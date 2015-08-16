#!/usr/bin/env bash -ex


cat <<CONFIG

opkg update && opkg install ebtables luci-ssl bash curl || exit 1

CONFIG
