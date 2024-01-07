## Network diagram

![Network Diagram](./network_diagram.png)

## Router commands & configurations

### Mikrotik RouterOS

* [Commands](./mikrotik_routeros_commands.txt)
* [Configuration](./mikrotik_routeros_configuration.txt)

### Ubiquiti EdgeOS

* [Commands](./ubiquiti_edgeos_commands.txt)
* [Configuration](./ubiquiti_edgeos_configuration.txt)
* [NTP synchronization fixer](./ntp_synchronization_fixer)

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

## Path MTU Discovery

### IPv4

```
$ ping -c 5 -D -M do -O -s 1452 -v -4 google.com
PING  (172.217.30.174) 1452(1480) bytes of data.
[1704604568.798671] 76 bytes from gru14s18-in-f14.1e100.net (172.217.30.174): icmp_seq=1 ttl=55 (truncated)
[1704604569.771012] 76 bytes from gru14s18-in-f14.1e100.net (172.217.30.174): icmp_seq=2 ttl=55 (truncated)
[1704604570.772570] 76 bytes from eze03s36-in-f14.1e100.net (172.217.30.174): icmp_seq=3 ttl=55 (truncated)
[1704604571.774289] 76 bytes from eze03s36-in-f14.1e100.net (172.217.30.174): icmp_seq=4 ttl=55 (truncated)
[1704604572.775426] 76 bytes from gru14s18-in-f14.1e100.net (172.217.30.174): icmp_seq=5 ttl=55 (truncated)

---  ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4006ms
rtt min/avg/max/mdev = 27.011/27.094/27.195/0.064 ms
```

### IPv6

```
$ ping -c 5 -D -M do -O -s 1432 -v -6 google.com
PING google.com(2800:3f0:4001:812::200e (2800:3f0:4001:812::200e)) 1432 data bytes
[1704604600.394429] 76 bytes from 2800:3f0:4001:812::200e (2800:3f0:4001:812::200e): icmp_seq=1 ttl=114 (truncated)
[1704604601.396597] 76 bytes from 2800:3f0:4001:812::200e (2800:3f0:4001:812::200e): icmp_seq=2 ttl=114 (truncated)
[1704604602.396906] 76 bytes from 2800:3f0:4001:812::200e (2800:3f0:4001:812::200e): icmp_seq=3 ttl=114 (truncated)
[1704604603.402084] 76 bytes from 2800:3f0:4001:812::200e (2800:3f0:4001:812::200e): icmp_seq=4 ttl=114 (truncated)
[1704604604.399127] 76 bytes from 2800:3f0:4001:812::200e (2800:3f0:4001:812::200e): icmp_seq=5 ttl=114 (truncated)

--- google.com ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4006ms
rtt min/avg/max/mdev = 24.925/26.137/29.745/1.822 ms
```

## Traceroute

### IPv4

```
$ mtr -4 --report-wide --report-cycles 100 --show-ips --aslookup google.com
Start: 2024-01-07T02:17:37-0300
HOST: pc                                                           Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    router.lan (192.168.1.1)                              0.0%   100    0.7   0.6   0.3   0.9   0.1
  2. AS18881  179.184.126.60                                        0.0%   100    2.2   2.5   2.2   3.7   0.2
  3. AS18881  191.30.9.225.dynamic.adsl.gvt.net.br (191.30.9.225)   0.0%   100    2.5   2.7   2.4   3.9   0.2
  4. AS???    187-100-57-56.dsl.telesp.net.br (187.100.57.56)      91.0%   100   22.5  22.5  22.4  23.0   0.2
  5. AS15169  72.14.194.130                                         0.0%   100   27.5  27.4  27.1  28.6   0.2
  6. AS15169  172.253.76.23                                         0.0%   100   29.3  29.9  28.7  69.7   4.3
  7. AS15169  142.250.46.227                                        0.0%   100   24.5  24.4  24.0  29.0   0.6
  8. AS15169  gru14s18-in-f14.1e100.net (172.217.30.174)            0.0%   100   27.2  27.1  26.7  27.8   0.1
```

### IPv6

```
$ mtr -6 --report-wide --report-cycles 100 --show-ips --aslookup google.com
Start: 2024-01-07T02:20:39-0300
HOST: pc                                              Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS18881  2804:7f4:c1ad:212a:4b4a:51ee:4d7e:247a   0.0%   100    0.7   0.6   0.4   0.8   0.1
  2. AS18881  2804:7f4:2000:1::bf                      0.0%   100    3.8   3.3   2.8   4.4   0.2
  3. AS18881  2804:7f4:2000:1000::8bd                  5.0%   100    3.4   3.6   2.7   7.2   0.4
  4. AS???    2001:12e0:100:3024:a005:3024:a009:4      0.0%   100    3.2   3.3   2.6   4.3   0.2
  5. AS???    2001:12e0:100:3004:a002:3024:a005:18     0.0%   100    3.2   3.9   3.0  45.3   4.2
  6. AS???    2001:12e0:100:3019:a002:3004:a002:e      0.0%   100   21.7  21.8  21.0  22.5   0.2
  7. AS???    2001:12e0:100:1016:a002:3019:a002:6      3.0%   100   27.8  27.8  26.9  53.4   2.6
  8. AS???    2001:12e0:100:1025:a001:1016:a002:26    33.0%   100   23.9  23.8  23.4  24.2   0.2
  9. AS12956  2001:1498:1:966::1551                   41.0%   100   28.3  28.3  27.9  28.7   0.1
 10. AS12956  2001:1498:1:957:8000::652                0.0%   100   28.6  28.4  27.9  31.0   0.5
 11. AS15169  2800:3f0:8061::1                         0.0%   100   24.9  24.7  24.4  25.3   0.1
 12. AS15169  2001:4860:0:1::57b2                      0.0%   100   25.0  24.9  24.3  29.0   0.7
 13. AS15169  2001:4860:0:1::7cc4                      3.0%   100   25.6  25.6  25.1  26.0   0.2
 14. AS15169  2001:4860:0:1::7ca9                      0.0%   100   27.8  28.1  27.4  32.7   0.7
 15. AS15169  2001:4860:0:1::d59                       5.0%   100   25.3  25.5  25.0  29.7   0.5
 16. AS15169  2800:3f0:4001:810::200e                  0.0%   100   24.4  24.4  23.6  24.9   0.2
```

## Speedtest CLI

https://www.speedtest.net/apps/cli

```
$ ./speedtest --selection-details

   Speedtest by Ookla

Selecting server:
      37740:  41.41 ms; CH Tech - Guaíba
      36605:  40.41 ms; Localnet - Guaíba
      30281:  36.77 ms; STEC-GUAIBA - Guaíba
      14143:  38.58 ms; Claro net vírtua - Porto Alegre
      36132:  22.38 ms; RSSul Telecom - Porto Alegre
      17678:   3.04 ms; RLNET - Porto Alegre
      38008:  34.78 ms; EdgeUno - Porto Alegre
      24878:   3.60 ms; RSnetPOA - Porto Alegre
      38210:  23.99 ms; i9NET - Porto Alegre
      38068:  24.42 ms; LPInternet - Porto Alegre
      Server: RLNET - Porto Alegre (id: 17678)
         ISP: Vivo
Idle Latency:     2.72 ms   (jitter: 0.09ms, low: 2.62ms, high: 2.85ms)
    Download:   710.33 Mbps (data used: 534.5 MB)                                                   
                  9.48 ms   (jitter: 0.52ms, low: 2.88ms, high: 10.61ms)
      Upload:   356.30 Mbps (data used: 466.7 MB)                                                   
                  2.20 ms   (jitter: 12.98ms, low: 1.36ms, high: 212.53ms)
 Packet Loss:     0.0%
  Result URL: https://www.speedtest.net/result/c/17f223a7-c1ba-4e1b-b34b-551da169e60a
```

## Other helpful online diagnostics

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
