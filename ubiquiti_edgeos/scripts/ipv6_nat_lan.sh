#!/bin/sh
LAN_INTERFACE="eth1"
DNS_SERVER_IP_ADDRESS="fd1a:ac95:26c8:c75f::1"
logger "Checking IPv6 NAT rules on LAN interface $LAN_INTERFACE"
IPV6_NAT_LAN_CUSTOM_001_COUNT=$(sudo ip6tables -t nat -L -v -n | grep -c "IPV6_NAT_LAN_CUSTOM_001")
IPV6_NAT_LAN_CUSTOM_002_COUNT=$(sudo ip6tables -t nat -L -v -n | grep -c "IPV6_NAT_LAN_CUSTOM_002")
if [ "$IPV6_NAT_LAN_CUSTOM_001_COUNT" -eq "0" ]; then
  sudo ip6tables -t nat -A PREROUTING -i "$LAN_INTERFACE" -p udp --dport 53 ! -d "$DNS_SERVER_IP_ADDRESS" -j REDIRECT --to-ports 53 -m comment --comment "IPV6_NAT_LAN_CUSTOM_001"
  logger "IPV6_NAT_LAN_CUSTOM_001 created"
fi
if [ "$IPV6_NAT_LAN_CUSTOM_002_COUNT" -eq "0" ]; then
  sudo ip6tables -t nat -A PREROUTING -i "$LAN_INTERFACE" -p tcp --dport 53 ! -d "$DNS_SERVER_IP_ADDRESS" -j REDIRECT --to-ports 53 -m comment --comment "IPV6_NAT_LAN_CUSTOM_002"
  logger "IPV6_NAT_LAN_CUSTOM_002 created"
fi
