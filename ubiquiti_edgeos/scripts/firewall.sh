#!/bin/sh

logger "Applying firewall rules"

# Interfaces

WAN_INTERFACE="pppoe0"

LAN_VLAN_10_INTERFACE="switch0.10"

# Ports

DNS_PORT_2_COUNT=$(sudo ipset list | grep --count "DNS_PORT_2")
if [ "$DNS_PORT_2_COUNT" -eq "0" ]; then
  sudo ipset create DNS_PORT_2 bitmap:port range 53-53
  logger "DNS_PORT_2 created"
fi

sudo ipset add DNS_PORT_2 53 -exist

NTP_PORT_COUNT=$(sudo ipset list | grep --count "NTP_PORT")
if [ "$NTP_PORT_COUNT" -eq "0" ]; then
  sudo ipset create NTP_PORT bitmap:port range 123-123
  logger "NTP_PORT created"
fi

sudo ipset add NTP_PORT 123 -exist

# IPv6 addresses

IPV6_DNS_ADDRESS_COUNT=$(sudo ipset list | grep --count "IPV6_DNS_ADDRESS")
if [ "$IPV6_DNS_ADDRESS_COUNT" -eq "0" ]; then
  sudo ipset create IPV6_DNS_ADDRESS hash:net family inet6 hashsize 64 maxelem 1
  logger "IPV6_DNS_ADDRESS created"
fi

sudo ipset add IPV6_DNS_ADDRESS "fd45:1e52:2abe:4c85::1/128" -exist

# IPv6 mangle

IPV6_MANGLE_1_COUNT=$(sudo ip6tables --table mangle --list-rules | grep --count "IPV6_MANGLE_1")
if [ "$IPV6_MANGLE_1_COUNT" -eq "0" ]; then
  sudo ip6tables --table mangle --append PREROUTING --in-interface "$WAN_INTERFACE" --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432 --match comment --comment "IPV6_MANGLE_1"
  logger "IPV6_MANGLE_1 created"
fi

IPV6_MANGLE_2_COUNT=$(sudo ip6tables --table mangle --list-rules | grep --count "IPV6_MANGLE_2")
if [ "$IPV6_MANGLE_2_COUNT" -eq "0" ]; then
  sudo ip6tables --table mangle --append POSTROUTING --out-interface "$WAN_INTERFACE" --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432 --match comment --comment "IPV6_MANGLE_2"
  logger "IPV6_MANGLE_2 created"
fi

# IPv6 NAT

IPV6_NAT_1_COUNT=$(sudo ip6tables --table nat --list-rules | grep --count "IPV6_NAT_1")
if [ "$IPV6_NAT_1_COUNT" -eq "0" ]; then
  sudo ip6tables --table nat --append PREROUTING --in-interface "$LAN_VLAN_10_INTERFACE" --protocol udp --match set ! --match-set IPV6_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match udp --match comment --comment "IPV6_NAT_1" --jump REDIRECT
  logger "IPV6_NAT_1 created"
fi

IPV6_NAT_2_COUNT=$(sudo ip6tables --table nat --list-rules | grep --count "IPV6_NAT_2")
if [ "$IPV6_NAT_2_COUNT" -eq "0" ]; then
  sudo ip6tables --table nat --append PREROUTING --in-interface "$LAN_VLAN_10_INTERFACE" --protocol tcp --match set ! --match-set IPV6_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match tcp --match comment --comment "IPV6_NAT_2" --jump REDIRECT
  logger "IPV6_NAT_2 created"
fi

IPV6_NAT_3_COUNT=$(sudo ip6tables --table nat --list-rules | grep --count "IPV6_NAT_3")
if [ "$IPV6_NAT_3_COUNT" -eq "0" ]; then
  sudo ip6tables --table nat --append POSTROUTING --out-interface "$WAN_INTERFACE" --protocol udp --match set --match-set NTP_PORT src --match udp --match comment --comment "IPV6_NAT_3" --jump SNAT --to-source :49152-65535
  logger "IPV6_NAT_3 created"
fi

# IPv4 addresses

IPV4_DNS_ADDRESS_COUNT=$(sudo ipset list | grep --count "IPV4_DNS_ADDRESS")
if [ "$IPV4_DNS_ADDRESS_COUNT" -eq "0" ]; then
  sudo ipset create IPV4_DNS_ADDRESS hash:net family inet hashsize 64 maxelem 1
  logger "IPV4_DNS_ADDRESS created"
fi

sudo ipset add IPV4_DNS_ADDRESS "192.168.167.1/32" -exist

IPV4_PRIVATE_ADDRESSES_COUNT=$(sudo ipset list | grep --count "IPV4_PRIVATE_ADDRESSES")
if [ "$IPV4_PRIVATE_ADDRESSES_COUNT" -eq "0" ]; then
  sudo ipset create IPV4_PRIVATE_ADDRESSES hash:net family inet
  logger "IPV4_PRIVATE_ADDRESSES created"
fi

sudo ipset add IPV4_PRIVATE_ADDRESSES "192.168.103.0/24" -exist

IPV4_MODEM_ADDRESS_COUNT=$(sudo ipset list | grep --count "IPV4_MODEM_ADDRESS")
if [ "$IPV4_MODEM_ADDRESS_COUNT" -eq "0" ]; then
  sudo ipset create IPV4_MODEM_ADDRESS hash:net family inet hashsize 64 maxelem 1
  logger "IPV4_MODEM_ADDRESS created"
fi

sudo ipset add IPV4_MODEM_ADDRESS "192.168.237.1/32" -exist

# IPv4 mangle

IPV4_MANGLE_1_COUNT=$(sudo iptables --table mangle --list-rules | grep --count "IPV4_MANGLE_1")
if [ "$IPV4_MANGLE_1_COUNT" -eq "0" ]; then
  sudo iptables --table mangle --append PREROUTING --in-interface "$WAN_INTERFACE" --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --match comment --comment "IPV4_MANGLE_1" --jump TCPMSS --set-mss 1452
  logger "IPV4_MANGLE_1 created"
fi

IPV4_MANGLE_2_COUNT=$(sudo iptables --table mangle --list-rules | grep --count "IPV4_MANGLE_2")
if [ "$IPV4_MANGLE_2_COUNT" -eq "0" ]; then
  sudo iptables --table mangle --append POSTROUTING --out-interface "$WAN_INTERFACE" --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --match comment --comment "IPV4_MANGLE_2" --jump TCPMSS --set-mss 1452
  logger "IPV4_MANGLE_2 created"
fi

# IPv4 NAT

IPV4_NAT_1_COUNT=$(sudo iptables --table nat --list-rules | grep --count "IPV4_NAT_1")
if [ "$IPV4_NAT_1_COUNT" -eq "0" ]; then
  sudo iptables --table nat --append PREROUTING --in-interface "$LAN_VLAN_10_INTERFACE" --protocol udp --match set ! --match-set IPV4_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match udp --match comment --comment "IPV4_NAT_1" --jump REDIRECT
  logger "IPV4_NAT_1 created"
fi

IPV4_NAT_2_COUNT=$(sudo iptables --table nat --list-rules | grep --count "IPV4_NAT_2")
if [ "$IPV4_NAT_2_COUNT" -eq "0" ]; then
  sudo iptables --table nat --append PREROUTING --in-interface "$LAN_VLAN_10_INTERFACE" --protocol tcp --match set ! --match-set IPV4_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match tcp --match comment --comment "IPV4_NAT_2" --jump REDIRECT
  logger "IPV4_NAT_2 created"
fi

IPV4_NAT_3_COUNT=$(sudo iptables --table nat --list-rules | grep --count "IPV4_NAT_3")
if [ "$IPV4_NAT_3_COUNT" -eq "0" ]; then
  sudo iptables --table nat --append POSTROUTING --out-interface "$WAN_INTERFACE" --protocol udp --match set --match-set IPV4_PRIVATE_ADDRESSES src --match set --match-set NTP_PORT src --match comment --comment "IPV4_NAT_3" --jump MASQUERADE --to-ports 49152-65535
  logger "IPV4_NAT_3 created"
fi

IPV4_NAT_4_COUNT=$(sudo iptables --table nat --list-rules | grep --count "IPV4_NAT_4")
if [ "$IPV4_NAT_4_COUNT" -eq "0" ]; then
  sudo iptables --table nat --append POSTROUTING --out-interface "$WAN_INTERFACE" --protocol udp --match set --match-set NTP_PORT src --match comment --comment "IPV4_NAT_4" --jump SNAT --to-source :49152-65535
  logger "IPV4_NAT_4 created"
fi

IPV4_NAT_5_COUNT=$(sudo iptables --table nat --list-rules | grep --count "IPV4_NAT_5")
if [ "$IPV4_NAT_5_COUNT" -eq "0" ]; then
  sudo iptables --table nat --append POSTROUTING --out-interface "$WAN_INTERFACE" --match set --match-set IPV4_PRIVATE_ADDRESSES src --match comment --comment "IPV4_NAT_5" --jump MASQUERADE
  logger "IPV4_NAT_5 created"
fi

IPV4_NAT_6_COUNT=$(sudo iptables --table nat --list-rules | grep --count "IPV4_NAT_6")
if [ "$IPV4_NAT_6_COUNT" -eq "0" ]; then
  sudo iptables --table nat --append POSTROUTING --match set --match-set IPV4_PRIVATE_ADDRESSES src --match set --match-set IPV4_MODEM_ADDRESS dst --match comment --comment "IPV4_NAT_6" --jump SNAT --to-source 192.168.237.2
  logger "IPV4_NAT_6 created"
fi
