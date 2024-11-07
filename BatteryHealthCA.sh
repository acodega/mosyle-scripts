#!/bin/bash

#
# File Name: BatteryHealthCA.sh https://github.com/acodega/mosyle
#
# Custom command attribute to check and report the Mac's battery health and cycle count
# Output example: "Normal (20)" indicates battery health reported normal with a cycle count of 20
# Includes logic to echo "N/A" if the computer does not have a battery
# 
# Custom command attributes are intended for use with Mosyle MDM
#

hwType=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Model Name" | grep "Book")

if [ "$hwType" != "" ];
  then
    batteryCondition=$(system_profiler SPPowerDataType | grep "Condition" | awk -F': ' '/Condition:/{ print $NF }')
    batteryCycleCount=$(system_profiler SPPowerDataType | grep "Cycle Count" | awk '{print $3}')
    echo $batteryCondition \($batteryCycleCount\)
  else
	  echo "N/A"
fi
