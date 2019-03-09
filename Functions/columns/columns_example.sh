#!/bin/sh

source  $(dirname $0)/columns.sh

tput reset
# Init
printf '\e[3J'

WINSIZE=$(tput cols) # buffer column number for spaces

COLA=$(echo "scale=0;($WINSIZE * 0.08 )/1" | bc )
COLB=$(echo "scale=0;($WINSIZE * 0.06 )/1" | bc )
COLC=$(echo "scale=0;($WINSIZE * 0.12 )/1" | bc )
COLD=$(echo "scale=0;($WINSIZE * 0.09 )/1" | bc )
COLE=$(echo "scale=0;($WINSIZE * 0.09 )/1" | bc )
COLF=$(echo "scale=0;($WINSIZE * 0.20 )/1" | bc )
COLG=$(echo "scale=0;($WINSIZE * 0.19 )/1" | bc )
COLH=$(echo "scale=0;($WINSIZE * 0.08 )/1" | bc )
COLI=$(echo "scale=0;($WINSIZE * 0.05 )/1" | bc )
COLJ=$(echo "scale=0;($WINSIZE * 0.04 )/1" | bc )


#printf "$(columndata  $COLA $COLA right)$(columndata $COLB $COLB right)$(columndata $COLC $COLC centre)$(columndata $COLD $COLD right)$(columndata $COLE $COLE right)$(columndata $COLF $COLF centre)$(columndata $COLG $COLG centre)$(columndata $COLH $COLH centre)$(columndata $COLI $COLI right)$(columndata $COLJ $COLJ centre)\n"
hr
printf "${KBLD}$(columndata Entered $COLA right)$(columndata Tracking $COLB right)$(columndata Status $COLC centre)$(columndata "Date D-M-Y" $COLD right)$(columndata "Time H:M:S" $COLE right)$(columndata Key $COLF centre)$(columndata Path $COLG centre)$(columndata Reporter $COLH centre)$(columndata Log $COLI right)$(columndata Flag $COLJ centre)${KNRM}\n"
hr
	
	
LOOP=0
for X in {1..100}; do
	NEWLINE=""

	NEWLINE="$NEWLINE$(columndata $(date +"%Y-%m%d") $COLA right)"
	
	NEWLINE="$NEWLINE$(columndata $(printf "%05d" $RANDOM) $COLB right)"
	
	if [ $(( RANDOM % 2 )) -eq 0 ]; then
		NEWLINE="$NEWLINE$(columndata Success $COLC centre)"
	else
		NEWLINE="$NEWLINE$(columndata Failure $COLC centre)"
	fi
	
	NEWLINE="$NEWLINE$(columndata $(printf %02d-%02d-%04d $(( (RANDOM% 12) +1 )) $(( (RANDOM % 31) +1 )) $(( RANDOM % 2018 )) ) $COLD right)"
	
	NEWLINE="$NEWLINE$(columndata $(printf %3d:%02d:%02d $(( RANDOM% 1000 )) $(( RANDOM % 100 )) $(( RANDOM % 99 )) ) $COLE right)"
	
	NEWLINE="$NEWLINE$(columndata $(openssl rand -base64 12) $COLF centre)"
	
	PATHS="$(ls / )"
	PATHRDM=$(( RANDOM % $(ls / |wc -l) ))
	PATHNAME=$( sed -n -e  "$PATHRDM  p" <<< $"$PATHS")
	NEWLINE="$NEWLINE$(columndata "/$PATHNAME" $COLG left)"
	
	NAMECOUNT=$(cat /usr/share/dict/propernames|wc -l)
	NAMERPICK=$(( RANDOM % NAMECOUNT ))
	NAME=$(sed -n -e  "$NAMERPICK  p" /usr/share/dict/propernames)
	NEWLINE="$NEWLINE$(columndata "$NAME" $COLH centre)"
	
	NEWLINE="$NEWLINE$(columndata $(printf "%3d" $RANDOM) $COLI right)"

	if [ $(( RANDOM % 2 )) -eq 0 ]; then
		NEWLINE="$NEWLINE$(columndata "x" $COLJ centre	)"
	else
		NEWLINE="$NEWLINE$(columndata " " $COLJ centre)"
	fi

	printf "$NEWLINE\n"
	
	(( LOOP++ ))
done

hr

exit 0
