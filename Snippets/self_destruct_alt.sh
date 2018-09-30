#!/bin/sh

# Self destructing script

# Get file info
FILE_FULL=$(basename "$0")
FILE_EXTN="${FILE_FULL##*.}"
FILE_NAME="${FILE_FULL%.*}"
FILE_PATH="$(dirname $0)"
DATE=$(date +"%y.%m.%d.%H.%M.%S")

# Because this is a demo, let's create a copy first
cp "$0" "$FILE_PATH/self_destruct_alt."$DATE."$FILE_EXTN"

# Delete file before the contents have run
ExitTrap () {
	# Delete if we exit on success
	[ $1 -eq 0 ] && rm $0
}
trap 'ExitTrap $?' EXIT


# Create some output, because the script is loaded into memory, it will still complete
clear
echo "File Extension: "$FILE_EXTN
echo "File Name:      "$FILE_NAME
echo "File Path:      "$FILE_PATH

echo "File Extension: "$FILE_EXTN > "$FILE_PATH/self_destruct_alt."$DATE."log"
echo "File Name:      "$FILE_NAME >> "$FILE_PATH/self_destruct_alt."$DATE."log"
echo "File Path:      "$FILE_PATH >> "$FILE_PATH/self_destruct_alt."$DATE."log"

echo DONE

exit 0