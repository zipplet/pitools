#!/bin/sh
# sd_to_usb_boot - configure the Raspberry Pi to boot from USB media and move the current installation to USB media.
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi

SDBOOT="/boot"
NEWSDBOOT="/bootsd"
USBDEVICE="/dev/sda"
USBDEVICEPARTITION="${USBDEVICE}1"
USBDEVICE2="/dev/sdb"
TEMPMOUNT="/mnt/tempmount"
CONFIG="/boot/cmdline.txt"
CONFIGBACKUP="/boot/cmdline.txt.backup"
INSTALLMARK="sd_to_usb_boot"
INSTALLMARKFILE="${INSTALLMARKDIR}/${INSTALLMARK}"

# We must run as root
. $SCRIPT_CHECK_ROOT

. $SCRIPT_CHECK_IF_INSTALLED
if [ $INSTALLED -eq 1 ]; then
  echo "${RED}${INSTALLMARK} is already installed.${NC}"
  exit 1
fi

clear
echo "${BLUE}-------------------------------------${NC}"
echo "${CYAN}sd_to_usb_boot version 0.2 (20161014)${NC}"
echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
echo "${CYAN}Thanks to Adafruit for the idea.${NC}"
echo "${BLUE}-------------------------------------${NC}"

echo
echo "This should be safe, but please pay attention to the warnings below."
echo "No data (other than the kernel boot command line) is modified on the SD"
echo "card, and the kernel boot command line file is backed up. You should be"
echo "able to recover if this fails but no guarentees!"
echo
echo "${CYAN}This script and related tools are only intended for Raspbian."
echo "Usage of them on any other distribution/OS may lead to destruction.${NC}"
echo
echo "${GREEN}Before proceeding, please confirm the following:${NC}"
echo "${YELLOW}1) You have a backup of your current SD card.${NC}"
echo "${YELLOW}2) You have attached a SINGLE USB mass storage device to your Raspberry Pi.${NC}"
echo "(other non storage devices can remain attached, like keyboards, mice, etc)"
echo "${YELLOW}3) This USB device is not mounted anywhere.${NC}"
echo "${YELLOW}4) You do not mind losing ALL data on the USB device as it will be formatted.${NC}"
echo "${YELLOW}5) The USB device is at least as large as your SD card.${NC}"
echo "${YELLOW}6) You are running your Pi in console-only mode (no GUI) right now.${NC}"
echo "${YELLOW}7) Your Raspberry Pi is connected to a working Internet connection.${NC}"
echo "${YELLOW}8) No servers (webservers, etc) are running as it may lead to a bad transfer.${NC}"
echo
read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
echo
if [ ! "$ANSWER" = "y" ]; then
  echo "Aborting."
  exit 1
fi

if [ ! -e "$USBDEVICE" ]; then
  echo "${RED}Cannot find the USB device (looking for ${USBDEVICE})${NC}"
  exit 1
fi

if [ -e "$USBDEVICE2" ]; then
  echo "${RED}Multiple USB mass storage devices found${NC}"
  exit 1
fi

if [ ! -d "$SDBOOT" ]; then
  echo "${RED}Cannot find the SD card boot mount (looking for ${SDBOOT})${NC}"
  exit 1
fi

if grep -qs "$USBDEVICE" /proc/mounts; then
  echo "${RED}The USB device IS mounted somewhere. Dismount it and try again. See the list below.${NC}"
  echo ${YELLOW}
  mount | grep $USBDEVICE
  echo ${NC}
  exit 1
fi

if [ ! -d "files" ]; then
  echo "${RED}Cannot find the files directory. Change to the script directory before running it${NC}"
  exit 1
fi

if [ ! -f "files/rpi-usbroot" ]; then
  echo "${RED}Cannot find the rpi-usbroot tool. Change to the script directory before running it${NC}"
  exit 1
fi

if [ ! -f "files/rpi-usbbootsync" ]; then
  echo "${RED}Cannot find the rpi-usbbootsync tool. Change to the script directory before running it${NC}"
  exit 1
fi

echo "${GREEN}Sanity tests passed.${NC}"

# Warn the user if this might be destructive (device has a partition)
if [ -e "$USBDEVICEPARTITION" ]; then
  echo "${YELLOW}CAUTION: Found a valid partition on the USB device that might contain data.${NC}"
fi

echo ${RED}
echo "While running, interrupting this script may destroy ALL DATA!"
read -p "Are you sure, ALL DATA will be LOST on the USB device? (y/n) :" -r ANSWER
echo ${NC}
if [ ! "$ANSWER" = "y" ]; then
  echo "Aborting."
  exit 1
fi

echo "${BLUE}----------------------------------------------${NC}"
echo "${CYAN}Checking that necessary packages are installed${NC}"
echo "${BLUE}----------------------------------------------${NC}"
echo

echo "${YELLOW}This may take a while depending on your Internet connection speed"
echo "and Pi model - please be patient.${NC}"
echo "${GREEN}Updating the local package cache...${NC}"
if ! apt-get update > /dev/null; then
  echo "${RED}apt-get update failed${NC}"
  exit 1
fi

if ! dpkg-query -W -f='${Status}' rsync 2>/dev/null | grep -c "ok installed" > /dev/null; then
  echo "${GREEN}Need to install rsync, installing...${NC}"
  if ! apt-get install -y rsync > /dev/null; then
    echo "${RED}Failed to install rsync${NC}"
    exit 1
  fi
fi

if ! dpkg-query -W -f='${Status}' parted 2>/dev/null | grep -c "ok installed" > /dev/null; then
  echo "${GREEN}Need to install parted, installing...${NC}"
  if ! apt-get install -y parted > /dev/null; then
    echo "${RED}Failed to install parted${NC}"
    exit 1
  fi
fi

echo "${GREEN}All required packages are installed.${NC}"

echo
echo "${BLUE}------------------------${NC}"
echo "${CYAN}Preparing the USB device${NC}"
echo "${BLUE}------------------------${NC}"
echo
echo "${GREEN}Creating a partition table...${NC}"
if ! parted --script "${USBDEVICE}" mklabel msdos > /dev/null; then
  echo "${RED}Failed to create the partition table${NC}"
  echo "${GREEN}Do not panic; your SD card is still OK. Try wiping the USB device and running this script again.${NC}"
  exit 1
fi
echo "${GREEN}Creating the partition...${NC}"
if ! parted --script --align optimal "${USBDEVICE}" mkpart primary ext4 0% 100% > /dev/null; then
  echo "${RED}Failed to create the partition${NC}"
  echo "${GREEN}Do not panic; your SD card is still OK. Try wiping the USB device and running this script again.${NC}"
  exit 1
fi
echo "${GREEN}Formatting the partition (this may take a while)...${NC}"
if ! mkfs -t ext4 -L rootfs "${USBDEVICEPARTITION}" > /dev/null; then
  echo "${RED}Failed to format the partition${NC}"
  echo "${GREEN}Do not panic; your SD card is still OK. Try wiping the USB device and running this script again.${NC}"
  exit 1
fi

echo "${GREEN}Mounting the USB device...${NC}"
if [ ! -d "$TEMPMOUNT" ]; then
  mkdir $TEMPMOUNT
fi
if ! mount ${USBDEVICEPARTITION} ${TEMPMOUNT}; then
  echo "${RED}Failed to mount the partition${NC}"
  echo "${GREEN}Do not panic; your SD card is still OK. Try wiping the USB device and running this script again.${NC}"
  exit 1
fi
echo "${GREEN}USB device mounted and ready.${NC}"

echo
echo "${BLUE}-----------------------------------${NC}"
echo "${CYAN}Synchronizing data from the SD card${NC}"
echo "${BLUE}-----------------------------------${NC}"
echo
echo "${YELLOW}This will take a long time, please be patient.${NC}"
echo "Watch the activity LED on the USB device to confirm activity."
if ! rsync -ax / $TEMPMOUNT; then
  echo "${RED}Failed to synchronize data to the USB device${NC}"
  echo "${GREEN}Do not panic; your SD card is still OK. Try wiping the USB device and running this script again.${NC}"
  exit 1
fi
echo "${GREEN}Data transfer from SD to USB successful.${NC}"

echo
echo "${BLUE}-------------------------------------${NC}"
echo "${CYAN}Installing the tools to the USB media${NC}"
echo "${BLUE}-------------------------------------${NC}"
echo
echo "${GREEN}Installing rpi-usbroot...${NC}"
cp files/rpi-usbroot "${TEMPMOUNT}/usr/sbin/rpi-usbroot"
sed -i '/^exit 0/i rpi-usbroot' "${TEMPMOUNT}/etc/rc.local"
echo "${GREEN}Installing rpi-usbbootsync...${NC}"
cp files/rpi-usbbootsync "${TEMPMOUNT}/usr/sbin/rpi-usbbootsync"
echo "${GREEN}Tools installed to USB media.${NC}"

echo
echo "${BLUE}--------------------------${NC}"
echo "${CYAN}Making the system bootable${NC}"
echo "${BLUE}--------------------------${NC}"
echo
echo "${GREEN}Creating the mountpoints...${NC}"
mkdir "${TEMPMOUNT}${NEWSDBOOT}"

echo "${GREEN}Modifying the new fstab on the USB device...${NC}"
sed -i '/mmcblk0p2/s/^/#/' "${TEMPMOUNT}/etc/fstab"
sed -i "s${SDBOOT}${NEWSDBOOT}/g" "${TEMPMOUNT}/etc/fstab"
echo "${USBDEVICEPARTITION}	/	ext4	defaults,noatime	0	1" >> "${TEMPMOUNT}/etc/fstab"

echo "${GREEN}Backing up the current kernel boot configuration...${NC}"
cp $CONFIG $CONFIGBACKUP

echo "${GREEN}Modifying the kernel boot configuration...${NC}"
sed -i "s|root=\/dev\/mmcblk0p2|root=${USBDEVICEPARTITION} rootdelay=5|" $CONFIG

echo "${GREEN}Marking this tool as installed...${NC}"
# Normally we would do this:
# . $SCRIPT_MARK_AS_INSTALLED
# But we cannot as we want to mark the USB device not the SD card. So do it manually.
if [ ! -d "${TEMPMOUNT}${INSTALLMARKDIR}" ]; then
  mkdir "${TEMPMOUNT}${INSTALLMARKDIR}"
fi
date > "${TEMPMOUNT}${INSTALLMARKFILE}"

echo
echo "${GREEN}Dismounting the USB device...${NC}"
umount ${USBDEVICEPARTITION}
echo "${GREEN}Removing the temporary mountpount...${NC}"
rm -rf $TEMPMOUNT


echo
echo
echo "${CYAN}All finished.${NC}"
echo
echo "If your Pi does not boot properly, you can restore your old boot configuration."
echo "To do this, put the SD card into a card reader, delete ${CONFIG} and rename ${CONFIGBACKUP} to ${CONFIG}"
echo "No other files were modified on your SD card - all of the other changes were made to the new USB partition."
echo

. $SCRIPT_WANT_REBOOT
