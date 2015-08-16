#!/usr/bin/env bash -ex
AP=$1

IP="10.5.11.$AP"
NETMASK=255.255.0.0
GATEWAY=10.5.10.1
DNS=10.5.10.1

cat <<CONFIG

cat <<EOF > /etc/config/dhcp || exit 1
config dnsmasq
	option domainneeded	1
	option boguspriv	1
	option filterwin2k	0  # enable for dial on demand
	option localise_queries	1
	option rebind_protection 1  # disable if upstream must serve RFC1918 addresses
	option rebind_localhost 1  # enable for RBL checking and similar services
	#list rebind_domain example.lan  # whitelist RFC1918 responses for domains
	option local	'/lan/'
	option domain	'lan'
	option expandhosts	1
	option nonegcache	0
	option authoritative	1
	option readethers	1
	option leasefile	'/tmp/dhcp.leases'
	option resolvfile	'/tmp/resolv.conf.auto'
	option server '$DNS'
	option server '8.8.4.4'
	#list server		'/mycompany.local/1.2.3.4'
	#option nonwildcard	1
	#list interface		br-lan
	#list notinterface	lo
	#list bogusnxdomain     '64.94.110.11'

config dhcp lan
	option interface	lan
	option ignore	1

EOF

cat <<EOF > /etc/config/firewall || exit 1
config defaults
	option syn_flood '1'
	option input 'ACCEPT'
	option output 'ACCEPT'
	option forward 'REJECT'

config zone
	option name 'lan'
	option network 'lan'
	option input 'ACCEPT'
	option output 'ACCEPT'
	option forward 'REJECT'

config include
	option path '/etc/firewall.user'

EOF

cat <<EOF > /etc/config/network || exit 1
config interface 'loopback'
	option ifname 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config interface 'lan'
	option type 'bridge'
	option _orig_ifname 'eth0.1 radio0.network1 radio1.network1'
	option _orig_bridge 'true'
	option ifname 'eth0.1'
	option proto 'static'
	option auto '1'
	option ipaddr '$IP'
	option netmask '$NETMASK'
	option gateway '$GATEWAY'
	option dns '$DNS'
	option stp '1'

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

