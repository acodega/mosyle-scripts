#!/bin/bash

#
# This script will download and install a signed and notarized pkg from GitHub
# The pkg we want to install needs to be published in the repo's "Releases" section
# The script will install the "latest" release indicated by the green "Latest" badge when you view the repo releases in your browser
#

# --- Customize these values ----

# If a GitHub url is https://github.com/bartreardon/swiftDialog then bartreardon is the gitHubOwner and swiftDialog is the gitHubRepo
gitHubOwner=
gitHubRepo=

# Provide a local path that will be checked to determine if the pkg has already been installed, ie pathToCheck=/usr/local/bin/dialog
pathToCheck=

# Provided the Team ID we should get when we download the pkg. Run "/usr/sbin/spctl -a -vv -t install /path/to/your.pkg" in Terminal to get the Team ID, ie JME5BW3F3R
expectedTeamID=

# --- Do not change anything remaining below ----

appName=$gitHubRepo
url=$(curl --silent --fail "https://api.github.com/repos/$gitHubOwner/$gitHubRepo/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg\"/ { print \$4; exit }")
exitCode=0

# Check for the app and install if not found
if [ ! -e "$pathToCheck" ]; then
  echo "$appName not found. Installing..."
  # Create temporary working directory
  workDirectory=$( /usr/bin/basename "$0" )
  tempDirectory=$( /usr/bin/mktemp -d "/private/tmp/$workDirectory.XXXXXX" )
  echo "Created working directory '$tempDirectory'"
  # Download the installer package
  echo "Downloading $appName package"
  /usr/bin/curl --location --silent "$url" -o "$tempDirectory/$appName.pkg"
  # Verify the download
  teamID=$(/usr/sbin/spctl -a -vv -t install "$tempDirectory/$appName.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()')
  echo "Team ID for downloaded package: $teamID"
  # Install the package if Team ID validates
  if [ "$expectedTeamID" = "$teamID" ] || [ "$expectedTeamID" = "" ]; then
    echo "Package verified. Installing package $appName.pkg"
    /usr/sbin/installer -pkg "$tempDirectory/$appName.pkg" -target /
    exitCode=0
  else 
    echo "Package verification failed before package installation could start. Download link may be invalid. Aborting."
    exitCode=1
    exit $exitCode
  fi
  # Remove the temporary working directory when done
  echo "Deleting working directory '$tempDirectory' and its contents"
  /bin/rm -Rf "$tempDirectory"  
else echo "$appName already found. Skipping installation..."
fi

exit $exitCode
