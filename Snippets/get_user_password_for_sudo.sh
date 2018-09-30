#!/bin/sh

# Get password
PASSWORD=$(osascript -e 'Tell application "System Events" to display dialog "Enter the admin password:" with hidden answer default answer ""' -e 'text returned of result')

# Pipe password into command
printf "$PASSWORD\n"|sudo -S fdesetup list

# Unset the password
unset PASSWORD