#!/bin/sh
LAN_INTERFACE="switch0.10"
DNS_SERVER_IP_ADDRESS="10.189.117.1"
logger "Checking IPv4 NAT rules on LAN interface $LAN_INTERFACE"
NAT_LAN_CUSTOM_001_COUNT=$(sudo iptables --table nat --list  --verbose --numeric | grep --count "NAT_LAN_CUSTOM_001")
NAT_LAN_CUSTOM_002_COUNT=$(sudo iptables --table nat --list  --verbose --numeric | grep --count "NAT_LAN_CUSTOM_002")
if [ "$NAT_LAN_CUSTOM_001_COUNT" -eq "0" ]; then
  sudo iptables --table nat --append PREROUTING --in-interface "$LAN_INTERFACE" --protocol udp --dport 53 ! --destination "$DNS_SERVER_IP_ADDRESS" --jump REDIRECT --to-ports 53 --match comment --comment "NAT_LAN_CUSTOM_001"
  logger "NAT_LAN_CUSTOM_001 created"
fi
if [ "$NAT_LAN_CUSTOM_002_COUNT" -eq "0" ]; then
  sudo iptables --table nat --append PREROUTING --in-interface "$LAN_INTERFACE" --protocol tcp --dport 53 ! --destination "$DNS_SERVER_IP_ADDRESS" --jump REDIRECT --to-ports 53 --match comment --comment "NAT_LAN_CUSTOM_002"
  logger "NAT_LAN_CUSTOM_002 created"
fi
