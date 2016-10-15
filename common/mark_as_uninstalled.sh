#!/bin/sh
# Unmark the program as installed.
# Copyright (c) Michael Nixon 2016.

if [ -f "$INSTALLMARKFILE" ]; then
  rm $INSTALLMARKFILE
fi

