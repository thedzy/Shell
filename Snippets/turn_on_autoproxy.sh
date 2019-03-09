#!/usr/bin/env sh

EXITERROR=0

PROXY_STATE=${1:-on}
[ ! "$PROXY_STATE" == "on" ] && [ ! "$PROXY_STATE" == "off" ] && printf "Reading proxy state\n"

# Enable/Disable/read proxy on all interfaces
NETSERVICES=$(/usr/sbin/networksetup -listallnetworkservices| grep -ov "*")
while read NETSERVICE; do
    printf "$NETSERVICE: "
    if [ ! "$PROXY_STATE" == "on" ] && [ ! "$PROXY_STATE" == "off" ]; then
        /usr/sbin/networksetup -getproxyautodiscovery "$NETSERVICE"
        [ $? -ne 0 ] && printf "Error reading proxies on $NETSERVICE\n"
    else
        /usr/sbin/networksetup -setproxyautodiscovery "$NETSERVICE" $PROXY_STATE
        [ $? -ne 0 ] && printf "Error setting proxies on $NETSERVICE\n" && (( EXITERROR++ ))
        /usr/sbin/networksetup -getproxyautodiscovery "$NETSERVICE"
    fi
done <<< "$NETSERVICES"

exit $EXITERROR