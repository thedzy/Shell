#!/bin/sh

printf "Running shell code"

expect - <<EOF 
spawn /Users/$USER/Desktop/expect scripts.sh
expect Who
send Me\r
expect Where
send Here\r
expect You

EOF

printf "Running shell code again"