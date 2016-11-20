#!/bin/sh
# Enable the swapfile service on the Raspberry Pi
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
if [ $INSTALLED -eq 0 ]; then
  echo "${RED}${INSTALLMARK} is not installed.${NC}"
  exit 1
fi

echo "${GREEN}Enabling swapfile service (this may take a while)...${NC}"
systemctl enable dphys-swapfile
systemctl start dphys-swapfile

echo "${GREEN}Marking this tool as removed...${NC}"
. $SCRIPT_MARK_AS_UNINSTALLED

echo "${GREEN}All done.${NC}"
echo
free -m