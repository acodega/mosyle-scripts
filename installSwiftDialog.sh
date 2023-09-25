#!/bin/bash

# Get the URL of the latest PKG From the Dialog GitHub repo
url=$(curl --silent --fail "https://api.github.com/repos/swiftDialog/swiftDialog/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg\"/ { print \$4; exit }")
# Expected Team ID of the downloaded PKG
expectedTeamID="PWA5E9TQ59"
exitCode=0

# If something goes wrong we want to notify the user using AppleScript and exit the script
# The second EndOfScript *must* be tabbed, do not uses spaces.
displayDialog() {
  message="A problem was encounted setting up this Mac. Please contact IT."
  currentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')
  if [[ "$currentUser" != "" ]]; then
    uid=$(id -u "$currentUser")
    launchctl asuser "$uid" /usr/bin/osascript <<-EndOfScript
      button returned of ¬
      (display dialog "$message" ¬
      buttons {"OK"} ¬
      default button "OK")
		EndOfScript
  fi
}

# Check for Dialog and install if not found
if [ ! -e "/Library/Application Support/Dialog/Dialog.app" ]; then
  echo "Dialog not found. Installing."
  # Create temporary working directory
  workDirectory=$( /usr/bin/basename "$0" )
  tempDirectory=$( /usr/bin/mktemp -d "/private/tmp/$workDirectory.XXXXXX" )
  echo "Created working directory '$tempDirectory'"
  # Download the installer package
  echo "Downloading Dialog package"
  /usr/bin/curl --location --silent "$url" -o "$tempDirectory/Dialog.pkg"
  # Verify the download
  teamID=$(/usr/sbin/spctl -a -vv -t install "$tempDirectory/Dialog.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()')
  echo "Team ID for downloaded package: $teamID"
  # Install the package if Team ID validates
  if [ "$expectedTeamID" = "$teamID" ] || [ "$expectedTeamID" = "" ]; then
    echo "Package verified. Installing package Dialog.pkg"
    /usr/sbin/installer -pkg "$tempDirectory/Dialog.pkg" -target /
    exitCode=0
  else 
    echo "Package verification failed before package installation could start. Download link may be invalid. Aborting."
    displayDialog
    exitCode=1
    exit $exitCode
  fi
  # Remove the temporary working directory when done
  echo "Deleting working directory '$tempDirectory' and its contents"
  /bin/rm -Rf "$tempDirectory"  
else echo "Dialog already found. Proceeding..."
fi

# Code can be entered here to run Dialog.

exit $exitCode
