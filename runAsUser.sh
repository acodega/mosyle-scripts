#!/bin/bash

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

runAsUser defaults write com.apple.finder FXRemoveOldTrashItems -bool TRUE
