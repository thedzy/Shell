#!/bin/sh

# Uncomment to require at least one parameter else throw help
#[[ ! $@ =~ ^\-.+ ]] && HELP=true

while [[ $# > 0 ]]
do
	KEY="$1"
	case $KEY in
		-o|--outfile)
			OUTFILE="$2"
			shift
		;;
		-i|--infile)
			NEXTARG="$2"
			while ! [[ "$NEXTARG" =~ -.* ]] && [[ $# > 1 ]]; do
				INFILES+=($NEXTARG)
				if ! [[ "$2" =~ -.* ]]; then
					shift
					NEXTARG="$2"
				else
					shift
					break
				fi
			done
		;;
		-c|--colour)
			COLOUR=true
		;;
		-b|--black)
			BLACK=false
		;;
		-v|--verbose)
			VERBOSE=1
		;;
		-vv|--verboser)
			VERBOSE=2
		;;
		-vvv|--verbosest)
			VERBOSE=3
		;;
		-h|--help)
			HELP=true
		;;
		*)
			echo "Unknown flag $KEY"
			exit 1
		;;
	esac
	shift
done

##########################################################################################
# Help
################

if ( ${HELP:-false} ); then
	printf "\n"

	# NAME
	printf "${KBLD}[NAME]${KNRM}\n"
	printf "\t%s\n\n" \
		"$(basename ${0%.*})"
	
	# SYNOPSIS
	printf "${KBLD}[SYNOPSIS]${KNRM}\n"
	printf "\t%s\n\n" \
		"$(basename $0) -o [file] -i [file] -c -b -v"
	
	# DESCRIPTION
	printf "${KBLD}[DESCRIPTION]${KNRM}\n"
	printf "\t%s\n\n" \
		"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Supports line wraping " | \
		fmt -p -w $(tput cols)

	# OPTIONS
	printf "${KBLD}[OPTIONS]${KNRM}\n"
	printf "\t%s\t%s\n" \
		"o" "OutFile: The file that will be created" \
		"i" "InFile: The files that will read the create the result, can be used mutliple times" \
		"c" "Colour output, not compatible with -b"\
		"b" "Black output, not compatible with -c" \
		"v" "More v's more verbose" \
	
	
	printf "\n\n"
	exit 0
fi

##########################################################################################
# Main
################


if ! ( ${COLOUR:-false} ); then
	printf "Colour      : False\n"
else
	printf "Colour      : True\n"
fi

if ( ${BLACK:-true} ); then
	printf "Black       : True\n"
else
	printf "Black       : False\n"
fi

if [ ${VERBOSE:-0} -eq 0 ]; then
	printf "Debug level : Off\n"
elif [ $VERBOSE -eq 1 ]; then
	printf "Debug level : %d\n" $VERBOSE
elif [ $VERBOSE -eq 2 ]; then
	printf "Debug level : %d\n" $VERBOSE
else
	printf "Debug level : Max\n"
fi

printf "InFiles     : ${INFILES[*]}\n"
printf "OutFile     : $OUTFILE\n"


exit 0