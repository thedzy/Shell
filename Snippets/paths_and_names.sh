#!/bin/sh

# Script file $0
echo $0

# Path to $0
FILEPATH="$(dirname "$0")"
echo "$FILEPATH"

# Script Full File Name
FILENAME="$(basename "$0")"
echo "$FILENAME"

# File Name
FILE="${FILENAME%.*}"
echo "$FILE"

# File extension
FILEEXT="${FILENAME##*.}"
echo "$FILEEXT"

# Get path relative to another path
BASEPATH="/"
NEWPATH=$(echo "$0"|sed "s:$BASEPATH::")
echo "$NEWPATH"