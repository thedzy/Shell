#!/bin/sh
#
# SCRIPT:	columns.sh
# AUTHOR:	thedzy <thedzy@hotmail.com>
# DATE:		2018-09-24
# REV:		1.0
#
# PLATFORM: MacOS
#
# PURPOSE:
#	Format data into columns
#
# FUNCTIONS: 
#	columndata()
# PARAMETERS: 
#	$1 Cell data
#	$2 Cell width
#	$3 Alignment (left, right center)
#

columndata() {
	local CDATA="$1"
	local WIDTH=$(( ${2} - 3 ))
	local ALIGN=$3

	local LEFT RIGHT
	
	[ $WIDTH -le 0 ] && echo " |" && exit

	CDATA=${CDATA: 0:WIDTH}
	case $3 in
		1|left)
			LEFT=$(( WIDTH - ${#CDATA} ))
			echo "$(printf "$CDATA""%${LEFT}s |")" "\c"
			;;
		3|right)
			RIGHT=$(( WIDTH - ${#CDATA} ))
			echo "$(printf "%${RIGHT}s$CDATA |")" "\c"
			;;
		*|centre)
			LEFT=$(( WIDTH - ${#CDATA} ))
			RIGHT=$(( LEFT / 2))
			LEFT=$(( LEFT - RIGHT ))
			echo "$(printf "%${RIGHT}s$CDATA%${LEFT}s |")" "\c"
			;;
	esac

}

hr() {
	local HR
	HR=$(tput cols)
	HR=$(printf "%${HR}s")
	printf "${KBLD}${HR// /=}${KNRM}"
}

