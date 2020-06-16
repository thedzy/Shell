#!/usr/bin/env bash

tput reset
printf '\e[3J'

##########################################################################################
# thedzy
# Filename: clone_dir_with_hardlinks.sh
# Author:   thedzy <thedzy@hotmail.com>
# Date:     2020-06-16
# Platform: MacOS
#
# Clone a directory by creating the folder structure and hard linking the files within
#
# Versions
# 1.	Create the directory structure
# 2.    Create links for all the files
# 3.    Copy permissions
#
#
# Parameters
# -s    Source directory
# -d    Destination directory
# -v    Verbose Output
# -e    Verbose and Errors
# -c    Clear/erase the destination prior to start, requires \"yes\" after to agree ex: -c yes
# -h	Help
# -l	Logging
# -d	Debugging
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
#
#
##########################################################################################

##########################################################################################
# Traps
################

ExitTrap() {
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

# Count errors
ERROR_COUNT=0

# Output
VERBOSE=false
ERRORS=false

# Clear first
CLEAR=false

##########################################################################################
# Arguments
################

# Uncomment to require at least one parameter else throw help
#[[ ! $@ =~ ^\-.+ ]] && HELP=true

# Parse arguments/parameters
while getopts ":s:d:v?:e?:c:d?:h?:l:" OPT; do
    case $OPT in
    l)
        LOGFILE="$OPTARG"
        echo "$LOGFILE"
        if [ -d "$(dirname $LOGFILE)" ]; then
            exec &>"$LOGFILE"
            LOGGING=1
        else
            printf "Invalid log path: %s\n" "$LOGFILE"
            exit 2
        fi
        ;;
    s)
        SOURCE="$OPTARG" >&2
        ;;
    d)
        DESTINATION="$OPTARG" >&2
        ;;
    v)
        VERBOSE=true
        ;;
    e)
        ERRORS=true
        ;;
    c)
        AGREE="$(echo "$OPTARG" | tr [:lower:] [:upper:])"
        [ "$AGREE" == "YES" ] && CLEAR=true || printf "No agreement to clear\n"
        ;;
    d)
        set -x
        ;;
    h)
        HELP=true
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    esac
done

##########################################################################################
# Help
################

if (${HELP:-false}); then
    printf "\n"

    # NAME
    printf "${KBLD}[NAME]${KNRM}\n"
    printf "\t%s\n\n" \
        "$(basename ${0%.*})"

    # SYNOPSIS
    printf "${KBLD}[SYNOPSIS]${KNRM}\n"
    printf "\t%s\n\n" \
        "$(basename $0) -sdvechdl"

    # DESCRIPTION
    printf "${KBLD}[DESCRIPTION]${KNRM}\n"
    printf "\t%s\n\n" \
        "Clone a directory by creating the folder structure and hard linking the files within " |
        fmt -p -w $(tput cols)

    # OPTIONS
    printf "${KBLD}[OPTIONS]${KNRM}\n"
    printf "\t%s\t%s\n" \
        "s" "Source folder" \
        "d" "Destination folder" \
        "v" "Verbose Output" \
        "e" "Verbose and Errors" \
        "c" "Clear/erase the destination prior to start, requires \"yes\" after to agree ex: -c yes" \
        "h" "Bring up this help message" \
        "d" "Debug on" \
        "l" "Log all output to file to file specified (ex. -l /var/log/logfile.log)"

    printf "\n\n"
    exit 0
fi

##########################################################################################
# Functions
################

copy_permmisions() {
    local SOURCE="$1"
    local DEST="$2"

    chown $(stat -f%u:%g "$SOURCE") "$DEST" &>/dev/null
    if [ $? -ne 0 ]; then
        echo $ERRORS
        $ERRORS && printf "Error copying permissions\n"
        ((ERROR_COUNT++))
    fi
}

##########################################################################################
# Main
################

# Check that a -s and -d when given
[ ! "$SOURCE" ] && printf "No source\n" && exit
[ ! "$DESTINATION" ] && printf "No destination\n" && exit

# Check that both are directories
if [ ! -d "$SOURCE" ] || [ ! -d "$DESTINATION" ]; then
    printf "Check source and destination and very both are directories\n"
    exit
fi

#read -s -n1 OPT && OPT=$(echo "$OPT" | tr [:lower:] [:upper:]) # Confirm removing destination
if $CLEAR; then
    printf "Removing %s\n" "$DESTINATION"
    rm -rf "$DESTINATION"
fi

# Start
printf "Cloning %s to %s\n" "$SOURCE" "$DESTINATION"

# Get directories
DU_DIR_ITEMS="$(du -xP "$SOURCE" | cut -d $'\t' -f2)"

# Build directory structure
printf "Building directory tree\n"
while read DU_DIR_ITEM; do
    NEW_DIR="${DU_DIR_ITEM#$SOURCE}"
    $VERBOSE && printf "Creating .. %s\n" "$DESTINATION$NEW_DIR"
    [ -d "$DESTINATION$NEW_DIR" ] && continue
    mkdir -p "$DESTINATION$NEW_DIR"
    [ $? -ne 0 ] && ((ERROR_COUNT++))
    copy_permmisions "$DU_DIR_ITEM" "$DESTINATION$NEW_DIR"
done <<<"$DU_DIR_ITEMS"

if [ $ERROR_COUNT -gt 0 ]; then
    printf "%d errors were encountered in the making directories\n" $ERROR_COUNT
fi

# Reset counter
ERROR_COUNT=0

# Get files and directories
DU_ITEMS="$(du -xPa "$SOURCE" | cut -d $'\t' -f2)"
# Link files
printf "Linking files\n"
while read DU_ITEM; do
    # If file
    if [ -f "$DU_ITEM" ]; then
        NEW_PATH="${DU_ITEM#$SOURCE}"
        # If destination exists
        if [ -e "$DESTINATION$NEW_PATH" ]; then
            $VERBOSE || $ERRORS && printf "Exists .. %s\n" "$DESTINATION$NEW_PATH"
            continue
        fi

        ln "$DU_ITEM" "$DESTINATION$NEW_PATH" &>/dev/null
        if [ $? -eq 0 ]; then
            $VERBOSE && printf "Linking .. %s\n" "$DESTINATION$NEW_PATH"
            copy_permmisions "$DU_ITEM" "$DESTINATION$NEW_PATH"
        else
            $VERBOSE || $ERRORS && printf "Failed .. %s\n" "$DESTINATION$NEW_PATH"
            ((ERROR_COUNT++))
        fi
    fi
done <<<"$DU_ITEMS"

if [ $ERROR_COUNT -gt 0 ]; then
    printf "%d errors were encountered in the linking files\n" $ERROR_COUNT
fi

exit 0
