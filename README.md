# pitools
Tools for doing various things with Raspberry Pi's. All of these target Raspbian unless mentioned otherwise.

Please see the documentation for each individual tool, do not blindly use them as some may damage data if used incorrectly or cause unwanted side effects.

## sd_to_usb_boot

* Copies your existing Raspberry Pi installation from the SD card to an attached USB device, and configures it to run from the USB device rather than the SD card. The SD card is still required to load the initial kernel, but you are free to use the old Linux partition on the SD card for something else afterwards. (The FAT32 boot partition must be left alone)
* The SD card is completely unmounted after the machine has booted and can be pulled out if you desire, without any consequences.
* The /boot partition from the SD card is kept in sync with a "virtual" /boot partition on the USB media, and a tool is included to sync the virtual /boot partition back to the SD card if modify it from the Pi itself (it will remount the real /boot from the SD card and sync back)
* This is an alternative to using the new "alpha" USB boot support on the Pi 3 (which is apparently not very reliable and does not work with many USB devices).

## fpc_3_builder

** Coming soon **
* Downloads a bootstrap compiler, then downloads the freepascal v3.0.0 source code, compiles it, installs it and sets it as your default freepascal compiler.
* Raspberry Pi 1 B+ and Pi 2 B supported.

## autologin

* Creates a new user account on your Pi called autologin, and configures it to automatically login to it on boot.

## simplestatus

* A demo script to run inside the autologin account, with installer.
* It displays the CPU temperature, RAM usage, CPU load and current IP addresses.
* Useful for Pi's with tiny LCD displays.
