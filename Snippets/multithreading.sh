#!/bin/sh

uselessfunction () {
	sleep $1
}

printf "Starting...\n"

TOTALSLEEPTIME=0
MAXSLEEPTIME=0
for INDEX in {1..1000}; do
	# Appending the ampsand (&) will spin of the process as a child
	SLEEPTIME=$(((RANDOM % 10) + 1 ))
	uselessfunction $SLEEPTIME &
	TOTALSLEEPTIME=$(( TOTALSLEEPTIME + SLEEPTIME))
	[ $SLEEPTIME -gt $MAXSLEEPTIME ] && MAXSLEEPTIME=$SLEEPTIME
done

printf "If not threaded the script would take $TOTALSLEEPTIME\n"
printf "Instead the process will take $MAXSLEEPTIME"

# Wait for all processes to complete before exiting
wait

printf "\nDone!\n"

exit 0
