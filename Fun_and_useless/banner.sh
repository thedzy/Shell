#!/bin/sh
#
# SCRIPT:	banner.sh
# AUTHOR:	thedzy <thedzy@hotmail.com>
# DATE:		2018-09-29
# REV:		2.0
#
# PLATFORM: MacOS
#
# DESCRIPTION:
#	Uses the MacOS banner function and corrects it to horizontal
#
# BUGS:
#
#
# PARAMETERS: 
#	$@ Text to display

# Set window seize
printf '\e[8;75;200t'

# Set variables
SIZE=30
MSG="$@"
MSGRES="$(banner -w $SIZE $MSG)"

OLD_IFS=$IFS
IFS=""
tput clear
Y=0
while read -r LINE; do
	X=$SIZE #print at bottom
	while read -n 1 CHAR; do
		tput cup $X $(( $Y )) # Add a multipier to widden text
		(( X-- ))
		[ "$CHAR" == "#" ] && printf "■"
	done <<< "$LINE"
	(( Y++ ))
	[ $Y -ge $(tput cols) ] && break
done <<< "$MSGRES"

IFS=$OLD_IFS

sleep 1
tput cup $(( SIZE - ( SIZE / 5 ) )) 0
read -p "Press any key to continue..." -n 1 -s

exit