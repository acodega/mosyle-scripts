#!/bin/bash

# Get the URL of the latest PKG From the Dialog GitHub repo
url=$(curl --silent --fail "https://api.github.com/repos/bartreardon/Dialog/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg\"/ { print \$4; exit }")
# Expected Team ID of the downloaded PKG
expectedTeamID="PWA5E9TQ59"
exitCode=0

# check for Dialog and install if not found
if [ ! -e "/Library/Application Support/Dialog/Dialog.app" ]; then
  echo "Dialog not found. Installing."
  # create temporary working directory
  workDirectory=$( /usr/bin/basename "$0" )
  tempDirectory=$( /usr/bin/mktemp -d "/private/tmp/$workDirectory.XXXXXX" )
  echo "Created working directory '$tempDirectory'"
  # download the installer package
  echo "Downloading Dialog package"
  /usr/bin/curl --location --silent "$url" -o "$tempDirectory/Dialog.pkg"
  # verify the download
  teamID=$(/usr/sbin/spctl -a -vv -t install "$tempDirectory/Dialog.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()')
  echo "Team ID for downloaded package: $teamID"
  # install the package if Team ID validates
  if [ "$expectedTeamID" = "$teamID" ] || [ "$expectedTeamID" = "" ]; then
    echo "Package verified. Installing package Dialog.pkg"
    /usr/sbin/installer -pkg "$tempDirectory/Dialog.pkg" -target /
    exitCode=0
  else 
    echo "Package verification failed before package installation could start. Download link may be invalid. Aborting."
    exitCode=1
    exit $exitCode
  fi
  # remove the temporary working directory when done
  echo "Deleting working directory '$tempDirectory' and its contents"
  /bin/rm -Rf "$tempDirectory"  
else echo "Dialog already found. Proceeding..."
fi

# Code can be entered here to run Dialog.

exit $exitCode