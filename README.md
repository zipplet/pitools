# pitools
Tools for doing various things with Raspberry Pi's. All of these target Raspbian unless mentioned otherwise.

Please see the documentation for each individual tool, do not blindly use them as some may damage data if used incorrectly or cause unwanted side effects. Here is a list of all the tools/directories and what they do.

These tools maintain a list of which ones have been installed under **/pitools** as some have dependencies on others, and I did not want to go with the hassle of making debian packages. Where this is the case, the readme for each tool explains this.

## Supported models

* Revision is that reported by **/proc/cpuinfo**
* Just because it has not been tested, it does not mean it will not work.
* Please see the notes under the table for more information.
* Anything marked as **Tested by me** means that I have that exact hardware revision and have performed testing myself.

Revision | Pi model | RAM | Supported | Tested | Released | Notes |
-------- | -------- | --- | --------- | ------ | -------- | ----- |
Beta | Pi 1 Model B | 256MB | ? | No | 2012 Q1 | Beta board
0002 | Pi 1 Model B | 256MB | Yes | No | 2012 Q1 | First public board
0003 | Pi 1 Model B | 256MB | Yes | No | 2012 Q3 | Another beta board?
0004 | Pi 1 Model B | 256MB | Yes | No | 2012 Q3 |
0005 | Pi 1 Model B | 256MB | Yes | No | 2012 Q4 |
0006 | Pi 1 Model B | 256MB | Yes | No | 2012 Q4 |
0007 | Pi 1 Model A | 256MB | Yes | No | 2013 Q1 |
0008 | Pi 1 Model A | 256MB | Yes | No | 2013 Q1 |
0009 | Pi 1 Model A | 256MB | Yes | No | 2013 Q1 |
000d | Pi 1 Model B | 512MB | Yes | No | 2012 Q4 |
000e | Pi 1 Model B | 512MB | Yes | No | 2012 Q4 |
000f | Pi 1 Model B | 512MB | Yes | No | 2014 Q3 |
0010 | Pi 1 Model B+ | 512MB | Yes | **Yes** | 2014 Q3 | **Tested by me**
0011 | Compute Module | 512MB | ? | No | 2014 Q2 | See **note 1**
0012 | Pi 1 Model A+ | 256MB | Yes | No | 2014 Q4 |
0013 | Pi 1 Model B+ | 512MB | Yes | No | 2015 Q1 | Last Pi 1 Model B+?
0014 | Compute Module | 512MB | ? | No | 2014 Q2 | See **note 1**
0015 | Pi 1 Model A+ | Note 3 | ? | No | ? |
a01040 | Pi 2 Model B | 1GB | Yes | No | ? | See **note 2**
a01041 | Pi 2 Model B | 1GB | Yes | No | 2015 Q1 | See **note 2**
a21041 | Pi 2 Model B | 1GB | Yes | No | 2015 Q1 | See **note 2**
a22042 | Pi 2 Model B (BCM2837) | 1GB | Yes | No | 2016 Q3 | See **note 2** - Last Pi 2 Model B?
900092 | Pi Zero | 512MB | ? | No | 2015 Q4 |
900093 | Pi Zero | 512MB | ? | No | 2016 Q2 |
920093 | Pi Zero | 512MB | ? | No | 2016 Q4? | Release date uncertain
a02082 | Pi 3 Model B | 1GB | ? | No | 2016 Q1 | Coming soon
a22082 | Pi 3 Model B | 1GB | ? | No | 2016 Q1 | Coming soon

* Note 1: **I really need help testing this stuff on a compute module;** please perform extensive testing and let me know the results, or a donation of a compute module with breakout board would be **greatly appreciated** (and also be added to my build farm for freepascal compilation of other projects, such as my upcoming game library port for Raspberry Pi and associated games). In Japan, it is difficult to get hold of these without a credit card.
* Note 2: I have a Raspberry Pi Model 2 B, but I have not checked the board revision. I will update this table once I have.
* Note 3: Revision 0015 comes with either 256MB or 512MB of RAM installed.

## sd_to_usb_boot

* Copies your existing Raspberry Pi installation from the SD card to an attached USB device, and configures it to run from the USB device rather than the SD card. The SD card is still required to load the initial kernel, but you are free to use the old Linux partition on the SD card for something else afterwards. (The FAT32 boot partition must be left alone)
* The SD card is completely unmounted after the machine has booted (and in theory could even be be pulled out but I do not recommend doing so just in case)
* The /boot partition from the SD card is kept in sync with a "virtual" /boot partition on the USB media, and a tool is included to sync the virtual /boot partition back to the SD card if modify it from the Pi itself (it will remount the real /boot from the SD card and sync back)
* This is an alternative to using the new "alpha" USB boot support on the Pi 3 (which is apparently not very reliable and does not work with many USB devices).

## fpc_3_builder

* Uses a bootstrap compiler to compile the freepascal v3.0.0 source code, installs it and sets it as your default freepascal compiler.
* The bootstrap compiler and freepascal v3.0.0 source code are supplied in this repository (that is why git clone is slow!)
* You need at a Pi model with at least 512MB of RAM.

## autologin

* Creates a new user account on your Pi called autologin, and configures it to automatically login to it on boot.

## simplestatus

* A demo script to run inside the autologin account, with installer.
* It displays the CPU temperature, RAM usage, CPU load and current IP addresses.
* Useful for Pi's with tiny LCD displays.

## gpio_soft_poweroff

* Initiates a controlled shutdown of your Raspberry Pi if GPIO pin 21 is connected to ground via a button.
* On a modern Pi with a 40 pin GPIO connector, connect a button between pins 39 and 40. No resistor is necessary.
* Logs shutdowns to /var/log/manual_shutdown.log
* **Make sure you connect the button between the correct GPIO pins!**
* Based on https://www.element14.com/community/docs/DOC-78055/l/adding-a-shutdown-button-to-the-raspberry-pi-b

## ds3231_setup

* Configures your Raspberry Pi to use a DS3231 RTC module properly
* Yes, even with systemd and ntpd - it "just works"

## usb_current_boost

* Configures your Raspberry Pi to provide the maximum possible power from the USB ports.
* Make sure you have a beefy PSU!

## no_swap

* Disables the swapfile on your Raspberry Pi.

## rpi_model

* Tells you detailed information about your Raspberry Pi model.

## common

* Common scripts used by other tools, don't run these directly.
