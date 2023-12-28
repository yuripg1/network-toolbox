from scapy.all import *
import csv
import dns.resolver
import random
import sys
import time


def query_dns_records(server, record_type):
    try:
        answers = dns.resolver.resolve(server, record_type)
        return [rdata.address for rdata in answers]
    except Exception:
        return []


def print_csv_header(writer):
    writer.writerow(["NTP Server", "IP Version", "IP Address", "UDP Source Port", "NTP Version", "Attempt Number", "Result"])


def print_csv_entry(writer, ntp_server, ip_version, ip_address, udp_source_port, ntp_version, attempt_number, result):
    writer.writerow([ntp_server, ip_version, ip_address, udp_source_port, ntp_version, attempt_number, result])


def iterate_over_ntp_combinations(test_parameters):
    csv_writer = csv.writer(sys.stdout)
    print_csv_header(csv_writer)
    for ntp_server in test_parameters["ntp_servers"]:
        ipv4_addresses = query_dns_records(ntp_server, "A")
        ipv6_addresses = query_dns_records(ntp_server, "AAAA")
        ipv4_addresses.sort()
        ipv6_addresses.sort()
        ip_addresses = ipv4_addresses + ipv6_addresses
        for ip_address in ip_addresses:
            udp_source_ports = test_parameters["udp_source_ports"] + [random.randint(test_parameters["random_udp_source_port_min"], test_parameters["random_udp_source_port_max"])]
            for udp_source_port in udp_source_ports:
                for ntp_version in test_parameters["ntp_versions"]:
                    create_ntp_request(csv_writer, test_parameters["max_attempts"], test_parameters["sleep"], test_parameters["timeout"], test_parameters["udp_destination_port"], ntp_server, ip_address, ntp_version, udp_source_port)


def create_ntp_request(csv_writer, max_attempts, sleep, timeout, udp_destination_port, ntp_server, ip_address, ntp_version, udp_source_port, attempt_number=1):
    ip_version = ""
    if ':' in ip_address:
        ip_version = "IPv6"
        ip_layer = IPv6(dst=ip_address)
    else:
        ip_version = "IPv4"
        ip_layer = IP(dst=ip_address)
    time.sleep(sleep)
    udp_packet = UDP(sport=udp_source_port, dport=udp_destination_port)
    ntp_packet = NTP(version=ntp_version)
    response = sr1(ip_layer / udp_packet / ntp_packet, timeout=timeout, verbose=0)
    result = ""
    if response:
        result = "Success"
    else:
        result = "Failure"
    print_csv_entry(csv_writer, ntp_server, ip_version, ip_address, udp_source_port, ntp_version, attempt_number, result)
    if result == "Failure" and attempt_number < max_attempts:
        create_ntp_request(csv_writer, max_attempts, sleep, timeout, udp_destination_port, ntp_server, ip_address, ntp_version, udp_source_port, attempt_number + 1)


def ntp_test():
    test_parameters = {
        "random_udp_source_port_min": 49152,
        "random_udp_source_port_max": 65535,
        "max_attempts": 3,
        "sleep": 5,
        "timeout": 15,
        "udp_destination_port": 123,
        "ntp_versions": [3, 4],
        "udp_source_ports": [123],
        "ntp_servers": ["time.windows.com", "time.nist.gov", "time.google.com", "time.cloudflare.com", "a.ntp.br", "b.ntp.br", "c.ntp.br", "a.st1.ntp.br", "b.st1.ntp.br", "c.st1.ntp.br", "d.st1.ntp.br", "gps.ntp.br", "pool.ntp.org", "br.pool.ntp.org"]
    }
    iterate_over_ntp_combinations(test_parameters)


ntp_test()
