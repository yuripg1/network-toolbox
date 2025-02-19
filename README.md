## Router commands & configurations

* [MikroTik RouterOS](./mikrotik_routeros/)
* [Ubiquiti EdgeOS](./ubiquiti_edgeos)

## Scripts

* [NTP test script](./scripts/ntp_test)
* [Ping analyzer script](./scripts/ping_analyzer/ping_analyzer.py)

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
[1739905980.031232] 64 bytes from 8.8.8.8: icmp_seq=1 ttl=119 time=17.8 ms
[1739905981.033438] 64 bytes from 8.8.8.8: icmp_seq=2 ttl=119 time=17.7 ms
[1739905982.035403] 64 bytes from 8.8.8.8: icmp_seq=3 ttl=119 time=17.6 ms
[1739905983.037410] 64 bytes from 8.8.8.8: icmp_seq=4 ttl=119 time=17.6 ms
[1739905984.039430] 64 bytes from 8.8.8.8: icmp_seq=5 ttl=119 time=17.6 ms
[1739905985.041706] 64 bytes from 8.8.8.8: icmp_seq=6 ttl=119 time=17.8 ms
[1739905986.043711] 64 bytes from 8.8.8.8: icmp_seq=7 ttl=119 time=17.6 ms
[1739905987.045995] 64 bytes from 8.8.8.8: icmp_seq=8 ttl=119 time=17.8 ms
[1739905988.048260] 64 bytes from 8.8.8.8: icmp_seq=9 ttl=119 time=17.8 ms
[1739905989.050240] 64 bytes from 8.8.8.8: icmp_seq=10 ttl=119 time=17.6 ms

--- 8.8.8.8 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9019ms
rtt min/avg/max/mdev = 17.566/17.685/17.806/0.099 ms
```

### IPv6

```
$ ping -c 10 -D -O -6 2001:4860:4860::8888
PING 2001:4860:4860::8888(2001:4860:4860::8888) 56 data bytes
[1739905992.701836] 64 bytes from 2001:4860:4860::8888: icmp_seq=1 ttl=55 time=17.6 ms
[1739905993.704033] 64 bytes from 2001:4860:4860::8888: icmp_seq=2 ttl=55 time=17.8 ms
[1739905994.706308] 64 bytes from 2001:4860:4860::8888: icmp_seq=3 ttl=55 time=17.8 ms
[1739905995.707571] 64 bytes from 2001:4860:4860::8888: icmp_seq=4 ttl=55 time=17.9 ms
[1739905996.709800] 64 bytes from 2001:4860:4860::8888: icmp_seq=5 ttl=55 time=17.8 ms
[1739905997.712092] 64 bytes from 2001:4860:4860::8888: icmp_seq=6 ttl=55 time=17.8 ms
[1739905998.713588] 64 bytes from 2001:4860:4860::8888: icmp_seq=7 ttl=55 time=17.9 ms
[1739905999.714856] 64 bytes from 2001:4860:4860::8888: icmp_seq=8 ttl=55 time=17.8 ms
[1739906000.717099] 64 bytes from 2001:4860:4860::8888: icmp_seq=9 ttl=55 time=17.8 ms
[1739906001.719029] 64 bytes from 2001:4860:4860::8888: icmp_seq=10 ttl=55 time=17.7 ms

--- 2001:4860:4860::8888 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9017ms
rtt min/avg/max/mdev = 17.605/17.784/17.858/0.070 ms
```

## Traceroute

### IPv4

```
$ mtr -4 --report-wide --report-cycles 250 --show-ips --aslookup 8.8.8.8
Start: 2025-02-18T16:13:25-0300
HOST: pc                                                             Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    _gateway (10.175.202.1)                                 0.0%   250    0.7   0.6   0.5   0.9   0.1
  2. AS???    ???                                                    100.0   250    0.0   0.0   0.0   0.0   0.0
  3. AS27699  201-1-227-248.dsl.telesp.net.br (201.1.227.248)         0.0%   250    2.5   2.5   2.2   7.2   0.3
  4. AS???    152-255-167-66.user.vivozap.com.br (152.255.167.66)    78.4%   250    2.6   2.6   2.2   3.1   0.2
  5. AS???    152-255-193-173.user.vivozap.com.br (152.255.193.173)  66.8%   250   12.0  17.0  11.6 357.1  38.8
  6. AS???    152-255-161-168.user.vivozap.com.br (152.255.161.168)  90.8%   250  309.5  29.5  16.7 309.5  61.0
        152-255-203-160.user.vivozap.com.br (152.255.203.160)
     AS???    152-255-203-160.user.vivozap.com.br (152.255.203.160)
  7. AS???    187-100-54-157.dsl.telesp.net.br (187.100.54.157)      21.2%   250   22.4  21.0  16.8  23.7   2.2
        187-100-54-165.dsl.telesp.net.br (187.100.54.165)
     AS???    187-100-54-165.dsl.telesp.net.br (187.100.54.165)
  8. AS???    ???                                                    100.0   250    0.0   0.0   0.0   0.0   0.0
  9. AS12956  84.16.7.106                                             0.4%   250   22.9  21.8  17.6  23.9   2.2
 10. AS12956  94.142.103.197                                          0.0%   250   22.9  22.1  17.4  23.2   1.9
 11. AS15169  142.251.69.141                                          0.0%   250   18.8  19.1  18.2  53.6   3.1
 12. AS15169  108.170.232.147                                         0.0%   250   18.1  17.8  17.6  18.3   0.1
 13. AS15169  dns.google (8.8.8.8)                                    0.0%   250   17.9  18.2  17.5  23.3   1.5
```

### IPv6

```
$ mtr -6 --report-wide --report-cycles 250 --show-ips --aslookup 2001:4860:4860::8888
Start: 2025-02-18T16:17:49-0300
HOST: pc                                              Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS18881  2804:7f4:ca02:3171:72c7:90fa:ba4d:9e56   0.0%   250    0.8   0.7   0.5   0.9   0.1
  2. AS???    ???                                     100.0   250    0.0   0.0   0.0   0.0   0.0
  3. AS???    2001:12e0:500:0:1:0:40:6ba               0.0%   250    2.5   2.5   2.1   4.5   0.2
  4. AS???    2001:12e0:100:3003:a002:3004:a005:0      6.8%   250    2.6   2.6   2.3   3.0   0.1
  5. AS???    2001:12e0:100:3003:a002:3020:a002:13     4.0%   250   12.1  11.9  11.5  13.1   0.2
  6. AS???    2001:12e0:100:1016:a002:3020:a002:21    26.0%   250   22.2  22.0  21.5  22.9   0.2
        2001:12e0:100:1017:a002:3020:a002:6
     AS???    2001:12e0:100:1017:a002:3020:a002:6
  7. AS???    2001:12e0:100:1016:a002:1016:a002:11     0.0%   250   16.9  17.4  16.6  23.2   1.6
        2001:12e0:100:1017:a002:1017:a002:11
     AS???    2001:12e0:100:1017:a002:1017:a002:11
  8. AS???    2001:12e0:100:1016:a002:1016:a001:23    42.0%   250   16.8  17.9  16.7  22.4   2.0
        2001:12e0:100:1016:a001:1017:a002:2a
     AS???    2001:12e0:100:1016:a001:1017:a002:2a
  9. AS15169  2001:4860:1:1::f36                       0.0%   250   23.2  22.6  17.6  24.7   1.6
 10. AS15169  2800:3f0:8364:2c0::1                     0.0%   250   18.2  18.5  17.8  23.6   1.4
 11. AS15169  dns.google (2001:4860:4860::8888)        0.0%   250   17.8  17.8  17.6  18.1   0.1
```

## Speedtest CLI

https://www.speedtest.net/apps/cli

```
$ ./speedtest --progress=no --selection-details

   Speedtest by Ookla

Selecting server:
      65079:  24.01 ms; SenGi Internet - São Vicente
      42154:  24.79 ms; Moovenet - Valinhos
      14143:  23.79 ms; Claro Net Vírtua - Porto Alegre
      36132:   2.55 ms; RSSul Telecom - Porto Alegre
      17678:   2.79 ms; RLNET - Porto Alegre
      38008:  25.53 ms; EdgeUno - Porto Alegre
      38210:  35.72 ms; i9NET - Porto Alegre
      39941:  16.83 ms; Onnexx - Porto Alegre
      52447:  24.31 ms; GNS POA - Porto Alegre
      27206:  25.94 ms; RJ CONNECT - Porto Alegre
      54846:   2.37 ms; Amigo Internet - Porto Alegre
      40075:   2.35 ms; Vtal - Porto Alegre
      Server: Vtal - Porto Alegre (id: 40075)
         ISP: Vivo
Idle Latency:     2.87 ms   (jitter: 0.05ms, low: 2.80ms, high: 3.00ms)
    Download:   798.57 Mbps (data used: 1.2 GB)
                  4.85 ms   (jitter: 2.73ms, low: 1.79ms, high: 213.28ms)
      Upload:   511.60 Mbps (data used: 232.1 MB)
                  9.74 ms   (jitter: 1.03ms, low: 2.48ms, high: 15.95ms)
 Packet Loss:     0.0%
  Result URL: https://www.speedtest.net/result/c/156a3cd9-628e-4787-8fb5-ab3e5b62689e
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
