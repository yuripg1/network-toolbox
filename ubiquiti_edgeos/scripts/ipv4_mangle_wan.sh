#!/bin/sh
WAN_INTERFACE="pppoe0"
logger "Applying IPv4 mangle rules on WAN interface $WAN_INTERFACE"
IPV4_MANGLE_WAN_1_COUNT=$(sudo iptables --table mangle --list  --verbose --numeric | grep --count "IPV4_MANGLE_WAN_1")
if [ "$IPV4_MANGLE_WAN_1_COUNT" -eq "0" ]; then
  sudo iptables --table mangle --append FORWARD --in-interface "$WAN_INTERFACE" --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --jump TCPMSS --set-mss 1452 --match comment --comment "IPV4_MANGLE_WAN_1"
  logger "IPV4_MANGLE_WAN_1 created"
fi
IPV4_MANGLE_WAN_2_COUNT=$(sudo iptables --table mangle --list  --verbose --numeric | grep --count "IPV4_MANGLE_WAN_2")
if [ "$IPV4_MANGLE_WAN_2_COUNT" -eq "0" ]; then
  sudo iptables --table mangle --append POSTROUTING --out-interface "$WAN_INTERFACE" --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --jump TCPMSS --set-mss 1452 --match comment --comment "IPV4_MANGLE_WAN_2"
  logger "IPV4_MANGLE_WAN_2 created"
fi
