#!/bin/sh
# Disable Bluetooth modem restoring GPIO 14 and 15 as UART0
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi

INSTALLMARK="pi3_disable_bt"
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
  echo "${BLUE}-------------------------------------${NC}"
  echo "${CYAN}pi3_disable_bt version 0.1 (20161121)${NC}"
  echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
  echo "${BLUE}-------------------------------------${NC}"

  echo
  echo "${GREEN}Before proceeding, please confirm the following:${NC}"
  echo "${YELLOW}1) You do not currently use the bluetooth adaptor.${NC}"
  echo "${YELLOW}2) GPIO pins 14 and 15 will be UART0 / ttyAMA0 like on older Pi models again.${NC}"
  echo
  echo
  read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
  echo
  if [ ! "$ANSWER" = "y" ]; then
    echo "Aborting."
    exit 1
  fi
fi

echo "${GREEN}Disabling bluetooth adaptor...${NC}"
echo "# Disable bluetooth adaptor (GPIO 14 and 15 will be UART0 ttyAMA0 again)" >> /boot/config.txt
echo "dtoverlay=pi3-disable-bt" >> /boot/config.txt

if [ -f "/pitools/sd_to_usb_boot" ]; then
  rpi-usbbootsync
fi

echo "${GREEN}Disabling systemd bluetooth service...${NC}"
systemctl disable hciuart
systemctl stop hciuart

echo "${GREEN}Marking this tool as installed...${NC}"
. $SCRIPT_MARK_AS_INSTALLED

if [ "$IS_SILENT" = "0" ]; then
  echo "${GREEN}All done. A reboot is required.${NC}"
  . $SCRIPT_WANT_REBOOT
fi
