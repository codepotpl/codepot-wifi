#!/usr/bin/env bash -ex
AP=$1

cat <<CONFIG

cat <<EOF > /etc/config/system || exit 1
config system
	option hostname 'codepot-ap-$AP'
	option zonename 'Europe/Warsaw'
	option timezone 'CET-1CEST,M3.5.0,M10.5.0/3'
	option conloglevel '8'
	option cronloglevel '8'

config timeserver 'ntp'
	list server 'tempus1.gum.gov.pl'
	list server 'ntp.coi.pw.edu.pl'
	list server 'tempus2.gum.gov.pl'
	option enable_server '0'

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

CONFIG
