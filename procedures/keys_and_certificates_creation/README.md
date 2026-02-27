# Keys and certificates

## Summary

This procedure creates the keys and certificates needed for securing the HTTPS management portal of the router

## Certificate Authority (CA)

The first step creates the following files:

* **certificate_authority.key**: Private key of the CA. Encrypted with a password. Must NOT be imported to the router.
* **certificate_authority.crt**: Certificate of the CA. Public. Can be imported to the router and to web browsers too.
* **certificate_authority.srl**: Serial to be referenced whenever signing a certificate with the CA private key.

```shell
$ openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -aes256 -out ./certificate_authority.key
$ openssl req -new -x509 -key ./certificate_authority.key -out ./certificate_authority.crt -days 1116 -config ./certificate_authority.cnf
$ printf '%X\n' 4096 > ./certificate_authority.srl
```

## Management via HTTPS

The second step creates the following files:

* **management_https.key**: Private key to encrypt the traffic in the HTTPS management portal of the router. Can be imported to the router.
* **management_https.csr**: Intermediate step containing the public key and the information needed for the certificate creation.
* **management_https.crt**: Certificate to secure the traffic in the HTTPS management portal of the router. Can be imported to the router.

```shell
$ openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out ./management_https.key
$ openssl req -new -key ./management_https.key -out ./management_https.csr -config ./management_https.cnf
$ openssl x509 -req -in ./management_https.csr -CA ./certificate_authority.crt -CAkey ./certificate_authority.key -CAserial ./certificate_authority.srl -out ./management_https.crt -days 1116 -extfile ./management_https.cnf -extensions cert_ext
```
