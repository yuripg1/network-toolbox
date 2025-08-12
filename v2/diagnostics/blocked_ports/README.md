# Blocked ports

## Summary

This test served to show that the ISP (Vivo) blocks inbound packets to the customer under the following scenarios:

| Layer 3 protocol | Layer 4 protocol | Destination port |
|:----------------:|:----------------:|:----------------:|
| IPv4             | TCP              | 19               |
| IPv4             | TCP              | 21               |
| IPv4             | TCP              | 23               |
| IPv4             | TCP              | 25               |
| IPv4             | TCP              | 53               |
| IPv4             | TCP              | 80               |
| IPv4             | TCP              | 81               |
| IPv4             | TCP              | 135              |
| IPv4             | TCP              | 139              |
| IPv4             | TCP              | 443              |
| IPv4             | TCP              | 445              |
| IPv4             | TCP              | 593              |
| IPv4             | TCP              | 1080             |
| IPv4             | TCP              | 1081             |
| IPv4             | TCP              | 3128             |
| IPv4             | TCP              | 4444             |
| IPv4             | TCP              | 4480             |
| IPv4             | TCP              | 6588             |
| IPv4             | TCP              | 7547             |
| IPv4             | TCP              | 8080             |
| IPv4             | TCP              | 51005            |
| IPv4             | UDP              | 19               |
| IPv4             | UDP              | 53               |
| IPv4             | UDP              | 69               |
| IPv4             | UDP              | 81               |
| IPv4             | UDP              | 123              |
| IPv4             | UDP              | 135              |
| IPv4             | UDP              | 137              |
| IPv4             | UDP              | 138              |
| IPv4             | UDP              | 139              |
| IPv4             | UDP              | 319              |
| IPv4             | UDP              | 320              |
| IPv4             | UDP              | 443              |
| IPv4             | UDP              | 1080             |
| IPv4             | UDP              | 1081             |
| IPv4             | UDP              | 3128             |
| IPv4             | UDP              | 4480             |
| IPv4             | UDP              | 6588             |
| IPv4             | UDP              | 8080             |
| IPv6             | TCP              | 21               |
| IPv6             | TCP              | 23               |
| IPv6             | TCP              | 25               |
| IPv6             | TCP              | 53               |
| IPv6             | TCP              | 80               |
| IPv6             | TCP              | 81               |
| IPv6             | TCP              | 135              |
| IPv6             | TCP              | 139              |
| IPv6             | TCP              | 443              |
| IPv6             | TCP              | 445              |
| IPv6             | TCP              | 593              |
| IPv6             | TCP              | 1080             |
| IPv6             | TCP              | 1081             |
| IPv6             | TCP              | 3128             |
| IPv6             | TCP              | 4444             |
| IPv6             | TCP              | 4480             |
| IPv6             | TCP              | 6588             |
| IPv6             | TCP              | 8080             |
| IPv6             | UDP              | 53               |
| IPv6             | UDP              | 69               |
| IPv6             | UDP              | 81               |
| IPv6             | UDP              | 123              |
| IPv6             | UDP              | 135              |
| IPv6             | UDP              | 137              |
| IPv6             | UDP              | 138              |
| IPv6             | UDP              | 139              |
| IPv6             | UDP              | 319              |
| IPv6             | UDP              | 320              |
| IPv6             | UDP              | 443              |
| IPv6             | UDP              | 1080             |
| IPv6             | UDP              | 1081             |
| IPv6             | UDP              | 3128             |
| IPv6             | UDP              | 4480             |
| IPv6             | UDP              | 6588             |
| IPv6             | UDP              | 8080             |

## Methodology

The testing methodology required the use of two different environments and the definition of how the blocked ports were going to be assessed.

### Testing agent

The main piece of software involved in this testing was the **[nmap](https://nmap.org/)** tool running on a remote server with highly dependable computing and networking resources in order to be able to produce reliable results. For this, an EC2 instance in the sa-east-1 region of AWS was used. Having that, then it was only a matter of using **[nmap](https://nmap.org/)** to run port scans covering all TCP and UDP ports over both IPv4 and IPv6.

For increased reliability in the results, the rate at which the ports were scanned and the timing tolerances for the replies were carefully controlled. While the rate of the TCP scans were not of much concern (due to them being replied with TCP RST packets), the UDP scans presented some challenges due to the rate limiting of ICMP and ICMPv6 replies (ICMPv6 more so than ICMP). Alongside that, every port that didn't produce a reply was tested a second time maintaining the same configuration as to confirm its behavior.

### Test target

The test target was a router with a configured internet access provided by the ISP (Vivo). Besides this, some more careful configurations were required.

First of all, to work in tandem with the **[nmap](https://nmap.org/)** tool, some firewall filtering rules were configured for packets coming from the testing agent. TCP packets were rejected replying with TCP RST packets (ver both IPv4 as well as IPv6) and UDP packets were rejected replying with ICMP Type 3 (Destination Unreachable) Code 3 (Port Unreachable) over IPv4 and ICMPv6 Type 1 (Destination Unreachable) Code 4 (Port Unreachable) over IPv6.

And as to avoid having the regular outbound traffic of the router interfere with the testing in any fashion, firewall NATting rules were configured to steer all outboud traffic from the router to the internet to use a range of ports outside of the range being tested at the moment. That means that while the ports between 0 and 51007 were being scanned, all outbound traffic from the router used the ports between 51008 and 65535. Following the same logic, while the ports between 51008 and 65535 were being scanned, all outbound traffic from the router used the ports between 8082 and 51003.

### Assertions

Finally, any ports that upon being scanned didn't produce any reply were deemed to be blocked by the ISP. The rest of them, which sent back replies as expected by the **[nmap](https://nmap.org/)** tool, were considered as not suffering from any blocking by the ISP.

## Level of confidence

With all the assurances involved in the testing scenarios, the results were considered worthy of confidence. No known potential problems were left unaddressed.

## Raw testing results

One can check out all **[nmap](https://nmap.org/)** commands issued for this test and their respective outputs in the **[test_output.txt](./test_output.txt)** file
