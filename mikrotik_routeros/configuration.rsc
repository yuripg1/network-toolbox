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
/interface vlan add arp=enabled arp-timeout=auto interface=bridge-lan loop-protect=off mtu=1500 name=bridge-lan-vlan-10 vlan-id=10
/interface vlan add arp=enabled arp-timeout=auto interface=eth1-wan loop-protect=off mtu=1500 name=eth1-wan-vlan-600 vlan-id=600
/interface list add name=wan-interface
/interface list add name=lan-vlan-10-interface
/ip dhcp-server option add code=23 force=no name=ipv4-vlan-10-dhcp-server-option-23 value="'64'"
/ip dhcp-server option add code=26 force=no name=ipv4-vlan-10-dhcp-server-option-26 value="'1492'"
/ip dhcp-server option add code=28 force=no name=ipv4-vlan-10-dhcp-server-option-28 value="'192.168.103.255'"
/ip pool add name=ipv4-vlan-10-dhcp-server-pool ranges=192.168.103.1-192.168.103.253
/ip dhcp-server add add-arp=yes address-pool=ipv4-vlan-10-dhcp-server-pool always-broadcast=no authoritative=yes bootp-support=none conflict-detection=yes interface=bridge-lan-vlan-10 lease-time=16h name=ipv4-vlan-10-dhcp-server use-reconfigure=no
/ppp profile add change-tcp-mss=no name=pppoe-client-profile use-compression=no use-encryption=no use-ipv6=yes use-mpls=no
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
/interface list member add interface=eth1-wan-vlan-600-pppoe-client list=wan-interface
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
/ip firewall filter add action=jump chain=forward comment="jump packets coming from wan interface" in-interface-list=wan-interface jump-target=ipv4-forward-wan-in
/ip firewall filter add action=return chain=ipv4-forward-wan-in comment="allow established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-forward-wan-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=drop chain=ipv4-forward-wan-in comment="drop remaining packets"
/ip firewall filter add action=jump chain=input comment="jump packets coming from wan interface" in-interface-list=wan-interface jump-target=ipv4-input-wan-in
/ip firewall filter add action=return chain=ipv4-input-wan-in comment="allow established,related packets" connection-state=established,related
/ip firewall filter add action=drop chain=ipv4-input-wan-in comment="drop invalid packets" connection-state=invalid
/ip firewall filter add action=return chain=ipv4-input-wan-in comment="allow icmp echo request packets" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=drop chain=ipv4-input-wan-in comment="drop remaining packets"
/ip firewall filter add action=jump chain=input comment="jump packets coming from lan-vlan-10 interface" in-interface-list=lan-vlan-10-interface jump-target=ipv4-input-lan-vlan-10-in
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
/ip firewall service-port set tftp disabled=yes
/ip firewall service-port set irc disabled=yes
/ip firewall service-port set h323 disabled=yes
/ip firewall service-port set sip disabled=yes
/ip firewall service-port set pptp disabled=yes
/ip firewall service-port set rtsp disabled=yes
/ip service set ftp disabled=yes
/ip service set telnet disabled=yes
/ip service set www disabled=yes
/ip service set api disabled=yes
/ip service set api-ssl disabled=yes
/ip service set www-ssl certificate=management_https disabled=no port=18856
/ip service set winbox disabled=no port=24639
/ip service set ssh disabled=no port=36518
/ip ssh set strong-crypto=yes
/ipv6 address add address=fd45:1e52:2abe:4c85::1/128 advertise=no auto-link-local=yes interface=lo no-dad=no
/ipv6 address add address=::6e86:3d5b:dc42:add2/64 advertise=yes auto-link-local=yes from-pool=ipv6-dhcp-client-pool interface=bridge-lan-vlan-10 no-dad=no
/ipv6 dhcp-client add add-default-route=yes allow-reconfigure=no check-gateway=ping custom-duid=0003000148a98a413e50 default-route-distance=2 default-route-tables=main:3 interface=eth1-wan-vlan-600-pppoe-client pool-name=ipv6-dhcp-client-pool pool-prefix-length=64 prefix-hint=::/64 rapid-commit=yes request=prefix use-interface-duid=no use-peer-dns=no validate-server-duid=yes
/ipv6 firewall address-list add address=fe80::/10 list=ipv6-link-local-addresses
/ipv6 firewall address-list add address=fd45:1e52:2abe:4c85::1/128 list=ipv6-dns-address
/ipv6 firewall filter add action=jump chain=forward comment="jump packets coming from wan interface" in-interface-list=wan-interface jump-target=ipv6-forward-wan-in
/ipv6 firewall filter add action=return chain=ipv6-forward-wan-in comment="allow established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=return chain=ipv6-forward-wan-in comment="allow icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-forward-wan-in comment="drop remaining packets"
/ipv6 firewall filter add action=jump chain=input comment="jump packets coming from wan interface" in-interface-list=wan-interface jump-target=ipv6-input-wan-in
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow dhcpv6 packets" dst-port=546 protocol=udp src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 router solicitation packets" icmp-options=133:0 protocol=icmpv6 src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 router advertisement packets" icmp-options=134:0 protocol=icmpv6 src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 neighbor solicitation packets" icmp-options=135:0 protocol=icmpv6
/ipv6 firewall filter add action=return chain=ipv6-input-wan-in comment="allow icmpv6 neighbor advertisement packets" icmp-options=136:0 protocol=icmpv6
/ipv6 firewall filter add action=drop chain=ipv6-input-wan-in comment="drop remaining packets"
/ipv6 firewall filter add action=jump chain=input comment="jump packets coming from lan-vlan-10 interface" in-interface-list=lan-vlan-10-interface jump-target=ipv6-input-lan-vlan-10-in
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow established,related packets" connection-state=established,related
/ipv6 firewall filter add action=drop chain=ipv6-input-lan-vlan-10-in comment="drop invalid packets" connection-state=invalid
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow tcp dns packets" dst-port=53 protocol=tcp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow udp dns packets" dst-port=53 protocol=udp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow management via https" dst-port=18856 protocol=tcp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow management via winbox" dst-port=24639 protocol=tcp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow management via ssh" dst-port=36518 protocol=tcp
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow icmpv6 echo request packets" icmp-options=128:0 protocol=icmpv6
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow icmpv6 router solicitation packets" icmp-options=133:0 protocol=icmpv6 src-address-list=ipv6-link-local-addresses
/ipv6 firewall filter add action=return chain=ipv6-input-lan-vlan-10-in comment="allow icmpv6 router advertisement packets" icmp-options=134:0 protocol=icmpv6 src-address-list=ipv6-link-local-addresses
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
