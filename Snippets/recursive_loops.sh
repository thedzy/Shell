#!/bin/bash

# To see what is going on behind the scenes, uncomment the next line
#set -x

# Simple recusrive loop, breaking with an "if"
loop() {
	local NUMBER=$1
	if [ $NUMBER -lt 10 ]; then
		(( NUMBER ++ ))
		loop $NUMBER
	else
		echo $NUMBER
	fi
}
echo $(loop 0) 


# Simple recusrive loop unsing a while
exponents() {
	local NUMBER=$1
	local INDEX=$2
	(( INDEX-- ))
	while [ $INDEX -gt 0 ]; do
		exponents $(( NUMBER * NUMBER )) $INDEX
		break
	done
	[ $INDEX -eq 0 ] && echo $NUMBER
}
echo $(exponents 9 3) 


# Non terminting recurisive loop (BAD), shows the limits of a recursive function
limits() {
	local NUMLIMITS=$1
	echo $NUMLIMITS
	(( NUMLIMITS ++ ))
	limits $NUMLIMITS
}
echo $(limits 0) 

# Recursive loop to create directory structure
dir() {
	local VAR="$1"
	local INDEX=$2
	(( INDEX++ ))
	
	local ITEMS=""
	local TABS=$(( INDEX * 4))
	for ITEM in "$VAR"/*; do
		[ -f "$ITEM" ] && continue
		[ "$VAR/*" == "$ITEM" ] && break
		printf "%${TABS}s $ITEM\n" "┕━"
		dir "$ITEM" $INDEX
	done
}

echo "$(dir "$HOME/Downloads" 0)"