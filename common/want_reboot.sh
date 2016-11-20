#!/bin/sh
# Ask if the Raspberry Pi should be rebooted, and reboot it if so
# Returns 1 if the user said no, 0 if they said yes and the machine is rebooting.
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

echo "${GREEN}"
read -p "Would you like to reboot the Raspberry Pi now? (y/n) :" -r ANSWER
echo "${NC}"
if [ ! "$ANSWER" = "y" ]; then
  exit 1
fi

reboot
exit 0
