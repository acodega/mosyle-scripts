#!/bin/bash
#
# A script to collect the version of Zoom that is currently installed.
# If Zoom is not installed, it returns "Not Installed".
# This is one of my template for collecting versions on apps that don't play well with Mosyle reporting.
#

result="Not Installed"
if [ -f "/Applications/zoom.us.app/Contents/Info.plist" ] ; then
result=$(/usr/bin/defaults read "/Applications/zoom.us.app/Contents/Info.plist" CFBundleShortVersionString | awk -F' ' '{print $1}')
fi

echo "$result"
