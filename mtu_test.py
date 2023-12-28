from scapy.all import sr1, IP, ICMP, IPv6, ICMPv6EchoRequest, ICMPv6PacketTooBig
import time

target = "google.com"
initial_mtu = 1500


def is_valid_response(response, ip_version):
    if response is None:
        return True
    if ip_version == 4:
        if response.haslayer(ICMP) and int(response[ICMP].type) == 3 and int(response[ICMP].code) == 4:
            print("ICMP / Destination Unreachable / Fragmentation required, and DF flag set")
            return False
        if response.haslayer(ICMP) and int(response[ICMP].type) == 0 and int(response[ICMP].code) == 0:
            print("ICMP / Echo Reply")
            return True
        return False
    elif ip_version == 6:
        if response.haslayer(ICMPv6PacketTooBig):
            print("ICMPv6 / Packet too big")
            return False
        return True


def test_mtu_per_protocol(target, initial_mtu, sleep, timeout, ip_version):
    mtu_to_attempt = initial_mtu
    if ip_version == 4:
        ip_protocol = "IPv4"
        overhead = 28
        ip_packet = IP(dst=target, flags="DF")
        icmp_packet = ICMP(type=8, code=0)
    elif ip_version == 6:
        ip_protocol = "IPv6"
        overhead = 48
        ip_packet = IPv6(dst=target)
        icmp_packet = ICMPv6EchoRequest()
    while mtu_to_attempt - overhead > 0:
        payload = 'A' * (mtu_to_attempt - overhead)
        packet = ip_packet / icmp_packet / payload
        print("IP protocol:", ip_protocol, "| MTU to attempt:", mtu_to_attempt)
        response = sr1(packet, timeout=timeout, verbose=0)
        if is_valid_response(response, ip_version):
            return mtu_to_attempt
        time.sleep(sleep)
        mtu_to_attempt -= 1


def mtu_test():
    test_parameters = {
        "target": "google.com",
        "initial_mtu": 1500,
        "sleep": 1,
        "timeout": 3
    }
    print("\n\nIPv4 MTU:", test_mtu_per_protocol(test_parameters["target"], test_parameters["initial_mtu"], test_parameters["sleep"], test_parameters["timeout"], 4), "\n\n")
    print("\n\nIPv6 MTU:", test_mtu_per_protocol(test_parameters["target"], test_parameters["initial_mtu"], test_parameters["sleep"], test_parameters["timeout"], 6), "\n\n")


mtu_test()
