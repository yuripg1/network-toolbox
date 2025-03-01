/interface bridge add admin-mac=48:A9:8A:2E:20:84 arp=enabled arp-timeout=auto auto-mac=no dhcp-snooping=no ether-type=0x8100 fast-forward=yes forward-reserved-addresses=no frame-types=admit-all igmp-snooping=no ingress-filtering=yes max-learned-entries=auto mtu=1500 name=bridge-lan protocol-mode=none pvid=1 vlan-filtering=yes
/interface ethernet set [ find default-name=ether1 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:41:3E:50 mtu=1500 name=ether1-wan
/interface ethernet set [ find default-name=ether2 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:D2:32:3B mtu=1500
/interface ethernet set [ find default-name=ether3 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:93:38:59 mtu=1500
/interface ethernet set [ find default-name=ether4 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:C2:ED:8C mtu=1500
/interface ethernet set [ find default-name=ether5 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:5D:38:CB mtu=1500
/interface ethernet set [ find default-name=ether6 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:CB:0D:50 mtu=1500
/interface ethernet set [ find default-name=ether7 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:9F:ED:76 mtu=1500
/interface ethernet set [ find default-name=ether8 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=no l2mtu=1504 loop-protect=off mac-address=48:A9:8A:1C:70:66 mtu=1500
/interface ethernet set [ find default-name=sfp-sfpplus1 ] arp=enabled arp-timeout=auto auto-negotiation=yes disabled=yes l2mtu=1504 loop-protect=off mac-address=48:A9:8A:D0:2F:04 mtu=1500
/interface vlan add arp=enabled arp-timeout=auto interface=bridge-lan loop-protect=off mtu=1500 name=bridge-lan-vlan-10 vlan-id=10
/interface vlan add arp=enabled arp-timeout=auto interface=ether1-wan loop-protect=off mtu=1500 name=ether1-wan-vlan-600 vlan-id=600
/interface list add name=wan-interfaces
/interface list add name=lan-interfaces
/interface list add include=wan-interfaces name=masquerade-interfaces
/ip dhcp-server option add code=26 force=no name=ip-dhcp-server-vlan-10-option-26 value="'1492'"
/ip dhcp-server option add code=28 force=no name=ip-dhcp-server-vlan-10-option-28 value="'10.175.202.255'"
/ip pool add name=ip-dhcp-server-pool-vlan-10 ranges=10.175.202.2-10.175.202.253
/ip dhcp-server add address-pool=ip-dhcp-server-pool-vlan-10 authoritative=yes bootp-support=none conflict-detection=yes interface=bridge-lan-vlan-10 lease-time=12h name=ip-dhcp-server-vlan-10
/ppp profile add change-tcp-mss=no name=pppoe-client-profile use-compression=no use-encryption=no use-ipv6=required use-mpls=no
/interface pppoe-client add add-default-route=yes allow=chap,mschap1,mschap2 default-route-distance=2 disabled=no interface=ether1-wan-vlan-600 max-mru=1492 max-mtu=1492 name=ether1-wan-vlan-600-pppoe-client password=cliente profile=pppoe-client-profile use-peer-dns=no user=cliente@cliente
/queue interface set ether1-wan queue=only-hardware-queue
/queue interface set ether2 queue=only-hardware-queue
/queue interface set ether3 queue=only-hardware-queue
/queue interface set ether4 queue=only-hardware-queue
/queue interface set ether5 queue=only-hardware-queue
/queue interface set ether6 queue=only-hardware-queue
/queue interface set ether7 queue=only-hardware-queue
/queue interface set ether8 queue=only-hardware-queue
/queue interface set sfp-sfpplus1 queue=only-hardware-queue
/system logging action set [ find name=memory ] memory-lines=10000
/ip smb set enabled=no
/interface bridge port add bridge=bridge-lan frame-types=admit-all hw=yes ingress-filtering=yes interface=ether2 learn=yes pvid=1
/interface bridge port add bridge=bridge-lan frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=ether3 learn=yes pvid=10
/interface bridge port add bridge=bridge-lan frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=ether4 learn=yes pvid=10
/interface bridge port add bridge=bridge-lan frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=ether5 learn=yes pvid=10
/interface bridge port add bridge=bridge-lan frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=ether6 learn=yes pvid=10
/interface bridge port add bridge=bridge-lan frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=ether7 learn=yes pvid=10
/interface bridge port add bridge=bridge-lan frame-types=admit-only-untagged-and-priority-tagged hw=yes ingress-filtering=yes interface=ether8 learn=yes pvid=10
/interface bridge settings set allow-fast-path=yes use-ip-firewall=no
/ip firewall connection tracking set enabled=yes generic-timeout=10m icmp-timeout=30s loose-tcp-tracking=yes tcp-close-timeout=10s tcp-close-wait-timeout=1m tcp-established-timeout=5d tcp-fin-wait-timeout=2m tcp-last-ack-timeout=30s tcp-max-retrans-timeout=5m tcp-syn-received-timeout=1m tcp-syn-sent-timeout=2m tcp-time-wait-timeout=2m tcp-unacked-timeout=5m udp-stream-timeout=3m udp-timeout=30s
/ip neighbor discovery-settings set discover-interface-list=none
/ip settings set accept-redirects=no accept-source-route=no allow-fast-path=yes ip-forward=yes rp-filter=no secure-redirects=yes send-redirects=yes tcp-syncookies=yes tcp-timestamps=random-offset
/ipv6 settings set accept-redirects=no accept-router-advertisements=yes disable-ipv6=no forward=yes
/interface bridge vlan add bridge=bridge-lan untagged=bridge-lan,ether2 vlan-ids=1
/interface bridge vlan add bridge=bridge-lan tagged=bridge-lan,ether2 untagged=ether3,ether4,ether5,ether6,ether7,ether8 vlan-ids=10
/interface list member add interface=bridge-lan-vlan-10 list=lan-interfaces
/interface list member add interface=ether1-wan-vlan-600-pppoe-client list=wan-interfaces
/interface list member add interface=ether1-wan list=masquerade-interfaces
/ip address add address=10.195.123.1/32 interface=lo network=10.195.123.1
/ip address add address=10.175.202.1/24 interface=bridge-lan-vlan-10 network=10.175.202.0
/ip address add address=10.123.203.2/24 interface=ether1-wan network=10.123.203.0
/ip cloud set back-to-home-vpn=revoked-and-disabled ddns-enabled=auto update-time=no
/ip dhcp-server network add address=10.175.202.0/24 dhcp-option=ip-dhcp-server-vlan-10-option-26,ip-dhcp-server-vlan-10-option-28 dns-server=10.195.123.1 gateway=10.175.202.1 netmask=24
/ip dns set allow-remote-requests=yes cache-size=20480KiB max-concurrent-queries=1000 servers=8.8.8.8,8.8.4.4
/ip dns static add address=10.195.123.1 name=router.lan ttl=5m type=A
/ip dns static add address=fd9b:69ab:e45c:4aa6::1 name=router.lan ttl=5m type=AAAA
/ip firewall address-list add address=10.195.123.1/32 list=ip-dns-addresses
/ip firewall address-list add address=10.175.202.0/24 list=ip-lan-addresses
/ip firewall filter add action=jump chain=forward comment="jump packets coming from wan interfaces" in-interface-list=wan-interfaces jump-target=ip-forward-wan-in
/ip firewall filter add action=return chain=ip-forward-wan-in comment="return established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ip-forward-wan-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=drop chain=ip-forward-wan-in comment="drop remaining packets"
/ip firewall filter add action=jump chain=input comment="jump packets coming from wan interfaces" in-interface-list=wan-interfaces jump-target=ip-input-wan-in
/ip firewall filter add action=return chain=ip-input-wan-in comment="return established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ip-input-wan-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=return chain=ip-input-wan-in comment="return icmp echo request packets" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=drop chain=ip-input-wan-in comment="drop remaining packets"
/ip firewall mangle add action=change-mss chain=forward in-interface-list=wan-interfaces new-mss=1452 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1453-65535
/ip firewall mangle add action=change-mss chain=postrouting new-mss=1452 out-interface-list=wan-interfaces passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1453-65535
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ip-dns-addresses dst-port=53 in-interface-list=lan-interfaces protocol=udp
/ip firewall nat add action=redirect chain=dstnat dst-address-list=!ip-dns-addresses dst-port=53 in-interface-list=lan-interfaces protocol=tcp
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=wan-interfaces protocol=udp src-address-list=ip-lan-addresses src-port=123 to-ports=49152-65535
/ip firewall nat add action=masquerade chain=srcnat out-interface-list=masquerade-interfaces src-address-list=ip-lan-addresses
/ip firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interfaces protocol=udp src-port=123 to-ports=49152-65535
/ip firewall service-port set ftp disabled=yes
/ip firewall service-port set tftp disabled=yes
/ip firewall service-port set irc disabled=yes
/ip firewall service-port set h323 disabled=yes
/ip firewall service-port set sip disabled=yes
/ip firewall service-port set pptp disabled=yes
/ip firewall service-port set rtsp disabled=yes
/ip service set telnet disabled=yes
/ip service set ftp disabled=yes
/ip service set www disabled=no port=80
/ip service set ssh disabled=no port=22
/ip service set www-ssl disabled=yes
/ip service set api disabled=yes
/ip service set winbox disabled=no port=8291
/ip service set api-ssl disabled=yes
/ip ssh set strong-crypto=yes
/ipv6 address add address=fd9b:69ab:e45c:4aa6::1/128 advertise=no interface=lo no-dad=no
/ipv6 address add address=::72c7:90fa:ba4d:9e56/64 advertise=yes from-pool=ipv6-dhcp-client-pool interface=bridge-lan-vlan-10 no-dad=no
/ipv6 dhcp-client add add-default-route=yes allow-reconfigure=yes default-route-distance=3 interface=ether1-wan-vlan-600-pppoe-client pool-name=ipv6-dhcp-client-pool pool-prefix-length=64 prefix-hint=::/64 rapid-commit=yes request=prefix use-interface-duid=no use-peer-dns=no
/ipv6 firewall address-list add address=fe80::/10 list=ipv6-link-local-addresses
/ipv6 firewall address-list add address=fd9b:69ab:e45c:4aa6::1/128 list=ipv6-dns-addresses
/ipv6 firewall filter add action=jump chain=forward comment="jump packets coming from wan interfaces" in-interface-list=wan-interfaces jump-target=ipv6-forward-wan-in
/ipv6 firewall filter add action=return chain=ipv6-forward-wan-in comment="return established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=return chain=ipv6-forward-wan-in comment="return icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop remaining packets"
/ipv6 firewall filter add action=jump chain=input comment="jump packets coming from wan interfaces" in-interface-list=wan-interfaces jump-target=ipv6-input-wan-in
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="return established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="return icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="return icmpv6 router solicitation packets" icmp-options=133:0 protocol=icmpv6 src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="return icmpv6 router advertisement packets" icmp-options=134:0 protocol=icmpv6 src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="return icmpv6 neighbor solicitation packets" icmp-options=135:0 protocol=icmpv6 src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="return icmpv6 neighbor advertisement packets" icmp-options=136:0 protocol=icmpv6 src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="return dhcpv6 packets" dst-port=546 protocol=udp src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop remaining packets"
/ipv6 firewall mangle add action=change-mss chain=forward in-interface-list=wan-interfaces new-mss=1432 passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1433-65535
/ipv6 firewall mangle add action=change-mss chain=postrouting new-mss=1432 out-interface-list=wan-interfaces passthrough=yes protocol=tcp tcp-flags=syn tcp-mss=1433-65535
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-addresses dst-port=53 in-interface-list=lan-interfaces protocol=udp
/ipv6 firewall nat add action=redirect chain=dstnat dst-address-list=!ipv6-dns-addresses dst-port=53 in-interface-list=lan-interfaces protocol=tcp
/ipv6 firewall nat add action=src-nat chain=srcnat out-interface-list=wan-interfaces protocol=udp src-port=123 to-ports=49152-65535
/ipv6 nd set [ find default=yes ] disabled=yes
/ipv6 nd add advertise-dns=yes advertise-mac-address=yes dns=fd9b:69ab:e45c:4aa6::1 hop-limit=64 interface=bridge-lan-vlan-10 managed-address-configuration=no mtu=1492 other-configuration=no ra-preference=medium
/ipv6 nd prefix default set autonomous=yes preferred-lifetime=12h valid-lifetime=18h
/system clock set time-zone-autodetect=no time-zone-name=America/Sao_Paulo
/system identity set name=Home-Router
/system ntp client set enabled=yes mode=unicast
/system ntp client servers add address=time1.google.com iburst=yes
/system ntp client servers add address=time2.google.com iburst=yes
/system ntp client servers add address=time3.google.com iburst=yes
/system ntp client servers add address=time4.google.com iburst=yes
/tool bandwidth-server set enabled=no
/tool graphing interface add interface=ether1-wan-vlan-600-pppoe-client store-on-disk=no
/tool graphing interface add interface=bridge-lan-vlan-10 store-on-disk=no
/tool graphing resource add store-on-disk=no
/tool mac-server set allowed-interface-list=none
/tool mac-server mac-winbox set allowed-interface-list=none
/tool mac-server ping set enabled=no
