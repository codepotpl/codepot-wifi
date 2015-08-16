#!/bin/bash

if [ $# -ne 0 ]
then
	APs="$*"
else
	APs=`seq 1 21`
fi

for i in $APs
do
	ping -W 1 -c 1 192.168.1.$i >/dev/null && echo "codepot-ap-$i is up" || echo "codepot-ap-$i is down!"
done

