#!/bin/sh

# Uncomment to require at least one parameter else throw help
#[[ ! $@ =~ ^\-.+ ]] && HELP=true

# Parse arguments/parameters (Only the ones specified on the next line)
# Question mark prevents parameters required
while getopts ":o:i:c?:b?:v?:h?:" opt; do
	case $opt in
	o)
		# Store an option
		OUTFILE="$OPTARG" >&2
		;;
	i)
		# Store multiple infiles
		INFILES+=( "$OPTARG" ) >&2
		;;
    c)
    	# Store True if seen
		COLOUR=true >&2
		;;
    b)
    	# Store False if seen
		BLACK=false >&2
		;;
	v)
		# Store how many times the option is chosen
		(( VERBOSE++ ))
		;;
    h)
		HELP=true
		;;
    \?)
		echo "Invalid option: -$OPTARG" >&2
		exit 1
		;;
    :)
		echo "Option -$OPTARG requires an argument." >&2
		exit 1
		;;
	esac
done

##########################################################################################
# Help
################

if ( ${HELP:-false} ) then
	printf "\n"

	# NAME
	printf "${KBLD}[NAME]${KNRM}\n"
	printf "\t%s\n\n" \
		"$(basename ${0%.*})"
	
	# SYNOPSIS
	printf "${KBLD}[SYNOPSIS]${KNRM}\n"
	printf "\t%s\n\n" \
		"$(basename $0) -o [file] -i [file] -cbv"
	
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