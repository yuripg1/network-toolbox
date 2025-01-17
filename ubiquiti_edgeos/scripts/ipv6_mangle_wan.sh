#!/bin/sh
WAN_INTERFACE="pppoe0"
logger "Checking IPv6 mangle rules on WAN interface $WAN_INTERFACE"
if ip link show "$WAN_INTERFACE" > /dev/null 2>&1; then
  IPV6_MANGLE_WAN_CUSTOM_001_COUNT=$(sudo ip6tables --table mangle --list  --verbose --numeric | grep --count "IPV6_MANGLE_WAN_CUSTOM_001")
  IPV6_MANGLE_WAN_CUSTOM_002_COUNT=$(sudo ip6tables --table mangle --list  --verbose --numeric | grep --count "IPV6_MANGLE_WAN_CUSTOM_002")
  if [ "$IPV6_MANGLE_WAN_CUSTOM_001_COUNT" -eq "0" ]; then
    sudo ip6tables --table mangle --append POSTROUTING --out-interface "$WAN_INTERFACE" --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432 --match comment --comment "IPV6_MANGLE_WAN_CUSTOM_001"
    logger "IPV6_MANGLE_WAN_CUSTOM_001 created"
  fi
  if [ "$IPV6_MANGLE_WAN_CUSTOM_002_COUNT" -eq "0" ]; then
    sudo ip6tables --table mangle --append PREROUTING --in-interface "$WAN_INTERFACE" --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432 --match comment --comment "IPV6_MANGLE_WAN_CUSTOM_002"
    logger "IPV6_MANGLE_WAN_CUSTOM_002 created"
  fi
fi
