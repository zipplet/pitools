#!/bin/sh
# Autologin installer
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
if [ $INSTALLED -eq 1 ]; then
  echo "${RED}${INSTALLMARK} is already installed.${NC}"
  exit 1
fi

. $SCRIPT_IS_SILENT

if [ "$IS_SILENT" = "0" ]; then
  clear
  echo "${BLUE}---------------------------------${NC}"
  echo "${CYAN}autologin version 0.2 (20161015)${NC}"
  echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
  echo "${BLUE}---------------------------------${NC}"

  echo
  echo "${RED}This script is designed for modern versions of Raspbian only that use systemd.${NC}"
  echo
  echo "${GREEN}Before proceeding, please confirm the following:${NC}"
  echo "${YELLOW}1) A new user account called ${CYAN}autologin${YELLOW} will be created.${NC}"
  echo "${YELLOW}2) Your Raspberry Pi will automatically login to this account on startup.${NC}"
  echo "${YELLOW}3) If the ${CYAN}autologin${YELLOW} account already exists, it will be used as-is.${NC}"
  echo "${YELLOW}4) The account will have the same group memberships as the Pi account but without sudo access.${NC}"
  echo
  read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
  echo
  if [ ! "$ANSWER" = "y" ]; then
    echo "Aborting."
    exit 1
  fi
fi

if [ ! -f "files/autologin@.service" ]; then
  echo "${RED}Cannot find files/autologin@.service. Run this script from its own directory!${NC}"
  exit 1
fi

cp files/autologin\@.service /etc/systemd/system/autologin\@.service

echo "${YELLOW}This script will configure your Pi to autologin at startup with a new"
echo "user account that we will create now, called ${CYAN}autologin${NC}."
echo
echo "If you want this account to start a program after logging in, edit the file"
echo "${CYAN}~/.profile${NC} in the ${CYAN}/home/autologin${NC} directory after."
echo

if [ "$IS_SILENT" = "0" ]; then
  echo "${CYAN}Creating the new account. You can use any password you want, but do not"
  echo "forget it incase you need it later.${NC}"
  echo
  adduser autologin
  echo
else
  echo "${CYAN}Creating the new account with the password ${GREEN}autologin${NC}"
  echo
  echo -e "\n\n\n\n\n\n" | adduser --disabled-login --quiet autologin
  echo
  echo -e "autologin\nautologin\n" | passwd autologin
  echo
fi

if [ ! -d "/home/autologin" ]; then
  echo "${RED}Cannot find the home directory for the new user. Something went wrong.${NC}"
  exit 1
fi

echo "${GREEN}Making sure the user is in the right groups ${CYAN}except sudo${GREEN}...${NC}"
# The same groups as the default Pi user except sudo.
usermod -a -G dialout autologin
usermod -a -G cdrom autologin
usermod -a -G audio autologin
usermod -a -G video autologin
usermod -a -G plugdev autologin
usermod -a -G games autologin
usermod -a -G users autologin
usermod -a -G input autologin
usermod -a -G netdev autologin
usermod -a -G spi autologin
usermod -a -G i2c autologin
usermod -a -G gpio autologin

echo "${GREEN}Setting up auto logon at boot...${NC}"

cp files/autologin\@.service /etc/systemd/system/autologin\@.service
rm /etc/systemd/system/getty.target.wants/getty@tty1.service
ln -s /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service

echo "${GREEN}Marking this tool as installed...${NC}"
. $SCRIPT_MARK_AS_INSTALLED

if [ "$IS_SILENT" = "0" ]; then
  echo "${GREEN}All done. Your Pi will auto-login with the ${CYAN}autologin${GREEN} account now.${NC}"
  echo "${YELLOW}To undo this, run ${CYAN}uninstall.sh${NC} ${YELLOW}at any time.${NC}"
  . $SCRIPT_WANT_REBOOT
fi
