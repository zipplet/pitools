#!/bin/sh
# Check if we are already installed.
# Returns 1 if we are, 0 otherwise.
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ -f "$INSTALLMARKFILE" ]; then
  INSTALLED=1
else
  INSTALLED=0
fi
