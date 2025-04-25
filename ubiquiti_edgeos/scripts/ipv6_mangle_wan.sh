#!/bin/sh
WAN_INTERFACE="pppoe0"
logger "Applying IPv6 mangle rules on WAN interface $WAN_INTERFACE"
IPV6_MANGLE_WAN_1_COUNT=$(sudo ip6tables --table mangle --list  --verbose --numeric | grep --count "IPV6_MANGLE_WAN_1")
if [ "$IPV6_MANGLE_WAN_1_COUNT" -eq "0" ]; then
  sudo ip6tables --table mangle --append FORWARD --in-interface "$WAN_INTERFACE" --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432 --match comment --comment "IPV6_MANGLE_WAN_1"
  logger "IPV6_MANGLE_WAN_1 created"
fi
IPV6_MANGLE_WAN_2_COUNT=$(sudo ip6tables --table mangle --list  --verbose --numeric | grep --count "IPV6_MANGLE_WAN_2")
if [ "$IPV6_MANGLE_WAN_2_COUNT" -eq "0" ]; then
  sudo ip6tables --table mangle --append POSTROUTING --out-interface "$WAN_INTERFACE" --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432 --match comment --comment "IPV6_MANGLE_WAN_2"
  logger "IPV6_MANGLE_WAN_2 created"
fi
