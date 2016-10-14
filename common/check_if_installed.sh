#!/bin/sh
# Check if we are already installed.
# Returns 1 if we are, 0 otherwise.
# Copyright (c) Michael Nixon 2016.

if [ -f "$INSTALLMARKFILE" ]; then
  INSTALLED=1
fi

INSTALLED=0
