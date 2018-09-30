#!/bin/sh

if [ "Exit" == $(osascript -e 'tell application "System Events" to return button returned of (display dialog "Do you wish to conintue?" with title "Update System" with icon note buttons {"Exit", "OK"} default button 2) as string') ]; then
	echo "Discontinuing"
	exit 1
fi

exit 0