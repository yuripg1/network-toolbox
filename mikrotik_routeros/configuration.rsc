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
/ipv6 nd add advertise-dns=yes advertise-mac-address=yes dns=fe80::48a9:8aff:fe40:5a95 hop-limit=64 interface=ether2-lan managed-address-configuration=no mtu=1492 other-configuration=no ra-preference=high
/ipv6 nd add interface=ether1-wan-vlan-600-pppoe-client
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
