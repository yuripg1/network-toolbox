## Configuration commands

### Credential configuration

```
set system login user user925232615 authentication plaintext-password 'password478924191'
set system login user user925232615 level admin
```

### Default credential removal

```
delete system login user ubnt
```

### Interfaces configuration

```
delete interfaces ethernet eth1 address
set interfaces ethernet eth0 description eth0-wan
set interfaces ethernet eth0 duplex auto
set interfaces ethernet eth0 mac 'D0:21:F9:90:67:BD'
set interfaces ethernet eth0 mtu 1500
set interfaces ethernet eth0 speed auto
set interfaces ethernet eth1 description eth1
set interfaces ethernet eth1 duplex auto
set interfaces ethernet eth1 mac 'D0:21:F9:82:0D:94'
set interfaces ethernet eth1 mtu 1500
set interfaces ethernet eth1 speed auto
set interfaces ethernet eth2 description eth2
set interfaces ethernet eth2 duplex auto
set interfaces ethernet eth2 mac 'D0:21:F9:D5:0A:39'
set interfaces ethernet eth2 mtu 1500
set interfaces ethernet eth2 speed auto
set interfaces ethernet eth3 description eth3
set interfaces ethernet eth3 duplex auto
set interfaces ethernet eth3 mac 'D0:21:F9:0E:6E:DA'
set interfaces ethernet eth3 mtu 1500
set interfaces ethernet eth3 speed auto
set interfaces ethernet eth4 description eth4
set interfaces ethernet eth4 duplex auto
set interfaces ethernet eth4 mac 'D0:21:F9:76:B7:33'
set interfaces ethernet eth4 mtu 1500
set interfaces ethernet eth4 speed auto
```

### Switch configuration

```
set interfaces switch switch0 description switch0-lan
set interfaces switch switch0 mtu 1500
set interfaces switch switch0 switch-port interface eth1 vlan pvid 1
set interfaces switch switch0 switch-port interface eth1 vlan vid 10
set interfaces switch switch0 switch-port interface eth2 vlan pvid 10
set interfaces switch switch0 switch-port interface eth3 vlan pvid 10
set interfaces switch switch0 switch-port interface eth4 vlan pvid 10
set interfaces switch switch0 switch-port vlan-aware enable
```

### IPv4 kernel configuration

```
set firewall all-ping enable
set firewall broadcast-ping disable
set firewall ip-src-route disable
set firewall receive-redirects disable
set firewall send-redirects enable
set firewall source-validation loose
set firewall syn-cookies enable
```

### IPv4 firewall rules

```
set firewall name IPV4_FORWARD_WAN_IN default-action drop
set firewall name IPV4_FORWARD_WAN_IN rule 3333 action accept
set firewall name IPV4_FORWARD_WAN_IN rule 3333 description 'accept established,related packets'
set firewall name IPV4_FORWARD_WAN_IN rule 3333 state established enable
set firewall name IPV4_FORWARD_WAN_IN rule 3333 state related enable
set firewall name IPV4_FORWARD_WAN_IN rule 6666 action drop
set firewall name IPV4_FORWARD_WAN_IN rule 6666 description 'drop invalid packets'
set firewall name IPV4_FORWARD_WAN_IN rule 6666 state invalid enable
set firewall name IPV4_INPUT_WAN_IN default-action drop
set firewall name IPV4_INPUT_WAN_IN rule 2500 action accept
set firewall name IPV4_INPUT_WAN_IN rule 2500 description 'accept established,related packets'
set firewall name IPV4_INPUT_WAN_IN rule 2500 state established enable
set firewall name IPV4_INPUT_WAN_IN rule 2500 state related enable
set firewall name IPV4_INPUT_WAN_IN rule 5000 action drop
set firewall name IPV4_INPUT_WAN_IN rule 5000 description 'drop invalid packets'
set firewall name IPV4_INPUT_WAN_IN rule 5000 state invalid enable
set firewall name IPV4_INPUT_WAN_IN rule 7500 action accept
set firewall name IPV4_INPUT_WAN_IN rule 7500 description 'accept icmp echo request packets'
set firewall name IPV4_INPUT_WAN_IN rule 7500 icmp code 0
set firewall name IPV4_INPUT_WAN_IN rule 7500 icmp type 8
set firewall name IPV4_INPUT_WAN_IN rule 7500 protocol icmp
```

### IPv4 loopback configuration

```
set interfaces loopback lo address 10.189.117.1/32
```

### IPv4 LAN

```
set interfaces switch switch0 vif 10 address 10.182.186.1/24
set interfaces switch switch0 vif 10 description switch0-lan-vif-10
set service dhcp-server shared-network-name VIF_10 authoritative enable
set service dhcp-server shared-network-name VIF_10 subnet 10.182.186.0/24 default-router 10.182.186.1
set service dhcp-server shared-network-name VIF_10 subnet 10.182.186.0/24 dns-server 10.189.117.1
set service dhcp-server shared-network-name VIF_10 subnet 10.182.186.0/24 lease 57600
set service dhcp-server shared-network-name VIF_10 subnet 10.182.186.0/24 start 10.182.186.2 stop 10.182.186.254
set service dhcp-server shared-network-name VIF_10 subnet 10.182.186.0/24 subnet-parameters 'option interface-mtu 1492;'
set service dhcp-server shared-network-name VIF_10 subnet 10.182.186.0/24 subnet-parameters 'option broadcast-address 10.182.186.255;'
set service dhcp-server static-arp enable
```

### Default address removal

```
delete interfaces ethernet eth0 address
```

### IPv4 WAN

```
set interfaces ethernet eth0 vif 600 description eth0-wan-vif-600
set interfaces ethernet eth0 vif 600 pppoe 0 default-route auto
set interfaces ethernet eth0 vif 600 pppoe 0 description eth0-wan-vif-600-pppoe
set interfaces ethernet eth0 vif 600 pppoe 0 firewall in name IPV4_FORWARD_WAN_IN
set interfaces ethernet eth0 vif 600 pppoe 0 firewall local name IPV4_INPUT_WAN_IN
set interfaces ethernet eth0 vif 600 pppoe 0 mtu 1492
set interfaces ethernet eth0 vif 600 pppoe 0 name-server none
set interfaces ethernet eth0 vif 600 pppoe 0 password cliente
set interfaces ethernet eth0 vif 600 pppoe 0 user-id cliente@cliente
```

### IPv4 TCP MSS clamping

See **[ipv4_mangle_wan.sh](./scripts/ipv4_mangle_wan.sh)**

### IPv4 DNS query redirection

See **[ipv4_nat_lan.sh](./scripts/ipv4_nat_lan.sh)**

### IPv4 NAT

```
set firewall group address-group IPV4_MASQUERADE_ADDRESSES address 10.182.186.0/24
set service nat rule 7000 outbound-interface pppoe0
set service nat rule 7000 source group address-group IPV4_MASQUERADE_ADDRESSES
set service nat rule 7000 type masquerade
```

### IPv4 workaround for ISP blocking of incoming NTP packets

```
set firewall group port-group NTP_PORT port 123
set service nat rule 6000 outbound-interface pppoe0
set service nat rule 6000 outside-address port 49152-65535
set service nat rule 6000 protocol udp
set service nat rule 6000 source group address-group IPV4_MASQUERADE_ADDRESSES
set service nat rule 6000 source group port-group NTP_PORT
set service nat rule 6000 type masquerade
set service nat rule 8000 outbound-interface pppoe0
set service nat rule 8000 outside-address port 49152-65535
set service nat rule 8000 protocol udp
set service nat rule 8000 source group port-group NTP_PORT
set service nat rule 8000 type source
```

### IPv4 modem access configuration

```
set interfaces ethernet eth0 address 10.123.203.2/24
set service nat rule 9000 outbound-interface eth0
set service nat rule 9000 source group address-group IPV4_MASQUERADE_ADDRESSES
set service nat rule 9000 type masquerade
```

### IPv4 static DNS configuration

```
set system static-host-mapping host-name router.lan inet 10.189.117.1
```

### IPv6 kernel configuration

```
set firewall ipv6-receive-redirects disable
set firewall ipv6-src-route disable
```

### IPv6 firewall rules

```
set firewall group ipv6-address-group IPV6_LINK_LOCAL_ADDRESSES ipv6-address 'fe80::/10'
set firewall group port-group DHCPV6_PORT port 546
set firewall ipv6-name IPV6_FORWARD_WAN_IN default-action drop
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 2500 action accept
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 2500 description 'accept established,related packets'
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 2500 state established enable
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 2500 state related enable
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 5000 action drop
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 5000 description 'drop invalid packets'
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 5000 state invalid enable
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 7500 action accept
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 7500 description 'accept icmpv6 echo request packets'
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 7500 icmpv6 type 128/0
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 7500 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN default-action drop
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 1111 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 1111 description 'accept established,related packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 1111 state established enable
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 1111 state related enable
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 2222 action drop
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 2222 description 'drop invalid packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 2222 state invalid enable
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 3333 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 3333 description 'accept icmpv6 echo request packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 3333 icmpv6 type 128/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 3333 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 description 'accept icmpv6 router solicitation packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 icmpv6 type 133/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 source group ipv6-address-group IPV6_LINK_LOCAL_ADDRESSES
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 description 'accept icmpv6 router advertisement packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 icmpv6 type 134/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 source group ipv6-address-group IPV6_LINK_LOCAL_ADDRESSES
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 description 'accept icmpv6 neighbor solicitation packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 icmpv6 type 135/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 source group ipv6-address-group IPV6_LINK_LOCAL_ADDRESSES
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 description 'accept icmpv6 neighbor advertisement packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 icmpv6 type 136/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 source group ipv6-address-group IPV6_LINK_LOCAL_ADDRESSES
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 description 'accept dhcpv6 packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 destination group port-group DHCPV6_PORT
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 protocol udp
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 source group ipv6-address-group IPV6_LINK_LOCAL_ADDRESSES
```

### IPv6 loopback configuration

```
set interfaces loopback lo address 'fd1a:ac95:26c8:c75f::1/128'
```

### IPv6 LAN

```
set interfaces switch switch0 vif 10 ipv6 dup-addr-detect-transmits 1
set interfaces switch switch0 vif 10 ipv6 router-advert cur-hop-limit 64
set interfaces switch switch0 vif 10 ipv6 router-advert default-lifetime 9000
set interfaces switch switch0 vif 10 ipv6 router-advert default-preference medium
set interfaces switch switch0 vif 10 ipv6 router-advert link-mtu 1492
set interfaces switch switch0 vif 10 ipv6 router-advert managed-flag false
set interfaces switch switch0 vif 10 ipv6 router-advert max-interval 1800
set interfaces switch switch0 vif 10 ipv6 router-advert min-interval 600
set interfaces switch switch0 vif 10 ipv6 router-advert name-server 'fd1a:ac95:26c8:c75f::1'
set interfaces switch switch0 vif 10 ipv6 router-advert other-config-flag false
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' autonomous-flag true
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' on-link-flag true
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' preferred-lifetime 57600
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' valid-lifetime 86400
set interfaces switch switch0 vif 10 ipv6 router-advert send-advert true
```

### IPv6 WAN

```
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd no-dns
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd pd 0 interface switch0.10 host-address '::1190:1cd9:750e:8422'
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd pd 0 prefix-length /64
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd prefix-only
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd rapid-commit enable
set interfaces ethernet eth0 vif 600 pppoe 0 firewall in ipv6-name IPV6_FORWARD_WAN_IN
set interfaces ethernet eth0 vif 600 pppoe 0 firewall local ipv6-name IPV6_INPUT_WAN_IN
set interfaces ethernet eth0 vif 600 pppoe 0 ipv6 address autoconf
set interfaces ethernet eth0 vif 600 pppoe 0 ipv6 dup-addr-detect-transmits 1
set interfaces ethernet eth0 vif 600 pppoe 0 ipv6 enable
```

### IPv6 TCP MSS clamping

See **[ipv6_mangle_wan.sh](./scripts/ipv6_mangle_wan.sh)**

### IPv6 DNS query redirection

See **[ipv6_nat_lan.sh](./scripts/ipv6_nat_lan.sh)**

### IPv6 workaround for ISP blocking of incoming NTP packets

See **[ipv6_nat_wan.sh](./scripts/ipv6_nat_wan.sh)**

### IPv6 static DNS configuration

```
set system static-host-mapping host-name router.lan inet 'fd1a:ac95:26c8:c75f::1'
```

### DNS configuration

```
set service dns forwarding cache-size 10000
set service dns forwarding listen-on switch0.10
set service dns forwarding name-server 8.8.4.4
set service dns forwarding name-server 8.8.8.8
set service dns forwarding options bogus-priv
set service dns forwarding options domain-needed
```

### Connection tracking configuration

```
set system conntrack tcp loose enable
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

### Clock configuration

```
delete system ntp server
set system ntp server time1.google.com
set system ntp server time2.google.com
set system ntp server time3.google.com
set system ntp server time4.google.com
set system time-zone America/Sao_Paulo
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

### Host name configuration

```
set system host-name Home-Router
```

### Discovery configuration

```
set service ubnt-discover disable
```

### Disabling of unused services

```
set service unms disable
```

### Management channels configuration

```
set service gui http-port 80
set service gui https-port 443
set service gui older-ciphers disable
set service ssh port 22
set service ssh protocol-version v2
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

## Configuration scripts

### Upload

```
$ scp ./scripts/ipv4_nat_lan.sh ./scripts/ipv6_nat_lan.sh ./scripts/ipv4_mangle_wan.sh ./scripts/ipv6_mangle_wan.sh ./scripts/ipv6_nat_wan.sh user925232615@router.lan:/home/user925232615
```

### Setup

```
$ sudo mv /home/user925232615/ipv4_nat_lan.sh /home/user925232615/ipv6_nat_lan.sh /home/user925232615/ipv4_mangle_wan.sh /home/user925232615/ipv6_mangle_wan.sh /home/user925232615/ipv6_nat_wan.sh /config/scripts/post-config.d
$ sudo chown root:root /config/scripts/post-config.d/ipv4_nat_lan.sh /config/scripts/post-config.d/ipv6_nat_lan.sh /config/scripts/post-config.d/ipv4_mangle_wan.sh /config/scripts/post-config.d/ipv6_mangle_wan.sh /config/scripts/post-config.d/ipv6_nat_wan.sh
$ sudo chmod +x /config/scripts/post-config.d/ipv4_nat_lan.sh /config/scripts/post-config.d/ipv6_nat_lan.sh /config/scripts/post-config.d/ipv4_mangle_wan.sh /config/scripts/post-config.d/ipv6_mangle_wan.sh /config/scripts/post-config.d/ipv6_nat_wan.sh
```

## Cleanup

```
$ sudo rm -rf /home/ubnt
```

## Final configuration

```
set firewall all-ping enable
set firewall broadcast-ping disable
set firewall group address-group IPV4_MASQUERADE_ADDRESSES address 10.182.186.0/24
set firewall group ipv6-address-group IPV6_LINK_LOCAL_ADDRESSES ipv6-address 'fe80::/10'
set firewall group port-group DHCPV6_PORT port 546
set firewall group port-group NTP_PORT port 123
set firewall ipv6-name IPV6_FORWARD_WAN_IN default-action drop
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 2500 action accept
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 2500 description 'accept established,related packets'
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 2500 state established enable
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 2500 state related enable
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 5000 action drop
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 5000 description 'drop invalid packets'
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 5000 state invalid enable
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 7500 action accept
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 7500 description 'accept icmpv6 echo request packets'
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 7500 icmpv6 type 128/0
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 7500 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN default-action drop
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 1111 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 1111 description 'accept established,related packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 1111 state established enable
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 1111 state related enable
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 2222 action drop
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 2222 description 'drop invalid packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 2222 state invalid enable
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 3333 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 3333 description 'accept icmpv6 echo request packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 3333 icmpv6 type 128/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 3333 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 description 'accept icmpv6 router solicitation packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 icmpv6 type 133/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 source group ipv6-address-group IPV6_LINK_LOCAL_ADDRESSES
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 description 'accept icmpv6 router advertisement packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 icmpv6 type 134/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 source group ipv6-address-group IPV6_LINK_LOCAL_ADDRESSES
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 description 'accept icmpv6 neighbor solicitation packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 icmpv6 type 135/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 source group ipv6-address-group IPV6_LINK_LOCAL_ADDRESSES
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 description 'accept icmpv6 neighbor advertisement packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 icmpv6 type 136/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 source group ipv6-address-group IPV6_LINK_LOCAL_ADDRESSES
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 description 'accept dhcpv6 packets'
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 destination group port-group DHCPV6_PORT
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 protocol udp
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 source group ipv6-address-group IPV6_LINK_LOCAL_ADDRESSES
set firewall ipv6-receive-redirects disable
set firewall ipv6-src-route disable
set firewall ip-src-route disable
set firewall name IPV4_FORWARD_WAN_IN default-action drop
set firewall name IPV4_FORWARD_WAN_IN rule 3333 action accept
set firewall name IPV4_FORWARD_WAN_IN rule 3333 description 'accept established,related packets'
set firewall name IPV4_FORWARD_WAN_IN rule 3333 state established enable
set firewall name IPV4_FORWARD_WAN_IN rule 3333 state related enable
set firewall name IPV4_FORWARD_WAN_IN rule 6666 action drop
set firewall name IPV4_FORWARD_WAN_IN rule 6666 description 'drop invalid packets'
set firewall name IPV4_FORWARD_WAN_IN rule 6666 state invalid enable
set firewall name IPV4_INPUT_WAN_IN default-action drop
set firewall name IPV4_INPUT_WAN_IN rule 2500 action accept
set firewall name IPV4_INPUT_WAN_IN rule 2500 description 'accept established,related packets'
set firewall name IPV4_INPUT_WAN_IN rule 2500 state established enable
set firewall name IPV4_INPUT_WAN_IN rule 2500 state related enable
set firewall name IPV4_INPUT_WAN_IN rule 5000 action drop
set firewall name IPV4_INPUT_WAN_IN rule 5000 description 'drop invalid packets'
set firewall name IPV4_INPUT_WAN_IN rule 5000 state invalid enable
set firewall name IPV4_INPUT_WAN_IN rule 7500 action accept
set firewall name IPV4_INPUT_WAN_IN rule 7500 description 'accept icmp echo request packets'
set firewall name IPV4_INPUT_WAN_IN rule 7500 icmp code 0
set firewall name IPV4_INPUT_WAN_IN rule 7500 icmp type 8
set firewall name IPV4_INPUT_WAN_IN rule 7500 protocol icmp
set firewall receive-redirects disable
set firewall send-redirects enable
set firewall source-validation loose
set firewall syn-cookies enable
set interfaces ethernet eth0 address 10.123.203.2/24
set interfaces ethernet eth0 description eth0-wan
set interfaces ethernet eth0 duplex auto
set interfaces ethernet eth0 mac 'D0:21:F9:90:67:BD'
set interfaces ethernet eth0 mtu 1500
set interfaces ethernet eth0 speed auto
set interfaces ethernet eth0 vif 600 description eth0-wan-vif-600
set interfaces ethernet eth0 vif 600 pppoe 0 default-route auto
set interfaces ethernet eth0 vif 600 pppoe 0 description eth0-wan-vif-600-pppoe
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd no-dns
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd pd 0 interface switch0.10 host-address '::1190:1cd9:750e:8422'
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd pd 0 prefix-length /64
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd prefix-only
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd rapid-commit enable
set interfaces ethernet eth0 vif 600 pppoe 0 firewall in ipv6-name IPV6_FORWARD_WAN_IN
set interfaces ethernet eth0 vif 600 pppoe 0 firewall in name IPV4_FORWARD_WAN_IN
set interfaces ethernet eth0 vif 600 pppoe 0 firewall local ipv6-name IPV6_INPUT_WAN_IN
set interfaces ethernet eth0 vif 600 pppoe 0 firewall local name IPV4_INPUT_WAN_IN
set interfaces ethernet eth0 vif 600 pppoe 0 ipv6 address autoconf
set interfaces ethernet eth0 vif 600 pppoe 0 ipv6 dup-addr-detect-transmits 1
set interfaces ethernet eth0 vif 600 pppoe 0 ipv6 enable
set interfaces ethernet eth0 vif 600 pppoe 0 mtu 1492
set interfaces ethernet eth0 vif 600 pppoe 0 name-server none
set interfaces ethernet eth0 vif 600 pppoe 0 password cliente
set interfaces ethernet eth0 vif 600 pppoe 0 user-id cliente@cliente
set interfaces ethernet eth1 description eth1
set interfaces ethernet eth1 duplex auto
set interfaces ethernet eth1 mac 'D0:21:F9:82:0D:94'
set interfaces ethernet eth1 mtu 1500
set interfaces ethernet eth1 speed auto
set interfaces ethernet eth2 description eth2
set interfaces ethernet eth2 duplex auto
set interfaces ethernet eth2 mac 'D0:21:F9:D5:0A:39'
set interfaces ethernet eth2 mtu 1500
set interfaces ethernet eth2 speed auto
set interfaces ethernet eth3 description eth3
set interfaces ethernet eth3 duplex auto
set interfaces ethernet eth3 mac 'D0:21:F9:0E:6E:DA'
set interfaces ethernet eth3 mtu 1500
set interfaces ethernet eth3 speed auto
set interfaces ethernet eth4 description eth4
set interfaces ethernet eth4 duplex auto
set interfaces ethernet eth4 mac 'D0:21:F9:76:B7:33'
set interfaces ethernet eth4 mtu 1500
set interfaces ethernet eth4 speed auto
set interfaces loopback lo address 10.189.117.1/32
set interfaces loopback lo address 'fd1a:ac95:26c8:c75f::1/128'
set interfaces switch switch0 description switch0-lan
set interfaces switch switch0 mtu 1500
set interfaces switch switch0 switch-port interface eth1 vlan pvid 1
set interfaces switch switch0 switch-port interface eth1 vlan vid 10
set interfaces switch switch0 switch-port interface eth2 vlan pvid 10
set interfaces switch switch0 switch-port interface eth3 vlan pvid 10
set interfaces switch switch0 switch-port interface eth4 vlan pvid 10
set interfaces switch switch0 switch-port vlan-aware enable
set interfaces switch switch0 vif 10 address 10.182.186.1/24
set interfaces switch switch0 vif 10 description switch0-lan-vif-10
set interfaces switch switch0 vif 10 ipv6 dup-addr-detect-transmits 1
set interfaces switch switch0 vif 10 ipv6 router-advert cur-hop-limit 64
set interfaces switch switch0 vif 10 ipv6 router-advert default-lifetime 9000
set interfaces switch switch0 vif 10 ipv6 router-advert default-preference medium
set interfaces switch switch0 vif 10 ipv6 router-advert link-mtu 1492
set interfaces switch switch0 vif 10 ipv6 router-advert managed-flag false
set interfaces switch switch0 vif 10 ipv6 router-advert max-interval 1800
set interfaces switch switch0 vif 10 ipv6 router-advert min-interval 600
set interfaces switch switch0 vif 10 ipv6 router-advert name-server 'fd1a:ac95:26c8:c75f::1'
set interfaces switch switch0 vif 10 ipv6 router-advert other-config-flag false
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' autonomous-flag true
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' on-link-flag true
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' preferred-lifetime 57600
set interfaces switch switch0 vif 10 ipv6 router-advert prefix '::/64' valid-lifetime 86400
set interfaces switch switch0 vif 10 ipv6 router-advert send-advert true
set service dhcp-server shared-network-name VIF_10 authoritative enable
set service dhcp-server shared-network-name VIF_10 subnet 10.182.186.0/24 default-router 10.182.186.1
set service dhcp-server shared-network-name VIF_10 subnet 10.182.186.0/24 dns-server 10.189.117.1
set service dhcp-server shared-network-name VIF_10 subnet 10.182.186.0/24 lease 57600
set service dhcp-server shared-network-name VIF_10 subnet 10.182.186.0/24 start 10.182.186.2 stop 10.182.186.254
set service dhcp-server shared-network-name VIF_10 subnet 10.182.186.0/24 subnet-parameters 'option interface-mtu 1492;'
set service dhcp-server shared-network-name VIF_10 subnet 10.182.186.0/24 subnet-parameters 'option broadcast-address 10.182.186.255;'
set service dhcp-server static-arp enable
set service dns forwarding cache-size 10000
set service dns forwarding listen-on switch0.10
set service dns forwarding name-server 8.8.4.4
set service dns forwarding name-server 8.8.8.8
set service dns forwarding options bogus-priv
set service dns forwarding options domain-needed
set service gui http-port 80
set service gui https-port 443
set service gui older-ciphers disable
set service nat rule 6000 outbound-interface pppoe0
set service nat rule 6000 outside-address port 49152-65535
set service nat rule 6000 protocol udp
set service nat rule 6000 source group address-group IPV4_MASQUERADE_ADDRESSES
set service nat rule 6000 source group port-group NTP_PORT
set service nat rule 6000 type masquerade
set service nat rule 7000 outbound-interface pppoe0
set service nat rule 7000 source group address-group IPV4_MASQUERADE_ADDRESSES
set service nat rule 7000 type masquerade
set service nat rule 8000 outbound-interface pppoe0
set service nat rule 8000 outside-address port 49152-65535
set service nat rule 8000 protocol udp
set service nat rule 8000 source group port-group NTP_PORT
set service nat rule 8000 type source
set service nat rule 9000 outbound-interface eth0
set service nat rule 9000 source group address-group IPV4_MASQUERADE_ADDRESSES
set service nat rule 9000 type masquerade
set service ssh port 22
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
set system conntrack tcp loose enable
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
set system login user user925232615 authentication plaintext-password 'password478924191'
set system login user user925232615 level admin
set system ntp server time1.google.com
set system ntp server time2.google.com
set system ntp server time3.google.com
set system ntp server time4.google.com
set system offload hwnat disable
set system offload ipsec disable
set system static-host-mapping host-name router.lan inet 10.189.117.1
set system static-host-mapping host-name router.lan inet 'fd1a:ac95:26c8:c75f::1'
set system time-zone America/Sao_Paulo
set system traffic-analysis dpi disable
```

## End result

### IPv4 addresses

```
$ sudo ip -brief -4 address
lo               UNKNOWN        127.0.0.1/8 10.189.117.1/32
eth0@itf0        UP             10.123.203.2/24
switch0.10@switch0 UP             10.182.186.1/24
pppoe0           UNKNOWN        201.42.157.128 peer 189.97.102.55/32
```

### IPv4 routes

```
$ sudo ip -4 route
default dev pppoe0 scope link
10.123.203.0/24 dev eth0 proto kernel scope link src 10.123.203.2
10.182.186.0/24 dev switch0.10 proto kernel scope link src 10.182.186.1
10.189.117.1 dev lo proto kernel scope link
189.97.102.55 dev pppoe0 proto kernel scope link src 201.42.157.128
201.42.157.128 dev pppoe0 proto kernel scope link
```

### IPv6 addresses

```
$ sudo ip -brief -6 address
lo               UNKNOWN        fd1a:ac95:26c8:c75f::1/128 ::1/128
itf0             UNKNOWN        fe80::d221:f9ff:fee1:353/64
eth0@itf0        UP             fe80::d221:f9ff:fe90:67bd/64
eth1@itf0        UP             fe80::d221:f9ff:fe82:d94/64
eth2@itf0        UP             fe80::d221:f9ff:fed5:a39/64
eth3@itf0        UP             fe80::d221:f9ff:fe0e:6eda/64
eth4@itf0        UP             fe80::d221:f9ff:fe76:b733/64
switch0@itf0     UP             fe80::d221:f9ff:fee1:353/64
switch0.10@switch0 UP             2804:7f4:ca02:6729:1190:1cd9:750e:8422/64 fe80::d221:f9ff:fee1:353/64
eth0.600@eth0    UP             fe80::d221:f9ff:fe90:67bd/64
pppoe0           UNKNOWN        2804:7f4:c02f:a3eb:e8a8:270d:201f:c75d/64 fe80::e8a8:270d:201f:c75d/10
```

### IPv6 routes

```
$ sudo ip -6 route
2804:7f4:c02f:a3eb::/64 dev pppoe0 proto kernel metric 256 expires 258874sec pref medium
2804:7f4:ca02:6729::/64 dev switch0.10 proto kernel metric 256 pref medium
unreachable fd1a:ac95:26c8:c75f::1 dev lo proto kernel metric 256 error -128 pref medium
fe80::/64 dev itf0 proto kernel metric 256 pref medium
fe80::/64 dev switch0 proto kernel metric 256 pref medium
fe80::/64 dev eth0 proto kernel metric 256 pref medium
fe80::/64 dev eth4 proto kernel metric 256 pref medium
fe80::/64 dev eth3 proto kernel metric 256 pref medium
fe80::/64 dev eth2 proto kernel metric 256 pref medium
fe80::/64 dev eth1 proto kernel metric 256 pref medium
fe80::/64 dev switch0.10 proto kernel metric 256 pref medium
fe80::/64 dev eth0.600 proto kernel metric 256 pref medium
fe80::/10 dev pppoe0 metric 1 pref medium
fe80::/10 dev pppoe0 proto kernel metric 256 pref medium
default via fe80::a21c:8dff:fef1:1934 dev pppoe0 proto ra metric 1024 expires 1474sec pref medium
```

## Resources

* [commands.txt](./commands.txt)
* [configuration.txt](./configuration.txt)
* [ipv4_nat_lan.sh](./scripts/ipv4_nat_lan.sh)
* [ipv6_nat_lan.sh](./scripts/ipv6_nat_lan.sh)
* [ipv4_mangle_wan.sh](./scripts/ipv4_mangle_wan.sh)
* [ipv6_mangle_wan.sh](./scripts/ipv6_mangle_wan.sh)
* [ipv6_nat_wan.sh](./scripts/ipv6_nat_wan.sh)
