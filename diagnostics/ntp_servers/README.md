# NTP servers

This test served to show that the ISP (Vivo), although blocking (for the most part) inbound UDP packets with destination port 123 to the customer, still allows traffic from certain well known NTP servers.

While the full extent of the allowed NTP servers it not publicly known, the test was able to demonstrate that some servers from **[NTP.br](https://ntp.br/)** are in this list, most notably **a.ntp.br**, **b.ntp.br**, **c.ntp.br**, **a.st1.ntp.br** and **d.st1.ntp.br**. The **gps.ntp.br** endpoint was observed to have only half of its addresses allowed. Lastly, it was not possible to draw any conclusions about the **b.st1.ntp.br** and **c.st1.ntp.br** servers due to them being offline at the time of the testing.

| NTP Server   | Address            | Type | Source Port | Result     |
|-------------:|:------------------:|:----:|:-----------:|:----------:|
| a.ntp.br     | 200.160.0.8        | Ping |             | ✅ Success |
| a.ntp.br     | 200.160.0.8        | NTP  | 123         | ✅ Success |
| a.ntp.br     | 2001:12ff::8       | Ping |             | ✅ Success |
| a.ntp.br     | 2001:12ff::8       | NTP  | 123         | ✅ Success |
| b.ntp.br     | 200.189.40.8       | Ping |             | ✅ Success |
| b.ntp.br     | 200.189.40.8       | NTP  | 123         | ✅ Success |
| b.ntp.br     | 2001:12f8:9:1::8   | Ping |             | ✅ Success |
| b.ntp.br     | 2001:12f8:9:1::8   | NTP  | 123         | ✅ Success |
| c.ntp.br     | 200.192.232.8      | Ping |             | ✅ Success |
| c.ntp.br     | 200.192.232.8      | NTP  | 123         | ✅ Success |
| c.ntp.br     | 2001:12f8:b:1::8   | Ping |             | ✅ Success |
| c.ntp.br     | 2001:12f8:b:1::8   | NTP  | 123         | ✅ Success |
| gps.ntp.br   | 200.160.7.193      | Ping |             | ✅ Success |
| gps.ntp.br   | 200.160.7.193      | NTP  | 123         | ❌ Failure |
| gps.ntp.br   | 200.160.7.197      | Ping |             | ✅ Success |
| gps.ntp.br   | 200.160.7.197      | NTP  | 123         | ✅ Success |
| gps.ntp.br   | 2001:12ff:0:7::193 | Ping |             | ✅ Success |
| gps.ntp.br   | 2001:12ff:0:7::193 | NTP  | 123         | ❌ Failure |
| gps.ntp.br   | 2001:12ff:0:7::197 | Ping |             | ✅ Success |
| gps.ntp.br   | 2001:12ff:0:7::197 | NTP  | 123         | ✅ Success |
| pool.ntp.br  | 200.160.0.8        | Ping |             | ✅ Success |
| pool.ntp.br  | 200.160.0.8        | NTP  | 123         | ✅ Success |
| pool.ntp.br  | 200.160.7.186      | Ping |             | ✅ Success |
| pool.ntp.br  | 200.160.7.186      | NTP  | 123         | ✅ Success |
| pool.ntp.br  | 200.160.7.193      | Ping |             | ✅ Success |
| pool.ntp.br  | 200.160.7.193      | NTP  | 123         | ❌ Failure |
| pool.ntp.br  | 200.160.7.196      | Ping |             | ✅ Success |
| pool.ntp.br  | 200.160.7.196      | NTP  | 123         | ✅ Success |
| pool.ntp.br  | 200.160.7.197      | Ping |             | ✅ Success |
| pool.ntp.br  | 200.160.7.197      | NTP  | 123         | ✅ Success |
| pool.ntp.br  | 200.189.40.8       | Ping |             | ✅ Success |
| pool.ntp.br  | 200.189.40.8       | NTP  | 123         | ✅ Success |
| pool.ntp.br  | 200.192.232.8      | Ping |             | ✅ Success |
| pool.ntp.br  | 200.192.232.8      | NTP  | 123         | ✅ Success |
| pool.ntp.br  | 2001:12f8:9:1::8   | Ping |             | ✅ Success |
| pool.ntp.br  | 2001:12f8:9:1::8   | NTP  | 123         | ✅ Success |
| pool.ntp.br  | 2001:12f8:b:1::8   | Ping |             | ✅ Success |
| pool.ntp.br  | 2001:12f8:b:1::8   | NTP  | 123         | ✅ Success |
| pool.ntp.br  | 2001:12ff:0:7::186 | Ping |             | ✅ Success |
| pool.ntp.br  | 2001:12ff:0:7::186 | NTP  | 123         | ✅ Success |
| pool.ntp.br  | 2001:12ff:0:7::193 | Ping |             | ✅ Success |
| pool.ntp.br  | 2001:12ff:0:7::193 | NTP  | 123         | ❌ Failure |
| pool.ntp.br  | 2001:12ff:0:7::196 | Ping |             | ✅ Success |
| pool.ntp.br  | 2001:12ff:0:7::196 | NTP  | 123         | ✅ Success |
| pool.ntp.br  | 2001:12ff:0:7::197 | Ping |             | ✅ Success |
| pool.ntp.br  | 2001:12ff:0:7::197 | NTP  | 123         | ✅ Success |
| pool.ntp.br  | 2001:12ff::8       | Ping |             | ✅ Success |
| pool.ntp.br  | 2001:12ff::8       | NTP  | 123         | ✅ Success |
| a.st1.ntp.br | 200.160.7.186      | Ping |             | ✅ Success |
| a.st1.ntp.br | 200.160.7.186      | NTP  | 123         | ✅ Success |
| a.st1.ntp.br | 2001:12ff:0:7::186 | Ping |             | ✅ Success |
| a.st1.ntp.br | 2001:12ff:0:7::186 | NTP  | 123         | ✅ Success |
| b.st1.ntp.br | 201.49.148.135     | Ping |             | ❌ Failure |
| b.st1.ntp.br | 201.49.148.135     | NTP  | 123         | ❌ Failure |
| c.st1.ntp.br | 200.186.125.195    | Ping |             | ❌ Failure |
| c.st1.ntp.br | 200.186.125.195    | NTP  | 123         | ❌ Failure |
| d.st1.ntp.br | 200.20.186.76      | Ping |             | ✅ Success |
| d.st1.ntp.br | 200.20.186.76      | NTP  | 123         | ✅ Success |

---

## Methodology

The testing methodology included proper configuration of the infrastructure and running a Python script

### Infrastructure configuration

The IPv4 test scenarios, which were run behind NAT, warranted the reservation in the router of the port 123 as well as the range of ports between 49152 and 65535 for the host running the tests. That way, the chance of unrelated traffic interfering with the tests was mitigated. The IPv6 test scenarios, however, had end-to-end connectivity and didn't need any special configuration.

### Python script

The script performed tests for reachability (ping) and for clock synchronization (NTP). To contrast the blocked port with the open ports, the script tested using both the source port 123 and a random port between 49152 and 65535. To make sure the NTP version didn't play a role in any filtering by the ISP, all tests were done using NTP versions 3 and 4. All those scenarios were done using IPv4 and IPv6.

In order to not have the results skewed by occasional dropped packets, the script was programmed to try up to three times every test scenario.

### Assertions

It was possible to discover allowed NTP servers through the scenarios that used source port 123 and received NTP replies as expected.

---

## Level of confidence

The essence of the test only required the evaluation of NTP request scenarios using source port 123. But in order to strengthen the confidence in the obtained results, additional tests were done, including tests for reachability (using ping), different NTP versions and source ports other than 123.

In the end, considering the tests done by the script and the proper configuration of the infrastructure, the results were deemed representative of the reality without any known oversights that could have introduced imprecisions.

---

## Raw testing results

The output of the script executions can be seen in the **[test_output.txt](./test_output.txt)** file, while the CSV describing the results of all test scenarios can be seen in the **[test_results.csv](./test_results.csv)** file

---

## How to run the script

### Important note

Be aware that scapy requires root privileges to send packets. Make sure you are comfortable with this before running the script.

### Setup

```shell
$ sudo apt update
$ sudo apt install -y python3-dev python3-pip python3-venv
```

### Run

```shell
$ bash ./run.sh
```

### Manual

```
usage: run.sh [-h] [--dns-only] [--protocol {ipv4,ipv6}] [--test-type {ping,ntp}] [--ntp-version {3,4}]

Test NTP servers connectivity

options:
  -h, --help            show this help message and exit
  --dns-only            Only perform DNS resolution
  --protocol {ipv4,ipv6}
                        Specify the protocol: ipv4 or ipv6
  --test-type {ping,ntp}
                        Specify the test type: ping or ntp
  --ntp-version {3,4}   Specify the NTP version: 3 or 4
```
