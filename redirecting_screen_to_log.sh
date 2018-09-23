#!/bin/bash

LOGFILE="/tmp/$(basename $0).log"
echo "Logging to $LOGFILE"

HEADER=" $(basename $0) [$$]:"
DATE() { date "+%Y-%m-%d %H:%M:%S"; };
logstd() { while IFS='' read -r LINE; do echo "$(DATE)$HEADER $LINE" >> $LOGFILE; done; };
logerr() { while IFS='' read -r LINE; do echo "$(DATE)$HEADER [ERROR] $LINE" >> $LOGFILE; done; };

exec 1> >(logstd)
exec 2> >(logerr)

# Sample output
echo works
echo works2
mv /tmp/file.does.not.exist /tmp/desitination.does.not.exist
(( 0 )) && echo Works || echo Fails
(( 1 )) && echo Works || echo Fails


exit 0
