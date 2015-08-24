#!/bin/bash

KNOWN_HOSTS=`dirname $0`/known_hosts
SSH="ssh -o UserKnownHostsFile=$KNOWN_HOSTS -o StrictHostKeyChecking=no"
USER=root
expect << EOF
	uci add firewall rule
	uci set firewall.@rule[-1].name=HTTP
	uci set firewall.@rule[-1].src=wan
	uci set firewall.@rule[-1].target=ACCEPT
	uci set firewall.@rule[-1].proto=tcp
	uci set firewall.@rule[-1].dest_port=80
	uci commit firewall

	uci add firewall rule
	uci set firewall.@rule[-1].name=SSH
	uci set firewall.@rule[-1].src=wan
	uci set firewall.@rule[-1].target=ACCEPT
	uci set firewall.@rule[-1].proto=tcp
	uci set firewall.@rule[-1].dest_port=22
	uci commit firewall
EOF