#!/bin/sh
WAN_INTERFACE="pppoe0"
logger "Checking IPv4 mangle rules on WAN interface $WAN_INTERFACE"
if ip link show "$WAN_INTERFACE" > /dev/null 2>&1; then
  IPV4_MANGLE_WAN_CUSTOM_001_COUNT=$(sudo iptables --table mangle --list  --verbose --numeric | grep --count "IPV4_MANGLE_WAN_CUSTOM_001")
  IPV4_MANGLE_WAN_CUSTOM_002_COUNT=$(sudo iptables --table mangle --list  --verbose --numeric | grep --count "IPV4_MANGLE_WAN_CUSTOM_002")
  if [ "$IPV4_MANGLE_WAN_CUSTOM_001_COUNT" -eq "0" ]; then
    sudo iptables --table mangle --append POSTROUTING --out-interface "$WAN_INTERFACE" --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --jump TCPMSS --set-mss 1452 --match comment --comment "IPV4_MANGLE_WAN_CUSTOM_001"
    logger "IPV4_MANGLE_WAN_CUSTOM_001 created"
  fi
  if [ "$IPV4_MANGLE_WAN_CUSTOM_002_COUNT" -eq "0" ]; then
    sudo iptables --table mangle --append PREROUTING --in-interface "$WAN_INTERFACE" --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --jump TCPMSS --set-mss 1452 --match comment --comment "IPV4_MANGLE_WAN_CUSTOM_002"
    logger "IPV4_MANGLE_WAN_CUSTOM_002 created"
  fi
fi
