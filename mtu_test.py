from scapy.all import sr1, IP, ICMP, IPv6, ICMPv6EchoRequest, ICMPv6PacketTooBig, TCP
import time


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
        if response is None:
            return True
        if response.haslayer(ICMPv6PacketTooBig):
            print("ICMPv6 / Packet too big")
            return False
        return False


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
        print("IP protocol:", ip_protocol, "| MTU to attempt:", mtu_to_attempt, "bytes")
        response = sr1(packet, timeout=timeout, verbose=0)
        if is_valid_response(response, ip_version):
            return mtu_to_attempt
        time.sleep(sleep)
        mtu_to_attempt -= 1


def test_tcp_mss_clamping(target, timeout, ip_version, port):
    if ip_version == 4:
        ip_packet = IP(dst=target)
    elif ip_version == 6:
        ip_packet = IPv6(dst=target)
    tcp_packet = TCP(dport=port, flags='S')
    response = sr1(ip_packet / tcp_packet, timeout=timeout, verbose=0)
    if response and response.haslayer(TCP):
        for option in response[TCP].options:
            if option[0] == "MSS":
                return option[1]
    return None


def mtu_and_mss_test():
    test_parameters = {
        "target": "www.microsoft.com",
        "initial_mtu": 1500,
        "sleep": 1,
        "timeout": 3
    }
    print("\nIPv4 MTU:", test_mtu_per_protocol(test_parameters["target"], test_parameters["initial_mtu"], test_parameters["sleep"], test_parameters["timeout"], 4), "bytes\n")
    print("\nIPv6 MTU:", test_mtu_per_protocol(test_parameters["target"], test_parameters["initial_mtu"], test_parameters["sleep"], test_parameters["timeout"], 6), "bytes\n")
    print("\nIPv4 TCP SYN,ACK MSS:", test_tcp_mss_clamping(test_parameters["target"], test_parameters["timeout"], 4, 443), "bytes\n")
    print("\nIPv6 TCP SYN,ACK MSS:", test_tcp_mss_clamping(test_parameters["target"], test_parameters["timeout"], 6, 443), "bytes\n")


mtu_and_mss_test()
