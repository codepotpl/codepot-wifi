#!/bin/bash

set -ex
if [ $# -ne 1 ]
then
	echo "usage: $0 <idx>" 1>&2
	exit 1
fi

AP=$1
IP="192.168.1.1"
#IP="10.5.11.$AP"

bash tools/main.sh $AP | ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$IP "cd / && sh"

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$IP "reboot"

set +ex
