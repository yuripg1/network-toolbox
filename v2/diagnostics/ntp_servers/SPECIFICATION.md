# Specification

## Context

The ISP (Vivo), although generally blocking inbound UDP packets with destination port 123 to the customer, still allows traffic from certain well known NTP servers.

That can cause serious problems for NTP clients that send their requests with source port 123 (Windows and RouterOS are two examples). The replies to those requests come with destination port 123 and thus, unless coming from the small number of NTP servers allowed by the ISP, get dropped before reaching the customer and results in the NTP clients failing to synchronize their clocks.

## Objective

This software aims to find out exactly what NTP servers have their traffic allowed by the ISP.

## Technologies

* Python 3
  * Scapy
  * dnspython

## Inputs

* A list of DNS of public NTP servers

## Outputs

* A CSV file detailing all the requests made and their respective results with the following information:
  * NTP server (the DNS)
  * Layer 3 protocol (IPv4 or IPv6)
  * Address (IPv4 address or IPv6 address)
  * Layer 4 protocol (UDP, ICMP or ICMPv6)
  * Source port (for UDP)
  * Type (for ICMP or ICMPv6)
  * Code (for ICMP or ICMPv6)
  * NTP version (for NTP requests)
  * Attempt number (to show if it's the first try or a retry)
  * Result (if the request received a successful reply or not)
  * Date/time

## General behavior

* For each NTP server in the input, obtain their IPv4 addresses (A records) and IPv6 addresses (AAAA records)
* After obtaining all IPv4 and IPv6 address of the targeted NTP servers, order them according to these criteria:
  * DNS in ascending order
  * IPv4 addresses before IPv6 addresses
  * IPv4 addresses in ascending order
  * IPv6 addresses in descending order
* Then, for each unique NTP server (by IP address), perform the following tests:
  * A simple reachability test by sending an ICMP Type 8 (Echo Request) Code 0 over IPv4 or an ICMPv6 Type 128 (Echo Request) Code 0 over IPv6
  * All permutations of NTP requests varying NTP version and source port
    * Test with NTP version 3 and 4
    * Test with source port 123 and with a random source port in the range between 8081 and 65535
      * When using a random source port and having to retry a request, use a different random source port every time
  * In all test scenarios, wait up to 5 seconds for a reply and, if not successful, try up to 2 more times

## Important considerations

* Implement a modern Python 3 project with proper dependencies management
* Have pings and NTP requests well formed and resembling authentic traffic
