#/bin/sh

MAC_1=`echo $1 | cut -d: -f1`
MAC_2=`echo $1 | cut -d: -f2`
MAC_3=`echo $1 | cut -d: -f3`
MAC_4=`echo $1 | cut -d: -f4`
MAC_5=`echo $1 | cut -d: -f5`
MAC_6=`echo $1 | cut -d: -f6`
MAC=`printf "%d.%d.%d.%d.%d.%d\n" 0x$MAC_1 0x$MAC_2 0x$MAC_3 0x$MAC_4 0x$MAC_5 0x$MAC_6`

COMMUNITY=`echo $2 | sed s/@.*//`
DEVICE=`echo $2 | sed s/.*@//`

INTER=`snmpwalk -Cc -v 2c -On  -c $COMMUNITY $DEVICE SNMPv2-SMI::mib-2.17.4.3.1.2 | grep "$MAC" | sed 's/.*INTEGER:\ //'`

if [ -n "$INTER" ];then
	INTERFACE=`snmpget -v 2c -On  -c $COMMUNITY $DEVICE SNMPv2-SMI::mib-2.17.1.4.1.2.$INTER | sed 's/.*INTEGER:\ //'`
	snmpget -v 2c -On -c $COMMUNITY $DEVICE ifDescr.$INTERFACE | sed 's/.*STRING:\ //'
	
fi
