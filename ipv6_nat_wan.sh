#!/bin/sh
WAN_INTERFACE="pppoe0"
logger "Checking IPv6 NAT rules on WAN interface $WAN_INTERFACE"
if ip link show "$WAN_INTERFACE" > /dev/null 2>&1; then
  RESTART_NTP_SERVICE=0
  IPV6_NAT_WAN_CUSTOM_001_COUNT=$(sudo ip6tables -t nat -L -v -n | grep -c "IPV6_NAT_WAN_CUSTOM_001")
  if [ "$IPV6_NAT_WAN_CUSTOM_001_COUNT" -eq "0" ]; then
    sudo ip6tables -t nat -A POSTROUTING -o "$WAN_INTERFACE" -p udp --sport 123 -j SNAT --to-source :49152-65535 -m comment --comment "IPV6_NAT_WAN_CUSTOM_001"
    RESTART_NTP_SERVICE=1
    logger "IPV6_NAT_WAN_CUSTOM_001 created"
  fi
  if [ "$RESTART_NTP_SERVICE" -eq "1" ]; then
    sleep 1m
    sudo service ntp restart
    logger "NTP service restarted"
  fi
fi
