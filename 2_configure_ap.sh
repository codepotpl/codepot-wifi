#!/bin/bash

set -ex
if [ $# -ne 1 ]
then
	echo "usage: $0 <idx>" 1>&2
	exit 1
fi

#bash tools/install.sh $1 | ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@192.168.1.1 "cd / && sh"
bash tools/users.sh $1 | ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@192.168.1.1 "cd / && sh"
bash tools/system.sh $1 | ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@192.168.1.1 "cd / && sh"


ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@192.168.1.1 "reboot"

set +ex
