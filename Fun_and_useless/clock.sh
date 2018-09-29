#!/bin/sh
#
# SCRIPT:	clock.sh
# AUTHOR:	thedzy <thedzy@hotmail.com>
# DATE:		2018-09-29
# REV:		3.0
#
# PLATFORM: MacOS
#
# DESCRIPTION:
#	Display an anologue lock that continues updating
#
# BUGS:
#	Does crash if the time is just right.  Still hunting this one down.
#
# PARAMETERS: 
#	None

tput reset

exec &2> /dev/null

# Functions
sin ()
{
    echo "scale=5;s($1*0.0174532)" | bc -l
}
cos ()
{
    echo "scale=5;c($1*0.0174532)" | bc -l
}

flotToint() {
    printf "%.0f\n" "$@"
}


# Parameters
[ "$1" == "" ] || [ $1 -eq 0 ] && LENGTH=$(( ($(tput lines) / 2 ) - 4 )) || LENGTH=$1
[ $(( LENGTH * 2 )) -gt $(tput lines) ] && echo "Too big" && exit 1

# ◉ ★ ✖︎ ◼︎ 🌕 ❤️
[ "$2" == "" ] && CHARPRINT="◉︎" || CHARPRINT="$2"

[ "$3" == "" ] && RATIO="3" || RATIO=$3

DRAWSECONDS=1

# Draw a star at ever degree
for DEGREE in {0..360}; do
	#COS=$(cos $DEGREE)
	#SIN=$(sin $DEGREE)
	XINT=$(flotToint $(echo "$(cos $DEGREE) * $LENGTH" | bc -l))
	YINT=$(flotToint $(echo "$(sin $DEGREE) * $LENGTH * $RATIO" | bc -l))
	tput cup $(echo "$XINT +  $LENGTH" | bc -l) $(echo "$YINT +  ($LENGTH * $RATIO)" | bc -l); printf "$CHARPRINT"
done

# Draw hour hand
for DEGREE in {0..360}; do
	if [ $(( DEGREE % 30 )) -eq 0 ]; then
		XINT=$(flotToint $(echo "$(cos $DEGREE) * ($LENGTH - 1)" | bc -l))
		YINT=$(flotToint $(echo "$(sin $DEGREE) * ($LENGTH - 1) * $RATIO" | bc -l))
		tput cup $(echo "$XINT +  $LENGTH" | bc -l) $(echo "$YINT +  ($LENGTH * $RATIO)" | bc -l); printf "$CHARPRINT"
		XINT=$(flotToint $(echo "$(cos $DEGREE) * ($LENGTH - 2)" | bc -l))
		YINT=$(flotToint $(echo "$(sin $DEGREE) * ($LENGTH - 2) * $RATIO" | bc -l))
		tput cup $(echo "$XINT +  $LENGTH" | bc -l) $(echo "$YINT +  ($LENGTH * $RATIO)" | bc -l); printf "$CHARPRINT"
	fi
done


# Draw hands
while [ true ]; do

	# Draw hour hand
	HOURHAND=-5
	HOURDEGREE=$(( (($(date +"%I") * 30) + ($(date +"%M") /2)) - 90 ))
	while [ $(( LENGTH / 2 )) -gt $HOURHAND ]; do
		(( HOURHAND++ ))
		XINT=$(flotToint $(echo "$(sin $HOURDEGREE) * $HOURHAND" | bc -l))
		YINT=$(flotToint $(echo "$(cos $HOURDEGREE) * $HOURHAND * $RATIO" | bc -l))
		tput cup $(echo "$XINT +   $LENGTH" | bc -l) $(echo "$YINT +  ($LENGTH * $RATIO)" | bc -l); printf "\033[31;1m$CHARPRINT\033[0m\n"
	done

	# Draw minute hand
	MINUTEHAND=-6
	MINUTEDEGREE=$(( ($(date +"%M") * 6) - 90 ))
	while [ $(( (LENGTH * 8) /10 )) -gt $MINUTEHAND ]; do
		(( MINUTEHAND++ ))
		XINT=$(flotToint $(echo "$(sin $MINUTEDEGREE) * $MINUTEHAND" | bc -l))
		YINT=$(flotToint $(echo "$(cos $MINUTEDEGREE) * $MINUTEHAND * $RATIO" | bc -l))
		tput cup $(echo "$XINT +   $LENGTH" | bc -l) $(echo "$YINT +  ($LENGTH * $RATIO)" | bc -l); printf "\033[52;1m$CHARPRINT\033[0m\n"
	done
	
	if (( DRAWSECONDS )); then
		# Draw minute hand
		SECONDHAND=-8
		SECONDDEGREE=$(( ($(date +"%S") * 6) - 90 ))
		while [ $(( (LENGTH * 9) /10 )) -gt $SECONDHAND ]; do
			(( SECONDHAND++ ))
			XINT=$(flotToint $(echo "$(sin $SECONDDEGREE) * $SECONDHAND" | bc -l))
			YINT=$(flotToint $(echo "$(cos $SECONDDEGREE) * $SECONDHAND * $RATIO" | bc -l))
			tput cup $(echo "$XINT +   $LENGTH" | bc -l) $(echo "$YINT +  ($LENGTH * $RATIO)" | bc -l); printf "\033[31;1m$CHARPRINT\033[0m\n"
		done
	fi
	
	
	
	tput cup $(( (LENGTH * 2) + 2 )) 0
	(( DRAWSECONDS )) && sleep .5 || sleep 10
	
	# Draw hour hand
	HOURHAND=-5
	while [ $(( LENGTH / 2 )) -gt $HOURHAND ]; do
		(( HOURHAND++ ))
		XINT=$(flotToint $(echo "$(sin $HOURDEGREE) * $HOURHAND" | bc -l))
		YINT=$(flotToint $(echo "$(cos $HOURDEGREE) * $HOURHAND * $RATIO" | bc -l))
		tput cup $(echo "$XINT +   $LENGTH" | bc -l) $(echo "$YINT +  ($LENGTH * $RATIO)" | bc -l); printf "  "
	done

	# Draw minute hand
	MINUTEHAND=-6
	while [ $(( (LENGTH * 8) /10 )) -gt $MINUTEHAND ]; do
		(( MINUTEHAND++ ))
		XINT=$(flotToint $(echo "$(sin $MINUTEDEGREE) * $MINUTEHAND" | bc -l))
		YINT=$(flotToint $(echo "$(cos $MINUTEDEGREE) * $MINUTEHAND * $RATIO" | bc -l))
		tput cup $(echo "$XINT +   $LENGTH" | bc -l) $(echo "$YINT +  ($LENGTH * $RATIO)" | bc -l); printf "  "
	done
	
	if (( DRAWSECONDS )); then
		# Draw minute hand
		SECONDHAND=-8
		while [ $(( (LENGTH * 9) /10 )) -gt $SECONDHAND ]; do
			(( SECONDHAND++ ))
			XINT=$(flotToint $(echo "$(sin $SECONDDEGREE) * $SECONDHAND" | bc -l))
			YINT=$(flotToint $(echo "$(cos $SECONDDEGREE) * $SECONDHAND * $RATIO" | bc -l))
			tput cup $(echo "$XINT +   $LENGTH" | bc -l) $(echo "$YINT +  ($LENGTH * $RATIO)" | bc -l); printf "  "
		done
	fi
	
	# Reset cursor
	
done


# Offset the end input for any following text
tput cup $(( (LENGTH * 2) + 2 )) 0

exit