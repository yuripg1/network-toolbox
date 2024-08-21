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

## Ping & MTU

### IPv4

```
$ ping -c 20 -D -M do -O -s 1464 -v -4 google.com
PING  (172.217.162.142) 1464(1492) bytes of data.
[1721300352.747546] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=1 ttl=55 (truncated)
[1721300353.748158] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=2 ttl=55 (truncated)
[1721300354.749943] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=3 ttl=55 (truncated)
[1721300355.751530] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=4 ttl=55 (truncated)
[1721300356.752956] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=5 ttl=55 (truncated)
[1721300357.754700] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=6 ttl=55 (truncated)
[1721300358.756480] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=7 ttl=55 (truncated)
[1721300359.758295] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=8 ttl=55 (truncated)
[1721300360.760038] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=9 ttl=55 (truncated)
[1721300361.760883] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=10 ttl=55 (truncated)
[1721300362.763635] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=11 ttl=55 (truncated)
[1721300363.765317] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=12 ttl=55 (truncated)
[1721300364.767213] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=13 ttl=55 (truncated)
[1721300365.768925] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=14 ttl=55 (truncated)
[1721300366.770829] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=15 ttl=55 (truncated)
[1721300367.772504] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=16 ttl=55 (truncated)
[1721300368.774291] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=17 ttl=55 (truncated)
[1721300369.776087] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=18 ttl=55 (truncated)
[1721300370.777938] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=19 ttl=55 (truncated)
[1721300371.779661] 76 bytes from gru14s19-in-f14.1e100.net (172.217.162.142): icmp_seq=20 ttl=55 (truncated)

---  ping statistics ---
20 packets transmitted, 20 received, 0% packet loss, time 19031ms
rtt min/avg/max/mdev = 20.266/20.420/20.557/0.082 ms
```

### IPv6

```
$ ping -c 20 -D -M do -O -s 1444 -v -6 google.com
PING google.com(2800:3f0:4001:809::200e (2800:3f0:4001:809::200e)) 1444 data bytes
[1721300374.773758] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=1 ttl=55 (truncated)
[1721300375.775634] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=2 ttl=55 (truncated)
[1721300376.775340] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=3 ttl=55 (truncated)
[1721300377.779526] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=4 ttl=55 (truncated)
[1721300378.780093] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=5 ttl=55 (truncated)
[1721300379.780613] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=6 ttl=55 (truncated)
[1721300380.783661] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=7 ttl=55 (truncated)
[1721300381.782470] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=8 ttl=55 (truncated)
[1721300382.786314] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=9 ttl=55 (truncated)
[1721300383.788085] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=10 ttl=55 (truncated)
[1721300384.790081] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=11 ttl=55 (truncated)
[1721300385.792032] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=12 ttl=55 (truncated)
[1721300386.794010] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=13 ttl=55 (truncated)
[1721300387.795990] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=14 ttl=55 (truncated)
[1721300388.798017] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=15 ttl=55 (truncated)
[1721300389.799784] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=16 ttl=55 (truncated)
[1721300390.801658] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=17 ttl=55 (truncated)
[1721300391.803738] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=18 ttl=55 (truncated)
[1721300392.805691] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=19 ttl=55 (truncated)
[1721300393.807595] 76 bytes from 2800:3f0:4001:809::200e (2800:3f0:4001:809::200e): icmp_seq=20 ttl=55 (truncated)

--- google.com ping statistics ---
20 packets transmitted, 20 received, 0% packet loss, time 19033ms
rtt min/avg/max/mdev = 25.343/25.631/26.059/0.179 ms
```

## Traceroute

### IPv4

```
$ mtr -4 --report-wide --report-cycles 200 --show-ips --aslookup google.com
Start: 2024-07-18T07:59:55-0300
HOST: pc                                                           Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    router.lan (10.175.202.1)                             0.0%   200    0.6   0.6   0.4   0.7   0.1
  2. AS18881  179.184.126.60                                        0.0%   200    2.3   2.3   2.0   3.5   0.2
  3. AS18881  191.30.9.225.dynamic.adsl.gvt.net.br (191.30.9.225)   0.0%   200    2.7   2.6   2.1   3.3   0.2
  4. AS???    ???                                                  100.0   200    0.0   0.0   0.0   0.0   0.0
  5. AS15169  72.14.194.130                                         0.0%   200   24.6  24.6  24.3  29.6   0.5
  6. AS15169  172.253.76.23                                         0.0%   200   25.2  25.0  24.5  30.4   0.4
  7. AS15169  72.14.232.83                                          0.0%   200   20.9  20.8  20.3  26.4   0.4
  8. AS15169  gru14s19-in-f14.1e100.net (172.217.162.142)           0.0%   200   20.5  20.3  20.0  20.6   0.1
```

### IPv6

```
$ mtr -6 --report-wide --report-cycles 200 --show-ips --aslookup google.com
Start: 2024-07-18T08:03:23-0300
HOST: pc                                              Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS18881  2804:7f4:c182:34a7:72c7:90fa:ba4d:9e56   0.0%   200    0.6   0.6   0.4   0.8   0.1
  2. AS18881  2804:7f4:2000:1::bf                      0.0%   200    3.3   3.3   2.9   4.4   0.2
  3. AS18881  2804:7f4:2000:1000::8bd                  6.5%   200    3.7   3.5   3.1   4.2   0.2
  4. AS???    2001:12e0:100:3024:a005:3024:a009:8      0.0%   200    3.2   3.3   2.3   3.9   0.2
  5. AS???    2001:12e0:100:3004:a002:3024:a005:18     0.0%   200    3.5   3.4   3.2   4.1   0.1
  6. AS???    2001:12e0:100:3019:a002:3004:a002:e      0.0%   200   21.8  21.8  21.5  22.6   0.2
  7. AS???    2001:12e0:100:1016:a002:3019:a002:1a    50.5%   200   27.7  27.6  27.3  28.1   0.1
  8. AS???    2001:12e0:100:1017:a001:1016:a002:28    71.5%   200   27.4  29.9  27.0  46.9   4.9
  9. AS15169  2001:4860:1:1::d84                      14.0%   200   25.5  25.9  25.2  36.7   1.1
 10. AS15169  2800:3f0:8073::1                         0.0%   200   28.3  28.4  28.1  28.7   0.1
 11. AS15169  2001:4860:0:1::2062                      0.0%   200   29.8  29.2  28.9  30.5   0.2
 12. AS15169  2001:4860:0:1::2955                      0.0%   200   29.1  29.0  28.7  29.4   0.1
 13. AS15169  2800:3f0:4001:809::200e                  0.0%   200   25.6  25.3  25.0  25.6   0.1
```

## Speedtest CLI

https://www.speedtest.net/apps/cli

```
$ ./speedtest --progress=no --selection-details

   Speedtest by Ookla

Selecting server:
      65079:  27.64 ms; SenGi Internet - São Vicente
      48754:  27.46 ms; BianchiNet - Jundiaí
      36605:   4.58 ms; Localnet - Guaíba
      30281:  35.49 ms; STEC-GUAIBA - Guaíba
      61847:  30.75 ms; CHTECH - Guaíba
      14143:  44.68 ms; Claro Net Vírtua - Porto Alegre
      36132:   3.91 ms; RSSul Telecom - Porto Alegre
      17678:   3.42 ms; RLNET - Porto Alegre
      38008:  41.20 ms; EdgeUno - Porto Alegre
      24878:   5.07 ms; RSnetPOA - Porto Alegre
      38068:  25.24 ms; LPInternet - Porto Alegre
      39941:  42.29 ms; Onnexx - Porto Alegre
      Server: RLNET - Porto Alegre (id: 17678)
         ISP: Vivo
Idle Latency:     3.73 ms   (jitter: 0.04ms, low: 3.61ms, high: 3.75ms)
    Download:   710.16 Mbps (data used: 348.3 MB)
                 11.19 ms   (jitter: 0.53ms, low: 4.08ms, high: 12.40ms)
      Upload:   356.09 Mbps (data used: 462.0 MB)
                  3.33 ms   (jitter: 19.29ms, low: 1.91ms, high: 417.98ms)
 Packet Loss:     0.0%
  Result URL: https://www.speedtest.net/result/c/c91ca7c4-03f1-48e0-8b34-86f6c0f30f95
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
