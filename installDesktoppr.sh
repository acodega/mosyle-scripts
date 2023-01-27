#!/bin/bash

# Get the URL of the latest PKG From the desktoppr GitHub repo
url=$(curl --silent --fail "https://api.github.com/repos/scriptingosx/desktoppr/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg\"/ { print \$4; exit }")
# Expected Team ID of the downloaded PKG
expectedTeamID="JME5BW3F3R"
exitCode=0

currentUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }')
uid=$(id -u "$currentUser")

runAsUser() {  
  if [ "$currentUser" != "loginwindow" ]; then
    launchctl asuser "$uid" sudo -u "$currentUser" "$@"
  else
    echo "No user logged in."
    # uncomment the exit command
    # to make the function exit with an error when no user is logged in
    # exit 1
  fi
}

# Check for desktoppr and install if not found
if [ ! -e "/usr/local/bin/desktoppr" ]; then
  echo "Desktoppr not found. Installing..."
  # Create temporary working directory
  workDirectory=$( /usr/bin/basename "$0" )
  tempDirectory=$( /usr/bin/mktemp -d "/private/tmp/$workDirectory.XXXXXX" )
  echo "Created working directory '$tempDirectory'"
  # Download the installer package
  echo "Downloading desktoppr package"
  /usr/bin/curl --location --silent "$url" -o "$tempDirectory/desktoppr.pkg"
  # Verify the download
  teamID=$(/usr/sbin/spctl -a -vv -t install "$tempDirectory/desktoppr.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()')
  echo "Team ID for downloaded package: $teamID"
  # Install the package if Team ID validates
  if [ "$expectedTeamID" = "$teamID" ] || [ "$expectedTeamID" = "" ]; then
    echo "Package verified. Installing package desktoppr.pkg"
    /usr/sbin/installer -pkg "$tempDirectory/desktoppr.pkg" -target /
    exitCode=0
  else 
    echo "Package verification failed before package installation could start. Download link may be invalid. Aborting."
    exitCode=1
    exit $exitCode
  fi
  # Remove the temporary working directory when done
  echo "Deleting working directory '$tempDirectory' and its contents"
  /bin/rm -Rf "$tempDirectory"  
else echo "Desktoppr already found. Proceeding..."
fi

# Uncomment to set the wallpaper
# runAsUser /usr/local/bin/desktoppr "/System/Library/Desktop Pictures/Studio Color.heic"

exit $exitCode
