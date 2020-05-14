#!/bin/bash

#
# File Name: LastStartupCA.sh https://github.com/acodega/mosyle
# Custom command attribute to check and report the time of the Mac's last startup (aka last restart)
# Custom command attributes are intended for use with Mosyle MDM
# I wish Mosyle supported date formatting so we could report against it
# ie "More than X days ago"
#

# Use sysctl kern.boottime to get date and time, then format it as a date attribute
date -jf "%s" "$(sysctl kern.boottime | awk -F'[= |,]' '{print $6}')" +"%Y-%m-%d %T"
