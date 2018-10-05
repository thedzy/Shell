#!/bin/sh

#############################
# RANDOMS letter and numbers
#############################

# DIGITS, 0-32768
echo $RANDOM

# DIGITS, 0-9
echo $((RANDOM % 10))

# DIGITS, 1-10
echo $((RANDOM % 10 + 1))

# BASE64, 48 alphanumeric characters
echo $(openssl rand -base64 48)

# Hex, 16 characters
echo $(openssl rand -hex 16)

# BASE64, 12 alphanumeric characters
echo $(cat /dev/random | LC_CTYPE=C tr -dc "[:alnum:]" | head -c 12)

# DIGITS, 0-99999999 (8 digits formatted)
echo $(printf "%08d" $(( (RANDOM * RANDOM) % 99999999 )))

# BASE64, 12 numbers
echo $(cat /dev/random | LC_CTYPE=C tr -dc "[:digit:]" | head -c 12)

# BASE64, 12 letters only
echo $(cat /dev/random | LC_CTYPE=C tr -dc "[:alpha:]" | head -c 12)

#############################
# RANDOMS files
#############################

# Make a 1mb file on the desktop
mkfile -n 1m ~/Desktop/1mfile

# Make a 1mb file on the desktop with randome zeros
# Clean 1024 * 1024 = 1mb
dd if=/dev/zero of=~/Desktop/1mbfile count=1024 bs=1024

# Make a 1mb file on the desktop with randome data
# Random 1024 * 1024 = 1mb
dd if=/dev/urandom of=/Desktop/1mbfile count=1024 bs=1024

# Make a ~1mb file on the desktop with randome words
# Word 100 (X) words on 1000 lines (Y)
ruby -e 'a=STDIN.readlines;100.times do;b=[];1000.times do; b << a[rand(a.size)].chomp end; puts b.join(" "); end' < /usr/share/dict/words > ~/Desktop/1mbfile.txt

# Turn file into package
mkdir -p /tmp/1mbfile
dd if=/dev/urandom of=/tmp/1mbfile/1mbfile.dat count=1024 bs=1024
pkgbuild --root /tmp/1mbfile  --identifier com.example.1mbfile --version 0.1 --install-location /tmp  ~/Desktop/1mbfile.pkg
