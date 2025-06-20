## Router management

### Protocols and ports

* HTTPS: TCP/18856 (**[https://home-router.lan:18856/](https://home-router.lan:18856/)**)
* SSH: TCP/36518
* WinBox: TCP/24639

### Credential

Username: **username920169077**</br>
Password: **password767865354**

## Required files

### Keys and certificates

* certificate_authority.crt
* management_https.crt
* management_https.key

Follow the steps at **[Keys and certificates](../keys_and_certificates)** to create the keys and certificates

## Configuration commands

### Credential configuration

```
/user add group=full name=username920169077 password=password767865354
```

### Default credential removal

```
/user remove admin
```

### Host name configuration

```
/system identity set name=Home-Router
```

### Interfaces configuration

```
/interface ethernet set [ find default-name=ether1 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:41:3E:50 mtu=1500 name=eth1-wan
/interface ethernet set [ find default-name=ether2 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:D2:32:3B mtu=1500 name=eth2
/interface ethernet set [ find default-name=ether3 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:93:38:59 mtu=1500 name=eth3
/interface ethernet set [ find default-name=ether4 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:C2:ED:8C mtu=1500 name=eth4
/interface ethernet set [ find default-name=ether5 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:5D:38:CB mtu=1500 name=eth5
/interface ethernet set [ find default-name=ether6 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:CB:0D:50 mtu=1500 name=eth6
/interface ethernet set [ find default-name=ether7 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:9F:ED:76 mtu=1500 name=eth7
/interface ethernet set [ find default-name=ether8 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:1C:70:66 mtu=1500 name=eth8
/interface ethernet set [ find default-name=sfp-sfpplus1 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=yes l2mtu=1504 loop-protect=off mac-address=48:A9:8A:D0:2F:04 mtu=1500 name=sfpplus1
```

### Switch configuration

```
/interface bridge settings set allow-fast-path=yes use-ip-firewall=no
/interface bridge add admin-mac=48:A9:8A:2E:20:84 arp=enabled arp-timeout=auto auto-mac=no dhcp-snooping=no ether-type=0x8100 fast-forward=yes forward-reserved-addresses=no frame-types=admit-all igmp-snooping=no ingress-filtering=yes max-learned-entries=auto mtu=1500 name=bridge-lan protocol-mode=none pvid=1 vlan-filtering=yes
/interface bridge vlan add bridge=bridge-lan untagged=bridge-lan,eth2 vlan-ids=1
/interface bridge vlan add bridge=bridge-lan tagged=bridge-lan,eth2 untagged=eth3,eth4,eth5,eth6,eth7,eth8 vlan-ids=10
/interface vlan add arp=enabled arp-timeout=auto interface=bridge-lan loop-protect=off mtu=1500 name=bridge-lan-vlan-1 vlan-id=1
/interface vlan add arp=enabled arp-timeout=auto interface=bridge-lan loop-protect=off mtu=1500 name=bridge-lan-vlan-10 vlan-id=10
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-all hw=yes ingress-filtering=yes interface=eth2 learn=yes pvid=1 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth3 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth4 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth5 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth6 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth7 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth8 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
```

### IPv4 kernel configuration

```
/ip settings set accept-redirects=no accept-source-route=no allow-fast-path=yes ip-forward=yes rp-filter=loose secure-redirects=yes send-redirects=yes tcp-syncookies=yes tcp-timestamps=random-offset
```

### IPv6 kernel configuration

```
/ipv6 settings set accept-redirects=no accept-router-advertisements=yes allow-fast-path=yes disable-ipv6=no disable-link-local-address=no forward=yes
```

### IPv4 loopback address configuration

```
/ip address add address=192.168.167.1/32 interface=lo network=192.168.167.1
```

### IPv6 loopback address configuration

```
/ipv6 address add address=fd45:1e52:2abe:4c85::1/128 advertise=no auto-link-local=yes interface=lo no-dad=no
```

### IPv4 LAN configuration

```
/interface list add name=lan-vlan-10-interface
/interface list member add interface=bridge-lan-vlan-10 list=lan-vlan-10-interface
/ip address add address=192.168.103.254/24 interface=bridge-lan-vlan-10 network=192.168.103.0
/ip dhcp-server option add code=23 force=no name=ipv4-vlan-10-dhcp-server-option-23 value="'64'"
/ip dhcp-server option add code=26 force=no name=ipv4-vlan-10-dhcp-server-option-26 value="'1492'"
/ip dhcp-server option add code=28 force=no name=ipv4-vlan-10-dhcp-server-option-28 value="'192.168.103.255'"
/ip dhcp-server network add address=192.168.103.0/24 dhcp-option=ipv4-vlan-10-dhcp-server-option-23,ipv4-vlan-10-dhcp-server-option-26,ipv4-vlan-10-dhcp-server-option-28 dns-server=192.168.167.1 gateway=192.168.103.254 netmask=0
/ip pool add name=ipv4-vlan-10-dhcp-server-pool ranges=192.168.103.1-192.168.103.253
/ip dhcp-server add add-arp=yes address-pool=ipv4-vlan-10-dhcp-server-pool always-broadcast=no authoritative=yes bootp-support=none conflict-detection=yes interface=bridge-lan-vlan-10 lease-time=16h name=ipv4-vlan-10-dhcp-server use-reconfigure=no
```

### IPv6 LAN configuration

```
/ipv6 nd prefix default set autonomous=yes preferred-lifetime=16h valid-lifetime=1d
/ipv6 nd set [ find default=yes ] disabled=yes
/ipv6 nd add advertise-dns=yes advertise-mac-address=yes dns=fd45:1e52:2abe:4c85::1 hop-limit=64 interface=bridge-lan-vlan-10 managed-address-configuration=no mtu=1492 other-configuration=no ra-interval=3m20s-10m ra-lifetime=2h30m ra-preference=medium
```

### IPv4 WAN firewall rules

```
/interface list add name=wan-interface
/ip firewall filter add action=jump chain=forward comment="check packets in the forward chain coming from the wan interface" in-interface-list=wan-interface jump-target=ipv4-forward-wan-in
/ip firewall filter add action=return chain=ipv4-forward-wan-in comment="allow established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-forward-wan-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=drop chain=ipv4-forward-wan-in comment="drop remaining packets"
/ip firewall filter add action=jump chain=input comment="check packets in the input chain coming from the wan interface" in-interface-list=wan-interface jump-target=ipv4-input-wan-in
/ip firewall filter add action=return chain=ipv4-input-wan-in comment="allow established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-input-wan-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=return chain=ipv4-input-wan-in comment="allow icmp echo request packets" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=drop chain=ipv4-input-wan-in comment="drop remaining packets"
```

### IPv6 WAN firewall rules

```
/ipv6 firewall address-list add address=fe80::/10 list=ipv6-link-local-addresses
/ipv6 firewall filter add action=jump chain=forward comment="check packets in the forward chain coming from the wan interface" in-interface-list=wan-interface jump-target=ipv6-forward-wan-in
/ipv6 firewall filter add action=return chain=ipv6-forward-wan-in comment="allow established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=return chain=ipv6-forward-wan-in comment="allow icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop remaining packets"
/ipv6 firewall filter add action=jump chain=input comment="check packets in the input chain coming from the wan interface" in-interface-list=wan-interface jump-target=ipv6-input-wan-in
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow dhcpv6 packets from link-local addresses" dst-port=546 protocol=udp src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 router advertisement packets from link-local addresses" icmp-options=134:0 protocol=icmpv6 src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 neighbor solicitation packets" icmp-options=135:0 protocol=icmpv6
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 neighbor advertisement packets" icmp-options=136:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop remaining packets"
```

### IPv4 address for modem access

```
/ip address add address=192.168.237.2/30 interface=eth1-wan network=192.168.237.0
```

### IPv4 WAN configuration

```
/ppp profile add change-tcp-mss=no interface-list=wan-interface name=pppoe-client-profile use-compression=no use-encryption=no use-ipv6=yes use-mpls=no
/interface vlan add arp=enabled arp-timeout=auto interface=eth1-wan loop-protect=off mtu=1500 name=eth1-wan-vlan-600 vlan-id=600
/interface pppoe-client add add-default-route=yes allow=chap,mschap1,mschap2 default-route-distance=2 disabled=no interface=eth1-wan-vlan-600 max-mru=1492 max-mtu=1492 name=eth1-wan-vlan-600-pppoe-client password=cliente profile=pppoe-client-profile use-peer-dns=no user=cliente@cliente
```

### IPv6 WAN configuration

```
/ipv6 address add address=::6e86:3d5b:dc42:add2/64 advertise=yes auto-link-local=yes from-pool=ipv6-dhcp-client-pool interface=bridge-lan-vlan-10 no-dad=no
/ipv6 dhcp-client add add-default-route=yes allow-reconfigure=no check-gateway=ping custom-duid=0003000148a98a413e50 default-route-distance=2 default-route-tables=main:3 interface=eth1-wan-vlan-600-pppoe-client pool-name=ipv6-dhcp-client-pool pool-prefix-length=64 prefix-hint=::/64 rapid-commit=yes request=prefix use-interface-duid=no use-peer-dns=no validate-server-duid=yes
```

### IPv4 TCP MSS clamping

```
/ip firewall mangle add action=change-mss chain=forward in-interface-list=wan-interface new-mss=1452 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1453-65535
/ip firewall mangle add action=change-mss chain=postrouting new-mss=1452 out-interface-list=wan-interface passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1453-65535
```

### IPv6 TCP MSS clamping

```
/ipv6 firewall mangle add action=change-mss chain=forward in-interface-list=wan-interface new-mss=1432 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1433-65535
/ipv6 firewall mangle add action=change-mss chain=postrouting new-mss=1432 out-interface-list=wan-interface passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1433-65535
```

### IPv4 DNAT redirecting all DNS queries to the router

```
/ip firewall address-list add address=192.168.167.1/32 list=ipv4-dns-address
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ipv4-dns-address dst-port=53 in-interface-list=lan-vlan-10-interface protocol=udp
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ipv4-dns-address dst-port=53 in-interface-list=lan-vlan-10-interface protocol=tcp
```

### IPv6 DNAT redirecting all DNS queries to the router

```
/ipv6 firewall address-list add address=fd45:1e52:2abe:4c85::1/128 list=ipv6-dns-address
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-address dst-port=53 in-interface-list=lan-vlan-10-interface protocol=udp
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-address dst-port=53 in-interface-list=lan-vlan-10-interface protocol=tcp
```

### IPv4 SNAT workaround for ISP blocking of incoming NTP packets (UDP/123)

```
/ip firewall address-list add address=192.168.103.0/24 list=ipv4-private-addresses
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interface protocol=udp src-address-list=ipv4-private-addresses src-port=123 to-ports=49152-65535
/ip firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interface protocol=udp src-port=123 to-ports=49152-65535
```

### IPv6 SNAT workaround for ISP blocking of incoming NTP packets (UDP/123)

```
/ipv6 firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interface protocol=udp src-port=123 to-ports=49152-65535
```

### IPv4 SNAT of private addresses for internet access

```
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interface src-address-list=ipv4-private-addresses
```

### IPv4 SNAT of private addresses for modem access

```
/ip firewall address-list add address=192.168.237.1/32 list=ipv4-modem-address
/ip firewall nat add action=src-nat chain=srcnat dst-address-list=ipv4-modem-address src-address-list=ipv4-private-addresses to-addresses=192.168.237.2
```

### IPv4 static DNS configuration

```
/ip dns static add address=192.168.167.1 name=home-router.lan ttl=5m type=A
/ip dns static add address=192.168.167.1 name=ipv4.home-router.lan ttl=5m type=A
```

### IPv6 static DNS configuration

```
/ip dns static add address=fd45:1e52:2abe:4c85::1 name=home-router.lan ttl=5m type=AAAA
/ip dns static add address=fd45:1e52:2abe:4c85::1 name=ipv6.home-router.lan ttl=5m type=AAAA
```

### DNS configuration

```
/ip dns set allow-remote-requests=yes cache-size=20480KiB max-concurrent-queries=1000 servers=2001:4860:4860::8888,2001:4860:4860::8844
```

### Clock configuration

```
/system clock set time-zone-autodetect=no time-zone-name=America/Sao_Paulo
/system ntp client servers add address=time1.google.com iburst=yes
/system ntp client servers add address=time2.google.com iburst=yes
/system ntp client servers add address=time3.google.com iburst=yes
/system ntp client servers add address=time4.google.com iburst=yes
/system ntp client set enabled=yes mode=unicast
```

### Connection tracking configuration

```
/ip firewall connection tracking set enabled=yes generic-timeout=10m icmp-timeout=30s loose-tcp-tracking=no tcp-close-timeout=10s tcp-close-wait-timeout=1m tcp-established-timeout=5d tcp-fin-wait-timeout=2m tcp-last-ack-timeout=30s tcp-max-retrans-timeout=5m tcp-syn-received-timeout=1m tcp-syn-sent-timeout=2m tcp-time-wait-timeout=2m tcp-unacked-timeout=5m udp-stream-timeout=3m udp-timeout=30s
```

### Disabling of unneeded NAT helpers

```
/ip firewall service-port set ftp disabled=yes
/ip firewall service-port set h323 disabled=yes
/ip firewall service-port set irc disabled=yes
/ip firewall service-port set pptp disabled=yes
/ip firewall service-port set rtsp disabled=yes
/ip firewall service-port set sip disabled=yes
/ip firewall service-port set tftp disabled=yes
```

### Disabling of discovery

```
/ip neighbor discovery-settings set discover-interface-list=none
```

### Disabling of unused services

```
/ip smb set enabled=no
/tool bandwidth-server set enabled=no
```

### Configuration of management via SSH

```
/ip service set ssh disabled=no port=36518
/ip ssh set ciphers=aes-gcm host-key-type=ed25519 strong-crypto=yes
```

### Configuration of management via WinBox

```
/ip service set winbox disabled=no port=24639
```

### Disabling of unused management channels

```
/ip service set api disabled=yes
/ip service set api-ssl disabled=yes
/ip service set ftp disabled=yes
/ip service set telnet disabled=yes
/ip service set www disabled=yes
```

### Upload of additional files

```
$ scp -P 36518 ../keys_and_certificates/certificate_authority.crt ../keys_and_certificates/management_https.crt ../keys_and_certificates/management_https.key username920169077@ipv6.home-router.lan:/
```

### Configuration of management via HTTPS

```
/certificate import file-name=certificate_authority.crt name=certificate_authority trusted=yes
/certificate import file-name=management_https.crt name=management_https trusted=yes
/certificate import file-name=management_https.key name=management_https trusted=yes
/ip service set www-ssl certificate=management_https disabled=no port=18856 tls-version=only-1.2
```

### IPv4 LAN firewall rules

```
/ip firewall filter add action=jump chain=input comment="check packets in the input chain coming from the lan-vlan-10 interface" in-interface-list=lan-vlan-10-interface jump-target=ipv4-input-lan-vlan-10-in
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-input-lan-vlan-10-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow tcp dns packets" dst-port=53 protocol=tcp
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow udp dns packets" dst-port=53 protocol=udp
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow dhcp packets" dst-port=67 protocol=udp
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow management via https" dst-port=18856 protocol=tcp
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow management via winbox" dst-port=24639 protocol=tcp
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow management via ssh" dst-port=36518 protocol=tcp
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow icmp echo request packets" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=drop chain=ipv4-input-lan-vlan-10-in comment="drop remaining packets"
```

### IPv6 LAN firewall rules

```
/ipv6 firewall address-list add address=fe80::/10 list=ipv6-link-local-and-unspecified-addresses
/ipv6 firewall address-list add address=::/128 list=ipv6-link-local-and-unspecified-addresses
/ipv6 firewall filter add action=jump chain=input comment="check packets in the input chain coming from the lan-vlan-10 interface" in-interface-list=lan-vlan-10-interface jump-target=ipv6-input-lan-vlan-10-in
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-input-lan-vlan-10-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow tcp dns packets" dst-port=53 protocol=tcp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow udp dns packets" dst-port=53 protocol=udp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow management via https" dst-port=18856 protocol=tcp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow management via winbox" dst-port=24639 protocol=tcp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow management via ssh" dst-port=36518 protocol=tcp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow icmpv6 router solicitation packets from link-local and unspecified addresses" icmp-options=133:0 protocol=icmpv6 src-address-list=ipv6-link-local-and-unspecified-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow icmpv6 neighbor solicitation packets" icmp-options=135:0 protocol=icmpv6
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow icmpv6 neighbor advertisement packets" icmp-options=136:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-input-lan-vlan-10-in comment="drop remaining packets"
```

### Cloud features configuration

```
/ip cloud set back-to-home-vpn=revoked-and-disabled ddns-enabled=auto update-time=no
```

### Logging configuration

```
/system logging action set [ find name=memory ] memory-lines=10000
```

### Graphing of interfaces traffic and system resources

```
/tool graphing interface add interface=eth1-wan-vlan-600-pppoe-client store-on-disk=no
/tool graphing interface add interface=bridge-lan-vlan-10 store-on-disk=no
/tool graphing resource add store-on-disk=no
```

### Disabling of access and troubleshooting via MAC address

```
/tool mac-server set allowed-interface-list=none
/tool mac-server mac-winbox set allowed-interface-list=none
/tool mac-server ping set enabled=no
```

### Physical interfaces queue configuration

```
/queue interface set eth1-wan queue=only-hardware-queue
/queue interface set eth2 queue=only-hardware-queue
/queue interface set eth3 queue=only-hardware-queue
/queue interface set eth4 queue=only-hardware-queue
/queue interface set eth5 queue=only-hardware-queue
/queue interface set eth6 queue=only-hardware-queue
/queue interface set eth7 queue=only-hardware-queue
/queue interface set eth8 queue=only-hardware-queue
/queue interface set sfpplus1 queue=only-hardware-queue
```

## Final configuration

```
/interface bridge add admin-mac=48:A9:8A:2E:20:84 arp=enabled arp-timeout=auto auto-mac=no dhcp-snooping=no ether-type=0x8100 fast-forward=yes forward-reserved-addresses=no frame-types=admit-all igmp-snooping=no ingress-filtering=yes max-learned-entries=auto mtu=1500 name=bridge-lan protocol-mode=none pvid=1 vlan-filtering=yes
/interface ethernet set [ find default-name=ether1 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:41:3E:50 mtu=1500 name=eth1-wan
/interface ethernet set [ find default-name=ether2 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:D2:32:3B mtu=1500 name=eth2
/interface ethernet set [ find default-name=ether3 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:93:38:59 mtu=1500 name=eth3
/interface ethernet set [ find default-name=ether4 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:C2:ED:8C mtu=1500 name=eth4
/interface ethernet set [ find default-name=ether5 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:5D:38:CB mtu=1500 name=eth5
/interface ethernet set [ find default-name=ether6 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:CB:0D:50 mtu=1500 name=eth6
/interface ethernet set [ find default-name=ether7 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:9F:ED:76 mtu=1500 name=eth7
/interface ethernet set [ find default-name=ether8 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:1C:70:66 mtu=1500 name=eth8
/interface ethernet set [ find default-name=sfp-sfpplus1 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=yes l2mtu=1504 loop-protect=off mac-address=48:A9:8A:D0:2F:04 mtu=1500 name=sfpplus1
/interface vlan add arp=enabled arp-timeout=auto interface=bridge-lan loop-protect=off mtu=1500 name=bridge-lan-vlan-1 vlan-id=1
/interface vlan add arp=enabled arp-timeout=auto interface=bridge-lan loop-protect=off mtu=1500 name=bridge-lan-vlan-10 vlan-id=10
/interface vlan add arp=enabled arp-timeout=auto interface=eth1-wan loop-protect=off mtu=1500 name=eth1-wan-vlan-600 vlan-id=600
/interface list add name=lan-vlan-10-interface
/interface list add name=wan-interface
/ip dhcp-server option add code=23 force=no name=ipv4-vlan-10-dhcp-server-option-23 value="'64'"
/ip dhcp-server option add code=26 force=no name=ipv4-vlan-10-dhcp-server-option-26 value="'1492'"
/ip dhcp-server option add code=28 force=no name=ipv4-vlan-10-dhcp-server-option-28 value="'192.168.103.255'"
/ip pool add name=ipv4-vlan-10-dhcp-server-pool ranges=192.168.103.1-192.168.103.253
/ip dhcp-server add add-arp=yes address-pool=ipv4-vlan-10-dhcp-server-pool always-broadcast=no authoritative=yes bootp-support=none conflict-detection=yes interface=bridge-lan-vlan-10 lease-time=16h name=ipv4-vlan-10-dhcp-server use-reconfigure=no
/ppp profile add change-tcp-mss=no interface-list=wan-interface name=pppoe-client-profile use-compression=no use-encryption=no use-ipv6=yes use-mpls=no
/interface pppoe-client add add-default-route=yes allow=chap,mschap1,mschap2 default-route-distance=2 disabled=no interface=eth1-wan-vlan-600 max-mru=1492 max-mtu=1492 name=eth1-wan-vlan-600-pppoe-client password=cliente profile=pppoe-client-profile use-peer-dns=no user=cliente@cliente
/queue interface set eth1-wan queue=only-hardware-queue
/queue interface set eth2 queue=only-hardware-queue
/queue interface set eth3 queue=only-hardware-queue
/queue interface set eth4 queue=only-hardware-queue
/queue interface set eth5 queue=only-hardware-queue
/queue interface set eth6 queue=only-hardware-queue
/queue interface set eth7 queue=only-hardware-queue
/queue interface set eth8 queue=only-hardware-queue
/queue interface set sfpplus1 queue=only-hardware-queue
/system logging action set [ find name=memory ] memory-lines=10000
/ip smb set enabled=no
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-all hw=yes ingress-filtering=yes interface=eth2 learn=yes pvid=1 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth3 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth4 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth5 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth6 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth7 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge-lan broadcast-flood=yes frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth8 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge settings set allow-fast-path=yes use-ip-firewall=no
/ip firewall connection tracking set enabled=yes generic-timeout=10m icmp-timeout=30s loose-tcp-tracking=no tcp-close-timeout=10s tcp-close-wait-timeout=1m tcp-established-timeout=5d tcp-fin-wait-timeout=2m tcp-last-ack-timeout=30s tcp-max-retrans-timeout=5m tcp-syn-received-timeout=1m tcp-syn-sent-timeout=2m tcp-time-wait-timeout=2m tcp-unacked-timeout=5m udp-stream-timeout=3m udp-timeout=30s
/ip neighbor discovery-settings set discover-interface-list=none
/ip settings set accept-redirects=no accept-source-route=no allow-fast-path=yes ip-forward=yes rp-filter=loose secure-redirects=yes send-redirects=yes tcp-syncookies=yes tcp-timestamps=random-offset
/ipv6 settings set accept-redirects=no accept-router-advertisements=yes allow-fast-path=yes disable-ipv6=no disable-link-local-address=no forward=yes
/interface bridge vlan add bridge=bridge-lan untagged=bridge-lan,eth2 vlan-ids=1
/interface bridge vlan add bridge=bridge-lan tagged=bridge-lan,eth2 untagged=eth3,eth4,eth5,eth6,eth7,eth8 vlan-ids=10
/interface list member add interface=bridge-lan-vlan-10 list=lan-vlan-10-interface
/ip address add address=192.168.167.1/32 interface=lo network=192.168.167.1
/ip address add address=192.168.103.254/24 interface=bridge-lan-vlan-10 network=192.168.103.0
/ip address add address=192.168.237.2/30 interface=eth1-wan network=192.168.237.0
/ip cloud set back-to-home-vpn=revoked-and-disabled ddns-enabled=auto update-time=no
/ip dhcp-server network add address=192.168.103.0/24 dhcp-option=ipv4-vlan-10-dhcp-server-option-23,ipv4-vlan-10-dhcp-server-option-26,ipv4-vlan-10-dhcp-server-option-28 dns-server=192.168.167.1 gateway=192.168.103.254 netmask=0
/ip dns set allow-remote-requests=yes cache-size=20480KiB max-concurrent-queries=1000 servers=2001:4860:4860::8888,2001:4860:4860::8844
/ip dns static add address=192.168.167.1 name=home-router.lan ttl=5m type=A
/ip dns static add address=192.168.167.1 name=ipv4.home-router.lan ttl=5m type=A
/ip dns static add address=fd45:1e52:2abe:4c85::1 name=home-router.lan ttl=5m type=AAAA
/ip dns static add address=fd45:1e52:2abe:4c85::1 name=ipv6.home-router.lan ttl=5m type=AAAA
/ip firewall address-list add address=192.168.167.1/32 list=ipv4-dns-address
/ip firewall address-list add address=192.168.103.0/24 list=ipv4-private-addresses
/ip firewall address-list add address=192.168.237.1/32 list=ipv4-modem-address
/ip firewall filter add action=jump chain=forward comment="check packets in the forward chain coming from the wan interface" in-interface-list=wan-interface jump-target=ipv4-forward-wan-in
/ip firewall filter add action=return chain=ipv4-forward-wan-in comment="allow established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-forward-wan-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=drop chain=ipv4-forward-wan-in comment="drop remaining packets"
/ip firewall filter add action=jump chain=input comment="check packets in the input chain coming from the wan interface" in-interface-list=wan-interface jump-target=ipv4-input-wan-in
/ip firewall filter add action=return chain=ipv4-input-wan-in comment="allow established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-input-wan-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=return chain=ipv4-input-wan-in comment="allow icmp echo request packets" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=drop chain=ipv4-input-wan-in comment="drop remaining packets"
/ip firewall filter add action=jump chain=input comment="check packets in the input chain coming from the lan-vlan-10 interface" in-interface-list=lan-vlan-10-interface jump-target=ipv4-input-lan-vlan-10-in
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-input-lan-vlan-10-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow tcp dns packets" dst-port=53 protocol=tcp
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow udp dns packets" dst-port=53 protocol=udp
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow dhcp packets" dst-port=67 protocol=udp
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow management via https" dst-port=18856 protocol=tcp
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow management via winbox" dst-port=24639 protocol=tcp
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow management via ssh" dst-port=36518 protocol=tcp
/ip firewall filter add action=return chain=ipv4-input-lan-vlan-10-in comment="allow icmp echo request packets" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=drop chain=ipv4-input-lan-vlan-10-in comment="drop remaining packets"
/ip firewall mangle add action=change-mss chain=forward in-interface-list=wan-interface new-mss=1452 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1453-65535
/ip firewall mangle add action=change-mss chain=postrouting new-mss=1452 out-interface-list=wan-interface passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1453-65535
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ipv4-dns-address dst-port=53 in-interface-list=lan-vlan-10-interface protocol=udp
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ipv4-dns-address dst-port=53 in-interface-list=lan-vlan-10-interface protocol=tcp
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interface protocol=udp src-address-list=ipv4-private-addresses src-port=123 to-ports=49152-65535
/ip firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interface protocol=udp src-port=123 to-ports=49152-65535
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interface src-address-list=ipv4-private-addresses
/ip firewall nat add action=src-nat chain=srcnat dst-address-list=ipv4-modem-address src-address-list=ipv4-private-addresses to-addresses=192.168.237.2
/ip firewall service-port set ftp disabled=yes
/ip firewall service-port set h323 disabled=yes
/ip firewall service-port set irc disabled=yes
/ip firewall service-port set pptp disabled=yes
/ip firewall service-port set rtsp disabled=yes
/ip firewall service-port set sip disabled=yes
/ip firewall service-port set tftp disabled=yes
/ip service set ssh disabled=no port=36518
/ip service set winbox disabled=no port=24639
/ip service set www-ssl certificate=management_https disabled=no port=18856 tls-version=only-1.2
/ip service set api disabled=yes
/ip service set api-ssl disabled=yes
/ip service set ftp disabled=yes
/ip service set telnet disabled=yes
/ip service set www disabled=yes
/ip ssh set ciphers=aes-gcm host-key-type=ed25519 strong-crypto=yes
/ipv6 address add address=fd45:1e52:2abe:4c85::1/128 advertise=no auto-link-local=yes interface=lo no-dad=no
/ipv6 address add address=::6e86:3d5b:dc42:add2/64 advertise=yes auto-link-local=yes from-pool=ipv6-dhcp-client-pool interface=bridge-lan-vlan-10 no-dad=no
/ipv6 dhcp-client add add-default-route=yes allow-reconfigure=no check-gateway=ping custom-duid=0003000148a98a413e50 default-route-distance=2 default-route-tables=main:3 interface=eth1-wan-vlan-600-pppoe-client pool-name=ipv6-dhcp-client-pool pool-prefix-length=64 prefix-hint=::/64 rapid-commit=yes request=prefix use-interface-duid=no use-peer-dns=no validate-server-duid=yes
/ipv6 firewall address-list add address=fe80::/10 list=ipv6-link-local-addresses
/ipv6 firewall address-list add address=fd45:1e52:2abe:4c85::1/128 list=ipv6-dns-address
/ipv6 firewall address-list add address=fe80::/10 list=ipv6-link-local-and-unspecified-addresses
/ipv6 firewall address-list add address=::/128 list=ipv6-link-local-and-unspecified-addresses
/ipv6 firewall filter add action=jump chain=forward comment="check packets in the forward chain coming from the wan interface" in-interface-list=wan-interface jump-target=ipv6-forward-wan-in
/ipv6 firewall filter add action=return chain=ipv6-forward-wan-in comment="allow established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=return chain=ipv6-forward-wan-in comment="allow icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop remaining packets"
/ipv6 firewall filter add action=jump chain=input comment="check packets in the input chain coming from the wan interface" in-interface-list=wan-interface jump-target=ipv6-input-wan-in
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow dhcpv6 packets from link-local addresses" dst-port=546 protocol=udp src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 router advertisement packets from link-local addresses" icmp-options=134:0 protocol=icmpv6 src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 neighbor solicitation packets" icmp-options=135:0 protocol=icmpv6
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 neighbor advertisement packets" icmp-options=136:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop remaining packets"
/ipv6 firewall filter add action=jump chain=input comment="check packets in the input chain coming from the lan-vlan-10 interface" in-interface-list=lan-vlan-10-interface jump-target=ipv6-input-lan-vlan-10-in
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-input-lan-vlan-10-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow tcp dns packets" dst-port=53 protocol=tcp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow udp dns packets" dst-port=53 protocol=udp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow management via https" dst-port=18856 protocol=tcp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow management via winbox" dst-port=24639 protocol=tcp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow management via ssh" dst-port=36518 protocol=tcp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow icmpv6 router solicitation packets from link-local and unspecified addresses" icmp-options=133:0 protocol=icmpv6 src-address-list=ipv6-link-local-and-unspecified-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow icmpv6 neighbor solicitation packets" icmp-options=135:0 protocol=icmpv6
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow icmpv6 neighbor advertisement packets" icmp-options=136:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-input-lan-vlan-10-in comment="drop remaining packets"
/ipv6 firewall mangle add action=change-mss chain=forward in-interface-list=wan-interface new-mss=1432 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1433-65535
/ipv6 firewall mangle add action=change-mss chain=postrouting new-mss=1432 out-interface-list=wan-interface passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1433-65535
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-address dst-port=53 in-interface-list=lan-vlan-10-interface protocol=udp
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-address dst-port=53 in-interface-list=lan-vlan-10-interface protocol=tcp
/ipv6 firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interface protocol=udp src-port=123 to-ports=49152-65535
/ipv6 nd set [ find default=yes ] disabled=yes
/ipv6 nd add advertise-dns=yes advertise-mac-address=yes dns=fd45:1e52:2abe:4c85::1 hop-limit=64 interface=bridge-lan-vlan-10 managed-address-configuration=no mtu=1492 other-configuration=no ra-interval=3m20s-10m ra-lifetime=2h30m ra-preference=medium
/ipv6 nd prefix default set autonomous=yes preferred-lifetime=16h valid-lifetime=1d
/system clock set time-zone-autodetect=no time-zone-name=America/Sao_Paulo
/system identity set name=Home-Router
/system ntp client set enabled=yes mode=unicast
/system ntp client servers add address=time1.google.com iburst=yes
/system ntp client servers add address=time2.google.com iburst=yes
/system ntp client servers add address=time3.google.com iburst=yes
/system ntp client servers add address=time4.google.com iburst=yes
/tool bandwidth-server set enabled=no
/tool graphing interface add interface=eth1-wan-vlan-600-pppoe-client store-on-disk=no
/tool graphing interface add interface=bridge-lan-vlan-10 store-on-disk=no
/tool graphing resource add store-on-disk=no
/tool mac-server set allowed-interface-list=none
/tool mac-server mac-winbox set allowed-interface-list=none
/tool mac-server ping set enabled=no
```

## End result

### IPv4 addresses

```
> /ip address print
Flags: D - DYNAMIC
Columns: ADDRESS, NETWORK, INTERFACE
#   ADDRESS             NETWORK        INTERFACE
0   192.168.167.1/32    192.168.167.1  lo
1   192.168.103.254/24  192.168.103.0  bridge-lan-vlan-10
2   192.168.237.2/30    192.168.237.0  eth1-wan
3 D 152.254.252.105/32  189.97.102.55  eth1-wan-vlan-600-pppoe-client
```

### IPv4 routes

```
> /ip route print
Flags: D - DYNAMIC; A - ACTIVE; c - CONNECT, v - VPN
Columns: DST-ADDRESS, GATEWAY, ROUTING-TABLE, DISTANCE
    DST-ADDRESS       GATEWAY                         ROUTING-TABLE  DISTANCE
DAv 0.0.0.0/0         eth1-wan-vlan-600-pppoe-client  main                  2
DAc 192.168.103.0/24  bridge-lan-vlan-10              main                  0
DAc 192.168.237.0/30  eth1-wan                        main                  0
DAc 189.97.102.55/32  eth1-wan-vlan-600-pppoe-client  main                  0
DAc 192.168.167.1/32  lo                              main                  0
```

### IPv6 addresses

```
> /ipv6 address print
Flags: D - DYNAMIC; G - GLOBAL, L - LINK-LOCAL
Columns: ADDRESS, FROM-POOL, INTERFACE, ADVERTISE, VALID
#    ADDRESS                                    FROM-POOL              INTERFACE                       ADVERTISE  VALID
0  G fd45:1e52:2abe:4c85::1/128                                        lo                              no
1  G 2804:7f4:ca00:ceb8:6e86:3d5b:dc42:add2/64  ipv6-dhcp-client-pool  bridge-lan-vlan-10              yes
2 D  ::1/128                                                           lo                              no
3 DL fe80::4aa9:8aff:fe2e:2084/64                                      bridge-lan-vlan-10              no
4 DL fe80::4aa9:8aff:fe2e:2084/64                                      bridge-lan-vlan-1               no
5 DL fe80::4aa9:8aff:fe2e:2084/64                                      bridge-lan                      no
6 DL fe80::4aa9:8aff:fe41:3e50/64                                      eth1-wan                        no
7 DL fe80::4aa9:8aff:fe41:3e50/64                                      eth1-wan-vlan-600               no
8 DL fe80::17c4:2404:0:f/64                                            eth1-wan-vlan-600-pppoe-client  no
9 DG 2804:7f4:c02f:660a:17c4:2404:0:f/64                               eth1-wan-vlan-600-pppoe-client  no         2d23h56m
```

### IPv6 routes

```
> /ipv6 route print
Flags: D - DYNAMIC; A - ACTIVE; c - CONNECT, d - DHCP, v - VPN
Columns: DST-ADDRESS, GATEWAY, ROUTING-TABLE, DISTANCE
    DST-ADDRESS                 GATEWAY                                                   ROUTING-TABLE  DISTANCE
DAv ::/0                        eth1-wan-vlan-600-pppoe-client                            main                  2
D d ::/0                        fe80::a21c:8dff:fef1:1934%eth1-wan-vlan-600-pppoe-client  main                  3
DAc 2804:7f4:c02f:660a::/64     eth1-wan-vlan-600-pppoe-client                            main                  0
D d 2804:7f4:ca00:ceb8::/64                                                               main                  2
DAc 2804:7f4:ca00:ceb8::/64     bridge-lan-vlan-10                                        main                  0
DAc fe80::/64                   bridge-lan-vlan-10                                        main                  0
DAc fe80::/64                   bridge-lan-vlan-1                                         main                  0
DAc fe80::/64                   bridge-lan                                                main                  0
DAc fe80::/64                   eth1-wan                                                  main                  0
DAc fe80::/64                   eth1-wan-vlan-600                                         main                  0
DAc fe80::/64                   eth1-wan-vlan-600-pppoe-client                            main                  0
DAc ::1/128                     lo                                                        main                  0
DAc fd45:1e52:2abe:4c85::1/128  lo                                                        main                  0
```

## Resources

* [commands.rsc](./commands.rsc)
* [configuration.rsc](./configuration.rsc)
