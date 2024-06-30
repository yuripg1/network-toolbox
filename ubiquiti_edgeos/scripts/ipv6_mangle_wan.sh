#!/bin/sh
WAN_INTERFACE="pppoe0"
logger "Checking IPv6 mangle rules on WAN interface $WAN_INTERFACE"
if ip link show "$WAN_INTERFACE" > /dev/null 2>&1; then
  IPV6_MANGLE_WAN_CUSTOM_001_COUNT=$(sudo ip6tables -t mangle -L -v -n | grep -c "IPV6_MANGLE_WAN_CUSTOM_001")
  IPV6_MANGLE_WAN_CUSTOM_002_COUNT=$(sudo ip6tables -t mangle -L -v -n | grep -c "IPV6_MANGLE_WAN_CUSTOM_002")
  if [ "$IPV6_MANGLE_WAN_CUSTOM_001_COUNT" -eq "0" ]; then
    sudo ip6tables -t mangle -A POSTROUTING -o "$WAN_INTERFACE" -p tcp -m tcp --tcp-flags SYN SYN -m tcpmss --mss 1421:65535 -j TCPMSS --set-mss 1420 -m comment --comment "IPV6_MANGLE_WAN_CUSTOM_001"
    logger "IPV6_MANGLE_WAN_CUSTOM_001 created"
  fi
  if [ "$IPV6_MANGLE_WAN_CUSTOM_002_COUNT" -eq "0" ]; then
    sudo ip6tables -t mangle -A PREROUTING -i "$WAN_INTERFACE" -p tcp -m tcp --tcp-flags SYN SYN -m tcpmss --mss 1421:65535 -j TCPMSS --set-mss 1420 -m comment --comment "IPV6_MANGLE_WAN_CUSTOM_002"
    logger "IPV6_MANGLE_WAN_CUSTOM_002 created"
  fi
fi
