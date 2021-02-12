#!/bin/bash
#
# Custom command attribute to check and report an installed app's version. Google Chrome is the example.
# Custom command attributes are intended for use with Mosyle MDM
# If app is not installed, it returns "Not Installed".
#

# Enter path here to the app you want to check
appPath="/Applications/Google Chrome.app"

result="Not Installed"
if [ -f "$appPath/Contents/Info.plist" ]; then
    result=$(/usr/bin/defaults read "$appPath/Contents/Info.plist" KSVersion)
fi

/bin/echo "$result"
