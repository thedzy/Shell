#!/bin/sh

LOGFILE=/tmp/$(basename $0)".log"
echo "Logging out to: $LOGFILE"

exec &> $LOGFILE

echo $(date +"%Y.%m.%d.%H.%M.%S")
echo $LOGFILE
echo "Test"
mv /tmp/nofilehere /tmp/nofilehereeither

exec &> $(tty)

echo "Returning to screen output"

exit 0
