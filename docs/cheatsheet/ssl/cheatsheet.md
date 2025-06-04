<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [generate private key and csr](#generate-private-key-and-csr)
- [generate a self-signed certificate](#generate-a-self-signed-certificate)
- [check ssl certificate](#check-ssl-certificate)
- [get issuer](#get-issuer)
- [get subject](#get-subject)
- [get expiration date](#get-expiration-date)
- [get serial number](#get-serial-number)
- [show multiple information](#show-multiple-information)
- [show fingerprint](#show-fingerprint)
- [extract from the ssl certificate (decoded)](#extract-from-the-ssl-certificate-decoded)
- [show the ssl certificate](#show-the-ssl-certificate)
- [verifying the keys match](#verifying-the-keys-match)
- [check remote certificate chain](#check-remote-certificate-chain)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [* cheatsheet: Check SSL Certificate with OpenSSL](https://www.howtouselinux.com/post/openssl-command-to-generate-view-check-certificate)
> - [* cheatsheet: Check SSL Certificate Chain with OpenSSL Examples](https://www.howtouselinux.com/post/certificate-chain)
{% endhint %}

## generate private key and csr
```bash
$ openssl genrsa -out privateKey.key 2048
$ openssl req -new -key privateKey.key -out CSR.csr

# or
$ openssl req -out CSR.csr \
              -new -newkey rsa:2048 \
              -nodes \
              -keyout privateKey.key \
              -subj "/C=US/ST=Florida/L=Saint Petersburg/O=Your Company, Inc./OU=IT/CN=yourdomain.com"
```

{% hint style='tip' %}
need to input the following info to generate CSR :
- ``Country Name``: 2-digit country code where our organization is legally located.
- ``State/Province``: Write the full name of the state where the organization is legally located.
- ``City``: Write the full name of the city where our organization is legally located.
- ``Organization Name``: Write the legal name of our organization.
- ``Organization Unit``: Name of the department
- ``Common Name``: Fully Qualified Domain Name
{% endhint %}

## generate a self-signed certificate
```bash
$ openssl req -x509 \
              -sha256 \
              -nodes \
              -days 365 \
              -newkey rsa:2048 \
              -keyout privateKey.key \
              -out certificate.crt
```

## check ssl certificate
- check private key info
  ```bash
  $ openssl rsa -noout -text -in privateKey.key
  ```
- check csr info
  ```bash
  $ openssl req -text -noout -in CSR.csr
  ```
- view ssl certificate info
  ```bash
  $ openssl x509 -text -noout -in certificate.crt
  ```

## get issuer
```bash
$ echo -n |
       openssl s_client \
               [-servername <domain.com>] \
               -connect <domain.com>:<port> 2>/dev/null |
       openssl x509 -noout -issuer
```

## get subject
```bash
$ echo -n |
       openssl s_client \
               [-servername <domain.com>] \
               -connect <domain.com>:<port> 2>/dev/null |
       openssl x509 -noout -subject
```

## get expiration date
```bash
$ echo -n |
       openssl s_client \
               [-servername <domain.com>] \
               -connect <domain.com>:<port> 2>/dev/null |
       openssl x509 -noout -dates

# or
$ openssl x509 -enddate -noout -in /path/to/name.pem

# i.e.:
$ echo -n |
       openssl s_client \
               [-servername <domain.com>] \
               -connect <domain.com>:<port> 2>/dev/null |
       openssl x509 -noout -dates
notBefore=Sep  8 00:00:00 2021 GMT
notAfter=Aug 18 23:59:59 2022 GMT
```

## get serial number
```bash
$ echo -n |
       openssl s_client \
               [-servername <domain.com>] \
               -connect <domain.com>:<port> 2>/dev/null |
       openssl x509 -noout -serial
serial=038**************************9CE

$ openssl x509 -noout -serial -in server.crt
serial=038**************************9CE
```

## show multiple information
```bash
$ echo -n |
       openssl s_client \
               [-servername <domain.com>] \
               -connect <domain.com>:<port> 2>/dev/null |
       openssl x509 -noout -dates -subject -issuer
```

## show fingerprint
```bash
$ echo -n |
       openssl s_client \
               [-servername <domain.com>] \
               -connect <domain.com>:<port> 2>/dev/null |
       openssl x509 -noout -fingerprint
```

## extract from the ssl certificate (decoded)
```bash
$ echo -n |
       openssl s_client \
               [-servername <domain.com>] \
               -connect <domain.com>:<port> 2>/dev/null |
       openssl x509 -noout -text
```

## show the ssl certificate
```bash
$ echo -n |
       openssl s_client \
               [-servername <domain.com>] \
               -connect <domain.com>:<port> 2>/dev/null |
       openssl x509
-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----
```

## verifying the keys match
```bash
$ openssl pkey -pubout -in privateKey.key | openssl sha256
# or
$ openssl req -pubkey -in CSR.csr -noout | openssl sha256
# or
$ openssl x509 -pubkey -in certificate.crt -noout | openssl sha256
```

## check remote certificate chain

> [!NOTE|label:see also:]
> - [* iMarslo: get lines between 2 patterns](../../cheatsheet/text-processing/text-processing.md#get-lines-between-2-patterns)

```bash
$ echo -n |
       openssl s_client -connect <domain.com>:<port> 2>/dev/null |
       awk '/Certificate chain/,/---/'
# or
$ echo -n |
       openssl s_client -connect <domain.com>:<port> 2>/dev/null |
       sed -n '/Certificate chain/,/---/p'

# i.e.:
$ echo -n |
       openssl s_client -connect google.com:443 2>/dev/null |
       awk '/Certificate chain/,/---/'
Certificate chain
 0 s:CN = *.google.com
   i:C = US, O = Google Trust Services, CN = WR2
   a:PKEY: id-ecPublicKey, 256 (bit); sigalg: RSA-SHA256
   v:NotBefore: Jul 30 12:32:53 2024 GMT; NotAfter: Oct 22 12:32:52 2024 GMT
 1 s:C = US, O = Google Trust Services, CN = WR2
   i:C = US, O = Google Trust Services LLC, CN = GTS Root R1
   a:PKEY: rsaEncryption, 2048 (bit); sigalg: RSA-SHA256
   v:NotBefore: Dec 13 09:00:00 2023 GMT; NotAfter: Feb 20 14:00:00 2029 GMT
 2 s:C = US, O = Google Trust Services LLC, CN = GTS Root R1
   i:C = BE, O = GlobalSign nv-sa, OU = Root CA, CN = GlobalSign Root CA
   a:PKEY: rsaEncryption, 4096 (bit); sigalg: RSA-SHA256
   v:NotBefore: Jun 19 00:00:42 2020 GMT; NotAfter: Jan 28 00:00:42 2028 GMT
---
```
