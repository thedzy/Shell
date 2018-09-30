#!/bin/sh
#
# SCRIPT:	timerout.sh
# AUTHOR:	thedzy <thedzy@hotmail.com>
# DATE:		2018-09-30
# REV:		1.0
#
# PLATFORM: MacOS
#
# DESCRIPTION:
#	Executes command with a timeout value
#	Return 1 or 0 if it succeeded in time
#
# BUGS:
#
# FUNCTIONS:
#	timeout()
#
# PARAMETERS:
#   $1 timeout in seconds
#   $2 command
# Returns 1 if timed out 0 otherwise

timeout() {
    TIME=$1
    # start the command in a subshell to avoid problem with pipes
    # (spawn accepts one command)
    COMMAND="/bin/sh -c \"$2\""

    expect -c "set echo \"-noecho\"; set timeout $TIME; spawn -noecho $COMMAND; expect timeout { exit 1 } eof { exit 0 }"    

    if [ $? = 1 ] ; then
        printf "Timeout after ${TIME} seconds\n"
        return 1
    else
    	return 0
    fi

}
