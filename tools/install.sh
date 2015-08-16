#!/usr/bin/env bash -ex


cat <<CONFIG

opkg update && opkg install ebtables luci-ssl || exit 1

CONFIG
