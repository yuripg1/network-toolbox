## Configuration commands

### Credential configuration

```
/user add group=full name=user749646300 password=password936275503
```

### Default credential removal

```
/user remove admin
```

### Interfaces configuration

```
/interface ethernet set [ find default-name=ether1 ] disabled=no l2mtu=1504 loop-protect=off mac-address=4A:A9:8A:5E:73:3D mtu=1500 name=ether1-wan
/interface ethernet set [ find default-name=ether2 ] disabled=no l2mtu=1504 loop-protect=off mac-address=4A:A9:8A:40:5A:95 mtu=1500 name=ether2-lan
/interface ethernet set [ find default-name=ether3 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface ethernet set [ find default-name=ether4 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface ethernet set [ find default-name=ether5 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface ethernet set [ find default-name=ether6 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface ethernet set [ find default-name=ether7 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface ethernet set [ find default-name=ether8 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface ethernet set [ find default-name=sfp-sfpplus1 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
```

### IPv4 firewall rules

```
/interface list add name=wan-interface-list
/ip firewall filter add action=jump chain=forward comment="jump packets coming from wan interfaces" in-interface-list=wan-interface-list jump-target=ip-forward-wan-in
/ip firewall filter add action=jump chain=input comment="jump packets coming from wan interfaces" in-interface-list=wan-interface-list jump-target=ip-input-wan-in
/ip firewall filter add action=accept chain=ip-forward-wan-in comment="accept established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ip-forward-wan-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=drop chain=ip-forward-wan-in comment="drop remaining packets"
/ip firewall filter add action=accept chain=ip-input-wan-in comment="accept established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ip-input-wan-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=accept chain=ip-input-wan-in comment="accept icmp echo request packets" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=drop chain=ip-input-wan-in comment="drop remaining icmp packets" log=yes protocol=icmp
/ip firewall filter add action=drop chain=ip-input-wan-in comment="drop remaining packets"
```

### IPv4 LAN

```
/ip address add address=10.175.202.1/24 interface=ether2-lan network=10.175.202.0
/interface list add name=lan-interface-list
/interface list member add interface=ether2-lan list=lan-interface-list
/ip dhcp-server option add code=26 force=no name=ip-dhcp-server-option-26 value="'1492'"
/ip dhcp-server option add code=28 force=no name=ip-dhcp-server-option-28 value="'10.175.202.255'"
/ip dhcp-server option sets add name=ip-dhcp-server-option-set options=ip-dhcp-server-option-26,ip-dhcp-server-option-28
/ip dhcp-server network add address=10.175.202.0/24 dhcp-option-set=ip-dhcp-server-option-set dns-server=10.175.202.1 gateway=10.175.202.1 netmask=24
/ip pool add name=ip-dhcp-server-pool ranges=10.175.202.2-10.175.202.253
/ip dhcp-server add address-pool=ip-dhcp-server-pool authoritative=yes conflict-detection=yes interface=ether2-lan lease-time=2d name=ip-dhcp-server
```

### IPv4 WAN

```
/ppp profile add change-tcp-mss=no name=pppoe-client-profile use-compression=no use-encryption=no use-ipv6=required use-mpls=no
/interface vlan add interface=ether1-wan loop-protect=off mtu=1500 name=ether1-wan-vlan-600 vlan-id=600
/interface pppoe-client add add-default-route=yes allow=chap,mschap1,mschap2 default-route-distance=1 disabled=no interface=ether1-wan-vlan-600 max-mru=1492 max-mtu=1492 name=ether1-wan-vlan-600-pppoe-client password=cliente profile=pppoe-client-profile use-peer-dns=no user=cliente@cliente
/interface list member add interface=ether1-wan-vlan-600-pppoe-client list=wan-interface-list
```

### IPv4 TCP MSS clamping

```
/ip firewall mangle add action=change-mss chain=forward in-interface-list=wan-interface-list new-mss=1452 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1453-65535
/ip firewall mangle add action=change-mss chain=postrouting new-mss=1452 out-interface-list=wan-interface-list passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1453-65535
```

### IPv4 DNS query redirection

```
/ip firewall address-list add address=10.175.202.1/32 list=ip-dns-address-list
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ip-dns-address-list dst-port=53 in-interface-list=lan-interface-list protocol=udp
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ip-dns-address-list dst-port=53 in-interface-list=lan-interface-list protocol=tcp
```

### IPv4 NAT

```
/interface list add include=wan-interface-list name=masquerade-interface-list
/ip firewall address-list add address=10.175.202.0/24 list=ip-lan-address-list
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=masquerade-interface-list src-address-list=ip-lan-address-list
```

### IPv4 workaround for ISP blocking of inbound UDP packets on port 123

```
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interface-list protocol=udp src-address-list=ip-lan-address-list src-port=123 to-ports=49152-65535 place-before=2
/ip firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interface-list protocol=udp src-port=123 to-ports=49152-65535
```

### IPv6 firewall rules

```
/ipv6 firewall address-list add address=fe80::/10 list=ipv6-link-local-address-list
/ipv6 firewall filter add action=jump chain=forward comment="jump packets coming from wan interfaces" in-interface-list=wan-interface-list jump-target=ipv6-forward-wan-in
/ipv6 firewall filter add action=jump chain=input comment="jump packets coming from wan interfaces" in-interface-list=wan-interface-list jump-target=ipv6-input-wan-in
/ipv6 firewall filter add action=accept chain=ipv6-forward-wan-in comment="accept established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=accept chain=ipv6-forward-wan-in comment="accept icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop remaining icmpv6 packets" log=yes protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop remaining packets"
/ipv6 firewall filter add action=accept chain=ipv6-input-wan-in comment="accept established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=accept chain=ipv6-input-wan-in comment="accept icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=accept chain=ipv6-input-wan-in comment="accept icmpv6 router advertisement packets" icmp-options=134:0 protocol=icmpv6 src-address-list=ipv6-link-local-address-list
/ipv6 firewall filter add action=accept chain=ipv6-input-wan-in comment="accept dhcpv6 packets" dst-port=546 protocol=udp src-address-list=ipv6-link-local-address-list src-port=547
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop remaining icmpv6 packets" log=yes protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop remaining dhcpv6 packets" dst-port=546 log=yes protocol=udp
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop remaining packets"
```

### IPv6 LAN

```
/ipv6 nd set [ find default=yes ] disabled=yes
/ipv6 nd add advertise-dns=yes advertise-mac-address=yes dns=fe80::48a9:8aff:fe40:5a95 hop-limit=64 interface=ether2-lan managed-address-configuration=no mtu=1492 other-configuration=no ra-preference=medium
/ipv6 nd prefix default set autonomous=yes
```

### IPv6 WAN

```
/ipv6 address add address=::72c7:90fa:ba4d:9e56/64 advertise=yes from-pool=ipv6-dhcp-client-pool interface=ether2-lan no-dad=no
/ipv6 dhcp-client add add-default-route=yes default-route-distance=2 interface=ether1-wan-vlan-600-pppoe-client pool-name=ipv6-dhcp-client-pool pool-prefix-length=64 prefix-hint=::/64 rapid-commit=yes request=prefix use-interface-duid=no use-peer-dns=no
```

### IPv6 TCP MSS clamping

```
/ipv6 firewall mangle add action=change-mss chain=forward in-interface-list=wan-interface-list new-mss=1432 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1433-65535
/ipv6 firewall mangle add action=change-mss chain=postrouting new-mss=1432 out-interface-list=wan-interface-list passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1433-65535
```

### IPv6 DNS query redirection

```
/ipv6 firewall address-list add address=fe80::48a9:8aff:fe40:5a95/128 list=ipv6-dns-address-list
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-address-list dst-port=53 in-interface-list=lan-interface-list protocol=udp
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-address-list dst-port=53 in-interface-list=lan-interface-list protocol=tcp
```

### IPv6 workaround for ISP blocking of inbound UDP packets on port 123

```
/ipv6 firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interface-list protocol=udp src-port=123 to-ports=49152-65535
```

### DNS configuration

```
/ip dns set allow-remote-requests=yes cache-size=20480KiB max-concurrent-queries=1000 servers=2001:4860:4860::8888,2001:4860:4860::8844
```

### Clock configuration

```
/ip cloud set ddns-enabled=no update-time=no
/system clock set time-zone-autodetect=no time-zone-name=America/Sao_Paulo
/system ntp client servers add address=time1.google.com iburst=yes
/system ntp client servers add address=time2.google.com iburst=yes
/system ntp client servers add address=time3.google.com iburst=yes
/system ntp client servers add address=time4.google.com iburst=yes
/system ntp client set enabled=yes mode=unicast
```

### Connection tracking timeouts

```
/ip firewall connection tracking set enabled=yes generic-timeout=10m icmp-timeout=30s loose-tcp-tracking=yes tcp-close-timeout=10s tcp-close-wait-timeout=1m tcp-established-timeout=5d tcp-fin-wait-timeout=2m tcp-last-ack-timeout=30s tcp-max-retrans-timeout=5m tcp-syn-received-timeout=1m tcp-syn-sent-timeout=2m tcp-time-wait-timeout=2m tcp-unacked-timeout=5m udp-stream-timeout=3m udp-timeout=30s
```

### Netfilter configuration

```
/ip settings set accept-redirects=no accept-source-route=no allow-fast-path=yes ip-forward=yes rp-filter=no secure-redirects=yes send-redirects=yes tcp-syncookies=yes
/ipv6 settings set accept-redirects=no accept-router-advertisements=yes disable-ipv6=no forward=yes
```

### Static DNS configuration

```
/ip dns static add address=10.175.202.1 name=router.lan ttl=5m type=A
```

### Modem access configuration

```
/ip address add address=10.123.203.2/24 interface=ether1-wan network=10.123.203.0
/interface list member add interface=ether1-wan list=masquerade-interface-list
```

### Host name configuration

```
/system identity set name=Home-Router
```

### Discovery configuration

```
/ip neighbor discovery-settings set discover-interface-list=none
```

### Management hardening

```
/ip ssh set strong-crypto=yes
```

### Disabling of unused services

```
/ip smb set enabled=no
/tool bandwidth-server set enabled=no
```

### Management channels configuration

```
/ip service set telnet disabled=yes
/ip service set ftp disabled=yes
/ip service set www disabled=no port=80
/ip service set ssh disabled=no port=22
/ip service set www-ssl disabled=yes
/ip service set api disabled=yes
/ip service set winbox disabled=yes
/ip service set api-ssl disabled=yes
```

### Physical interfaces queue configuration

```
/queue interface set ether1-wan queue=only-hardware-queue
/queue interface set ether2-lan queue=only-hardware-queue
/queue interface set ether3 queue=only-hardware-queue
/queue interface set ether4 queue=only-hardware-queue
/queue interface set ether5 queue=only-hardware-queue
/queue interface set ether6 queue=only-hardware-queue
/queue interface set ether7 queue=only-hardware-queue
/queue interface set ether8 queue=only-hardware-queue
/queue interface set sfp-sfpplus1 queue=only-hardware-queue
```

### Log configuration

```
/system logging action set [ find name=memory ] memory-lines=10000
```

### Graphing of interfaces traffic and system resources

```
/tool graphing interface add interface=ether1-wan store-on-disk=no
/tool graphing interface add interface=ether2-lan store-on-disk=no
/tool graphing resource add store-on-disk=no
```

### Disabling of access and troubleshooting via MAC address

```
/tool mac-server set allowed-interface-list=none
/tool mac-server mac-winbox set allowed-interface-list=none
/tool mac-server ping set enabled=no
```

## Final configuration

```
/interface ethernet set [ find default-name=ether1 ] disabled=no l2mtu=1504 loop-protect=off mac-address=4A:A9:8A:5E:73:3D mtu=1500 name=ether1-wan
/interface ethernet set [ find default-name=ether2 ] disabled=no l2mtu=1504 loop-protect=off mac-address=4A:A9:8A:40:5A:95 mtu=1500 name=ether2-lan
/interface ethernet set [ find default-name=ether3 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface ethernet set [ find default-name=ether4 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface ethernet set [ find default-name=ether5 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface ethernet set [ find default-name=ether6 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface ethernet set [ find default-name=ether7 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface ethernet set [ find default-name=ether8 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface ethernet set [ find default-name=sfp-sfpplus1 ] disabled=yes l2mtu=1504 loop-protect=off mtu=1500
/interface vlan add interface=ether1-wan loop-protect=off mtu=1500 name=ether1-wan-vlan-600 vlan-id=600
/interface list add name=wan-interface-list
/interface list add name=lan-interface-list
/interface list add include=wan-interface-list name=masquerade-interface-list
/ip dhcp-server option add code=26 force=no name=ip-dhcp-server-option-26 value="'1492'"
/ip dhcp-server option add code=28 force=no name=ip-dhcp-server-option-28 value="'10.175.202.255'"
/ip dhcp-server option sets add name=ip-dhcp-server-option-set options=ip-dhcp-server-option-26,ip-dhcp-server-option-28
/ip pool add name=ip-dhcp-server-pool ranges=10.175.202.2-10.175.202.253
/ip dhcp-server add address-pool=ip-dhcp-server-pool authoritative=yes conflict-detection=yes interface=ether2-lan lease-time=2d name=ip-dhcp-server
/ppp profile add change-tcp-mss=no name=pppoe-client-profile use-compression=no use-encryption=no use-ipv6=required use-mpls=no
/interface pppoe-client add add-default-route=yes allow=chap,mschap1,mschap2 default-route-distance=1 disabled=no interface=ether1-wan-vlan-600 max-mru=1492 max-mtu=1492 name=ether1-wan-vlan-600-pppoe-client password=cliente profile=pppoe-client-profile use-peer-dns=no user=cliente@cliente
/queue interface set ether1-wan queue=only-hardware-queue
/queue interface set ether2-lan queue=only-hardware-queue
/queue interface set ether3 queue=only-hardware-queue
/queue interface set ether4 queue=only-hardware-queue
/queue interface set ether5 queue=only-hardware-queue
/queue interface set ether6 queue=only-hardware-queue
/queue interface set ether7 queue=only-hardware-queue
/queue interface set ether8 queue=only-hardware-queue
/queue interface set sfp-sfpplus1 queue=only-hardware-queue
/system logging action set [ find name=memory ] memory-lines=10000
/ip smb set enabled=no
/ip firewall connection tracking set enabled=yes generic-timeout=10m icmp-timeout=30s loose-tcp-tracking=yes tcp-close-timeout=10s tcp-close-wait-timeout=1m tcp-established-timeout=5d tcp-fin-wait-timeout=2m tcp-last-ack-timeout=30s tcp-max-retrans-timeout=5m tcp-syn-received-timeout=1m tcp-syn-sent-timeout=2m tcp-time-wait-timeout=2m tcp-unacked-timeout=5m udp-stream-timeout=3m udp-timeout=30s
/ip neighbor discovery-settings set discover-interface-list=none
/ip settings set accept-redirects=no accept-source-route=no allow-fast-path=yes ip-forward=yes rp-filter=no secure-redirects=yes send-redirects=yes tcp-syncookies=yes
/ipv6 settings set accept-redirects=no accept-router-advertisements=yes disable-ipv6=no forward=yes
/interface list member add interface=ether2-lan list=lan-interface-list
/interface list member add interface=ether1-wan-vlan-600-pppoe-client list=wan-interface-list
/interface list member add interface=ether1-wan list=masquerade-interface-list
/ip address add address=10.175.202.1/24 interface=ether2-lan network=10.175.202.0
/ip address add address=10.123.203.2/24 interface=ether1-wan network=10.123.203.0
/ip cloud set ddns-enabled=no update-time=no
/ip dhcp-server network add address=10.175.202.0/24 dhcp-option-set=ip-dhcp-server-option-set dns-server=10.175.202.1 gateway=10.175.202.1 netmask=24
/ip dns set allow-remote-requests=yes cache-size=20480KiB max-concurrent-queries=1000 servers=2001:4860:4860::8888,2001:4860:4860::8844
/ip dns static add address=10.175.202.1 name=router.lan ttl=5m type=A
/ip firewall address-list add address=10.175.202.1/32 list=ip-dns-address-list
/ip firewall address-list add address=10.175.202.0/24 list=ip-lan-address-list
/ip firewall filter add action=jump chain=forward comment="jump packets coming from wan interfaces" in-interface-list=wan-interface-list jump-target=ip-forward-wan-in
/ip firewall filter add action=jump chain=input comment="jump packets coming from wan interfaces" in-interface-list=wan-interface-list jump-target=ip-input-wan-in
/ip firewall filter add action=accept chain=ip-forward-wan-in comment="accept established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ip-forward-wan-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=drop chain=ip-forward-wan-in comment="drop remaining packets"
/ip firewall filter add action=accept chain=ip-input-wan-in comment="accept established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ip-input-wan-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=accept chain=ip-input-wan-in comment="accept icmp echo request packets" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=drop chain=ip-input-wan-in comment="drop remaining icmp packets" log=yes protocol=icmp
/ip firewall filter add action=drop chain=ip-input-wan-in comment="drop remaining packets"
/ip firewall mangle add action=change-mss chain=forward in-interface-list=wan-interface-list new-mss=1452 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1453-65535
/ip firewall mangle add action=change-mss chain=postrouting new-mss=1452 out-interface-list=wan-interface-list passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1453-65535
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ip-dns-address-list dst-port=53 in-interface-list=lan-interface-list protocol=udp
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ip-dns-address-list dst-port=53 in-interface-list=lan-interface-list protocol=tcp
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interface-list protocol=udp src-address-list=ip-lan-address-list src-port=123 to-ports=49152-65535
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=masquerade-interface-list src-address-list=ip-lan-address-list
/ip firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interface-list protocol=udp src-port=123 to-ports=49152-65535
/ip service set telnet disabled=yes
/ip service set ftp disabled=yes
/ip service set www disabled=no port=80
/ip service set ssh disabled=no port=22
/ip service set www-ssl disabled=yes
/ip service set api disabled=yes
/ip service set winbox disabled=yes
/ip service set api-ssl disabled=yes
/ip ssh set strong-crypto=yes
/ipv6 address add address=::72c7:90fa:ba4d:9e56/64 advertise=yes from-pool=ipv6-dhcp-client-pool interface=ether2-lan no-dad=no
/ipv6 dhcp-client add add-default-route=yes default-route-distance=2 interface=ether1-wan-vlan-600-pppoe-client pool-name=ipv6-dhcp-client-pool pool-prefix-length=64 prefix-hint=::/64 rapid-commit=yes request=prefix use-interface-duid=no use-peer-dns=no
/ipv6 firewall address-list add address=fe80::/10 list=ipv6-link-local-address-list
/ipv6 firewall address-list add address=fe80::48a9:8aff:fe40:5a95/128 list=ipv6-dns-address-list
/ipv6 firewall filter add action=jump chain=forward comment="jump packets coming from wan interfaces" in-interface-list=wan-interface-list jump-target=ipv6-forward-wan-in
/ipv6 firewall filter add action=jump chain=input comment="jump packets coming from wan interfaces" in-interface-list=wan-interface-list jump-target=ipv6-input-wan-in
/ipv6 firewall filter add action=accept chain=ipv6-forward-wan-in comment="accept established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=accept chain=ipv6-forward-wan-in comment="accept icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop remaining icmpv6 packets" log=yes protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop remaining packets"
/ipv6 firewall filter add action=accept chain=ipv6-input-wan-in comment="accept established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=accept chain=ipv6-input-wan-in comment="accept icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=accept chain=ipv6-input-wan-in comment="accept icmpv6 router advertisement packets" icmp-options=134:0 protocol=icmpv6 src-address-list=ipv6-link-local-address-list
/ipv6 firewall filter add action=accept chain=ipv6-input-wan-in comment="accept dhcpv6 packets" dst-port=546 protocol=udp src-address-list=ipv6-link-local-address-list src-port=547
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop remaining icmpv6 packets" log=yes protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop remaining dhcpv6 packets" dst-port=546 log=yes protocol=udp
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop remaining packets"
/ipv6 firewall mangle add action=change-mss chain=forward in-interface-list=wan-interface-list new-mss=1432 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1433-65535
/ipv6 firewall mangle add action=change-mss chain=postrouting new-mss=1432 out-interface-list=wan-interface-list passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1433-65535
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-address-list dst-port=53 in-interface-list=lan-interface-list protocol=udp
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-address-list dst-port=53 in-interface-list=lan-interface-list protocol=tcp
/ipv6 firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interface-list protocol=udp src-port=123 to-ports=49152-65535
/ipv6 nd set [ find default=yes ] disabled=yes
/ipv6 nd add advertise-dns=yes advertise-mac-address=yes dns=fe80::48a9:8aff:fe40:5a95 hop-limit=64 interface=ether2-lan managed-address-configuration=no mtu=1492 other-configuration=no ra-preference=medium
/ipv6 nd prefix default set autonomous=yes
/system clock set time-zone-autodetect=no time-zone-name=America/Sao_Paulo
/system identity set name=Home-Router
/system ntp client set enabled=yes mode=unicast
/system ntp client servers add address=time1.google.com iburst=yes
/system ntp client servers add address=time2.google.com iburst=yes
/system ntp client servers add address=time3.google.com iburst=yes
/system ntp client servers add address=time4.google.com iburst=yes
/tool bandwidth-server set enabled=no
/tool graphing interface add interface=ether1-wan store-on-disk=no
/tool graphing interface add interface=ether2-lan store-on-disk=no
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
#   ADDRESS           NETWORK         INTERFACE
0   10.175.202.1/24   10.175.202.0    ether2-lan
1   10.123.203.2/24   10.123.203.0    ether1-wan
2 D 187.112.51.41/32  179.184.126.59  ether1-wan-vlan-600-pppoe-client
```

### IPv4 routes

```
> /ip route print
Flags: D - DYNAMIC; A - ACTIVE; c - CONNECT, v - VPN
Columns: DST-ADDRESS, GATEWAY, DISTANCE
    DST-ADDRESS        GATEWAY                           DISTANCE
DAv 0.0.0.0/0          ether1-wan-vlan-600-pppoe-client         1
DAc 10.123.203.0/24    ether1-wan                               0
DAc 10.175.202.0/24    ether2-lan                               0
DAc 179.184.126.59/32  ether1-wan-vlan-600-pppoe-client         0
```

### IPv6 addresses

```
> /ipv6 address print
Flags: D - DYNAMIC; G - GLOBAL, L - LINK-LOCAL
Columns: ADDRESS, FROM-POOL, INTERFACE, ADVERTISE, VALID
#    ADDRESS                                    FROM-POOL              INTERFACE                         ADVERTISE  VALID
0  G 2804:7f4:c2b5:e851:72c7:90fa:ba4d:9e56/64  ipv6-dhcp-client-pool  ether2-lan                        yes
1 D  ::1/128                                                           lo                                no
2 DL fe80::48a9:8aff:fe5e:733d/64                                      ether1-wan-vlan-600               no
3 DL fe80::48a9:8aff:fe5e:733d/64                                      ether1-wan                        no
4 DL fe80::48a9:8aff:fe40:5a95/64                                      ether2-lan                        no
5 DL fe80::7917:7c34:0:c/64                                            ether1-wan-vlan-600-pppoe-client  no
6 DG 2804:7f4:c003:5801:7917:7c34:0:c/64                               ether1-wan-vlan-600-pppoe-client  no         23h57m36s
```

### IPv6 routes

```
> /ipv6 route print
Flags: D - DYNAMIC; A - ACTIVE; c - CONNECT, d - DHCP, v - VPN
Columns: DST-ADDRESS, GATEWAY, DISTANCE
    DST-ADDRESS                                 GATEWAY                                                     DISTANCE
D d ::/0                                        fe80::e681:84ff:fe30:840f%ether1-wan-vlan-600-pppoe-client         2
DAv ::/0                                        ether1-wan-vlan-600-pppoe-client                                   1
DAc ::1/128                                     lo                                                                 0
DAc 2804:7f4:c003:5801::/64                     ether1-wan-vlan-600-pppoe-client                                   0
DAc 2804:7f4:c2b5:e851::/64                     ether2-lan                                                         0
D d 2804:7f4:c2b5:e851::/64                                                                                        2
DAc fe80::%ether1-wan/64                        ether1-wan                                                         0
DAc fe80::%ether2-lan/64                        ether2-lan                                                         0
DAc fe80::%ether1-wan-vlan-600/64               ether1-wan-vlan-600                                                0
DAc fe80::%ether1-wan-vlan-600-pppoe-client/64  ether1-wan-vlan-600-pppoe-client                                   0
```

## Resources

* [commands.rsc](./commands.rsc)
* [configuration.rsc](./configuration.rsc)
