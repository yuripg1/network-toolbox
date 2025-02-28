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
[1740709817.856374] 64 bytes from 8.8.8.8: icmp_seq=1 ttl=119 time=18.5 ms
[1740709818.858457] 64 bytes from 8.8.8.8: icmp_seq=2 ttl=119 time=18.7 ms
[1740709819.860513] 64 bytes from 8.8.8.8: icmp_seq=3 ttl=119 time=18.6 ms
[1740709820.862491] 64 bytes from 8.8.8.8: icmp_seq=4 ttl=119 time=18.5 ms
[1740709821.864481] 64 bytes from 8.8.8.8: icmp_seq=5 ttl=119 time=18.6 ms
[1740709822.866436] 64 bytes from 8.8.8.8: icmp_seq=6 ttl=119 time=18.5 ms
[1740709823.868428] 64 bytes from 8.8.8.8: icmp_seq=7 ttl=119 time=18.7 ms
[1740709824.870503] 64 bytes from 8.8.8.8: icmp_seq=8 ttl=119 time=18.7 ms
[1740709825.872532] 64 bytes from 8.8.8.8: icmp_seq=9 ttl=119 time=18.6 ms
[1740709826.874543] 64 bytes from 8.8.8.8: icmp_seq=10 ttl=119 time=18.6 ms

--- 8.8.8.8 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9018ms
rtt min/avg/max/mdev = 18.478/18.599/18.712/0.069 ms
```

### IPv6

```
$ ping -c 10 -D -O -6 2001:4860:4860::8888
PING 2001:4860:4860::8888(2001:4860:4860::8888) 56 data bytes
[1740709828.259950] 64 bytes from 2001:4860:4860::8888: icmp_seq=1 ttl=55 time=23.3 ms
[1740709829.261543] 64 bytes from 2001:4860:4860::8888: icmp_seq=2 ttl=55 time=23.2 ms
[1740709830.262989] 64 bytes from 2001:4860:4860::8888: icmp_seq=3 ttl=55 time=23.0 ms
[1740709831.264719] 64 bytes from 2001:4860:4860::8888: icmp_seq=4 ttl=55 time=23.2 ms
[1740709832.266269] 64 bytes from 2001:4860:4860::8888: icmp_seq=5 ttl=55 time=23.1 ms
[1740709833.267810] 64 bytes from 2001:4860:4860::8888: icmp_seq=6 ttl=55 time=23.1 ms
[1740709834.269261] 64 bytes from 2001:4860:4860::8888: icmp_seq=7 ttl=55 time=23.0 ms
[1740709835.270835] 64 bytes from 2001:4860:4860::8888: icmp_seq=8 ttl=55 time=23.2 ms
[1740709836.271590] 64 bytes from 2001:4860:4860::8888: icmp_seq=9 ttl=55 time=23.2 ms
[1740709837.273117] 64 bytes from 2001:4860:4860::8888: icmp_seq=10 ttl=55 time=23.1 ms

--- 2001:4860:4860::8888 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9013ms
rtt min/avg/max/mdev = 23.023/23.148/23.263/0.076 ms
```

## Traceroute

### IPv4

```
$ mtr -4 --report-wide --report-cycles 250 --show-ips --aslookup 8.8.8.8
Start: 2025-02-27T23:30:38-0300
HOST: pc                                                             Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    _gateway (10.175.202.1)                                 0.0%   250    0.6   0.6   0.4   0.7   0.1
  2. AS???    ???                                                    100.0   250    0.0   0.0   0.0   0.0   0.0
  3. AS27699  201-1-227-250.dsl.telesp.net.br (201.1.227.250)         0.0%   250    2.5   2.5   2.3   3.4   0.1
  4. AS???    152-255-167-66.user.vivozap.com.br (152.255.167.66)    62.8%   250    2.9   2.6   2.4   3.0   0.1
  5. AS???    152-255-204-133.user.vivozap.com.br (152.255.204.133)  51.2%   250   12.0  12.4  11.7  75.8   5.8
  6. AS???    187-100-60-247.dsl.telesp.net.br (187.100.60.247)      72.8%   250   16.9  29.3  16.5 645.2  78.4
  7. AS???    187-100-54-171.dsl.telesp.net.br (187.100.54.171)       0.0%   250   22.9  22.8  21.8  40.3   2.7
  8. AS???    ???                                                    100.0   250    0.0   0.0   0.0   0.0   0.0
  9. AS15169  74.125.52.64                                            0.0%   250   22.4  22.4  22.0  22.6   0.1
 10. AS15169  142.250.63.175                                          0.0%   250   22.8  22.7  22.2  23.4   0.2
 11. AS15169  192.178.240.75                                          0.0%   250   22.8  22.6  22.4  23.0   0.1
 12. AS15169  dns.google (8.8.8.8)                                    0.0%   250   18.7  18.6  18.4  18.9   0.1
```

### IPv6

```
$ mtr -6 --report-wide --report-cycles 250 --show-ips --aslookup 2001:4860:4860::8888
Start: 2025-02-27T23:34:56-0300
HOST: pc                                              Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS18881  2804:7f4:ca02:5009:72c7:90fa:ba4d:9e56   0.0%   250    0.7   0.7   0.6   0.9   0.1
  2. AS???    ???                                     100.0   250    0.0   0.0   0.0   0.0   0.0
  3. AS???    2001:12e0:500:c046:201:1:227:250         0.0%   250    2.6   2.5   2.3   4.3   0.2
  4. AS???    2001:12e0:100:3003:a002:3004:a005:0      0.0%   250    2.6   2.6   2.3   3.2   0.1
  5. AS???    2001:12e0:100:3003:a002:3020:a002:13     0.0%   250   11.8  11.8  11.7  12.7   0.1
  6. AS???    2001:12e0:100:1016:a002:3020:a002:2      0.0%   250   22.8  22.7  22.5  23.3   0.1
  7. AS???    2001:12e0:100:1016:a002:1016:a002:17     0.0%   250   18.8  18.8  18.6  21.3   0.3
  8. AS???    2001:12e0:100:1025:a001:1016:a002:26    72.8%   250   23.2  22.8  22.6  23.2   0.1
  9. AS15169  2001:4860:1:1::c4a                      27.2%   250   18.9  18.8  18.6  25.8   0.5
 10. AS15169  2800:3f0:803e::1                         0.0%   250   19.0  18.8  18.6  19.1   0.1
 11. AS15169  dns.google (2001:4860:4860::8888)        0.0%   250   23.4  23.2  23.0  23.5   0.1
```

## Speedtest CLI

https://www.speedtest.net/apps/cli

```
$ ./speedtest --progress=no --selection-details

   Speedtest by Ookla

Selecting server:
      65079:  26.22 ms; SenGi Internet - São Vicente
      40803:  19.78 ms; Seguro Net - Campinas
      14143:  18.47 ms; Claro Net Vírtua - Porto Alegre
      36132:   2.66 ms; RSSul Telecom - Porto Alegre
      17678:   2.72 ms; RLNET - Porto Alegre
      38008:  25.83 ms; EdgeUno - Porto Alegre
      38210:  17.73 ms; i9NET - Porto Alegre
      27206:   3.37 ms; RJ CONNECT - Porto Alegre
      54846:   2.60 ms; Amigo Internet - Porto Alegre
      40075:   2.31 ms; Vtal - Porto Alegre
      51576:  18.85 ms; CFG NET PROVEDOR - Porto Alegre
      13905:   3.30 ms; Melnet - Porto Alegre
      Server: Vtal - Porto Alegre (id: 40075)
         ISP: Vivo
Idle Latency:     2.65 ms   (jitter: 0.14ms, low: 2.56ms, high: 2.76ms)
    Download:   907.07 Mbps (data used: 466.0 MB)
                  6.15 ms   (jitter: 6.11ms, low: 2.55ms, high: 223.67ms)
      Upload:   511.36 Mbps (data used: 231.1 MB)
                 13.29 ms   (jitter: 0.58ms, low: 3.00ms, high: 15.02ms)
 Packet Loss:     0.0%
  Result URL: https://www.speedtest.net/result/c/ce0cce4f-8176-40c4-935a-dea2d6fd7ae2
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
