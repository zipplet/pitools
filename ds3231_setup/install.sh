#!/bin/sh

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi

INSTALLMARK="ds3231_setup"
INSTALLMARKFILE="${INSTALLMARKDIR}/${INSTALLMARK}"

# We must run as root
. $SCRIPT_CHECK_ROOT

. $SCRIPT_CHECK_IF_INSTALLED
if [ $INSTALLED -eq 1 ]; then
  echo "${RED}${INSTALLMARK} is already installed.${NC}"
  exit 1
fi

clear
echo "${BLUE}-----------------------------------${NC}"
echo "${CYAN}ds3231_setup version 0.1 (20161016)${NC}"
echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
echo "${BLUE}-----------------------------------${NC}"

echo
echo "${GREEN}Before proceeding, please confirm the following:${NC}"
echo "${YELLOW}1) This script assumes you have connected a ${CYAN}DS3231${YELLOW} based RTC to your Raspberry Pi.${NC}"
echo "${YELLOW}2) You will need to manually force a clock set after booting for the first time after doing this.${NC}"
echo
echo
read -p "Have you read, confirmed and do you understand all of the above? (y/n) :" -r ANSWER
echo
if [ ! "$ANSWER" = "y" ]; then
  echo "Aborting."
  exit 1
fi

if ! grep -qs "dtparam=i2c_arm=on" /boot/config.txt; then
  echo "${RED}i2c support needs to be enabled on this Raspberry Pi. Please run raspi-config.${NC}"
  exit 1
fi

if [ ! -f "files/hwclock-stop.service" ]; then
  echo "${RED}Cannot find files/hwclock-stop.service - Run this script from its own directory!${NC}"
  exit 1
fi

echo "${GREEN}Installing systemd services...${NC}"
cp files/hwclock-stop.service /lib/systemd/system/hwclock-stop.service
systemctl enable hwclock-stop

echo "${GREEN}Working around a silly bug by modifying /etc/init.d/ntp...${NC}"
echo "(a backup has been created at /etc/init.d/ntp.backup)"
cp /etc/init.d/ntp /etc/init.d/ntp.backup
sed -i '/^log_daemon_msg "Starting NTP server"/i hwclock -s' "/etc/init.d/ntp"

echo "${GREEN}Adding driver overlay...${NC}"
echo "# RTC support" >> /boot/config.txt
echo "dtoverlay=i2c-rtc,ds3231" >> /boot/config.txt

if [ -f "/pitools/sd_to_usb_boot" ]; then
  rpi-usbbootsync
fi

echo "${GREEN}Making sure fake-hwclock is removed...${NC}"
apt-get purge fake-hwclock

echo "${GREEN}Removing any old adjtime file...${NC}"
rm /etc/adjtime

echo "${GREEN}Marking this tool as installed...${NC}"
. $SCRIPT_MARK_AS_INSTALLED

echo "${GREEN}All done. A reboot is required.${NC}"
echo "${YELLOW}After rebooting for the first time and setting the correct time, please run ${CYAN}hwclock -w${YELLOW} and then reboot again.${NC}"

. $SCRIPT_WANT_REBOOT