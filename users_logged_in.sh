#!/bin/sh

LUSERS=($(users))
echo ${#LUSERS[@]}" Users logged in: ${LUSERS[@]}"
if [ ${#LUSERS[@]} -eq 1 ] && [ "${LUSERS}" == "_mbsetupuser" ]; then
	echo "At the Login screen"
else
	echo "Not at the Login screen"
fi
