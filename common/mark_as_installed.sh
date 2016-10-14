#!/bin/sh
# Mark the program as installed.
# Copyright (c) Michael Nixon 2016.

if [ ! -d "$INSTALLMARKDIR" ]; then
  mkdir $INSTALLMARKDIR
fi
date > $INSTALLMARKFILE
