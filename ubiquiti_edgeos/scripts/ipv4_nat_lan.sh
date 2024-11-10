#!/bin/sh
LAN_INTERFACE="eth1"
DNS_SERVER_IP_ADDRESS="10.189.117.1"
logger "Checking IPv4 NAT rules on LAN interface $LAN_INTERFACE"
NAT_LAN_CUSTOM_001_COUNT=$(sudo iptables -t nat -L -v -n | grep -c "NAT_LAN_CUSTOM_001")
NAT_LAN_CUSTOM_002_COUNT=$(sudo iptables -t nat -L -v -n | grep -c "NAT_LAN_CUSTOM_002")
if [ "$NAT_LAN_CUSTOM_001_COUNT" -eq "0" ]; then
  sudo iptables -t nat -A PREROUTING -i "$LAN_INTERFACE" -p udp --dport 53 ! -d "$DNS_SERVER_IP_ADDRESS" -j REDIRECT --to-ports 53 -m comment --comment "NAT_LAN_CUSTOM_001"
  logger "NAT_LAN_CUSTOM_001 created"
fi
if [ "$NAT_LAN_CUSTOM_002_COUNT" -eq "0" ]; then
  sudo iptables -t nat -A PREROUTING -i "$LAN_INTERFACE" -p tcp --dport 53 ! -d "$DNS_SERVER_IP_ADDRESS" -j REDIRECT --to-ports 53 -m comment --comment "NAT_LAN_CUSTOM_002"
  logger "NAT_LAN_CUSTOM_002 created"
fi
