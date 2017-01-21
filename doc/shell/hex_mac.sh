##/bin/sh

MAC_1=`echo $1 | cut -d: -f1`
MAC_2=`echo $1 | cut -d: -f2`
MAC_3=`echo $1 | cut -d: -f3`
MAC_4=`echo $1 | cut -d: -f4`
MAC_5=`echo $1 | cut -d: -f5`
MAC_6=`echo $1 | cut -d: -f6`
MAC=`printf "%d.%d.%d.%d.%d.%d\n" 0x$MAC_1 0x$MAC_2 0x$MAC_3 0x$MAC_4 0x$MAC_5 0x$MAC_6`

echo $MAC
