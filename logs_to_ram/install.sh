#!/bin/sh
# Move /var/log and /tmp to a small RAM disk to extend SD card life
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi

INSTALLMARK="logs_to_ram"
INSTALLMARKFILE="${INSTALLMARKDIR}/${INSTALLMARK}"

# We must run as root
. $SCRIPT_CHECK_ROOT

. $SCRIPT_CHECK_IF_INSTALLED
if [ $INSTALLED -eq 1 ]; then
  echo "${RED}${INSTALLMARK} is already installed.${NC}"
  exit 1
fi

. $SCRIPT_IS_SILENT

if [ "$IS_SILENT" = "0" ]; then
  clear
  echo "${BLUE}----------------------------------${NC}"
  echo "${CYAN}logs_to_ram version 0.1 (20161124)${NC}"
  echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
  echo "${BLUE}----------------------------------${NC}"

  echo
  echo "${GREEN}Before proceeding, please confirm the following:${NC}"
  echo "${YELLOW}1) This should only really be used on a Pi with 1GB of RAM.${NC}"
  echo "${YELLOW}2) If you use this on a Pi with 512MB of RAM, it will work but it is only recommended in a non GUI environment.${NC}"
  echo "${YELLOW}3) All logs and temporary files are lost at reboot.${NC}"
  echo "${YELLOW}4) Any log archives (.gz files) are deleted periodically.${NC}"
  echo
  echo
  read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
  echo
  if [ ! "$ANSWER" = "y" ]; then
    echo "Aborting."
    exit 1
  fi
  echo
  echo "${CYAN}This tool will ${RED}IMMEDIATELY${CYAN} reboot your Raspberry Pi once it finishes installing!${NC}"
  read -p "Is that OK (y/n) :" -r ANSWER
  echo
  if [ ! "$ANSWER" = "y" ]; then
    echo "Aborting."
    exit 1
  fi
fi

if [ ! -f "files/logkiller" ]; then
  echo "${RED}Cannot find files/logkiller - Run this script from its own directory!${NC}"
  exit 1
fi

echo "${GREEN}Adding the RAM filesystem to /etc/fstab...${NC}"
echo "tmpfs /tmp tmpfs defaults,noatime,nosuid,size=30m 0 0" >> /etc/fstab
echo "tmpfs /var/log tmpfs defaults,noatime,nosuid,mode=0755,size=30m 0 0" >> /etc/fstab

echo "${GREEN}Disabling ntp (just incase)...${NC}"
systemctl stop ntp

echo "${GREEN}Removing old /tmp and /var/log contents...${NC}"
# Might crash the Pi
#rm -f /tmp/* 2>&1 > /dev/null
rm -f /var/log/*.gz 2>&1 /dev/null

echo "${GREEN}Installing logkiller script...${NC}"
cp files/logkiller /etc/cron.hourly/

echo "${GREEN}Marking this tool as installed...${NC}"
. $SCRIPT_MARK_AS_INSTALLED

echo "${RED}Issuing reboot...${NC}"
reboot
