#!/bin/sh
# Enable USB current boost mode.
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi

INSTALLMARK="usb_current_boost"
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
  echo "${BLUE}----------------------------------------${NC}"
  echo "${CYAN}usb_current_boost version 0.1 (20161016)${NC}"
  echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
  echo "${BLUE}----------------------------------------${NC}"

  echo
  echo "${GREEN}Before proceeding, please confirm the following:${NC}"
  echo "${YELLOW}1) You have a high current power supply attached to your Raspberry Pi (at least capable of 2 amps, ideally 2.5 amps)${NC}"
  echo "${YELLOW}2) This tool only really works on Pi 1 B+ models or later.${NC}"
  echo
  echo
  read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
  echo
  if [ ! "$ANSWER" = "y" ]; then
    echo "Aborting."
    exit 1
  fi
fi

echo "${GREEN}Enabling USB current boost mode...${NC}"
echo "# Enable maximum USB current" >> /boot/config.txt
echo "max_usb_current=1" >> /boot/config.txt

if [ -f "/pitools/sd_to_usb_boot" ]; then
  rpi-usbbootsync
fi

echo "${GREEN}Marking this tool as installed...${NC}"
. $SCRIPT_MARK_AS_INSTALLED

if [ "$IS_SILENT" = "0" ]; then
  echo "${GREEN}All done. A reboot is required.${NC}"
  . $SCRIPT_WANT_REBOOT
fi
