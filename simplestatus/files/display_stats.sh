#!/bin/sh
# Constantly display some interesting system stats
#
# Part of pitools - https://github.com/zipplet/pitools
# Copyright (c) Michael Nixon 2016.

while :
do
  TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
  CLOCKSPEED=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
  MEMOUTPUT=$(free -h | sed -n '3p')
  RAMUSED=$(echo $MEMOUTPUT | awk -F ' ' '{print $3}')
  RAMFREE=$(echo $MEMOUTPUT | awk -F ' ' '{print $4}')
  LOAD=$(cat /proc/loadavg | awk -F ' ' '{print $1} {print $2} {print $3}')
  clear
  date
  echo
  echo CPU - temp: $(($TEMP/1000)) C, clock: $(($CLOCKSPEED/1000)) MHz
  echo RAM - used: $RAMUSED, free: $RAMFREE
  echo Load: $LOAD
  echo
  /sbin/ifconfig | grep -Fi "inet addr" | sed -e 's/^[ \t]*//' | awk '{print $2}'
  sleep 10
done
