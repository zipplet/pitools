#!/bin/sh
# Sets IS_SILENT to 1 if --quiet is passed on the command line
# (Otherwise sets it to 0)
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

IS_SILENT="0"
if [ ! -z "$1" ]; then
  if [ "$1" = "--quiet" ]; then
    IS_SILENT="1"
  fi
fi
