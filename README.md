# pitools
Tools for doing various things with Raspberry Pi's. All of these target Raspbian unless mentioned otherwise.

Please see the documentation for each individual tool, do not blindly use them as some may damage data if used incorrectly or cause unwanted side effects. Here is a list of all the tools/directories and what they do.

These tools maintain a list of which ones have been installed under **/pitools** as some have dependencies on others, and I did not want to go with the hassle of making debian packages. Where this is the case, the readme for each tool explains this.

## Supported models

* Revision is that reported by **/proc/cpuinfo**
* Just because it has not been tested, it does not mean it will not work.
* Please see the notes under the table for more information.
* Anything marked as **Tested by me** means that I have that exact hardware revision and have performed testing myself.

Pi model | RAM | Supported | Tested | Notes |
-------- | --- | --------- | ------ | ----- |
Pi Zero | 512MB | Yes | Yes | **Tested by me**
Pi 1 Model A | 256MB | Yes | No |
Pi 1 Model A+ | 256MB | Yes | No |
Pi 1 Model B | 256MB | Yes | No | 256MB Model B?
Pi 1 Model B | 512MB | Yes | No |
Pi 1 Model B+ | 512MB | Yes | Yes | **Tested by me**
Compute Module | 512MB | ? | No | **Please see note**
Pi 2 Model B | 1GB | Yes | Yes | **Tested by me**
Pi 3 Model B | 1GB | Yes | Yes | **Tested by me**

Note: **I really need help testing this stuff on a compute module;** please perform extensive testing and let me know the results, or a donation of a compute module with breakout board would be **greatly appreciated** (and also be added to my build farm for freepascal compilation of other projects, such as my upcoming game library port for Raspberry Pi and associated games). In Japan, it is difficult to get hold of these without a credit card.

## sd_to_usb_boot

* Copies your existing Raspberry Pi installation from the SD card to an attached USB device, and configures it to run from the USB device rather than the SD card. The SD card is still required to load the initial kernel, but you are free to use the old Linux partition on the SD card for something else afterwards. (The FAT32 boot partition must be left alone)
* The SD card is completely unmounted after the machine has booted (and in theory could even be be pulled out but I do not recommend doing so just in case)
* The /boot partition from the SD card is kept in sync with a "virtual" /boot partition on the USB media, and a tool is included to sync the virtual /boot partition back to the SD card if modify it from the Pi itself (it will remount the real /boot from the SD card and sync back)
* This is an alternative to using the new "alpha" USB boot support on the Pi 3 (which is apparently not very reliable and does not work with many USB devices).

## fpc_3_builder

* Uses a bootstrap compiler to compile the freepascal v3.0.0 source code, installs it and sets it as your default freepascal compiler.
* The bootstrap compiler and freepascal v3.0.0 source code are supplied in this repository (that is why git clone is slow!)
* You need at a Pi model with at least 512MB of RAM.
* __An internet connection is not required during the installation as all of the required files are supplied in this repository.__

## autologin

* Creates a new user account on your Pi called autologin, and configures it to automatically login to it on boot.

## simplestatus

* A demo script to run inside the autologin account, with installer.
* It displays the CPU temperature, RAM usage, CPU load and current IP addresses.
* Useful for Pi's with tiny LCD displays.

## gpio_soft_poweroff

* Initiates a controlled shutdown of your Raspberry Pi if GPIO pin 21 is connected to ground via a button.
* On a modern Pi with a 40 pin GPIO connector, connect a button and 10K resistor between pins 39 and 40.
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

## pi3_disable_bt

* Disables the Bluetooth controller on the Raspberry Pi 3
* This also means GPIO 14 and 15 can be used as a real hardware serial port again (UART0 / ttyAMA0)
* The bluetooth service is also disabled.

## pi3_disable_wifi

* Disables the Wi-fi controller on the Raspberry Pi 3

## logs_to_ram

* Moves /tmp and /var/log to a small RAM disk
* /var/log will have all archived *.gz files flushed hourly

## common

* Common scripts used by other tools, don't run these directly.

# Todo list

* Add uninstallers for all tools
* Disallow tools like pi3_disable_bt from being installed if the config.txt file has already been manually modified
* Make all tools support --quiet
* Add a "recommended provisioning" tool
* For usb_current_boost, disallow Pi 3.
* For logs_to_ram, expire old /tmp files and refuse installation on models with 256MB of RAM, and throw an extra warning up for models with 512MB of RAM
