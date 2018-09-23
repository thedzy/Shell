#!/bin/sh

IFS=$'.' IP=($1)

INVALID=0
if [ ${#IP[@]} -eq 4 ]; then
	for SEGMENT in "${IP[@]}"; do
		if [ ! -z "${SEGMENT//[0-9]/}" ]; then
			(( INVALID++ )); break
		fi
		if [ $SEGMENT -gt 255 ]; then
			(( INVALID++ )); break
		fi
	done
else
	(( INVALID++ ))
fi

(( INVALID )) && echo Invalid || echo Valid

exit 0
