#!/bin/bash

#
# File Name: varTrashCheckCA.sh https://github.com/acodega/mosyle
# Custom command attribute to check and report on the size of the /private/var/root/.Trash folder
# Adobe and Microsoft OneDrive leave old versions here without deleting them
# Custom command attributes are intended for use with Mosyle MDM
#

pathcheck=/private/var/root/.Trash

if [ -e "$pathcheck" ]; then
    echo $(sudo du -sh "$pathcheck" | awk '{print $1}')
else 
    echo "N/A"
fi
