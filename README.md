## Router commands & configurations

* [MikroTik RouterOS](./mikrotik_routeros/)
* [Ubiquiti EdgeOS](./ubiquiti_edgeos)

## Scripts

* [NTP test script](./scripts/ntp_test)

## Network diagram

![Network Diagram](./img/network_diagram.png)

## Connectivity

![Connectivity Test Output - Vivo](./img/connectivity_test_output_vivo.png)

## ICMP

### IPv4

![ICMP Test IPv4 - Output - Vivo - 1](./img/icmp_test_ipv4_output_vivo_1.png)

![ICMP Test IPv4 - Output - Vivo - 2](./img/icmp_test_ipv4_output_vivo_2.png)

### IPv6

![ICMP Test IPv6 - Output - Vivo - 1](./img/icmp_test_ipv6_output_vivo_1.png)

![ICMP Test IPv6 - Output - Vivo - 2](./img/icmp_test_ipv6_output_vivo_2.png)

## Ping

### IPv4

```
$ ping -c 10 -D -O -4 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
[1737057077.615929] 64 bytes from 8.8.8.8: icmp_seq=1 ttl=60 time=29.6 ms
[1737057078.615305] 64 bytes from 8.8.8.8: icmp_seq=2 ttl=60 time=27.1 ms
[1737057079.616824] 64 bytes from 8.8.8.8: icmp_seq=3 ttl=60 time=27.3 ms
[1737057080.618507] 64 bytes from 8.8.8.8: icmp_seq=4 ttl=60 time=27.3 ms
[1737057081.623021] 64 bytes from 8.8.8.8: icmp_seq=5 ttl=60 time=30.0 ms
[1737057082.626270] 64 bytes from 8.8.8.8: icmp_seq=6 ttl=60 time=32.7 ms
[1737057083.621346] 64 bytes from 8.8.8.8: icmp_seq=7 ttl=60 time=27.0 ms
[1737057084.627029] 64 bytes from 8.8.8.8: icmp_seq=8 ttl=60 time=31.1 ms
[1737057085.625369] 64 bytes from 8.8.8.8: icmp_seq=9 ttl=60 time=27.8 ms
[1737057086.627038] 64 bytes from 8.8.8.8: icmp_seq=10 ttl=60 time=28.1 ms

--- 8.8.8.8 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9013ms
rtt min/avg/max/mdev = 26.987/28.801/32.722/1.871 ms
```

### IPv6

```
$ ping -c 10 -D -O -6 2001:4860:4860::8888
PING 2001:4860:4860::8888 (2001:4860:4860::8888) 56 data bytes
[1737057087.901519] 64 bytes from 2001:4860:4860::8888: icmp_seq=1 ttl=115 time=18.7 ms
[1737057088.902059] 64 bytes from 2001:4860:4860::8888: icmp_seq=2 ttl=115 time=18.6 ms
[1737057089.902988] 64 bytes from 2001:4860:4860::8888: icmp_seq=3 ttl=115 time=18.5 ms
[1737057090.904174] 64 bytes from 2001:4860:4860::8888: icmp_seq=4 ttl=115 time=18.7 ms
[1737057091.905922] 64 bytes from 2001:4860:4860::8888: icmp_seq=5 ttl=115 time=18.4 ms
[1737057092.911393] 64 bytes from 2001:4860:4860::8888: icmp_seq=6 ttl=115 time=22.0 ms
[1737057093.913938] 64 bytes from 2001:4860:4860::8888: icmp_seq=7 ttl=115 time=23.0 ms
[1737057094.913894] 64 bytes from 2001:4860:4860::8888: icmp_seq=8 ttl=115 time=21.5 ms
[1737057095.913917] 64 bytes from 2001:4860:4860::8888: icmp_seq=9 ttl=115 time=19.5 ms
[1737057096.914268] 64 bytes from 2001:4860:4860::8888: icmp_seq=10 ttl=115 time=18.6 ms

--- 2001:4860:4860::8888 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9013ms
rtt min/avg/max/mdev = 18.428/19.757/23.036/1.637 ms
```

## Traceroute

### IPv4

```
$ mtr -4 --report-wide --report-cycles 250 --show-ips --aslookup 8.8.8.8
Start: 2025-01-16T16:51:38-0300
HOST: laptop                                                         Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    _gateway (10.175.202.1)                                 0.0%   250    0.7   0.5   0.3   0.8   0.1
  2. AS???    ???                                                    100.0   250    0.0   0.0   0.0   0.0   0.0
  3. AS27699  201-1-227-250.dsl.telesp.net.br (201.1.227.250)         0.0%   250    2.8   2.9   2.2  11.4   1.2
  4. AS???    152-255-156-210.user.vivozap.com.br (152.255.156.210)  72.8%   250    3.1   2.8   2.1  11.3   1.1
  5. AS???    152-255-193-158.user.vivozap.com.br (152.255.193.158)  72.4%   250   23.5  21.6  20.9  25.7   0.8
  6. AS???    152-255-203-134.user.vivozap.com.br (152.255.203.134)  84.4%   250  520.4 121.7  22.4 1540. 318.1
  7. AS???    ???                                                    100.0   250    0.0   0.0   0.0   0.0   0.0
  8. AS12956  84.16.7.106                                             0.0%   250   27.6  28.0  27.1  52.5   1.9
  9. AS12956  94.142.103.197                                          0.0%   250   27.7  27.9  27.3  32.0   0.8
 10. AS15169  142.251.69.135                                          0.0%   250   24.0  23.0  22.1  28.3   0.9
 11. AS15169  108.170.248.213                                         0.0%   250   23.6  23.9  23.2  31.8   0.8
 12. AS15169  dns.google (8.8.8.8)                                    0.0%   250   27.6  27.6  27.1  34.3   0.8
```

### IPv6

```
$ mtr -6 --report-wide --report-cycles 250 --show-ips --aslookup 2001:4860:4860::8888
Start: 2025-01-16T16:56:03-0300
HOST: laptop                                          Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS18881  2804:7f4:ca01:a161:72c7:90fa:ba4d:9e56   0.0%   250    0.5   0.6   0.4   0.9   0.1
  2. AS???    ???                                     100.0   250    0.0   0.0   0.0   0.0   0.0
  3. AS???    2001:12e0:500:0:1:0:40:6ba               0.0%   250    8.0   4.6   2.2  11.6   2.8
  4. AS???    2001:12e0:100:3003:a002:3004:a005:0      0.0%   250    7.7   4.5   2.3  11.6   2.7
  5. AS???    2001:12e0:100:3003:a002:3020:a002:d      0.0%   250   12.1  14.3  11.7  25.0   3.3
  6. AS???    2001:12e0:100:1017:a002:3020:a002:6     12.0%   250   21.8  23.7  21.5  34.7   2.7
  7. AS???    2001:12e0:100:1025:a001:1017:a002:30    90.0%   250   23.6  24.2  21.7  33.5   3.1
  8. AS15169  2001:4860:1:1::c4a                      15.6%   250   23.2  26.0  22.8  42.8   3.7
  9. AS15169  2800:3f0:8362:100::1                     0.0%   250   23.0  25.0  22.5  35.7   2.8
 10. AS15169  dns.google (2001:4860:4860::8888)        0.0%   250   22.4  20.9  18.5  31.9   3.1
```

## Speedtest CLI

https://www.speedtest.net/apps/cli

```
$ ./speedtest --progress=no --selection-details

   Speedtest by Ookla

Selecting server:
      65079:  28.93 ms; SenGi Internet - São Vicente
      40803:  33.04 ms; Seguro Net - Campinas
      14143:  23.06 ms; Claro Net Vírtua - Porto Alegre
      36132:   2.36 ms; RSSul Telecom - Porto Alegre
      17678:   2.52 ms; RLNET - Porto Alegre
      38008:  12.01 ms; EdgeUno - Porto Alegre
      38210:  18.03 ms; i9NET - Porto Alegre
      38068:  24.09 ms; LPInternet - Porto Alegre
      39941:  21.56 ms; Onnexx - Porto Alegre
      52447:   2.47 ms; GNS POA - Porto Alegre
      33982:  20.59 ms; CLICNET - Porto Alegre
      27206:   3.09 ms; RJ CONNECT - Porto Alegre
      Server: RSSul Telecom - Porto Alegre (id: 36132)
         ISP: Vivo
Idle Latency:     2.55 ms   (jitter: 0.08ms, low: 2.46ms, high: 2.60ms)
    Download:   800.46 Mbps (data used: 1.2 GB)
                  4.52 ms   (jitter: 2.64ms, low: 1.58ms, high: 208.02ms)
      Upload:   511.44 Mbps (data used: 230.2 MB)
                 13.87 ms   (jitter: 0.77ms, low: 2.61ms, high: 15.73ms)
 Packet Loss:     0.0%
  Result URL: https://www.speedtest.net/result/c/2f11b3da-63a3-44ee-a2f7-e962707ecec8
```

## Helpful online diagnostics

### IPv6 & DNSSEC

* https://top.nic.br/connection/

### IPv6

* https://ip6.biz/
* https://test-ipv6.com/
* https://ipv6test.google.com/
* https://ipv6-test.com/

### ICMP

* http://icmpcheck.popcount.org/

### ICMPv6

* http://icmpcheckv6.popcount.org/

### TCP MSS (IPv4 only)

* https://www.speedguide.net/analyzer.php

### Bufferbloat

* https://www.waveform.com/tools/bufferbloat

### DNS

* https://1.1.1.1/help
* https://www.dnsleaktest.com/


### Packet loss

* https://packetlosstest.com/

### Speed test

* https://www.speedtest.net/
* https://beta.simet.nic.br/
* https://speed.cloudflare.com/
* https://fast.com/
