#!/bin/bash
#
# Custom command attribute to check and report on Installomator version.
# Custom command attributes are intended for use with Mosyle MDM
# If it is not found, script returns "Not Installed".
#

appPath="/usr/local/Installomator/Installomator.sh"
result="Not Installed"

if [ -f "$appPath" ]; then
    result=$($appPath longversion | grep "Installomater" | sed 's/.*Installomater: //')
fi

/bin/echo "$result"