# sd_to_usb_boot

Inspired by: https://learn.adafruit.com/external-drive-as-raspberry-pi-root/

## What is this?

This is an automated tool to make your Raspberry Pi run the OS from any USB device. Simply insert a USB device, boot your Pi into console only mode and run the install script, sit back and relax!

Your SD card is still needed to start the boot process, but once the kernel is loaded control is passed over to the USB device. An additional pair of tools are installed to keep the SD card /boot partition in sync with a virtual /boot partition on the USB media for compatibility and ease of use.

## How do I use it?

git clone this repo, change to the sd_to_usb_boot directory and then run:
```
sudo ./install.sh
```

Make sure you read all of the warnings and follow the instructions. Take backups first!
