#!/bin/sh
LAN_INTERFACE="switch0.10"
IPV4_DNS_ADDRESS="192.168.167.1/32"
logger "Applying IPv4 NAT rules on LAN interface $LAN_INTERFACE"
IPV4_NAT_LAN_1_COUNT=$(sudo iptables --table nat --list  --verbose --numeric | grep --count "IPV4_NAT_LAN_1")
if [ "$IPV4_NAT_LAN_1_COUNT" -eq "0" ]; then
  sudo iptables --table nat --append PREROUTING --in-interface "$LAN_INTERFACE" --protocol udp --dport 53 ! --destination "$IPV4_DNS_ADDRESS" --jump REDIRECT --to-ports 53 --match comment --comment "IPV4_NAT_LAN_1"
  logger "IPV4_NAT_LAN_1 created"
fi
IPV4_NAT_LAN_2_COUNT=$(sudo iptables --table nat --list  --verbose --numeric | grep --count "IPV4_NAT_LAN_2")
if [ "$IPV4_NAT_LAN_2_COUNT" -eq "0" ]; then
  sudo iptables --table nat --append PREROUTING --in-interface "$LAN_INTERFACE" --protocol tcp --dport 53 ! --destination "$IPV4_DNS_ADDRESS" --jump REDIRECT --to-ports 53 --match comment --comment "IPV4_NAT_LAN_2"
  logger "IPV4_NAT_LAN_2 created"
fi
