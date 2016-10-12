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
echo "${BLUE}-----------------------------------${NC}"
echo "${CYAN}simplestatus version 0.1 (20161012)${NC}"
echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
echo "${BLUE}-----------------------------------${NC}"

echo "${YELLOW}1) This script assumes you already have an account called ${CYAN}autologin.${NC}"
echo "${YELLOW}2) A simple demo script that displays useful system stats will be run at login.${NC}"
echo "${YELLOW}3) You can stop the script at any time with Ctrl+C.${NC}"
echo
read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
echo
if [ ! "$ANSWER" = "y" ]; then
  echo "Aborting."
  exit 1
fi

if [ ! -d "/home/autologin" ]; then
  echo "${RED}There is no autologin account (/home/autologin)!${NC}"
  exit 1
fi

if [ ! -e "files/start.sh" ]; then
  echo "${RED}Cannot find files/start.sh - Run this script from its own directory!${NC}"
  exit 1
fi

if [ ! -e "files/display_stats.sh" ]; then
  echo "${RED}Cannot find files/display_stats.sh - Run this script from its own directory!${NC}"
  exit 1
fi

cp files/* /home/autologin
echo "./start.sh" >> /home/autologin/.profile

echo "${GREEN}All done. Reboot your Pi and give it a try.${NC}"
echo "${YELLOW}To undo this, remove ${CYAN}./start.sh${YELLOW} from ${CYAN}/home/autologin/.profile${NC}"
