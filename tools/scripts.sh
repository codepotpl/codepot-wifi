#!/usr/bin/env bash

IP="192.168.1.1"

scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no tools/scripts/*.sh root@$IP:.
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no tools/scripts/root root@$IP:/etc/crontabs/root

