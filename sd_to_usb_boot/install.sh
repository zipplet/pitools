#!/bin/sh

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

SDBOOT="/boot"
NEWSDBOOT="/bootsd"
USBDEVICE="/dev/sda"
USBDEVICEPARTITION="${USBDEVICE}1"
USBDEVICE2="/dev/sdb"
TEMPMOUNT="/mnt/tempmount"

# We must run as root
if [ "$(id -u)" != "0" ]; then
   echo "${RED}Please run this installer as root${NC}" 1>&2
   exit 1
fi

clear
echo "${BLUE}-------------------------------------${NC}"
echo "${CYAN}sd_to_usb_boot version 0.1 (20161010)${NC}"
echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
echo "${CYAN}Thanks to Adafruit for the idea.${NC}"
echo "${BLUE}-------------------------------------${NC}"

echo

echo "${GREEN}Before proceeding, please confirm the following:${NC}"
echo "${YELLOW}1) You have a backup of your current SD card.${NC}"
echo "${YELLOW}2) You have attached a SINGLE USB mass storage device to your Raspberry Pi.${NC}"
echo "(other non storage devices can remain attached, like keyboards, mice, etc)"
echo "${YELLOW}3) This USB device is not mounted anywhere.${NC}"
echo "${YELLOW}4) You do not mind losing ALL data on the USB device.${NC}"
echo "${YELLOW}5) The USB device is at least as large as your SD card.${NC}"
echo "${YELLOW}6) You are OK with losing all data on your SD card and USB device if this goes wrong.${NC}"
echo "${YELLOW}7) You are running your Pi in console-only mode (no GUI) right now.${NC}"
echo "${YELLOW}8) Your Raspberry Pi is connected to a working Internet connection.${NC}"
echo
read -p "Have you read, confirmed and understand all of the above? (y/n) :" -r ANSWER
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

if [ -d "$NEWSDBOOT" ]; then
  echo "${RED}This Pi has already had this tool run on it before${NC}"
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

echo "${BLUE}---------------------------------------------------${NC}"
echo "${CYAN}Making sure required packages we need are installed${NC}"
echo "${BLUE}---------------------------------------------------${NC}"
echo
echo "${YELLOW}This may take a while depending on your Internet connection speed"
echo "and Pi model - please be patient.${NC}"
echo "${GREEN}Updating the local package cache...${NC}"
if ! apt-get update > /dev/null; then
  echo "${RED}apt-get update failed${NC}"
  exit 1
fi
if ! dpkg -s rsync > /dev/null 2>&1; then
  echo "${GREEN}Need to install rsync, installing...${NC}"
  if ! apt-get install -y rsync > /dev/null; then
    echo "${RED}Failed to install rsync${NC}"
    exit 1
  fi
fi
if ! dpkg -s parted > /dev/null 2>&1; then
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
if ! parted --script "${USBDEVICE}" mklabel mbr; then
  echo "${RED}Failed to create the partition table${NC}"
  echo "${GREEN}Do not panic; your SD card is still OK. Try wiping the USB device and running this script again.${NC}"
  exit 1
fi
echo "${GREEN}Creating the data partition...${NC}"
if ! parted --script --align optimal "${USBDEVICE}" mkpart primary ext4 0% 100%; then
  echo "${RED}Failed to create the partition${NC}"
  echo "${GREEN}Do not panic; your SD card is still OK. Try wiping the USB device and running this script again.${NC}"
  exit 1
fi
echo "${GREEN}Formatting the data partition...${NC}"
if ! mkfs -t ext4 -L rootfs "${USBDEVICEPARTITION}"; then
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
echo "${BLUE}-----------------------------${NC}"
echo "${CYAN}Copying data from the SD card${NC}"
echo "${BLUE}-----------------------------${NC}"
echo
echo "${YELLOW}This will take a long time, please be patient.${NC}"
echo "Watch the activity LEDs on the USB device to confirm this is progressing."
if ! rsync -ax / $TEMPMOUNT; then
  echo "${RED}Failed to synchronize data to the USB device${NC}"
  echo "${GREEN}Do not panic; your SD card is still OK. Try wiping the USB device and running this script again.${NC}"
  exit 1
fi
echo "${GREEN}Data transfer from SD to USB successful.${NC}"
