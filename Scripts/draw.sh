#!/bin/sh

tput reset
printf '\e[3J'
printf '\033[?7l'

##########################################################################################
# thedzy
# Author: thedzy
# Date: 2018-09-30
# Platform: MacOS
#
# Description
#		Drawing, move the cursor and use the options (in help) to change
#
# Versions
# 1.	Draw
#		
#
# Parameters
#		None
#
# Known Bugs
# 		If it can't keep up it sometime print a control code on the screen
#
##########################################################################################



# Initialise Variables
XPOSA=0; YPOSA=0
XPOSB=0; YPOSB=0
XPOSC=0; YPOSC=0
COLOURPICK=0
COLOUR=256

# Get screen resolution
SCREENX=$(( $(tput cols) - 1 ))
SCREENY=$(( $(tput lines) - 2 ))

help() {
	tput cup 0 $SCREENX
	tput rin 1; tput indn 1
	screen -L -m  -S help bash -c 'Printf "
	
    >> Help <<
    ╔═══════════════════════════════════════════════════╗
    ║   Key     Function                                ║
    ╠═══════════════════════════════════════════════════╣
    ║    ↑      Draw Up                                 ║
    ║    ↓      Draw Down                               ║
    ║    ←      Draw Left                               ║
    ║    →      Draw Right                              ║
    ║                                                   ║
    ║    0-255  Change Colour                           ║
    ║                                                   ║
    ║    H      Help screen                             ║
    ║    G      Erase screen and draw grid              ║
    ║    C      Clear screen                            ║
    ║    E      Eraser                                  ║
    ║    M      Free Movement                           ║
    ║    T      Type text and hit <enter>               ║
    ║    Q      Quit                                    ║
    ║                                                   ║
    ╚═══════════════════════════════════════════════════╝
	
	Press any key to exit";read -rsn1 EXIT' &>/dev/null
}

help

# Loop til the end
while read -rsn1 OPT # Read one key (first byte in key press)
do
	# Get screen resolution and update if changed
	SCREENX=$(( $(tput cols) - 1 ))
	SCREENY=$(( $(tput lines) - 2 ))
	
	# Get key presses
    case "$OPT" in
    $'\x1b') # ESC
    
    	# Move 2nd last know position to 3rd
    	XPOSC=$XPOSB; YPOSC=$YPOSB
		# Move last position to 2nd last known
		XPOSB=$XPOSA; YPOSB=$YPOSA
		
		# If the colour change changed update the colour
		[ $COLOURPICK -gt 0 ] && [ $COLOURPICK -le 255 ] && COLOUR=$COLOURPICK
		COLOURPICK=0
		
		# Check for cursor movement
        read -rsn1 OPT
        [ "$OPT" == "" ] && continue   # Esc-Key
        [ "$OPT" == "[" ] && read -rsn1 OPT
        [ "$OPT" == "O" ] && read -rsn1 OPT
        case "$OPT" in
        A) # Up
            (( YPOSA-- ))
            ;;
        B) # Down
            (( YPOSA++ ))
            ;;
        C) # Right
        	(( XPOSA++ ))
        	;;    
        D) # Left
        	(( XPOSA-- ))
        	;;
        esac
        ;;
    [0-9]) # Start calculating a new colour
    	COLOURPICK=$(( ( COLOURPICK * 10 ) + OPT ))
    	[ $COLOURPICK -gt 256 ] && COLOURPICK=0
    	tput cup $(( SCREENY + 1 )) $(( SCREENX - 3 ))
    	printf "\e[48;5;${COLOURPICK}m %3d\e[0m" $COLOURPICK
    	;;
    c|C) # Clear the screen
    	clear
    	COLOUR=256
    	;;
    e|E) # Clear the screen
    	COLOUR=257
    	tput cup $(( SCREENY + 1 )) $(( SCREENX - 3 ))
    	printf " Ers"
    	;;
    m|M) # Clear the screen
    	COLOUR=256
    	tput cup $(( SCREENY + 1 )) $(( SCREENX - 3 ))
    	printf " Mve"
    	;;
    g|G) # draw grid
    	tput cup 0 0
    	[ $COLOURPICK -gt 0 ] && [ $COLOURPICK -le 255 ] && COLOUR=$COLOURPICK
    	COLOURPICK=0
    	printf "\e[38;5;${COLOUR}m"
    	for GRIDY in $(seq 0 $SCREENY); do
    		for GRIDX in $(seq 0 $SCREENX); do
    			if [ $(( GRIDX % 10 )) -eq 0 ]; then
    				[ $(( GRIDY % 5 )) -eq 0 ] && printf "┼" || printf "┊"
    			else
    				[ $(( GRIDY % 5 )) -eq 0 ] && printf "┈" || printf " "
    			fi
    		done
    		printf "\n"
    	done
    	printf "\e[0m"
    	COLOUR=256
    	;;
    h|H)
    	help
    	;;
    t|T) # Start accepting type and display it, with updated colour
    	[ $COLOURPICK -gt 0 ] && [ $COLOURPICK -le 255 ] && COLOUR=$COLOURPICK
		COLOURPICK=0
		tput cup $(( SCREENY + 1 )) 55
    	read OPT
    	tput rin 1
    	tput cup $YPOSA $XPOSA
    	printf "\e[38;5;${COLOUR}m$OPT\e[0m"
    	COLOUR=256
    	;;
    q|Q)	# Exit
    	tput cup $(( SCREENY + 2 )) 0
    	break
    	;;
    esac
    
    # Print status bar
    tput cup $(( SCREENY + 1 )) 0
    BUFFER=$(( SCREENX - 73 ))
    KBKW="\e[0m\e[48;5;255m\e[38;5;232m"
    KBLD="\033[34;1m"
    printf "${KBKW} ${KBLD}C${KBKW}lear | ${KBLD}G${KBKW}rid | ${KBLD}E${KBKW}rase | ${KBLD}M${KBKW}ove | ${KBLD}T${KBKW}ype | ${KBLD}H${KBKW}elp | ${KBLD}Q${KBKW}uit%${BUFFER}s %3d,%3d | COLOUR:\e[48;5;${COLOUR}m %3d\e[0m" " " $YPOSA $XPOSA $COLOUR
    
    # Keep XY positions in range
    [ $XPOSA -lt 0 ] && XPOSA=0
    [ $XPOSA -ge $SCREENX ] && XPOSA=$SCREENX
    
    [ $YPOSA -lt 0 ] && YPOSA=0
    [ $YPOSA -gt $SCREENY ] && YPOSA=$SCREENY
    
    # Move cursor into position
	tput cup $YPOSA $XPOSA

	# Draw lines and redraw angles
	printf "\e[38;5;${COLOUR}m"
	if [ $COLOUR -ne 256 ]; then
		[ $COLOUR -eq 257 ] && printf " " && tput cub1 && continue
		if [ $XPOSA -gt $XPOSB ]; then
			printf "━"
			[ $YPOSC -gt $YPOSA ] && tput cup $YPOSB $XPOSB && printf "┏"
			[ $YPOSC -lt $YPOSA ] && tput cup $YPOSB $XPOSB && printf "┗"
		fi
		if [ $XPOSA -lt $XPOSB ]; then
			printf "━"
			[ $YPOSC -gt $YPOSA ] && tput cup $YPOSB $XPOSB && printf "┓"
			[ $YPOSC -lt $YPOSA ] && tput cup $YPOSB $XPOSB && printf "┛"
		fi
	
		if [ $YPOSA -gt $YPOSB ]; then
			printf "┃"
			[ $XPOSC -gt $XPOSA ] && tput cup $YPOSB $XPOSB && printf "┏"
			[ $XPOSC -lt $XPOSA ] && tput cup $YPOSB $XPOSB && printf "┓"
		fi
		if [ $YPOSA -lt $YPOSB ]; then
			printf "┃"
			[ $XPOSC -gt $XPOSA ] && tput cup $YPOSB $XPOSB && printf "┗"
			[ $XPOSC -lt $XPOSA ] && tput cup $YPOSB $XPOSB && printf "┛"
		fi
		printf "\e[0m"
		tput cup $YPOSA $XPOSA
		
	fi
	
	
done

printf "\e[0m"
printf "\n\n"

exit 0