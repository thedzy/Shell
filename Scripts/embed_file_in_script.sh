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
#		Creates a script that will generate a file when run.  Can be used to create
#		starter scripts to embed files that will be needed during it's run.
#
# Versions
# 1.	Creates a file that emeds another file
#		
#
# Parameters
# -h|help		Help
# -f|file		File and path to embed
# -s|script		Script and paths file to create
# -o|outfile	File and path created when the script runs
#
# Known Bugs
# 
#
##########################################################################################
#
# Exit Codes
#	0. Success/Help
#	1. Bad parameter
#	3. Missing parameter
#
#
##########################################################################################

##########################################################################################
# Traps
################

ExitTrap () {
	# Exit code/cleanup
	
	

	# Clean up tmpdir
	rm -rf "$TMPDIR" || printf "Error removing temporary directory $TMPDIR\n"

	# Restore formatting
	printf "${KNRM}"
	
	# Restore the cursor
	tput cnorm
	
	#printf "Exiting $1\n"
	exit $1
}
trap 'ExitTrap $?' INT EXIT TERM


##########################################################################################
# Environment setup
################

# Global Variables
BASEPATH="$(dirname $0)"
BASENAME="$(basename $0)"

INPUTFILE=""
SCRIPTFILE=""
OUTFILE=""

# Create temporary and working diorectory
WRKDIR="$TMPDIR"
TMPDIR="/tmp/$BASENAME."$(openssl rand -hex 12)
mkdir -p -m 777 "$TMPDIR"

# Colours (ex. ${KBLD}Bold Text${KNRM})
KNRM="\x1B[0m"
KRED="\x1B[31m"
KGRN="\x1B[32m"
KYEL="\x1B[33m"
KBLU="\x1B[34m"
KMAG="\x1B[35m"
KCYN="\x1B[36m"
KWHT="\x1B[37m"

KBLD="\033[1m"
KNRM="\033[0m"

# Default values
LOGGING=0

# Set window Title
printf "\033]0;${BASENAME%%.*}\007"

# Hide the cursor for the run of the script
tput civis


##########################################################################################
# Arguments
################

# Uncomment to require at least one parameter else throw help
[[ ! $@ =~ ^\-.+ ]] && HELP=true

while [[ $# > 0 ]]
do
    key="$1"
    case $key in
        -f|--file)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                INPUTFILE=$nextArg
                if [ ! -d "$(dirname "$INPUTFILE")" ]; then
					printf "Invalid file path: %s\n" "$INPUTFILE"
					exit 2
				fi
                if ! [[ "$2" =~ -.* ]]; then
                    shift
                    nextArg="$2"
                else
                    shift
                    break
                fi
            done
        ;;
        -s|--script)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                SCRIPTFILE=$nextArg
                if [ ! -d "$(dirname "$SCRIPTFILE")" ]; then
					printf "Invalid script path: %s\n" "$SCRIPTFILE"
					exit 2
				fi
                if ! [[ "$2" =~ -.* ]]; then
                    shift
                    nextArg="$2"
                else
                    shift
                    break
                fi
            done
        ;;
        -o|--outfile)
            nextArg="$2"
            while ! [[ "$nextArg" =~ -.* ]] && [[ $# > 1 ]]; do
                OUTFILE=$nextArg
                if ! [[ "$2" =~ -.* ]]; then
                    shift
                    nextArg="$2"
                else
                    shift
                    break
                fi
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
		"$(basename $0) -h -f /path/to/file -s /path/to/file -o /path/to/file"
	
	# DESCRIPTION
	printf "${KBLD}[DESCRIPTION]${KNRM}\n"
	printf "\t%s\n\n" \
		"Creates a script that will generate a file when run.  Can be used to create starter scripts to embed files that will be needed during it's run. " | \
		fmt -p -w $(tput cols)

	# OPTIONS
	printf "${KBLD}[OPTIONS]${KNRM}\n"
	printf "\t%s\t%s\n" \
		"h|help" "Bring up this help message" \
		"f|file"		"File and path to embed" \
		"s|script"		"Script and paths file to create" \
		"o|outfile"	"File and path created when the script runs" \
	
	printf "\n\n"
	exit 0
fi


##########################################################################################
# Functions
################






##########################################################################################
# Main
################

if [ "$INPUTFILE" == "" ] || [ "$SCRIPTFILE" == "" ] || [ "$OUTFILE" == "" ]; then
	echo "Missing paramter"
	printf "Inout file:  $INPUTFILE\n"
	printf "Script file: $SCRIPTFILE\n"
	printf "Output file: $OUTFILE\n"
	exit 3
fi

cat <<CODE > "/tmp/$TMPFILE.sh"
#!/bin/sh

# Creates file '$OUTFILE ' when run
cd /tmp

cat > "file.bin" <<-"EMBEDFILE"
CODE
uuencode "$INPUTFILE" "$(basename "$INPUTFILE")" >> "/tmp/$TMPFILE.sh"
cat <<CODE >> "/tmp/$TMPFILE.sh"
EMBEDFILE

# Unpack and remove file
uudecode file.bin
rm file.bin

mv "/tmp/$(basename "$INPUTFILE")" '$OUTFILE'

exit 0
CODE

chmod a+x "/tmp/$TMPFILE.sh"
cp "/tmp/$TMPFILE.sh" "$SCRIPTFILE"

echo "Embedded $INPUTFILE in $SCRIPTFILE"
echo "When run it will create $OUTFILE"



exit 0