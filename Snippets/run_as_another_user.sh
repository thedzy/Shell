#!/bin/sh

# Command to run as the user
CMD="defaults -currentHost read com.apple.screensaver idleTime"

################################
#  Method 1
################################

# Get user and id of loged in user
UUID=$(id -u $(logname))
launchctl asuser $UUID $CMD


################################
#  Method 2
################################
sudo -u $(logname) $CMD