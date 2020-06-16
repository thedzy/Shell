#!/bin/bash

tput reset
printf '\e[3J'

##########################################################################################
# CompanyName
# Author:
# Date:
# Platform: MacOS
#
# Description
#
# Versions
# 1.	Features
#
#
#
##########################################################################################
#
# Exit Codes
#	0. Success/Help
#
#
#
##########################################################################################

##########################################################################################
# Traps
################

ExitTrap () {
	# Exit code/cleanup



	# Clean up tmpdir
	rm -rf "$TMPDIR" || printf "Error removing temporary directory %s\n" "$TMPDIR"

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
BASEPATH="$(dirname "$0")"
BASENAME="$(basename "$0")"


# Create temporary and working directory
WRKDIR="$TMPDIR"
TMPDIR="/tmp/$BASENAME."$(openssl rand -hex 12)
mkdir -p -m 777 "$TMPDIR"

# Colours (ex. ${KBLD}Bold Text${KNRM})
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

# Turn off line wrapping:
#printf '\033[?7l'
# Turn on  line wrapping:
#printf '\033[?7h'

# Set window size ex. 100w x 40h
#printf '\033[8;40;100t'

# Set window Title
printf "\033]0;%s\007" "${BASENAME%%.*}"

# Hide the cursor for the run of the script
tput civis

##########################################################################################
# Functions
################






##########################################################################################
# Main
################


printf "Do stuff\n"


exit 0