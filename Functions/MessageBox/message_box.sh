#!/bin/sh
#
# SCRIPT:	message_box.sh
# AUTHOR:	thedzy <thedzy@hotmail.com>
# DATE:		2018-09-24
# REV:		2.0
#
# PLATFORM: MacOS
#
# PURPOSE:
#	Display a message centre screen
#
# FUNCTIONS: 
#	messagebox()
# PARAMETERS: 
#	$1 Message (default: ERROR)
#	$2 Width (default: 5)
#	$3 Hieght (default: 3)
#	$4 Colour (default: 9)
#	$5 Text Colour (default: 15)
#

messagebox () {
	# Usage :
	# messagebox   window_width(default message +4)   window_height(default 3)   message(default "error")   window_colour(default red/124)   text_colour(default white/256)

	# Get Parameters
	local MSG="${1:-ERROR}"
	local WIDTH=${2:-5}
	local HEIGHT=$(( ${3:-3} - 1 ))
	local WINCOLOUR=${4:-9}
	local TXTCOLOUR=${5:-15}
	
	# Get terminal window information
	local WINWIDTH=$(tput cols)
	local WINHEIGHT=$(tput lines)
	
	# Limit window size
	[ $WIDTH -lt $(( ${#MSG} + 6 )) ] && WIDTH=$(( ${#MSG} + 6 ))
	[ $WIDTH -gt $WINWIDTH ] && WIDTH=$WINWIDTH
	[ $HEIGHT -le 2 ] && HEIGHT=2
	[ $HEIGHT -gt $WINHEIGHT ] && HEIGHT=$WINHEIGHT
	WIDTH=$(( WIDTH -2 ))
	
	# Get padding information
	local XPADDING=$(( (( WINWIDTH - WIDTH ) / 2) - 2 )) 
	local YPADDING=$(( (( WINHEIGHT - HEIGHT ) / 2) - 2 )) 
	local LPADDING=$(( ( WIDTH - ${#MSG} ) / 2 ))
	local RPADDING=$(( WIDTH - ${#MSG} - LPADDING ))
	local MSGLINE=$(( HEIGHT / 2 ))
	
	# Draw top and bottom bar
	local BAR=$(printf "%${WIDTH}s"); BAR=${BAR// /═}

	# Build window
	tput sc
	printf "\e[38;5;${TXTCOLOUR}m"
	printf "\e[48;5;${WINCOLOUR}m"
	tput cup $YPADDING
	for LINE in $(seq 0 $HEIGHT); do
		tput cup $(( YPADDING + LINE )) $XPADDING
		case $LINE in
			0 ) 		printf "╔${BAR}╗";;
			$MSGLINE )  printf "║%${LPADDING}s${MSG}%${RPADDING}s║";;
			$HEIGHT ) 	printf "╚${BAR}╝";;
			* ) 		printf "║%${WIDTH}s║";;
		esac
	done
	printf "\e[0m"
	tput rc
}
