#!/bin/sh
LAN_INTERFACE="switch0.10"
IPV6_DNS_ADDRESS="fd1a:ac95:26c8:c75f::1/128"
logger "Checking IPv6 NAT rules on LAN interface $LAN_INTERFACE"
IPV6_NAT_LAN_CUSTOM_001_COUNT=$(sudo ip6tables --table nat --list  --verbose --numeric | grep --count "IPV6_NAT_LAN_CUSTOM_001")
IPV6_NAT_LAN_CUSTOM_002_COUNT=$(sudo ip6tables --table nat --list  --verbose --numeric | grep --count "IPV6_NAT_LAN_CUSTOM_002")
if [ "$IPV6_NAT_LAN_CUSTOM_001_COUNT" -eq "0" ]; then
  sudo ip6tables --table nat --append PREROUTING --in-interface "$LAN_INTERFACE" --protocol udp --dport 53 ! -d "$IPV6_DNS_ADDRESS" --jump REDIRECT --to-ports 53 --match comment --comment "IPV6_NAT_LAN_CUSTOM_001"
  logger "IPV6_NAT_LAN_CUSTOM_001 created"
fi
if [ "$IPV6_NAT_LAN_CUSTOM_002_COUNT" -eq "0" ]; then
  sudo ip6tables --table nat --append PREROUTING --in-interface "$LAN_INTERFACE" --protocol tcp --dport 53 ! -d "$IPV6_DNS_ADDRESS" --jump REDIRECT --to-ports 53 --match comment --comment "IPV6_NAT_LAN_CUSTOM_002"
  logger "IPV6_NAT_LAN_CUSTOM_002 created"
fi
