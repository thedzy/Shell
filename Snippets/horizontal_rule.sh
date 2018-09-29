#!/bin/sh

HR=$(tput cols)
HR="$(printf "%${HR}s")"
HR=${HR// /-}
echo $HR


exit $?
