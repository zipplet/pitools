#!/bin/sh
# Add a simple status script to the autologin user to run once the autologin user logs in automatically.
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi

# We must run as root
. $SCRIPT_CHECK_ROOT

# First make sure that our dependency, autologin, is installed.
INSTALLMARK="autologin"
INSTALLMARKFILE="${INSTALLMARKDIR}/${INSTALLMARK}"

. $SCRIPT_CHECK_IF_INSTALLED
if [ $INSTALLED -eq 0 ]; then
  echo "${RED}${INSTALLMARK} is not installed and is required.${NC}"
  exit 1
fi

INSTALLMARK="simplestatus"
INSTALLMARKFILE="${INSTALLMARKDIR}/${INSTALLMARK}"

. $SCRIPT_CHECK_IF_INSTALLED
if [ $INSTALLED -eq 1 ]; then
  echo "${RED}${INSTALLMARK} is already installed.${NC}"
  exit 1
fi

. $SCRIPT_IS_SILENT

if [ "$IS_SILENT" = "0" ]; then
  clear
  echo "${BLUE}-----------------------------------${NC}"
  echo "${CYAN}simplestatus version 0.2 (20161016)${NC}"
  echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
  echo "${BLUE}-----------------------------------${NC}"

  echo
  echo "${YELLOW}1) This script assumes you already have an account called ${CYAN}autologin, but if you got this far you probably do.${NC}"
  echo "${YELLOW}2) A simple demo script that displays useful system stats will be run at login.${NC}"
  echo "${YELLOW}3) You can stop the script at any time with Ctrl+C.${NC}"
  echo
  read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
  echo
  if [ ! "$ANSWER" = "y" ]; then
    echo "Aborting."
    exit 1
  fi
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

echo "${GREEN}Marking this tool as installed...${NC}"
. $SCRIPT_MARK_AS_INSTALLED


if [ "$IS_SILENT" = "0" ]; then
  echo "${GREEN}All done. Reboot your Pi and give it a try.${NC}"
  . $SCRIPT_WANT_REBOOT
fi
