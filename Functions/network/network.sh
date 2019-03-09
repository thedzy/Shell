#!/bin/sh
#
# SCRIPT:	network.sh
# AUTHOR:	thedzy <thedzy@hotmail.com>
# DATE:		2018-09-30
# REV:		1.0
#
# PLATFORM: MacOS
#
# DESCRIPTION:
#	Basic network fuctions
#
# BUGS:
#
# FUNCTIONS:
#	getIPs()
#	getIP()
#	getIPcount()
#	mask2cdr()
#	cdr2mask()
#

#################################
# FUNCTION:
#	getIPs()
#
# DESCRIPTION:
#	Basic network fuctions
#
# PARAMETERS:
# 	None
# Returns all IPs in an array
function getIPs(){
	IPS=($(ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2))
	echo ${IPS[@]}
}

#################################
# FUNCTION:
#	getIP()
#
# DESCRIPTION:
#	Get IP by position in array
#
# PARAMETERS:
# 	$1 Postion
# Returns IPs in the array
function getIP(){
	[ "$1" == "" ] && IPNUM=0 || IPNUM=$1
	IPS=($(getIPs))

	echo ${IPS[$IPNUM]}
}

#################################
# FUNCTION:
#	getIPcount()
#
# DESCRIPTION:
#	Get IP count
#
# PARAMETERS:
# 	None
# Returns IPs count
function getIPcount(){
	IPS=($(getIPs))

	echo ${#IPS[@]}
}

#################################
# FUNCTION:
#	mask2cdr()
#
# DESCRIPTION:
#	Convert mask to CDR
#
# PARAMETERS:
# 	$1 Mask
# ReturnsCDR
mask2cdr ()
{
   # Assumes there's no "255." after a non-255 byte in the mask
   local MASK=${1##*255.}
   set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#MASK})*2 )) ${MASK%%.*}
   MASK=${1%%$3*}
   echo $(( $2 + (${#MASK}/4) ))
}

#################################
# FUNCTION:
#	cdr2mask()
#
# DESCRIPTION:
#	Convert CDR to mask
#
# PARAMETERS:
# 	$1 CDR
# Returns Mask
cdr2mask ()
{
   # Number of args to shift, 255..255, first non-255 byte, zeroes
   set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
   [ $1 -gt 1 ] && shift $1 || shift
   echo ${1-0}.${2-0}.${3-0}.${4-0}
}