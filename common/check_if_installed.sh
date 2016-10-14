#!/bin/sh
# Check if we are already installed.
# Returns 1 if we are, 0 otherwise.
# Copyright (c) Michael Nixon 2016.

if [ -f "$INSTALLMARKFILE" ]; then
  exit 1
fi

exit 0
