#!/bin/bash

#
# File Name: BatteryHealthCA.sh https://github.com/acodega/mosyle
#
# Custom command attribute to check and report the Mac's battery health and cycle count
# Output example: "Normal (20)" indicates battery health reported normal with a cycle count of 20
# 
# Custom command attributes are intended for use with Mosyle MDM
#

batteryCondition=$(system_profiler SPPowerDataType | grep "Condition" | awk '{print $2}')
batteryCycleCount=$(system_profiler SPPowerDataType | grep "Cycle Count" | awk '{print $3}')

echo $batteryCondition \($batteryCycleCount\)
