#!/bin/zsh

# set these values as needed for this script

# First, enter the Microsoft fwlink product ID, e.g. "525133" for Office 2019, found at the end of Microsoft's FW links
linkID="525133"
url="https://go.microsoft.com/fwlink/?linkid=$linkID"

# Second, Expected Team ID of the downloaded PKG. to provide value,
# Manually download the package and run '/usr/sbin/spctl -a -vv -t install package.pkg' to get the expected Team ID
expectedTeamID="UBF8T346G9"

# no further customization is needed

# check for Office installation and exit if found
if [ -e "/Applications/Microsoft Word.app" ]; then;
  echo "Microsoft Word found. Exiting."
	exitcode=0
	exit $exitCode
else echo "Microsoft Word not found. Proceeding..."
fi

# create temporary working directory
workDirectory=$( /usr/bin/basename $0 )
tempDirectory=$( /usr/bin/mktemp -d "/private/tmp/$workDirectory.XXXXXX" )
echo "Created working directory '$tempDirectory'"

# download the installer package
echo "Downloading package $linkID.pkg"
/usr/bin/curl --location --silent "$url" -o "$tempDirectory/$linkID.pkg"

# verify the download
teamID=$(/usr/sbin/spctl -a -vv -t install "$tempDirectory/$linkID.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()')
echo "Team ID for downloaded package: $teamID"

# install the package if Team ID validates
if [ "$expectedTeamID" = "$teamID" ] || [ "$expectedTeamID" = "" ]; then
  echo "Package verified. Installing package $linkID.pkg"
  /usr/sbin/installer -pkg "$tempDirectory/$linkID.pkg" -target /
  exitCode=0
else
	echo "Package verification failed before package installation could start. Download link may be invalid."
	exitCode=1
fi

# remove the temporary working directory when done
echo "Deleting working directory '$tempDirectory' and its contents"
/bin/rm -Rf "$tempDirectory"

exit $exitCode
