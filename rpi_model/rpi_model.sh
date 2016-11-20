#!/bin/sh

if [ ! -f "../common/common.sh" ]; then
  echo "Please run this script from the script directory."
  exit 1
else
  . ../common/common.sh
fi

# Report Pi model
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
echo " - RAM: ${CYAN}${PIRAM}${NC}"

exit 0
