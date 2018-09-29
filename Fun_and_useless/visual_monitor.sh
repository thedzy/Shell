#!/bin/sh

tput -T5620 reset

#
# SCRIPT:	visual_monitor.sh
# AUTHOR:	thedzy <thedzy@hotmail.com>
# DATE:		2018-09-29
# REV:		1.0
#
# PLATFORM: MacOS
#
# PURPOSE:
#	Display the cpu and memory of the computer
#

clear

ProgressBar() {

	# Usage:
	# ProgressBar Tile Position (MaxPosition or 0 for indefinite) Colours
	
	local MAX=$3
	local PROGRESS=$2
	local TITLE="$1"
	local RAINBOW=(${@:4})
	local PROGRESSPER RAINBOWPOS CLR COLOUR SIZE LEFT POS BAR NUM

	# Format Styles
	KBLD="\033[1m"
	KNRM="\033[0m"
	
	if [ $MAX -ne 0 ]; then
		# Progress
		PROGRESSPER=$(( ( PROGRESS * 1000 / MAX ) / 10 ))
		RAINBOWPOS=$(( (( PROGRESS * 1000 / MAX) * ( ${#RAINBOW[@]} -1 ) ) /1000 ))
		CLR=${RAINBOW[RAINBOWPOS]}
		COLOUR="\e[48;5;${CLR}m"

		# Calculate sizes
		SIZE=$(( $(tput cols) - 11 - ${#TITLE}))
		[ $PROGRESSPER -ne 100 ] && DONE=$(( (( (SIZE*10000) / (MAX) ) * (PROGRESS)) /10000 )) || DONE=$SIZE
		LEFT=$(( SIZE - DONE ))

		# Render bar
		printf "\r ${KBLD}${TITLE} : [${COLOUR}%${DONE}s${KNRM}%${LEFT}s${KBLD}] ${PROGRESSPER}%%${KNRM}"
	else
		# Candy stripe
		SIZE=$(( $(tput cols) - 7 - ${#TITLE}))
		POS=$(( ${#RAINBOW[@]} - ((PROGRESS + COLUMNS) % ${#RAINBOW[@]}) -1 ))
		BAR=""
		for NUM in $(seq 0 ${SIZE}); do
			BAR="${BAR}\e[48;5;${RAINBOW[POS]}m "
			(( POS++ ))
			[ $POS -ge ${#RAINBOW[@]} ] && POS=0
		done

		# Render bar
		printf "\r ${KBLD}${TITLE} : [${BAR}${KNRM}] ${KNRM}"
	fi
}


tput cup 1 0
tput cvvis
printf "\e[1;38m :: System Monitoring :: "

CPUS=$(sysctl -a | grep cpu | grep hw.ncpu | grep -Eo "[0-9]{1,3}")

while true; do

		
		CPU=$(echo "$(ps -A -o %cpu | awk '{ cpu += $1} END {print cpu}') / $CPUS" | bc)
		MEM=$(ps -A -o %mem | awk '{ mem += $1} END {print mem}')

		tput cup 2 0
		ProgressBar "CPU" ${CPU%.*} 100 196
		tput cup 3 0
		ProgressBar "MEM" ${MEM%.*} 100 028
		
		sleep 1
done
fi


exit 0
