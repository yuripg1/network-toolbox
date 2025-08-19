import argparse
import csv
import datetime
import dns.resolver
import json
import random
import scapy.all
import time

ntp_servers = [
    "a.ntp.br",
    "b.ntp.br",
    "c.ntp.br",
    "gps.ntp.br",
    "pool.ntp.br",
    "a.st1.ntp.br",
    "b.st1.ntp.br",
    "c.st1.ntp.br",
    "d.st1.ntp.br",
    "time.cloudflare.com",
    "time.google.com",
    "time1.google.com",
    "time2.google.com",
    "time3.google.com",
    "time4.google.com",
    "ntp.ubuntu.com",
    "time.windows.com",
    "time.nist.gov",
    "pool.ntp.org",
    "0.pool.ntp.org",
    "1.pool.ntp.org",
    "2.pool.ntp.org",
    "3.pool.ntp.org",
    "br.pool.ntp.org",
    "0.br.pool.ntp.org",
    "1.br.pool.ntp.org",
    "2.br.pool.ntp.org",
    "3.br.pool.ntp.org",
]

timeout = 5
sleep_after_failure = 1
sleep_before_request = 0.2
max_attempts = 3
min_random_port = 8081
max_random_port = 65535
dns_cache_path = "./dns_cache.json"
test_results_path = "./test_results.json"


def get_addresses_from_dns_cache(ntp_server, record_type, dns_cache):
    for dns_cache_entry in dns_cache:
        if (
            dns_cache_entry["ntp_server"] == ntp_server
            and dns_cache_entry["record_type"] == record_type
        ):
            return dns_cache_entry["addresses"]
    return None


def add_addresses_to_dns_cache(ntp_server, record_type, addresses, dns_cache):
    dns_cache.append(
        {
            "ntp_server": ntp_server,
            "record_type": record_type,
            "addresses": addresses,
        }
    )


def resolve_dns(
    ntp_server,
    record_type,
    dns_cache,
    timeout,
    sleep_after_failure,
    sleep_before_request,
    max_attempts,
    attempt_number=1,
):
    dns_resolver = dns.resolver.Resolver()
    dns_resolver.timeout = timeout
    dns_resolver.nameservers = [
        "8.8.8.8",
        "8.8.4.4",
        "2001:4860:4860::8888",
        "2001:4860:4860::8844",
    ]
    try:
        addresses = get_addresses_from_dns_cache(ntp_server, record_type, dns_cache)
        if addresses is not None:
            return addresses
        time.sleep(sleep_before_request)
        answers = dns_resolver.resolve(ntp_server, record_type)
        addresses = [rdata.address for rdata in answers]
        add_addresses_to_dns_cache(ntp_server, record_type, addresses, dns_cache)
        return addresses
    except dns.resolver.NoAnswer:
        add_addresses_to_dns_cache(ntp_server, record_type, [], dns_cache)
        return []
    except Exception:
        print(f"        Error resolving DNS for {ntp_server} {record_type}")
        if attempt_number < max_attempts:
            time.sleep(sleep_after_failure)
            return resolve_dns(
                ntp_server,
                record_type,
                dns_cache,
                timeout,
                sleep_after_failure,
                sleep_before_request,
                max_attempts,
                attempt_number + 1,
            )
        else:
            return []


def get_ntp_server_addresses(
    ntp_server,
    dns_record_types,
    dns_cache,
    timeout,
    sleep_after_failure,
    sleep_before_request,
    max_attempts,
):
    ntp_server_addresses = []
    for dns_record_type in dns_record_types:
        addresses = resolve_dns(
            ntp_server,
            dns_record_type,
            dns_cache,
            timeout,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
        )
        addresses.sort()
        ntp_server_addresses.extend(addresses)
    return ntp_server_addresses


def get_all_ntp_servers_with_addresses(
    ntp_servers,
    dns_record_types,
    dns_cache,
    timeout,
    sleep_after_failure,
    sleep_before_request,
    max_attempts,
):
    ntp_servers_with_addresses = []
    for ntp_server in ntp_servers:
        print(f"    Getting addresses for {ntp_server}")
        addresses = get_ntp_server_addresses(
            ntp_server,
            dns_record_types,
            dns_cache,
            timeout,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
        )
        if len(addresses) > 0:
            print(f"        {'\n        '.join(addresses)}")
            for address in addresses:
                ntp_servers_with_addresses.append(
                    {"ntp_server": ntp_server, "address": address}
                )
    return ntp_servers_with_addresses


def get_all_ping_scenarios(ntp_servers_with_addresses):
    ping_scenarios = []
    for ntp_server_with_addresses in ntp_servers_with_addresses:
        ping_scenarios.append(
            {
                **ntp_server_with_addresses,
            }
        )
    random.shuffle(ping_scenarios)
    return ping_scenarios


def get_all_ntp_scenarios(ntp_servers_with_addresses, ntp_versions):
    ntp_scenarios = []
    for ntp_server_with_addresses in ntp_servers_with_addresses:
        if 3 in ntp_versions:
            ntp_scenarios.append(
                {
                    **ntp_server_with_addresses,
                    "source_port": 123,
                    "ntp_version": 3,
                }
            )
            ntp_scenarios.append(
                {
                    **ntp_server_with_addresses,
                    "source_port": random.randint(min_random_port, max_random_port),
                    "ntp_version": 3,
                }
            )
        if 4 in ntp_versions:
            ntp_scenarios.append(
                {
                    **ntp_server_with_addresses,
                    "source_port": 123,
                    "ntp_version": 4,
                }
            )
            ntp_scenarios.append(
                {
                    **ntp_server_with_addresses,
                    "source_port": random.randint(min_random_port, max_random_port),
                    "ntp_version": 4,
                }
            )
    random.shuffle(ntp_scenarios)
    return ntp_scenarios


def ping_ntp_server(
    ping_scenario,
    test_results,
    timeout,
    sleep_after_failure,
    sleep_before_request,
    max_attempts,
    attempt_number=1,
):
    address = ping_scenario["address"]
    if ":" in address:
        ip_layer = scapy.all.IPv6(dst=address)
        icmp_layer = scapy.all.ICMPv6EchoRequest()
    else:
        ip_layer = scapy.all.IP(dst=address)
        icmp_layer = scapy.all.ICMP(type=8, code=0)
    packet = ip_layer / icmp_layer
    time.sleep(sleep_before_request)
    request_datetime = datetime.datetime.now(datetime.timezone.utc).isoformat()
    current_test_result = {
        **ping_scenario,
        "type": "ping",
        "source_port": None,
        "ntp_version": None,
        "attempt_number": attempt_number,
        "success": False,
        "datetime": request_datetime,
    }
    response = scapy.all.sr1(packet, timeout=timeout, verbose=0)
    if response is not None:
        if response.haslayer(scapy.all.ICMP):
            icmp_response = response.getlayer(scapy.all.ICMP)
            if icmp_response.type == 0 and icmp_response.code == 0:
                current_test_result["success"] = True
        elif response.haslayer(scapy.all.ICMPv6EchoReply):
            icmpv6_response = response.getlayer(scapy.all.ICMPv6EchoReply)
            if icmpv6_response.type == 129 and icmpv6_response.code == 0:
                current_test_result["success"] = True
    test_results.append(current_test_result)
    if current_test_result["success"] != True and attempt_number < max_attempts:
        time.sleep(sleep_after_failure)
        return ping_ntp_server(
            ping_scenario,
            test_results,
            timeout,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
            attempt_number + 1,
        )
    return current_test_result


def ping_ntp_servers(
    ntp_servers_with_addresses,
    test_results,
    timeout,
    sleep_after_failure,
    sleep_before_request,
    max_attempts,
):
    ping_scenarios = get_all_ping_scenarios(ntp_servers_with_addresses)
    total_ping_scenarios = len(ping_scenarios)
    current_ping_scenario = 1
    for ping_scenario in ping_scenarios:
        print(f"    Pinging {ping_scenario['address']} ({ping_scenario['ntp_server']})")
        current_test_result = ping_ntp_server(
            ping_scenario,
            test_results,
            timeout,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
        )
        result_string = (
            "Success" if current_test_result["success"] == True else "Failure"
        )
        print(
            f"        {result_string} | {current_test_result['datetime']} | {current_ping_scenario:3}/{total_ping_scenarios} completed"
        )
        current_ping_scenario += 1


def test_ntp_server(
    ntp_scenario,
    test_results,
    timeout,
    sleep_after_failure,
    sleep_before_request,
    max_attempts,
    attempt_number=1,
):
    address = ntp_scenario["address"]
    source_port = ntp_scenario["source_port"]
    ntp_version = ntp_scenario["ntp_version"]
    if ":" in address:
        ip_layer = scapy.all.IPv6(dst=address)
    else:
        ip_layer = scapy.all.IP(dst=address)
    udp_layer = scapy.all.UDP(sport=source_port, dport=123)
    ntp_packet = scapy.all.NTP(version=ntp_version, mode=3, stratum=0)
    time.sleep(sleep_before_request)
    request_datetime = datetime.datetime.now(datetime.timezone.utc).isoformat()
    current_test_result = {
        **ntp_scenario,
        "type": "ntp",
        "attempt_number": attempt_number,
        "success": False,
        "datetime": request_datetime,
    }
    response = scapy.all.sr1(
        ip_layer / udp_layer / ntp_packet, timeout=timeout, verbose=0
    )
    if response is not None and response.haslayer(scapy.all.NTP):
        current_test_result["success"] = True
    test_results.append(current_test_result)
    if current_test_result["success"] != True and attempt_number < max_attempts:
        time.sleep(sleep_after_failure)
        return test_ntp_server(
            ntp_scenario,
            test_results,
            timeout,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
            attempt_number + 1,
        )
    return current_test_result


def test_ntp_servers(
    ntp_servers_with_addresses,
    ntp_versions,
    test_results,
    timeout,
    sleep_after_failure,
    sleep_before_request,
    max_attempts,
):
    ntp_scenarios = get_all_ntp_scenarios(ntp_servers_with_addresses, ntp_versions)
    total_ntp_scenarios = len(ntp_scenarios)
    current_ntp_scenario = 1
    for ntp_scenario in ntp_scenarios:
        print(
            f"    Testing {ntp_scenario['address']} ({ntp_scenario['ntp_server']}) | Source port {ntp_scenario['source_port']} | NTP version {ntp_scenario['ntp_version']}"
        )
        current_test_result = test_ntp_server(
            ntp_scenario,
            test_results,
            timeout,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
        )
        result_string = (
            "Success" if current_test_result["success"] == True else "Failure"
        )
        print(
            f"        {result_string} | {current_test_result['datetime']} | {current_ntp_scenario:3}/{total_ntp_scenarios} completed"
        )
        current_ntp_scenario += 1


def sort_test_results(test_results):
    def sort_key(result):
        type_order = {"ping": 0, "ntp": 1}
        type_value = type_order.get(result["type"], 2)
        return (
            ".".join(reversed(result["ntp_server"].split("."))),
            0 if ":" not in result["address"] else 1,
            result["address"],
            type_value,
            0 if result["source_port"] == 123 else 1,
            result["ntp_version"],
            result["attempt_number"],
        )

    return sorted(test_results, key=sort_key)


def export_test_results_to_csv(test_results):
    timestamp = int(time.time())
    filename = f"test_results_{timestamp}.csv"
    headers = [
        "NTP Server",
        "Address",
        "Type",
        "Source Port",
        "NTP Version",
        "Attempt Number",
        "Result",
        "Date/Time",
    ]
    with open(filename, mode="w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(headers)
        for result in test_results:
            type_string = result["type"]
            if type_string.lower() == "ntp":
                type_string = "NTP"
            elif type_string.lower() == "ping":
                type_string = "Ping"
            result_string = "Success" if result["success"] == True else "Failure"
            writer.writerow(
                [
                    result["ntp_server"],
                    result["address"],
                    type_string,
                    result["source_port"],
                    result["ntp_version"],
                    result["attempt_number"],
                    result_string,
                    result["datetime"],
                ]
            )


def load_dns_cache(dns_cache_path):
    try:
        with open(dns_cache_path, mode="r", encoding="utf-8") as jsonfile:
            return json.load(jsonfile)
    except Exception:
        return []


def save_updated_dns_cache(dns_cache, dns_cache_path):
    with open(dns_cache_path, mode="w", newline="", encoding="utf-8") as jsonfile:
        json.dump(dns_cache, jsonfile, indent=4)


def import_previous_test_results(test_results_path):
    try:
        with open(test_results_path, mode="r", encoding="utf-8") as jsonfile:
            return json.load(jsonfile)
    except Exception:
        return []


def save_updated_test_results(test_results, test_results_path):
    with open(test_results_path, mode="w", newline="", encoding="utf-8") as jsonfile:
        json.dump(test_results, jsonfile, indent=4)


def parse_arguments():
    argument_parser = argparse.ArgumentParser(
        description="Test NTP servers connectivity"
    )
    argument_parser.add_argument(
        "--protocol",
        choices=["ipv4", "ipv6"],
        default=None,
        help="Specify the protocol: ipv4 or ipv6",
    )
    argument_parser.add_argument(
        "--test-type",
        choices=["ping", "ntp"],
        default=None,
        help="Specify the test type: ping or ntp",
    )
    argument_parser.add_argument(
        "--ntp-version",
        choices=["3", "4"],
        default=None,
        help="Specify the NTP version: 3 or 4",
    )
    arguments = argument_parser.parse_args()
    return arguments


def apply_default_options(options):
    if len(options["dns_record_types"]) == 0:
        options["dns_record_types"] = ["A", "AAAA"]
    if len(options["test_types"]) == 0:
        options["test_types"] = ["ping", "ntp"]
    if len(options["ntp_versions"]) == 0:
        options["ntp_versions"] = [3, 4]
    return options


def get_options_from_arguments(arguments):
    options = {
        "dns_record_types": [],
        "test_types": [],
        "ntp_versions": [],
    }
    if arguments.protocol:
        protocol_map = {"ipv4": "A", "ipv6": "AAAA"}
        options["dns_record_types"] = [protocol_map[arguments.protocol]]
    if arguments.test_type:
        options["test_types"] = [arguments.test_type]
    if arguments.ntp_version:
        options["ntp_versions"] = [int(arguments.ntp_version)]
    apply_default_options(options)
    return options


def main():
    arguments = parse_arguments()
    options = get_options_from_arguments(arguments)
    test_results = []
    print("Phase 1: Loading DNS cache")
    dns_cache = load_dns_cache(dns_cache_path)
    print("Phase 2: Getting addresses of NTP servers")
    ntp_servers_with_addresses = get_all_ntp_servers_with_addresses(
        ntp_servers,
        options["dns_record_types"],
        dns_cache,
        timeout,
        sleep_after_failure,
        sleep_before_request,
        max_attempts,
    )
    print("Phase 3: Saving updated DNS cache")
    save_updated_dns_cache(dns_cache, dns_cache_path)
    print("Phase 4: Importing previous test results")
    test_results = import_previous_test_results(test_results_path)
    print("Phase 5: Pinging NTP servers")
    if "ping" in options["test_types"]:
        ping_ntp_servers(
            ntp_servers_with_addresses,
            test_results,
            timeout,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
        )
    print("Phase 6: Testing NTP servers")
    if "ntp" in options["test_types"]:
        test_ntp_servers(
            ntp_servers_with_addresses,
            options["ntp_versions"],
            test_results,
            timeout,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
        )
    print("Phase 7: Saving updated test results")
    save_updated_test_results(test_results, test_results_path)
    print("Phase 8: Exporting test results to CSV")
    sorted_test_results = sort_test_results(test_results)
    export_test_results_to_csv(sorted_test_results)


if __name__ == "__main__":
    main()
