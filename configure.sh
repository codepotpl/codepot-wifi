#!/bin/bash

set -ex
if [ $# -ne 1 ]
then
	echo "usage: $0 <idx>" 1>&2
	exit 1
fi

AP=$1
IP="192.168.24.$((AP+1))"
#sudo ifconfig wlan0 10.5.10.40 netmask 255.255.255.0
bash tools/main.sh $AP | ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$IP "cd / && sh"

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$IP "reboot"

set +ex
