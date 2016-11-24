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

## Important note about the drift file

**I might automate this later as part of the rtc-fixclock tool**

After the final reboot, please **wait for 15-30 minutes** so that ntpd can create a new drift file (you need a working Internet connection during the entire time). You can verify if this has occured or not, by running this:

```
ls /var/lib/ntp/
```

If you see nothing, you need to wait a little longer. Once the initial drift file has been created, run this to check that ntpd is working properly:

```
root@testpi:/home/zipplet# ntpq -p
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
*ntp1.jst.mfeed. 133.243.236.17   2 u   64   64   17    3.820   -1.929   1.343
 ntp2.jst.mfeed. 133.243.236.17   2 u   56   64   17    3.861   -1.736   1.266
 ntp3.jst.mfeed. 133.243.236.17   2 u   64   64   17    5.718   -2.486   1.344
```

One server should be marked with an asterisk, in my case the first one. That means ntp is using it as the master server for clock correction. Now, just wait until the driftfile is created. If you see no servers with an asterisk, wait 5 minutes and try again.

## Tips

Now that you have a real RTC, once you have confirmed it is working (you have set the initial time using **sudo rtc-fixclock** and rebooted) you should edit **/etc/ntp.conf** and replace the list of NTP servers with ones closer to your location. For example:

**Before:**
```
server 0.debian.pool.ntp.org iburst
server 1.debian.pool.ntp.org iburst
server 2.debian.pool.ntp.org iburst
server 3.debian.pool.ntp.org iburst
```

**After:** (I am in Japan, so I used these - but you could use the NTP pool project)
```
server ntp1.jst.mfeed.ad.jp iburst
server ntp2.jst.mfeed.ad.jp iburst
server ntp3.jst.mfeed.ad.jp iburst
```

I recommend keeping iburst, and using at least 3 servers. If you have multiple Pi's, put a DS3231 on a single Pi (call it your Master) and connect it to your network via Ethernet. Pick some good NTP servers, maybe even as many as 5. Then configure all of your other Pi's to sync to that Pi - rather than straining the limited capacity of NTP servers available on the Internet.

This also means you do not need to fit a DS3231 or similar to every Pi - even if your Internet is down, they can synchronise with your master Pi that has a hardware RTC and will maintain (reasonable) time even if power cycled.
