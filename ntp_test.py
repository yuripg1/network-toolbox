from datetime import datetime
from scapy.all import *
import csv
import dns.resolver
import random
import sys
import time


def query_dns_records(server, timeout, sleep, max_attempts, record_type, attempt_number=1):
    dns_resolver = dns.resolver.Resolver()
    dns_resolver.timeout = timeout
    try:
        answers = dns_resolver.resolve(server, record_type)
        return [rdata.address for rdata in answers]
    except Exception:
        if attempt_number < max_attempts:
            time.sleep(sleep)
            return query_dns_records(server, timeout, sleep, max_attempts, record_type, attempt_number + 1)
        else:
            return []


def print_csv_header(writer):
    writer.writerow(["NTP Server", "IP Version", "IP Address", "UDP Source Port", "NTP Version", "Attempt Number", "Result", "Date/Time"])


def print_csv_entry(writer, ntp_server, ip_version, ip_address, udp_source_port, ntp_version, attempt_number, result, date_time):
    writer.writerow([ntp_server, ip_version, ip_address, udp_source_port, ntp_version, attempt_number, result, date_time])


def iterate_over_ntp_combinations(test_parameters):
    csv_writer = csv.writer(sys.stdout)
    print_csv_header(csv_writer)
    for ntp_server in test_parameters["ntp_servers"]:
        ipv4_addresses = query_dns_records(ntp_server, test_parameters["timeout"], test_parameters["sleep"], test_parameters["max_attempts"], "A",)
        ipv6_addresses = query_dns_records(ntp_server, test_parameters["timeout"], test_parameters["sleep"], test_parameters["max_attempts"], "AAAA")
        ipv4_addresses.sort()
        ipv6_addresses.sort()
        ip_addresses = ipv4_addresses + ipv6_addresses
        for ip_address in ip_addresses:
            for udp_source_port in test_parameters["udp_source_ports"]:
                for ntp_version in test_parameters["ntp_versions"]:
                    effective_udp_source_port = udp_source_port
                    if effective_udp_source_port == (-1):
                        effective_udp_source_port = random.randint(test_parameters["random_udp_source_port_min"], test_parameters["random_udp_source_port_max"])
                    create_ntp_request(csv_writer, test_parameters["max_attempts"], test_parameters["sleep"], test_parameters["timeout"], test_parameters["udp_destination_port"], ntp_server, ip_address, ntp_version, effective_udp_source_port)


def create_ntp_request(csv_writer, max_attempts, sleep, timeout, udp_destination_port, ntp_server, ip_address, ntp_version, udp_source_port, attempt_number=1):
    ip_version = ""
    if ":" in ip_address:
        ip_version = "IPv6"
        ip_layer = IPv6(dst=ip_address)
    else:
        ip_version = "IPv4"
        ip_layer = IP(dst=ip_address)
    time.sleep(sleep)
    date_time = datetime.now(timezone.utc).isoformat()
    udp_packet = UDP(sport=udp_source_port, dport=udp_destination_port)
    ntp_packet = NTP(version=ntp_version)
    response = sr1(ip_layer / udp_packet / ntp_packet, timeout=timeout, verbose=0)
    result = ""
    if response:
        result = "Success"
    else:
        result = "Failure"
    print_csv_entry(csv_writer, ntp_server, ip_version, ip_address, udp_source_port, ntp_version, attempt_number, result, date_time)
    if result == "Failure" and attempt_number < max_attempts:
        create_ntp_request(csv_writer, max_attempts, sleep, timeout, udp_destination_port, ntp_server, ip_address, ntp_version, udp_source_port, attempt_number + 1)


def ntp_test():
    test_parameters = {
        "random_udp_source_port_min": 49152,
        "random_udp_source_port_max": 65535,
        "max_attempts": 3,
        "sleep": 15,
        "timeout": 15,
        "udp_destination_port": 123,
        "ntp_versions": [3, 4],
        "udp_source_ports": [123, -1],
        "ntp_servers": ["a.ntp.br", "b.ntp.br", "c.ntp.br", "gps.ntp.br", "pool.ntp.br", "a.st1.ntp.br", "b.st1.ntp.br", "c.st1.ntp.br", "d.st1.ntp.br", "time.cloudflare.com", "time.google.com", "time1.google.com", "time2.google.com", "time3.google.com", "time4.google.com", "ntp.ubuntu.com", "time.windows.com", "time.nist.gov", "pool.ntp.org", "0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org", "3.pool.ntp.org", "br.pool.ntp.org", "0.br.pool.ntp.org", "1.br.pool.ntp.org", "2.br.pool.ntp.org", "3.br.pool.ntp.org"]
    }
    iterate_over_ntp_combinations(test_parameters)


ntp_test()
