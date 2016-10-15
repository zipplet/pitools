#!/bin/sh

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

echo "${GREEN}Installing dphys-swapfile...${NC}"
apt-get install -y dphys-swapfile > /dev/null

echo "${GREEN}Marking this tool as removed...${NC}"
. $SCRIPT_MARK_AS_UNINSTALLED

echo "${GREEN}All done. A reboot is required.${NC}"

. $SCRIPT_WANT_REBOOT