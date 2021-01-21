try:
    import RPi.GPIO
except (RuntimeError, ModuleNotFoundError):
    from fake_rpigpio import RPi

pins = [13,16,20,19]

RPi.GPIO.setup(pins, RPi.GPIO.IN, pull_up_down=RPi.GPIO.PUD_UP)


dec = int("".join([str(int(RPi.GPIO.input(pin))) for pin in pins]),2)

print(dec)
