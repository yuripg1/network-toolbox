#!/bin/sh

logger "Checking and applying firewall rules"

# Helper functions

create_ipset() {
  local name="$1"
  local type="$2"
  local list_count=$(sudo ipset list | grep --count "$name")
  if [ "$list_count" -eq "0" ]; then
    sudo ipset create "$name" $type
    logger "sudo ipset create $name $type"
  fi
}

add_ipset_entry() {
  local name="$1"
  local entry="$2"
  sudo ipset add "$name" "$entry" -exist
  logger "sudo ipset add $name $entry -exist"
}

add_iptables_rule() {
  local protocol="$1"
  local comment="$2"
  local table="$3"
  local chain="$4"
  local rule="$5"
  local command=""
  case "$protocol" in
    ipv4) command="iptables" ;;
    ipv6) command="ip6tables" ;;
    *) return 1 ;;
  esac
  local list_rules_count=$(sudo $command --table "$table" --list-rules | grep --count "$comment")
  if [ "$list_rules_count" -eq "0" ]; then
    sudo $command --match comment --comment "$comment" --table "$table" --append "$chain" $rule
    logger "sudo $command --match comment --comment $comment --table $table --append $chain $rule"
  fi
}

# Interfaces

WAN_INTERFACE="pppoe0"
LAN_INTERFACE="switch0.10"

# IPv4 addresses

IPV4_DNS_ADDRESS="192.168.167.1/32"
IPV4_WAN_NAT_SOURCES="192.168.103.0/24"
IPV4_MODEM_NAT_SOURCES="192.168.103.0/24"
IPV4_MODEM_ADDRESS="192.168.237.1/32"

# IPv6 addresses

IPV6_DNS_ADDRESS="fd45:1e52:2abe:4c85::1/128"

# IPv4 TCP MSS clamping

add_iptables_rule "ipv4" "IPV4_MANGLE_1" "mangle" "PREROUTING" "--in-interface $WAN_INTERFACE --protocol tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --jump TCPMSS --set-mss 1452"
add_iptables_rule "ipv4" "IPV4_MANGLE_2" "mangle" "POSTROUTING" "--out-interface $WAN_INTERFACE --protocol tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --jump TCPMSS --set-mss 1452"

# IPv6 TCP MSS clamping

add_iptables_rule "ipv6" "IPV6_MANGLE_1" "mangle" "PREROUTING" "--in-interface $WAN_INTERFACE --protocol tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432"
add_iptables_rule "ipv6" "IPV6_MANGLE_2" "mangle" "POSTROUTING" "--out-interface $WAN_INTERFACE --protocol tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432"

# IPv4 DNAT to redirect all DNS queries

create_ipset "DNS_SERVER_PORT_2" "bitmap:port range 53-53"
add_ipset_entry "DNS_SERVER_PORT_2" "53"
create_ipset "IPV4_DNS_ADDRESS" "hash:net family inet hashsize 64 maxelem 1"
add_ipset_entry "IPV4_DNS_ADDRESS" $IPV4_DNS_ADDRESS
add_iptables_rule "ipv4" "IPV4_NAT_1" "nat" "PREROUTING" "--in-interface $LAN_INTERFACE --match set ! --match-set IPV4_DNS_ADDRESS dst --protocol udp --match set --match-set DNS_SERVER_PORT_2 dst --jump REDIRECT"
add_iptables_rule "ipv4" "IPV4_NAT_2" "nat" "PREROUTING" "--in-interface $LAN_INTERFACE --match set ! --match-set IPV4_DNS_ADDRESS dst --protocol tcp --match set --match-set DNS_SERVER_PORT_2 dst --jump REDIRECT"

# IPv6 DNAT to redirect all DNS queries

create_ipset "IPV6_DNS_ADDRESS" "hash:net family inet6 hashsize 64 maxelem 1"
add_ipset_entry "IPV6_DNS_ADDRESS" $IPV6_DNS_ADDRESS
add_iptables_rule "ipv6" "IPV6_NAT_1" "nat" "PREROUTING" "--in-interface $LAN_INTERFACE --match set ! --match-set IPV6_DNS_ADDRESS dst --protocol udp --match set --match-set DNS_SERVER_PORT_2 dst --jump REDIRECT"
add_iptables_rule "ipv6" "IPV6_NAT_2" "nat" "PREROUTING" "--in-interface $LAN_INTERFACE --match set ! --match-set IPV6_DNS_ADDRESS dst --protocol tcp --match set --match-set DNS_SERVER_PORT_2 dst --jump REDIRECT"

# IPv4 SNAT of private addresses for internet access

create_ipset "IPV4_WAN_NAT_SOURCES" "hash:net family inet"
add_ipset_entry "IPV4_WAN_NAT_SOURCES" $IPV4_WAN_NAT_SOURCES
add_iptables_rule "ipv4" "IPV4_NAT_3" "nat" "POSTROUTING" "--out-interface $WAN_INTERFACE --match set --match-set IPV4_WAN_NAT_SOURCES src --protocol tcp --jump MASQUERADE --to-ports 8081-51004"
add_iptables_rule "ipv4" "IPV4_NAT_4" "nat" "POSTROUTING" "--out-interface $WAN_INTERFACE --match set --match-set IPV4_WAN_NAT_SOURCES src --protocol udp --jump MASQUERADE --to-ports 8081-65535"
add_iptables_rule "ipv4" "IPV4_NAT_5" "nat" "POSTROUTING" "--out-interface $WAN_INTERFACE --match set --match-set IPV4_WAN_NAT_SOURCES src --jump MASQUERADE"

# IPv4 SNAT to bypass ISP blocking of incoming UDP packets on port 123

create_ipset "NTP_CLIENT_PORT" "bitmap:port range 123-123"
add_ipset_entry "NTP_CLIENT_PORT" "123"
add_iptables_rule "ipv4" "IPV4_NAT_6" "nat" "POSTROUTING" "--out-interface $WAN_INTERFACE --protocol udp --match set --match-set NTP_CLIENT_PORT src --jump SNAT --to-source :8081-65535"

# IPv6 SNAT to bypass ISP blocking of incoming UDP packets on port 123

add_iptables_rule "ipv6" "IPV6_NAT_3" "nat" "POSTROUTING" "--out-interface $WAN_INTERFACE --protocol udp --match set --match-set NTP_CLIENT_PORT src --jump SNAT --to-source :8081-65535"

# IPv4 SNAT of private addresses for modem access

create_ipset "IPV4_MODEM_NAT_SOURCES" "hash:net family inet"
add_ipset_entry "IPV4_MODEM_NAT_SOURCES" $IPV4_MODEM_NAT_SOURCES
create_ipset "IPV4_MODEM_ADDRESS" "hash:net family inet hashsize 64 maxelem 1"
add_ipset_entry "IPV4_MODEM_ADDRESS" $IPV4_MODEM_ADDRESS
add_iptables_rule "ipv4" "IPV4_NAT_7" "nat" "POSTROUTING" "--match set --match-set IPV4_MODEM_NAT_SOURCES src --match set --match-set IPV4_MODEM_ADDRESS dst --jump SNAT --to-source 192.168.237.2"
