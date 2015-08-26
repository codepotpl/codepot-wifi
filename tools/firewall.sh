#!/usr/bin/env bash -ex
AP=$1


cat <<CONFIG
#uci add firewall rule
#uci set firewall.@rule[-1].src=wan
#uci set firewall.@rule[-1].target=ACCEPT
#uci set firewall.@rule[-1].proto=tcp
#uci set firewall.@rule[-1].dest_port=80
#uci commit firewall

uci add firewall rule
uci set firewall.@rule[-1].src=wan
uci set firewall.@rule[-1].target=ACCEPT
uci set firewall.@rule[-1].proto=tcp
uci set firewall.@rule[-1].dest_port=22
uci commit firewall

CONFIG


