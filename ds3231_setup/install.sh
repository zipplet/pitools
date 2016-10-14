#!/bin/sh

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

INSTALLMARKDIR="/pitools"
INSTALLMARK="ds3231_setup"
INSTALLMARKFILE="${INSTALLMARKDIR}/${INSTALLMARK}"
CURRENTDATE=$(date)
CONFIGFILE="/boot/config.txt"

# We must run as root
if [ "$(id -u)" != "0" ]; then
   echo "${RED}Please run this installer as root${NC}" 1>&2
   exit 1
fi

if [ -e "$INSTALLMARKFILE" ]; then
  echo "${RED}${INSTALLMARK} is already installed.${NC}"
  exit 1
fi

clear
echo "${BLUE}-----------------------------------${NC}"
echo "${CYAN}ds3231_setup version 0.1 (20161014)${NC}"
echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
echo "${BLUE}-----------------------------------${NC}"

echo
echo "${GREEN}Before proceeding, please confirm the following:${NC}"
echo "${YELLOW}1) This script assumes you have connected a ${CYAN}DS3231${YELLOW} based RTC to your Raspberry Pi.${NC}"
echo "${YELLOW}2) Your Raspberry Pi clock must be correct before proceeding any further.${NC}"
echo
echo "${GREEN}The current date and time is ${CURRENTDATE}, if this is wrong stop and fix that first!${NC}"
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

cp files/start.sh /home/autologin
cp files/display_stats.sh /home/autologin
chown autologin:autologin /home/autologin/start.sh
chown autologin:autologin /home/autologin/display_stats.sh
echo "" >> /home/autologin/.profile
echo "# Start simple system status display" >> /home/autologin/.profile
echo "./start.sh" >> /home/autologin/.profile

echo "${GREEN}All done. Reboot your Pi and give it a try.${NC}"
echo "${YELLOW}To undo this, remove ${CYAN}./start.sh${YELLOW} from ${CYAN}/home/autologin/.profile${NC}"

echo "${GREEN}"
read -p "Would you like to reboot your Raspberry Pi now? (y/n) :" -r ANSWER
echo "${NC}"
if [ ! "$ANSWER" = "y" ]; then
  echo "Aborting."
  exit 1
fi

# Reboot
reboot
