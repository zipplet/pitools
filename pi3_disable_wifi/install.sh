#!/bin/sh
# Disable the wifi controller
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi

INSTALLMARK="pi3_disable_wifi"
INSTALLMARKFILE="${INSTALLMARKDIR}/${INSTALLMARK}"

# We must run as root
. $SCRIPT_CHECK_ROOT

. $SCRIPT_CHECK_IF_INSTALLED
if [ $INSTALLED -eq 1 ]; then
  echo "${RED}${INSTALLMARK} is already installed.${NC}"
  exit 1
fi

# We only support Raspberry Pi 3 Model B
. $SCRIPT_GET_PI_MODEL
if [ "$PIMODEL" != "3" ]; then
  echo "${RED}This tool only works on the Raspberry Pi 3 Model B.${NC}"
  exit 1
else
  if [ "$PISUBMODEL" != "B" ]; then
    echo "${RED}This tool only works on the Raspberry Pi 3 Model B.${NC}"
    exit 1
  fi
fi

. $SCRIPT_IS_SILENT

if [ "$IS_SILENT" = "0" ]; then
  clear
  echo "${BLUE}---------------------------------------${NC}"
  echo "${CYAN}pi3_disable_wifi version 0.1 (20161121)${NC}"
  echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
  echo "${BLUE}---------------------------------------${NC}"

  echo
  echo "${GREEN}Before proceeding, please confirm the following:${NC}"
  echo "${YELLOW}1) You do not currently use the wifi adaptor.${NC}"
  echo
  echo
  read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
  echo
  if [ ! "$ANSWER" = "y" ]; then
    echo "Aborting."
    exit 1
  fi
fi

echo "${GREEN}Disabling wifi adaptor...${NC}"
echo "# BEGIN pi3_disable_wifi" >> /etc/modprobe.d/raspi-blacklist.conf
echo "blacklist brcmfmac" >> /etc/modprobe.d/raspi-blacklist.conf
echo "blacklist brcmutil" >> /etc/modprobe.d/raspi-blacklist.conf
echo "# END pi3_disable_wifi" >> /etc/modprobe.d/raspi-blacklist.conf

echo "${GREEN}Marking this tool as installed...${NC}"
. $SCRIPT_MARK_AS_INSTALLED

if [ "$IS_SILENT" = "0" ]; then
  echo "${GREEN}All done. A reboot is required.${NC}"
  . $SCRIPT_WANT_REBOOT
fi
