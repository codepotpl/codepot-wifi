#!/usr/bin/env bash -ex

AP=$1
SSID="Codepot"
SSID_ALTERNATIVE="$SSID Alternative"
PASSWORD="codepot2015"

declare -A CH24
declare -A CH50

DEFAULT_CH24=1
DEFAULT_CH50=36

AP_MAC=`printf "%02d" $AP`
MAC0="64:66:b3:eb:$AP_MAC:24"
MAC1="64:66:b3:eb:$AP_MAC:50"

CH24["1"]=1
CH24["2"]=2
CH24["3"]=1
CH24["4"]=1
CH24["5"]=1
CH24["6"]=1
CH24["7"]=1
CH24["8"]=1
CH24["9"]=1
CH24["10"]=1
CH24["11"]=1
CH24["12"]=1
CH24["13"]=1
CH24["14"]=1
CH24["15"]=1
CH24["16"]=1
CH24["17"]=1
CH24["18"]=1
CH24["19"]=1
CH24["20"]=1
CH24["21"]=1

CH50["1"]=36
CH50["2"]=36
CH50["3"]=36
CH50["4"]=36
CH50["5"]=36
CH50["6"]=36
CH50["7"]=36
CH50["8"]=36
CH50["9"]=36
CH50["10"]=36
CH50["11"]=36
CH50["12"]=36
CH50["13"]=36
CH50["14"]=36
CH50["15"]=36
CH50["16"]=36
CH50["17"]=36
CH50["18"]=36
CH50["19"]=36
CH50["20"]=36
CH50["21"]=36

cat <<CONFIG

uci set wireless.radio0=wifi-device;
uci set wireless.radio0.type=mac80211;
uci set wireless.radio0.channel=${CH24["$AP"]-$DEFAULT_CH24};
uci set wireless.radio0.hwmode=11ng;
uci set wireless.radio0.htmode=HT20;
uci set wireless.radio0.ht_capab="LDPC SHORT-GI-20 SHORT-GI-40 TX-STBC RX-STBC1 DSSS_CCK-40";
uci set wireless.radio0.disabled=0;
uci set wireless.@wifi-iface[0]=wifi-iface;
uci set wireless.@wifi-iface[0].device=radio0;
uci set wireless.@wifi-iface[0].network=lan;
uci set wireless.@wifi-iface[0].mode=ap;
uci set wireless.@wifi-iface[0].encryption=psk2+ccmp;
uci set wireless.@wifi-iface[0].ssid="$SSID";
uci set wireless.@wifi-iface[0].key=$PASSWORD;
uci set wireless.@wifi-iface[0].isolate=1;
uci commit wireless;

uci set wireless.radio1=wifi-device;
uci set wireless.radio1.type=mac80211;
uci set wireless.radio1.channel=${CH50["$AP"]-$DEFAULT_CH24};
uci set wireless.radio1.hwmode=11na;
uci set wireless.radio1.htmode=HT20;
uci set wireless.radio1.ht_capab="LDPC SHORT-GI-20 SHORT-GI-40 TX-STBC RX-STBC1 DSSS_CCK-40";
uci set wireless.radio1.disabled=0;
uci set wireless.@wifi-iface[1]=wifi-iface;
uci set wireless.@wifi-iface[1].device=radio1;
uci set wireless.@wifi-iface[1].network=lan;
uci set wireless.@wifi-iface[1].mode=ap;
uci set wireless.@wifi-iface[1].encryption=psk2+ccmp;
uci set wireless.@wifi-iface[1].ssid="$SSID_ALTERNATIVE";
uci set wireless.@wifi-iface[1].key=$PASSWORD;
uci set wireless.@wifi-iface[1].isolate=1;
uci commit wireless;

wifi

CONFIG

