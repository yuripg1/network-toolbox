#!/bin/sh
WAN_INTERFACE="pppoe0"
logger "Checking IPv4 mangle rules on WAN interface $WAN_INTERFACE"
if ip link show "$WAN_INTERFACE" > /dev/null 2>&1; then
  MANGLE_WAN_CUSTOM_001_COUNT=$(sudo iptables -t mangle -L -v -n | grep -c "MANGLE_WAN_CUSTOM_001")
  MANGLE_WAN_CUSTOM_002_COUNT=$(sudo iptables -t mangle -L -v -n | grep -c "MANGLE_WAN_CUSTOM_002")
  if [ "$MANGLE_WAN_CUSTOM_001_COUNT" -eq "0" ]; then
    sudo iptables -t mangle -A POSTROUTING -o "$WAN_INTERFACE" -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1441:65535 -j TCPMSS --set-mss 1440 -m comment --comment "MANGLE_WAN_CUSTOM_001"
    logger "MANGLE_WAN_CUSTOM_001 created"
  fi
  if [ "$MANGLE_WAN_CUSTOM_002_COUNT" -eq "0" ]; then
    sudo iptables -t mangle -A PREROUTING -i "$WAN_INTERFACE" -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1441:65535 -j TCPMSS --set-mss 1440 -m comment --comment "MANGLE_WAN_CUSTOM_002"
    logger "MANGLE_WAN_CUSTOM_002 created"
  fi
fi
