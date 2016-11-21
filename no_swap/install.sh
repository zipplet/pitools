#!/bin/sh
# Disable the swap file service on the Raspberry Pi
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi

INSTALLMARK="no_swap"
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
  echo "${BLUE}---------------------------------${NC}"
  echo "${CYAN}no_swap version 0.1 (20161016)${NC}"
  echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
  echo "${BLUE}---------------------------------${NC}"

  echo
  echo "${GREEN}Before proceeding, please confirm the following:${NC}"
  echo "${YELLOW}1) Your Raspberry Pi has enough RAM (ideally it is a 1GB model and you do not run it in GUI mode).${NC}"
  echo
  echo
  read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
  echo
  if [ ! "$ANSWER" = "y" ]; then
    echo "Aborting."
    exit 1
  fi
fi

echo "${GREEN}Disabling swapfile service...${NC}"
systemctl stop dphys-swapfile
systemctl disable dphys-swapfile

echo "${GREEN}Removing any old swapfile...${NC}"
rm /var/swap

echo "${GREEN}Marking this tool as installed...${NC}"
. $SCRIPT_MARK_AS_INSTALLED

if [ "$IS_SILENT" = "0" ]; then
  echo "${GREEN}All done.${NC}"
  echo
  free -m
fi
