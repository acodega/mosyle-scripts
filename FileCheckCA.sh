#!/bin/bash

#
# File Name: FileCheck.sh https://github.com/acodega/mosyle
# Custom command attribute to check and report if a file or files exists
# Custom command attributes are intended for use with Mosyle MDM
# Remember, we want to produce output if the file is found or not found
# This example was used to check for leftover FileWave remnants
#

paths=(
  "/var/FileWave/"
  "/usr/local/sbin/FileWave.app"
  "/sbin/fwcontrol"
  "/Applications/FileWave Kiosk.app"
  "/System/Library/StartupItems/FWClient/"
)

for path in "${paths[@]}"; do
  if [ ! -e "${path}" ]; then
    echo "Not found: '${path}'"
  else
    echo "Found: '${path}'" 
  fi
done
