#!/bin/sh


# Check if the file that called this script is itself
if [ "$(ps -p $PPID -o command="" | awk '{ print $2 }')" != "$0" ]; then
	# Rerun the script caffienated
	printf "Relauching\n"
	caffeinate -dimsu sh $0
	exit 0
fi


printf "Do stuff ..."
sleep 300
printf "Done\n"

exit 0
