#!/bin/sh

IP=$1

COMMUNITY=`echo $2 | sed s/@.*//`
DEVICE=`echo $2 | sed s/.*@//`

snmpwalk -Cc -v 2c -On  -c $COMMUNITY $DEVICE atPhysAddress | grep "$IP " | sed -e 's/.*Hex-STRING:\ //' -e 's/\ *$//' -e 's/\ /:/g'
