#!/bin/sh
WAN_INTERFACE="pppoe0"
logger "Fixing NTP on interface $WAN_INTERFACE"
if ip link show "$WAN_INTERFACE" > /dev/null 2>&1; then
  NTP_NAT_RULES=$(sudo ip6tables -t nat -L -v -n | grep -c "udp spt:123 to::49152-65535")
  if [ "$NTP_NAT_RULES" -eq "0" ]; then
    logger "There is no IPv6 Source NAT rule for NTP"
    sudo ip6tables -t nat -A POSTROUTING -o "$WAN_INTERFACE" -p udp --sport 123 -j SNAT --to-source :49152-65535
    logger "IPv6 Source NAT rule for NTP created"
    sleep 1m
    sudo service ntp restart
    logger "NTP service restarted"
  fi
fi
