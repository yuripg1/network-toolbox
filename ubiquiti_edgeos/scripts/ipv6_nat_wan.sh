#!/bin/sh
WAN_INTERFACE="pppoe0"
logger "Checking IPv6 NAT rules on WAN interface $WAN_INTERFACE"
if ip link show "$WAN_INTERFACE" > /dev/null 2>&1; then
  IPV6_NAT_WAN_CUSTOM_001_COUNT=$(sudo ip6tables -t nat -L -v -n | grep -c "IPV6_NAT_WAN_CUSTOM_001")
  if [ "$IPV6_NAT_WAN_CUSTOM_001_COUNT" -eq "0" ]; then
    sudo ip6tables -t nat -A POSTROUTING -o "$WAN_INTERFACE" -p udp --sport 123 -j SNAT --to-source :49152-65535 -m comment --comment "IPV6_NAT_WAN_CUSTOM_001"
    logger "IPV6_NAT_WAN_CUSTOM_001 created"
  fi
fi
