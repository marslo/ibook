<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [manage certificate in OS (client)](#manage-certificate-in-os-client)
  - [OSX](#osx)
    - [add](#add)
    - [search](#search)
    - [remove](#remove)
    - [others](#others)
  - [Windows](#windows)
  - [Linux](#linux)
    - [ubuntu](#ubuntu)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


# manage certificate in OS (client)
## OSX
### add
```bash
$ sudo security add-trusted-cert -d \
                                 -r trustRoot \
                                 -k "/Library/Keychains/System.keychain" \
                                 "/Users/marslo/Downloads/ca.crt"
```

### search
{% codetabs name="command", type="bash" -%}
$ security find-certificate -a -c <artifactory> -Z
$ security find-certificate -a -c artifactor -Z | grep SHA-1
SHA-1 hash: 915D019F0993F369C09D75C6B8DA201B8DE2636E

$ security list-keychain
    "/Users/marslo/Library/Keychains/login.keychain-db"
    "/Library/Keychains/System.keychain"
{%- language name="more details", type="bash" -%}
$ security find-certificate -a -c artifactor -Z
SHA-1 hash: 915D019F0993F369C09D75C6B8DA201B8DE2636E
keychain: "/Library/Keychains/System.keychain"
version: 256
class: 0x80001000
attributes:
    "alis"<blob>="marslo.jiao@mycompany.com"
    "cenc"<uint32>=0x00000003
    "ctyp"<uint32>=0x00000001
    "hpky"<blob>=0x2332BC619E***  "#2\274a\236Q\216\224"0[\256h\212~\216S\322E|"
    "issu"<blob>=0x3081A3310B*** "0\201\..Sichuan1\0200\016\..Chengdu1\0200\016\..mycompany1\0140\012\..CDI1(0&\006\..sample.artifactory.com1&0$\006\011*\206H\206\..marslo.jiao@mycompany.com"
    "labl"<blob>="sample.artifactory.com"
    "skid"<blob>=0x2332BC619E***  "#2\274a\236Q\216\224"0[\256h\212~\216S\322E|"
    "snbr"<blob>=0x00D2305479***  "\000\3220Ty+1B\316"
    "subj"<blob>=0x3081A3310B***  "0\201\..Sichuan1\0200\016\..Chengdu1\0200\016\..mycompany1\0140\012\..CDI1(0&\006\..sample.artifactory.com1&0$\006\011*\206H\206\..marslo.jiao@mycompany.com"

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
{%- endcodetabs %}

### remove
```bash
$ sudo security delete-certificate -Z 915D019F0993F369C09D75C6B8DA201B8DE2636E
```

### others
- 1st:
{% codetabs name="command", type="bash" -%}
$ cd /etc/nginx/
$ sudo openssl genrsa -des3 -out server.key 1024
$ sudo openssl req -new -key server.key -out server.csr
$ sudo cp server.key{,.org}
$ sudo cp server.csr{,.org}
$ sudo openssl rsa -in server.key.org \
                   -out server.key
$ sudo openssl x509 -req \
                    -days 365 \
                    -signkey server.key \
                    -in server.csr \
                    -out server.crt
{%- language name="more details", type="bash" -%}

$ ls -Altrh
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

$ sudo openssl req -new \
                   -key server.key \
                   -out server.csr
Enter pass phrase for server.key: artifactory
You are about to be asked to enter information that will be incorporated into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
*****
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

$ sudo openssl rsa \
              -in server.key.org \
              -out server.key
Enter pass phrase for server.key.org:
writing RSA key

$ sudo openssl x509 -req \
                    -days 365 \
                    -signkey server.key \
                    -in server.csr \
                    -out server.crt
Signature ok
subject=/C=CN/ST=Sichuan/L=Chengdu/O=mycompany/OU=mycompany/CN=docker-2.artifactory/emailAddress=marslo.jiao@mycompany.com
Getting Private key
{%- endcodetabs %}


- 2nd:
  ```bash
  /etc/nginx$ sudo openssl req \
                           -x509 \
                           -nodes \
                           -sha256 \
                           -days 365 \
                           -newkey rsa:2048 \
                           -keyout certs/sample.artifactory.com.key \
                           -out certs/sample.artifactory.com.crt
  Generating a 2048 bit RSA private key
  ........+++
  ..............................................................+++
  writing new private key to 'certs/sample.artifactory.com.key'
  -----
  You are about to be asked to enter information that will be incorporated
  into your certificate request.
  What you are about to enter is what is called a Distinguished Name or a DN.
  There are quite a few fields but you can leave some blank
  For some fields there will be a default value,
  If you enter '.', the field will be left blank.

  *****
  Country Name (2 letter code) [AU]:CN
  State or Province Name (full name) [Some-State]:Sichuan
  Locality Name (eg, city) []:Chengdu
  Organization Name (eg, company) [Internet Widgits Pty Ltd]:mycompany
  Organizational Unit Name (eg, section) []:mycompany
  Common Name (e.g. server FQDN or YOUR name) []:sample.artifactory.com
  Email Address []:marslo.jiao@mycompany.com
  ```

- [3rd: genreate key and cert by one command](https://www.digicert.com/easy-csr/openssl.htm)
  ```bash
  $ openssl req -new \
                -newkey rsa:2048 \
                -nodes \
                -out www_artifactory__mycompany_com.csr \
                -keyout www_artifactory__mycompany_com.key \
                -subj "/C=CN/ST=Sichuan/L=Chengdu/O=mycompany/OU=CDI/CN=sample.artifactory.com"
  ```

## Windows
## Linux
### ubuntu
- add
  ```bash
  $ sudo cp ca.crt /usr/local/share/ca-certificates/
  $ ls -Altrh !$
  ls -altrh /usr/local/share/ca-certificates/
  total 12K
  -rw-r--r-- 1 root root 1.5K Jan  3 16:03 ca.crt

  $ sudo update-ca-certificates
  Updating certificates in /etc/ssl/certs...
  1 added, 0 removed; done.
  Running hooks in /etc/ca-certificates/update.d...
  done.

  $ sudo systemctl restart docker.service
  ```
- remove
  ```bash
  $ sudo rm -rf /usr/local/share/ca-certificates/ca.crt
  $ sudo update-ca-certificates --fresh
  $ sudo systemctl restart docker.service
  ```

