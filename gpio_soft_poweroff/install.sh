#!/bin/sh
# Install a GPIO soft power off daemon
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi

INSTALLMARK="gpio_soft_poweroff"
INSTALLMARKFILE="${INSTALLMARKDIR}/${INSTALLMARK}"

# We must run as root
if [ "$(id -u)" != "0" ]; then
   echo "${RED}Please run this installer as root${NC}" 1>&2
   exit 1
fi

# We must run as root
. $SCRIPT_CHECK_ROOT

. $SCRIPT_CHECK_IF_INSTALLED
if [ $INSTALLED -eq 1 ]; then
  echo "${RED}${INSTALLMARK} is already installed.${NC}"
  exit 1
fi

clear
echo "${BLUE}-------------------------------------------------------------------------${NC}"
echo "${CYAN}gpio_soft_poweroff version 0.2 (20161016)${NC}"
echo "${CYAN}Copyright (c) Michael Nixon 2016 (script Copyright (c) Inderpreet Singh).${NC}"
echo "${CYAN}Thanks to Inderpreet Singh for the script.${NC}"
echo "${BLUE}-------------------------------------------------------------------------${NC}"

echo
echo "${GREEN}Before proceeding, please confirm the following:${NC}"
echo "${YELLOW}1) You are familiar with using GPIO pins safely so you will not damage your Pi.${NC}"
echo "${YELLOW}2) You have a modern Pi with a 40 pin GPIO connector.${NC}"
echo "${YELLOW}3) You understand the GPIO pin numbering.${NC}"
echo 'https://www.element14.com/community/docs/DOC-78055/l/adding-a-shutdown-button-to-the-raspberry-pi-b may be useful'
echo "${YELLOW}4) GPIO pin 21 is not currently in use.${NC}"
echo
read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
echo
if [ ! "$ANSWER" = "y" ]; then
  echo "Aborting."
  exit 1
fi

if [ ! -e "files/shutdown_button.py" ]; then
  echo "${RED}Cannot find files/shutdown_button.py - please run this script from its own directory${NC}"
  exit 1
fi

echo "${GREEN}Setting things up...${NC}"
cp files/shutdown_button.py /usr/sbin
sed -i '/^exit 0/i /usr/sbin/shutdown_button.py &' "/etc/rc.local"
echo "${GREEN}Marking this tool as installed...${NC}"
. $SCRIPT_MARK_AS_INSTALLED
echo "${GREEN}All done.${NC}"
echo "You can test this after rebooting by briefly shorting pins 39 and 40 with a jumper (make sure you understand the pin numbering before doing this or ${CYAN}you might destroy your Pi!${NC}"

. $SCRIPT_WANT_REBOOT
