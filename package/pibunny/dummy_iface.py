import asyncio


async def control_led(color, pattern):
    while True:
        # print(pattern.stages)
        for stage in pattern.stages:
            if stage[0]:
                print("setting to ", color)
            else:
                print("clearing")
            await asyncio.sleep(stage[1]/1000)
        if pattern.oneshot:
            return
