#!/bin/bash

#
# File Name: FileCheckCA.sh https://github.com/acodega/mosyle
# Custom command attribute to check and report if a file or files exists
# Custom command attributes are intended for use with Mosyle MDM
# Remember, we want to produce output if the file is found or not found
# This example was used to check for leftover FileWave remnants
#

path1=/var/FileWave/
path2=/usr/local/sbin/FileWave.app
path3=/sbin/fwcontrol
path4=/Applications/FileWave\ Kiosk.app
path5=/System/Library/StartupItems/FWClient/


if [ -e "$path1" ]; then echo "Yes: '$path1'"
else echo "Not found: '$path1'"
fi

if [ -e "$path2" ]; then echo "Yes: '$path2'"
else echo "Not found: '$path2'"
fi

if [ -e "$path3" ]; then echo "Yes: '$path3'"
else echo "Not found: '$path3'"
fi

if [ -e "$path4" ]; then echo "Yes: '$path4'"
else echo "Not found: '$path4'"
fi

if [ -e "$path5" ]; then echo "Yes: '$path5'"
else echo "Not found: '$path5'"
fi
