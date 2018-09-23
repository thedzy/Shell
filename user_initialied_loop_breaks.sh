#!/bin/sh

# Loop until user presses a key

read -p "Press any key to stop ..." -t 3 -n 1 -r
until [ $? -eq 0 ]; do
	echo "running again"
	read -p "Press any key to stop ..." -t 3 -n 1 -r
done
