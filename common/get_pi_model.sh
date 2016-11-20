#!/bin/sh
# Get the current Raspberry Pi model
# Copyright (c) Michael Nixon 2016.

# Sets:
# - PIBOARDREVISION - Raw board revision ID
# - PIBOARD - Friendly human readable board name
# - PIMODEL - Main model (e.g. 0, 1, 2)
# - PISUBMODEL - Sub model (e.g. A, B, B+)
# - PIRAM - RAM in MB

PIBOARDREVISION=$(grep "Revision" /proc/cpuinfo | cut -f2 | cut -c3-)

# This table comes from http://elinux.org/RPi_HardwareHistory#Board_Revision_History
case "$PIBOARDREVISION" in
  "0002")
    PIBOARD="Q1 2012 - PCB 1.0 - Pi 1 Model B [256MB] (original)"
    PIMODEL="1"
    PISUBMODEL="B"
    PIRAM="256"
    ;;
  "0003")
    PIBOARD="Q3 2012 - PCB 1.0 - Pi 1 Model B (ECN0001) [256MB] (Fuses mod and D14 removed)"
    PIMODEL="1"
    PISUBMODEL="B"
    PIRAM="256"
    ;;
  "0004")
    PIBOARD="Q3 2012 - PCB 2.0 - Pi 1 Model B [256MB] (Manufactured by Sony)"
    PIMODEL="1"
    PISUBMODEL="B"
    PIRAM="256"
    ;;
  "0005")
    PIBOARD="Q4 2012 - PCB 2.0 - Pi 1 Model B [256MB] (Manufactured by Qisda)"
    PIMODEL="1"
    PISUBMODEL="B"
    PIRAM="256"
    ;;
  "0006")
    PIBOARD="Q4 2012 - PCB 2.0 - Pi 1 Model B [256MB] (Manufactured by Egoman)"
    PIMODEL="1"
    PISUBMODEL="B"
    PIRAM="256"
    ;;
  "0007")
    PIBOARD="Q1 2013 - PCB 2.0 - Pi 1 Model A [256MB] (Manufactured by Egoman)"
    PIMODEL="1"
    PISUBMODEL="A"
    PIRAM="256"
    ;;
  "0008")
    PIBOARD="Q1 2013 - PCB 2.0 - Pi 1 Model A [256MB] (Manufactured by Sony)"
    PIMODEL="1"
    PISUBMODEL="A"
    PIRAM="256"
    ;;
  "0009")
    PIBOARD="Q1 2013 - PCB 2.0 - Pi 1 Model A [256MB] (Manufactured by Qisda)"
    PIMODEL="1"
    PISUBMODEL="A"
    PIRAM="256"
    ;;
  "000d")
    PIBOARD="Q4 2012 - PCB 2.0 - Pi 1 Model A [512MB] (Manufactured by Egoman)"
    PIMODEL="1"
    PISUBMODEL="A"
    PIRAM="512"
    ;;
  "000e")
    PIBOARD="Q4 2012 - PCB 2.0 - Pi 1 Model B [512MB] (Manufactured by Sony)"
    PIMODEL="1"
    PISUBMODEL="B"
    PIRAM="512"
    ;;
  "000f")
    PIBOARD="Q4 2012 - PCB 2.0 - Pi 1 Model B [512MB] (Manufactured by Qisda)"
    PIMODEL="1"
    PISUBMODEL="B"
    PIRAM="512"
    ;;
  "0010")
    PIBOARD="Q3 2014 - PCB 1.0 - Pi 1 Model B+ [512MB] (Manufactured by Sony)"
    PIMODEL="1"
    PISUBMODEL="B+"
    PIRAM="512"
    ;;
  "0011")
    PIBOARD="Q2 2014 - PCB 1.0 - Compute Module [512MB] (Manufactured by Sony)"
    PIMODEL="Compute"
    # For now pretend compute modules are equivalent to a B+
    PISUBMODEL="B+"
    PIRAM="512"
    ;;
  "0012")
    PIBOARD="Q4 2014 - PCB 1.1 - Pi 1 Model A+ [256MB] (Manufactured by Sony)"
    PIMODEL="1"
    PISUBMODEL="A+"
    PIRAM="256"
    ;;
  "0013")
    PIBOARD="Q1 2015 - PCB 1.2 - Pi 1 Model B+ [512MB] (Unknown manufacturer)"
    PIMODEL="1"
    PISUBMODEL="B+"
    PIRAM="512"
    ;;
  "0014")
    PIBOARD="Q2 2014 - PCB 1.0 - Compute Module [512MB] (Manufactured by Embest)"
    PIMODEL="1"
    # For now pretend compute modules are equivalent to a B+
    PISUBMODEL="B+"
    PIRAM="512"
    ;;
  "0015")
    PIBOARD="Unknown manufacturing date - PCB 1.1 - Pi 1 Model A+ [256/512MB] (Unknown RAM and unknown manufacturer)"
    PIMODEL="1"
    PISUBMODEL="A+"
    # Err on the side of caution, although we could add a check here
    PIRAM="256"
    ;;
  "a01040")
    PIBOARD="Unknown manufacturing date - PCB 1.0 - Pi 2 Model B [1GB] (Unknown manufacturer)"
    PIMODEL="2"
    PISUBMODEL="B"
    PIRAM="1024"
    ;;
  "a01041")
    PIBOARD="Q1 2015 - PCB 1.1 - Pi 2 Model B [1GB] (Manufactured by Sony)"
    PIMODEL="2"
    PISUBMODEL="B"
    PIRAM="1024"
    ;;
  "a21041")
    PIBOARD="Q1 2015 - PCB 1.1 - Pi 2 Model B [1GB] (Manufactured by Embest)"
    PIMODEL="2"
    PISUBMODEL="B"
    PIRAM="1024"
    ;;
  "a22042")
    PIBOARD="Q3 2016 - PCB 1.2 - Pi 2 Model B (BCM2837) [1GB] (Manufactured by Embest)"
    PIMODEL="2"
    PISUBMODEL="B"
    PIRAM="1024"
    ;;
  "900092")
    PIBOARD="Q4 2015 - PCB 1.2 - Pi Zero [512MB] (Manufactured by Sony)"
    PIMODEL="0"
    PISUBMODEL="0"
    PIRAM="512"
    ;;
  "900093")
    PIBOARD="Q2 2016 - PCB 1.3 - Pi Zero [512MB] (Manufactured by Sony)"
    PIMODEL="0"
    PISUBMODEL="0"
    PIRAM="512"
    ;;
  "920093")
    PIBOARD="Q4 2016? - PCB 1.3 - Pi Zero [512MB] (Manufactured by Embest)"
    PIMODEL="0"
    PISUBMODEL="0"
    PIRAM="512"
    ;;
  "a02082")
    PIBOARD="Q1 2016 - PCB 1.2 - Pi 3 Model B [1GB] (Manufactured by Sony)"
    PIMODEL="3"
    PISUBMODEL="B"
    PIRAM="1024"
    ;;
  "a22082")
    PIBOARD="Q1 2016 - PCB 1.2 - Pi 3 Model B [1GB] (Manufactured by Embest)"
    PIMODEL="3"
    PISUBMODEL="B"
    PIRAM="1024"
    ;;
  *)
    PIBOARD=""
    PIMODEL=""
    PISUBMODEL=""
    PIRAM=""
    ;;
esac
