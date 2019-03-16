#!/bin/sh

# Check that stdin is not empty, and loop through lines in stdin
if [ -s /dev/stdin ]; then
    while read STDIN_LINE; do
        printf "%s\n" "$STDIN_LINE"
    done <<< "$(cat /dev/stdin)"
fi