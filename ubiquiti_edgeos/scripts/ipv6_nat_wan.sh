#!/bin/sh
WAN_INTERFACE="pppoe0"
logger "Checking IPv6 NAT rules on WAN interface $WAN_INTERFACE"
if ip link show "$WAN_INTERFACE" > /dev/null 2>&1; then
  IPV6_NAT_WAN_CUSTOM_001_COUNT=$(sudo ip6tables --table nat --list  --verbose --numeric | grep --count "IPV6_NAT_WAN_CUSTOM_001")
  if [ "$IPV6_NAT_WAN_CUSTOM_001_COUNT" -eq "0" ]; then
    sudo ip6tables --table nat --append POSTROUTING --out-interface "$WAN_INTERFACE" --protocol udp --sport 123 --jump SNAT --to-source :49152-65535 --match comment --comment "IPV6_NAT_WAN_CUSTOM_001"
    logger "IPV6_NAT_WAN_CUSTOM_001 created"
  fi
fi
