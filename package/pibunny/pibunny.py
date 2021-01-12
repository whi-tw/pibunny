import sys
import time
import asyncio
import subprocess

import blinkt_iface as iface

last_color = None


class pattern:
    '''How a pattern is defined

    [s1, t1, s2, t2, oneshot]
    '''

    def __init__(self, *args, oneshot=False):
        if len(args) % 2 != 0 and len(args) > 1:
            print("fuuu")
            exit(1)
        elif len(args) == 1:
            args = (args[0], 1)
        self.oneshot = oneshot
        self.stages = []
        for i in range(0, len(args), 2):
            self.stages.append((args[i], args[i+1]))


PATTERNS = {
    # Default. No blink. Used if pattern argument is ommitted
    "SOLID": pattern(True, oneshot=True),

    # Symmetric 1000ms ON, 1000ms OFF, repeating
    "SLOW": pattern(True, 1000, False, 1000),
    # Symmetric 100ms ON, 100ms OFF, repeating
    "FAST": pattern(True, 100, False, 100),
    # Symmetric 10ms ON, 10ms OFF, repeating
    "VERYFAST": pattern(True, 10, False, 10),

    # 1 100ms blink(s) ON followed by 1 second OFF, repeating
    "SINGLE": pattern(True, 100, False, 1000),
    # 2 100ms blink(s) ON followed by 1 second OFF, repeating
    "DOUBLE": pattern(True, 100, False, 100,
                      True, 100, False, 1000),
    # 3 100ms blink(s) ON followed by 1 second OFF, repeating
    "TRIPLE": pattern(True, 100, False, 100,
                      True, 100, False, 100,
                      True, 100,  False, 1000),
    # 4 100ms blink(s) ON followed by 1 second OFF, repeating
    "QUAD": pattern(True, 100, False, 100,
                    True, 100, False, 100,
                    True, 100, False, 100,
                    True, 100, False, 1000),
    # 5 100ms blink(s) ON followed by 1 second OFF, repeating
    "QUIN": pattern(True, 100, False, 100,
                    True, 100, False, 100,
                    True, 100, False, 100,
                    True, 100, False, 100,
                    True, 100, False, 1000),
    "ISINGLE": [],  # 1 100ms blink(s) OFF followed by 1 second ON, repeating
    "IDOUBLE": [],  # 2 100ms blink(s) OFF followed by 1 second ON, repeating
    "ITRIPLE": [],  # 3 100ms blink(s) OFF followed by 1 second ON, repeating
    "IQUAD": [],  # 4 100ms blink(s) OFF followed by 1 second ON, repeating
    "IQUIN": [],  # 5 100ms blink(s) OFF followed by 1 second ON, repeating

    # 1000ms VERYFAST blink followed by SOLID
    "SUCCESS": pattern(True, 100, False, 100,
                       True, 100, False, 100,
                       True, 100, False, 100,
                       True, 100, False, 100,
                       True, 100, False, 100,
                       True, 1, oneshot=True),
    #           Custom value in ms for continuous symmetric blinking
}

STATES = {
    "SETUP": "M SOLID",         # Magenta solid

    "FAIL": "R SLOW",           # Red slow blink
    "FAIL1": "R SLOW",          # Red slow blink
    "FAIL2": "R FAST",          # Red fast blink
    "FAIL3": "R VERYFAST",      # Red very fast blink

    "ATTACK": "Y SINGLE",       # Yellow single blink
    "STAGE1": "Y SINGLE",       # Yellow single blink
    "STAGE2": "Y DOUBLE",       # Yellow double blink
    "STAGE3": "Y TRIPLE",       # Yellow triple blink
    "STAGE4": "Y QUAD",         # Yellow quadruple blink
    "STAGE5": "Y QUIN",         # Yellow quintuple blink

    "SPECIAL": "C ISINGLE",     # Cyan inverted single blink
    "SPECIAL1": "C ISINGLE",    # Cyan inverted single blink
    "SPECIAL2": "C IDOUBLE",    # Cyan inverted double blink
    "SPECIAL3": "C ITRIPLE",    # Cyan inverted triple blink
    "SPECIAL4": "C IQUAD",      # Cyan inverted quadriple blink
    "SPECIAL5": "C IQUIN",      # Cyan inverted quintuple blink

    "CLEANUP": "W FAST",        # White fast blink
    "FINISH": "G SUCCESS",      # Green 1000ms VERYFAST blink followed by SOLID

    "OFF": "",  # Turns the LED off
}

COLORS = {
    "R": (255, 0, 0),
    "G": (0, 255, 0),
    "B": (0, 0, 255),
    "Y": "R G",
    "C": "G B",
    "M": "R B",
    "W": "R G B"
}


def parse_color(colors: list):
    out = [0, 0, 0]
    for color in colors:
        rgb = None
        if type(COLORS[color]) == tuple:
            rgb = COLORS[color]
        else:  # must be a composite color
            rgb = parse_color(COLORS[color].split(" "))
        for i, v in enumerate(rgb):
            out[i] += v
            if out[i] > 255:
                out[i] = 255
    return out


def parse_pattern(patterns: list):
    try:
        return PATTERNS[patterns[0]]
    except IndexError:
        return PATTERNS["SOLID"]


def parse_args(args: str):
    args = args.split(" ")
    cargs = []
    sargs = []
    pargs = []
    for arg in args:
        if arg in COLORS:
            cargs.append(arg)
        elif arg in STATES:
            sargs.append(arg)
        elif arg in PATTERNS:
            pargs.append(arg)
    return cargs, sargs, pargs


def read_color():
    global last_color
    try:
        with open("/tmp/lastled", "r") as cfg:
            cfg = cfg.readline().strip()
    except FileNotFoundError:
        return False
    if cfg != last_color:
        last_color = cfg
        return cfg
    return False


current_task = None


async def main_loop(loop):
    while True:
        cfg = read_color()
        if cfg:
            print(cfg)
            try:
                current_task.cancel()
            except UnboundLocalError:
                pass

            ca, sa, pa = parse_args(cfg)

            if sa:
                ca, sa, pa = parse_args(STATES[sa[0]])
            color = parse_color(ca)
            pattern = parse_pattern(pa)
            current_task = loop.create_task(iface.control_led(color, pattern))

        await asyncio.sleep(0.1)


switch1 = True
script = "armingMode.sh"
if switch1:
    script = "/opt/pibunny/switch1.sh"


subprocess.run(["/bin/bash", script])

loop = asyncio.get_event_loop()
loop.create_task(main_loop(loop))
loop.run_forever()
