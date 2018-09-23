#!/bin/sh


# Position 0 is the filename
echo "$0"


# How many parameters where passed
echo "$#"


# All parameters as one
echo "${*}"

# All parameters as array
echo "${@}

# Parmeters 1 and 3
echo "${1} ${3}"


# Parameters 4+"
echo "${@:4}"


# Parameters 4-6, Parameter 4 plus 2
echo "${@:4:2}"


# Loop through parameters
for PARAM in "$@"; do
	(( PARAMNUM++ ))
	echo "$PARAMNUM: $PARAM"
done


exit 0
