#!/bin/bash

if [ $# -ne 1 ]
then
	echo "usage: $0 <idx>" 1>&2
	exit 1
fi

expect << EOF
spawn telnet 192.168.1.1 23
expect -re ".*#"
send "uci show wireless.radio0.macaddr | sed 's/wireless.radio0.macaddr/RADIO0\[\"$1\"\]/'; uci show wireless.radio1.macaddr | sed 's/wireless.radio1.macaddr/RADIO1\[\"$1\"\]/'\r"
expect -re ".*#"
send "echo \"SSH-RSA\" > /etc/dropbear/authorized_keys\r"
expect -re ".*#"
send "exit\r"
EOF
