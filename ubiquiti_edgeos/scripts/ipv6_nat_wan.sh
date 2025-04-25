#!/bin/sh
WAN_INTERFACE="pppoe0"
logger "Applying IPv6 NAT rules on WAN interface $WAN_INTERFACE"
IPV6_NAT_WAN_1_COUNT=$(sudo ip6tables --table nat --list  --verbose --numeric | grep --count "IPV6_NAT_WAN_1")
if [ "$IPV6_NAT_WAN_1_COUNT" -eq "0" ]; then
  sudo ip6tables --table nat --append POSTROUTING --out-interface "$WAN_INTERFACE" --protocol udp --sport 123 --jump SNAT --to-source :49152-65535 --match comment --comment "IPV6_NAT_WAN_1"
  logger "IPV6_NAT_WAN_1 created"
fi
