#!/bin/sh

# Files
[ ${#@} -eq 0 ] && echo "No file specified" && exit 1
[ ! -f "$1" ] && echo "Invalid File $1" && exit 2
ORGFILE="$1"
FILEEXT="${ORGFILE##*.}"
ENCFILE="${ORGFILE%.*}_ecrypted.${FILEEXT}"
DECFILE="${ORGFILE%.*}_decrypted.${FILEEXT}"

echo "File being erypted: $ORGFILE"
echo "Ecrypted File:      $ENCFILE"
echo "Decrypted File:     $DECFILE"

# Generate a password for the encryption
KEY="$(openssl rand -base64 48)"

# Add key to the keychain
security add-generic-password -a "" -j "Key to decrypt $ENCFILE" -l "$ENCFILE" -s "Terminal" -w "$KEY"
# If error 45, get key stored
[ $? -eq 45 ] && KEY=$(security find-generic-password -l "$ENCFILE" -w)
# Encypt file
openssl enc -des3 -in "$ORGFILE" -out "$ENCFILE" -salt -a -k "$KEY"
unset KEY

# Retrieve key from Keychain
KEYRETRIEVED=$(security find-generic-password -l "$ENCFILE" -w)
# Decrypt file
openssl enc -d -des3 -in "$ENCFILE" -out "$DECFILE" -salt -a -k "$KEYRETRIEVED"

exit 0
