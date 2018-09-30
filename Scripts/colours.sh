#!/bin/sh


tput reset
printf '\e[3J'

##########################################################################################
# thedzy
# Author: thedzy
# Date: 2018-09-29
# Platform: MacOS
#
# Description
#		Create a colour gradient
#		Shows all 256 term colours (grid option)
#
# Versions
# 1.	Spefify the start and the stop colour in RGB and steps
# 2.	Display in a grid
# 3.	Display single colour
#		
#
# Parameters
# -h			Help
# -s|start		Start rgb values separated by spaces
# -e|end		End rgb values separated by spaces
# -n|steps		Steps from beginning to end
# -u|Uunique	Display only unique values
# -g|grid		Display a grid of colours (6 modes)
#
# Known Bugs
# 1. Gradients are now showing a colour at the front before the others and its mostly black
#
##########################################################################################
#
# Exit Codes
# 1. Bad parameter
#
##########################################################################################

##########################################################################################
# Environment setup
################

# Defaults values
NEWRGB=0
OLDRGB=0
STEPS=0
UNIQUE=0
GRID=-1


# Format Styles
KBLD="\033[1m"
KNRM="\033[0m"

##########################################################################################
# Arguments
################

# Uncomment to require at least one parameter else throw help
[[ ! $@ =~ ^\-.+ ]] && HELP=true

while [[ $# > 0 ]]
do
    key="$1"
    case $key in
        -s|--start)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                RGBB+=($nextArg)
                if ! [[ "$2" =~ -.* ]]; then
                    shift
                    nextArg="$2"
                else
                    shift
                    break
                fi
            done
        ;;
        -e|--end)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                RGBA+=($nextArg)
                if ! [[ "$2" =~ -.* ]]; then
                    shift
                    nextArg="$2"
                else
                    shift
                    break
                fi
            done
        ;;
        -n|--steps)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                STEPS=$nextArg
                shift
                break
            done
        ;;
        -u|--unique)
            UNIQUE=1
        ;;
        -h|--help)
            HELP=true
        ;;
        -g|--grid)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                GRID=$nextArg
                # Defaults Grid
				GRID=${GRID/[^0-9]/0}
                shift
                break
            done

        ;;
        *)
            echo "Unknown flag $key"
            exit 1
        ;;
    esac
    shift
done

##########################################################################################
# Arguments Validation
################

# Parse through RGB arrays
for VARNAME in ${!RGB@}; do
	eval VARARRY=\( \${${VARNAME}[@]} \)
	for VALUE in ${VARARRY[@]}; do
		[ $VALUE -gt 256 ] && printf "RGB value above 255\n" && exit 1
	done
	
	# Validate RGBB
	if [ ${#VARARRY[@]} -lt 3 ] && [ ${#VARARRY[@]} -gt 0 ] ; then
		printf "Option -s/--start and -e/--end requires 3 parameters\n"
		exit 1
	elif [ ${#VARARRY[@]} -gt 3 ] && [ ${#VARARRY[@]} -gt 0 ]; then
		printf "Option -s/--start and -e/--end take 3 parameters\n"
		exit 1
	fi
done

# Default RGBB
if [ ${#RGBB[@]} -eq 0 ]; then
 	RGBB=( 0 0 0 )
fi
# Default RGBA
if [ ${#RGBA[@]} -eq 0 ]; then
	RGBA=( 255 255 255 )
fi

# Default Steps
[ $STEPS -le 0 ] || [ $STEPS -gt $(( $(tput cols) / 5 )) ] && STEPS=$(( $(tput cols) / 5 ))
[ $STEPS -lt 2 ] && STEPS=2

#Grid limit to 5
[ $GRID -gt 5 ] && GRID=0

##########################################################################################
# Help
################

if ( ${HELP:-false} ) then
	printf "\n"

	# NAME
	printf "${KBLD}[NAME]${KNRM}\n"
	printf "\t%s\n\n" \
		$(basename "${0%.*}")
	
	# SYNOPSIS
	printf "${KBLD}[SYNOPSIS]${KNRM}\n"
	printf "\t%s\n\n" \
		$(basename "$0")" -ehnsu"
	
	# DESCRIPTION
	printf "${KBLD}[DESCRIPTION]${KNRM}\n"
	printf "\t%s\n\n" \
		"Creates a gradient from two colours" \
		| fmt -p -w $(tput cols)

	# OPTIONS
	printf "${KBLD}[OPTIONS]${KNRM}\n"
	printf "\t%s\t%s\n" \
		"-h --help" "Bring up this help message" \
		"-s --start" "The start RGB value seperated by spaced (ex. 0 0 0)" \
		"-e --end" "The end RGB value seperated by spaced (ex. 255 255 255)" \
		"-n --steps" "Bring up this help message" \
		"-u --unique" "Display only unique values" \
		"-g --grid" "Display only a grid of colours in one of 6 modes (0-5)" \
	
	printf "\n\n"
	exit 0
fi

##########################################################################################
# Main
################

# If Grid was selected
if [ $GRID -ge 0 ]; then
	# Generate the colour pattern
	for A in {0..5}; do
		for B in {0..5}; do
			for C in {0..5}; do
				[ $GRID -eq 0 ] && NEWRGB=$(( 16 + 36 * A + 6 * B + C ))
				[ $GRID -eq 1 ] && NEWRGB=$(( 16 + 36 * A + 6 * C + B ))
				[ $GRID -eq 2 ] && NEWRGB=$(( 16 + 36 * B + 6 * A + C ))
				[ $GRID -eq 3 ] && NEWRGB=$(( 16 + 36 * B + 6 * C + A ))
				[ $GRID -eq 4 ] && NEWRGB=$(( 16 + 36 * C + 6 * A + B ))
				[ $GRID -eq 5 ] && NEWRGB=$(( 16 + 36 * C + 6 * B + A ))
				[ $(( A + B + C )) -gt 5 ] && TEXT=16 || TEXT=256
				LINE1="${LINE1}"$(printf "\e[48;5;${NEWRGB}m\e[38;5;${TEXT}m %03d " $NEWRGB)
				LINE2="${LINE2}"$(printf "\e[48;5;${NEWRGB}m     ")
     		done
     		printf "${LINE2}\e[0m\n"
     		printf "${LINE1}\e[0m\n"
     		printf "${LINE2}\e[0m\n"
     		unset LINE1
     		unset LINE2
     	done
     done
     # Append the greys
     for COLOUR in {232..256}; do
			[ $COLOUR -gt 244 ] && TEXT=16 || TEXT=256
			LINE1="${LINE1}"$(printf "\e[48;5;${COLOUR}m\e[38;5;${TEXT}m %03d " $COLOUR)
			LINE2="${LINE2}\e[48;5;${COLOUR}m     "

			if [ $(( (COLOUR - 3) % 6 )) -eq 0 ]; then
				printf "${LINE2}\e[0m\n"
				printf "${LINE1}\e[0m\n"
				printf "${LINE2}\e[0m\n"
				unset LINE1
				unset LINE2
			fi
		done
	exit 0
fi

# Calculate the steps
for INDEX in $(seq 0 ${STEPS}); do
	[ $INDEX -ge $STEPS ] && break
	
	R=$(( ((( (${RGBA[0]}-${RGBB[0]}) / (STEPS - 1)) * INDEX) + ${RGBB[0]}) /51 ))
	G=$(( ((( (${RGBA[1]}-${RGBB[1]}) / (STEPS - 1)) * INDEX) + ${RGBB[1]}) /51 ))
	B=$(( ((( (${RGBA[2]}-${RGBB[2]}) / (STEPS - 1)) * INDEX) + ${RGBB[2]}) /51 ))
	
	# Generate a RGB VAlue
	#NEWRGB=$(( 16 + 36 * R + 6 * G + B ))
	NEWRGB=$(( ((R*6/5)*36 + (G*6/5)*6 + (B*6/5))+16 ))

	# Test if the value has changed and assign it
	if [ $NEWRGB -ne $OLDRGB ]; then
		# Prefill lines
		LINE1="${LINE1}\e[48;5;${NEWRGB}m     "
		LINE2=$(printf "${LINE2} %03d " ${NEWRGB} )
		[ $UNIQUE -ne 0 ] && OLDRGB=$NEWRGB
	fi

done

# Print lines
printf "${LINE1}\n"
printf "${LINE1}\n"
printf "${LINE1}\n"
printf "${KNRM}${KBLD}${LINE2}${KNRM}\n"

exit 0