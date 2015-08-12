#!/bin/bash

# $1 - ap index

declare -A RADIO0
declare -A RADIO1
declare -A CH24
declare -A CH5
declare -A TX24
declare -A TX5
declare -A SWTAGS
declare -A SWNET

WIFI_PASSWORD=mce.2014

DEFAULT_CH24=1
DEFAULT_CH5=36

DEFAULT_TX24=12
DEFAULT_TX5=12

DEFAULT_SWTAGS="0t 1t 2t 3t"
DEFAULT_SWNET="0t 1t 2t 3t 4 5"

ISOLATE=1

# HOL
RADIO0["1"]=64:66:b3:eb:10:b1
RADIO1["1"]=64:66:b3:eb:10:b2
CH24["1"]=1
CH5["1"]=40
SWTAGS["1"]="0t 1t"
SWNET["1"]="0t 1t 2 3 4 5"

RADIO0["2"]=64:66:b3:eb:0e:79
RADIO1["2"]=64:66:b3:eb:0e:7a
CH24["2"]=6
CH5["2"]=48

RADIO0["3"]="64:66:b3:eb:10:5d"
RADIO1["3"]="64:66:b3:eb:10:5e"
CH24["3"]=11
CH5["3"]=56

# SALA 1
RADIO0["4"]=64:66:b3:eb:10:ab
RADIO1["4"]=64:66:b3:eb:10:ac
CH24["4"]=1
CH5["4"]=48

RADIO0["5"]=64:66:b3:eb:10:91
RADIO1["5"]=64:66:b3:eb:10:92
CH24["5"]=6
CH5["5"]=56

RADIO0["6"]=64:66:b3:eb:10:59
RADIO1["6"]=64:66:b3:eb:10:5a
CH24["6"]=11
CH5["6"]=60

# SALA 2
RADIO0["7"]="64:66:b3:eb:10:3b"
RADIO1["7"]="64:66:b3:eb:10:3c"
CH24["7"]=1
CH5["7"]=36

RADIO0["8"]="64:66:b3:eb:16:cb"
RADIO1["8"]="64:66:b3:eb:16:cc"
CH24["8"]=6
CH5["8"]=44
SWTAGS["8"]="0t 1t 2t 3t 4t 5t"
SWNET["8"]="0t 1t 2t 3t 4t 5t"

RADIO0["9"]="64:66:b3:eb:10:5f"
RADIO1["9"]="64:66:b3:eb:10:60"
CH24["9"]=13
CH5["9"]=52

RADIO0["10"]="64:66:b3:eb:17:31"
RADIO1["10"]="64:66:b3:eb:17:32"
CH24["10"]=11
CH5["10"]=60

# SALA 3
RADIO0["11"]="64:66:b3:eb:10:7b"
RADIO1["11"]="64:66:b3:eb:10:7c"
CH24["11"]=6
CH5["11"]=40

RADIO0["12"]=64:66:b3:eb:10:89
RADIO1["12"]=64:66:b3:eb:10:8a
CH24["12"]=11
CH5["12"]=48

RADIO0["13"]=64:66:b3:eb:17:67
RADIO1["13"]=64:66:b3:eb:17:68
CH24["13"]=1
CH5["13"]=56

# SPARE
RADIO0["14"]="64:66:b3:eb:10:73"
RADIO1["14"]="64:66:b3:eb:10:74"
CH24["14"]=6
CH5["14"]=40

RADIO0["15"]="64:70:02:38:fb:59"
RADIO1["15"]="64:70:02:38:fb:5a"
CH24["15"]=11
CH5["15"]=44

if [ $# -ne 1 ]
then
	echo "usage: $0 <idx>" 1>&2
	exit 1
fi

AP=$1

cat <<CONFIG

opkg update && opkg install ebtables luci-ssl || exit 1

cat <<"EOF" > /etc/shadow || exit 1
root:*:16078:0:99999:7:::
daemon:*:0:0:99999:7:::
ftp:*:0:0:99999:7:::
network:*:0:0:99999:7:::
nobody:*:0:0:99999:7:::
EOF

cat <<EOF > /etc/dropbear/authorized_keys || exit 1
EOF

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
	#list server		'/mycompany.local/1.2.3.4'
	#option nonwildcard	1
	#list interface		br-lan
	#list notinterface	lo
	#list bogusnxdomain     '64.94.110.11'

config dhcp lan
	option interface	lan
	option ignore	1

config dhcp mgmt
	option interface	mgmt
	option ignore	1
EOF

cat <<EOF > /etc/config/dropbear || exit 1
config dropbear
	option PasswordAuth 'on'
	option Port '22'
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

config zone
	option name 'mgmt'
	option input 'ACCEPT'
	option forward 'REJECT'
	option output 'ACCEPT'
	option network 'mgmt'
EOF

cat <<EOF > /etc/config/system || exit 1
config system
	option hostname 'ap-$AP'
	option zonename 'Europe/Warsaw'
	option timezone 'CET-1CEST,M3.5.0,M10.5.0/3'
	option conloglevel '8'
	option cronloglevel '8'

config timeserver 'ntp'
	list server '0.openwrt.pool.ntp.org'
	list server '1.openwrt.pool.ntp.org'
	list server '2.openwrt.pool.ntp.org'
	list server '3.openwrt.pool.ntp.org'

config led 'led_usb1'
	option name 'USB1'
	option sysfs 'tp-link:green:usb1'
	option trigger 'usbdev'
	option dev '1-1.1'
	option interval '50'

config led 'led_usb2'
	option name 'USB2'
	option sysfs 'tp-link:green:usb2'
	option trigger 'usbdev'
	option dev '1-1.2'
	option interval '50'

config led 'led_wlan2g'
	option name 'WLAN2G'
	option sysfs 'tp-link:blue:wlan2g'
	option trigger 'phy0tpt'
EOF

rm -f /etc/config/wireles
cat <<EOF > /etc/config/wireless
config wifi-device 'radio0'
	option type 'mac80211'
	option macaddr '${RADIO0["$AP"]}'
	option hwmode '11ng'
	option htmode 'HT20'
	list ht_capab 'LDPC'
	list ht_capab 'SHORT-GI-20'
	list ht_capab 'SHORT-GI-40'
	list ht_capab 'TX-STBC'
	list ht_capab 'RX-STBC1'
	list ht_capab 'DSSS_CCK-40'
	option channel '${CH24["$AP"]-$DEFAULT_CH24}'
	option txpower '${TX24["$AP"]-$DEFAULT_TX24}'
	option country 'US'

config wifi-iface
	option device 'radio0'
	option mode 'ap'
	option network 'lan'
	option encryption 'none'
	option ssid 'MCE Alternative'
	option isolate '$ISOLATE'

config wifi-device 'radio1'
	option type 'mac80211'
	option channel '${CH5["$AP"]-$DEFAULT_CH5}'
	option txpower '${TX5["$AP"]-$DEFAULT_TX5}'
	option macaddr '${RADIO1["$AP"]}'
	option hwmode '11na'
	option htmode 'HT20'
	list ht_capab 'LDPC'
	list ht_capab 'SHORT-GI-20'
	list ht_capab 'SHORT-GI-40'
	list ht_capab 'TX-STBC'
	list ht_capab 'RX-STBC1'
	list ht_capab 'DSSS_CCK-40'

config wifi-iface
	option device 'radio1'
	option mode 'ap'
	option network 'lan'
	option encryption 'none'
	option ssid 'MCE'
	option isolate '$ISOLATE'

config wifi-iface
	option device 'radio1'
	option mode 'ap'
	option network 'lan'
	option encryption 'none'
	option ssid 'MCE Alternative'
	option isolate '$ISOLATE'
EOF

cat <<EOF > /etc/config/network || exit 1
config interface 'loopback'
	option ifname 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config interface 'lan'
	option type 'bridge'
	option _orig_ifname 'eth0.$AP radio0.network1 radio1.network1'
	option _orig_bridge 'true'
	option ifname 'eth0.$AP'
	option proto 'none'
	option auto '1'
	option stp '1'

config switch
	option name 'eth0'
	option reset '1'
	option enable_vlan '1'

config switch_vlan
	option device 'eth0'
	option vlan '1'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '1'

config switch_vlan
	option device 'eth0'
	option vlan '2'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '2'

config switch_vlan
	option device 'eth0'
	option vlan '3'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '3'

config switch_vlan
	option device 'eth0'
	option vlan '4'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '4'

config switch_vlan
	option device 'eth0'
	option vlan '5'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '5'

config switch_vlan
	option device 'eth0'
	option vlan '6'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '6'

config switch_vlan
	option device 'eth0'
	option vlan '7'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '7'

config switch_vlan
	option device 'eth0'
	option vlan '8'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '8'

config switch_vlan
	option device 'eth0'
	option vlan '9'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '9'

config switch_vlan
	option device 'eth0'
	option vlan '10'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '10'

config switch_vlan
	option device 'eth0'
	option vlan '11'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '11'

config switch_vlan
	option device 'eth0'
	option vlan '12'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '12'

config switch_vlan
	option device 'eth0'
	option vlan '13'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '13'

config switch_vlan
	option device 'eth0'
	option vlan '14'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '14'

config switch_vlan
	option device 'eth0'
	option vlan '20'
	option ports '${SWTAGS["$AP"]-$DEFAULT_SWTAGS}'
	option vid '20'

config switch_vlan
	option device 'eth0'
	option vlan '21'
	option ports '${SWNET["$AP"]-$DEFAULT_SWNET}'
	option vid '21'

config interface 'mgmt'
	option type 'bridge'
	option proto 'static'
	option ifname 'eth0.20'
	option ipaddr '10.230.0.$AP'
	option netmask '255.255.255.0'
	option gateway '10.230.0.254'
	option dns '10.230.0.254'
	option stp '1'
EOF

cat <<EOF > /etc/firewall.user || exit 1
# This file is interpreted as shell script.
# Put your custom iptables rules here, they will
# be executed with each firewall (re-)start.

ebtables -F FORWARD
ebtables -A FORWARD -i ! eth0+ -o ! eth0+ --logical-in br-lan --logical-out br-lan -j DROP
EOF

echo Configuration updated.
CONFIG

cat <<"CONFIG"
cd /tmp/
wget http://luci.subsignal.org/~jow/reghack/reghack.mips.elf
chmod +x reghack.mips.elf
/tmp/reghack.mips.elf /lib/modules/*/ath.ko
/tmp/reghack.mips.elf /lib/modules/*/cfg80211.ko
CONFIG
