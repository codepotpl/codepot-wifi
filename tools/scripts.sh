#!/usr/bin/env bash


scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no tools/scripts/*.sh root@$IP:.

cat <<CONFIG

cat <<EOF > /etc/crontabs/root || exit 1
* * * * * bash /root/metrics.sh &> /dev/null
EOF

CONFIG