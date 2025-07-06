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

# IPv4 TCP MSS clamping

add_iptables_rule "ipv4" "IPV4_MANGLE_1" "mangle" "PREROUTING" "--in-interface $WAN_INTERFACE --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --jump TCPMSS --set-mss 1452"
add_iptables_rule "ipv4" "IPV4_MANGLE_2" "mangle" "POSTROUTING" "--out-interface $WAN_INTERFACE --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --jump TCPMSS --set-mss 1452"

# IPv6 TCP MSS clamping

add_iptables_rule "ipv6" "IPV6_MANGLE_1" "mangle" "PREROUTING" "--in-interface $WAN_INTERFACE --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432"
add_iptables_rule "ipv6" "IPV6_MANGLE_2" "mangle" "POSTROUTING" "--out-interface $WAN_INTERFACE --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432"

# IPv4 DNAT redirecting all DNS queries to the router

create_ipset "DNS_PORT_2" "bitmap:port range 53-53"
add_ipset_entry "DNS_PORT_2" "53"
create_ipset "IPV4_DNS_ADDRESS" "hash:net family inet hashsize 64 maxelem 1"
add_ipset_entry "IPV4_DNS_ADDRESS" "192.168.167.1/32"
add_iptables_rule "ipv4" "IPV4_NAT_1" "nat" "PREROUTING" "--in-interface $LAN_INTERFACE --protocol udp --match set ! --match-set IPV4_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match udp --jump REDIRECT"
add_iptables_rule "ipv4" "IPV4_NAT_2" "nat" "PREROUTING" "--in-interface $LAN_INTERFACE --protocol tcp --match set ! --match-set IPV4_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match tcp --jump REDIRECT"

# IPv6 DNAT redirecting all DNS queries to the router

create_ipset "IPV6_DNS_ADDRESS" "hash:net family inet6 hashsize 64 maxelem 1"
add_ipset_entry "IPV6_DNS_ADDRESS" "fd45:1e52:2abe:4c85::1/128"
add_iptables_rule "ipv6" "IPV6_NAT_1" "nat" "PREROUTING" "--in-interface $LAN_INTERFACE --protocol udp --match set ! --match-set IPV6_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match udp --jump REDIRECT"
add_iptables_rule "ipv6" "IPV6_NAT_2" "nat" "PREROUTING" "--in-interface $LAN_INTERFACE --protocol tcp --match set ! --match-set IPV6_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match tcp --jump REDIRECT"

# IPv4 SNAT workaround for ISP blocking of incoming NTP packets (UDP/123)

create_ipset "NTP_PORT" "bitmap:port range 123-123"
add_ipset_entry "NTP_PORT" "123"
create_ipset "IPV4_WAN_NAT_SOURCES" "hash:net family inet"
add_ipset_entry "IPV4_WAN_NAT_SOURCES" "192.168.103.0/24"
add_iptables_rule "ipv4" "IPV4_NAT_3" "nat" "POSTROUTING" "--out-interface $WAN_INTERFACE --protocol udp --match set --match-set IPV4_WAN_NAT_SOURCES src --match set --match-set NTP_PORT src --jump MASQUERADE --to-ports 49152-65535"
add_iptables_rule "ipv4" "IPV4_NAT_4" "nat" "POSTROUTING" "--out-interface $WAN_INTERFACE --protocol udp --match set --match-set NTP_PORT src --jump SNAT --to-source :49152-65535"

# IPv6 SNAT workaround for ISP blocking of incoming NTP packets (UDP/123)

add_iptables_rule "ipv6" "IPV6_NAT_3" "nat" "POSTROUTING" "--out-interface $WAN_INTERFACE --protocol udp --match set --match-set NTP_PORT src --match udp --jump SNAT --to-source :49152-65535"

# IPv4 SNAT of private addresses for internet access

add_iptables_rule "ipv4" "IPV4_NAT_5" "nat" "POSTROUTING" "--out-interface $WAN_INTERFACE --match set --match-set IPV4_WAN_NAT_SOURCES src --jump MASQUERADE"

# IPv4 SNAT of private addresses for modem access

create_ipset "IPV4_MODEM_NAT_SOURCES" "hash:net family inet"
add_ipset_entry "IPV4_MODEM_NAT_SOURCES" "192.168.103.0/24"
create_ipset "IPV4_MODEM_ADDRESS" "hash:net family inet hashsize 64 maxelem 1"
add_ipset_entry "IPV4_MODEM_ADDRESS" "192.168.237.1/32"
add_iptables_rule "ipv4" "IPV4_NAT_6" "nat" "POSTROUTING" "--match set --match-set IPV4_MODEM_NAT_SOURCES src --match set --match-set IPV4_MODEM_ADDRESS dst --jump SNAT --to-source 192.168.237.2"
