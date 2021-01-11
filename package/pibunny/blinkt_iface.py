import asyncio

import blinkt


async def control_led(color, pattern):
    while True:
        for stage in pattern.stages:
            if stage[0]:
                blinkt.set_pixel(7, *color)
            else:
                blinkt.set_pixel(7, 0, 0, 0)
            blinkt.show()
            await asyncio.sleep(stage[1]/1000)
        if pattern.oneshot:
            return
