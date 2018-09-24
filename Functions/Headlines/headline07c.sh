#!/bin/sh

headline () {
	# http://patorjk.com/software/taag/#p=testall&h=0&v=0&f=Modular&t=ABCDEFGHIJKLMNOPQRSTUVWXYZ
	
	WINCOLS=$(tput cols)
	WINROWS=$(tput lines)
	
	# Character sets
	LETTERSET=( '.' {A..Z} '?' '!' ',')
	LETTERHGT=9	#Average
	#LETTERWID  , a  b  c  d  e  f  g  h  i  j k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  ?  !  , 
	LETTERWID=( 3 13 13 11 11 13 13 13 15 5  8 12 11 16 10 11 13 12 13 13 12 11 11 12 16 10 13 12 5 3 0) # height a and width of letters
	LETTERDES=(
		'      ▄████████ ▀█████████▄   ▄████████ ████████▄     ▄████████    ▄████████    ▄██████▄     ▄█    █▄     ▄█       ▄█    ▄█   ▄█▄  ▄█          ▄▄▄▄███▄▄▄▄   ███▄▄▄▄    ▄██████▄     ▄███████▄ ████████▄      ▄████████    ▄████████     ███     ███    █▄   ▄█    █▄   ▄█     █▄  ▀████    ▐████▀ ▄██   ▄    ▄███████▄    ▄███████▄     ▄█       '
		'     ███    ███   ███    ███ ███    ███ ███   ▀███   ███    ███   ███    ███   ███    ███   ███    ███   ███      ███   ███ ▄███▀ ███        ▄██▀▀▀███▀▀▀██▄ ███▀▀▀██▄ ███    ███   ███    ███ ███    ███    ███    ███   ███    ███ ▀█████████▄ ███    ███ ███    ███ ███     ███   ███▌   ████▀  ███   ██▄ ██▀     ▄██  ██▀     ▄██   ███       '
		'     ███    ███   ███    ███ ███    █▀  ███    ███   ███    █▀    ███    █▀    ███    █▀    ███    ███   ███▌     ███   ███▐██▀   ███        ███   ███   ███ ███   ███ ███    ███   ███    ███ ███    ███    ███    ███   ███    █▀     ▀███▀▀██ ███    ███ ███    ███ ███     ███    ███  ▐███    ███▄▄▄███       ▄███▀        ▄███▀   ███       '
		'     ███    ███  ▄███▄▄▄██▀  ███        ███    ███  ▄███▄▄▄      ▄███▄▄▄      ▄███         ▄███▄▄▄▄███▄▄ ███▌     ███  ▄█████▀    ███        ███   ███   ███ ███   ███ ███    ███   ███    ███ ███    ███   ▄███▄▄▄▄██▀   ███            ███   ▀ ███    ███ ███    ███ ███     ███    ▀███▄███▀    ▀▀▀▀▀▀███  ▀█▀▄███▀▄▄      ▄███▀     ███       '
		'   ▀███████████ ▀▀███▀▀▀██▄  ███        ███    ███ ▀▀███▀▀▀     ▀▀███▀▀▀     ▀▀███ ████▄  ▀▀███▀▀▀▀███▀  ███▌     ███ ▀▀█████▄    ███        ███   ███   ███ ███   ███ ███    ███ ▀█████████▀  ███    ███  ▀▀███▀▀▀▀▀   ▀███████████     ███     ███    ███ ███    ███ ███     ███    ████▀██▄     ▄██   ███   ▄███▀   ▀      ██▀       █▀        '
		'     ███    ███   ███    ██▄ ███    █▄  ███    ███   ███    █▄    ███          ███    ███   ███    ███   ███      ███   ███▐██▄   ███        ███   ███   ███ ███   ███ ███    ███   ███        ███    ███  ▀███████████          ███     ███     ███    ███ ███    ███ ███     ███   ▐███  ▀███    ███   ███ ▄███▀                                '
		'▄▄   ███    ███   ███    ███ ███    ███ ███   ▄███   ███    ███   ███          ███    ███   ███    ███   ███      ███   ███ ▀███▄ ███▌    ▄  ███   ███   ███ ███   ███ ███    ███   ███        ███  ▀ ███    ███    ███    ▄█    ███     ███     ███    ███ ███    ███ ███ ▄█▄ ███  ▄███     ███▄  ███   ███ ███▄     ▄█     ███▄       ▄█        '
		'██   ███    █▀  ▄█████████▀  ████████▀  ████████▀    ██████████   ███          ████████▀    ███    █▀    █▀   █▄ ▄███   ███   ▀█▀ █████▄▄██   ▀█   ███   █▀   ▀█   █▀   ▀██████▀   ▄████▀       ▀██████▀▄█   ███    ███  ▄████████▀     ▄████▀   ████████▀   ▀██████▀   ▀███▀███▀  ████       ███▄  ▀█████▀   ▀████████▀      ▀██       █▀   █▀   '
		'                                                                                                              ▀▀▀▀▀▀    ▀         ▀                                                                      ██  ███    ███                                                                                                                     █▀   '
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

