import machine


def deep_sleep(msecs):
    # configure RTC.ALARM0 to be able to wake the device
    rtc = machine.RTC()
    rtc.irq(trigger=rtc.ALARM0, wake=machine.DEEPSLEEP)

    # set RTC.ALARM0 to fire after msecs milliseconds, waking the device
    rtc.alarm(rtc.ALARM0, msecs)

    # put the device to sleep
    machine.deepsleep()
