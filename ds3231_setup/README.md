# ds3231_setup

Configures your Raspberry Pi to use a DS3231 RTC module properly.
Credit goes to marcus15 ( https://www.raspberrypi.org/forums/viewtopic.php?p=692662 )

## Status

**Stable; ready for use but with care.**

## How do I install this?

* Turn off your Raspberry Pi first ;)
* Plug in your RTC module (it must be a DS3231 i2c bus module!)
* Make sure i2c is enabled - run **sudo raspi-config** and check. If it was not enabled, enable it and reboot.
* Run **install.sh** as root.
* Reboot.
* Run **sudo rtc-fixclock** once ntpd has set the clock.
* Reboot again.
* Done!

## Can I uninstall this?

Not yet (by hand only right now).