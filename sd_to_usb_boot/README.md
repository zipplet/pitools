# sd_to_usb_boot

Inspired by: https://learn.adafruit.com/external-drive-as-raspberry-pi-root/

## Status

**Stable; ready for use.**

**BIG WARNING:** After updating your Raspberry Pi (apt-get), you need to run **rpi-usbbootsync** or the new kernel files/etc are not copied from the virtual /boot to the real SD card /boot partition. This could cause strange things to happen - at best you will be running an old kernel forever; at worst your Pi will become unbootable. I will fix this at some point (not sure how yet; possibly by redirecting apt-get/dpkg/aptitude to a script that sets a flag saying a sync is required, then on shutdown look for this flag and if it is present, invoke rpi-usbbootsync and clear the flag).

**This also applies if you run raspi-config** - run **rpi-usbbootsync** after or your changes will be overridden by the ones on the SD card. **This behaviour is by design** - it allows you to fix screwups by editing the SD card with a computer that cannot read a linux filesystem on your USB device.

**SMALLER WARNING:** Plugging in USB devices like network adaptors while you are booting from a USB device may cause the USB storage device to malfunction (you will see lots of kernel error messages and your Pi will stop working properly until rebooted), possibly due to a kernel bug. I recommend having all USB devices you plan to use plugged in before powering up the Pi if you boot from USB. USB network adaptors in particular exhibit this issue. I confirmed that if you plug in the network adaptors (I tested an ethernet and wi-fi one) before connecting power, it works fine - proof:

```
root@testpi:/home/pi# ifconfig
eth0      Link encap:Ethernet  HWaddr b8:27:eb:9a:02:9c <-- Built in NIC
          inet addr:192.168.100.40  Bcast:192.168.255.255  Mask:255.255.0.0
          inet6 addr: fe80::5d2f:6068:e825:df5f/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:199 errors:0 dropped:0 overruns:0 frame:0
          TX packets:109 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:33839 (33.0 KiB)  TX bytes:17341 (16.9 KiB)

eth1      Link encap:Ethernet  HWaddr 34:95:db:2c:5a:04 <-- this is the second NIC! Cable unplugged at the moment
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:457 errors:0 dropped:0 overruns:0 frame:0
          TX packets:466 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:68807 (67.1 KiB)  TX bytes:94642 (92.4 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:214 errors:0 dropped:0 overruns:0 frame:0
          TX packets:214 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1
          RX bytes:19828 (19.3 KiB)  TX bytes:19828 (19.3 KiB)
          
root@testpi:/home/pi# mount
/dev/sda1 on / type ext4 (rw,noatime,data=ordered) <-- booted from USB!
<rest snipped>
```

## What is this?

This is an automated tool to make your Raspberry Pi run the OS from any USB device. Simply insert a USB device, boot your Pi into console only mode and run the install script, sit back and relax!

Your SD card is still needed to start the boot process, but once the kernel is loaded control is passed over to the USB device. An additional pair of tools are installed to keep the SD card /boot partition in sync with a virtual /boot partition on the USB media for compatibility and ease of use.

Once you are happy with the conversion you may reuse the old OS partition on the SD card for something else, or get a smaller SD card (even as small as 128MB would be fine), format it as FAT32, move your /boot partition to it and use that!

## How do I use it?

git clone this repo, change to the sd_to_usb_boot directory and then run:
```
sudo ./install.sh
```

Make sure you read all of the warnings and follow the instructions. Take backups first!

## Is there not official USB boot support on the Pi 3?

Yes there is official USB boot support on the Pi 3 (I have not tested that myself) however it has issues with many devices according to the Raspberry Pi Foundation.

##  Why would I use this?

Your Pi should operate much more quickly from a USB device if you pick a good one, especially a small, cheap USB solid state disk. Even a cheap but reasonable quality 16GB USB flash drive is faster than a UHS-1 SD card in my testing. Also, wear levelling algorithyms may be better. You could also use a hard disk (you will probably need a VERY beefy power supply for the Pi or a powered USB hub).

This script is almost guarenteed to work as the original kernel still boots from the SD card, but it is then told to use the USB device as the root file system. It also works with any Raspberry Pi. The only negative thing is the requirement for an SD card of some kind to be left inserted - but once the Pi has finished booting, the card is UNTOUCHED and unmounted (you can even pull it out, although I would not recommend it).

The only other downside is that because I want the SD card completely dismounted during operation, /boot must be dismounted. To make things painless (allow software that demands that /boot is mounted to work, allow editing cmdline.txt during use etc), the Pi will synchronise the contents of the SD card /boot partition with a virtual /boot on the USB device during the boot sequence (this takes <1 second) then dismount the SD card. You are then editing a virtual /boot partition. This can be synchronised on demand back to the SD card by running the rpi-usbbootsync tool.

A positive point is that because the SD card /boot partition takes precedence, so if things get screwed up you can fix things the old fashioned way. Stick the SD card in a card reader and edit files as necessary, and they will synchronise back to the virtual /boot partition on the next boot.

## What are the installed tools, and how do I use them?

### rpi-usbroot

This script runs at every boot (currently via /etc/rc.local), and performs the following actions:

* Synchronises the SD card boot partition to the virtual boot partition on the USB media. (If the virtual boot partition has been deleted by accident, it recreates it)
* Completely dismounts the SD card after that to avoid SD card corruption, even during power loss.

It should never be executed manually.

### rpi-usbbootsync

This script synchronises any changes made to the virtual /boot partition on the USB media back to the SD card on demand.

* Run it as root - **sudo rpi-usbbootsync**
* Use it if you make changes to a file like config.txt, use apt-get to update your Pi or have used raspi-config to change settings. **If you do not, they will be wiped when you reboot**. This behaviour is by design to allow you to recover from mistakes (how? insert the SD card into another computer and edit files as necessary, then put it back into the Pi - your changes will then override the ones on the virtual /boot partition and be copied to it)

**Note that all of my tools in the pitools repo automatically run rpi-usbbootsync if they make changes to the /boot virtual partition, if sd_to_usb_boot is installed.**

### rpi-usbtoolsupdate

**Coming soon**

### rpi-usbrevertboot

**Coming soon**
