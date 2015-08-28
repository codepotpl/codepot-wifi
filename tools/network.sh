#!/usr/bin/env bash -ex
AP=$1

IP="192.168.24.$((AP+1))"
NETMASK=255.255.255.0
GATEWAY=192.168.24.1

cat <<CONFIG

cat <<EOF > /etc/config/dhcp || exit 1

config dnsmasq
	option domainneeded '1'
	option boguspriv '1'
	option localise_queries '1'
	option rebind_protection '1'
	option rebind_localhost '1'
	option local '/lan/'
	option expandhosts '1'
	option authoritative '1'
	option readethers '1'
	option leasefile '/tmp/dhcp.leases'
	option resolvfile '/tmp/resolv.conf.auto'

config dhcp 'lan'
	option interface 'lan'
	option start '244'
	option limit '1500'
	option leasetime '1m'

config dhcp 'wan'
	option interface 'wan'
	option ignore '1'

EOF

cat <<EOF > /etc/config/network || exit 1
config interface 'loopback'
	option ifname 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config interface 'lan'
	option ifname 'eth0.1'
	option type 'bridge'
	option proto 'static'
	option ipaddr '192.168.1.1'
	option netmask '255.255.0.0'
	option dns '8.8.8.8 8.8.4.4'

config interface 'wan'
	option ifname 'eth0.2'
	option _orig_ifname 'eth0.2'
	option _orig_bridge 'false'
	option proto 'static'
	option ipaddr '$IP'
	option netmask '$NETMASK'
	option gateway '$GATEWAY'

config switch
	option name 'eth0'
	option reset '1'
	option enable_vlan '1'

config switch_vlan
	option device 'eth0'
	option vlan '1'
	option ports '0t 2 3 4 5'

config switch_vlan
	option device 'eth0'
	option vlan '2'
	option ports '0t 1'

EOF

cat <<EOF > /etc/firewall.user || exit 1
# This file is interpreted as shell script.
# Put your custom iptables rules here, they will
# be executed with each firewall (re-)start.

ebtables -F FORWARD
ebtables -A FORWARD -i ! eth0+ -o ! eth0+ --logical-in br-lan --logical-out br-lan -j DROP
EOF

sed -i "s/DNS_SERVERS=\"\"/DNS_SERVERS=\"8.8.8.8 $DNS\"/g" /etc/init.d/dnsmasq

CONFIG

