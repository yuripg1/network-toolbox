# Keys and certificates

## Summary

This procedure creates the keys and certificates needed for securing the HTTPS management portal of the router

## Certificate Authority (CA)

This section creates the following files:

* **certificate_authority.key**: Private key of the CA. Encrypted with a password. Must NOT be imported to the router.
* **certificate_authority.crt**: Certificate of the CA. Public. Can be imported to the router and to web browsers too.
* **certificate_authority.srl**: Serial number file used by OpenSSL to track the next certificate serial.

```shell
$ openssl genpkey -aes256 -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out ./certificate_authority.key
$ openssl req -new -sha512 -x509 -days 3653 -key ./certificate_authority.key -config ./certificate_authority.cnf -out ./certificate_authority.crt
$ printf '%X\n' 4096 > ./certificate_authority.srl
$ chmod 600 ./certificate_authority.key
$ chmod 644 ./certificate_authority.crt ./certificate_authority.srl
```

## Management via HTTPS

This section creates the following files:

* **management_https.key**: Private key to encrypt the traffic in the HTTPS management portal of the router. Can be imported to the router.
* **management_https.csr**: Intermediate step containing the public key and the information needed for the certificate creation.
* **management_https.crt**: Certificate to secure the traffic in the HTTPS management portal of the router. Can be imported to the router.

```shell
$ openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out ./management_https.key
$ openssl req -new -config ./management_https.cnf -key ./management_https.key -out ./management_https.csr
$ openssl x509 -req -sha256 -days 3653 -extensions cert_ext -in ./management_https.csr -CA ./certificate_authority.crt -CAkey ./certificate_authority.key -CAserial ./certificate_authority.srl -extfile ./management_https.cnf -out ./management_https.crt
$ chmod 0600 ./management_https.key
$ chmod 0644 ./management_https.csr ./management_https.crt
```

## OpenVPN Server

This section creates the following files:

* **openvpn_server.key**: Private key to encrypt the traffic in the OpenVPN tunnels. Can be imported to the router.
* **openvpn_server.csr**: Intermediate step containing the public key and the information needed for the certificate creation.
* **openvpn_server.crt**: Certificate to secure the traffic in the OpenVPN tunnels. Can be imported to the router.
* **openvpn_server_dh.pem**: Diffie-Hellman parameters used to perform key exchange. Can be imported to the router.

```shell
$ openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out ./openvpn_server.key
$ openssl req -new -config ./openvpn_server.cnf -key ./openvpn_server.key -out ./openvpn_server.csr
$ openssl x509 -req -sha256 -days 3653 -extensions cert_ext -in ./openvpn_server.csr -CA ./certificate_authority.crt -CAkey ./certificate_authority.key -CAserial ./certificate_authority.srl -extfile ./openvpn_server.cnf -out ./openvpn_server.crt
$ openssl dhparam -out ./openvpn_server_dh.pem -2 2048
$ chmod 0600 ./openvpn_server.key
$ chmod 0644 ./openvpn_server.csr ./openvpn_server.crt ./openvpn_server_dh.pem
```

## OpenVPN Client

This section creates the following files:

* **openvpn_client.key**: Private key to authenticate with the OpenVPN Server.
* **openvpn_client.csr**: Intermediate step containing the public key and the information needed for the certificate creation.
* **openvpn_client.crt**: Certificate to secure the traffic in the OpenVPN tunnels.

Before running the commands below, make sure the `openvpn_client.cnf` file references the desired username such as in `CN=username920169077`.

```shell
$ openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out ./openvpn_client.key
$ openssl req -new -config ./openvpn_client.cnf -key ./openvpn_client.key -out ./openvpn_client.csr
$ openssl x509 -req -sha256 -days 3653 -extensions cert_ext -in ./openvpn_client.csr -CA ./certificate_authority.crt -CAkey ./certificate_authority.key -CAserial ./certificate_authority.srl -extfile ./openvpn_client.cnf -out ./openvpn_client.crt
$ chmod 0600 ./openvpn_client.key
$ chmod 0644 ./openvpn_client.csr ./openvpn_client.crt
```
