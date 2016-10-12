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
CONFIG="/boot/cmdline.txt"
CONFIGBACKUP="/boot/cmdline.txt.backup"

# We must run as root
if [ "$(id -u)" != "0" ]; then
   echo "${RED}Please run this installer as root${NC}" 1>&2
   exit 1
fi

clear
echo "${BLUE}-----------------------------------------${NC}"
echo "${CYAN}gpio_soft_poweroff version 0.1 (20161010)${NC}"
echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
echo "${CYAN}Thanks to Inderpreet Singh the script.${NC}"
echo "${BLUE}-----------------------------------------${NC}"

echo "${GREEN}Before proceeding, please confirm the following:${NC}"
echo "${YELLOW}1) You are familiar with using GPIO pins safely so you will not damage your Pi.${NC}"
echo "${YELLOW}2) You have a modern Pi with a 40 pin GPIO connector.${NC}"
echo "${YELLOW}3) You understand the GPIO pin numbering.${NC}"
echo 'https://www.element14.com/community/docs/DOC-78055/l/adding-a-shutdown-button-to-the-raspberry-pi-b may be useful'
echo
read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
echo
if [ ! "$ANSWER" = "y" ]; then
  echo "Aborting."
  exit 1
fi

if [ ! -e "files/shutdown_button.py" ]; then
  echo "${RED}Cannot find files/shutdown_button.py - please run this script from its own directory${NC}"
  exit 1
fi

echo "${GREEN}Setting things up...${NC}"
cp files/shutdown_button.py /usr/sbin
sed -i '/^exit 0/i /usr/sbin/shutdown_button.py &' "/etc/rc.local"
echo "${GREEN}All done.${NC}"
echo "You can test this after rebooting by briefly shorting pins 39 and 40 with a jumper (make sure you understand the pin numbering before doing this or ${CYAN}you might destroy your Pi!${NC}"

echo "${GREEN}"
read -p "Would you like to reboot your Raspberry Pi now? (y/n) :" -r ANSWER
echo "${NC}"
if [ ! "$ANSWER" = "y" ]; then
  echo "Aborting."
  exit 1
fi

# Reboot
reboot
