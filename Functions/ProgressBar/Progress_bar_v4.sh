#!/bin/sh

ProgressBar() {

	# Usage:
	# ProgressBar Tile Position (MaxPosition or 0 for indefinite) Colours
	
	local MAX=$3
	local PROGRESS=$2
	local TITLE="$1"
	local RAINBOW=(${@:4})
	local PROGRESSPER RAINBOWPOS CLR COLOUR SIZE LEFT POS BAR NUM

	tput sc
	tput cup 0 0
	
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
	
	tput rc
}
