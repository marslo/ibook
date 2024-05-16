<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [terminology](#terminology)
  - [extensions](#extensions)
  - [algorithms](#algorithms)
    - [symmetric encryption](#symmetric-encryption)
    - [asymmetric encryption](#asymmetric-encryption)
- [certs](#certs)
  - [generate csr](#generate-csr)
  - [sign the csr](#sign-the-csr)
  - [nginx configure](#nginx-configure)
- [usage](#usage)
  - [show content](#show-content)
  - [convert](#convert)
    - [frmo cer](#frmo-cer)
    - [from a pkcs#12 ( .pfx/.p12 )](#from-a-pkcs12--pfxp12-)
    - [from crt](#from-crt)
    - [remove password from extacted private key](#remove-password-from-extacted-private-key)
    - [from certificate](#from-certificate)
  - [Code Signing Certificates](#code-signing-certificates)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP|label:references:]
> - [* iMarslo: Artifactory Nginx CSR](../../artifactory/nginx-cert.md)
> - [Frequently used OpenSSL Commands](https://www.xolphin.com/support/OpenSSL/Frequently_used_OpenSSL_Commands)
> - [The Most Common OpenSSL Commands](https://www.sslshopper.com/article-most-common-openssl-commands.html) | [OpenSSL Commands](https://pleasantpasswords.com/info/pleasant-password-server/b-server-configuration/3-installing-a-3rd-party-certificate/openssl-commands)

# terminology
## extensions

> [!TIP|label:references:]
> - [What is the difference between .CER and .CRT?](https://stackoverflow.com/a/63556623/2940319)
> - [What are the differences between .pem, .csr, .key, .crt and other such file extensions?](https://crypto.stackexchange.com/a/43700/116555)
> - [Difference between pem, crt, key files](https://stackoverflow.com/a/63195495/2940319)

|          EXTENSION         | NAME                                                                   | DESCRIPTION                                                                                                                                                                                        |
|:--------------------------:|:-----------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|            `.ca`           | Certificate Authority                                                  | -                                                                                                                                                                                                  |
|           `.key`           | Private Key                                                            | -                                                                                                                                                                                                  |
| `.csr`<br>`.req`<br>`.p10` | Certificate Signing Request                                            | -                                                                                                                                                                                                  |
|           `.crt`           | Certificate                                                            | used for certificates, may be encoded as binary DER or as ASCII PEM,  usually an [X509v3](https://www.rfc-editor.org/rfc/rfc5280) certificate                                                      |
|           `.cer`           | Certificate                                                            | alternate form of .crt (Microsoft Convention), DER encoded or base64[PEM] encoded                                                                                                                  |
|           `.pem`           | [Privacy Enhanced Mail](https://www.rfc-editor.org/rfc/rfc7468)        | indicates a base64 encoding with header and footer lines                                                                                                                                           |
|           `.crl`           | Certificate Revocation List                                            | defined within the [X.509v3](https://www.rfc-editor.org/rfc/rfc5280) certificate specifications, and this is usually DER encoded                                                                   |
|      `.p8`<br>`.pkcs8`     | PKCS#8 Private Keys                                                    | PKCS#8 defines a way to encrypt private keys using                                                                                                                                                 |
|      `.p12`<br>`.pfx`      | [PKCS#12](https://www.rfc-editor.org/rfc/rfc7292) defined key store    | commonly password protected. It can contain trusted certificates, private key(s) and their certificate chain(s)                                                                                    |
|      `.p7b`<br>`.p7c`      | [PKCS#7/CMS](https://www.rfc-editor.org/rfc/rfc5652#section-5) message | it is often used as a way to handle the certificates which make up a 'chain' or 'bundle' as a single                                                                                               |
|            `jks`           | Java Key Store                                                         | Java Key Store (JKS) is a repository of security certificates, either authorization certificates or public key certificates, plus corresponding private keys, used for instance in SSL encryption. |

## [algorithms](https://www.xolphin.com/support/Terminology/Algorithms)
### symmetric encryption
- `3DES`
- `AES`

### asymmetric encryption
- `RSA`
- `DSA`
- `ECC`
- `ECDSA`
- `Hash Algorithms`
- `MD5`
- `SHA-1`
- `SHA-2`
- `SHA-3`

# certs
## generate csr

> [!NOTE|label:references:]
> - [How to generate a private key and CSR from the command line](https://www.a2hosting.com/kb/security/ssl/generating-a-private-key-and-csr-from-the-command-line/)
> - [How to Generate a CSR for Nginx (OpenSSL)](https://www.thesslstore.com/knowledgebase/ssl-generate/csr-generation-guide-for-nginx-openssl/)
> - [GENERATE A CERTIFICATE SIGNING REQUEST (CSR) USING OPENSSL ON MICROSOFT WINDOWS SYSTEM](https://knowledge.digicert.com/solution/generate-a-certificate-signing-request-using-openssl-on-microsoft-windows-system)
> - [HOW TO GENERATE A CSR FOR SSL CERTIFICATES ON WINDOWS](https://itac.txst.edu/support/ssl-certificate/csr-windows.html)

```bash
# generate key
$ openssl genrsa -out dashboard.key 2048

# generate csr
$ openssl req -sha256 \
              -new \
              -key dashboard.key \
              -out dashboard.csr \
              -subj '/C=US/ST=California/L=Santa Clara/O=Company Name, Inc./CN=dashboard.kubernetes.com'
```

- or generate key and csr in one command
  ```bash
  $ openssl req -new -newkey rsa:2048 -nodes -keyout dashboard.key -out dashboard.csr -subj '/C=US/ST=California/L=Santa Clara/O=Company Name, Inc./CN=dashboard.kubernetes.com'
  ```

## sign the csr

> [!TIP|label:references:]
> - [How do you sign a Certificate Signing Request with your Certification Authority?](https://stackoverflow.com/a/21340898/2940319)
> - [openssl.cnf](https://raw.githubusercontent.com/openssl/openssl/master/apps/openssl.cnf)

```bash
$ echo subjectAltName = DNS: server.sample.com,IP: 10.110.136.104 >> extfile.cnf
$ echo extendedKeyUsage = serverAuth >> extfile.cnf
$ openssl x509 -req \
               -days 365 \
               -sha256 \
               -CAcreateserial \
               -CA ca.crt \                            # the CA crt
               -CAkey ca.key \                         # the CA key
               -in server.csr \
               -out server.crt \
               -extfile extfile.cnf                    # the external file
```

- [Sign a certificate request using the CA certificate above and add user certificate extensions](https://www.openssl.org/docs/man1.0.2/man1/x509.html)
  ```bash
  $ openssl x509 -req -in req.pem -extfile openssl.cnf -extensions v3_usr \
            -CA cacert.pem -CAkey key.pem -CAcreateserial

  # Set a certificate to be trusted for SSL client use and change set its alias to "Steve's Class 1 CA"
  $ openssl x509 -in cert.pem            -addtrust clientAuth -setalias "Steve's Class 1 CA" -out trust.pem
  # or
  $ openssl x509 -in steve.cer -trustout -addtrust clientAuth -setalias "Steve's Class 1 CA" -out steve.pem
  ```

- [or generate crt with key in one command](https://www.techrepublic.com/article/how-to-enable-ssl-on-nginx/)
  ```bash
  $ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx-selfsigned.key -out nginx-selfsigned.crt
  ```

## nginx configure

> [!NOTE|label:references:]
> - [Configuring HTTPS servers](https://nginx.org/en/docs/http/configuring_https_servers.html)
> - [How to Redirect HTTP to HTTPS in Nginx](https://phoenixnap.com/kb/redirect-http-to-https-nginx#:~:text=To%20redirect%20all%20websites%20from,directive%20to%20force%20a%20redirection.&text=The%20following%20is%20a%20breakdown,HTTP%20traffic%20on%20Port%2080.)
> - [Module ngx_http_ssl_module](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate)
> - [Update: Using Free Let’s Encrypt SSL/TLS Certificates with NGINX](https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/)

- modify/create nginx configure
  ```bash
  $ cat /etc/nginx/sites-enabled/server.sample.com
  server {
      listen 80;
      listen 443 ssl;

      ssl_certificate     /etc/nginx/certs/server.pem;
      ssl_certificate_key /etc/nginx/certs/server.key;
      ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
      ssl_ciphers         HIGH:!aNULL:!MD5;

      server_name server.sample.com;

      location / {
          proxy_pass http://localhost:8080;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection 'upgrade';
          proxy_set_header Host $host;
          proxy_cache_bypass $http_upgrade;
      }
  }
  ```

- test and reload
  ```bash
  $ nginx -t
  $ nginx -s reload
  $ sudo systemctl restart nginx.service

  # more
  $ which -a nginx
  /usr/sbin/nginx
  /sbin/nginx
  ```

# usage
## show content
- certificate request ( csr )
  ```bash
  # show content of a certificate request
  #    csr: request
  #          v
  $ openssl req -in certificate.csr -noout -text

  # subject name
  $ openssl req -in certificate.csr -noout -subject

  # verify
  $ openssl req -in certificate.csr -noout -verify
  ```

- certificate ( pem, crt, cer )
  ```bash
  # show content of a certificate
  #    x509: certificate
  #          v
  $ openssl x509 -in certificate.pem -noout -text

  # show serial number of a certificate
  $ openssl x509 -in certificate.pem -noout -serial

  # show subject name
  $ openssl x509 -in certificate.pem -noout -subject

  # show subject name in RFC2253 format
  $ openssl x509 -in certificate.pem -noout -subject -nameopt RFC2253

  # show subject name in oneline support UTF8
  $ openssl x509 -in certificate.pem -noout -subject -nameopt oneline,-esc_msb

  # show SHA-1 fingerprint
  $ openssl x509 -sha1 -in certificate.pem -noout -fingerprint
  ```

## convert

> [!NOTE|label:references:]
> - [Do I need to convert .CER to .CRT for Apache SSL certificates? If so, how?](https://stackoverflow.com/a/642346/2940319)
> - [x509 options](https://www.openssl.org/docs/man1.0.2/man1/x509.html)

### frmo cer
- to crt
  ```bash
  # DER encoded ( binary )
  $ openssl x509 -inform DER -in certificate.cer -out certificate.crt

  # PEM encoded ( human readable )
  $ openssl x509 -inform PEM -in certificate.cer -out certificate.crt
  ```

- to pem
  ```bash
  $ openssl x509 -inform DER -in certificate.cer -out certificate.pem -outform PEM
  $ openssl x509 -inform PEM -in certificate.cer -out certificate.pem -outform PEM
  ```

### from a pkcs#12 ( .pfx/.p12 )

> [!NOTE|label:references:]
> - [Convert pfx file to pem file](https://www.xolphin.com/support/Certificate_conversions/Convert_pfx_file_to_pem_file)

- to pem
  ```bash
  $ openssl pkcs12 -in certificate.pfx -out certificate.pem -nodes

  ## -nocerts
  $ openssl pkcs12 -in filename.pfx -nocerts -out key.pem
  $ openssl pkcs12 -export -out certificate.pfx -inkey privateKey.key -in certificate.crt -certfile CACert.crt

  ## -clcerts
  $ openssl pkcs12 -in filename.pfx -clcerts -nokeys -out certificate.pem
  ```

### from crt

> [!NOTE|label:references:]
> - [Conversion of crt file to pem file](https://www.xolphin.com/support/Certificate_conversions/Conversion_of_crt_file_to_pem_file)

- to pem
  ```bash
  ## PEM encoded
  $ openssl x509 -in certificate.crt -out certificate.pem -outform PEM

  ## DER encoded
  $ openssl x509 -in certificate.crt -out certificate.der -outform DER

  ## from DER encoded to PEM encoded
  $ openssl x509 -in certificate.der -inform DER -out output.pem -outform PEM
  ```

### [remove password from extacted private key](https://www.xolphin.com/support/Certificate_conversions/Convert_pfx_file_to_pem_file)
```bash
$ openssl rsa -in key.pem -out key.pem
```

### from certificate
- to certificate request
  ```bash
  $ openssl x509 -x509toreq -in certificate.crt -out certificate.csr -signkey privateKey.key
  # or
  $ openssl x509 -x509toreq -in certificate.pem -out req.pem -signkey key.pem
  ```

## [Code Signing Certificates](https://www.xolphin.com/support/signatures/Code_Signing_Certificates)
