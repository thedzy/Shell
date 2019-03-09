#!/bin/sh

source  $(dirname $0)/message_box.sh

tput reset
printf '\e[3J'


ls -GoOpa ~/

# Contune example
OPT=0
until [ "${OPT/Y/y}" == "y" ] || [ "${OPT/N/n}" == "n" ]; do
	messagebox "WOULD YOU LIKE TO CONTUNE (Y/N)?" 0 5  058 191
	read -n 1 -s OPT
	OPT=${OPT:-0}
done

[ "${OPT/Y/y}" == "y" ] && printf "Continuing ...\n\n\n" || printf "Breaking ...\n\n\n" 

exit 0
