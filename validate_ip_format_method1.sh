#!/bin/sh

IP="$1"

if expr "$IP" : '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*/[0-9]*$' >/dev/null; then
	echo YES
else
	echo NO
fi
