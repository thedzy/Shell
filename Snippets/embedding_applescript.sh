#!/bin/sh

USERNAME=$(/usr/bin/osascript <<OSASCRIPT
	Tell application "System Events"
		with timeout of 900 seconds
			display dialog "Please enter your company username:" default answer "" with icon file ":System:Library:CoreServices:CoreTypes.bundle:Contents:Resources:UserIcon.icns" with title "Login Password" with text buttons {"Ok"} default button 1 giving up after 700
		end timeout
	end tell
	text returned of result
OSASCRIPT
)

printf "$USERNAME\n"

exit 0