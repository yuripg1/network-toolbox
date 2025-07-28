## Router management

### Protocols and ports

* HTTPS: TCP/18856 (**[https://router.internal:18856/](https://router.internal:18856/)**)
* SSH: TCP/36518
* WinBox: TCP/24639

### Credential

Username: **username920169077**</br>
Password: **password767865354**

## Zone-based firewall policies

### IPv4

| <nobr>From&nbsp;\\&nbsp;To</nobr> | Local                                  | LAN                                    | WAN                                 | Modem                               |
|----------------------------------:|:--------------------------------------:|:--------------------------------------:|:-----------------------------------:|:-----------------------------------:|
| Local                             | ✅                                     | <nobr>ipv4-allow-all-traffic</nobr>    | <nobr>ipv4-allow-all-traffic</nobr> | <nobr>ipv4-allow-all-traffic</nobr> |
| LAN                               | <nobr>ipv4-lan-to-local</nobr>         | ✅                                     | <nobr>ipv4-allow-all-traffic</nobr> | <nobr>ipv4-lan-to-modem</nobr>      |
| WAN                               | <nobr>ipv4-wan-to-local</nobr>         | <nobr>ipv4-wan-to-lan</nobr>           | ✅                                  | ❌                                  |
| Modem                             | <nobr>ipv4-allow-return-traffic</nobr> | <nobr>ipv4-allow-return-traffic</nobr> | ❌                                  | ✅                                  |

### IPv6

| <nobr>From&nbsp;\\&nbsp;To</nobr> | Local                          | LAN                                 | WAN                                 | Modem |
|----------------------------------:|:------------------------------:|:-----------------------------------:|:-----------------------------------:|:-----:|
| Local                             | ✅                             | <nobr>ipv6-allow-all-traffic</nobr> | <nobr>ipv6-allow-all-traffic</nobr> | ❌    |
| LAN                               | <nobr>ipv6-lan-to-local</nobr> | ✅                                  | <nobr>ipv6-allow-all-traffic</nobr> | ❌    |
| WAN                               | <nobr>ipv6-wan-to-local</nobr> | <nobr>ipv6-wan-to-lan</nobr>        | ✅                                  | ❌    |
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
/user add group=full name=username920169077 password=password767865354
```

### Default credential removal

```
/user remove admin
```

### Configuration of management via SSH

```
/ip service set ssh disabled=no port=36518
/ip ssh set ciphers=aes-gcm host-key-type=ed25519 strong-crypto=yes
```

### Host name configuration

```
/system identity set name=Router
```

### Loopback interface configuration

```
/interface set lo comment="Loopback (Local)"
```

### Ethernet interfaces configuration

```
/interface ethernet set [ find default-name=ether1 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth1 (Modem)" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:41:3E:50 mtu=1500 name=eth1-modem
/interface ethernet set [ find default-name=ether2 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth2 - Bridge - Trunk" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:D2:32:3B mtu=1500 name=eth2
/interface ethernet set [ find default-name=ether3 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth3 - Bridge - VLAN 10" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:93:38:59 mtu=1500 name=eth3
/interface ethernet set [ find default-name=ether4 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth4 - Bridge - VLAN 10" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:C2:ED:8C mtu=1500 name=eth4
/interface ethernet set [ find default-name=ether5 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth5 - Bridge - VLAN 10" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:5D:38:CB mtu=1500 name=eth5
/interface ethernet set [ find default-name=ether6 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth6 - Bridge - VLAN 10" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:CB:0D:50 mtu=1500 name=eth6
/interface ethernet set [ find default-name=ether7 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth7 - Bridge - VLAN 10" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:9F:ED:76 mtu=1500 name=eth7
/interface ethernet set [ find default-name=ether8 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth8 - Bridge - VLAN 10" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:1C:70:66 mtu=1500 name=eth8
/interface ethernet set [ find default-name=sfp-sfpplus1 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment=sfpplus1 disabled=yes l2mtu=1504 loop-protect=off mac-address=48:A9:8A:D0:2F:04 mtu=1500 name=sfpplus1
```

### Bridge interfaces configuration

```
/interface bridge settings set allow-fast-path=yes use-ip-firewall=no
/interface bridge add admin-mac=48:A9:8A:2E:20:84 arp=enabled arp-timeout=auto auto-mac=no comment="Bridge" dhcp-snooping=no ether-type=0x8100 fast-forward=yes forward-reserved-addresses=no frame-types=admit-all igmp-snooping=no ingress-filtering=yes max-learned-entries=auto mtu=1500 name=bridge protocol-mode=none pvid=1 vlan-filtering=yes
/interface bridge vlan add bridge=bridge untagged=bridge,eth2 vlan-ids=1
/interface bridge vlan add bridge=bridge tagged=bridge,eth2 untagged=eth3,eth4,eth5,eth6,eth7,eth8 vlan-ids=10
/interface vlan add arp=enabled arp-timeout=auto comment="Bridge - VLAN 1" interface=bridge loop-protect=off mtu=1500 name=bridge-vlan-1 vlan-id=1
/interface vlan add arp=enabled arp-timeout=auto comment="Bridge - VLAN 10 (LAN)" interface=bridge loop-protect=off mtu=1500 name=bridge-vlan-10-lan vlan-id=10
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth2 - Bridge - Trunk" frame-types=admit-all hw=yes ingress-filtering=yes interface=eth2 learn=yes pvid=1 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth3 - Bridge - VLAN 10" frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth3 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth4 - Bridge - VLAN 10" frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth4 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth5 - Bridge - VLAN 10" frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth5 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth6 - Bridge - VLAN 10" frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth6 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth7 - Bridge - VLAN 10" frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth7 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth8 - Bridge - VLAN 10" frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth8 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
```

### DNS configuration

```
/ip dns set allow-remote-requests=yes cache-size=20480KiB max-udp-packet-size=1444 servers=2001:4860:4860::8888,2001:4860:4860::8844
```

### IPv4 kernel configuration

```
/ip settings set accept-redirects=no accept-source-route=no allow-fast-path=yes ip-forward=yes rp-filter=no secure-redirects=yes send-redirects=yes tcp-syncookies=yes tcp-timestamps=random-offset
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
/ipv6 address add address=fd45:1e52:2abe:4c85::1/128 advertise=no auto-link-local=yes interface=lo no-dad=yes
```

### IPv4 LAN address configuration

```
/ip address add address=192.168.103.254/24 interface=bridge-vlan-10-lan network=192.168.103.0
```

### IPv4 LAN DHCP server configuration

```
/ip dhcp-server option add code=23 force=no name=ipv4-vlan-10-dhcp-server-option-23 value="'64'"
/ip dhcp-server option add code=26 force=no name=ipv4-vlan-10-dhcp-server-option-26 value="'1492'"
/ip dhcp-server option add code=28 force=no name=ipv4-vlan-10-dhcp-server-option-28 value="'192.168.103.255'"
/ip dhcp-server network add address=192.168.103.0/24 dhcp-option=ipv4-vlan-10-dhcp-server-option-23,ipv4-vlan-10-dhcp-server-option-26,ipv4-vlan-10-dhcp-server-option-28 dns-server=192.168.167.1 gateway=192.168.103.254 netmask=0
/ip pool add name=ipv4-vlan-10-dhcp-server-pool ranges=192.168.103.1-192.168.103.253
/ip dhcp-server add add-arp=yes address-pool=ipv4-vlan-10-dhcp-server-pool always-broadcast=no authoritative=yes bootp-support=none conflict-detection=yes interface=bridge-vlan-10-lan lease-time=16h name=ipv4-vlan-10-dhcp-server use-reconfigure=no
```

### IPv6 LAN SLAAC configuration

```
/ipv6 nd prefix default set autonomous=yes preferred-lifetime=16h valid-lifetime=1d
/ipv6 nd set [ find default=yes ] disabled=yes
/ipv6 nd add advertise-dns=yes advertise-mac-address=yes dns=fd45:1e52:2abe:4c85::1 hop-limit=64 interface=bridge-vlan-10-lan managed-address-configuration=no mtu=1492 other-configuration=no ra-interval=3m20s-10m ra-lifetime=2h30m ra-preference=high
/ipv6 address add address=::6e86:3d5b:dc42:add2/64 advertise=yes auto-link-local=yes from-pool=ipv6-dhcp-client-pool interface=bridge-vlan-10-lan no-dad=no
```

### IPv4 static DNS configuration

```
/ip dns static add address=192.168.167.1 name=router.internal ttl=5m type=A
/ip dns static add address=192.168.167.1 name=ipv4.router.internal ttl=5m type=A
```

### IPv6 static DNS configuration

```
/ip dns static add address=fd45:1e52:2abe:4c85::1 name=router.internal ttl=5m type=AAAA
/ip dns static add address=fd45:1e52:2abe:4c85::1 name=ipv6.router.internal ttl=5m type=AAAA
```

### IPv4 firewall rule sets

```
/ip firewall address-list add address=127.0.0.0/8 list=ipv4-invalid-wan-sources
/ip firewall address-list add address=192.168.167.1/32 list=ipv4-invalid-wan-sources
/ip firewall address-list add address=192.168.103.0/24 list=ipv4-invalid-wan-sources
/ip firewall address-list add address=192.168.237.0/30 list=ipv4-invalid-wan-sources
/ip firewall address-list add address=192.168.103.0/24 list=ipv4-lan-dhcp-sources
/ip firewall address-list add address=0.0.0.0/32 list=ipv4-lan-dhcp-sources
/ip firewall address-list add address=192.168.103.0/24 list=ipv4-lan-sources
/ip firewall filter add action=accept chain=ipv4-allow-all-traffic comment="Accept ESTABLISHED,NEW,RELATED packets" connection-state=established,related,new
/ip firewall filter add action=drop chain=ipv4-allow-all-traffic comment="Drop INVALID packets" connection-state=invalid
/ip firewall filter add action=accept chain=ipv4-allow-all-traffic comment="Accept remaining packets"
/ip firewall filter add action=accept chain=ipv4-allow-return-traffic comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-allow-return-traffic comment="Drop remaining packets"
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-lan-to-local comment="Drop INVALID packets" connection-state=invalid
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept DHCP packets" dst-port=67 protocol=udp src-address-list=ipv4-lan-dhcp-sources
/ip firewall filter add action=drop chain=ipv4-lan-to-local comment="Drop packets with spoofed source addresses" src-address-list=!ipv4-lan-sources
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept UDP DNS packets" dst-port=53 protocol=udp
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept TCP DNS packets" dst-port=53 protocol=tcp
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept management via HTTPS" dst-port=18856 protocol=tcp
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept management via WinBox" dst-port=24639 protocol=tcp
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept management via SSH" dst-port=36518 protocol=tcp
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept ICMP Echo Request packets" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=drop chain=ipv4-lan-to-local comment="Drop remaining packets"
/ip firewall filter add action=accept chain=ipv4-lan-to-modem comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-lan-to-modem comment="Drop INVALID packets" connection-state=invalid
/ip firewall filter add action=accept chain=ipv4-lan-to-modem comment="Accept management via HTTP" dst-port=45631 protocol=tcp
/ip firewall filter add action=drop chain=ipv4-lan-to-modem comment="Drop remaining packets"
/ip firewall filter add action=accept chain=ipv4-wan-to-lan comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-wan-to-lan comment="Drop INVALID packets" connection-state=invalid
/ip firewall filter add action=drop chain=ipv4-wan-to-lan comment="Drop packets with spoofed source addresses" src-address-list=ipv4-invalid-wan-sources
/ip firewall filter add action=drop chain=ipv4-wan-to-lan comment="Drop remaining packets"
/ip firewall filter add action=accept chain=ipv4-wan-to-local comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-wan-to-local comment="Drop INVALID packets" connection-state=invalid
/ip firewall filter add action=drop chain=ipv4-wan-to-local comment="Drop packets with spoofed source addresses" src-address-list=ipv4-invalid-wan-sources
/ip firewall filter add action=accept chain=ipv4-wan-to-local comment="Accept ICMP Echo Request packets" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=drop chain=ipv4-wan-to-local comment="Drop remaining packets"
```

### IPv6 firewall rule sets

```
/ipv6 firewall address-list add address=::1/128 list=ipv6-invalid-wan-sources
/ipv6 firewall address-list add address=fd45:1e52:2abe:4c85::1/128 list=ipv6-invalid-wan-sources
/ipv6 firewall address-list add address=fe80::/64 list=ipv6-link-local-sources
/ipv6 firewall address-list add address=fe80::/64 list=ipv6-lan-slaac-sources
/ipv6 firewall address-list add address=::/128 list=ipv6-lan-slaac-sources
/ipv6 firewall address-list add address=fe80::/64 list=ipv6-lan-sources
/ipv6 firewall filter add action=accept chain=ipv6-allow-all-traffic comment="Accept ESTABLISHED,NEW,RELATED packets" connection-state=established,related,new
/ipv6 firewall filter add action=drop chain=ipv6-allow-all-traffic comment="Drop INVALID packets" connection-state=invalid
/ipv6 firewall filter add action=accept chain=ipv6-allow-all-traffic comment="Accept remaining packets"
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-lan-to-local comment="Drop INVALID packets" connection-state=invalid
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept ICMPv6 Router Solicitation packets" icmp-options=133:0 protocol=icmpv6 src-address-list=ipv6-lan-slaac-sources
/ipv6 firewall filter add action=drop chain=ipv6-lan-to-local comment="Drop packets with spoofed source addresses" src-address-list=!ipv6-lan-sources
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept UDP DNS packets" dst-port=53 protocol=udp
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept TCP DNS packets" dst-port=53 protocol=tcp
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept management via HTTPS" dst-port=18856 protocol=tcp
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept management via WinBox" dst-port=24639 protocol=tcp
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept management via SSH" dst-port=36518 protocol=tcp
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept ICMPv6 Echo Request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept ICMPv6 Neighbor Solicitation packets" icmp-options=135:0 protocol=icmpv6
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept ICMPv6 Neighbor Advertisement packets" icmp-options=136:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-lan-to-local comment="Drop remaining packets"
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-lan comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-wan-to-lan comment="Drop INVALID packets" connection-state=invalid
/ipv6 firewall filter add action=drop chain=ipv6-wan-to-lan comment="Drop packets with spoofed source addresses" src-address-list=ipv6-invalid-wan-sources
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-lan comment="Accept ICMPv6 Echo Request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-wan-to-lan comment="Drop remaining packets"
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-local comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-wan-to-local comment="Drop INVALID packets" connection-state=invalid
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-local comment="Accept DHCPv6 packets" dst-port=546 protocol=udp src-address-list=ipv6-link-local-sources src-port=547
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-local comment="Accept ICMPv6 Router Advertisement packets" icmp-options=134:0 protocol=icmpv6 src-address-list=ipv6-link-local-sources
/ipv6 firewall filter add action=drop chain=ipv6-wan-to-local comment="Drop packets with spoofed source addresses" src-address-list=ipv6-invalid-wan-sources
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-local comment="Accept ICMPv6 Echo Request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-local comment="Accept ICMPv6 Neighbor Solicitation packets" icmp-options=135:0 protocol=icmpv6
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-local comment="Accept ICMPv6 Neighbor Advertisement packets" icmp-options=136:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-wan-to-local comment="Drop remaining packets"
```

### IPv4 firewall zone policies for LAN, Local, Modem and WAN

```
/interface list add comment="LAN" name=lan-interface
/interface list add comment="Local" name=local-interface
/interface list add comment="Modem" name=modem-interface
/interface list add comment="WAN" name=wan-interface
/interface list member add interface=bridge-vlan-10-lan list=lan-interface
/interface list member add interface=lo list=local-interface
/interface list member add interface=eth1-modem list=modem-interface
/ip firewall filter add action=jump chain=ipv4-lan-zone comment="Check packets going from WAN to LAN" in-interface-list=wan-interface jump-target=ipv4-wan-to-lan
/ip firewall filter add action=jump chain=ipv4-lan-zone comment="Check packets going from Modem to LAN" in-interface-list=modem-interface jump-target=ipv4-allow-return-traffic
/ip firewall filter add action=accept chain=ipv4-lan-zone comment="Accept packets going from LAN to LAN" in-interface-list=lan-interface
/ip firewall filter add action=drop chain=ipv4-lan-zone comment="Drop remaining packets going to LAN"
/ip firewall filter add action=jump chain=ipv4-wan-zone comment="Check packets going from LAN to WAN" in-interface-list=lan-interface jump-target=ipv4-allow-all-traffic
/ip firewall filter add action=accept chain=ipv4-wan-zone comment="Accept packets going from WAN to WAN" in-interface-list=wan-interface
/ip firewall filter add action=drop chain=ipv4-wan-zone comment="Drop remaining packets going to WAN"
/ip firewall filter add action=jump chain=ipv4-modem-zone comment="Check packets going from LAN to Modem" in-interface-list=lan-interface jump-target=ipv4-lan-to-modem
/ip firewall filter add action=accept chain=ipv4-modem-zone comment="Accept packets going from Modem to Modem" in-interface-list=modem-interface
/ip firewall filter add action=drop chain=ipv4-modem-zone comment="Drop remaining packets going to Modem"
/ip firewall filter add action=jump chain=ipv4-local-input-zone comment="Check packets going from WAN to Local" in-interface-list=wan-interface jump-target=ipv4-wan-to-local
/ip firewall filter add action=jump chain=ipv4-local-input-zone comment="Check packets going from LAN to Local" in-interface-list=lan-interface jump-target=ipv4-lan-to-local
/ip firewall filter add action=jump chain=ipv4-local-input-zone comment="Check packets going from Modem to Local" in-interface-list=modem-interface jump-target=ipv4-allow-return-traffic
/ip firewall filter add action=accept chain=ipv4-local-input-zone comment="Accept packets going from Local to Local" in-interface-list=local-interface
/ip firewall filter add action=drop chain=ipv4-local-input-zone comment="Drop remaining packets going to Local"
/ip firewall filter add action=jump chain=ipv4-local-output-zone comment="Check packets going from Local to WAN" jump-target=ipv4-allow-all-traffic out-interface-list=wan-interface
/ip firewall filter add action=jump chain=ipv4-local-output-zone comment="Check packets going from Local to LAN" jump-target=ipv4-allow-all-traffic out-interface-list=lan-interface
/ip firewall filter add action=jump chain=ipv4-local-output-zone comment="Check packets going from Local to Modem" jump-target=ipv4-allow-all-traffic out-interface-list=modem-interface
/ip firewall filter add action=accept chain=ipv4-local-output-zone comment="Accept packets going from Local to Local" out-interface-list=local-interface
/ip firewall filter add action=drop chain=ipv4-local-output-zone comment="Drop remaining packets coming from Local"
/ip firewall filter add action=jump chain=forward comment="LAN zone" jump-target=ipv4-lan-zone out-interface-list=lan-interface
/ip firewall filter add action=jump chain=forward comment="WAN zone" jump-target=ipv4-wan-zone out-interface-list=wan-interface
/ip firewall filter add action=jump chain=forward comment="Modem zone" jump-target=ipv4-modem-zone out-interface-list=modem-interface
/ip firewall filter add action=jump chain=input comment="Local zone (input)" jump-target=ipv4-local-input-zone
/ip firewall filter add action=jump chain=output comment="Local zone (output)" jump-target=ipv4-local-output-zone
```

### IPv6 firewall zone policies for LAN, Local, Modem and WAN

```
/ipv6 firewall filter add action=jump chain=ipv6-lan-zone comment="Check packets going from WAN to LAN" in-interface-list=wan-interface jump-target=ipv6-wan-to-lan
/ipv6 firewall filter add action=accept chain=ipv6-lan-zone comment="Accept packets going from LAN to LAN" in-interface-list=lan-interface
/ipv6 firewall filter add action=drop chain=ipv6-lan-zone comment="Drop remaining packets going to LAN"
/ipv6 firewall filter add action=jump chain=ipv6-wan-zone comment="Check packets going from LAN to WAN" in-interface-list=lan-interface jump-target=ipv6-allow-all-traffic
/ipv6 firewall filter add action=accept chain=ipv6-wan-zone comment="Accept packets going from WAN to WAN" in-interface-list=wan-interface
/ipv6 firewall filter add action=drop chain=ipv6-wan-zone comment="Drop remaining packets going to WAN"
/ipv6 firewall filter add action=accept chain=ipv6-modem-zone comment="Accept packets going from Modem to Modem" in-interface-list=modem-interface
/ipv6 firewall filter add action=drop chain=ipv6-modem-zone comment="Drop remaining packets going to Modem"
/ipv6 firewall filter add action=jump chain=ipv6-local-input-zone comment="Check packets going from WAN to Local" in-interface-list=wan-interface jump-target=ipv6-wan-to-local
/ipv6 firewall filter add action=jump chain=ipv6-local-input-zone comment="Check packets going from LAN to Local" in-interface-list=lan-interface jump-target=ipv6-lan-to-local
/ipv6 firewall filter add action=accept chain=ipv6-local-input-zone comment="Accept packets going from Local to Local" in-interface-list=local-interface
/ipv6 firewall filter add action=drop chain=ipv6-local-input-zone comment="Drop remaining packets going to Local"
/ipv6 firewall filter add action=jump chain=ipv6-local-output-zone comment="Check packets going from Local to WAN" jump-target=ipv6-allow-all-traffic out-interface-list=wan-interface
/ipv6 firewall filter add action=jump chain=ipv6-local-output-zone comment="Check packets going from Local to LAN" jump-target=ipv6-allow-all-traffic out-interface-list=lan-interface
/ipv6 firewall filter add action=accept chain=ipv6-local-output-zone comment="Accept packets going from Local to Local" out-interface-list=local-interface
/ipv6 firewall filter add action=drop chain=ipv6-local-output-zone comment="Drop remaining packets coming from Local"
/ipv6 firewall filter add action=jump chain=forward comment="LAN zone" jump-target=ipv6-lan-zone out-interface-list=lan-interface
/ipv6 firewall filter add action=jump chain=forward comment="WAN zone" jump-target=ipv6-wan-zone out-interface-list=wan-interface
/ipv6 firewall filter add action=jump chain=forward comment="Modem zone" jump-target=ipv6-modem-zone out-interface-list=modem-interface
/ipv6 firewall filter add action=jump chain=input comment="Local zone (input)" jump-target=ipv6-local-input-zone
/ipv6 firewall filter add action=jump chain=output comment="Local zone (output)" jump-target=ipv6-local-output-zone
```

### IPv4 address configuration for modem access

```
/ip address add address=192.168.237.2/30 interface=eth1-modem network=192.168.237.0
```

### WAN PPPoE client configuration

```
/ppp profile add change-tcp-mss=no interface-list=wan-interface name=pppoe-client-profile use-compression=no use-encryption=no use-ipv6=yes use-mpls=no
/interface vlan add arp=enabled arp-timeout=auto comment="eth1 - VLAN 600" interface=eth1-modem loop-protect=off mtu=1500 name=eth1-vlan-600 vlan-id=600
/interface pppoe-client add add-default-route=yes allow=chap,mschap1,mschap2 comment="eth1 - VLAN 600 - PPPoE client (WAN)" default-route-distance=2 disabled=no interface=eth1-vlan-600 max-mru=1492 max-mtu=1492 name=eth1-vlan-600-pppoe-client-wan password=cliente profile=pppoe-client-profile use-peer-dns=no user=cliente@cliente
```

### IPv6 WAN DHCPv6 client configuration

```
/ipv6 dhcp-client add add-default-route=yes allow-reconfigure=no check-gateway=ping custom-duid=0003000148a98a413e50 default-route-distance=2 default-route-tables=main:3 interface=eth1-vlan-600-pppoe-client-wan pool-name=ipv6-dhcp-client-pool pool-prefix-length=64 prefix-address-lists=ipv6-invalid-wan-sources,ipv6-lan-slaac-sources,ipv6-lan-sources prefix-hint=::/64 rapid-commit=yes request=prefix use-interface-duid=no use-peer-dns=no validate-server-duid=yes
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

### IPv4 DNAT to redirect all DNS queries

```
/ip firewall address-list add address=192.168.167.1/32 list=ipv4-dns-address
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ipv4-dns-address dst-port=53 in-interface-list=lan-interface protocol=udp
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ipv4-dns-address dst-port=53 in-interface-list=lan-interface protocol=tcp
```

### IPv6 DNAT to redirect all DNS queries

```
/ipv6 firewall address-list add address=fd45:1e52:2abe:4c85::1/128 list=ipv6-dns-address
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-address dst-port=53 in-interface-list=lan-interface protocol=udp
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-address dst-port=53 in-interface-list=lan-interface protocol=tcp
```

### IPv4 SNAT of private addresses for internet access

```
/ip firewall address-list add address=192.168.103.0/24 list=ipv4-wan-nat-sources
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interface protocol=tcp src-address-list=ipv4-wan-nat-sources to-ports=8081-65535
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interface protocol=udp src-address-list=ipv4-wan-nat-sources to-ports=8081-65535
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interface src-address-list=ipv4-wan-nat-sources
```

### IPv4 SNAT to bypass ISP blocking of incoming UDP packets on port 123

```
/ip firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interface protocol=udp src-port=123 to-ports=8081-65535
```

### IPv6 SNAT to bypass ISP blocking of incoming UDP packets on port 123

```
/ipv6 firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interface protocol=udp src-port=123 to-ports=8081-65535
```

### IPv4 SNAT of private addresses for modem access

```
/ip firewall address-list add address=192.168.103.0/24 list=ipv4-modem-nat-sources
/ip firewall address-list add address=192.168.237.1/32 list=ipv4-modem-address
/ip firewall nat add action=src-nat chain=srcnat dst-address-list=ipv4-modem-address src-address-list=ipv4-modem-nat-sources to-addresses=192.168.237.2
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

### Disabling of unused services

```
/ip smb set enabled=no
/tool bandwidth-server set enabled=no
/tool romon set enabled=no
```

### Disabling of discovery

```
/ip neighbor discovery-settings set discover-interface-list=none
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
/ip service set www disabled=yes port=45631
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
/tool graphing interface add interface=eth1-modem store-on-disk=no
/tool graphing interface add interface=eth1-vlan-600-pppoe-client-wan store-on-disk=no
/tool graphing interface add interface=bridge-vlan-10-lan store-on-disk=no
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
/queue interface set eth1-modem queue=only-hardware-queue
/queue interface set eth2 queue=only-hardware-queue
/queue interface set eth3 queue=only-hardware-queue
/queue interface set eth4 queue=only-hardware-queue
/queue interface set eth5 queue=only-hardware-queue
/queue interface set eth6 queue=only-hardware-queue
/queue interface set eth7 queue=only-hardware-queue
/queue interface set eth8 queue=only-hardware-queue
/queue interface set sfpplus1 queue=only-hardware-queue
```

### Upload of additional files

```
$ scp -P 36518 ../keys_and_certificates/certificate_authority.crt ../keys_and_certificates/management_https.crt ../keys_and_certificates/management_https.key username920169077@192.168.103.254:/
```

### Configuration of management via HTTPS

```
/certificate import file-name=certificate_authority.crt name=certificate_authority trusted=yes
/certificate import file-name=management_https.crt name=management_https trusted=yes
/certificate import file-name=management_https.key name=management_https trusted=yes
/ip service set www-ssl certificate=management_https disabled=no port=18856 tls-version=only-1.2
```

## Final configuration

```
/interface bridge add admin-mac=48:A9:8A:2E:20:84 arp=enabled arp-timeout=auto auto-mac=no comment="Bridge" dhcp-snooping=no ether-type=0x8100 fast-forward=yes forward-reserved-addresses=no frame-types=admit-all igmp-snooping=no ingress-filtering=yes max-learned-entries=auto mtu=1500 name=bridge protocol-mode=none pvid=1 vlan-filtering=yes
/interface ethernet set [ find default-name=ether1 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth1 (Modem)" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:41:3E:50 mtu=1500 name=eth1-modem
/interface ethernet set [ find default-name=ether2 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth2 - Bridge - Trunk" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:D2:32:3B mtu=1500 name=eth2
/interface ethernet set [ find default-name=ether3 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth3 - Bridge - VLAN 10" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:93:38:59 mtu=1500 name=eth3
/interface ethernet set [ find default-name=ether4 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth4 - Bridge - VLAN 10" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:C2:ED:8C mtu=1500 name=eth4
/interface ethernet set [ find default-name=ether5 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth5 - Bridge - VLAN 10" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:5D:38:CB mtu=1500 name=eth5
/interface ethernet set [ find default-name=ether6 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth6 - Bridge - VLAN 10" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:CB:0D:50 mtu=1500 name=eth6
/interface ethernet set [ find default-name=ether7 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth7 - Bridge - VLAN 10" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:9F:ED:76 mtu=1500 name=eth7
/interface ethernet set [ find default-name=ether8 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment="eth8 - Bridge - VLAN 10" disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:1C:70:66 mtu=1500 name=eth8
/interface ethernet set [ find default-name=sfp-sfpplus1 ] arp=enabled arp-timeout=auto auto-negotiation=yes comment=sfpplus1 disabled=yes l2mtu=1504 loop-protect=off mac-address=48:A9:8A:D0:2F:04 mtu=1500 name=sfpplus1
/interface vlan add arp=enabled arp-timeout=auto comment="Bridge - VLAN 1" interface=bridge loop-protect=off mtu=1500 name=bridge-vlan-1 vlan-id=1
/interface vlan add arp=enabled arp-timeout=auto comment="Bridge - VLAN 10 (LAN)" interface=bridge loop-protect=off mtu=1500 name=bridge-vlan-10-lan vlan-id=10
/interface vlan add arp=enabled arp-timeout=auto comment="eth1 - VLAN 600" interface=eth1-modem loop-protect=off mtu=1500 name=eth1-vlan-600 vlan-id=600
/interface list add comment="LAN" name=lan-interface
/interface list add comment="Local" name=local-interface
/interface list add comment="Modem" name=modem-interface
/interface list add comment="WAN" name=wan-interface
/ip dhcp-server option add code=23 force=no name=ipv4-vlan-10-dhcp-server-option-23 value="'64'"
/ip dhcp-server option add code=26 force=no name=ipv4-vlan-10-dhcp-server-option-26 value="'1492'"
/ip dhcp-server option add code=28 force=no name=ipv4-vlan-10-dhcp-server-option-28 value="'192.168.103.255'"
/ip pool add name=ipv4-vlan-10-dhcp-server-pool ranges=192.168.103.1-192.168.103.253
/ip dhcp-server add add-arp=yes address-pool=ipv4-vlan-10-dhcp-server-pool always-broadcast=no authoritative=yes bootp-support=none conflict-detection=yes interface=bridge-vlan-10-lan lease-time=16h name=ipv4-vlan-10-dhcp-server use-reconfigure=no
/ppp profile add change-tcp-mss=no interface-list=wan-interface name=pppoe-client-profile use-compression=no use-encryption=no use-ipv6=yes use-mpls=no
/interface pppoe-client add add-default-route=yes allow=chap,mschap1,mschap2 comment="eth1 - VLAN 600 - PPPoE client (WAN)" default-route-distance=2 disabled=no interface=eth1-vlan-600 max-mru=1492 max-mtu=1492 name=eth1-vlan-600-pppoe-client-wan password=cliente profile=pppoe-client-profile use-peer-dns=no user=cliente@cliente
/queue interface set eth1-modem queue=only-hardware-queue
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
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth2 - Bridge - Trunk" frame-types=admit-all hw=yes ingress-filtering=yes interface=eth2 learn=yes pvid=1 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth3 - Bridge - VLAN 10" frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth3 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth4 - Bridge - VLAN 10" frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth4 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth5 - Bridge - VLAN 10" frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth5 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth6 - Bridge - VLAN 10" frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth6 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth7 - Bridge - VLAN 10" frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth7 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge port add bridge=bridge broadcast-flood=yes comment="eth8 - Bridge - VLAN 10" frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=eth8 learn=yes pvid=10 unknown-multicast-flood=yes unknown-unicast-flood=yes
/interface bridge settings set allow-fast-path=yes use-ip-firewall=no
/ip firewall connection tracking set enabled=yes generic-timeout=10m icmp-timeout=30s loose-tcp-tracking=no tcp-close-timeout=10s tcp-close-wait-timeout=1m tcp-established-timeout=5d tcp-fin-wait-timeout=2m tcp-last-ack-timeout=30s tcp-max-retrans-timeout=5m tcp-syn-received-timeout=1m tcp-syn-sent-timeout=2m tcp-time-wait-timeout=2m tcp-unacked-timeout=5m udp-stream-timeout=3m udp-timeout=30s
/ip neighbor discovery-settings set discover-interface-list=none
/ip settings set accept-redirects=no accept-source-route=no allow-fast-path=yes ip-forward=yes rp-filter=no secure-redirects=yes send-redirects=yes tcp-syncookies=yes tcp-timestamps=random-offset
/ipv6 settings set accept-redirects=no accept-router-advertisements=yes allow-fast-path=yes disable-ipv6=no disable-link-local-address=no forward=yes
/interface bridge vlan add bridge=bridge untagged=bridge,eth2 vlan-ids=1
/interface bridge vlan add bridge=bridge tagged=bridge,eth2 untagged=eth3,eth4,eth5,eth6,eth7,eth8 vlan-ids=10
/interface list member add interface=bridge-vlan-10-lan list=lan-interface
/interface list member add interface=lo list=local-interface
/interface list member add interface=eth1-modem list=modem-interface
/ip address add address=192.168.167.1/32 interface=lo network=192.168.167.1
/ip address add address=192.168.103.254/24 interface=bridge-vlan-10-lan network=192.168.103.0
/ip address add address=192.168.237.2/30 interface=eth1-modem network=192.168.237.0
/ip cloud set back-to-home-vpn=revoked-and-disabled ddns-enabled=auto update-time=no
/ip dhcp-server network add address=192.168.103.0/24 dhcp-option=ipv4-vlan-10-dhcp-server-option-23,ipv4-vlan-10-dhcp-server-option-26,ipv4-vlan-10-dhcp-server-option-28 dns-server=192.168.167.1 gateway=192.168.103.254 netmask=0
/ip dns set allow-remote-requests=yes cache-size=20480KiB max-udp-packet-size=1444 servers=2001:4860:4860::8888,2001:4860:4860::8844
/ip dns static add address=192.168.167.1 name=router.internal ttl=5m type=A
/ip dns static add address=192.168.167.1 name=ipv4.router.internal ttl=5m type=A
/ip dns static add address=fd45:1e52:2abe:4c85::1 name=router.internal ttl=5m type=AAAA
/ip dns static add address=fd45:1e52:2abe:4c85::1 name=ipv6.router.internal ttl=5m type=AAAA
/ip firewall address-list add address=127.0.0.0/8 list=ipv4-invalid-wan-sources
/ip firewall address-list add address=192.168.167.1/32 list=ipv4-invalid-wan-sources
/ip firewall address-list add address=192.168.103.0/24 list=ipv4-invalid-wan-sources
/ip firewall address-list add address=192.168.237.0/30 list=ipv4-invalid-wan-sources
/ip firewall address-list add address=192.168.103.0/24 list=ipv4-lan-dhcp-sources
/ip firewall address-list add address=0.0.0.0/32 list=ipv4-lan-dhcp-sources
/ip firewall address-list add address=192.168.103.0/24 list=ipv4-lan-sources
/ip firewall address-list add address=192.168.167.1/32 list=ipv4-dns-address
/ip firewall address-list add address=192.168.103.0/24 list=ipv4-wan-nat-sources
/ip firewall address-list add address=192.168.103.0/24 list=ipv4-modem-nat-sources
/ip firewall address-list add address=192.168.237.1/32 list=ipv4-modem-address
/ip firewall filter add action=accept chain=ipv4-allow-all-traffic comment="Accept ESTABLISHED,NEW,RELATED packets" connection-state=established,related,new
/ip firewall filter add action=drop chain=ipv4-allow-all-traffic comment="Drop INVALID packets" connection-state=invalid
/ip firewall filter add action=accept chain=ipv4-allow-all-traffic comment="Accept remaining packets"
/ip firewall filter add action=accept chain=ipv4-allow-return-traffic comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-allow-return-traffic comment="Drop remaining packets"
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-lan-to-local comment="Drop INVALID packets" connection-state=invalid
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept DHCP packets" dst-port=67 protocol=udp src-address-list=ipv4-lan-dhcp-sources
/ip firewall filter add action=drop chain=ipv4-lan-to-local comment="Drop packets with spoofed source addresses" src-address-list=!ipv4-lan-sources
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept UDP DNS packets" dst-port=53 protocol=udp
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept TCP DNS packets" dst-port=53 protocol=tcp
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept management via HTTPS" dst-port=18856 protocol=tcp
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept management via WinBox" dst-port=24639 protocol=tcp
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept management via SSH" dst-port=36518 protocol=tcp
/ip firewall filter add action=accept chain=ipv4-lan-to-local comment="Accept ICMP Echo Request packets" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=drop chain=ipv4-lan-to-local comment="Drop remaining packets"
/ip firewall filter add action=accept chain=ipv4-lan-to-modem comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-lan-to-modem comment="Drop INVALID packets" connection-state=invalid
/ip firewall filter add action=accept chain=ipv4-lan-to-modem comment="Accept management via HTTP" dst-port=45631 protocol=tcp
/ip firewall filter add action=drop chain=ipv4-lan-to-modem comment="Drop remaining packets"
/ip firewall filter add action=accept chain=ipv4-wan-to-lan comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-wan-to-lan comment="Drop INVALID packets" connection-state=invalid
/ip firewall filter add action=drop chain=ipv4-wan-to-lan comment="Drop packets with spoofed source addresses" src-address-list=ipv4-invalid-wan-sources
/ip firewall filter add action=drop chain=ipv4-wan-to-lan comment="Drop remaining packets"
/ip firewall filter add action=accept chain=ipv4-wan-to-local comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-wan-to-local comment="Drop INVALID packets" connection-state=invalid
/ip firewall filter add action=drop chain=ipv4-wan-to-local comment="Drop packets with spoofed source addresses" src-address-list=ipv4-invalid-wan-sources
/ip firewall filter add action=accept chain=ipv4-wan-to-local comment="Accept ICMP Echo Request packets" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=drop chain=ipv4-wan-to-local comment="Drop remaining packets"
/ip firewall filter add action=jump chain=ipv4-lan-zone comment="Check packets going from WAN to LAN" in-interface-list=wan-interface jump-target=ipv4-wan-to-lan
/ip firewall filter add action=jump chain=ipv4-lan-zone comment="Check packets going from Modem to LAN" in-interface-list=modem-interface jump-target=ipv4-allow-return-traffic
/ip firewall filter add action=accept chain=ipv4-lan-zone comment="Accept packets going from LAN to LAN" in-interface-list=lan-interface
/ip firewall filter add action=drop chain=ipv4-lan-zone comment="Drop remaining packets going to LAN"
/ip firewall filter add action=jump chain=ipv4-wan-zone comment="Check packets going from LAN to WAN" in-interface-list=lan-interface jump-target=ipv4-allow-all-traffic
/ip firewall filter add action=accept chain=ipv4-wan-zone comment="Accept packets going from WAN to WAN" in-interface-list=wan-interface
/ip firewall filter add action=drop chain=ipv4-wan-zone comment="Drop remaining packets going to WAN"
/ip firewall filter add action=jump chain=ipv4-modem-zone comment="Check packets going from LAN to Modem" in-interface-list=lan-interface jump-target=ipv4-lan-to-modem
/ip firewall filter add action=accept chain=ipv4-modem-zone comment="Accept packets going from Modem to Modem" in-interface-list=modem-interface
/ip firewall filter add action=drop chain=ipv4-modem-zone comment="Drop remaining packets going to Modem"
/ip firewall filter add action=jump chain=ipv4-local-input-zone comment="Check packets going from WAN to Local" in-interface-list=wan-interface jump-target=ipv4-wan-to-local
/ip firewall filter add action=jump chain=ipv4-local-input-zone comment="Check packets going from LAN to Local" in-interface-list=lan-interface jump-target=ipv4-lan-to-local
/ip firewall filter add action=jump chain=ipv4-local-input-zone comment="Check packets going from Modem to Local" in-interface-list=modem-interface jump-target=ipv4-allow-return-traffic
/ip firewall filter add action=accept chain=ipv4-local-input-zone comment="Accept packets going from Local to Local" in-interface-list=local-interface
/ip firewall filter add action=drop chain=ipv4-local-input-zone comment="Drop remaining packets going to Local"
/ip firewall filter add action=jump chain=ipv4-local-output-zone comment="Check packets going from Local to WAN" jump-target=ipv4-allow-all-traffic out-interface-list=wan-interface
/ip firewall filter add action=jump chain=ipv4-local-output-zone comment="Check packets going from Local to LAN" jump-target=ipv4-allow-all-traffic out-interface-list=lan-interface
/ip firewall filter add action=jump chain=ipv4-local-output-zone comment="Check packets going from Local to Modem" jump-target=ipv4-allow-all-traffic out-interface-list=modem-interface
/ip firewall filter add action=accept chain=ipv4-local-output-zone comment="Accept packets going from Local to Local" out-interface-list=local-interface
/ip firewall filter add action=drop chain=ipv4-local-output-zone comment="Drop remaining packets coming from Local"
/ip firewall filter add action=jump chain=forward comment="LAN zone" jump-target=ipv4-lan-zone out-interface-list=lan-interface
/ip firewall filter add action=jump chain=forward comment="WAN zone" jump-target=ipv4-wan-zone out-interface-list=wan-interface
/ip firewall filter add action=jump chain=forward comment="Modem zone" jump-target=ipv4-modem-zone out-interface-list=modem-interface
/ip firewall filter add action=jump chain=input comment="Local zone (input)" jump-target=ipv4-local-input-zone
/ip firewall filter add action=jump chain=output comment="Local zone (output)" jump-target=ipv4-local-output-zone
/ip firewall mangle add action=change-mss chain=forward in-interface-list=wan-interface new-mss=1452 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1453-65535
/ip firewall mangle add action=change-mss chain=postrouting new-mss=1452 out-interface-list=wan-interface passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1453-65535
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ipv4-dns-address dst-port=53 in-interface-list=lan-interface protocol=udp
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ipv4-dns-address dst-port=53 in-interface-list=lan-interface protocol=tcp
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interface protocol=tcp src-address-list=ipv4-wan-nat-sources to-ports=8081-65535
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interface protocol=udp src-address-list=ipv4-wan-nat-sources to-ports=8081-65535
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interface src-address-list=ipv4-wan-nat-sources
/ip firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interface protocol=udp src-port=123 to-ports=8081-65535
/ip firewall nat add action=src-nat chain=srcnat dst-address-list=ipv4-modem-address src-address-list=ipv4-modem-nat-sources to-addresses=192.168.237.2
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
/ip service set www disabled=yes port=45631
/ip ssh set ciphers=aes-gcm host-key-type=ed25519 strong-crypto=yes
/ipv6 address add address=fd45:1e52:2abe:4c85::1/128 advertise=no auto-link-local=yes interface=lo no-dad=yes
/ipv6 address add address=::6e86:3d5b:dc42:add2/64 advertise=yes auto-link-local=yes from-pool=ipv6-dhcp-client-pool interface=bridge-vlan-10-lan no-dad=no
/ipv6 dhcp-client add add-default-route=yes allow-reconfigure=no check-gateway=ping custom-duid=0003000148a98a413e50 default-route-distance=2 default-route-tables=main:3 interface=eth1-vlan-600-pppoe-client-wan pool-name=ipv6-dhcp-client-pool pool-prefix-length=64 prefix-address-lists=ipv6-invalid-wan-sources,ipv6-lan-slaac-sources,ipv6-lan-sources prefix-hint=::/64 rapid-commit=yes request=prefix use-interface-duid=no use-peer-dns=no validate-server-duid=yes
/ipv6 firewall address-list add address=::1/128 list=ipv6-invalid-wan-sources
/ipv6 firewall address-list add address=fd45:1e52:2abe:4c85::1/128 list=ipv6-invalid-wan-sources
/ipv6 firewall address-list add address=fe80::/64 list=ipv6-link-local-sources
/ipv6 firewall address-list add address=fe80::/64 list=ipv6-lan-slaac-sources
/ipv6 firewall address-list add address=::/128 list=ipv6-lan-slaac-sources
/ipv6 firewall address-list add address=fe80::/64 list=ipv6-lan-sources
/ipv6 firewall address-list add address=fd45:1e52:2abe:4c85::1/128 list=ipv6-dns-address
/ipv6 firewall filter add action=accept chain=ipv6-allow-all-traffic comment="Accept ESTABLISHED,NEW,RELATED packets" connection-state=established,related,new
/ipv6 firewall filter add action=drop chain=ipv6-allow-all-traffic comment="Drop INVALID packets" connection-state=invalid
/ipv6 firewall filter add action=accept chain=ipv6-allow-all-traffic comment="Accept remaining packets"
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-lan-to-local comment="Drop INVALID packets" connection-state=invalid
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept ICMPv6 Router Solicitation packets" icmp-options=133:0 protocol=icmpv6 src-address-list=ipv6-lan-slaac-sources
/ipv6 firewall filter add action=drop chain=ipv6-lan-to-local comment="Drop packets with spoofed source addresses" src-address-list=!ipv6-lan-sources
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept UDP DNS packets" dst-port=53 protocol=udp
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept TCP DNS packets" dst-port=53 protocol=tcp
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept management via HTTPS" dst-port=18856 protocol=tcp
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept management via WinBox" dst-port=24639 protocol=tcp
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept management via SSH" dst-port=36518 protocol=tcp
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept ICMPv6 Echo Request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept ICMPv6 Neighbor Solicitation packets" icmp-options=135:0 protocol=icmpv6
/ipv6 firewall filter add action=accept chain=ipv6-lan-to-local comment="Accept ICMPv6 Neighbor Advertisement packets" icmp-options=136:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-lan-to-local comment="Drop remaining packets"
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-lan comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-wan-to-lan comment="Drop INVALID packets" connection-state=invalid
/ipv6 firewall filter add action=drop chain=ipv6-wan-to-lan comment="Drop packets with spoofed source addresses" src-address-list=ipv6-invalid-wan-sources
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-lan comment="Accept ICMPv6 Echo Request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-wan-to-lan comment="Drop remaining packets"
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-local comment="Accept ESTABLISHED,RELATED packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-wan-to-local comment="Drop INVALID packets" connection-state=invalid
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-local comment="Accept DHCPv6 packets" dst-port=546 protocol=udp src-address-list=ipv6-link-local-sources src-port=547
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-local comment="Accept ICMPv6 Router Advertisement packets" icmp-options=134:0 protocol=icmpv6 src-address-list=ipv6-link-local-sources
/ipv6 firewall filter add action=drop chain=ipv6-wan-to-local comment="Drop packets with spoofed source addresses" src-address-list=ipv6-invalid-wan-sources
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-local comment="Accept ICMPv6 Echo Request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-local comment="Accept ICMPv6 Neighbor Solicitation packets" icmp-options=135:0 protocol=icmpv6
/ipv6 firewall filter add action=accept chain=ipv6-wan-to-local comment="Accept ICMPv6 Neighbor Advertisement packets" icmp-options=136:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-wan-to-local comment="Drop remaining packets"
/ipv6 firewall filter add action=jump chain=ipv6-lan-zone comment="Check packets going from WAN to LAN" in-interface-list=wan-interface jump-target=ipv6-wan-to-lan
/ipv6 firewall filter add action=accept chain=ipv6-lan-zone comment="Accept packets going from LAN to LAN" in-interface-list=lan-interface
/ipv6 firewall filter add action=drop chain=ipv6-lan-zone comment="Drop remaining packets going to LAN"
/ipv6 firewall filter add action=jump chain=ipv6-wan-zone comment="Check packets going from LAN to WAN" in-interface-list=lan-interface jump-target=ipv6-allow-all-traffic
/ipv6 firewall filter add action=accept chain=ipv6-wan-zone comment="Accept packets going from WAN to WAN" in-interface-list=wan-interface
/ipv6 firewall filter add action=drop chain=ipv6-wan-zone comment="Drop remaining packets going to WAN"
/ipv6 firewall filter add action=accept chain=ipv6-modem-zone comment="Accept packets going from Modem to Modem" in-interface-list=modem-interface
/ipv6 firewall filter add action=drop chain=ipv6-modem-zone comment="Drop remaining packets going to Modem"
/ipv6 firewall filter add action=jump chain=ipv6-local-input-zone comment="Check packets going from WAN to Local" in-interface-list=wan-interface jump-target=ipv6-wan-to-local
/ipv6 firewall filter add action=jump chain=ipv6-local-input-zone comment="Check packets going from LAN to Local" in-interface-list=lan-interface jump-target=ipv6-lan-to-local
/ipv6 firewall filter add action=accept chain=ipv6-local-input-zone comment="Accept packets going from Local to Local" in-interface-list=local-interface
/ipv6 firewall filter add action=drop chain=ipv6-local-input-zone comment="Drop remaining packets going to Local"
/ipv6 firewall filter add action=jump chain=ipv6-local-output-zone comment="Check packets going from Local to WAN" jump-target=ipv6-allow-all-traffic out-interface-list=wan-interface
/ipv6 firewall filter add action=jump chain=ipv6-local-output-zone comment="Check packets going from Local to LAN" jump-target=ipv6-allow-all-traffic out-interface-list=lan-interface
/ipv6 firewall filter add action=accept chain=ipv6-local-output-zone comment="Accept packets going from Local to Local" out-interface-list=local-interface
/ipv6 firewall filter add action=drop chain=ipv6-local-output-zone comment="Drop remaining packets coming from Local"
/ipv6 firewall filter add action=jump chain=forward comment="LAN zone" jump-target=ipv6-lan-zone out-interface-list=lan-interface
/ipv6 firewall filter add action=jump chain=forward comment="WAN zone" jump-target=ipv6-wan-zone out-interface-list=wan-interface
/ipv6 firewall filter add action=jump chain=forward comment="Modem zone" jump-target=ipv6-modem-zone out-interface-list=modem-interface
/ipv6 firewall filter add action=jump chain=input comment="Local zone (input)" jump-target=ipv6-local-input-zone
/ipv6 firewall filter add action=jump chain=output comment="Local zone (output)" jump-target=ipv6-local-output-zone
/ipv6 firewall mangle add action=change-mss chain=forward in-interface-list=wan-interface new-mss=1432 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1433-65535
/ipv6 firewall mangle add action=change-mss chain=postrouting new-mss=1432 out-interface-list=wan-interface passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1433-65535
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-address dst-port=53 in-interface-list=lan-interface protocol=udp
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-address dst-port=53 in-interface-list=lan-interface protocol=tcp
/ipv6 firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interface protocol=udp src-port=123 to-ports=8081-65535
/ipv6 nd set [ find default=yes ] disabled=yes
/ipv6 nd add advertise-dns=yes advertise-mac-address=yes dns=fd45:1e52:2abe:4c85::1 hop-limit=64 interface=bridge-vlan-10-lan managed-address-configuration=no mtu=1492 other-configuration=no ra-interval=3m20s-10m ra-lifetime=2h30m ra-preference=high
/ipv6 nd prefix default set autonomous=yes preferred-lifetime=16h valid-lifetime=1d
/system clock set time-zone-autodetect=no time-zone-name=America/Sao_Paulo
/system identity set name=Router
/system ntp client set enabled=yes mode=unicast
/system ntp client servers add address=time1.google.com iburst=yes
/system ntp client servers add address=time2.google.com iburst=yes
/system ntp client servers add address=time3.google.com iburst=yes
/system ntp client servers add address=time4.google.com iburst=yes
/tool bandwidth-server set enabled=no
/tool graphing interface add interface=eth1-modem store-on-disk=no
/tool graphing interface add interface=eth1-vlan-600-pppoe-client-wan store-on-disk=no
/tool graphing interface add interface=bridge-vlan-10-lan store-on-disk=no
/tool graphing resource add store-on-disk=no
/tool mac-server set allowed-interface-list=none
/tool mac-server mac-winbox set allowed-interface-list=none
/tool mac-server ping set enabled=no
/tool romon set enabled=no
```

## End result

### IPv4 addresses

```
> /ip address print
Flags: D - DYNAMIC
Columns: ADDRESS, NETWORK, INTERFACE
#   ADDRESS             NETWORK        INTERFACE
0   192.168.167.1/32    192.168.167.1  lo
1   192.168.103.254/24  192.168.103.0  bridge-vlan-10-lan
2   192.168.237.2/30    192.168.237.0  eth1-modem
3 D 201.1.26.114/32     189.97.102.55  eth1-vlan-600-pppoe-client-wan
```

### IPv4 routes

```
> /ip route print
Flags: D - DYNAMIC; A - ACTIVE; c - CONNECT, v - VPN
Columns: DST-ADDRESS, GATEWAY, ROUTING-TABLE, DISTANCE
    DST-ADDRESS       GATEWAY                         ROUTING-TABLE  DISTANCE
DAv 0.0.0.0/0         eth1-vlan-600-pppoe-client-wan  main                  2
DAc 189.97.102.55/32  eth1-vlan-600-pppoe-client-wan  main                  0
DAc 192.168.103.0/24  bridge-vlan-10-lan              main                  0
DAc 192.168.167.1/32  lo                              main                  0
DAc 192.168.237.0/30  eth1-modem                      main                  0
```

### IPv6 addresses

```
> /ipv6 address print
Flags: D - DYNAMIC; G - GLOBAL, L - LINK-LOCAL
Columns: ADDRESS, FROM-POOL, INTERFACE, ADVERTISE, VALID
#    ADDRESS                                    FROM-POOL              INTERFACE                       ADVERTISE  VALID
0  G fd45:1e52:2abe:4c85::1/128                                        lo                              no
1  G 2804:7f4:ca01:6254:6e86:3d5b:dc42:add2/64  ipv6-dhcp-client-pool  bridge-vlan-10-lan              yes
2 D  ::1/128                                                           lo                              no
3 DL fe80::4aa9:8aff:fe2e:2084/64                                      bridge                          no
4 DL fe80::4aa9:8aff:fe2e:2084/64                                      bridge-vlan-10-lan              no
5 DL fe80::4aa9:8aff:fe2e:2084/64                                      bridge-vlan-1                   no
6 DL fe80::4aa9:8aff:fe41:3e50/64                                      eth1-vlan-600                   no
7 DL fe80::4aa9:8aff:fe41:3e50/64                                      eth1-modem                      no
8 DL fe80::8bb6:cece:0:f/64                                            eth1-vlan-600-pppoe-client-wan  no
9 DG 2804:7f4:c02f:3907:8bb6:cece:0:f/64                               eth1-vlan-600-pppoe-client-wan  no         2d23h57m48s
```

### IPv6 routes

```
> /ipv6 route print
Flags: D - DYNAMIC; A - ACTIVE; c - CONNECT, d - DHCP, v - VPN
Columns: DST-ADDRESS, GATEWAY, ROUTING-TABLE, DISTANCE
    DST-ADDRESS                 GATEWAY                                                   ROUTING-TABLE  DISTANCE
DAv ::/0                        eth1-vlan-600-pppoe-client-wan                            main                  2
D d ::/0                        fe80::a21c:8dff:fef1:1934%eth1-vlan-600-pppoe-client-wan  main                  3
DAc ::1/128                     lo                                                        main                  0
DAc 2804:7f4:c02f:3907::/64     eth1-vlan-600-pppoe-client-wan                            main                  0
D d 2804:7f4:ca01:6254::/64                                                               main                  2
DAc 2804:7f4:ca01:6254::/64     bridge-vlan-10-lan                                        main                  0
DAc fd45:1e52:2abe:4c85::1/128  lo                                                        main                  0
DAc fe80::/64                   bridge                                                    main                  0
DAc fe80::/64                   bridge-vlan-10-lan                                        main                  0
DAc fe80::/64                   bridge-vlan-1                                             main                  0
DAc fe80::/64                   eth1-vlan-600                                             main                  0
DAc fe80::/64                   eth1-modem                                                main                  0
DAc fe80::/64                   eth1-vlan-600-pppoe-client-wan                            main                  0
```

## Resources

* [commands.rsc](./commands.rsc)
* [configuration.rsc](./configuration.rsc)
