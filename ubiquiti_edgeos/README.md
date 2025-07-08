## Router management

### Protocols and ports

* HTTPS: TCP/18856 (**[https://home-router.lan:18856/](https://home-router.lan:18856/)**)
* SSH: TCP/36518

### Credential

Username: **username920169077**</br>
Password: **password767865354**

## Zone-based firewall policies

### IPv4

| <nobr>From&nbsp;\\&nbsp;To</nobr> | Local                                  | LAN                                    | WAN                                 | Modem                               |
|----------------------------------:|:--------------------------------------:|:--------------------------------------:|:-----------------------------------:|:-----------------------------------:|
| Local                             | ✅                                     | <nobr>IPV4_ALLOW_ALL_TRAFFIC</nobr>    | <nobr>IPV4_ALLOW_ALL_TRAFFIC</nobr> | <nobr>IPV4_ALLOW_ALL_TRAFFIC</nobr> |
| LAN                               | <nobr>IPV4_LAN_TO_LOCAL</nobr>         | ✅                                     | <nobr>IPV4_ALLOW_ALL_TRAFFIC</nobr> | <nobr>IPV4_LAN_TO_MODEM</nobr>      |
| WAN                               | <nobr>IPV4_WAN_TO_LOCAL</nobr>         | <nobr>IPV4_WAN_TO_LAN</nobr>           | ✅                                  | ❌                                  |
| Modem                             | <nobr>IPV4_ALLOW_RETURN_TRAFFIC</nobr> | <nobr>IPV4_ALLOW_RETURN_TRAFFIC</nobr> | ❌                                  | ✅                                  |

### IPv6

| <nobr>From&nbsp;\\&nbsp;To</nobr> | Local                          | LAN                                 | WAN                                 | Modem |
|----------------------------------:|:------------------------------:|:-----------------------------------:|:-----------------------------------:|:-----:|
| Local                             | ✅                             | <nobr>IPV6_ALLOW_ALL_TRAFFIC</nobr> | <nobr>IPV6_ALLOW_ALL_TRAFFIC</nobr> | ❌    |
| LAN                               | <nobr>IPV6_LAN_TO_LOCAL</nobr> | ✅                                  | <nobr>IPV6_ALLOW_ALL_TRAFFIC</nobr> | ❌    |
| WAN                               | <nobr>IPV6_WAN_TO_LOCAL</nobr> | <nobr>IPV6_WAN_TO_LAN</nobr>        | ✅                                  | ❌    |
| Modem                             | ❌                             | ❌                                  | ❌                                  | ✅    |

## Required files

### Keys and certificates

* certificate_authority.crt
* management_https.crt
* management_https.key

Follow the steps at **[Keys and certificates](../keys_and_certificates)** to create the keys and certificates

## Configuration commands

### New credential configuration

```
set system login user username920169077 authentication plaintext-password 'password767865354'
set system login user username920169077 level admin
```

### Default credential removal

```
delete system login user ubnt
```

### Configuration of management via SSH

```
set service ssh port 36518
set service ssh protocol-version v2
```

### Host name configuration

```
set system host-name Home-Router
```

### Loopback interface configuration

```
set interfaces loopback lo description 'Loopback (Local)'
```

### Ethernet interfaces configuration

```
delete interfaces ethernet eth1 address
set interfaces ethernet eth0 description 'eth0 (Modem)'
set interfaces ethernet eth0 duplex auto
set interfaces ethernet eth0 mac 'D0:21:F9:90:67:BD'
set interfaces ethernet eth0 mtu 1500
set interfaces ethernet eth0 speed auto
set interfaces ethernet eth1 description 'eth1 - Switch - Trunk'
set interfaces ethernet eth1 duplex auto
set interfaces ethernet eth1 mac 'D0:21:F9:82:0D:94'
set interfaces ethernet eth1 mtu 1500
set interfaces ethernet eth1 speed auto
set interfaces ethernet eth2 description 'eth2 - Switch - VLAN 10'
set interfaces ethernet eth2 duplex auto
set interfaces ethernet eth2 mac 'D0:21:F9:D5:0A:39'
set interfaces ethernet eth2 mtu 1500
set interfaces ethernet eth2 speed auto
set interfaces ethernet eth3 description 'eth3 - Switch - VLAN 10'
set interfaces ethernet eth3 duplex auto
set interfaces ethernet eth3 mac 'D0:21:F9:0E:6E:DA'
set interfaces ethernet eth3 mtu 1500
set interfaces ethernet eth3 speed auto
set interfaces ethernet eth4 description 'eth4 - Switch - VLAN 10'
set interfaces ethernet eth4 duplex auto
set interfaces ethernet eth4 mac 'D0:21:F9:76:B7:33'
set interfaces ethernet eth4 mtu 1500
set interfaces ethernet eth4 speed auto
```

### Switch interfaces configuration

```
set interfaces switch switch0 description Switch
set interfaces switch switch0 mtu 1500
set interfaces switch switch0 switch-port interface eth1 vlan pvid 1
set interfaces switch switch0 switch-port interface eth1 vlan vid 10
set interfaces switch switch0 switch-port interface eth2 vlan pvid 10
set interfaces switch switch0 switch-port interface eth3 vlan pvid 10
set interfaces switch switch0 switch-port interface eth4 vlan pvid 10
set interfaces switch switch0 switch-port vlan-aware enable
set interfaces switch switch0 vif 1 description 'Switch - VLAN 1'
set interfaces switch switch0 vif 10 description 'Switch - VLAN 10 (LAN)'
```

### DNS configuration

```
set service dns forwarding cache-size 10000
set service dns forwarding listen-on switch0.10
set service dns forwarding name-server '2001:4860:4860::8844'
set service dns forwarding name-server '2001:4860:4860::8888'
set service dns forwarding options bogus-priv
set service dns forwarding options domain-needed
```

### IPv4 kernel configuration

```
set firewall all-ping enable
set firewall broadcast-ping disable
set firewall ip-src-route disable
set firewall receive-redirects disable
set firewall send-redirects enable
set firewall source-validation disable
set firewall syn-cookies enable
```

### IPv6 kernel configuration

```
set firewall ipv6-receive-redirects disable
set firewall ipv6-src-route disable
```

### IPv4 loopback address configuration

```
set interfaces loopback lo address 192.168.167.1/32
```

### IPv6 loopback address configuration

```
set interfaces loopback lo address 'fd45:1e52:2abe:4c85::1/128'
```

### IPv4 LAN address configuration

```
set interfaces switch switch0 vif 10 address 192.168.103.254/24
```

### IPv4 LAN DHCP server configuration

```
set service dhcp-server shared-network-name VLAN_10 authoritative enable
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 default-router 192.168.103.254
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 dns-server 192.168.167.1
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 lease 57600
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 start 192.168.103.1 stop 192.168.103.253
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 subnet-parameters 'option default-ip-ttl 64;'
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 subnet-parameters 'option interface-mtu 1492;'
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 subnet-parameters 'option broadcast-address 192.168.103.255;'
set service dhcp-server static-arp enable
```

### IPv6 LAN SLAAC configuration

```
set interfaces switch switch0 vif 10 ipv6 dup-addr-detect-transmits 1
set interfaces switch switch0 vif 10 ipv6 router-advert cur-hop-limit 64
set interfaces switch switch0 vif 10 ipv6 router-advert default-lifetime 9000
set interfaces switch switch0 vif 10 ipv6 router-advert default-preference medium
set interfaces switch switch0 vif 10 ipv6 router-advert link-mtu 1492
set interfaces switch switch0 vif 10 ipv6 router-advert managed-flag false
set interfaces switch switch0 vif 10 ipv6 router-advert max-interval 600
set interfaces switch switch0 vif 10 ipv6 router-advert min-interval 200
set interfaces switch switch0 vif 10 ipv6 router-advert name-server 'fd45:1e52:2abe:4c85::1'
set interfaces switch switch0 vif 10 ipv6 router-advert other-config-flag false
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' autonomous-flag true
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' on-link-flag true
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' preferred-lifetime 57600
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' valid-lifetime 86400
set interfaces switch switch0 vif 10 ipv6 router-advert send-advert true
```

### IPv4 static DNS configuration

```
set system static-host-mapping host-name home-router.lan inet 192.168.167.1
set system static-host-mapping host-name ipv4.home-router.lan inet 192.168.167.1
```

### IPv6 static DNS configuration

```
set system static-host-mapping host-name home-router.lan inet 'fd45:1e52:2abe:4c85::1'
set system static-host-mapping host-name ipv6.home-router.lan inet 'fd45:1e52:2abe:4c85::1'
```

### IPv4 firewall rule sets

```
set firewall group address-group IPV4_INVALID_WAN_SOURCES address 127.0.0.0/8
set firewall group address-group IPV4_INVALID_WAN_SOURCES address 192.168.167.1
set firewall group address-group IPV4_INVALID_WAN_SOURCES address 192.168.103.0/24
set firewall group address-group IPV4_INVALID_WAN_SOURCES address 192.168.237.0/30
set firewall group address-group IPV4_LAN_SOURCES address 192.168.103.0/24
set firewall group port-group DHCP_PORT port 67
set firewall group port-group DNS_PORT port 53
set firewall group port-group MANAGEMENT_HTTPS_PORT port 18856
set firewall group port-group MANAGEMENT_HTTP_PORT port 45631
set firewall group port-group MANAGEMENT_SSH_PORT port 36518
set firewall name IPV4_ALLOW_ALL_TRAFFIC default-action accept
set firewall name IPV4_ALLOW_ALL_TRAFFIC description 'Allow all traffic'
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 10 action accept
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 10 description 'Accept ESTABLISHED,NEW,RELATED packets'
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 10 state established enable
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 10 state new enable
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 10 state related enable
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 20 action drop
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 20 description 'Drop INVALID packets'
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 20 state invalid enable
set firewall name IPV4_ALLOW_RETURN_TRAFFIC default-action drop
set firewall name IPV4_ALLOW_RETURN_TRAFFIC description 'Allow return traffic'
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 10 action accept
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 10 state established enable
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 10 state related enable
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 20 action drop
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 20 description 'Drop INVALID packets'
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 20 state invalid enable
set firewall name IPV4_LAN_TO_LOCAL default-action drop
set firewall name IPV4_LAN_TO_LOCAL description 'Check packets going from LAN to Local'
set firewall name IPV4_LAN_TO_LOCAL rule 10 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall name IPV4_LAN_TO_LOCAL rule 10 state established enable
set firewall name IPV4_LAN_TO_LOCAL rule 10 state related enable
set firewall name IPV4_LAN_TO_LOCAL rule 20 action drop
set firewall name IPV4_LAN_TO_LOCAL rule 20 description 'Drop INVALID packets'
set firewall name IPV4_LAN_TO_LOCAL rule 20 state invalid enable
set firewall name IPV4_LAN_TO_LOCAL rule 30 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 30 description 'Accept DHCP packets'
set firewall name IPV4_LAN_TO_LOCAL rule 30 destination group port-group DHCP_PORT
set firewall name IPV4_LAN_TO_LOCAL rule 30 protocol udp
set firewall name IPV4_LAN_TO_LOCAL rule 30 source address 0.0.0.0
set firewall name IPV4_LAN_TO_LOCAL rule 40 action drop
set firewall name IPV4_LAN_TO_LOCAL rule 40 description 'Drop packets with spoofed source addresses'
set firewall name IPV4_LAN_TO_LOCAL rule 40 source group address-group '!IPV4_LAN_SOURCES'
set firewall name IPV4_LAN_TO_LOCAL rule 50 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 50 description 'Accept DHCP packets'
set firewall name IPV4_LAN_TO_LOCAL rule 50 destination group port-group DHCP_PORT
set firewall name IPV4_LAN_TO_LOCAL rule 50 protocol udp
set firewall name IPV4_LAN_TO_LOCAL rule 60 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 60 description 'Accept TCP DNS packets'
set firewall name IPV4_LAN_TO_LOCAL rule 60 destination group port-group DNS_PORT
set firewall name IPV4_LAN_TO_LOCAL rule 60 protocol tcp
set firewall name IPV4_LAN_TO_LOCAL rule 70 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 70 description 'Accept UDP DNS packets'
set firewall name IPV4_LAN_TO_LOCAL rule 70 destination group port-group DNS_PORT
set firewall name IPV4_LAN_TO_LOCAL rule 70 protocol udp
set firewall name IPV4_LAN_TO_LOCAL rule 80 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 80 description 'Accept management via HTTPS'
set firewall name IPV4_LAN_TO_LOCAL rule 80 destination group port-group MANAGEMENT_HTTPS_PORT
set firewall name IPV4_LAN_TO_LOCAL rule 80 protocol tcp
set firewall name IPV4_LAN_TO_LOCAL rule 90 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 90 description 'Accept management via SSH'
set firewall name IPV4_LAN_TO_LOCAL rule 90 destination group port-group MANAGEMENT_SSH_PORT
set firewall name IPV4_LAN_TO_LOCAL rule 90 protocol tcp
set firewall name IPV4_LAN_TO_LOCAL rule 100 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 100 description 'Accept ICMP Echo Request packets'
set firewall name IPV4_LAN_TO_LOCAL rule 100 icmp code 0
set firewall name IPV4_LAN_TO_LOCAL rule 100 icmp type 8
set firewall name IPV4_LAN_TO_LOCAL rule 100 protocol icmp
set firewall name IPV4_LAN_TO_MODEM default-action drop
set firewall name IPV4_LAN_TO_MODEM description 'Check packets going from LAN to Modem'
set firewall name IPV4_LAN_TO_MODEM rule 10 action accept
set firewall name IPV4_LAN_TO_MODEM rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall name IPV4_LAN_TO_MODEM rule 10 state established enable
set firewall name IPV4_LAN_TO_MODEM rule 10 state related enable
set firewall name IPV4_LAN_TO_MODEM rule 20 action drop
set firewall name IPV4_LAN_TO_MODEM rule 20 description 'Drop INVALID packets'
set firewall name IPV4_LAN_TO_MODEM rule 20 state invalid enable
set firewall name IPV4_LAN_TO_MODEM rule 30 action accept
set firewall name IPV4_LAN_TO_MODEM rule 30 description 'Accept management via HTTP'
set firewall name IPV4_LAN_TO_MODEM rule 30 destination group port-group MANAGEMENT_HTTP_PORT
set firewall name IPV4_LAN_TO_MODEM rule 30 protocol tcp
set firewall name IPV4_WAN_TO_LAN default-action drop
set firewall name IPV4_WAN_TO_LAN description 'Check packets going from WAN to LAN'
set firewall name IPV4_WAN_TO_LAN rule 10 action accept
set firewall name IPV4_WAN_TO_LAN rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall name IPV4_WAN_TO_LAN rule 10 state established enable
set firewall name IPV4_WAN_TO_LAN rule 10 state related enable
set firewall name IPV4_WAN_TO_LAN rule 20 action drop
set firewall name IPV4_WAN_TO_LAN rule 20 description 'Drop INVALID packets'
set firewall name IPV4_WAN_TO_LAN rule 20 state invalid enable
set firewall name IPV4_WAN_TO_LAN rule 30 action drop
set firewall name IPV4_WAN_TO_LAN rule 30 description 'Drop packets with spoofed source addresses'
set firewall name IPV4_WAN_TO_LAN rule 30 source group address-group IPV4_INVALID_WAN_SOURCES
set firewall name IPV4_WAN_TO_LOCAL default-action drop
set firewall name IPV4_WAN_TO_LOCAL description 'Check packets going from WAN to Local'
set firewall name IPV4_WAN_TO_LOCAL rule 10 action accept
set firewall name IPV4_WAN_TO_LOCAL rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall name IPV4_WAN_TO_LOCAL rule 10 state established enable
set firewall name IPV4_WAN_TO_LOCAL rule 10 state related enable
set firewall name IPV4_WAN_TO_LOCAL rule 20 action drop
set firewall name IPV4_WAN_TO_LOCAL rule 20 description 'Drop INVALID packets'
set firewall name IPV4_WAN_TO_LOCAL rule 20 state invalid enable
set firewall name IPV4_WAN_TO_LOCAL rule 30 action drop
set firewall name IPV4_WAN_TO_LOCAL rule 30 description 'Drop packets with spoofed source addresses'
set firewall name IPV4_WAN_TO_LOCAL rule 30 source group address-group IPV4_INVALID_WAN_SOURCES
set firewall name IPV4_WAN_TO_LOCAL rule 40 action accept
set firewall name IPV4_WAN_TO_LOCAL rule 40 description 'Accept ICMP Echo Request packets'
set firewall name IPV4_WAN_TO_LOCAL rule 40 icmp code 0
set firewall name IPV4_WAN_TO_LOCAL rule 40 icmp type 8
set firewall name IPV4_WAN_TO_LOCAL rule 40 protocol icmp
```

### IPv6 firewall rule sets

```
set firewall group ipv6-address-group IPV6_INVALID_LAN_SOURCES ipv6-address '::1'
set firewall group ipv6-address-group IPV6_INVALID_LAN_SOURCES ipv6-address 'fd45:1e52:2abe:4c85::1'
set firewall group ipv6-address-group IPV6_INVALID_WAN_SOURCES ipv6-address '::1'
set firewall group ipv6-address-group IPV6_INVALID_WAN_SOURCES ipv6-address 'fd45:1e52:2abe:4c85::1'
set firewall group ipv6-address-group IPV6_LAN_SLAAC_SOURCES ipv6-address 'fe80::/64'
set firewall group ipv6-address-group IPV6_LAN_SLAAC_SOURCES ipv6-address '::'
set firewall group ipv6-address-group IPV6_LINK_LOCAL_SOURCES ipv6-address 'fe80::/64'
set firewall group port-group DHCPV6_PORT port 546
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC default-action accept
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC description 'Allow all traffic'
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 10 action accept
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 10 description 'Accept ESTABLISHED,NEW,RELATED packets'
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 10 state established enable
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 10 state new enable
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 10 state related enable
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 20 action drop
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 20 description 'Drop INVALID packets'
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 20 state invalid enable
set firewall ipv6-name IPV6_LAN_TO_LOCAL default-action drop
set firewall ipv6-name IPV6_LAN_TO_LOCAL description 'Check packets going from LAN to Local'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 10 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 10 state established enable
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 10 state related enable
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 20 action drop
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 20 description 'Drop INVALID packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 20 state invalid enable
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 30 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 30 description 'Accept ICMPv6 Router Solicitation packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 30 icmpv6 type 133/0
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 30 protocol icmpv6
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 30 source group ipv6-address-group IPV6_LAN_SLAAC_SOURCES
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 40 action drop
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 40 description 'Drop packets with spoofed source addresses'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 40 source group ipv6-address-group IPV6_INVALID_LAN_SOURCES
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 50 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 50 description 'Accept TCP DNS packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 50 destination group port-group DNS_PORT
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 50 protocol tcp
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 60 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 60 description 'Accept UDP DNS packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 60 destination group port-group DNS_PORT
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 60 protocol udp
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 70 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 70 description 'Accept management via HTTPS'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 70 destination group port-group MANAGEMENT_HTTPS_PORT
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 70 protocol tcp
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 80 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 80 description 'Accept management via SSH'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 80 destination group port-group MANAGEMENT_SSH_PORT
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 80 protocol tcp
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 90 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 90 description 'Accept ICMPv6 Echo Request packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 90 icmpv6 type 128/0
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 90 protocol icmpv6
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 100 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 100 description 'Accept ICMPv6 Neighbor Solicitation packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 100 icmpv6 type 135/0
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 100 protocol icmpv6
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 110 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 110 description 'Accept ICMPv6 Neighbor Advertisement packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 110 icmpv6 type 136/0
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 110 protocol icmpv6
set firewall ipv6-name IPV6_WAN_TO_LAN default-action drop
set firewall ipv6-name IPV6_WAN_TO_LAN description 'Check packets going from WAN to LAN'
set firewall ipv6-name IPV6_WAN_TO_LAN rule 10 action accept
set firewall ipv6-name IPV6_WAN_TO_LAN rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall ipv6-name IPV6_WAN_TO_LAN rule 10 state established enable
set firewall ipv6-name IPV6_WAN_TO_LAN rule 10 state related enable
set firewall ipv6-name IPV6_WAN_TO_LAN rule 20 action drop
set firewall ipv6-name IPV6_WAN_TO_LAN rule 20 description 'Drop INVALID packets'
set firewall ipv6-name IPV6_WAN_TO_LAN rule 20 state invalid enable
set firewall ipv6-name IPV6_WAN_TO_LAN rule 30 action drop
set firewall ipv6-name IPV6_WAN_TO_LAN rule 30 description 'Drop packets with spoofed source addresses'
set firewall ipv6-name IPV6_WAN_TO_LAN rule 30 source group ipv6-address-group IPV6_INVALID_WAN_SOURCES
set firewall ipv6-name IPV6_WAN_TO_LAN rule 40 action accept
set firewall ipv6-name IPV6_WAN_TO_LAN rule 40 description 'Accept ICMPv6 Echo Request packets'
set firewall ipv6-name IPV6_WAN_TO_LAN rule 40 icmpv6 type 128/0
set firewall ipv6-name IPV6_WAN_TO_LAN rule 40 protocol icmpv6
set firewall ipv6-name IPV6_WAN_TO_LOCAL default-action drop
set firewall ipv6-name IPV6_WAN_TO_LOCAL description 'Check packets going from WAN to Local'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 10 action accept
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 10 state established enable
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 10 state related enable
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 20 action drop
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 20 description 'Drop INVALID packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 20 state invalid enable
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 30 action accept
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 30 description 'Accept DHCPv6 packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 30 destination group port-group DHCPV6_PORT
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 30 protocol udp
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 30 source group ipv6-address-group IPV6_LINK_LOCAL_SOURCES
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 40 action accept
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 40 description 'Accept ICMPv6 Router Advertisement packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 40 icmpv6 type 134/0
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 40 protocol icmpv6
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 40 source group ipv6-address-group IPV6_LINK_LOCAL_SOURCES
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 50 action drop
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 50 description 'Drop packets with spoofed source addresses'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 50 source group ipv6-address-group IPV6_INVALID_WAN_SOURCES
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 60 action accept
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 60 description 'Accept ICMPv6 Echo Request packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 60 icmpv6 type 128/0
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 60 protocol icmpv6
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 70 action accept
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 70 description 'Accept ICMPv6 Neighbor Solicitation packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 70 icmpv6 type 135/0
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 70 protocol icmpv6
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 80 action accept
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 80 description 'Accept ICMPv6 Neighbor Advertisement packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 80 icmpv6 type 136/0
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 80 protocol icmpv6
```

### IPv4 firewall zone policies for LAN, Local and Modem

```
set zone-policy zone LAN default-action drop
set zone-policy zone LAN description 'LAN zone'
set zone-policy zone LAN from LOCAL firewall name IPV4_ALLOW_ALL_TRAFFIC
set zone-policy zone LAN from MODEM firewall name IPV4_ALLOW_RETURN_TRAFFIC
set zone-policy zone LAN interface switch0.10
set zone-policy zone LOCAL default-action drop
set zone-policy zone LOCAL description 'Local zone'
set zone-policy zone LOCAL from LAN firewall name IPV4_LAN_TO_LOCAL
set zone-policy zone LOCAL from MODEM firewall name IPV4_ALLOW_RETURN_TRAFFIC
set zone-policy zone LOCAL local-zone
set zone-policy zone MODEM default-action drop
set zone-policy zone MODEM description 'Modem zone'
set zone-policy zone MODEM from LAN firewall name IPV4_LAN_TO_MODEM
set zone-policy zone MODEM from LOCAL firewall name IPV4_ALLOW_ALL_TRAFFIC
set zone-policy zone MODEM interface eth0
```

### IPv6 firewall zone policies for LAN, Local and Modem

```
set zone-policy zone LAN from LOCAL firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC
set zone-policy zone LOCAL from LAN firewall ipv6-name IPV6_LAN_TO_LOCAL
```

### IPv4 address configuration for modem access

```
delete interfaces ethernet eth0 address
set interfaces ethernet eth0 address 192.168.237.2/30
```

### IPv4 WAN PPPoE client configuration

```
set interfaces ethernet eth0 vif 600 description 'eth0 - VLAN 600'
set interfaces ethernet eth0 vif 600 pppoe 0 default-route auto
set interfaces ethernet eth0 vif 600 pppoe 0 description 'eth0 - VLAN 600 - PPPoE client (WAN)'
set interfaces ethernet eth0 vif 600 pppoe 0 mtu 1492
set interfaces ethernet eth0 vif 600 pppoe 0 name-server none
set interfaces ethernet eth0 vif 600 pppoe 0 password cliente
set interfaces ethernet eth0 vif 600 pppoe 0 user-id cliente@cliente
```

### IPv4 firewall zone policies for WAN

```
set zone-policy zone LAN from WAN firewall name IPV4_WAN_TO_LAN
set zone-policy zone LOCAL from WAN firewall name IPV4_WAN_TO_LOCAL
set zone-policy zone WAN default-action drop
set zone-policy zone WAN description 'WAN zone'
set zone-policy zone WAN from LAN firewall name IPV4_ALLOW_ALL_TRAFFIC
set zone-policy zone WAN from LOCAL firewall name IPV4_ALLOW_ALL_TRAFFIC
set zone-policy zone WAN interface pppoe0
```

### IPv6 firewall zone policies for WAN

```
set zone-policy zone LAN from WAN firewall ipv6-name IPV6_WAN_TO_LAN
set zone-policy zone LOCAL from WAN firewall ipv6-name IPV6_WAN_TO_LOCAL
set zone-policy zone WAN from LAN firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC
set zone-policy zone WAN from LOCAL firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC
```

### IPv6 WAN SLAAC configuration

```
set interfaces ethernet eth0 vif 600 pppoe 0 ipv6 address autoconf
set interfaces ethernet eth0 vif 600 pppoe 0 ipv6 dup-addr-detect-transmits 1
set interfaces ethernet eth0 vif 600 pppoe 0 ipv6 enable
```

### IPv6 WAN DHCPv6 client configuration

```
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd no-dns
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd pd 0 interface switch0.10 host-address '::6e86:3d5b:dc42:add2'
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd pd 0 prefix-length /64
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd prefix-only
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd rapid-commit enable
```

### IPv4 TCP MSS clamping

See **[firewall.sh](./scripts/firewall.sh)**

```
$ sudo iptables --match comment --comment IPV4_MANGLE_1 --table mangle --append PREROUTING --in-interface pppoe0 --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --jump TCPMSS --set-mss 1452
$ sudo iptables --match comment --comment IPV4_MANGLE_2 --table mangle --append POSTROUTING --out-interface pppoe0 --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --jump TCPMSS --set-mss 1452
```

### IPv6 TCP MSS clamping

See **[firewall.sh](./scripts/firewall.sh)**

```
$ sudo ip6tables --match comment --comment IPV6_MANGLE_1 --table mangle --append PREROUTING --in-interface pppoe0 --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432
$ sudo ip6tables --match comment --comment IPV6_MANGLE_2 --table mangle --append POSTROUTING --out-interface pppoe0 --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432
```

### IPv4 DNAT redirecting all DNS queries to the router

See **[firewall.sh](./scripts/firewall.sh)**

```
$ sudo ipset create DNS_PORT_2 bitmap:port range 53-53
$ sudo ipset add DNS_PORT_2 53 -exist
$ sudo ipset create IPV4_DNS_ADDRESS hash:net family inet hashsize 64 maxelem 1
$ sudo ipset add IPV4_DNS_ADDRESS 192.168.167.1/32 -exist
$ sudo iptables --match comment --comment IPV4_NAT_1 --table nat --append PREROUTING --in-interface switch0.10 --protocol udp --match set ! --match-set IPV4_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match udp --jump REDIRECT
$ sudo iptables --match comment --comment IPV4_NAT_2 --table nat --append PREROUTING --in-interface switch0.10 --protocol tcp --match set ! --match-set IPV4_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match tcp --jump REDIRECT
```

### IPv6 DNAT redirecting all DNS queries to the router

See **[firewall.sh](./scripts/firewall.sh)**

```
$ sudo ipset create IPV6_DNS_ADDRESS hash:net family inet6 hashsize 64 maxelem 1
$ sudo ipset add IPV6_DNS_ADDRESS fd45:1e52:2abe:4c85::1/128 -exist
$ sudo ip6tables --match comment --comment IPV6_NAT_1 --table nat --append PREROUTING --in-interface switch0.10 --protocol udp --match set ! --match-set IPV6_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match udp --jump REDIRECT
$ sudo ip6tables --match comment --comment IPV6_NAT_2 --table nat --append PREROUTING --in-interface switch0.10 --protocol tcp --match set ! --match-set IPV6_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match tcp --jump REDIRECT
```

### IPv4 SNAT workaround for ISP blocking of incoming NTP packets (UDP/123)

See **[firewall.sh](./scripts/firewall.sh)**

```
$ sudo ipset create NTP_PORT bitmap:port range 123-123
$ sudo ipset add NTP_PORT 123 -exist
$ sudo ipset create IPV4_WAN_NAT_SOURCES hash:net family inet
$ sudo ipset add IPV4_WAN_NAT_SOURCES 192.168.103.0/24 -exist
$ sudo iptables --match comment --comment IPV4_NAT_3 --table nat --append POSTROUTING --out-interface pppoe0 --protocol udp --match set --match-set IPV4_WAN_NAT_SOURCES src --match set --match-set NTP_PORT src --jump MASQUERADE --to-ports 49152-65535
$ sudo iptables --match comment --comment IPV4_NAT_4 --table nat --append POSTROUTING --out-interface pppoe0 --protocol udp --match set --match-set NTP_PORT src --jump SNAT --to-source :49152-65535
```

### IPv6 SNAT workaround for ISP blocking of incoming NTP packets (UDP/123)

See **[firewall.sh](./scripts/firewall.sh)**

```
$ sudo ip6tables --match comment --comment IPV6_NAT_3 --table nat --append POSTROUTING --out-interface pppoe0 --protocol udp --match set --match-set NTP_PORT src --match udp --jump SNAT --to-source :49152-65535
```

### IPv4 SNAT of private addresses for internet access

See **[firewall.sh](./scripts/firewall.sh)**

```
$ sudo iptables --match comment --comment IPV4_NAT_5 --table nat --append POSTROUTING --out-interface pppoe0 --match set --match-set IPV4_WAN_NAT_SOURCES src --jump MASQUERADE
```

### IPv4 SNAT of private addresses for modem access

See **[firewall.sh](./scripts/firewall.sh)**

```
$ sudo ipset create IPV4_MODEM_NAT_SOURCES hash:net family inet
$ sudo ipset add IPV4_MODEM_NAT_SOURCES 192.168.103.0/24 -exist
$ sudo ipset create IPV4_MODEM_ADDRESS hash:net family inet hashsize 64 maxelem 1
$ sudo ipset add IPV4_MODEM_ADDRESS 192.168.237.1/32 -exist
$ sudo iptables --match comment --comment IPV4_NAT_6 --table nat --append POSTROUTING --match set --match-set IPV4_MODEM_NAT_SOURCES src --match set --match-set IPV4_MODEM_ADDRESS dst --jump SNAT --to-source 192.168.237.2
```

### Clock configuration

```
delete system ntp server
set system ntp server time1.google.com
set system ntp server time2.google.com
set system ntp server time3.google.com
set system ntp server time4.google.com
set system time-zone America/Sao_Paulo
```

### Connection tracking configuration

```
set system conntrack tcp loose disable
set system conntrack timeout icmp 30
set system conntrack timeout other 600
set system conntrack timeout tcp close 10
set system conntrack timeout tcp close-wait 60
set system conntrack timeout tcp established 432000
set system conntrack timeout tcp fin-wait 120
set system conntrack timeout tcp last-ack 30
set system conntrack timeout tcp syn-recv 60
set system conntrack timeout tcp syn-sent 120
set system conntrack timeout tcp time-wait 120
set system conntrack timeout udp other 30
set system conntrack timeout udp stream 180
```

### Disabling of unneeded NAT helpers

```
set system conntrack modules ftp disable
set system conntrack modules gre disable
set system conntrack modules h323 disable
set system conntrack modules pptp disable
set system conntrack modules sip disable
set system conntrack modules tftp disable
```

### Disabling of unused services

```
set service unms disable
```

### Disabling of discovery

```
set service ubnt-discover disable
```

### Disabling of telemetry

```
set system analytics-handler send-analytics-report false
set system crash-handler send-crash-report false
```

### Disabling of hardware offloading

```
set system offload hwnat disable
set system offload ipsec disable
```

### Disabling of traffic analysis

```
set system traffic-analysis dpi disable
```

### Upload of additional files

```
$ scp -P 36518 ../keys_and_certificates/certificate_authority.crt ../keys_and_certificates/management_https.crt ../keys_and_certificates/management_https.key ./scripts/firewall.sh username920169077@192.168.103.254:/home/username920169077
```

### File location, permission and ownership changes, and firewall rules application

```
$ sudo mv /home/username920169077/certificate_authority.crt /home/username920169077/management_https.crt /home/username920169077/management_https.key /config/auth
$ sudo mv /home/username920169077/firewall.sh /config/scripts/post-config.d
$ sudo cat /config/auth/management_https.crt /config/auth/management_https.key > /config/auth/management_https.pem
$ sudo chown root:root /config/auth/certificate_authority.crt /config/auth/management_https.crt /config/auth/management_https.key /config/auth/management_https.pem /config/scripts/post-config.d/firewall.sh
$ sudo chmod 0600 /config/auth/certificate_authority.crt /config/auth/management_https.crt /config/auth/management_https.key /config/auth/management_https.pem
$ sudo chmod 0700 /config/scripts/post-config.d/firewall.sh
$ sudo /config/scripts/post-config.d/firewall.sh
```

### Configuration of management via HTTPS

```
set service gui ca-file /config/auth/certificate_authority.crt
set service gui cert-file /config/auth/management_https.pem
set service gui http-port 45631
set service gui https-port 18856
set service gui older-ciphers disable
```

## Final configuration

```
set firewall all-ping enable
set firewall broadcast-ping disable
set firewall group address-group IPV4_INVALID_WAN_SOURCES address 127.0.0.0/8
set firewall group address-group IPV4_INVALID_WAN_SOURCES address 192.168.167.1
set firewall group address-group IPV4_INVALID_WAN_SOURCES address 192.168.103.0/24
set firewall group address-group IPV4_INVALID_WAN_SOURCES address 192.168.237.0/30
set firewall group address-group IPV4_LAN_SOURCES address 192.168.103.0/24
set firewall group ipv6-address-group IPV6_INVALID_LAN_SOURCES ipv6-address '::1'
set firewall group ipv6-address-group IPV6_INVALID_LAN_SOURCES ipv6-address 'fd45:1e52:2abe:4c85::1'
set firewall group ipv6-address-group IPV6_INVALID_WAN_SOURCES ipv6-address '::1'
set firewall group ipv6-address-group IPV6_INVALID_WAN_SOURCES ipv6-address 'fd45:1e52:2abe:4c85::1'
set firewall group ipv6-address-group IPV6_LAN_SLAAC_SOURCES ipv6-address 'fe80::/64'
set firewall group ipv6-address-group IPV6_LAN_SLAAC_SOURCES ipv6-address '::'
set firewall group ipv6-address-group IPV6_LINK_LOCAL_SOURCES ipv6-address 'fe80::/64'
set firewall group port-group DHCPV6_PORT port 546
set firewall group port-group DHCP_PORT port 67
set firewall group port-group DNS_PORT port 53
set firewall group port-group MANAGEMENT_HTTPS_PORT port 18856
set firewall group port-group MANAGEMENT_HTTP_PORT port 45631
set firewall group port-group MANAGEMENT_SSH_PORT port 36518
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC default-action accept
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC description 'Allow all traffic'
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 10 action accept
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 10 description 'Accept ESTABLISHED,NEW,RELATED packets'
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 10 state established enable
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 10 state new enable
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 10 state related enable
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 20 action drop
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 20 description 'Drop INVALID packets'
set firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC rule 20 state invalid enable
set firewall ipv6-name IPV6_LAN_TO_LOCAL default-action drop
set firewall ipv6-name IPV6_LAN_TO_LOCAL description 'Check packets going from LAN to Local'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 10 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 10 state established enable
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 10 state related enable
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 20 action drop
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 20 description 'Drop INVALID packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 20 state invalid enable
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 30 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 30 description 'Accept ICMPv6 Router Solicitation packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 30 icmpv6 type 133/0
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 30 protocol icmpv6
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 30 source group ipv6-address-group IPV6_LAN_SLAAC_SOURCES
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 40 action drop
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 40 description 'Drop packets with spoofed source addresses'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 40 source group ipv6-address-group IPV6_INVALID_LAN_SOURCES
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 50 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 50 description 'Accept TCP DNS packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 50 destination group port-group DNS_PORT
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 50 protocol tcp
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 60 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 60 description 'Accept UDP DNS packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 60 destination group port-group DNS_PORT
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 60 protocol udp
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 70 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 70 description 'Accept management via HTTPS'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 70 destination group port-group MANAGEMENT_HTTPS_PORT
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 70 protocol tcp
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 80 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 80 description 'Accept management via SSH'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 80 destination group port-group MANAGEMENT_SSH_PORT
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 80 protocol tcp
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 90 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 90 description 'Accept ICMPv6 Echo Request packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 90 icmpv6 type 128/0
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 90 protocol icmpv6
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 100 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 100 description 'Accept ICMPv6 Neighbor Solicitation packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 100 icmpv6 type 135/0
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 100 protocol icmpv6
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 110 action accept
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 110 description 'Accept ICMPv6 Neighbor Advertisement packets'
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 110 icmpv6 type 136/0
set firewall ipv6-name IPV6_LAN_TO_LOCAL rule 110 protocol icmpv6
set firewall ipv6-name IPV6_WAN_TO_LAN default-action drop
set firewall ipv6-name IPV6_WAN_TO_LAN description 'Check packets going from WAN to LAN'
set firewall ipv6-name IPV6_WAN_TO_LAN rule 10 action accept
set firewall ipv6-name IPV6_WAN_TO_LAN rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall ipv6-name IPV6_WAN_TO_LAN rule 10 state established enable
set firewall ipv6-name IPV6_WAN_TO_LAN rule 10 state related enable
set firewall ipv6-name IPV6_WAN_TO_LAN rule 20 action drop
set firewall ipv6-name IPV6_WAN_TO_LAN rule 20 description 'Drop INVALID packets'
set firewall ipv6-name IPV6_WAN_TO_LAN rule 20 state invalid enable
set firewall ipv6-name IPV6_WAN_TO_LAN rule 30 action drop
set firewall ipv6-name IPV6_WAN_TO_LAN rule 30 description 'Drop packets with spoofed source addresses'
set firewall ipv6-name IPV6_WAN_TO_LAN rule 30 source group ipv6-address-group IPV6_INVALID_WAN_SOURCES
set firewall ipv6-name IPV6_WAN_TO_LAN rule 40 action accept
set firewall ipv6-name IPV6_WAN_TO_LAN rule 40 description 'Accept ICMPv6 Echo Request packets'
set firewall ipv6-name IPV6_WAN_TO_LAN rule 40 icmpv6 type 128/0
set firewall ipv6-name IPV6_WAN_TO_LAN rule 40 protocol icmpv6
set firewall ipv6-name IPV6_WAN_TO_LOCAL default-action drop
set firewall ipv6-name IPV6_WAN_TO_LOCAL description 'Check packets going from WAN to Local'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 10 action accept
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 10 state established enable
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 10 state related enable
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 20 action drop
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 20 description 'Drop INVALID packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 20 state invalid enable
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 30 action accept
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 30 description 'Accept DHCPv6 packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 30 destination group port-group DHCPV6_PORT
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 30 protocol udp
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 30 source group ipv6-address-group IPV6_LINK_LOCAL_SOURCES
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 40 action accept
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 40 description 'Accept ICMPv6 Router Advertisement packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 40 icmpv6 type 134/0
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 40 protocol icmpv6
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 40 source group ipv6-address-group IPV6_LINK_LOCAL_SOURCES
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 50 action drop
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 50 description 'Drop packets with spoofed source addresses'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 50 source group ipv6-address-group IPV6_INVALID_WAN_SOURCES
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 60 action accept
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 60 description 'Accept ICMPv6 Echo Request packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 60 icmpv6 type 128/0
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 60 protocol icmpv6
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 70 action accept
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 70 description 'Accept ICMPv6 Neighbor Solicitation packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 70 icmpv6 type 135/0
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 70 protocol icmpv6
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 80 action accept
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 80 description 'Accept ICMPv6 Neighbor Advertisement packets'
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 80 icmpv6 type 136/0
set firewall ipv6-name IPV6_WAN_TO_LOCAL rule 80 protocol icmpv6
set firewall ipv6-receive-redirects disable
set firewall ipv6-src-route disable
set firewall ip-src-route disable
set firewall name IPV4_ALLOW_ALL_TRAFFIC default-action accept
set firewall name IPV4_ALLOW_ALL_TRAFFIC description 'Allow all traffic'
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 10 action accept
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 10 description 'Accept ESTABLISHED,NEW,RELATED packets'
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 10 state established enable
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 10 state new enable
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 10 state related enable
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 20 action drop
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 20 description 'Drop INVALID packets'
set firewall name IPV4_ALLOW_ALL_TRAFFIC rule 20 state invalid enable
set firewall name IPV4_ALLOW_RETURN_TRAFFIC default-action drop
set firewall name IPV4_ALLOW_RETURN_TRAFFIC description 'Allow return traffic'
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 10 action accept
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 10 state established enable
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 10 state related enable
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 20 action drop
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 20 description 'Drop INVALID packets'
set firewall name IPV4_ALLOW_RETURN_TRAFFIC rule 20 state invalid enable
set firewall name IPV4_LAN_TO_LOCAL default-action drop
set firewall name IPV4_LAN_TO_LOCAL description 'Check packets going from LAN to Local'
set firewall name IPV4_LAN_TO_LOCAL rule 10 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall name IPV4_LAN_TO_LOCAL rule 10 state established enable
set firewall name IPV4_LAN_TO_LOCAL rule 10 state related enable
set firewall name IPV4_LAN_TO_LOCAL rule 20 action drop
set firewall name IPV4_LAN_TO_LOCAL rule 20 description 'Drop INVALID packets'
set firewall name IPV4_LAN_TO_LOCAL rule 20 state invalid enable
set firewall name IPV4_LAN_TO_LOCAL rule 30 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 30 description 'Accept DHCP packets'
set firewall name IPV4_LAN_TO_LOCAL rule 30 destination group port-group DHCP_PORT
set firewall name IPV4_LAN_TO_LOCAL rule 30 protocol udp
set firewall name IPV4_LAN_TO_LOCAL rule 30 source address 0.0.0.0
set firewall name IPV4_LAN_TO_LOCAL rule 40 action drop
set firewall name IPV4_LAN_TO_LOCAL rule 40 description 'Drop packets with spoofed source addresses'
set firewall name IPV4_LAN_TO_LOCAL rule 40 source group address-group '!IPV4_LAN_SOURCES'
set firewall name IPV4_LAN_TO_LOCAL rule 50 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 50 description 'Accept DHCP packets'
set firewall name IPV4_LAN_TO_LOCAL rule 50 destination group port-group DHCP_PORT
set firewall name IPV4_LAN_TO_LOCAL rule 50 protocol udp
set firewall name IPV4_LAN_TO_LOCAL rule 60 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 60 description 'Accept TCP DNS packets'
set firewall name IPV4_LAN_TO_LOCAL rule 60 destination group port-group DNS_PORT
set firewall name IPV4_LAN_TO_LOCAL rule 60 protocol tcp
set firewall name IPV4_LAN_TO_LOCAL rule 70 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 70 description 'Accept UDP DNS packets'
set firewall name IPV4_LAN_TO_LOCAL rule 70 destination group port-group DNS_PORT
set firewall name IPV4_LAN_TO_LOCAL rule 70 protocol udp
set firewall name IPV4_LAN_TO_LOCAL rule 80 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 80 description 'Accept management via HTTPS'
set firewall name IPV4_LAN_TO_LOCAL rule 80 destination group port-group MANAGEMENT_HTTPS_PORT
set firewall name IPV4_LAN_TO_LOCAL rule 80 protocol tcp
set firewall name IPV4_LAN_TO_LOCAL rule 90 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 90 description 'Accept management via SSH'
set firewall name IPV4_LAN_TO_LOCAL rule 90 destination group port-group MANAGEMENT_SSH_PORT
set firewall name IPV4_LAN_TO_LOCAL rule 90 protocol tcp
set firewall name IPV4_LAN_TO_LOCAL rule 100 action accept
set firewall name IPV4_LAN_TO_LOCAL rule 100 description 'Accept ICMP Echo Request packets'
set firewall name IPV4_LAN_TO_LOCAL rule 100 icmp code 0
set firewall name IPV4_LAN_TO_LOCAL rule 100 icmp type 8
set firewall name IPV4_LAN_TO_LOCAL rule 100 protocol icmp
set firewall name IPV4_LAN_TO_MODEM default-action drop
set firewall name IPV4_LAN_TO_MODEM description 'Check packets going from LAN to Modem'
set firewall name IPV4_LAN_TO_MODEM rule 10 action accept
set firewall name IPV4_LAN_TO_MODEM rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall name IPV4_LAN_TO_MODEM rule 10 state established enable
set firewall name IPV4_LAN_TO_MODEM rule 10 state related enable
set firewall name IPV4_LAN_TO_MODEM rule 20 action drop
set firewall name IPV4_LAN_TO_MODEM rule 20 description 'Drop INVALID packets'
set firewall name IPV4_LAN_TO_MODEM rule 20 state invalid enable
set firewall name IPV4_LAN_TO_MODEM rule 30 action accept
set firewall name IPV4_LAN_TO_MODEM rule 30 description 'Accept management via HTTP'
set firewall name IPV4_LAN_TO_MODEM rule 30 destination group port-group MANAGEMENT_HTTP_PORT
set firewall name IPV4_LAN_TO_MODEM rule 30 protocol tcp
set firewall name IPV4_WAN_TO_LAN default-action drop
set firewall name IPV4_WAN_TO_LAN description 'Check packets going from WAN to LAN'
set firewall name IPV4_WAN_TO_LAN rule 10 action accept
set firewall name IPV4_WAN_TO_LAN rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall name IPV4_WAN_TO_LAN rule 10 state established enable
set firewall name IPV4_WAN_TO_LAN rule 10 state related enable
set firewall name IPV4_WAN_TO_LAN rule 20 action drop
set firewall name IPV4_WAN_TO_LAN rule 20 description 'Drop INVALID packets'
set firewall name IPV4_WAN_TO_LAN rule 20 state invalid enable
set firewall name IPV4_WAN_TO_LAN rule 30 action drop
set firewall name IPV4_WAN_TO_LAN rule 30 description 'Drop packets with spoofed source addresses'
set firewall name IPV4_WAN_TO_LAN rule 30 source group address-group IPV4_INVALID_WAN_SOURCES
set firewall name IPV4_WAN_TO_LOCAL default-action drop
set firewall name IPV4_WAN_TO_LOCAL description 'Check packets going from WAN to Local'
set firewall name IPV4_WAN_TO_LOCAL rule 10 action accept
set firewall name IPV4_WAN_TO_LOCAL rule 10 description 'Accept ESTABLISHED,RELATED packets'
set firewall name IPV4_WAN_TO_LOCAL rule 10 state established enable
set firewall name IPV4_WAN_TO_LOCAL rule 10 state related enable
set firewall name IPV4_WAN_TO_LOCAL rule 20 action drop
set firewall name IPV4_WAN_TO_LOCAL rule 20 description 'Drop INVALID packets'
set firewall name IPV4_WAN_TO_LOCAL rule 20 state invalid enable
set firewall name IPV4_WAN_TO_LOCAL rule 30 action drop
set firewall name IPV4_WAN_TO_LOCAL rule 30 description 'Drop packets with spoofed source addresses'
set firewall name IPV4_WAN_TO_LOCAL rule 30 source group address-group IPV4_INVALID_WAN_SOURCES
set firewall name IPV4_WAN_TO_LOCAL rule 40 action accept
set firewall name IPV4_WAN_TO_LOCAL rule 40 description 'Accept ICMP Echo Request packets'
set firewall name IPV4_WAN_TO_LOCAL rule 40 icmp code 0
set firewall name IPV4_WAN_TO_LOCAL rule 40 icmp type 8
set firewall name IPV4_WAN_TO_LOCAL rule 40 protocol icmp
set firewall receive-redirects disable
set firewall send-redirects enable
set firewall source-validation disable
set firewall syn-cookies enable
set interfaces ethernet eth0 address 192.168.237.2/30
set interfaces ethernet eth0 description 'eth0 (Modem)'
set interfaces ethernet eth0 duplex auto
set interfaces ethernet eth0 mac 'D0:21:F9:90:67:BD'
set interfaces ethernet eth0 mtu 1500
set interfaces ethernet eth0 speed auto
set interfaces ethernet eth0 vif 600 description 'eth0 - VLAN 600'
set interfaces ethernet eth0 vif 600 pppoe 0 default-route auto
set interfaces ethernet eth0 vif 600 pppoe 0 description 'eth0 - VLAN 600 - PPPoE client (WAN)'
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd no-dns
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd pd 0 interface switch0.10 host-address '::6e86:3d5b:dc42:add2'
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd pd 0 prefix-length /64
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd prefix-only
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd rapid-commit enable
set interfaces ethernet eth0 vif 600 pppoe 0 ipv6 address autoconf
set interfaces ethernet eth0 vif 600 pppoe 0 ipv6 dup-addr-detect-transmits 1
set interfaces ethernet eth0 vif 600 pppoe 0 ipv6 enable
set interfaces ethernet eth0 vif 600 pppoe 0 mtu 1492
set interfaces ethernet eth0 vif 600 pppoe 0 name-server none
set interfaces ethernet eth0 vif 600 pppoe 0 password cliente
set interfaces ethernet eth0 vif 600 pppoe 0 user-id cliente@cliente
set interfaces ethernet eth1 description 'eth1 - Switch - Trunk'
set interfaces ethernet eth1 duplex auto
set interfaces ethernet eth1 mac 'D0:21:F9:82:0D:94'
set interfaces ethernet eth1 mtu 1500
set interfaces ethernet eth1 speed auto
set interfaces ethernet eth2 description 'eth2 - Switch - VLAN 10'
set interfaces ethernet eth2 duplex auto
set interfaces ethernet eth2 mac 'D0:21:F9:D5:0A:39'
set interfaces ethernet eth2 mtu 1500
set interfaces ethernet eth2 speed auto
set interfaces ethernet eth3 description 'eth3 - Switch - VLAN 10'
set interfaces ethernet eth3 duplex auto
set interfaces ethernet eth3 mac 'D0:21:F9:0E:6E:DA'
set interfaces ethernet eth3 mtu 1500
set interfaces ethernet eth3 speed auto
set interfaces ethernet eth4 description 'eth4 - Switch - VLAN 10'
set interfaces ethernet eth4 duplex auto
set interfaces ethernet eth4 mac 'D0:21:F9:76:B7:33'
set interfaces ethernet eth4 mtu 1500
set interfaces ethernet eth4 speed auto
set interfaces loopback lo address 192.168.167.1/32
set interfaces loopback lo address 'fd45:1e52:2abe:4c85::1/128'
set interfaces loopback lo description 'Loopback (Local)'
set interfaces switch switch0 description Switch
set interfaces switch switch0 mtu 1500
set interfaces switch switch0 switch-port interface eth1 vlan pvid 1
set interfaces switch switch0 switch-port interface eth1 vlan vid 10
set interfaces switch switch0 switch-port interface eth2 vlan pvid 10
set interfaces switch switch0 switch-port interface eth3 vlan pvid 10
set interfaces switch switch0 switch-port interface eth4 vlan pvid 10
set interfaces switch switch0 switch-port vlan-aware enable
set interfaces switch switch0 vif 1 description 'Switch - VLAN 1'
set interfaces switch switch0 vif 10 address 192.168.103.254/24
set interfaces switch switch0 vif 10 description 'Switch - VLAN 10 (LAN)'
set interfaces switch switch0 vif 10 ipv6 dup-addr-detect-transmits 1
set interfaces switch switch0 vif 10 ipv6 router-advert cur-hop-limit 64
set interfaces switch switch0 vif 10 ipv6 router-advert default-lifetime 9000
set interfaces switch switch0 vif 10 ipv6 router-advert default-preference medium
set interfaces switch switch0 vif 10 ipv6 router-advert link-mtu 1492
set interfaces switch switch0 vif 10 ipv6 router-advert managed-flag false
set interfaces switch switch0 vif 10 ipv6 router-advert max-interval 600
set interfaces switch switch0 vif 10 ipv6 router-advert min-interval 200
set interfaces switch switch0 vif 10 ipv6 router-advert name-server 'fd45:1e52:2abe:4c85::1'
set interfaces switch switch0 vif 10 ipv6 router-advert other-config-flag false
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' autonomous-flag true
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' on-link-flag true
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' preferred-lifetime 57600
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' valid-lifetime 86400
set interfaces switch switch0 vif 10 ipv6 router-advert send-advert true
set service dhcp-server shared-network-name VLAN_10 authoritative enable
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 default-router 192.168.103.254
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 dns-server 192.168.167.1
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 lease 57600
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 start 192.168.103.1 stop 192.168.103.253
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 subnet-parameters 'option default-ip-ttl 64;'
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 subnet-parameters 'option interface-mtu 1492;'
set service dhcp-server shared-network-name VLAN_10 subnet 192.168.103.0/24 subnet-parameters 'option broadcast-address 192.168.103.255;'
set service dhcp-server static-arp enable
set service dns forwarding cache-size 10000
set service dns forwarding listen-on switch0.10
set service dns forwarding name-server '2001:4860:4860::8844'
set service dns forwarding name-server '2001:4860:4860::8888'
set service dns forwarding options bogus-priv
set service dns forwarding options domain-needed
set service gui ca-file /config/auth/certificate_authority.crt
set service gui cert-file /config/auth/management_https.pem
set service gui http-port 45631
set service gui https-port 18856
set service gui older-ciphers disable
set service ssh port 36518
set service ssh protocol-version v2
set service ubnt-discover disable
set service unms disable
set system analytics-handler send-analytics-report false
set system conntrack modules ftp disable
set system conntrack modules gre disable
set system conntrack modules h323 disable
set system conntrack modules pptp disable
set system conntrack modules sip disable
set system conntrack modules tftp disable
set system conntrack tcp loose disable
set system conntrack timeout icmp 30
set system conntrack timeout other 600
set system conntrack timeout tcp close 10
set system conntrack timeout tcp close-wait 60
set system conntrack timeout tcp established 432000
set system conntrack timeout tcp fin-wait 120
set system conntrack timeout tcp last-ack 30
set system conntrack timeout tcp syn-recv 60
set system conntrack timeout tcp syn-sent 120
set system conntrack timeout tcp time-wait 120
set system conntrack timeout udp other 30
set system conntrack timeout udp stream 180
set system crash-handler send-crash-report false
set system host-name Home-Router
set system login user username920169077 authentication plaintext-password 'password767865354'
set system login user username920169077 level admin
set system ntp server time1.google.com
set system ntp server time2.google.com
set system ntp server time3.google.com
set system ntp server time4.google.com
set system offload hwnat disable
set system offload ipsec disable
set system static-host-mapping host-name home-router.lan inet 192.168.167.1
set system static-host-mapping host-name home-router.lan inet 'fd45:1e52:2abe:4c85::1'
set system static-host-mapping host-name ipv4.home-router.lan inet 192.168.167.1
set system static-host-mapping host-name ipv6.home-router.lan inet 'fd45:1e52:2abe:4c85::1'
set system time-zone America/Sao_Paulo
set system traffic-analysis dpi disable
set zone-policy zone LAN default-action drop
set zone-policy zone LAN description 'LAN zone'
set zone-policy zone LAN from LOCAL firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC
set zone-policy zone LAN from LOCAL firewall name IPV4_ALLOW_ALL_TRAFFIC
set zone-policy zone LAN from MODEM firewall name IPV4_ALLOW_RETURN_TRAFFIC
set zone-policy zone LAN from WAN firewall ipv6-name IPV6_WAN_TO_LAN
set zone-policy zone LAN from WAN firewall name IPV4_WAN_TO_LAN
set zone-policy zone LAN interface switch0.10
set zone-policy zone LOCAL default-action drop
set zone-policy zone LOCAL description 'Local zone'
set zone-policy zone LOCAL from LAN firewall ipv6-name IPV6_LAN_TO_LOCAL
set zone-policy zone LOCAL from LAN firewall name IPV4_LAN_TO_LOCAL
set zone-policy zone LOCAL from MODEM firewall name IPV4_ALLOW_RETURN_TRAFFIC
set zone-policy zone LOCAL from WAN firewall ipv6-name IPV6_WAN_TO_LOCAL
set zone-policy zone LOCAL from WAN firewall name IPV4_WAN_TO_LOCAL
set zone-policy zone LOCAL local-zone
set zone-policy zone MODEM default-action drop
set zone-policy zone MODEM description 'Modem zone'
set zone-policy zone MODEM from LAN firewall name IPV4_LAN_TO_MODEM
set zone-policy zone MODEM from LOCAL firewall name IPV4_ALLOW_ALL_TRAFFIC
set zone-policy zone MODEM interface eth0
set zone-policy zone WAN default-action drop
set zone-policy zone WAN description 'WAN zone'
set zone-policy zone WAN from LAN firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC
set zone-policy zone WAN from LAN firewall name IPV4_ALLOW_ALL_TRAFFIC
set zone-policy zone WAN from LOCAL firewall ipv6-name IPV6_ALLOW_ALL_TRAFFIC
set zone-policy zone WAN from LOCAL firewall name IPV4_ALLOW_ALL_TRAFFIC
set zone-policy zone WAN interface pppoe0

$ sudo iptables --match comment --comment IPV4_MANGLE_1 --table mangle --append PREROUTING --in-interface pppoe0 --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --jump TCPMSS --set-mss 1452
$ sudo iptables --match comment --comment IPV4_MANGLE_2 --table mangle --append POSTROUTING --out-interface pppoe0 --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1453:65535 --jump TCPMSS --set-mss 1452
$ sudo ip6tables --match comment --comment IPV6_MANGLE_1 --table mangle --append PREROUTING --in-interface pppoe0 --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432
$ sudo ip6tables --match comment --comment IPV6_MANGLE_2 --table mangle --append POSTROUTING --out-interface pppoe0 --protocol tcp --match tcp --tcp-flags SYN SYN --match tcpmss --mss 1433:65535 --jump TCPMSS --set-mss 1432
$ sudo ipset create DNS_PORT_2 bitmap:port range 53-53
$ sudo ipset add DNS_PORT_2 53 -exist
$ sudo ipset create IPV4_DNS_ADDRESS hash:net family inet hashsize 64 maxelem 1
$ sudo ipset add IPV4_DNS_ADDRESS 192.168.167.1/32 -exist
$ sudo iptables --match comment --comment IPV4_NAT_1 --table nat --append PREROUTING --in-interface switch0.10 --protocol udp --match set ! --match-set IPV4_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match udp --jump REDIRECT
$ sudo iptables --match comment --comment IPV4_NAT_2 --table nat --append PREROUTING --in-interface switch0.10 --protocol tcp --match set ! --match-set IPV4_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match tcp --jump REDIRECT
$ sudo ipset create IPV6_DNS_ADDRESS hash:net family inet6 hashsize 64 maxelem 1
$ sudo ipset add IPV6_DNS_ADDRESS fd45:1e52:2abe:4c85::1/128 -exist
$ sudo ip6tables --match comment --comment IPV6_NAT_1 --table nat --append PREROUTING --in-interface switch0.10 --protocol udp --match set ! --match-set IPV6_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match udp --jump REDIRECT
$ sudo ip6tables --match comment --comment IPV6_NAT_2 --table nat --append PREROUTING --in-interface switch0.10 --protocol tcp --match set ! --match-set IPV6_DNS_ADDRESS dst --match set --match-set DNS_PORT_2 dst --match tcp --jump REDIRECT
$ sudo ipset create NTP_PORT bitmap:port range 123-123
$ sudo ipset add NTP_PORT 123 -exist
$ sudo ipset create IPV4_WAN_NAT_SOURCES hash:net family inet
$ sudo ipset add IPV4_WAN_NAT_SOURCES 192.168.103.0/24 -exist
$ sudo iptables --match comment --comment IPV4_NAT_3 --table nat --append POSTROUTING --out-interface pppoe0 --protocol udp --match set --match-set IPV4_WAN_NAT_SOURCES src --match set --match-set NTP_PORT src --jump MASQUERADE --to-ports 49152-65535
$ sudo iptables --match comment --comment IPV4_NAT_4 --table nat --append POSTROUTING --out-interface pppoe0 --protocol udp --match set --match-set NTP_PORT src --jump SNAT --to-source :49152-65535
$ sudo ip6tables --match comment --comment IPV6_NAT_3 --table nat --append POSTROUTING --out-interface pppoe0 --protocol udp --match set --match-set NTP_PORT src --match udp --jump SNAT --to-source :49152-65535
$ sudo iptables --match comment --comment IPV4_NAT_5 --table nat --append POSTROUTING --out-interface pppoe0 --match set --match-set IPV4_WAN_NAT_SOURCES src --jump MASQUERADE
$ sudo ipset create IPV4_MODEM_NAT_SOURCES hash:net family inet
$ sudo ipset add IPV4_MODEM_NAT_SOURCES 192.168.103.0/24 -exist
$ sudo ipset create IPV4_MODEM_ADDRESS hash:net family inet hashsize 64 maxelem 1
$ sudo ipset add IPV4_MODEM_ADDRESS 192.168.237.1/32 -exist
$ sudo iptables --match comment --comment IPV4_NAT_6 --table nat --append POSTROUTING --match set --match-set IPV4_MODEM_NAT_SOURCES src --match set --match-set IPV4_MODEM_ADDRESS dst --jump SNAT --to-source 192.168.237.2
```

## End result

### IPv4 addresses

```
$ sudo ip -brief -4 address
lo                 UNKNOWN        127.0.0.1/8 192.168.167.1/32
eth0@itf0          UP             192.168.237.2/30
switch0.10@switch0 UP             192.168.103.254/24
pppoe0             UNKNOWN        201.42.158.27 peer 189.97.102.55/32
```

### IPv4 routes

```
$ sudo ip -4 route
0.0.0.0 dev pppoe0 proto kernel scope link
default dev pppoe0 scope link
189.97.102.55 dev pppoe0 proto kernel scope link src 201.42.158.27
192.168.103.0/24 dev switch0.10 proto kernel scope link src 192.168.103.254
192.168.167.1 dev lo proto kernel scope link
192.168.237.0/30 dev eth0 proto kernel scope link src 192.168.237.2
201.42.158.27 dev pppoe0 proto kernel scope link
```

### IPv6 addresses

```
$ sudo ip -brief -6 address
lo                 UNKNOWN        fd45:1e52:2abe:4c85::1/128 ::1/128
itf0               UNKNOWN        fe80::d221:f9ff:fee1:353/64
eth0@itf0          UP             fe80::d221:f9ff:fe90:67bd/64
eth1@itf0          UP             fe80::d221:f9ff:fe82:d94/64
eth2@itf0          UP             fe80::d221:f9ff:fed5:a39/64
eth3@itf0          UP             fe80::d221:f9ff:fe0e:6eda/64
eth4@itf0          UP             fe80::d221:f9ff:fe76:b733/64
switch0@itf0       UP             fe80::d221:f9ff:fee1:353/64
switch0.10@switch0 UP             2804:7f4:ca01:15ac:6e86:3d5b:dc42:add2/64 fe80::d221:f9ff:fee1:353/64
switch0.1@switch0  UP             fe80::d221:f9ff:fee1:353/64
eth0.600@eth0      UP             fe80::d221:f9ff:fe90:67bd/64
pppoe0             UNKNOWN        2804:7f4:c02f:c7e7:503c:8d10:6852:5626/64 fe80::503c:8d10:6852:5626/10
```

### IPv6 routes

```
$ sudo ip -6 route
2804:7f4:c02f:c7e7::/64 dev pppoe0 proto kernel metric 256 expires 259010sec pref medium
2804:7f4:ca01:15ac::/64 dev switch0.10 proto kernel metric 256 pref medium
unreachable fd45:1e52:2abe:4c85::1 dev lo proto kernel metric 256 error -128 pref medium
fe80::/64 dev itf0 proto kernel metric 256 pref medium
fe80::/64 dev switch0 proto kernel metric 256 pref medium
fe80::/64 dev eth0 proto kernel metric 256 pref medium
fe80::/64 dev eth2 proto kernel metric 256 pref medium
fe80::/64 dev eth3 proto kernel metric 256 pref medium
fe80::/64 dev eth1 proto kernel metric 256 pref medium
fe80::/64 dev eth4 proto kernel metric 256 pref medium
fe80::/64 dev switch0.10 proto kernel metric 256 pref medium
fe80::/64 dev switch0.1 proto kernel metric 256 pref medium
fe80::/64 dev eth0.600 proto kernel metric 256 pref medium
fe80::/10 dev pppoe0 metric 1 pref medium
fe80::/10 dev pppoe0 proto kernel metric 256 pref medium
default via fe80::a21c:8dff:fef1:1934 dev pppoe0 proto ra metric 1024 expires 1610sec pref medium
```

## Resources

* [commands.txt](./commands.txt)
* [configuration.txt](./configuration.txt)
* [firewall.sh](./scripts/firewall.sh)
