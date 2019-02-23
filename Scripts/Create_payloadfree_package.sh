#!/bin/sh

#tput reset
#printf '\e[3J'

##########################################################################################
# thedzy
# Author: thedzy
# Date: 2018-09-29
# Platform: MacOS
#
# Description
#		Recreates the package command for creating a payload free package by allowing the 
#		use to scpecify the post and preinstall without them needing to be
#		named correctly and in a folder
#
# Versions
# 1.	Cretaes a file with a perinstall/postinall script
#		
#
# Parameters
# -h|help			Help
# -l|log			Logging
# -d|debug			Debugging
# -a|preinstall 	Preinstall script
# -b|postinstall 	Postinstall script
# -v|version		Version
# -i|Identifier		Identifier
#
# Known Bugs
# 
#
##########################################################################################
#
# Exit Codes
#	0. Success/Help
#	1. Bad parameter
#	2. Bad log file
#	3. Invalid script file
#	4. Invalid pkg path
#
#
#	100+. 100+ error from line of code
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

ErrTrap () {
	# Error trapping
	local ERRLNE="$1"
	local ERRNUM="$2"
	local ERRCMD=$(sed -n -e  "$1  p" "$0")
	local ERRDAT=$(date +"%Y.%m.%d %H.%M.%S")
	
	#Output err to screen and line
	printf "$ERRDAT Error: $ERRNUM on line $ERRLNE: $ERRCMD\n"

	# Ask to continue
	tput sc
	local OPT=""
	until [ "${OPT/Y/y}" == "y" ] || [ "${OPT/N/n}" == "n" ]; do
		tput rc
		!(( LOGGING )) && read -p "Continue (y/n)? " -n 1 -s OPT
		OPT=${OPT:-0}
		(( LOGGING )) && OPT="y"
	done
	
	# Exit if the user chooses "N/n"
	[ "${OPT/N/n}" == "n" ] && exit $(( $ERRNUM + 100 )) || printf "\nContinuing ....\n"
}
trap 'ErrTrap ${LINENO} ${?}' ERR



##########################################################################################
# Environment setup
################

# Global Variables
BASEPATH="$(dirname $0)"
BASENAME="$(basename $0)"

# Initialise
VERSION=""
IDENTIFIER=""
PACKAGEFILE=""

# Create temporary and working diorectory
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
printf "\033]0;${BASENAME%%.*}\007"

# Hide the cursor for the run of the script
tput civis


##########################################################################################
# Arguments
################

# Uncomment to require at least one parameter else throw help
[[ ! $@ =~ ^\-.+ ]] && HELP=true

while [[ $# > 0 ]]
do
    key="$1"
    case $key in
        -l|--log)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                LOGFILE+=($nextArg)
                if [ -d "$(dirname $LOGFILE)" ]; then
					exec &> "$LOGFILE"
					LOGGING=1
				else
					printf "Invalid log path: %s\n" "$LOGFILE"
					exit 2
				fi
                if ! [[ "$2" =~ -.* ]]; then
                    shift
                    nextArg="$2"
                else
                    shift
                    break
                fi
            done
        ;;
        -d|--debug)
            echo "Debug ON"
            set -x
        ;;
        -h|--help)
            HELP=true
        ;;
        -a|--preinstall)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                PRESCRIPT+=($nextArg)
                if [ ! -f "$PRESCRIPT" ]; then
					printf "Invalid preinstall script: %s\n" "$PRESCRIPT"
					exit 3
				else
					mkdir -p "$TMPDIR/scripts"
					cp "$PRESCRIPT" "$TMPDIR/scripts/preinstall"
				fi
                if ! [[ "$2" =~ -.* ]]; then
                    shift
                    nextArg="$2"
                else
                    shift
                    break
                fi
            done
        ;;
        -b|--postinstall)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                POSTSCRIPT+=($nextArg)
                if [ ! -f "$POSTSCRIPT" ]; then
					printf "Invalid preinstall script: %s\n" "$POSTSCRIPT"
					exit 3
				else
					mkdir -p "$TMPDIR/scripts"
					cp "$POSTSCRIPT"  "$TMPDIR/scripts/postinstall"
				fi
                if ! [[ "$2" =~ -.* ]]; then
                    shift
                    nextArg="$2"
                else
                    shift
                    break
                fi
            done
        ;;
        -v|--version)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                VERSION+=($nextArg)
                if ! [[ "$2" =~ -.* ]]; then
                    shift
                    nextArg="$2"
                else
                    shift
                    break
                fi
            done
        ;;
        -i|--identifier)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                IDENTIFIER+=($nextArg)
                if ! [[ "$2" =~ -.* ]]; then
                    shift
                    nextArg="$2"
                else
                    shift
                    break
                fi
            done
        ;;
        -p|--pkg)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                PACKAGEFILE+=($nextArg)
                if [ ! -d "$(dirname "$PACKAGEFILE")" ]; then
					printf "Invalid pkg destination: %s\n" "$PACKAGEFILE"
					exit 4
				else
					mkdir -p "$TMPDIR/scripts"
					cp "$POSTSCRIPT"  "$TMPDIR/scripts/postinstall"
				fi
                if ! [[ "$2" =~ -.* ]]; then
                    shift
                    nextArg="$2"
                else
                    shift
                    break
                fi
            done
        ;;
        *)
            echo "Unknown flag $key"
            exit 1
        ;;
    esac
    shift
done

##########################################################################################
# Help
################

if ( ${HELP:-false} ); then
	printf "\n"

	# NAME
	printf "${KBLD}[NAME]${KNRM}\n"
	printf "\t%s\n\n" \
		"$(basename ${0%.*})"
	
	# SYNOPSIS
	printf "${KBLD}[SYNOPSIS]${KNRM}\n"
	printf "\t%s\n\n" \
		"$(basename $0) -hdl"
	
	# DESCRIPTION
	printf "${KBLD}[DESCRIPTION]${KNRM}\n"
	printf "\t%s\n\n" \
		"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Supports line wraping " | \
		fmt -p -w $(tput cols)

	# OPTIONS
	printf "${KBLD}[OPTIONS]${KNRM}\n"
	printf "\t%s\t%s\n" \
		"h|help" "Bring up this help message" \
		"d|debug" "Debug on" \
		"l|log" "Log all output to file to file specified (ex. -l /var/log/logfile.log)"\
		"a|presinatll" "Preinstall file" \
		"b|postinstall" "Post install file" \
		"v|version" "Version of the package" \
		"i|identifier" "Unique identifer" \
		"p|package" "Package to be generated" \
	
	printf "\n\n"
	exit 0
fi


##########################################################################################
# Functions
################






##########################################################################################
# Main
################

if [ ! -f "$TMPDIR/scripts/preinstall" ] && [ ! -f "$TMPDIR/scripts/postinstall" ]; then
	printf "Not valid scripts given\n"
	exit 3
fi

[ -z "$VERSION" ] && VERSION="1.0"
[ -z "$IDENTIFIER" ] && IDENTIFIER="$HOSTNAME.$(date +"%y.%m.%d.%H.%M.%S")"
[ -z "$PACKAGEFILE" ] && PACKAGEFILE="$HOME/Desktop/paylodfree.pkg"

pkgbuild --nopayload --scripts "$TMPDIR/scripts" --identifier "$IDENTIFIER" --version "$VERSION" "$PACKAGEFILE"

open "$(dirname "$PACKAGEFILE")/"


exit 0

#Get script path


if [ -z $PACKAGEFILE ];then
	PACKAGEFILE=$1.pkg
fi


exit 0