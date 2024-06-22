## Network diagram

![Network Diagram](./img/network_diagram.png)

## Router commands & configurations

### MikroTik RouterOS

* [Commands](./mikrotik_routeros_commands.rsc)
* [Configuration](./mikrotik_routeros_configuration.rsc)

### Ubiquiti EdgeOS

* [Commands](./ubiquiti_edgeos_commands.txt)
* [Configuration](./ubiquiti_edgeos_configuration.txt)
* [IPv4 NAT rules (LAN)](./ipv4_nat_lan.sh)
* [IPv6 NAT rules (LAN)](./ipv6_nat_lan.sh)
* [IPv4 Mangle rules (WAN)](./ipv4_mangle_wan.sh)
* [IPv6 Mangle rules (WAN)](./ipv6_mangle_wan.sh)
* [IPv6 NAT rules (WAN)](./ipv6_nat_wan.sh)

## NTP test script

### Resources

* [Source code](./ntp_test.py)
* [Vivo Telefônica Brasil (Brazilian ISP) output](./ntp_test_output_vivo.csv)

### Setup

```
$ sudo apt update
$ sudo apt -y install python3-pip python3-dev python3-venv
$ python3 -m venv network-toolbox-venv
$ source ./network-toolbox-venv/bin/activate
$ pip3 install dnspython scapy
```

### Run

```
$ sudo ./network-toolbox-venv/bin/python3 ./ntp_test.py
```

### Teardown

```
$ deactivate
```

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
$ ping -c 10 -D -M do -O -s 1452 -v -4 google.com
PING  (172.217.28.14) 1452(1480) bytes of data.
[1719075616.724296] 76 bytes from gru14s08-in-f14.1e100.net (172.217.28.14): icmp_seq=1 ttl=55 (truncated)
[1719075617.704538] 76 bytes from gru14s08-in-f14.1e100.net (172.217.28.14): icmp_seq=2 ttl=55 (truncated)
[1719075618.705755] 76 bytes from eze03s15-in-f14.1e100.net (172.217.28.14): icmp_seq=3 ttl=55 (truncated)
[1719075619.708139] 76 bytes from eze03s15-in-f14.1e100.net (172.217.28.14): icmp_seq=4 ttl=55 (truncated)
[1719075620.709549] 76 bytes from eze03s15-in-f14.1e100.net (172.217.28.14): icmp_seq=5 ttl=55 (truncated)
[1719075621.710778] 76 bytes from gru14s08-in-f14.1e100.net (172.217.28.14): icmp_seq=6 ttl=55 (truncated)
[1719075622.713019] 76 bytes from eze03s15-in-f14.1e100.net (172.217.28.14): icmp_seq=7 ttl=55 (truncated)
[1719075623.714296] 76 bytes from eze03s15-in-f14.1e100.net (172.217.28.14): icmp_seq=8 ttl=55 (truncated)
[1719075624.715639] 76 bytes from gru14s08-in-f14.1e100.net (172.217.28.14): icmp_seq=9 ttl=55 (truncated)
[1719075625.717051] 76 bytes from eze03s15-in-f14.1e100.net (172.217.28.14): icmp_seq=10 ttl=55 (truncated)

---  ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9013ms
rtt min/avg/max/mdev = 19.914/20.010/20.137/0.064 ms
```

### IPv6

```
$ ping -c 10 -D -M do -O -s 1432 -v -6 google.com
PING google.com(2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e)) 1432 data bytes
[1719075637.151093] 76 bytes from 2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e): icmp_seq=1 ttl=55 (truncated)
[1719075638.152206] 76 bytes from 2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e): icmp_seq=2 ttl=55 (truncated)
[1719075639.152529] 76 bytes from 2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e): icmp_seq=3 ttl=55 (truncated)
[1719075640.156356] 76 bytes from 2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e): icmp_seq=4 ttl=55 (truncated)
[1719075641.157468] 76 bytes from 2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e): icmp_seq=5 ttl=55 (truncated)
[1719075642.159446] 76 bytes from 2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e): icmp_seq=6 ttl=55 (truncated)
[1719075643.161418] 76 bytes from 2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e): icmp_seq=7 ttl=55 (truncated)
[1719075644.163357] 76 bytes from 2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e): icmp_seq=8 ttl=55 (truncated)
[1719075645.165213] 76 bytes from 2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e): icmp_seq=9 ttl=55 (truncated)
[1719075646.166763] 76 bytes from 2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e): icmp_seq=10 ttl=55 (truncated)

--- google.com ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9016ms
rtt min/avg/max/mdev = 20.734/20.930/21.560/0.272 ms
```

## Traceroute

### IPv4

```
$ mtr -4 --report-wide --report-cycles 100 --show-ips --aslookup google.com
Start: 2024-06-22T14:01:14-0300
HOST: pc                                                           Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    router.lan (10.175.202.1)                             0.0%   100    0.6   0.6   0.5   0.7   0.0
  2. AS18881  179.184.126.60                                        0.0%   100    2.4   2.5   2.2   3.7   0.3
  3. AS18881  191.30.9.225.dynamic.adsl.gvt.net.br (191.30.9.225)   0.0%   100    2.5   2.8   2.4   3.4   0.2
  4. AS???    ???                                                  100.0   100    0.0   0.0   0.0   0.0   0.0
  5. AS15169  72.14.194.130                                         0.0%   100   21.2  21.1  20.8  21.3   0.1
  6. AS15169  172.253.50.119                                        1.0%   100   21.2  21.4  21.0  24.7   0.7
  7. AS15169  216.239.48.123                                        0.0%   100   21.6  22.0  21.3  44.6   2.3
  8. AS15169  eze03s15-in-f14.1e100.net (172.217.28.14)             0.0%   100   19.9  19.9  19.8  20.1   0.1
```

### IPv6

```
$ mtr -6 --report-wide --report-cycles 100 --show-ips --aslookup google.com
Start: 2024-06-22T14:03:11-0300
HOST: pc                                              Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS18881  2804:7f4:c181:a8a7:72c7:90fa:ba4d:9e56   0.0%   100    0.6   0.7   0.6   1.8   0.1
  2. AS18881  2804:7f4:2000:1::bf                      0.0%   100    3.3   3.4   3.1   4.7   0.2
  3. AS18881  2804:7f4:2000:1000::8b9                 18.0%   100    3.9   3.7   3.4   4.2   0.2
  4. AS???    2001:12e0:0:3024:a006::2                 0.0%   100    3.4   3.3   3.1   3.8   0.1
  5. AS???    2001:12e0:100:3003:a002:3024:a006:0      0.0%   100    4.6  95.5   4.5 3763. 499.9
  6. AS???    2001:12e0:100:3003:a002:3020:a002:9     34.0%   100   14.3  14.3  14.1  15.0   0.2
  7. AS???    2001:12e0:100:1017:a002:3020:a002:10     2.0%   100   19.3  19.1  18.9  19.7   0.1
  8. AS???    2001:12e0:100:1017:a001:1017:a002:24    75.0%   100   19.0  19.2  19.0  19.6   0.1
  9. AS15169  2001:4860:1:1::d84                      45.0%   100   22.1  21.9  21.7  22.5   0.2
 10. AS15169  2800:3f0:8364:240::1                     0.0%   100   20.2  20.0  19.7  20.2   0.1
 11. AS15169  2001:4860:0:1::8762                      0.0%   100   21.2  21.4  20.9  25.0   0.7
 12. AS15169  2001:4860:0:1::7cc2                     11.0%   100   22.0  22.2  21.4  25.8   0.7
 13. AS15169  2001:4860:0:1::12e1                      0.0%   100   21.5  21.1  20.8  22.1   0.2
 14. AS15169  2001:4860:0:1::1329                      0.0%   100   20.1  20.0  19.9  20.8   0.1
 15. AS15169  2800:3f0:4001:823::200e                  0.0%   100   20.3  20.3  20.2  20.6   0.1
```

## Speedtest CLI

https://www.speedtest.net/apps/cli

```
$ ./speedtest --progress=no --selection-details

   Speedtest by Ookla

Selecting server:
      48754:  23.39 ms; BianchiNet - Jundiaí
      42154:  24.67 ms; Moovenet - Valinhos
      36605:  19.16 ms; Localnet - Guaíba
      30281:  18.72 ms; STEC-GUAIBA - Guaíba
      61847:  19.35 ms; CHTECH - Guaíba
      14143:  46.24 ms; Claro Net Vírtua - Porto Alegre
      36132:   2.75 ms; RSSul Telecom - Porto Alegre
      17678:   2.81 ms; RLNET - Porto Alegre
      38008:  38.41 ms; EdgeUno - Porto Alegre
      24878:   5.00 ms; RSnetPOA - Porto Alegre
      38068:  31.48 ms; LPInternet - Porto Alegre
      39941:  45.31 ms; Onnexx - Porto Alegre
      Server: RSSul Telecom - Porto Alegre (id: 36132)
         ISP: Vivo
Idle Latency:     3.19 ms   (jitter: 0.14ms, low: 2.97ms, high: 3.22ms)
    Download:   708.28 Mbps (data used: 542.1 MB)
                  9.69 ms   (jitter: 0.53ms, low: 2.88ms, high: 10.85ms)
      Upload:   356.34 Mbps (data used: 462.8 MB)
                  2.42 ms   (jitter: 6.80ms, low: 1.52ms, high: 222.42ms)
 Packet Loss:     0.0%
  Result URL: https://www.speedtest.net/result/c/dd996cb5-fde1-4e4a-b5c5-2675ddd01564
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

### Speed test

* https://beta.simet.nic.br/
* https://www.speedtest.net/
* https://fast.com/
