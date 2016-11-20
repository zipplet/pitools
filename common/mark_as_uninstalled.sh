#!/bin/sh
# Unmark the program as installed.
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ -f "$INSTALLMARKFILE" ]; then
  rm $INSTALLMARKFILE
fi

