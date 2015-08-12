#!/bin/bash

KNOWN_HOSTS=`dirname $0`/known_hosts
SSH="ssh -o UserKnownHostsFile=$KNOWN_HOSTS -o StrictHostKeyChecking=no"
USER=root

if [ $# -ne 0 ]
then
	APs="$*"
else
	APs="1 2 3 5 6 4 10 9 7 8 11 12 13"
fi

for i in $APs
do
	echo "==== Configuring ap-$i ====" && bash config.sh $i | $SSH $USER@10.230.0.$i "cd / && sh && sleep 1s && reboot" && echo "Configured ap-$i" || echo "Failed to configure ap-$i"
done

wait
