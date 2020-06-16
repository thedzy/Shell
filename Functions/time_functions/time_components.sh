#!/usr/bin/env bash
#
# SCRIPT:	time_components.sh
# AUTHOR:	thedzy <thedzy@hotmail.com>
# DATE:		2020-06-16
# REV:		1.0
#
# PLATFORM: MacOS
#
# DESCRIPTION:
#   Get the components of time in seconds, minutes, hours, days
#
# BUGS:
#
#
# PARAMETERS:
#

time_components() {
    local SECONDS=$1
    local MINUTES=$((SECONDS / 60))
    local SECONDS=$((SECONDS % 60))
    local HOURS=$((MINUTES / 60))
    local MINUTES=$((MINUTES % 60))
    local DAYS=$((HOURS / 24))
    local HOURS=$((HOURS % 24))

    echo $DAYS $HOURS $MINUTES $SECONDS
}
