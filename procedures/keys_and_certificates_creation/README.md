## Keys and certificates

### Certificate Authority

```
$ openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -aes256 -out ./certificate_authority.key
$ openssl req -new -x509 -key ./certificate_authority.key -out ./certificate_authority.crt -days 1116 -config ./certificate_authority.cnf
$ printf '%X\n' 4096 > ./certificate_authority.srl
```

### Management via HTTPS

```
$ openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out ./management_https.key
$ openssl req -new -key ./management_https.key -out ./management_https.csr -config ./management_https.cnf
$ openssl x509 -req -in ./management_https.csr -CA ./certificate_authority.crt -CAkey ./certificate_authority.key -CAserial ./certificate_authority.srl -out ./management_https.crt -days 1116 -extfile ./management_https.cnf -extensions cert_ext
```
