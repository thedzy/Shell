#!/bin/sh

# Ensure script is running as root
if [ $(id -u) -ne 0 ] ; then
	echo "Script requires root privilages"
	sudo "$0"
	exit 2
fi

echo "You are $USER"

exit 1