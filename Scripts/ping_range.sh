#!/bin/sh

tput reset
printf '\e[3J'

##########################################################################################
# thedzy
# Author: thedzy
# Date: 2018-10-09
# Platform: MacOS
#
# Description
#		Ping multiple IPs in parallel specifing only the part the range you need
#		Example: 10.0.0 will ping everything in the 10.0.0 range 10.0.0.0 - 10.0.0.255
#
# Versions
# 1.	Pings a range of IPs
# 2.	Pings a range of IPs based on any number of segments
#		
#
# Parameters
#		IP Default: 192.168.0.0
#
# Known Bugs
# 		Virtually no error checking!!
#		Always tries to pring the first 3 segments
#
##########################################################################################

##########################################################################################
# Traps
################

ExitTrap () {
	# Exit code/cleanup
	
	# Clean up tmpdir
	rm -rf "$TMPDIR" || printf "Error removing temporary directory $TMPDIR\n"

	# Restore formatting
	printf "${KNRM}"
	
	# Restore the cursor
	tput cnorm
	
	#printf "Exiting $1\n"
	exit $1
}
trap 'ExitTrap $?' INT EXIT TERM


##########################################################################################
# Environment setup
################

# Global Variables
BASEPATH="$(dirname $0)"
BASENAME="$(basename $0)"


# Create temporary and working diorectory
WRKDIR="$TMPDIR"
TMPDIR="/tmp/$BASENAME."$(openssl rand -hex 12)
mkdir -p -m 777 "$TMPDIR"

# Colours
KNRM="\x1B[0m"
KRED="\x1B[31m"
KGRN="\x1B[32m"
KYEL="\x1B[33m"
KBLU="\x1B[34m"
KMAG="\x1B[35m"
KCYN="\x1B[36m"
KWHT="\x1B[37m"

KBLD="\033[1m"
KNRM="\033[0m"

# Default values
LOGGING=0

# Set window Title
printf "\033]0;${BASENAME%%.*}\007"

# Hide the cursor for the run of the script
tput civis

##########################################################################################
# Functions
################

# Function to ping and write to screen
pinger(){
	local PINGIP=$1
	ping "$PINGIP" -c 2 -i .5 -W 3 -q &>/dev/null
	[ $? -gt 0 ] && printf "${KRED}$PINGIP${KNRM}\n" || printf "${KGRN}${KBLD}$PINGIP${KNRM}\n"
}

# Build IPs to ping based on the known and missing data of IP
buidips() {
	local SEGMENT=${1}
	SEGMENT=${SEGMENT:=0}
	if [ ${IP[SEGMENT]:-256} -le 255 ]; then
		(( SEGMENT++ ))
		# Prevent a leading . on the first segment
		[ -z "$2" ] && local NEWIP="${IP[$SEGMENT - 1]}" || local NEWIP="$2.${IP[$SEGMENT - 1]}"
		# Recursively call the function
		buidips $SEGMENT "$NEWIP"
	else
		# If Segment is missing and we are within 4 segments generate all possible values
		if [ $SEGMENT -lt 4 ]; then
			(( SEGMENT++ ))
			for INDEX in {0..255}; do
				# Recursively call the function
				buidips $SEGMENT "$2.$INDEX"
			done
		fi
	fi
	
	[ $SEGMENT -eq 4 ] && pinger "$2" &
}

##########################################################################################
# Main
################

# Get parameters
if [ -z "$1" ]; then
	IP=( 196 168 0 0 )
else
	IFS=$'.'
	IP=($1)
	IFS=$' '
fi

# Get and display number of segments provided
SEGMENTS=${#IP[@]}
[ ${SEGMENTS} -gt 4 ] && echo "Invalid number of segments" && exit 1
echo "Segments: $SEGMENTS"

# Call the recursive function the build the ip addresses
buidips

# Wait for all pings to finish before exiting
wait

exit 0