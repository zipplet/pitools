#!/bin/sh
# Make sure we are root.
# Returns 1 if we are not (fail), 0 if we are (success).
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ "$(id -u)" != "0" ]; then
   echo "${RED}Please run this program as root (or use sudo)${NC}" 1>&2
   exit 1
fi
