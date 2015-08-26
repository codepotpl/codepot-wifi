#!/bin/bash

curl -G http://52.18.195.210:8086/query --data-urlencode "q=CREATE DATABASE wifi"
echo ""
ap=`uname -n | cut -d '-' -f 3`

function count_devices() {
clients_24=`bash show_wifi_clients.sh wlan0 | wc -l`
clients_50=`bash show_wifi_clients.sh wlan1 | wc -l`
total_clients=$(($clients_50 + $clients_24))
load_5=`cat /proc/loadavg | cut  -d ' ' -f 1`

echo "Total: $total_clients"
echo "24ghz: $clients_24"
echo "50ghz: $clients_50"
echo "Load: $load_5"

curl -v -XPOST 'http://52.18.195.210:8086/write?db=wifi' --data-binary "wifi.50.$ap value=$clients_50
wifi.24.$ap value=$clients_24
wifi.total.$ap value=$total_clients
load.5min.$ap value=$load_5"
}

count_devices


