#!/bin/sh
# Autologin uninstaller
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi

INSTALLMARK="autologin"
INSTALLMARKFILE="${INSTALLMARKDIR}/${INSTALLMARK}"

# We must run as root
. $SCRIPT_CHECK_ROOT

. $SCRIPT_CHECK_IF_INSTALLED
if [ $INSTALLED -eq 0 ]; then
  echo "${RED}${INSTALLMARK} is not installed.${NC}"
  exit 1
fi

clear
echo "${BLUE}---------------------------------${NC}"
echo "${CYAN}autologin version 0.2 (20161015)${NC}"
echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
echo "${BLUE}---------------------------------${NC}"

echo
echo "${RED}This script is designed for modern versions of Raspbian only that use systemd.${NC}"
echo
echo "${YELLOW}This will only disable autologin at boot, the user account will be left untouched.${NC}"

read -p "Do you really want to remove autologin? (y/n) :" -r ANSWER
echo
if [ ! "$ANSWER" = "y" ]; then
  echo "Aborting."
  exit 1
fi

rm /etc/systemd/system/getty.target.wants/getty@tty1.service
ln -s /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty1.service

. $SCRIPT_MARK_AS_UNINSTALLED

echo "${GREEN}All done. Your Pi will no longer auto login at boot.${NC}"

. $SCRIPT_WANT_REBOOT

