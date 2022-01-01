#!/bin/bash

#
# File Name: ModelCheckCA.sh https://github.com/acodega/mosyle
# Custom command attribute to look up and report a Mac's marketing name
# MDMs including Mosyle use MDM commands to return a Mac's model identifier
# for inventory purposes, but Apple reuses model identifiers across model years.
# This CA checks Apple's support web service to retrieve the marketing name.
# Custom command attributes are intended for use with Mosyle MDM
#

## Get the Mac's serial number
serialNum=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')

## Check the length of the serial number and set an appropriate string to use for the lookup
if [[ ${#serialNum} -ge 12 ]]; then
    Serial=$(echo "$serialNum" | tail -c 5)
else
    Serial=$(echo "$serialNum" | tail -c 4)
fi

## Get the full model name from Apple's support page, using the portion of the Serial Number
# fullModelName=$(curl -s "https://support-sp.apple.com/sp/product?cc=${Serial}" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<configCode>/{print $3}')

## Replacing call to support-sp.apple.com because randomized serial numbers are in use and the site seams to no longer work
fullModelName=/usr/libexec/PlistBuddy -c "print 0:product-description" /dev/stdin <<< $(/usr/sbin/ioreg -abr -k "product-name")

## If we didn't get an empty response, echo the full model name
if [ "$fullModelName" != "" ]; then
    echo "$fullModelName"
    ## Echo the result for the EA
    echo "$fullModelName"
else
    ## If we really weren't able to find anything, set "Not Found" as our result
    echo "Not Found"
fi
