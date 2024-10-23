## Configuration commands

### Credential configuration

```
set system login user user925232615 authentication plaintext-password password478924191
set system login user user925232615 level admin
```

### Default credential removal

```
delete system login user ubnt
```

### Interfaces configuration

```
delete interfaces ethernet eth1 address
delete interfaces switch switch0 mtu
set interfaces ethernet eth0 description eth0-wan
set interfaces ethernet eth0 mac D2:21:F9:48:20:D2
set interfaces ethernet eth0 mtu 1500
set interfaces ethernet eth1 description eth1-lan
set interfaces ethernet eth1 mac D2:21:F9:DD:C8:50
set interfaces ethernet eth1 mtu 1500
set interfaces ethernet eth2 disable
set interfaces ethernet eth2 mtu 1500
set interfaces ethernet eth3 disable
set interfaces ethernet eth3 mtu 1500
set interfaces ethernet eth4 disable
set interfaces ethernet eth4 mtu 1500
set interfaces switch switch0 mtu 1500
```

### IPv4 firewall rules

```
set firewall name FORWARD_WAN_IN default-action drop
set firewall name FORWARD_WAN_IN rule 3333 action accept
set firewall name FORWARD_WAN_IN rule 3333 description "accept established,related packets"
set firewall name FORWARD_WAN_IN rule 3333 state established enable
set firewall name FORWARD_WAN_IN rule 3333 state related enable
set firewall name FORWARD_WAN_IN rule 6666 action drop
set firewall name FORWARD_WAN_IN rule 6666 description "drop invalid packets"
set firewall name FORWARD_WAN_IN rule 6666 state invalid enable
set firewall name INPUT_WAN_IN default-action drop
set firewall name INPUT_WAN_IN rule 2000 action accept
set firewall name INPUT_WAN_IN rule 2000 description "accept established,related packets"
set firewall name INPUT_WAN_IN rule 2000 state established enable
set firewall name INPUT_WAN_IN rule 2000 state related enable
set firewall name INPUT_WAN_IN rule 4000 action drop
set firewall name INPUT_WAN_IN rule 4000 description "drop invalid packets"
set firewall name INPUT_WAN_IN rule 4000 state invalid enable
set firewall name INPUT_WAN_IN rule 6000 action accept
set firewall name INPUT_WAN_IN rule 6000 description "accept icmp echo request packets"
set firewall name INPUT_WAN_IN rule 6000 icmp code 0
set firewall name INPUT_WAN_IN rule 6000 icmp type 8
set firewall name INPUT_WAN_IN rule 6000 protocol icmp
set firewall name INPUT_WAN_IN rule 8000 action drop
set firewall name INPUT_WAN_IN rule 8000 description "drop and log remaining icmp packets"
set firewall name INPUT_WAN_IN rule 8000 log enable
set firewall name INPUT_WAN_IN rule 8000 protocol icmp
```

### IPv4 LAN

```
set interfaces ethernet eth1 address 10.182.186.1/24
set service dhcp-server shared-network-name LAN authoritative enable
set service dhcp-server shared-network-name LAN subnet 10.182.186.0/24 default-router 10.182.186.1
set service dhcp-server shared-network-name LAN subnet 10.182.186.0/24 dns-server 10.182.186.1
set service dhcp-server shared-network-name LAN subnet 10.182.186.0/24 lease 172800
set service dhcp-server shared-network-name LAN subnet 10.182.186.0/24 start 10.182.186.2 stop 10.182.186.253
set service dhcp-server shared-network-name LAN subnet 10.182.186.0/24 subnet-parameters "option interface-mtu 1492;"
set service dhcp-server shared-network-name LAN subnet 10.182.186.0/24 subnet-parameters "option broadcast-address 10.182.186.255;"
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
set interfaces ethernet eth0 vif 600 pppoe 0 firewall in name FORWARD_WAN_IN
set interfaces ethernet eth0 vif 600 pppoe 0 firewall local name INPUT_WAN_IN
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
set service nat rule 7000 outbound-interface pppoe0
set service nat rule 7000 source address 10.182.186.0/24
set service nat rule 7000 type masquerade
```

### IPv4 workaround for ISP blocking of inbound UDP packets on port 123

```
set service nat rule 6000 outbound-interface pppoe0
set service nat rule 6000 outside-address port 49152-65535
set service nat rule 6000 protocol udp
set service nat rule 6000 source address 10.182.186.0/24
set service nat rule 6000 source port 123
set service nat rule 6000 type masquerade
set service nat rule 8000 outbound-interface pppoe0
set service nat rule 8000 outside-address port 49152-65535
set service nat rule 8000 protocol udp
set service nat rule 8000 source port 123
set service nat rule 8000 type source
```

### IPv6 firewall rules

```
set firewall ipv6-name IPV6_FORWARD_WAN_IN default-action drop
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 2000 action accept
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 2000 description "accept established,related packets"
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 2000 state established enable
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 2000 state related enable
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 4000 action drop
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 4000 description "drop invalid packets"
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 4000 state invalid enable
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 6000 action accept
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 6000 description "accept icmpv6 echo request packets"
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 6000 icmpv6 type 128/0
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 6000 protocol icmpv6
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 8000 action drop
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 8000 description "drop and log remaining icmpv6 packets"
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 8000 log enable
set firewall ipv6-name IPV6_FORWARD_WAN_IN rule 8000 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN default-action drop
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 1111 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 1111 description "accept established,related packets"
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 1111 state established enable
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 1111 state related enable
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 2222 action drop
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 2222 description "drop invalid packets"
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 2222 state invalid enable
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 3333 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 3333 description "accept icmpv6 echo request packets"
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 3333 icmpv6 type 128/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 3333 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 description "accept icmpv6 router solicitation packets"
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 icmpv6 type 133/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 4444 source address fe80::/10
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 description "accept icmpv6 router advertisement packets"
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 icmpv6 type 134/0
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 5555 source address fe80::/10
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 action accept
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 description "accept dhcpv6 packets"
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 destination port 546
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 protocol udp
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 source address fe80::/10
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 6666 source port 547
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 action drop
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 description "drop and log remaining icmpv6 packets"
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 log enable
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 7777 protocol icmpv6
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 action drop
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 description "drop and log remaining dhcpv6 packets"
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 destination port 546
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 log enable
set firewall ipv6-name IPV6_INPUT_WAN_IN rule 8888 protocol udp
```

### IPv6 LAN

```
set interfaces ethernet eth1 ipv6 dup-addr-detect-transmits 1
set interfaces ethernet eth1 ipv6 router-advert cur-hop-limit 64
set interfaces ethernet eth1 ipv6 router-advert default-preference medium
set interfaces ethernet eth1 ipv6 router-advert link-mtu 1492
set interfaces ethernet eth1 ipv6 router-advert managed-flag false
set interfaces ethernet eth1 ipv6 router-advert name-server fe80::d021:f9ff:fedd:c850
set interfaces ethernet eth1 ipv6 router-advert other-config-flag false
set interfaces ethernet eth1 ipv6 router-advert prefix ::/64 autonomous-flag true
set interfaces ethernet eth1 ipv6 router-advert prefix ::/64 on-link-flag true
set interfaces ethernet eth1 ipv6 router-advert send-advert true
```

### IPv6 WAN

```
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd no-dns
set interfaces ethernet eth0 vif 600 pppoe 0 dhcpv6-pd pd 0 interface eth1 host-address ::1190:1cd9:750e:8422
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

### IPv6 workaround for ISP blocking of inbound UDP packets on port 123

See **[ipv6_nat_wan.sh](./scripts/ipv6_nat_wan.sh)**

### DNS configuration

```
set service dns forwarding cache-size 10000
set service dns forwarding listen-on eth1
set service dns forwarding name-server 2001:4860:4860::8844
set service dns forwarding name-server 2001:4860:4860::8888
set service dns forwarding options bogus-priv
set service dns forwarding options domain-needed
```

### Clock configuration

```
delete system ntp server
set system time-zone America/Sao_Paulo
set system ntp server time1.google.com
set system ntp server time2.google.com
set system ntp server time3.google.com
set system ntp server time4.google.com
```

### Connection tracking timeouts

```
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

### Kernel configuration

```
set firewall ip-src-route disable
set firewall ipv6-receive-redirects disable
set firewall ipv6-src-route disable
set firewall receive-redirects disable
set firewall send-redirects enable
set firewall source-validation disable
set firewall syn-cookies enable
```

### Static DNS configuration

```
set system static-host-mapping host-name router.lan inet 10.182.186.1
```

### Modem access configuration

```
set interfaces ethernet eth0 address 10.123.203.2/24
set service nat rule 9000 outbound-interface eth0
set service nat rule 9000 source address 10.182.186.0/24
set service nat rule 9000 type masquerade
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
delete service gui
delete service ssh
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

### System DNS configuration

```
set system name-server 127.0.0.1
```

## Configuration scripts

### Upload

```
$ scp ./scripts/ipv4_nat_lan.sh user925232615@router.lan:/home/user925232615
$ scp ./scripts/ipv6_nat_lan.sh user925232615@router.lan:/home/user925232615
$ scp ./scripts/ipv4_mangle_wan.sh user925232615@router.lan:/home/user925232615
$ scp ./scripts/ipv6_mangle_wan.sh user925232615@router.lan:/home/user925232615
$ scp ./scripts/ipv6_nat_wan.sh user925232615@router.lan:/home/user925232615
```

### Setup

```
$ sudo mv /home/user925232615/ipv4_nat_lan.sh /config/scripts/post-config.d/ipv4_nat_lan.sh
$ sudo mv /home/user925232615/ipv6_nat_lan.sh /config/scripts/post-config.d/ipv6_nat_lan.sh
$ sudo mv /home/user925232615/ipv4_mangle_wan.sh /etc/ppp/ip-up.d/ipv4_mangle_wan.sh
$ sudo mv /home/user925232615/ipv6_mangle_wan.sh /etc/ppp/ipv6-up.d/ipv6_mangle_wan.sh
$ sudo mv /home/user925232615/ipv6_nat_wan.sh /etc/ppp/ipv6-up.d/ipv6_nat_wan.sh
$ sudo chown root:root /config/scripts/post-config.d/ipv4_nat_lan.sh
$ sudo chown root:root /config/scripts/post-config.d/ipv6_nat_lan.sh
$ sudo chown root:root /etc/ppp/ip-up.d/ipv4_mangle_wan.sh
$ sudo chown root:root /etc/ppp/ipv6-up.d/ipv6_mangle_wan.sh
$ sudo chown root:root /etc/ppp/ipv6-up.d/ipv6_nat_wan.sh
$ sudo chmod +x /config/scripts/post-config.d/ipv4_nat_lan.sh
$ sudo chmod +x /config/scripts/post-config.d/ipv6_nat_lan.sh
$ sudo chmod +x /etc/ppp/ip-up.d/ipv4_mangle_wan.sh
$ sudo chmod +x /etc/ppp/ipv6-up.d/ipv6_mangle_wan.sh
$ sudo chmod +x /etc/ppp/ipv6-up.d/ipv6_nat_wan.sh
```

## Final configuration

```
firewall {
    all-ping enable
    broadcast-ping disable
    ipv6-name IPV6_FORWARD_WAN_IN {
        default-action drop
        rule 2000 {
            action accept
            description "accept established,related packets"
            state {
                established enable
                related enable
            }
        }
        rule 4000 {
            action drop
            description "drop invalid packets"
            state {
                invalid enable
            }
        }
        rule 6000 {
            action accept
            description "accept icmpv6 echo request packets"
            icmpv6 {
                type 128/0
            }
            protocol icmpv6
        }
        rule 8000 {
            action drop
            description "drop and log remaining icmpv6 packets"
            log enable
            protocol icmpv6
        }
    }
    ipv6-name IPV6_INPUT_WAN_IN {
        default-action drop
        rule 1111 {
            action accept
            description "accept established,related packets"
            state {
                established enable
                related enable
            }
        }
        rule 2222 {
            action drop
            description "drop invalid packets"
            state {
                invalid enable
            }
        }
        rule 3333 {
            action accept
            description "accept icmpv6 echo request packets"
            icmpv6 {
                type 128/0
            }
            protocol icmpv6
        }
        rule 4444 {
            action accept
            description "accept icmpv6 router solicitation packets"
            icmpv6 {
                type 133/0
            }
            protocol icmpv6
            source {
                address fe80::/10
            }
        }
        rule 5555 {
            action accept
            description "accept icmpv6 router advertisement packets"
            icmpv6 {
                type 134/0
            }
            protocol icmpv6
            source {
                address fe80::/10
            }
        }
        rule 6666 {
            action accept
            description "accept dhcpv6 packets"
            destination {
                port 546
            }
            protocol udp
            source {
                address fe80::/10
                port 547
            }
        }
        rule 7777 {
            action drop
            description "drop and log remaining icmpv6 packets"
            log enable
            protocol icmpv6
        }
        rule 8888 {
            action drop
            description "drop and log remaining dhcpv6 packets"
            destination {
                port 546
            }
            log enable
            protocol udp
        }
    }
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    name FORWARD_WAN_IN {
        default-action drop
        rule 3333 {
            action accept
            description "accept established,related packets"
            state {
                established enable
                related enable
            }
        }
        rule 6666 {
            action drop
            description "drop invalid packets"
            state {
                invalid enable
            }
        }
    }
    name INPUT_WAN_IN {
        default-action drop
        rule 2000 {
            action accept
            description "accept established,related packets"
            state {
                established enable
                related enable
            }
        }
        rule 4000 {
            action drop
            description "drop invalid packets"
            state {
                invalid enable
            }
        }
        rule 6000 {
            action accept
            description "accept icmp echo request packets"
            icmp {
                code 0
                type 8
            }
            protocol icmp
        }
        rule 8000 {
            action drop
            description "drop and log remaining icmp packets"
            log enable
            protocol icmp
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
}
interfaces {
    ethernet eth0 {
        address 10.123.203.2/24
        description eth0-wan
        duplex auto
        mac D2:21:F9:48:20:D2
        mtu 1500
        speed auto
        vif 600 {
            description eth0-wan-vif-600
            pppoe 0 {
                default-route auto
                description eth0-wan-vif-600-pppoe
                dhcpv6-pd {
                    no-dns
                    pd 0 {
                        interface eth1 {
                            host-address ::1190:1cd9:750e:8422
                        }
                        prefix-length /64
                    }
                    prefix-only
                    rapid-commit enable
                }
                firewall {
                    in {
                        ipv6-name IPV6_FORWARD_WAN_IN
                        name FORWARD_WAN_IN
                    }
                    local {
                        ipv6-name IPV6_INPUT_WAN_IN
                        name INPUT_WAN_IN
                    }
                }
                ipv6 {
                    address {
                        autoconf
                    }
                    dup-addr-detect-transmits 1
                    enable {
                    }
                }
                mtu 1492
                name-server none
                password ****************
                user-id cliente@cliente
            }
        }
    }
    ethernet eth1 {
        address 10.182.186.1/24
        description eth1-lan
        duplex auto
        ipv6 {
            dup-addr-detect-transmits 1
            router-advert {
                cur-hop-limit 64
                default-preference medium
                link-mtu 1492
                managed-flag false
                max-interval 600
                name-server fe80::d021:f9ff:fedd:c850
                other-config-flag false
                prefix ::/64 {
                    autonomous-flag true
                    on-link-flag true
                    valid-lifetime 2592000
                }
                reachable-time 0
                retrans-timer 0
                send-advert true
            }
        }
        mac D2:21:F9:DD:C8:50
        mtu 1500
        speed auto
    }
    ethernet eth2 {
        disable
        duplex auto
        mtu 1500
        speed auto
    }
    ethernet eth3 {
        disable
        duplex auto
        mtu 1500
        speed auto
    }
    ethernet eth4 {
        disable
        duplex auto
        mtu 1500
        poe {
            output off
        }
        speed auto
    }
    loopback lo {
    }
    switch switch0 {
        mtu 1500
    }
}
service {
    dhcp-server {
        disabled false
        hostfile-update disable
        shared-network-name LAN {
            authoritative enable
            subnet 10.182.186.0/24 {
                default-router 10.182.186.1
                dns-server 10.182.186.1
                lease 172800
                start 10.182.186.2 {
                    stop 10.182.186.253
                }
                subnet-parameters "option interface-mtu 1492;"
                subnet-parameters "option broadcast-address 10.182.186.255;"
            }
        }
        static-arp disable
        use-dnsmasq disable
    }
    dns {
        forwarding {
            cache-size 10000
            listen-on eth1
            name-server 2001:4860:4860::8844
            name-server 2001:4860:4860::8888
            options bogus-priv
            options domain-needed
        }
    }
    gui {
        http-port 80
        https-port 443
        older-ciphers disable
    }
    nat {
        rule 6000 {
            outbound-interface pppoe0
            outside-address {
                port 49152-65535
            }
            protocol udp
            source {
                address 10.182.186.0/24
                port 123
            }
            type masquerade
        }
        rule 7000 {
            outbound-interface pppoe0
            source {
                address 10.182.186.0/24
            }
            type masquerade
        }
        rule 8000 {
            outbound-interface pppoe0
            outside-address {
                port 49152-65535
            }
            protocol udp
            source {
                port 123
            }
            type source
        }
        rule 9000 {
            outbound-interface eth0
            source {
                address 10.182.186.0/24
            }
            type masquerade
        }
    }
    ssh {
        port 22
        protocol-version v2
    }
    ubnt-discover {
        disable
    }
    unms {
        disable
    }
}
system {
    analytics-handler {
        send-analytics-report false
    }
    conntrack {
        expect-table-size 2048
        hash-size 32768
        table-size 262144
        timeout {
            icmp 30
            other 600
            tcp {
                close 10
                close-wait 60
                established 432000
                fin-wait 120
                last-ack 30
                syn-recv 60
                syn-sent 120
                time-wait 120
            }
            udp {
                other 30
                stream 180
            }
        }
    }
    crash-handler {
        send-crash-report false
    }
    host-name Home-Router
    login {
        user user925232615 {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
            level admin
        }
    }
    name-server 127.0.0.1
    ntp {
        server time1.google.com {
        }
        server time2.google.com {
        }
        server time3.google.com {
        }
        server time4.google.com {
        }
    }
    offload {
        hwnat disable
        ipsec disable
    }
    static-host-mapping {
        host-name router.lan {
            inet 10.182.186.1
        }
    }
    syslog {
        global {
            facility all {
                level notice
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone America/Sao_Paulo
    traffic-analysis {
        dpi disable
    }
}
```

## End result

### IPv4 addresses

```
$ sudo ip -brief -4 address
lo               UNKNOWN        127.0.0.1/8
eth0@itf0        UP             10.123.203.2/24
eth1@itf0        UP             10.182.186.1/24
pppoe0           UNKNOWN        191.32.33.7 peer 179.184.126.60/32
```

### IPv4 routes

```
$ sudo ip -4 route
default dev pppoe0 scope link
10.123.203.0/24 dev eth0 proto kernel scope link src 10.123.203.2
10.182.186.0/24 dev eth1 proto kernel scope link src 10.182.186.1
179.184.126.60 dev pppoe0 proto kernel scope link src 191.32.33.7
191.32.33.7 dev pppoe0 proto kernel scope link
```

### IPv6 addresses

```
$ sudo ip -brief -6 address
lo               UNKNOWN        ::1/128
itf0             UNKNOWN        fe80::d221:f9ff:fee1:353/64
eth0@itf0        UP             fe80::d021:f9ff:fe48:20d2/64
eth1@itf0        UP             2804:7f4:c183:342f:1190:1cd9:750e:8422/64 fe80::d021:f9ff:fedd:c850/64
switch0@itf0     UP             fe80::d221:f9ff:fee1:353/64
eth0.600@eth0    UP             fe80::d021:f9ff:fe48:20d2/64
pppoe0           UNKNOWN        2804:7f4:c00f:e8e:2003:4065:f8d8:d37c/64 fe80::2003:4065:f8d8:d37c/10
```

### IPv6 routes

```
$ sudo ip -6 route
2804:7f4:c00f:e8e::/64 dev pppoe0 proto kernel metric 256 expires 86249sec pref medium
2804:7f4:c183:342f::/64 dev eth1 proto kernel metric 256 pref medium
fe80::/64 dev itf0 proto kernel metric 256 pref medium
fe80::/64 dev switch0 proto kernel metric 256 pref medium
fe80::/64 dev eth0 proto kernel metric 256 pref medium
fe80::/64 dev eth1 proto kernel metric 256 pref medium
fe80::/64 dev eth0.600 proto kernel metric 256 pref medium
fe80::/10 dev pppoe0 metric 1 pref medium
fe80::/10 dev pppoe0 proto kernel metric 256 pref medium
default via fe80::e681:84ff:fe57:f00f dev pppoe0 proto ra metric 1024 expires 4349sec hoplimit 64 pref medium
```

## Resources

* [commands.txt](./commands.txt)
* [configuration.txt](./configuration.txt)
* [ipv4_nat_lan.sh](./scripts/ipv4_nat_lan.sh)
* [ipv6_nat_lan.sh](./scripts/ipv6_nat_lan.sh)
* [ipv4_mangle_wan.sh](./scripts/ipv4_mangle_wan.sh)
* [ipv6_mangle_wan.sh](./scripts/ipv6_mangle_wan.sh)
* [ipv6_nat_wan.sh](./scripts/ipv6_nat_wan.sh)
