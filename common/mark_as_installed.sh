#!/bin/sh
# Mark the program as installed.
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

if [ ! -d "$INSTALLMARKDIR" ]; then
  mkdir $INSTALLMARKDIR
fi
date > $INSTALLMARKFILE
