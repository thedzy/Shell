#!/usr/bin/env bash

source "$(dirname "$0")/time_components.sh"

SECONDS=$(( RANDOM ** 2 % 1000000))
TIME=($(time_components $SECONDS))

printf "%d seconds is eqivilant to:\n" $SECONDS
printf "%dday(s) %dhour(s) %dminute(s) %dsecond(s) \n" ${TIME[*]}
