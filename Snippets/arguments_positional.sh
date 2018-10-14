#!/bin/sh


# Position 0 is the filename
echo "$0"


# How many parameters where passed
echo "$#"


# All arguments as one
echo "${*}"

# All arguments as array
echo "${@}

# Arguments 1 and 3
echo "${1} ${3}"


# Arguments 4+"
echo "${@:4}"


# Arguments 4-6, Arguments 4 plus 2
echo "${@:4:2}"


# Loop through arguments
for PARAM in "$@"; do
	(( PARAMNUM++ ))
	echo "$PARAMNUM: $PARAM"
done


exit 0
