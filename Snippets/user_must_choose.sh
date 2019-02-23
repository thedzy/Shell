#!/bin/sh
# Must choose two examples

tput reset


# Option 1
OPT=X
tput sc
while [ "${OPT/[^1-4]/X}" == "X" ] || [ ! -n "$OPT" ]; do
	echo "1. Do nothing"
	echo "2. Do something"
	echo "3. Do anything"
	echo "4. Do or do not, there is no try"
	read -p "Choose? " -s -n 1 OPT
	tput el1;tput rc
done

echo "\n\n\n"
echo "You choose: $OPT\n"

# Option 2
tput sc
while [ ! "$OPT" == "y" ] && [ ! "$OPT" == "n" ]; do
	read -p "Choose? (y/n) " -s -n 1 OPT
	OPT=$(echo "$OPT" | tr [:upper:] [:lower:] )
	tput el1;tput rc
done

echo "You choose: $OPT"

exit 0
