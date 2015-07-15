#!/bin/bash -ex

if [ "$(id -u)" != "0" ]; then
   echo "Sudo !" 1>&2
   exit 1
fi

ifconfig eth0 down
ifconfig eth0 192.168.1.2 netmask 255.255.255.0
sleep 10

ifconfig eth0
ping -c1 192.168.1.1
expect -d firstboot.exp
