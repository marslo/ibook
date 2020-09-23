<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [SSL Cert](#ssl-cert)
  - [Create Cert for server](#create-cert-for-server)
    - [CA (root cert)](#ca-root-cert)
    - [Cert for Server](#cert-for-server)
    - [Sign the server cert with CA](#sign-the-server-cert-with-ca)
    - [Cert for Client](#cert-for-client)
    - [Update the file perm](#update-the-file-perm)
    - [Check certs](#check-certs)
  - [Certificate working with Nginx](#certificate-working-with-nginx)
  - [Certificate working with Client](#certificate-working-with-client)
    - [Add certifactory in MacOS](#add-certifactory-in-macos)
    - [Find the added cert in MacOS](#find-the-added-cert-in-macos)
    - [Remove the cert in MacOS](#remove-the-cert-in-macos)
    - [Other methods](#other-methods)
  - [If you enter '.', the field will be left blank.](#if-you-enter--the-field-will-be-left-blank)
- [Artifactory HTTPS](#artifactory-https)
  - [If you enter '.', the field will be left blank.](#if-you-enter--the-field-will-be-left-blank-1)
  - [If you enter '.', the field will be left blank.](#if-you-enter--the-field-will-be-left-blank-2)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# SSL Cert
## Create Cert for server
### CA (root cert)

    $ openssl genrsa -aes256 -out www.artifactory.mycompany.com-ca.key 2048
    $ openssl req -new -x509 -days 365 -key www.artifactory.mycompany.com-ca.key -sha256 -out www.artifactory.mycompany.com-ca.crt -subj "/C=CN/ST=Sichuan/L=Chengdu/O=mycompany/OU=CDI/CN=www.artifactory.mycompany.com"

<details><summary>Click to check details</summary>
<pre><code>$ openssl genrsa -aes256 -out www.artifactory.mycompany.com-ca.key 2048
Generating RSA private key, 2048 bit long modulus
....................................................................+++
...................................................+++
unable to write 'random state'
e is 65537 (0x10001)
Enter pass phrase for www.artifactory.mycompany.com-ca.key:artifactory
Verifying - Enter pass phrase for www.artifactory.mycompany.com-ca.key:artifactory
$ openssl req -new -x509 -days 365 -key www.artifactory.mycompany.com-ca.key -sha256 -out www.artifactory.mycompany.com-ca.crt -subj "/C=CN/ST=Sichuan/L=Chengdu/O=mycompany/OU=CDI/CN=www.artifactory.mycompany.com/emailAddress=marslo.jiao@mycompany.com"
Enter pass phrase for www.artifactory.mycompany.com-ca.key:artifactory
</code></pre>
</details>

### Cert for Server

    $ openssl genrsa -out  www.artifactory.mycompany.com-server.key 2048
    $ openssl req -sha256 -new -key www.artifactory.mycompany.com-server.key -out www.artifactory.mycompany.com-server.csr -subj "/C=CN/ST=Sichuan/L=Chengdu/O=mycompany/OU=CDI/CN=www.artifactory.mycompany.com/emailAddress=marslo.jiao@mycompany.com"

<details><summary>Click to check details</summary>
<pre><code>$ openssl genrsa -out  www.artifactory.mycompany.com-server.key 2048
Generating RSA private key, 2048 bit long modulus
......................................................................+++
............................................................................................................................................................................................................................+++
unable to write 'random state'
e is 65537 (0x10001)
$ openssl req -sha256 -new -key www.artifactory.mycompany.com-server.key -out www.artifactory.mycompany.com-server.csr -subj "/C=CN/ST=Sichuan/L=Chengdu/O=mycompany/OU=CDI/CN=www.artifactory.mycompany.com/emailAddress=marslo.jiao@mycompany.com"
</code></pre>
</details>

### Sign the server cert with CA

    $ echo subjectAltName = DNS:www.artifactory.mycompany.com,IP:130.147.219.19 >> extfile.cnf
    $ echo extendedKeyUsage = serverAuth >> extfile.cnf

    $ openssl x509 -req -days 365 -sha256 -in www.artifactory.mycompany.com-server.csr -CA www.artifactory.mycompany.com-ca.crt -CAkey www.artifactory.mycompany.com-ca.key -CAcreateserial -out www.artifactory.mycompany.com-server.crt -extfile extfile.cnf

<details><summary>Click to check details</summary>
<pre><code>$ echo subjectAltName = DNS:www.artifactory.mycompany.com,IP:130.147.219.19 >> extfile.cnf
$ echo extendedKeyUsage = serverAuth >> extfile.cnf
$ openssl x509 -req -days 365 -sha256 -in www.artifactory.mycompany.com-server.csr -CA www.artifactory.mycompany.com-ca.crt -CAkey www.artifactory.mycompany.com-ca.key -CAcreateserial -out www.artifactory.mycompany.com-server.crt -extfile extfile.cnf
Signature ok
subject=/C=CN/ST=Sichuan/L=Chengdu/O=mycompany/OU=CDI/CN=www.artifactory.mycompany.com/emailAddress=marslo.jiao@mycompany.com
Getting CA Private Key
Enter pass phrase for www.artifactory.mycompany.com-ca.key:artifactory
unable to write 'random state'

$ ls
extfile.cnf                             www.artifactory.mycompany.com-ca.key      www.artifactory.mycompany.com-server.csr  www.srl
www.artifactory.mycompany.com-ca.crt  www.artifactory.mycompany.com-server.crt  www.artifactory.mycompany.com-server.key
</code></pre>
</details>

### Cert for Client

    $ openssl genrsa -out www.artifactory.mycompany.com-client.key
    $ openssl req -subj "/C=CN/ST=Sichuan/L=Chengdu/O=mycompany/OU=CDI/CN=www.artifactory.mycompany.com/emailAddress=marslo.jiao@mycompany.com" -new -key www.artifactory.mycompany.com-client.key -out www.artifactory.mycompany.com-client.csr
    $ echo extendedKeyUsage = clientAuth >> extfile.cnf
    $ openssl x509 -req -days 365 -sha256 -in www.artifactory.mycompany.com-client.csr -CA www.artifactory.mycompany.com-ca.crt -CAkey www.artifactory.mycompany.com-ca.key -CAcreateserial -out www.artifactory.mycompany.com-client.cert -extfile extfile.cnf

<details><summary>Click to check details</summary>
<pre><code>$ openssl genrsa -out www.artifactory.mycompany.com-client.key 2048
Generating RSA private key, 2048 bit long modulus
................................................+++
.......................+++
unable to write 'random state'
e is 65537 (0x10001)

$ openssl req -subj "/C=CN/ST=Sichuan/L=Chengdu/O=mycompany/OU=CDI/CN=www.artifactory.mycompany.com/emailAddress=marslo.jiao@mycompany.com" -new -key www.artifactory.mycompany.com-client.key -out www.artifactory.mycompany.com-client.csr

$ echo extendedKeyUsage = clientAuth >> extfile.cnf
$ cat extfile.cnf
subjectAltName = DNS:www.artifactory.mycompany.com,IP:130.147.219.19
extendedKeyUsage = serverAuth
extendedKeyUsage = clientAuth

$ openssl x509 -req -days 365 -sha256 -in www.artifactory.mycompany.com-client.csr -CA www.artifactory.mycompany.com-ca.crt -CAkey www.artifactory.mycompany.com-ca.key -CAcreateserial -out www.artifactory.mycompany.com-client.cert -extfile extfile.cnf
Signature ok
subject=/C=CN/ST=Sichuan/L=Chengdu/O=mycompany/OU=CDI/CN=www.artifactory.mycompany.com/emailAddress=marslo.jiao@mycompany.com
Getting CA Private Key
Enter pass phrase for www.artifactory.mycompany.com-ca.key:artifactor
unable to write 'random state'
</code></pre>
</details>

### Update the file perm

    $ sudo chmod -v 0444 www.artifactory.mycompany.com-ca.crt www.artifactory.mycompany.com-server.crt client.cert
    $ sudo chmod -v 0400 www.artifactory.mycompany.com-ca.key client.key www.artifactory.mycompany.com-server.key

### Check certs
#### crt

    $ openssl x509 -noout -text -in www.artifactory.mycompany.com-server.crt

<details><summary>openssl x509 ca.crt</summary>
<pre><code>$ openssl x509 -noout -text -in www.artifactory.mycompany.com-ca.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 15145698426239402702 (0xd23054792b3142ce)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=CN, ST=Sichuan, L=Chengdu, O=mycompany, OU=CDI, CN=www.artifactory.mycompany.com/emailAddress=marslo.jiao@mycompany.com
        Validity
            Not Before: Jan  2 11:35:31 2018 GMT
            Not After : Jan  2 11:35:31 2019 GMT
        Subject: C=CN, ST=Sichuan, L=Chengdu, O=mycompany, OU=CDI, CN=www.artifactory.mycompany.com/emailAddress=marslo.jiao@mycompany.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:d0:3f:b6:c5:e5:52:8d:c7:26:3f:e7:0a:7a:5f:
                    c1:71:2a:9e:34:07:7e:10:4a:3d:c4:4f:f7:df:58:
                    93:0d:fa:00:e8:21:75:6d:d1:45:7d:bd:27:f2:c5:
                    08:13:8f:4f:be:91:9f:28:19:7e:c3:a7:42:1b:fc:
                    b4:96:21:8a:33:59:79:27:a3:cf:13:3e:cd:92:0d:
                    7e:b9:9f:0d:01:bf:27:5f:e4:7a:7d:db:69:a3:78:
                    96:a8:c3:a9:2d:31:28:97:ba:6c:20:17:ab:eb:85:
                    ce:2c:25:e8:3e:a0:8b:c0:0b:b2:a9:e1:ac:9f:e1:
                    57:35:bb:64:6a:99:2e:8f:27:f1:04:40:a7:16:32:
                    31:4e:ad:18:5e:9e:0b:dd:42:17:af:8a:58:c6:1a:
                    e9:00:52:97:7b:7a:24:cc:b1:81:8d:b9:20:60:e4:
                    96:d5:77:82:07:4e:df:9c:3a:26:95:d5:ed:aa:a1:
                    24:94:64:0e:93:9a:9e:9b:d4:78:6b:46:50:69:05:
                    19:6a:ff:7b:1d:1b:0f:ce:6b:30:33:c7:99:9d:6a:
                    30:0c:fc:f8:74:00:df:65:6f:fa:1b:24:0a:73:77:
                    4d:94:45:27:9b:93:a6:81:37:57:57:6f:e9:ae:e4:
                    5e:a8:b8:be:31:0f:73:4b:9e:1b:ed:78:5c:48:ec:
                    0b:a5
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Alternative Name:
                IP Address:130.147.219.19
            X509v3 Subject Key Identifier:
                23:32:BC:61:9E:51:8E:94:22:30:5B:AE:68:8A:7E:8E:53:D2:45:7C
            X509v3 Authority Key Identifier:
                keyid:23:32:BC:61:9E:51:8E:94:22:30:5B:AE:68:8A:7E:8E:53:D2:45:7C

            X509v3 Basic Constraints:
                CA:TRUE
    Signature Algorithm: sha256WithRSAEncryption
         69:a3:fe:35:63:a5:e8:4e:e6:3e:4f:9d:f6:82:3d:73:f2:a7:
         22:c1:46:e5:09:5e:61:81:b7:70:3c:62:ba:43:7d:bd:ac:67:
         d0:41:ea:a7:b8:41:47:04:bc:41:9a:46:35:31:3f:62:10:7a:
         58:73:45:3a:59:3b:41:6b:2b:1e:62:42:b7:7e:c1:6b:92:25:
         2a:df:3f:69:b5:26:8e:c7:5d:c6:24:a0:65:21:b7:63:74:60:
         7f:3b:0e:9a:80:a4:4f:a2:79:20:19:92:64:60:b7:53:5c:09:
         6e:46:6e:7a:d7:ee:ef:f4:2e:27:7a:1a:0e:da:5b:8b:7a:bf:
         40:56:9f:16:63:6b:89:ab:48:65:07:45:e0:a0:21:7c:0f:6d:
         9c:2a:ab:ca:d0:02:06:8a:39:7a:ea:65:b9:04:13:0f:6b:cd:
         ea:e5:9f:59:c5:d2:06:b2:e4:c3:cb:ab:59:69:aa:11:e6:08:
         49:12:cc:d4:29:21:2b:59:c1:dc:bb:e6:a9:7d:96:68:a4:7b:
         61:76:8a:21:a9:69:a5:83:d5:8b:f6:08:4e:c0:34:64:6b:65:
         96:ac:ed:cd:c1:0b:54:7d:a9:57:07:77:0c:6a:43:9e:4f:c0:
         6c:12:88:e8:cf:34:08:67:af:1c:2f:bb:49:54:1b:17:95:89:
         b3:2d:c9:5f
</code></pre>
</details>

<details><summary>openssl x509 server.crt</summary>
<pre><code>$ openssl x509 -noout -text -in www.artifactory.mycompany.com-server.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 12625600037876864867 (0xaf37245755cf1763)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=CN, ST=Sichuan, L=Chengdu, O=mycompany, OU=CDI, CN=www.artifactory.mycompany.com/emailAddress=marslo.jiao@mycompany.com
        Validity
            Not Before: Jan  2 11:39:47 2018 GMT
            Not After : Jan  2 11:39:47 2019 GMT
        Subject: C=CN, ST=Sichuan, L=Chengdu, O=mycompany, OU=CDI, CN=www.artifactory.mycompany.com/emailAddress=marslo.jiao@mycompany.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:b9:af:45:ba:6d:99:42:34:09:c5:ef:da:be:a6:
                    c4:ff:09:9a:bf:7c:89:51:a8:c6:df:c8:ba:b3:a6:
                    42:24:36:d5:5d:ff:f3:ab:df:de:6e:05:8b:81:4a:
                    ec:4c:58:16:ca:0c:56:9e:a7:0e:2d:ba:93:68:e1:
                    0d:f9:f6:82:ce:98:9b:65:53:8f:ba:27:c9:0c:f8:
                    f1:4c:14:11:67:ef:97:5c:bb:15:16:ae:c4:eb:16:
                    e2:22:29:7a:36:fd:aa:19:f3:ad:93:9a:a3:5c:0c:
                    92:77:d3:cc:75:b1:29:b4:8d:cd:74:57:18:5c:d2:
                    c2:00:7a:d4:b2:54:81:0a:44:e7:b8:ef:44:36:86:
                    4f:04:ab:21:0c:fe:79:9c:93:31:f5:44:46:9d:d8:
                    36:79:4b:c0:dd:5b:8e:6f:dc:0c:8a:0a:a4:d7:4d:
                    5a:5c:b0:c0:af:4d:38:45:30:79:3f:a1:69:8a:5b:
                    19:49:25:bd:5f:19:d8:4f:e0:03:9a:43:fb:ad:6d:
                    2b:cc:7c:eb:c5:7c:64:fc:9b:bf:83:91:50:ac:21:
                    a1:b6:3f:70:23:cb:d6:af:eb:48:71:cf:f4:da:41:
                    4e:97:84:64:0c:b4:4d:5f:cb:30:f5:47:a6:35:3d:
                    02:99:6f:3f:e9:e9:56:42:a0:58:54:21:04:87:f9:
                    7a:a5
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Alternative Name:
                DNS:www.artifactory.mycompany.com, IP Address:130.147.219.19
            X509v3 Extended Key Usage:
                TLS Web Server Authentication
    Signature Algorithm: sha256WithRSAEncryption
         3d:e8:81:f2:ab:89:47:e2:2c:8c:5a:54:31:c2:2a:11:37:e6:
         ab:89:ff:d1:c2:8c:8e:3a:7d:d2:1d:28:3e:9e:5f:9e:89:08:
         78:2e:16:32:52:e7:35:ab:66:09:a4:83:85:42:55:d6:7c:4f:
         37:cf:8d:37:bd:57:d0:00:f2:9c:67:68:a2:ed:49:c6:eb:0f:
         b7:49:ba:ae:12:35:82:a6:a5:b6:5e:f7:68:08:f7:3f:a1:73:
         d2:94:3e:7a:d9:5c:e1:e2:ab:12:46:66:9d:59:3a:e1:2d:aa:
         a6:53:97:40:ac:a3:ca:80:6d:5b:75:dc:c4:ee:10:48:55:2c:
         10:00:43:07:e6:c4:16:09:fb:04:5d:78:8e:85:21:21:75:01:
         a5:af:c0:c0:d1:fd:33:6e:5b:24:8b:f8:e6:1c:df:b7:f1:e5:
         38:02:d4:a8:e1:09:93:2e:8d:19:ea:e2:11:3f:c1:fe:75:bb:
         ef:03:6e:c3:50:77:a5:54:7d:7e:e0:cd:85:20:08:41:38:b2:
         86:65:aa:58:51:1b:7b:ed:6a:07:0f:cc:ab:49:d8:34:ec:5d:
         fd:0d:75:48:81:3c:a5:bc:ce:c0:95:8c:8e:d3:8c:0f:0d:a3:
         a7:73:70:bc:59:89:7c:42:25:0b:cb:2f:b0:86:4a:46:56:f2:
         e9:d9:63:f1

</code></pre>
</details>

#### csr

    $ openssl req -noout -text -in www.artifactory.mycompany.com-server.csr
<details><summary>openss req</summary>
<pre><code>$ openssl req -noout -text -in www.artifactory.mycompany.com-server.csr
Certificate Request:
    Data:
        Version: 0 (0x0)
        Subject: C=CN, ST=Sichuan, L=Chengdu, O=mycompany, OU=CDI, CN=www.artifactory.mycompany.com/emailAddress=marslo.jiao@mycompany.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:b9:af:45:ba:6d:99:42:34:09:c5:ef:da:be:a6:
                    c4:ff:09:9a:bf:7c:89:51:a8:c6:df:c8:ba:b3:a6:
                    42:24:36:d5:5d:ff:f3:ab:df:de:6e:05:8b:81:4a:
                    ec:4c:58:16:ca:0c:56:9e:a7:0e:2d:ba:93:68:e1:
                    0d:f9:f6:82:ce:98:9b:65:53:8f:ba:27:c9:0c:f8:
                    f1:4c:14:11:67:ef:97:5c:bb:15:16:ae:c4:eb:16:
                    e2:22:29:7a:36:fd:aa:19:f3:ad:93:9a:a3:5c:0c:
                    92:77:d3:cc:75:b1:29:b4:8d:cd:74:57:18:5c:d2:
                    c2:00:7a:d4:b2:54:81:0a:44:e7:b8:ef:44:36:86:
                    4f:04:ab:21:0c:fe:79:9c:93:31:f5:44:46:9d:d8:
                    36:79:4b:c0:dd:5b:8e:6f:dc:0c:8a:0a:a4:d7:4d:
                    5a:5c:b0:c0:af:4d:38:45:30:79:3f:a1:69:8a:5b:
                    19:49:25:bd:5f:19:d8:4f:e0:03:9a:43:fb:ad:6d:
                    2b:cc:7c:eb:c5:7c:64:fc:9b:bf:83:91:50:ac:21:
                    a1:b6:3f:70:23:cb:d6:af:eb:48:71:cf:f4:da:41:
                    4e:97:84:64:0c:b4:4d:5f:cb:30:f5:47:a6:35:3d:
                    02:99:6f:3f:e9:e9:56:42:a0:58:54:21:04:87:f9:
                    7a:a5
                Exponent: 65537 (0x10001)
        Attributes:
            a0:00
    Signature Algorithm: sha256WithRSAEncryption
         74:99:e5:36:44:b4:48:a9:50:83:eb:61:02:37:6c:8a:46:45:
         0e:58:04:40:66:55:56:fc:fd:cf:15:a0:31:be:de:3a:16:4f:
         9a:46:1d:17:33:7f:38:dd:36:a9:76:e5:92:b2:48:29:60:e7:
         af:c0:f6:76:0d:9a:a6:40:43:a8:98:75:90:c3:c1:2a:7d:51:
         1d:df:1b:50:8b:69:ce:7c:74:cf:03:9d:69:6b:41:7f:ed:bc:
         f1:6c:c0:93:22:36:5e:f7:8c:d0:f7:f5:0f:dc:51:93:1e:23:
         cc:12:cd:f3:0e:6c:1b:4e:b2:df:01:86:5b:d0:79:c8:6e:c8:
         57:72:a8:dd:81:8a:af:c3:52:e2:ff:e8:f1:3d:6f:cb:e4:a9:
         1c:51:58:b9:31:00:c0:88:5e:ca:63:59:f8:d7:82:d4:22:30:
         0c:d8:bd:e6:01:11:d2:4a:68:64:d1:8e:d5:a1:19:0c:5a:99:
         25:cd:c2:e5:ed:f3:48:e3:c0:7a:00:a3:a8:09:8e:d3:50:2a:
         84:29:63:66:50:3e:42:af:43:ea:fa:5b:28:f9:f1:84:89:88:
         2e:7f:8d:bf:44:29:83:fa:89:b3:b8:3c:13:98:20:76:6c:d3:
         67:ce:03:9e:15:ea:3e:9d:4b:cb:c2:78:ab:57:1d:b7:e8:9e:
         81:1b:b5:1f


</code></pre>
</details>


## Certificate working with Nginx

    $ grep ssl_certificate /etc/nginx/sites-enabled/artifactoryv2.conf
    ssl_certificate       /etc/nginx/certs/www.artifactory.mycompany.com/www.artifactory.mycompany.com-server.crt;
    ssl_certificate_key   /etc/nginx/certs/www.artifactory.mycompany.com/www.artifactory.mycompany.com-server.key;

## Certificate working with Client
### Add certifactory in MacOS

    $ sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "/Users/marslo/Downloads/www.artifactory.mycompany.com-ca.crt"

### Find the added cert in MacOS

    $ security find-certificate -a -c <artifactory> -Z
    $ security find-certificate -a -c artifactor -Z | grep SHA-1
    SHA-1 hash: 915D019F0993F369C09D75C6B8DA201B8DE2636E

    $ security list-keychain
        "/Users/marslo/Library/Keychains/login.keychain-db"
        "/Library/Keychains/System.keychain"


<details><summary>Click to check details</summary>
<pre><code>$ security find-certificate -a -c artifactor -Z
SHA-1 hash: 915D019F0993F369C09D75C6B8DA201B8DE2636E
keychain: "/Library/Keychains/System.keychain"
version: 256
class: 0x80001000
attributes:
    "alis"<blob>="marslo.jiao@mycompany.com"
    "cenc"<uint32>=0x00000003
    "ctyp"<uint32>=0x00000001
    "hpky"<blob>=0x2332BC619E518E9422305BAE688A7E8E53D2457C  "#2\274a\236Q\216\224"0[\256h\212~\216S\322E|"
    "issu"<blob>=0x3081A3310B300906035504061302434E3110300E06035504080C075369636875616E3110300E06035504070C074368656E6764753110300E060355040A0C075068696C697073310C300A060355040B0C034344493128302606035504030C1F7077772E61727469666163746F72792E6364692E7068696C6970732E636F6D3126302406092A864886F70D01090116176D6172736C6F2E6A69616F407068696C6970732E636F6D  "0\201\2431\0130\011\006\003U\004\006\023\002CN1\0200\016\006\003U\004\010\014\007Sichuan1\0200\016\006\003U\004\007\014\007Chengdu1\0200\016\006\003U\004\012\014\007mycompany1\0140\012\006\003U\004\013\014\003CDI1(0&\006\003U\004\003\014\037www.artifactory.mycompany.com1&0$\006\011*\206H\206\367\015\001\011\001\026\027marslo.jiao@mycompany.com"
    "labl"<blob>="www.artifactory.mycompany.com"
    "skid"<blob>=0x2332BC619E518E9422305BAE688A7E8E53D2457C  "#2\274a\236Q\216\224"0[\256h\212~\216S\322E|"
    "snbr"<blob>=0x00D23054792B3142CE  "\000\3220Ty+1B\316"
    "subj"<blob>=0x3081A3310B300906035504061302434E3110300E06035504080C075369636875616E3110300E06035504070C074368656E6764753110300E060355040A0C075068696C697073310C300A060355040B0C034344493128302606035504030C1F7077772E61727469666163746F72792E6364692E7068696C6970732E636F6D3126302406092A864886F70D01090116176D6172736C6F2E6A69616F407068696C6970732E636F6D  "0\201\2431\0130\011\006\003U\004\006\023\002CN1\0200\016\006\003U\004\010\014\007Sichuan1\0200\016\006\003U\004\007\014\007Chengdu1\0200\016\006\003U\004\012\014\007mycompany1\0140\012\006\003U\004\013\014\003CDI1(0&\006\003U\004\003\014\037www.artifactory.mycompany.com1&0$\006\011*\206H\206\367\015\001\011\001\026\027marslo.jiao@mycompany.com"

$ security find-certificate -a -c artifactor -Z -p -m
SHA-1 hash: 915D019F0993F369C09D75C6B8DA201B8DE2636E
email addresses: marslo.jiao@mycompany.com
-----BEGIN CERTIFICATE-----
MIIELDCCAxSgAwIBAgIJANIwVHkrMULOMA0GCSqGSIb3DQEBCwUAMIGjMQswCQYD
VQQGEwJDTjEQMA4GA1UECAwHU2ljaHVhbjEQMA4GA1UEBwwHQ2hlbmdkdTEQMA4G
A1UECgwHUGhpbGlwczEMMAoGA1UECwwDQ0RJMSgwJgYDVQQDDB9wd3cuYXJ0aWZh
Y3RvcnkuY2RpLnBoaWxpcHMuY29tMSYwJAYJKoZIhvcNAQkBFhdtYXJzbG8uamlh
b0BwaGlsaXBzLmNvbTAeFw0xODAxMDIxMTM1MzFaFw0xOTAxMDIxMTM1MzFaMIGj
MQswCQYDVQQGEwJDTjEQMA4GA1UECAwHU2ljaHVhbjEQMA4GA1UEBwwHQ2hlbmdk
dTEQMA4GA1UECgwHUGhpbGlwczEMMAoGA1UECwwDQ0RJMSgwJgYDVQQDDB9wd3cu
YXJ0aWZhY3RvcnkuY2RpLnBoaWxpcHMuY29tMSYwJAYJKoZIhvcNAQkBFhdtYXJz
bG8uamlhb0BwaGlsaXBzLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBANA/tsXlUo3HJj/nCnpfwXEqnjQHfhBKPcRP999Ykw36AOghdW3RRX29J/LF
CBOPT76RnygZfsOnQhv8tJYhijNZeSejzxM+zZINfrmfDQG/J1/ken3baaN4lqjD
qS0xKJe6bCAXq+uFziwl6D6gi8ALsqnhrJ/hVzW7ZGqZLo8n8QRApxYyMU6tGF6e
C91CF6+KWMYa6QBSl3t6JMyxgY25IGDkltV3ggdO35w6JpXV7aqhJJRkDpOanpvU
eGtGUGkFGWr/ex0bD85rMDPHmZ1qMAz8+HQA32Vv+hskCnN3TZRFJ5uTpoE3V1dv
6a7kXqi4vjEPc0ueG+14XEjsC6UCAwEAAaNhMF8wDwYDVR0RBAgwBocEgpPbEzAd
BgNVHQ4EFgQUIzK8YZ5RjpQiMFuuaIp+jlPSRXwwHwYDVR0jBBgwFoAUIzK8YZ5R
jpQiMFuuaIp+jlPSRXwwDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEA
aaP+NWOl6E7mPk+d9oI9c/KnIsFG5QleYYG3cDxiukN9vaxn0EHqp7hBRwS8QZpG
NTE/YhB6WHNFOlk7QWsrHmJCt37Ba5IlKt8/abUmjsddxiSgZSG3Y3RgfzsOmoCk
T6J5IBmSZGC3U1wJbkZuetfu7/QuJ3oaDtpbi3q/QFafFmNriatIZQdF4KAhfA9t
nCqrytACBoo5eupluQQTD2vN6uWfWcXSBrLkw8urWWmqEeYISRLM1CkhK1nB3Lvm
qX2WaKR7YXaKIalppYPVi/YITsA0ZGtllqztzcELVH2pVwd3DGpDnk/AbBKI6M80
CGevHC+7SVQbF5WJsy3JXw==
-----END CERTIFICATE-----
</code></pre>
</details>


### Remove the cert in MacOS

    $ sudo security delete-certificate -Z 915D019F0993F369C09D75C6B8DA201B8DE2636E

### Other methods
<details><summary>Click to check details</summary>
<li>Others 1:</li>
<pre><code>$ cd /etc/nginx/
$ sudo openssl genrsa -des3 -out server.key 1024
$ sudo openssl req -new -key server.key -out server.csr
$ sudo cp server.key{,.org}
$ sudo cp server.csr{,.org}
$ sudo openssl rsa -in server.key.org -out server.key
$ sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
</pre></code>

<details><summary>Click to check details</summary>
<pre><code>$ ls -Altrh
total 80K
-rw-r--r--   1 root root 3.0K May  3  2017 win-utf
-rw-r--r--   1 root root  664 May  3  2017 uwsgi_params
-rw-r--r--   1 root root  636 May  3  2017 scgi_params
-rw-r--r--   1 root root  180 May  3  2017 proxy_params
-rw-r--r--   1 root root 1.5K May  3  2017 nginx.conf
-rw-r--r--   1 root root 3.9K May  3  2017 mime.types
-rw-r--r--   1 root root 2.2K May  3  2017 koi-win
-rw-r--r--   1 root root 2.8K May  3  2017 koi-utf
-rw-r--r--   1 root root 1007 May  3  2017 fastcgi_params
-rw-r--r--   1 root root 1.1K May  3  2017 fastcgi.conf
drwxr-xr-x   2 root root 4.0K Jul 27 04:11 modules-available
drwxr-xr-x   2 root root 4.0K Jul 27 04:11 conf.d
drwxr-xr-x   2 root root 4.0K Dec 26 18:08 sites-available
drwxr-xr-x   2 root root 4.0K Dec 26 18:08 snippets
drwxr-xr-x   2 root root 4.0K Dec 26 18:08 sites-enabled
drwxr-xr-x   2 root root 4.0K Dec 26 18:08 modules-enabled
$ sudo openssl genrsa -des3 -out server.key 1024
Generating RSA private key, 1024 bit long modulus
.................................................................++++++
......++++++
e is 65537 (0x10001)
Enter pass phrase for server.key: artifactory
Verifying - Enter pass phrase for server.key: artifactory

$ sudo openssl req -new -key server.key -out server.csr
Enter pass phrase for server.key: artifactory
You are about to be asked to enter information that will be incorporated into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:Sichuan
Locality Name (eg, city) []:Chengdu
Organization Name (eg, company) [Internet Widgits Pty Ltd]:mycompany
Organizational Unit Name (eg, section) []:mycompany
Common Name (e.g. server FQDN or YOUR name) []:docker-2.artifactory
Email Address []:marslo.jiao@mycompany.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:artifactory
An optional company name []:mycompany

$ ls -Altrh
total 80K
-rw-r--r-- 1 root root 3.0K May  3  2017 win-utf
-rw-r--r-- 1 root root  664 May  3  2017 uwsgi_params
-rw-r--r-- 1 root root  636 May  3  2017 scgi_params
-rw-r--r-- 1 root root  180 May  3  2017 proxy_params
-rw-r--r-- 1 root root 1.5K May  3  2017 nginx.conf
-rw-r--r-- 1 root root 3.9K May  3  2017 mime.types
-rw-r--r-- 1 root root 2.2K May  3  2017 koi-win
-rw-r--r-- 1 root root 2.8K May  3  2017 koi-utf
-rw-r--r-- 1 root root 1007 May  3  2017 fastcgi_params
-rw-r--r-- 1 root root 1.1K May  3  2017 fastcgi.conf
drwxr-xr-x 2 root root 4.0K Jul 27 04:11 modules-available
drwxr-xr-x 2 root root 4.0K Jul 27 04:11 conf.d
drwxr-xr-x 2 root root 4.0K Dec 26 18:08 sites-available
drwxr-xr-x 2 root root 4.0K Dec 26 18:08 snippets
drwxr-xr-x 2 root root 4.0K Dec 26 18:08 sites-enabled
drwxr-xr-x 2 root root 4.0K Dec 26 18:08 modules-enabled
-rw-r--r-- 1 root root  951 Dec 26 18:32 server.key
-rw-r--r-- 1 root root  785 Dec 26 18:36 server.csr
-rw-r--r-- 1 root root  951 Dec 26 18:38 server.key.org
-rw-r--r-- 1 root root  785 Dec 26 18:38 server.csr.org

$ sudo openssl rsa -in server.key.org -out server.key
Enter pass phrase for server.key.org:
writing RSA key

$ sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
Signature ok
subject=/C=CN/ST=Sichuan/L=Chengdu/O=mycompany/OU=mycompany/CN=docker-2.artifactory/emailAddress=marslo.jiao@mycompany.com
Getting Private key
</code></pre>
</details>

<li>Others 2:</li>
<pre><code>/etc/nginx$ sudo openssl req -newkey rsa:2048 -nodes -sha256 -keyout certs/www.artifactory.mycompany.com.key -x509 -days 365 -out certs/www.artifactory.mycompany.com.crt
Generating a 2048 bit RSA private key
........+++
..............................................................+++
writing new private key to 'certs/www.artifactory.mycompany.com.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:Sichuan
Locality Name (eg, city) []:Chengdu
Organization Name (eg, company) [Internet Widgits Pty Ltd]:mycompany
Organizational Unit Name (eg, section) []:mycompany
Common Name (e.g. server FQDN or YOUR name) []:www.artifactory.mycompany.com
Email Address []:marslo.jiao@mycompany.com
</code></pre>

<li><a href="https://www.digicert.com/easy-csr/openssl.htm">Other 3:</a></li>

<details><summary>genreate key and cert by one command</summary>
<pre><code>$ openssl req -new -newkey rsa:2048 -nodes -out www_artifactory__mycompany_com.csr -keyout www_artifactory__mycompany_com.key -subj "/C=CN/ST=Sichuan/L=Chengdu/O=mycompany/OU=CDI/CN=www.artifactory.mycompany.com"
</code></pre>
</details>

</details>



# Artifactory HTTPS

    $ sudo openssl genrsa -des3 -out artifactorykey 2048
    $ sudo openssl req -new -key artifactorykey -out artifactorycsr
    $ sudo cp artifactorykey{,.org}
    $ sudo openssl rsa -in artifactorykey.org -out artifactorykey
    $ sudo openssl x509 -req -days 365 -in artifactorycsr -signkey artifactorykey -out artifactorycrt

<details><summary>SSL with IP</summary>
<pre><code>$ sudo openssl genrsa -des3 -out artifactorykey 2048
Generating RSA private key, 2048 bit long modulus
.........................+++
........................................................................+++
e is 65537 (0x10001)
Enter pass phrase for artifactorykey: artifactory
Verifying - Enter pass phrase for artifactorykey: artifactory

$ sudo openssl req -new -key artifactorykey -out artifactorycsr
Enter pass phrase for artifactorykey: artifactory
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:Sichuan
Locality Name (eg, city) []:Chengdu
Organization Name (eg, company) [Internet Widgits Pty Ltd]:mycompany Ltd
Organizational Unit Name (eg, section) []:.
Common Name (e.g. server FQDN or YOUR name) []:192.168.1.102
Email Address []:.

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:.
An optional company name []:.

$ sudo cp artifactorykey{,.org}

$ sudo openssl rsa -in artifactorykey.org -out artifactorykey
Enter pass phrase for artifactorykey.org: artifactory
writing RSA key


$ sudo openssl x509 -req -days 365 -in artifactorycsr -signkey artifactorykey -out artifactorycrt
Signature ok
subject=/C=CN/ST=Sichuan/L=Chengdu/O=mycompany Ltd/CN=192.168.1.102
Getting Private key

$ openssl x509 -text -noout -in ssl_ip/artifactorycrt
Certificate:
    Data:
        Version: 1 (0x0)
        Serial Number: 9804858425156156035 (0x8811daca106dba83)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=CN, ST=Sichuan, L=Chengdu, O=mycompany Ltd, CN=192.168.1.102
        Validity
            Not Before: Dec 26 16:23:15 2017 GMT
            Not After : Dec 26 16:23:15 2018 GMT
        Subject: C=CN, ST=Sichuan, L=Chengdu, O=mycompany Ltd, CN=192.168.1.102
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:ad:32:26:35:8a:8f:09:82:ff:59:61:14:14:1b:
                    9c:da:02:74:09:48:2a:d5:05:1d:ad:8a:d0:e0:70:
                    1f:9b:44:b4:df:4d:c5:4c:5a:1b:8a:52:7b:2a:69:
                    a2:77:d3:cf:c7:fb:a6:ef:34:d1:bb:23:8d:d0:78:
                    e6:48:3f:8c:12:3c:69:d5:62:2d:74:24:b8:49:a8:
                    59:c7:36:5f:64:97:5a:d1:8f:9a:5b:2f:aa:a8:65:
                    6c:75:28:60:55:b9:2a:5b:41:71:a4:fa:eb:10:7e:
                    84:4b:fb:c3:57:9c:55:8e:e8:2a:4a:c1:45:74:54:
                    58:d5:09:0d:59:d4:14:94:db:5b:67:91:9c:23:24:
                    c4:07:10:d1:f1:28:fa:97:38:01:da:81:c4:f3:63:
                    d7:84:24:dc:3c:ff:04:64:b2:3e:41:f0:d8:08:66:
                    06:cc:7c:05:3c:90:97:0b:02:b6:b5:2f:03:28:b7:
                    4c:38:aa:84:23:3e:9e:d4:b0:3a:58:4c:f3:74:df:
                    36:63:f2:18:ac:d1:0d:ef:05:6b:f3:dc:b6:d3:c7:
                    f0:91:7b:b8:69:4f:ae:19:da:34:b7:38:1e:e2:9a:
                    10:2e:a9:a0:54:f6:61:b9:da:e6:98:c8:9b:76:83:
                    d6:59:77:d9:18:c6:57:8c:cf:af:a4:89:5a:87:99:
                    c4:15
                Exponent: 65537 (0x10001)
    Signature Algorithm: sha256WithRSAEncryption
         5a:06:ad:9b:d0:07:d7:9b:92:2a:77:71:ff:80:6e:c1:39:bd:
         81:e8:0f:21:39:bd:80:3e:96:a9:6b:7a:73:f1:80:70:4e:b1:
         d4:b7:1e:54:be:62:dc:35:c0:b9:d8:8c:d1:24:75:8a:42:ec:
         a9:dd:9b:9a:f2:4b:ad:6e:38:d7:a2:fa:7a:70:be:7b:8c:37:
         63:71:10:fe:73:18:de:e5:9c:c5:6e:1a:4e:cb:7b:51:26:56:
         68:56:fb:4f:71:d7:7b:94:b6:55:b9:f8:9b:31:a8:26:a5:e5:
         32:36:33:65:7b:1d:9f:27:7d:f1:b0:d2:06:7c:75:d7:39:bb:
         7a:44:92:e1:b8:fc:2b:fd:3c:43:93:d6:47:19:f6:ad:d3:cc:
         82:dd:15:bd:d3:a0:e2:2d:92:fd:65:44:60:44:21:b9:1f:31:
         fd:91:c2:78:86:d9:aa:77:fd:54:ae:2f:4c:ae:5d:5e:c7:a3:
         43:0d:6b:32:23:d9:61:b6:a7:c4:47:eb:bc:c2:79:6c:06:f0:
         a6:af:e8:45:c6:02:d5:1c:09:26:8a:a7:b0:ff:74:50:85:82:
         1d:88:b2:2c:eb:20:3e:bf:3b:4e:9b:ab:b7:4f:e8:14:a8:1a:
         33:50:e9:a8:24:3e:5e:2a:68:ea:fa:f3:12:30:94:8e:0f:0d:
         da:6c:17:60
</code></pre>
</details>

<details><summary>SSL With Domain</summary>
<pre><code>$ sudo openssl genrsa -des3 -out artifactorykey 2048
Generating RSA private key, 2048 bit long modulus
........................+++
.......................................+++
e is 65537 (0x10001)
Enter pass phrase for artifactorykey: artifactory
Verifying - Enter pass phrase for artifactorykey: artifactory

$ sudo openssl req -new -key artifactorykey -out artifactorycsr
Enter pass phrase for artifactorykey: artifactory
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:Sichuan
Locality Name (eg, city) []:Chengdu
Organization Name (eg, company) [Internet Widgits Pty Ltd]:mycompany Ltd
Organizational Unit Name (eg, section) []:mycompany CDI
Common Name (e.g. server FQDN or YOUR name) []:docker-1.artifactory
Email Address []:.

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:.
An optional company name []:.

$ sudo cp artifactorykey{,.org}

$ sudo openssl rsa -in artifactorykey.org -out artifactorykey
Enter pass phrase for artifactorykey.org: artifactory
writing RSA key

$ sudo openssl x509 -req -days 365 -in artifactorycsr -signkey artifactorykey -out artifactorycrt
Signature ok
subject=/C=CN/ST=Sichuan/L=Chengdu/O=mycompany Ltd/OU=mycompany CDI/CN=docker-1.artifactory
Getting Private key

$ openssl x509 -text -noout -in ssl/artifactorycrt
Certificate:
    Data:
        Version: 1 (0x0)
        Serial Number: 15006671364169185053 (0xd0426818d254b71d)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=CN, ST=Sichuan, L=Chengdu, O=mycompany Ltd, OU=mycompany CDI, CN=docker-1.artifactory
        Validity
            Not Before: Dec 26 16:02:10 2017 GMT
            Not After : Dec 26 16:02:10 2018 GMT
        Subject: C=CN, ST=Sichuan, L=Chengdu, O=mycompany Ltd, OU=mycompany CDI, CN=docker-1.artifactory
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:dc:30:6b:83:56:92:fb:f3:fb:bc:da:3e:a9:5c:
                    67:c3:19:42:9a:8f:8f:30:e6:27:fa:a9:9d:c9:3e:
                    9c:31:3d:aa:d8:9f:ae:9b:64:b0:75:2a:01:51:ad:
                    04:c4:00:5d:f4:f8:b4:af:bb:20:f3:77:45:65:28:
                    d8:38:28:b2:03:46:d0:67:d1:91:8e:7b:65:66:a0:
                    7e:a5:e2:fe:80:00:5e:54:95:50:52:9c:44:2a:aa:
                    dc:a2:80:be:16:07:79:b4:13:1d:f5:8a:ca:c3:ab:
                    1c:76:de:f3:b8:23:9b:54:17:28:be:ac:e5:68:5c:
                    f3:83:49:61:55:d2:e1:ea:0c:e7:72:75:6e:90:5a:
                    90:a8:85:01:c6:cc:69:94:5b:c4:f9:14:6d:70:0a:
                    8e:45:e0:b9:28:aa:99:3a:22:12:db:0b:d7:d9:6e:
                    aa:35:36:5e:e6:00:eb:99:ab:46:6d:7b:e5:12:b1:
                    f9:0c:5c:d3:c0:47:7b:b3:e4:03:15:fa:8d:42:f8:
                    a1:c1:ce:dc:42:d2:81:88:18:0d:26:28:7e:90:cf:
                    e8:05:84:75:94:e9:ac:20:47:95:c7:50:1c:d8:42:
                    c3:d7:8b:90:f9:a9:48:cc:a5:8d:88:3b:54:a9:ef:
                    20:ce:ee:4c:6d:04:65:eb:6c:f7:22:9d:c8:13:33:
                    b1:6d
                Exponent: 65537 (0x10001)
    Signature Algorithm: sha256WithRSAEncryption
         c3:c7:c8:0d:19:d1:0b:05:ac:11:e3:e4:af:25:0e:95:f5:f5:
         31:ed:90:4e:7f:1a:2b:a2:2f:4d:a3:d9:57:40:a2:f6:af:55:
         90:53:bf:72:39:81:5d:53:41:85:e0:1d:26:9f:9e:33:05:46:
         9c:fc:51:99:19:5c:7d:ef:aa:cc:50:61:0b:f4:11:69:bd:9e:
         2a:34:48:e9:9d:7c:d0:e0:80:a5:42:67:ac:8e:0c:d6:84:19:
         8e:cb:05:97:9f:21:c5:e0:78:8f:97:f6:53:fa:f2:ec:49:3f:
         fb:11:68:ed:ea:c0:8c:c5:be:08:61:e4:bd:4e:05:5f:89:99:
         f6:47:6f:b3:1e:5f:49:62:ff:37:dc:f0:c4:4b:bb:a4:15:06:
         b1:80:4d:24:ef:bb:25:d6:a5:60:13:34:57:73:ba:b4:b0:8b:
         42:0f:18:ef:0e:17:60:83:4d:61:bd:ef:55:b9:52:6a:47:ab:
         c3:ee:b3:11:27:86:aa:87:18:d5:60:b8:b4:34:c2:fa:75:48:
         0e:f1:f4:30:b3:fa:b3:ad:a9:8a:6e:e6:62:71:02:5a:72:bd:
         5c:45:a0:23:ea:1d:84:16:24:3d:88:a0:12:20:61:7a:f8:bd:
         dc:0f:fb:26:c0:f3:2f:1f:66:7e:64:35:b6:45:05:c4:00:43:
         2d:18:da:a1
</code></pre>
</details>

