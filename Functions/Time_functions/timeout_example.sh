#!/bin/sh

source "$(dirname "$0")/timeout.sh"


# Give the command (sleep 50), five seconds to complete
timeout 5 "sleep 50"
[ $? -ne 0 ] && printf "Failed\n" || printf "Success\n"