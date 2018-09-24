#!/bin/sh

headline () {
	# http://patorjk.com/software/taag/#p=testall&h=0&v=0&f=Modular&t=ABCDEFGHIJKLMNOPQRSTUVWXYZ
	
	WINCOLS=$(tput cols)
	WINROWS=$(tput lines)
	
	# Character sets
	LETTERSET=( '.' {A..Z} '?' '!' ',')
	LETTERHGT=9	#Average
	#LETTERWID  . a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  ?  ! , .
	LETTERWID=( 3 14 11 12 13 12 11 13 14 6  9  13 12 16 13 13 11 13 12 10 13 14 14 22 13 12 10 10 3 3 3 0) # height a and width of letters
	LETTERDES=(
		'         db      `7MM"""Yp,   .g8"""bgd `7MM"""Yb.   `7MM"""YMM  `7MM"""YMM   .g8"""bgd  `7MMF*  `7MMF*`7MMF*   `7MMF*`7MMF* `YMM* `7MMF*      `7MMM.     ,MMF*`7MN.   `7MF*  .g8""8q.   `7MM"""Mq.   .g8""8q.   `7MM"""Mq.   .M"""bgd MMP""MM""YMM `7MMF*   `7MF*`7MMF*   `7MF*`7MMF*     A     `7MF*`YMM*   `MP* `YMM*   `MM*MMM"""AMV ,M"""b.   OO          '
		'        ;MM:       MM    Yb .dP*     `M   MM    `Yb.   MM    `7    MM    `7 .dP*     `M    MM      MM    MM       MM    MM   .M*     MM          MMMb    dPMM    MMN.    M  .dP*    `YM.   MM   `MM..dP*    `YM.   MM   `MM. ,MI    "Y P*   MM   `7   MM       M    `MA     ,V    `MA     ,MA     ,V    VMb.  ,P     VMA   ,V  M*   AMV  89*  `Mg  88          '
		'       ,V^MM.      MM    dP dM*       `   MM     `Mb   MM   d      MM   d   dM*       `    MM      MM    MM       MM    MM .d"       MM          M YM   ,M MM    M YMb   M  dM*      `MM   MM   ,M9 dM*      `MM   MM   ,M9  `MMb.          MM        MM       M     VM:   ,V      VM:   ,VVM:   ,V      `MM.M*       VMA ,V   *   AMV        ,M9  ||          '
		'      ,M  `MM      MM"""bg. MM            MM      MM   MMmmMM      MM""MM   MM             MMmmmmmmMM    MM       MM    MMMMM.       MM          M  Mb  M* MM    M  `MN. M  MM        MM   MMmmdM9  MM        MM   MMmmdM9     `YMMNq.      MM        MM       M      MM.  M*       MM.  M* MM.  M*        MMb         VMMP       AMV      mMMY*   ||          '
		'      AbmmmqMA     MM    `Y MM.           MM     ,MP   MM   Y  ,   MM   Y   MM.    `7MMF*  MM      MM    MM       MM    MM  VMA      MM      ,   M  YM.P*  MM    M   `MM.M  MM.      ,MP   MM       MM.      ,MP   MM  YM.   .     `MM      MM        MM       M      `MM A*        `MM A*  `MM A*       ,M*`Mb.        MM       AMV   ,   MM      `*          '
		',,   A*     VML    MM    ,9 `Mb.     ,*   MM    ,dP*   MM     ,M   MM       `Mb.     MM    MM      MM    MM  (O)  MM    MM   `MM.    MM     ,M   M  `YM*   MM    M     YMM  `Mb.    ,dP*   MM       `Mb.    ,dP*   MM   `Mb. Mb     dM      MM        YM.     ,M       :MM;          :MM;    :MM;       ,P   `MM.       MM      AMV   ,M   ,,      ,,  ,,      '
		'db .AMA.   .AMMA..JMMmmmd9    `"bmmmd*  .JMMmmmdP*   .JMMmmmmMMM .JMML.       `"bmmmdPY  .JMML.  .JMML..JMML. Ymmm9   .JMML.   MMb..JMMmmmmMMM .JML. `*  .JMML..JML.    YM    `"bmmd"*   .JMML.       `"bmmd"*   .JMML. .JMM.P"Ybmmd"     .JMML.       `bmmmmd"*        VF            VF      VF      .MM:.  .:MMa.   .JMML.   AMVmmmmMM   db      db  dg      '
		'                                                                                                                                                                                                       MMb                                                                                                                                             ,j      '
		'                                                                                                                                                                                                        `bood*                                                                                                                                        ,*       '
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
