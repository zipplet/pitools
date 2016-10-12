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
echo "${BLUE}---------------------------------${NC}"
echo "${CYAN}autologin version 0.1 (20161012)${NC}"
echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
echo "${BLUE}---------------------------------${NC}"

echo
echo "${RED}This script is designed for modern versions of Raspbian only that use systemd.${NC}"
echo
echo "${YELLOW}1) A new user account called ${CYAN}autologin${ELLOW} will be created.${NC}"
echo "${YELLOW}2) Your Raspberry Pi will automatically login to this account on startup.${NC}"
echo
read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
echo
if [ ! "$ANSWER" = "y" ]; then
  echo "Aborting."
  exit 1
fi

echo "${YELLOW}This script will configure your Pi to autologin at startup with a new"
echo "user account that we will create now, called ${CYAN}autologin${NC}."
echo
echo "If you want this account to start a program after logging in, edit the file"
echo "${CYAN}~/.profile${NC} in the ${CYAN}/home/autologin${NC} directory after."
echo
echo "${CYAN}Creating the new account. You can use any password you want, but do not"
echo "forget it incase you need it later.${NC}"
echo
adduser autologin
echo

if [ ! -d "/home/autologin" ]; then
  echo "${RED}Cannot find the home directory for the new user. Something went wrong.${NC}"
  exit 1
fi

cp files/autologin\@.service /etc/systemd/system/autologin\@.service
rm /etc/systemd/system/getty.target.wants/getty@tty1.service
ln -s /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service

echo "${GREEN}All done. Your Pi will auto-login with the ${CYAN}autologin${GREEN} account now.${NC}"
echo "${YELLOW}To undo this, run ${CYAN}undo.sh${NC} at any time."
