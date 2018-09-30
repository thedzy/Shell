#!/bin/sh

INTCOLS=$(tput cols)
INTROWS=$(tput lines)

# Trap a window resize and resturn the size
trap_resize(){
	# Size window size
	printf "\e[8;${INTROWS};${INTCOLS}t"
}
trap 'trap_resize' WINCH

# Do something
X=20
tput sc
while [ $X -gt 0 ]; do
	tput rc
	printf "Lockdown counter... $X  \n"
	sleep 1
	(( X-- ))
done