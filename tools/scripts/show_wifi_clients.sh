#!/bin/sh

if [ $# -ne 1 ]
then
	echo "usage: $0 <inteface>" 1>&2
	exit 1
fi
interface=$1

maclist=`iw dev $interface station dump | grep Station | cut -f 2 -s -d" "`
for mac in $maclist
do
	ip="UNKN"
	host=""
	ip=`cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep $mac | cut -f 2 -s -d" "`
	host=`cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d" " | grep $mac | cut -f 3 -s -d" "`
	echo -e "$ip\t$host\t$mac\t$interface"
done
