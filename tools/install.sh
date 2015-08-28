#!/usr/bin/env bash -ex


cat <<CONFIG
sed -i 's/127.0.0.1/8.8.8.8/g' /etc/resolv.conf

opkg update

opkg install ebtables
#opkg install luci-ssl



CONFIG
