#!/bin/bash

# set these values as needed for this script

# Microsoft fwlink product ID, e.g. "525133" for Office 2019, found at the end of Microsoft's FW link
linkID="2093504"
url="https://go.microsoft.com/fwlink/?linkid=$linkID"

# Proxy!
proxyServer=""
proxyPort=""

if [[ -z $proxyServer ]];then
	echo "Proxy IP Address not set, skipping set proxy"
else
    echo "Proxy value set to $proxyServer:$proxyPort"
	if ping -q -c 1 -W 5 $proxyServer; then 
    	echo "Proxy reachable and will be set to $proxyServer:$proxyPort"
    	export HTTP_PROXY=$proxyServer:$proxyPort
    	export HTTPS_PROXY=$proxyServer:$proxyPort
    	export http_proxy=$proxyServer:$proxyPort
    	export https_proxy=$proxyServer:$proxyPort
	else
    	echo "Proxy value is set, but its not reachable, skipping set proxy"
	fi
fi

# Expected Team ID of the downloaded PKG. To find out the value,
# Manually download the package and run
# '/usr/sbin/spctl -a -vv -t install package.pkg' to get the expected Team ID
expectedTeamID="UBF8T346G9"

# no further customization is needed

# check for Office installation and exit if found
if [ -e "/Applications/Microsoft Edge.app" ]; then
  echo "Microsoft Edge found. Exiting."
    exitCode=0
    exit $exitCode
else echo "Microsoft Edge not found. Proceeding..."
fi

# create temporary working directory
workDirectory=$( /usr/bin/basename "$0" )
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

unset http_proxy
unset https_proxy

exit $exitCode
