#!/bin/sh

source "$(dirname "$0")/network.sh"

printf "\nIP Addresses\n"
getIPs

printf "\nTotal Addresses\n"
getIPcount

printf "\nFirst IP Address\n"
getIP 0

printf "\n255.0.0.0 has a cdr mask of\n"
mask2cdr 17.0.0.0

printf "\n8 CDR is a mask of\n"
cdr2mask 8