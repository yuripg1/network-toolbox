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
$ ping -c 5 -D -M do -O -s 1465 -v -4 google.com
PING  (142.251.129.142) 1465(1493) bytes of data.
[1702918019.220435] From router.lan (192.168.1.1) icmp_seq=1 Frag needed and DF set (mtu = 1492)
[1702918020.220831] no answer yet for icmp_seq=1
ping: local error: message too long, mtu=1492
[1702918021.242078] no answer yet for icmp_seq=2
ping: local error: message too long, mtu=1492
[1702918022.266075] no answer yet for icmp_seq=3
ping: local error: message too long, mtu=1492
[1702918023.290086] no answer yet for icmp_seq=4
ping: local error: message too long, mtu=1492

---  ping statistics ---
5 packets transmitted, 0 received, +5 errors, 100% packet loss, time 4070ms
```

### IPv6

```
$ ping -c 5 -D -M do -O -s 1445 -v -6 google.com
PING google.com(2800:3f0:4001:82f::200e (2800:3f0:4001:82f::200e)) 1445 data bytes
ping: local error: message too long, mtu: 1492
[1702918029.594045] no answer yet for icmp_seq=1
ping: local error: message too long, mtu: 1492
[1702918030.618072] no answer yet for icmp_seq=2
ping: local error: message too long, mtu: 1492
[1702918031.642174] no answer yet for icmp_seq=3
ping: local error: message too long, mtu: 1492
[1702918032.666085] no answer yet for icmp_seq=4
ping: local error: message too long, mtu: 1492

--- google.com ping statistics ---
5 packets transmitted, 0 received, +5 errors, 100% packet loss, time 4098ms
```

## Traceroute

### IPv4

```
$ mtr -4 --report-wide --report-cycles 100 --show-ips --aslookup google.com
Start: 2023-12-18T13:47:17-0300
HOST: pc                                                           Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    router.lan (192.168.1.1)                              0.0%   100    0.6   0.6   0.5   0.7   0.0
  2. AS18881  179.184.126.59                                        0.0%   100    2.3   2.4   2.1   3.1   0.2
  3. AS18881  191.30.9.223.dynamic.adsl.gvt.net.br (191.30.9.223)   0.0%   100    2.8   2.6   2.3   3.1   0.2
  4. AS???    ???                                                  100.0   100    0.0   0.0   0.0   0.0   0.0
  5. AS15169  72.14.194.130                                         0.0%   100   27.3  27.3  27.0  28.6   0.2
  6. AS15169  172.253.76.23                                         0.0%   100   29.6  30.3  29.0  84.1   5.5
  7. AS15169  142.251.78.21                                         0.0%   100   23.8  23.8  23.7  24.1   0.1
  8. AS15169  gru14s31-in-f14.1e100.net (142.251.129.142)           0.0%   100   23.8  23.8  22.9  24.1   0.1
```

### IPv6

```
$ mtr -6 --report-wide --report-cycles 100 --show-ips --aslookup google.com
Start: 2023-12-18T13:49:09-0300
HOST: pc                                              Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS18881  2804:7f4:c2b0:5e9e:4b4a:51ee:4d7e:247a   0.0%   100    0.7   0.6   0.5   0.7   0.1
  2. AS18881  2804:7f4:2000:1::be                      0.0%   100    3.2   3.3   3.0   4.0   0.2
  3. AS18881  2804:7f4:2000:1000::8bb                 28.0%   100    3.3   3.5   3.2   4.0   0.2
  4. AS???    2001:12e0:100:3024:a002:3024:a009:2      0.0%   100    3.4   3.2   3.0   3.6   0.1
  5. AS???    2001:12e0:100:3004:a002:3024:a005:18     0.0%   100    3.2   3.4   3.1   4.0   0.1
  6. AS???    2001:12e0:100:3019:a002:3004:a002:c      5.0%   100   22.0  21.8  21.5  22.3   0.1
  7. AS???    2001:12e0:100:1016:a002:3019:a002:6     52.0%   100   27.5  35.3  27.3 204.0  32.7
  8. AS???    2001:12e0:100:1017:a001:1016:a002:26    30.0%   100   27.7  27.8  27.5  28.7   0.2
  9. AS15169  2001:4860:1:1::d84                      32.0%   100   29.9  29.9  29.6  30.7   0.2
 10. AS15169  2800:3f0:8061::1                         0.0%   100   28.1  28.2  27.9  28.5   0.1
 11. AS15169  2001:4860:0:1::57b4                     30.0%   100   30.0  30.0  29.4  33.1   0.6
 12. AS15169  2001:4860:0:1::7c84                      5.0%   100   29.1  28.9  28.6  30.0   0.2
 13. AS15169  2001:4860:0:1::12e1                      0.0%   100   25.0  25.0  24.2  26.9   0.3
 14. AS15169  2001:4860:0:1::3401                      0.0%   100   28.8  28.9  28.6  29.2   0.1
 15. AS15169  2800:3f0:4001:82f::200e                  0.0%   100   25.0  24.8  24.5  25.1   0.1
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
