#!/usr/bin/env bash

AP=$1

cat <<CONFIG
CONFIG

bash tools/install.sh $AP
bash tools/users.sh $AP
bash tools/system.sh $AP
bash tools/network.sh $AP
bash tools/wifi.sh $AP
#bash tools/scripts.sh $AP
bash tools/firewall.sh $AP