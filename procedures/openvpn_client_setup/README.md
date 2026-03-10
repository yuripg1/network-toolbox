# OpenVPN client setup

This procedure sets up an OpenVPN client connecting to the OpenVPN server configured in the router

---

## Required files

### Keys and certificates

Follow the steps at **[Keys and certificates creation](../keys_and_certificates_creation)** to create the required keys and certificates

* certificate_authority.crt
* openvpn_client.crt
* openvpn_client.key

### OVPN template

Take the OVPN template file available with the router configuration:

* Ubiquiti EdgeOS: **[openvpn_client.ovpn](../../ubiquiti_edgeos/openvpn_client.ovpn)**
* MikroTik RouterOS: **[openvpn_client.ovpn](../../mikrotik_routeros/openvpn_client.ovpn)**

---

## Configuration

Replace the following values inside the template:

* `{{ENTER_OPENVPN_SERVER_ADDRESS}}`: Address of the OpenVPN server you want to connect to
* `{{ENTER_CERTIFICATE_AUTHORITY}}`: Base64-encoded Certificate Authority (`certificate_authority.crt`)
* `{{ENTER_OPENVPN_CLIENT_CERTIFICATE}}`: Base64-encoded OpenVPN client certificate (`openvpn_client.crt`)
* `{{ENTER_OPENVPN_CLIENT_PRIVATE_KEY}}`: Base64-encoded OpenVPN client private key (`openvpn_client.key`)

---

## How to run

Many platforms have native or easy-to-install OpenVPN client solutions that allow you to import the OVPN file and connect to the OpenVPN server.

Another option is to connect by using the OpenVPN server command line like so:

```shell
$ sudo openvpn --config ./openvpn_client.ovpn
```
