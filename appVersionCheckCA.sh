#!/bin/bash
#
# A script to collect the version of Google Chrome that is currently installed.
# If Google Chrome is not installed, it returns "Not Installed".
# This is my template for collecting versions on apps that don't play well with Mosyle reporting.
#

RESULT="Not Installed"
if [ -f "/Applications/Google Chrome.app/Contents/Info.plist" ] ; then
RESULT=$(/usr/bin/defaults read "/Applications/Google Chrome.app/Contents/Info.plist" KSVersion)
fi

/bin/echo "$RESULT"
