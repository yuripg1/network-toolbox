#!/bin/sh
LAN_INTERFACE="switch0.10"
IPV4_DNS_ADDRESS="10.189.117.1/32"
logger "Checking IPv4 NAT rules on LAN interface $LAN_INTERFACE"
IPV4_NAT_LAN_CUSTOM_001_COUNT=$(sudo iptables --table nat --list  --verbose --numeric | grep --count "IPV4_NAT_LAN_CUSTOM_001")
IPV4_NAT_LAN_CUSTOM_002_COUNT=$(sudo iptables --table nat --list  --verbose --numeric | grep --count "IPV4_NAT_LAN_CUSTOM_002")
if [ "$IPV4_NAT_LAN_CUSTOM_001_COUNT" -eq "0" ]; then
  sudo iptables --table nat --append PREROUTING --in-interface "$LAN_INTERFACE" --protocol udp --dport 53 ! --destination "$IPV4_DNS_ADDRESS" --jump REDIRECT --to-ports 53 --match comment --comment "IPV4_NAT_LAN_CUSTOM_001"
  logger "IPV4_NAT_LAN_CUSTOM_001 created"
fi
if [ "$IPV4_NAT_LAN_CUSTOM_002_COUNT" -eq "0" ]; then
  sudo iptables --table nat --append PREROUTING --in-interface "$LAN_INTERFACE" --protocol tcp --dport 53 ! --destination "$IPV4_DNS_ADDRESS" --jump REDIRECT --to-ports 53 --match comment --comment "IPV4_NAT_LAN_CUSTOM_002"
  logger "IPV4_NAT_LAN_CUSTOM_002 created"
fi
