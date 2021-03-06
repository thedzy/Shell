#!/bin/sh
#
# SCRIPT:	headline15c.sh
# AUTHOR:	thedzy <thedzy@hotmail.com>
# DATE:		2018-09-24
# REV:		15.0c
#
# PLATFORM: MacOS
#
# PURPOSE:
#	Print title/banner
#
# FUNCTIONS: 
#	headline()
# PARAMETERS: 
#	$@ Text to  print
#

headline () {
	# http://patorjk.com/software/taag/#p=testall&h=0&v=0&f=Modular&t=ABCDEFGHIJKLMNOPQRSTUVWXYZ
	
	WINCOLS=$(tput cols)
	WINROWS=$(tput lines)
	
	# Character sets
	LETTERSET=( '.' {A..Z} '!' ',')
	LETTERHGT=5	#Average
	#LETTERWID  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  ?  ! , .
	LETTERWID=( 2 6  6  5  7  5  4  5  6  3  5  5  5  9  5  6  5  6  5  6  5  5  5  8  6  6  6  9  9 3 3 3 0) # height a and width of letters
	LETTERDES=(
		'   ▄▄▄· ▄▄▄▄·  ▄▄· ·▄▄▄▄  ▄▄▄ .·▄▄▄ ▄▄ •  ▄ .▄▪   ▐▄▄▄▄ •▄ ▄▄▌  • ▌ ▄ ·.  ▐ ▄        ▄▄▄·.▄▄▄  ▄▄▄  .▄▄ · ▄▄▄▄▄▄• ▄▌ ▌ ▐·▄▄▌ ▐ ▄▌▐▄• ▄  ▄· ▄▌·▄▄▄▄•     ▐ '
		'  ▐█ ▀█ ▐█ ▀█▪▐█ ▌▪██▪ ██ ▀▄.▀·▐▄▄·▐█ ▀ ▪██▪▐███   ·███▌▄▌▪██•  ·██ ▐███▪•█▌▐█▪     ▐█ ▄█▐▀•▀█ ▀▄ █·▐█ ▀. •██  █▪██▌▪█·█▌██· █▌▐█ █▌█▌▪▐█▪██▌▪▀·.█▌     ▌'
		'  ▄█▀▀█ ▐█▀▀█▄██ ▄▄▐█· ▐█▌▐▀▀▪▄██▪ ▄█ ▀█▄██▀▐█▐█·▪▄ ██▐▀▀▄·██▪  ▐█ ▌▐▌▐█·▐█▐▐▌ ▄█▀▄  ██▀·█▌·.█▌▐▀▀▄ ▄▀▀▀█▄ ▐█.▪█▌▐█▌▐█▐█•██▪▐█▐▐▌ ·██· ▐█▌▐█▪▄█▀▀▀•     ▐'
		'  ▐█ ▪▐▌██▄▪▐█▐███▌██. ██ ▐█▄▄▌██▌.▐█▄▪▐███▌▐▀▐█▌▐▌▐█▌▐█.█▌▐█▌▐▌██ ██▌▐█▌██▐█▌▐█▌.▐▌▐█▪·•▐█▪▄█·▐█•█▌▐█▄▪▐█ ▐█▌·▐█▄█▌ ███ ▐█▌██▐█▌▪▐█·█▌ ▐█▀·.█▌▪▄█▀     █'
		'▀  ▀  ▀ ·▀▀▀▀ ·▀▀▀ ▀▀▀▀▀•  ▀▀▀ ▀▀▀ ·▀▀▀▀ ▀▀▀ ·▀▀▀ ▀▀▀•·▀  ▀.▀▀▀ ▀▀  █▪▀▀▀▀▀ █▪ ▀█▄▀▪.▀   ·▀▀█. .▀  ▀ ▀▀▀▀  ▀▀▀  ▀▀▀ . ▀   ▀▀▀▀ ▀▪•▀▀ ▀▀  ▀ • ·▀▀▀ •     ▀ '
 	)                                                                                   
	  
	# Get words and spaces
	WORD="${@}"
	SPACE=$(( ${LETTERWID[1]} / 2 )) 
	tput sc
	
	STARTWID=0 # Start Width
	CNTLINES=0 # Line counter

	for LETTERNUM in $( seq 0 $(( ${#WORD} -1 )) ); do
		tput rc															# Save cursor positoin
		LETTER=${WORD:LETTERNUM:1} 										# Get letter from WORD (string)
		if [ "$LETTER" == " " ]; then									# If letter is space skip
			(( STARTWID+=SPACE ))
			tput cud $LETTERHGT
			continue
		fi
		LETTER=$(tr [:lower:] [:upper:] <<< $LETTER)					# Convert to supper to match position
		LETTERIDX=$(echo ${LETTERSET[@]}|sed "s/${LETTER}.*//"|wc -w)		# Get position
		LETTERSUM="${LETTERWID[@]:0:LETTERIDX}"
		LETTERSUM=$( echo "0${LETTERSUM// /+}+0" |bc)
		#LETTERIDX=$( echo "0${LETTERSUM// /+}+0" |bc)				# Get potion in LETTERDES

		if [ $(( STARTWID + LETTERWID[LETTERIDX] )) -ge $WINCOLS ]; then
			tput cud $LETTERHGT
			tput sc

			STARTWID=0
			(( CNTLINES++ ))
			if [ $CNTLINES -ge $(( ( WINROWS / LETTERHGT ) - 1 )) ]; then
				sleep 2
				clear
				tput sc
				CNTLINES=0
			fi
		fi
		
		# For each line in letter hight move to letter position and draw
		for INDEX in $( seq 0 ${LETTERHGT} ); do
			LINE=${LETTERDES[INDEX]}
			[ $STARTWID -ne 0 ] && tput cuf $STARTWID
			printf "${LINE:LETTERSUM:LETTERWID[LETTERIDX]}\n"
		done

		STARTWID=$(( STARTWID + ${LETTERWID[LETTERIDX]} ))
	done
}
