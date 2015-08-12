#!/bin/bash

KNOWN_HOSTS=`dirname $0`/known_hosts
SSH="ssh -o UserKnownHostsFile=$KNOWN_HOSTS -o StrictHostKeyChecking=no"
USER=root

if [ $# -ne 0 ]
then
	APs="$*"
else
	APs=`seq 1 13`
fi

for i in $APs
do
	ping -W 0 -c 2 192.168.1.$i >/dev/null && echo "ap-$i is up" || echo "ap-$i is down!"
done
