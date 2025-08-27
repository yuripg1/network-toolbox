import argparse
import csv
import dataclasses
import datetime
import dns.resolver
import json
import random
import scapy.all
import time
import typing

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

timeout = 2
sleep_after_failure = 0.2
sleep_before_request = 0.1
max_attempts = 3
min_random_port = 8081
max_random_port = 65535
dns_cache_directory = "./"
dns_cache_filename = "dns_cache"
test_results_directory = "./"
test_results_filename = "test_results"

DnsRecordType = typing.Literal["A", "AAAA"]
TestType = typing.Literal["ping", "ntp"]
NtpVersion = typing.Literal[3, 4]


@dataclasses.dataclass
class Options:
    dns_record_types: set[DnsRecordType]
    test_types: set[TestType]
    ntp_versions: set[NtpVersion]


@dataclasses.dataclass
class DnsCacheEntry:
    ntp_server: str
    record_type: DnsRecordType
    addresses: list[str]


@dataclasses.dataclass
class TestTarget:
    ntp_server: str
    address: str


@dataclasses.dataclass
class TestScenario(TestTarget):
    type: TestType
    source_port: int | None
    ntp_version: NtpVersion | None


@dataclasses.dataclass
class TestResult(TestScenario):
    attempt_number: int
    success: bool
    datetime: str


def export_test_results_to_csv(
    test_results: list[TestResult],
    test_results_directory: str,
    test_results_filename: str,
) -> None:
    timestamp = int(time.time())
    full_file_path = f"{test_results_directory}/{test_results_filename}_{timestamp}.csv"
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
    with open(full_file_path, mode="w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(headers)
        for result in test_results:
            type_string = str(result.type).lower()
            if type_string == "ntp":
                type_string = "NTP"
            elif type_string == "ping":
                type_string = "Ping"
            result_string = "Success" if result.success == True else "Failure"
            writer.writerow(
                [
                    result.ntp_server,
                    result.address,
                    type_string,
                    result.source_port,
                    result.ntp_version,
                    result.attempt_number,
                    result_string,
                    result.datetime,
                ]
            )


def sort_test_results(test_results: list[TestResult]) -> list[TestResult]:
    def sort_key(result: TestResult) -> tuple:
        type_order = {"ping": 0, "ntp": 1}
        type_value = type_order.get(result.type, 2)
        return (
            ".".join(reversed(result.ntp_server.split("."))),
            0 if ":" not in result.address else 1,
            result.address,
            type_value,
            0 if result.source_port == 123 else 1,
            result.ntp_version,
            result.attempt_number,
        )

    return sorted(test_results, key=sort_key)


def save_updated_test_results(
    test_results: list[TestResult],
    test_results_directory: str,
    test_results_filename: str,
) -> None:
    serializable_test_results = [dataclasses.asdict(result) for result in test_results]
    full_file_path = f"{test_results_directory}/{test_results_filename}.json"
    with open(full_file_path, mode="w", newline="", encoding="utf-8") as jsonfile:
        json.dump(serializable_test_results, jsonfile, indent=4)


def test_ntp_server(
    ntp_scenario: TestScenario,
    test_results: list[TestResult],
    timeout: float,
    sleep_after_failure: float,
    sleep_before_request: float,
    max_attempts: int,
    attempt_number=1,
) -> TestResult:
    address = ntp_scenario.address
    source_port = ntp_scenario.source_port
    ntp_version = ntp_scenario.ntp_version
    if ":" in address:
        ip_layer = scapy.all.IPv6(dst=address)
    else:
        ip_layer = scapy.all.IP(dst=address)
    udp_layer = scapy.all.UDP(sport=source_port, dport=123)
    ntp_packet = scapy.all.NTP(version=ntp_version, mode=3, stratum=0)
    time.sleep(sleep_before_request)
    request_datetime = datetime.datetime.now(datetime.timezone.utc).isoformat()
    current_test_result = TestResult(
        ntp_server=ntp_scenario.ntp_server,
        address=ntp_scenario.address,
        type="ntp",
        source_port=ntp_scenario.source_port,
        ntp_version=ntp_scenario.ntp_version,
        attempt_number=attempt_number,
        success=False,
        datetime=request_datetime,
    )
    response = scapy.all.sr1(
        ip_layer / udp_layer / ntp_packet, timeout=timeout, verbose=0
    )
    if response is not None and response.haslayer(scapy.all.NTP):
        current_test_result.success = True
    test_results.append(current_test_result)
    if current_test_result.success != True and attempt_number < max_attempts:
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


def get_all_ntp_scenarios(
    test_targets: list[TestTarget], ntp_versions: set[NtpVersion]
) -> list[TestScenario]:
    ntp_scenarios: list[TestScenario] = []
    possible_ntp_versions: list[NtpVersion] = [3, 4]
    for test_target in test_targets:
        for ntp_version in possible_ntp_versions:
            if ntp_version in ntp_versions:
                ntp_scenarios.append(
                    TestScenario(
                        ntp_server=test_target.ntp_server,
                        address=test_target.address,
                        type="ntp",
                        source_port=123,
                        ntp_version=ntp_version,
                    )
                )
                ntp_scenarios.append(
                    TestScenario(
                        ntp_server=test_target.ntp_server,
                        address=test_target.address,
                        type="ntp",
                        source_port=random.randint(min_random_port, max_random_port),
                        ntp_version=ntp_version,
                    )
                )
    random.shuffle(ntp_scenarios)
    return ntp_scenarios


def test_ntp_servers(
    test_targets: list[TestTarget],
    ntp_versions: set[NtpVersion],
    test_results: list[TestResult],
    timeout: float,
    sleep_after_failure: float,
    sleep_before_request: float,
    max_attempts: int,
) -> None:
    ntp_scenarios = get_all_ntp_scenarios(test_targets, ntp_versions)
    total_ntp_scenarios = len(ntp_scenarios)
    for current_ntp_scenario, ntp_scenario in enumerate(ntp_scenarios, start=1):
        print(
            f"    Testing {ntp_scenario.address} ({ntp_scenario.ntp_server}) | Source port {ntp_scenario.source_port} | NTP version {ntp_scenario.ntp_version}"
        )
        current_test_result = test_ntp_server(
            ntp_scenario,
            test_results,
            timeout,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
        )
        result_string = "Success" if current_test_result.success == True else "Failure"
        print(
            f"        {result_string} | {current_test_result.datetime} | {current_ntp_scenario}/{total_ntp_scenarios} completed"
        )


def ping_ntp_server(
    ping_scenario: TestScenario,
    test_results: list[TestResult],
    timeout: float,
    sleep_after_failure: float,
    sleep_before_request: float,
    max_attempts: int,
    attempt_number=1,
) -> TestResult:
    address = ping_scenario.address
    if ":" in address:
        ip_layer = scapy.all.IPv6(dst=address)
        icmp_layer = scapy.all.ICMPv6EchoRequest()
    else:
        ip_layer = scapy.all.IP(dst=address)
        icmp_layer = scapy.all.ICMP(type=8, code=0)
    packet = ip_layer / icmp_layer
    time.sleep(sleep_before_request)
    request_datetime = datetime.datetime.now(datetime.timezone.utc).isoformat()
    current_test_result = TestResult(
        ntp_server=ping_scenario.ntp_server,
        address=ping_scenario.address,
        type="ping",
        source_port=None,
        ntp_version=None,
        attempt_number=attempt_number,
        success=False,
        datetime=request_datetime,
    )
    response = scapy.all.sr1(packet, timeout=timeout, verbose=0)
    if response is not None:
        if response.haslayer(scapy.all.ICMP):
            icmp_response = response.getlayer(scapy.all.ICMP)
            if icmp_response.type == 0 and icmp_response.code == 0:
                current_test_result.success = True
        elif response.haslayer(scapy.all.ICMPv6EchoReply):
            icmpv6_response = response.getlayer(scapy.all.ICMPv6EchoReply)
            if icmpv6_response.type == 129 and icmpv6_response.code == 0:
                current_test_result.success = True
    test_results.append(current_test_result)
    if current_test_result.success != True and attempt_number < max_attempts:
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


def get_all_ping_scenarios(test_targets: list[TestTarget]) -> list[TestScenario]:
    ping_scenarios: list[TestScenario] = []
    for test_target in test_targets:
        ping_scenarios.append(
            TestScenario(
                ntp_server=test_target.ntp_server,
                address=test_target.address,
                type="ping",
                source_port=None,
                ntp_version=None,
            )
        )
    random.shuffle(ping_scenarios)
    return ping_scenarios


def ping_ntp_servers(
    test_targets: list[TestTarget],
    test_results: list[TestResult],
    timeout: float,
    sleep_after_failure: float,
    sleep_before_request: float,
    max_attempts: int,
) -> None:
    ping_scenarios = get_all_ping_scenarios(test_targets)
    total_ping_scenarios = len(ping_scenarios)
    for current_ping_scenario, ping_scenario in enumerate(ping_scenarios, start=1):
        print(f"    Pinging {ping_scenario.address} ({ping_scenario.ntp_server})")
        current_test_result = ping_ntp_server(
            ping_scenario,
            test_results,
            timeout,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
        )
        result_string = "Success" if current_test_result.success == True else "Failure"
        print(
            f"        {result_string} | {current_test_result.datetime} | {current_ping_scenario}/{total_ping_scenarios} completed"
        )


def load_test_results(
    test_results_directory: str, test_results_filename: str
) -> list[TestResult]:
    full_file_path = f"{test_results_directory}/{test_results_filename}.json"
    try:
        with open(full_file_path, mode="r", encoding="utf-8") as jsonfile:
            serialized_test_results = json.load(jsonfile)
            if isinstance(serialized_test_results, list):
                return [TestResult(**result) for result in serialized_test_results]
            else:
                return []
    except Exception:
        return []


def save_updated_dns_cache(
    dns_cache: list[DnsCacheEntry], dns_cache_directory: str, dns_cache_filename: str
) -> None:
    serializable_dns_cache = [dataclasses.asdict(entry) for entry in dns_cache]
    full_file_path = f"{dns_cache_directory}/{dns_cache_filename}.json"
    with open(full_file_path, mode="w", newline="", encoding="utf-8") as jsonfile:
        json.dump(serializable_dns_cache, jsonfile, indent=4)


def add_addresses_to_dns_cache(
    ntp_server: str,
    record_type: DnsRecordType,
    addresses: list[str],
    dns_cache: list[DnsCacheEntry],
) -> None:
    dns_cache.append(
        DnsCacheEntry(
            ntp_server=ntp_server, record_type=record_type, addresses=addresses
        )
    )


def get_addresses_from_dns_cache(
    ntp_server: str, record_type: DnsRecordType, dns_cache: list[DnsCacheEntry]
) -> list[str] | None:
    for dns_cache_entry in dns_cache:
        if (
            dns_cache_entry.ntp_server == ntp_server
            and dns_cache_entry.record_type == record_type
        ):
            return dns_cache_entry.addresses
    return None


def resolve_dns(
    ntp_server: str,
    record_type: DnsRecordType,
    dns_cache: list[DnsCacheEntry],
    dns_resolver: dns.resolver.Resolver,
    sleep_after_failure: float,
    sleep_before_request: float,
    max_attempts: int,
    attempt_number=1,
) -> list[str]:
    addresses = get_addresses_from_dns_cache(ntp_server, record_type, dns_cache)
    if addresses is not None:
        return addresses
    time.sleep(sleep_before_request)
    try:
        answers = dns_resolver.resolve(ntp_server, record_type)
        addresses = [str(rdata.address) for rdata in answers]
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
                dns_resolver,
                sleep_after_failure,
                sleep_before_request,
                max_attempts,
                attempt_number + 1,
            )
        else:
            return []


def get_ntp_server_addresses(
    ntp_server: str,
    dns_record_types: set[DnsRecordType],
    dns_cache: list[DnsCacheEntry],
    dns_resolver: dns.resolver.Resolver,
    sleep_after_failure: float,
    sleep_before_request: float,
    max_attempts: int,
) -> list[str]:
    ntp_server_addresses: list[str] = []
    for dns_record_type in dns_record_types:
        addresses = resolve_dns(
            ntp_server,
            dns_record_type,
            dns_cache,
            dns_resolver,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
        )
        addresses.sort()
        ntp_server_addresses.extend(addresses)
    return ntp_server_addresses


def get_all_test_targets(
    ntp_servers: list[str],
    dns_record_types: set[DnsRecordType],
    dns_cache: list[DnsCacheEntry],
    dns_resolver: dns.resolver.Resolver,
    sleep_after_failure: float,
    sleep_before_request: float,
    max_attempts: int,
) -> list[TestTarget]:
    test_targets: list[TestTarget] = []
    for ntp_server in ntp_servers:
        print(f"    Getting addresses for {ntp_server}")
        addresses = get_ntp_server_addresses(
            ntp_server,
            dns_record_types,
            dns_cache,
            dns_resolver,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
        )
        if len(addresses) > 0:
            print(f"        {'\n        '.join(addresses)}")
            for address in addresses:
                test_targets.append(TestTarget(ntp_server=ntp_server, address=address))
    return test_targets


def get_dns_resolver(timeout: float) -> dns.resolver.Resolver:
    dns_resolver = dns.resolver.Resolver()
    dns_resolver.timeout = timeout
    dns_resolver.nameservers = [
        "8.8.8.8",
        "8.8.4.4",
        "2001:4860:4860::8888",
        "2001:4860:4860::8844",
    ]
    return dns_resolver


def load_dns_cache(
    dns_cache_directory: str, dns_cache_filename: str
) -> list[DnsCacheEntry]:
    full_file_path = f"{dns_cache_directory}/{dns_cache_filename}.json"
    try:
        with open(full_file_path, mode="r", encoding="utf-8") as jsonfile:
            serialized_dns_cache = json.load(jsonfile)
            if isinstance(serialized_dns_cache, list):
                return [DnsCacheEntry(**entry) for entry in serialized_dns_cache]
            else:
                return []
    except Exception:
        return []


def apply_default_options(options: Options) -> None:
    if len(options.dns_record_types) == 0:
        options.dns_record_types = set(["A", "AAAA"])
    if len(options.test_types) == 0:
        options.test_types = set(["ping", "ntp"])
    if len(options.ntp_versions) == 0:
        options.ntp_versions = set([3, 4])


def get_options_from_arguments(arguments: argparse.Namespace) -> Options:
    options: Options = Options(
        dns_record_types=set(),
        test_types=set(),
        ntp_versions=set(),
    )
    if arguments.protocol:
        protocol_map: dict[str, DnsRecordType] = {"ipv4": "A", "ipv6": "AAAA"}
        options.dns_record_types.add(protocol_map[arguments.protocol])
    if arguments.test_type:
        test_type_map: dict[str, TestType] = {"ping": "ping", "ntp": "ntp"}
        options.test_types.add(test_type_map[arguments.test_type])
    if arguments.ntp_version:
        ntp_version_map: dict[str, NtpVersion] = {"3": 3, "4": 4}
        options.ntp_versions.add(ntp_version_map[arguments.ntp_version])
    apply_default_options(options)
    return options


def parse_arguments() -> argparse.Namespace:
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
    return argument_parser.parse_args()


def main() -> None:
    arguments = parse_arguments()
    options = get_options_from_arguments(arguments)
    test_results: list[TestResult] = []
    print("Phase 1: Loading DNS cache")
    dns_cache = load_dns_cache(dns_cache_directory, dns_cache_filename)
    print("Phase 2: Getting addresses of NTP servers")
    dns_resolver = get_dns_resolver(timeout)
    test_targets = get_all_test_targets(
        ntp_servers,
        options.dns_record_types,
        dns_cache,
        dns_resolver,
        sleep_after_failure,
        sleep_before_request,
        max_attempts,
    )
    print("Phase 3: Saving updated DNS cache")
    save_updated_dns_cache(dns_cache, dns_cache_directory, dns_cache_filename)
    print("Phase 4: Loading test results")
    test_results = load_test_results(test_results_directory, test_results_filename)
    print("Phase 5: Pinging NTP servers")
    if "ping" in options.test_types:
        ping_ntp_servers(
            test_targets,
            test_results,
            timeout,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
        )
    print("Phase 6: Testing NTP servers")
    if "ntp" in options.test_types:
        test_ntp_servers(
            test_targets,
            options.ntp_versions,
            test_results,
            timeout,
            sleep_after_failure,
            sleep_before_request,
            max_attempts,
        )
    print("Phase 7: Saving updated test results")
    save_updated_test_results(
        test_results, test_results_directory, test_results_filename
    )
    print("Phase 8: Exporting test results to CSV")
    sorted_test_results = sort_test_results(test_results)
    export_test_results_to_csv(
        sorted_test_results, test_results_directory, test_results_filename
    )


if __name__ == "__main__":
    main()
