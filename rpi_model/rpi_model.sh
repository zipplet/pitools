#!/bin/sh
# Report the Raspberry Pi model
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi


clear
echo "${BLUE}---------------------------------${NC}"
echo "${CYAN}rpi_model version 0.1 (20161120)${NC}"
echo "${CYAN}Copyright (c) Michael Nixon 2016.${NC}"
echo "${BLUE}---------------------------------${NC}"

. $SCRIPT_GET_PI_MODEL

# Report Pi model
echo
echo "${YELLOW}NOTE: I do not own any compute modules, so this may not be accurate for those.${NC}"
echo
if [ "$PIBOARD" = "" ]; then
  echo "${RED}Sorry, your Raspberry Pi model is currently unsupported / unknown.${NC}"
  echo "${RED}Please submit the output of ${CYAN}cat /proc/cpuinfo${RED} along with more information about your Rasperry Pi${NC}"
  echo "${RED}to the author, by opening a GitHub issue. Please include high resolution images of the top and bottom of the board.${NC}"
  exit 1
fi
echo "Your Pi: ${CYAN}${PIBOARD}${NC}"
echo " - Model: ${CYAN}${PIMODEL}${NC}"
echo " - Sub model: ${CYAN}${PISUBMODEL}${NC}"
echo " - RAM: ${CYAN}${PIRAM}MB${NC}"
echo " - Revision: ${CYAN}${PIBOARDREVISION}${NC}"

exit 0
