## NTP test script

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

## MTR

### IPv4

```
$ mtr -4 --report-wide --report-cycles 100 --show-ips --aslookup google.com
Start: 2023-12-09T06:47:25-0300
HOST: pc                                                             Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    router.lan (10.138.222.1)                               0.0%   100    0.6   0.5   0.4   0.7   0.1
  2. AS18881  179.184.126.59                                         22.0%   100    2.4   2.3   1.8   3.0   0.2
  3. AS18881  191.30.9.227.dynamic.adsl.gvt.net.br (191.30.9.227)     0.0%   100    2.6   2.4   2.2   3.0   0.1
  4. AS26599  152-255-179-142.user.vivozap.com.br (152.255.179.142)  10.0%   100    2.5   2.3   1.7   3.8   0.2
  5. AS26599  152-255-183-71.user.vivozap.com.br (152.255.183.71)     9.0%   100    2.3   2.5   2.2   4.1   0.2
  6. AS???    187-100-57-205.dsl.telesp.net.br (187.100.57.205)      67.0%   100   20.8  20.8  20.5  21.7   0.2
  7. AS26599  152-255-203-130.user.vivozap.com.br (152.255.203.130)  91.0%   100   23.6  23.6  23.4  23.8   0.1
  8. AS???    ???                                                    100.0   100    0.0   0.0   0.0   0.0   0.0
  9. AS15169  72.14.194.130                                           0.0%   100   24.8  24.8  24.3  25.8   0.2
 10. AS15169  172.253.50.119                                          0.0%   100   23.6  23.8  23.4  26.9   0.6
 11. AS15169  216.239.51.199                                          0.0%   100   27.5  27.5  27.3  27.8   0.1
 12. AS15169  gru14s36-in-f14.1e100.net (142.251.132.46)              0.0%   100   23.7  23.5  23.3  23.8   0.1
```

### IPv6

```
$ mtr -6 --report-wide --report-cycles 100 --show-ips --aslookup google.com
Start: 2023-12-09T06:51:11-0300
HOST: pc                                              Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS18881  2804:7f4:c2b1:464c:4b4a:51ee:4d7e:247a   0.0%   100    0.7   0.6   0.4   0.7   0.1
  2. AS18881  2804:7f4:2000:1::be                      0.0%   100    3.3   3.3   2.9   4.5   0.3
  3. AS18881  2804:7f4:2000:1000::8b7                  7.0%   100    3.6   3.5   2.5   4.4   0.3
  4. AS???    2001:12e0:100:3024:a006:3024:a008:6      0.0%   100    3.2   3.2   2.6   3.8   0.2
  5. AS???    2001:12e0:100:3004:a002:3024:a006:0      0.0%   100    3.2   3.3   3.0   5.6   0.3
  6. AS???    2001:12e0:100:3019:a002:3004:a002:12     0.0%   100   21.8  21.7  21.4  22.1   0.1
  7. AS???    2001:12e0:100:1016:a002:3019:a002:2      4.0%   100   27.5  27.6  27.3  32.7   0.5
  8. AS???    2001:12e0:100:1017:a001:1016:a002:28     0.0%   100   27.6  27.7  27.3  28.5   0.2
  9. AS15169  2001:4860:1:1::d84                      38.0%   100   29.9  27.2  26.7  29.9   0.4
 10. AS15169  2800:3f0:8055::1                         0.0%   100   29.0  29.0  28.7  29.2   0.1
 11. AS15169  2001:4860:0:1::6082                      0.0%   100   28.9  29.1  28.9  31.2   0.4
 12. AS15169  2001:4860:0:1::7cc8                      0.0%   100   26.3  27.3  25.8  54.1   3.7
 13. AS15169  2001:4860:0:1::3f9d                      8.0%   100   30.1  30.5  29.5  87.6   6.0
 14. AS15169  2001:4860:0:1::d6f                       0.0%   100   28.8  28.8  28.6  29.4   0.2
 15. AS15169  2800:3f0:4001:833::200e                  0.0%   100   29.3  29.0  28.7  29.4   0.1
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

## Path MTU Discovery

### IPv4

```
$ ping -c 3 -D -M do -O -s 1465 -v -4 google.com
PING  (142.251.129.142) 1465(1493) bytes of data.
ping: local error: message too long, mtu=1492
[1702623904.504416] no answer yet for icmp_seq=1
ping: local error: message too long, mtu=1492
[1702623905.528422] no answer yet for icmp_seq=2
ping: local error: message too long, mtu=1492

---  ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2032ms
```

### IPv6

```
$ ping -c 3 -D -M do -O -s 1445 -v -6 google.com
PING google.com(2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e)) 1445 data bytes
ping: local error: message too long, mtu: 1492
[1702623918.360422] no answer yet for icmp_seq=1
ping: local error: message too long, mtu: 1492
[1702623919.384403] no answer yet for icmp_seq=2
ping: local error: message too long, mtu: 1492

--- google.com ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2036ms
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
