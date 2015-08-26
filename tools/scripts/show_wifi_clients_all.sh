#!/bin/sh


# Shows MAC, IP address and any hostname info for all connected wifi devices
# written for openwrt 12.09 Attitude Adjustment

echo    "# All connected wifi devices, with IP address,"
echo    "# hostname (if available), and MAC address."
echo -e "# IP address\tname\tMAC address\tInterface"
# list all wireless network interfaces
# (for MAC80211 driver; see wiki article for alternative commands)
for interface in `iw dev | grep Interface | cut -f 2 -s -d" "`
do
	bash show_wifi_clients.sh $interface
done
