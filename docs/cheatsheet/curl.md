<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [install via source](#install-via-source)
- [get](#get)
  - [get JSON](#get-json)
  - [get XML](#get-xml)
  - [get `http_code` or `response_code`](#get-http_code-or-response_code)
  - [get `http_code` for multiple urls](#get-http_code-for-multiple-urls)
  - [get `size_download`](#get-size_download)
  - [get time](#get-time)
- [post](#post)
  - [post JSON data using Curl](#post-json-data-using-curl)
  - [post a file using Curl](#post-a-file-using-curl)
  - [post form data using Curl](#post-form-data-using-curl)
  - [post XML](#post-xml)
- [put](#put)
  - [send PUT request](#send-put-request)
- [delete](#delete)
  - [send a DELETE request](#send-a-delete-request)
- [authorization](#authorization)
  - [Basic Auth Credentials](#basic-auth-credentials)
  - [Bearer Token Authorization Header](#bearer-token-authorization-header)
  - [Curl with a proxy](#curl-with-a-proxy)
- [content type](#content-type)
  - [set the content type for a Curl request](#set-the-content-type-for-a-curl-request)
- [others](#others)
  - [ssl](#ssl)
  - [send http header with curl request](#send-http-header-with-curl-request)
  - [set a timeout](#set-a-timeout)
  - [send a head request](#send-a-head-request)
  - [send a OPTIONS request](#send-a-options-request)
  - [send a CORS request](#send-a-cors-request)
  - [send Cookies](#send-cookies)
  - [set the User-Agent string](#set-the-user-agent-string)
- [convert](#convert)
  - [convert to python requests](#convert-to-python-requests)
  - [convert to javascript/ajax calls](#convert-to-javascriptajax-calls)
  - [convert to php code](#convert-to-php-code)
  - [convert to http request](#convert-to-http-request)
- [12 Essential Curl Commands for Linux, Windows and macOS](#12-essential-curl-commands-for-linux-windows-and-macos)
- [references](#references)
  - [Top 20 Curl Flags](#top-20-curl-flags)
  - [write-out](#write-out)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [online rest & soap api testing tool : curl](https://reqbin.com/curl)
> - [curl.1 the man page](https://curl.se/docs/manpage.html)
>
> available %-symbols:
> - `content_type`
> - `curl_version`
> - `errormsg`
> - `exitcode`
> - `filename_effective`
> - `ftp_entry_path`
> - `http_code` - The numerical response code that was found in the last retrieved HTTP(S) or FTP(s) transfer
> - `http_connect`
> - `http_version`
> - `json`
> - `local_ip`
> - `local_port`
> - `method`
> - `num_connects`
> - `num_headers`
> - `num_redirects`
> - `proxy_ssl_verify_result`
> - `redirect_url`
> - `referer`
> - `remote_ip`
> - `remote_port`
> - `response_code` - The numerical response code that was found in the last transfer (formerly known as `http_code`)
> - `scheme`
> - `size_download`
> - `size_header`
> - `size_request`
> - `size_upload`
> - `speed_download`
> - `speed_upload`
> - `ssl_verify_result`
> - `stderr`
> - `stdout`
> - `time_appconnect`
> - `time_connect`
> - `time_namelookup`
> - `time_pretransfer`
> - `time_redirect`
> - `time_starttransfer`
> - `time_total`
> - `url`
> - `url_effective`
> - `urlnum`
>
> - get via
>   ```bash
>   $ curl -sSLg \
>          -k \
>          -o /dev/null \
>          -w "%{json}" \
>          https://domain.name.com |
>     jq -r 'keys[]' |
>     sort
>   ```
{% endhint %}

## install via source

> [!NOTE|label:references:]
> - [Re: Using libcurl to send shell commands through SSH?](https://curl.se/mail/lib-2018-06/0124.html)
>   - [libcurl 8](https://github.com/curl/curl/wiki/libcurl-8)
> - [How to Build and Install latest cURL version on CentOS and Ubuntu?](https://geekflare.com/curl-installation/)
> - [how to install curl and libcurl](https://github.com/curl/curl/blob/master/docs/INSTALL.md)
> - [release curl/curl](https://github.com/curl/curl/releases)

- environment
  ```bash
  $ sudo dnf install -y wget gcc openssl-devel libssh2 libssh2-devel libssh2-docs
  $ curl -fsSLgk -O https://github.com/curl/curl/releases/download/curl-8_2_1/curl-8.2.1.tar.gz
  $ tar xzf curl-8.2.1.tar.gz
  $ cd curl-8.2.1
  ```

- build

  > [!NOTE|label:references]
  > - `--prefix=/usr/local` will install in :
  >   - `/usr/local/lib`
  >   - `/usr/local/bin`
  >   - `/usr/local/include`
  >   - `/usr/local/share`

  ```bash
  $ ./configure --with-libssh \
                --with-libssh2 \
                --with-ssl \
                --enable-websockets
                --with-gssapi \
                --prefix=/opt/curl \
  ...

  configure: Configured to build curl/libcurl:

    Host setup:       x86_64-pc-linux-gnu
    Install prefix:   /opt/curl
    Compiler:         gcc
     CFLAGS:          -Werror-implicit-function-declaration -O2 -Wno-system-headers -pthread
     CPPFLAGS:
     LDFLAGS:
     LIBS:            -lssh2 -lssh2 -lssl -lcrypto -lssl -lcrypto -lgssapi_krb5 -lzstd -lz

    curl version:     8.2.1
    SSL:              enabled (OpenSSL)
    SSH:              enabled (libSSH2)
    zlib:             enabled
    brotli:           no      (--with-brotli)
    zstd:             enabled (libzstd)
    GSS-API:          enabled (MIT Kerberos/Heimdal)
    GSASL:            no      (libgsasl not found)
    TLS-SRP:          enabled
    resolver:         POSIX threaded
    IPv6:             enabled
    Unix sockets:     enabled
    IDN:              no      (--with-{libidn2,winidn})
    Build libcurl:    Shared=yes, Static=yes
    Built-in manual:  enabled
    --libcurl option: enabled (--disable-libcurl-option)
    Verbose errors:   enabled (--disable-verbose)
    Code coverage:    disabled
    SSPI:             no      (--enable-sspi)
    ca cert bundle:   /etc/pki/tls/certs/ca-bundle.crt
    ca cert path:     no
    ca fallback:      no
    LDAP:             no      (--enable-ldap / --with-ldap-lib / --with-lber-lib)
    LDAPS:            no      (--enable-ldaps)
    RTSP:             enabled
    RTMP:             no      (--with-librtmp)
    PSL:              no      (libpsl not found)
    Alt-svc:          enabled (--disable-alt-svc)
    Headers API:      enabled (--disable-headers-api)
    HSTS:             enabled (--disable-hsts)
    HTTP1:            enabled (internal)
    HTTP2:            no      (--with-nghttp2, --with-hyper)
    HTTP3:            no      (--with-ngtcp2 --with-nghttp3, --with-quiche, --with-msh3)
    ECH:              no      (--enable-ech)
    WebSockets:       enabled
    Protocols:        DICT FILE FTP FTPS GOPHER GOPHERS HTTP HTTPS IMAP IMAPS MQTT POP3 POP3S RTSP SCP SFTP SMB SMBS SMTP SMTPS TELNET TFTP WS WSS
    Features:         AsynchDNS GSS-API HSTS HTTPS-proxy IPv6 Kerberos Largefile NTLM NTLM_WB SPNEGO SSL TLS-SRP UnixSockets alt-svc libz threadsafe zstd

    WARNING:  Websockets enabled but marked EXPERIMENTAL. Use with caution!

  $ make -j
  $ sudo make install

  # check
  $ tree -L 2 /opt/curl
  /opt/curl
  ├── bin
  │   ├── curl
  │   └── curl-config
  ├── include
  │   └── curl
  ├── lib
  │   ├── libcurl.a
  │   ├── libcurl.la
  │   ├── libcurl.so -> libcurl.so.4.8.0
  │   ├── libcurl.so.4 -> libcurl.so.4.8.0
  │   ├── libcurl.so.4.8.0
  │   └── pkgconfig
  └── share
      ├── aclocal
      └── man
  ```

- set

  > [!NOTE|label:OPTIONAL]
  > no need if using `/usr/local` as `--prefix`

  ```bash
  $ sudo update-alternatives --install /usr/local/bin/curl curl /opt/curl/bin/curl 999
  $ sudo update-alternatives --install /usr/local/bin/curl-config curl-config /opt/curl/bin/curl-config 999

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export LD_RUN_PATH=/usr/local/lib:$LD_RUN_PATH
  ```

- check
  ```bash
  $ alternatives --list | grep curl
  curl                    auto    /opt/curl/bin/curl
  curl-config             auto    /opt/curl/bin/curl-config

  $ curl --version
  curl 8.2.1 (x86_64-pc-linux-gnu) libcurl/8.2.1 OpenSSL/1.1.1k-fips zlib/1.2.11 zstd/1.4.4 libssh2/1.9.0
  Release-Date: 2023-07-26
  Protocols: dict file ftp ftps gopher gophers http https imap imaps mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp ws wss
  Features: alt-svc AsynchDNS GSS-API HSTS HTTPS-proxy IPv6 Kerberos Largefile libz NTLM NTLM_WB SPNEGO SSL threadsafe TLS-SRP UnixSockets zstd

  $ curl --help all
  ```

## get
### [get JSON](https://reqbin.com/req/c-vdhoummp/curl-get-json-example)
```bash
$ curl https://reqbin.com/echo/get/json \
       -H "Accept: application/json"
```

### [get XML](https://reqbin.com/req/c-eanbjsr1/curl-get-xml-example)
```bash
$ curl https://reqbin.com/echo/get/xml \
       -H "Accept: application/xml"
```

### [get `http_code` or `response_code`](https://superuser.com/a/442395/112396)
```bash
$ curl -s -o /dev/null -w "%{http_code}" https://github.com
200
```

- or
  ```bash
  $ curl -s -o /dev/null -w "response: '%{response_code}'" https://github.com
  response: '200'
  ```

- or
  ```bash
  $ curl -sSgL -X GET https://github.com/fake/url | sed -nre 's!^.*"status"\s*:\s*([0-9]+).*$!\1!gp'
  404
  ```

- [or](https://superuser.com/a/1444693/112396)
  ```bash
  $ curl http://www.example.org -o >(cat >&1) -w "%{http_code}\n" 1>&2
  ```

### get `http_code` for multiple urls
```bash
$ xargs -n1 curl -sk -o /dev/null -w '%{http_code} ' < <(echo "https://1.domain.com https://2.domain.com")

# i.e.:
$ xargs -n1 curl -sk -o /dev/null -w '%{http_code} ' < <(echo "https://stackoverflow.com/questions/3110444/ https://stackoverflow.com/questions/3110444/")
301 301
```

- or
  ```bash
  $ echo "https://1.domain.com
  https://2.domain.com
  " > urls.txt
  $ xargs -n1 curl -sk -o /dev/null -w '%{http_code} ' < urls.txt
  ```

- or
  ```bash
  $ curl -sSgL -X GET https://1.domain.com https://2.domain.com | sed -nre 's!^.*"status"\s*:\s*([0-9]+).*$!\1!gp'
  404
  200
  ```


### [get `size_download`](https://superuser.com/a/1257030/112396)
```bash
$ curl -R -s -S -w "\nhttp: %{http_code}. size: %{size_download}\n" -o /dev/null https://github.com
```

### [get time](https://www.shellhacks.com/check-website-response-time-linux-command-line/)
```bash
$ curl -s \
       -w 'results: \n
           Lookup time:\t%{time_namelookup}
           Connect time:\t%{time_connect}
           PreXfer time:\t%{time_pretransfer}
           StartXfer time:\t%{time_starttransfer}
           AppCon time:\t%{time_appconnect}
           Redirect time:\t%{time_redirect}\n
           Total time:\t%{time_total}\n' \
       -o /deve/null \
       https://github.com

results:

         Lookup time: 0.001288
         Connect time:  0.001617
         PreXfer time:  0.080264
         StartXfer time:  0.119895
         AppCon time: 0.080165
         Redirect time: 0.000000

         Total time:  0.120600
```

## post
### [post JSON data using Curl](https://reqbin.com/req/c-dwjszac0/curl-post-json-example)
```bash
$ curl -X POST https://reqbin.com/echo/post/json \
       -H 'Content-Type: application/json' \
       -d '{"login":"my_login","password":"my_password"}'
```

### [post a file using Curl](https://reqbin.com/req/c-dot4w5a2/curl-post-file)
```bash
$ curl -d @data.json https://reqbin.com/echo/post/json
```

### [post form data using Curl](https://reqbin.com/req/c-sma2qrvp/curl-post-form-example)
```bash
$ curl -X POST https://reqbin.com/echo/post/form \
       -H "Content-Type: application/x-www-form-urlencoded" \
       -d "param1=value1&param2=value2"
```

### [post XML](https://reqbin.com/req/c-yzrfjhug/curl-post-xml-example)
```bash
$ curl -X POST https://reqbin.com/echo/post/xml \
       -H "Content-Type: application/xml" \
       -H "Accept: application/xml" \
       -d "<Request><Login>my_login</Login><Password>my_password</Password></Request>"
```

## put
### [send PUT request](https://reqbin.com/req/c-d4os3720/curl-put-example)
```bash
$ curl -X PUT https://reqbin.com/echo/put/json \
       -d "PUT request data"
```

## delete

{% hint style='tip' %}
> syntax:
> ```bash
> $ curl -X DELETE [URL] [options]
> ```
{% endhint %}

### [send a DELETE request](https://reqbin.com/req/c-1dw4uds4/curl-delete-request-example)
```bash
$ curl -X DELETE http://reqbin.com/sample/delete/json?id=1 \
       -H "Accept: application/json"
```

## authorization
### [Basic Auth Credentials](https://reqbin.com/req/c-haxm0xgr/curl-basic-auth-example)
```bash
$ curl https://reqbin.com/echo \
       -u "login:password"
```

### [Bearer Token Authorization Header](https://reqbin.com/req/c-hlt4gkzd/curl-bearer-token-authorization-header-example)
```bash
$ curl https://reqbin.com/echo/get/json \
       -H "Accept: application/json" \
       -H "Authorization: Bearer {token}"
```

### [Curl with a proxy](https://reqbin.com/req/c-ddxflki5/curl-proxy-server)
```bash
$ curl https://reqbin.com/echo \
       -x myproxy.com:8080 \
       -U login:password
```


## content type
### [set the content type for a Curl request](https://reqbin.com/req/c-woh4qwov/curl-content-type)
```bash
$ curl -X POST https://reqbin.com/echo/post/json \
       -H 'Content-Type: application/json' \
       -H 'Accept: application/json' \
       -d '{"Id": 78912, "Quantity": 1, "Price": 19.00}'
```

## others

### ssl
#### [ignore invalid and self-signed SSL certificate errors in Curl](https://reqbin.com/req/c-ug1qqqwh/curl-ignore-certificate-checks)
```bash
$ curl -k https://expired.badssl.com
```

#### [make HTTPS requests with Curl](https://reqbin.com/req/c-lfozgltr/curl-https-request)
```bash
$ curl -k https://expired.badssl.com
```

#### [with SSL connections](https://reqbin.com/req/c-bw1fsypn/curl-ssl-request)
```bash
$ curl -k https://expired.badssl.com
```

### [send http header with curl request](https://reqbin.com/req/c-ea0d5rlb/curl-send-header-example)
```bash
$ curl https://reqbin.com/echo/get/json \
       -H "X-Custom-Header: value" \
       -H "Content-Type: application/json"
```

### [set a timeout](https://reqbin.com/req/c-70cqyayb/curl-timeout)
```bash
$ curl --connection-timeout 5 https://reqbin.com/echo
```

### [send a head request](https://reqbin.com/req/c-tmyvmbgu/curl-head-request-example)
```bash
$ curl -I https://reqbin.com/echo
```

### [send a OPTIONS request](https://reqbin.com/req/c-d8nxa0fl/curl-options-request)
```bash
$ curl https://api.reqbin.com/api/v1/requests \
       -X OPTIONS  \
       -H "Access-Control-Request-Method: POST" \
       -H "Access-Control-Request-Headers: content-type" \
       -H "Origin: https://reqbin.com"
```

### [send a CORS request](https://reqbin.com/req/c-taimahsa/curl-cors-request)
```bash
$ curl -H "Origin: https://example.reqbin.com" \
       https://reqbin.com/echo
```

### [send Cookies](https://reqbin.com/req/c-bjcj04uw/curl-send-cookies-example)
```bash
$ curl --cookie "Name=Value" https://reqbin.com/echo
```

### [set the User-Agent string](https://reqbin.com/req/c-ekublyqq/curl-user-agent)
```bash
$ curl https://reqbin.com/echo \
       -A "ReqBin Curl Client/1.0"
```

## convert
### [convert to python requests](https://reqbin.com/req/python/c-xgafmluu/convert-curl-to-python-requests)
```bash
$ curl -X POST https://reqbin.com/echo/post/json \
       -H "Content-Type: application/json" \
       -d "{\"login\":\"my_login\",\"password\":\"my_password\"}"
```

### [convert to javascript/ajax calls](https://reqbin.com/req/javascript/c-wyuctivp/convert-curl-to-javascript)
```bash
$ curl -X POST https://reqbin.com/echo/post/json \
       -H "Content-Type: application/json" \
       -d "{\"login\":\"my_login\",\"password\":\"my_password\"}"
```

### [convert to php code](https://reqbin.com/req/php/c-kvv2ga1h/convert-curl-to-php)
```bash
$ curl -X POST https://reqbin.com/echo/post/json \
       -H "Content-Type: application/json" \
       -d "{\"login\":\"my_login\",\"password\":\"my_password\"}"
```

### [convert to http request](https://reqbin.com/req/c-w7oitglz/convert-curl-to-http-request)
```bash
$ curl https://reqbin.com/echo/get/json \
       -H "Content-Type: application/json" \
       -H "Accept: application/json"
```

## [12 Essential Curl Commands for Linux, Windows and macOS](https://reqbin.com/req/c-kdnocjul/curl-commands)
* get resource content by url
  ```bash
  $ curl https://reqbin.com/echo
  ```
* save url content to a file
  ```bash
  $ curl -o logo.png https://reqbin.com/static/img/logo.png
  ```
* download multiple files at once
  ```bash
  $ curl -O https://reqbin.com/static/img/code/curl.png \
         -O https://reqbin.com/static/img/code/java.png \
         -O https://reqbin.com/static/img/code/python.png
  ```
* check page http headers
  ```bash
  ```
* force curl to use http/2 protocol
  ```bash
  $ curl --http2 https://reqbin.com
  ```
* do follow redirects
  ```bash
  $ curl -L http://www.reqbin.com/echo
  ```
* use proxy server
  ```bash
  $ curl -x proxy.domain.com:8080 -U user:password https://reqbin.com
  ```
* provide additional http headers with request
  ```bash
  $ curl -H "Accept: application/json" https://reqbin.com/echo/get/json
  ```
* send data to the server
  ```bash
  $ curl -d '{"id": 123456}' \
         -H "Content-Type: application/json" \
         https://reqbin.com/echo/post/json
  ```
* change the user-agent string
  ```bash
  $ curl --user-agent "MyAppName 1.0" https://reqbin.com/echo
  ```
* send cookies to website
  ```bash
  $ curl -b "name1=value1; name2=value2" https://reqbin.com
  ```

## references
### [Top 20 Curl Flags](https://reqbin.com/req/c-skhwmiil/curl-flags-example)

|         Flags        | Description                                                         | Syntax                                                 |
|:--------------------:|---------------------------------------------------------------------|--------------------------------------------------------|
|         `-O`         | Download the file and save it under the original name               | `curl -O [URL]`                                        |
|         `-o`         | Download the file and save it with a different name                 | `curl -o [file name] [URL]`                            |
|         `-X`         | Specify the HTTP method to be used when sending the request         | `curl -X [method] [URL]`                               |
|     `-I or -head`    | Print the title without the body of the document                    | `curl -I [URL]`                                        |
|         `-d`         | Specify the data to send to the server                              | `curl -d "key1=value1&key2=value2" [URL]`              |
|   `-k or -insecure`  | Ignore SSL Certificate Errors                                       | `curl -k [URL]`                                        |
|    `-u or --user`    | Specify the authentication data by passing a pair of login-password | `curl -u [user:password] [URL]`                        |
|         `-F`         | Submit form data as POST request                                    | `curl -F @field_name=@path/to/myFile`                  |
|      `--cookie`      | Send HTTP cookies                                                   | `curl --cookie "Name=Value" [URL]`                     |
|    `-x or --proxy`   | Use a proxy server to upload files                                  | `curl -x "[protocol://][host][:port]" [URL] [options]` |
|    `--limit-rate`    | Limit the download speed                                            | `curl --limit-rate [speed] -O [URL]`                   |
|  `-L or --location`  | Follow Curl redirect using HTTP Location header                     | `curl -L [URL]`                                        |
|         `-v`         | Makes Curl verbose                                                  | `curl -v [URL]`                                        |
|  `-m or --max-time`  | Set a limit in seconds for the entire operation                     | `curl -m [SECONDS] [URL]`                              |
|  `--connect-timeout` | Set a limit in seconds for a connection request                     | `curl --connect-timeout [SECONDS] [URL]`               |
|         `-T`         | Transfers the specified local file to a remote URL                  | `curl -T [file name] [URL]`                            |
|   `-H or --header`   | Add additional HTTP request header                                  | `curl -H "X-Header: value" [URL]`                      |
|         `-D`         | Save the HTTP headers that the site sends back                      | `curl -D [URL]`                                        |
| `-A or --user-agent` | Set User-Agent string                                               | `curl -A "value" [URL]`                                |
|         `-C`         | Resume an interrupted or intentionally stopped download             | `curl -C [OFFSET] -O [URL]`                            |


### write-out

| Option                                | Description                                                                                                                                                                                                                                             |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Lookup time (`time_namelookup`)       | The time, in seconds, it took from the start until the name resolving was completed                                                                                                                                                                     |
| Connect time (`time_connect`)         | The time, in seconds, it took from the start until the TCP connect to the remote host was completed                                                                                                                                                     |
| PreXfer time (`time_pretransfer`)     | The time, in seconds, it took from the start until the file transfer was just about to begin. This includes all ‘pre-transfer’ commands and negotiations that are specific to the particular protocol(s) involved                                       |
| StartXfer time (`time_starttransfer`) | The time, in seconds, it took from the start until the first byte was just about to be transferred. This includes ‘time_pretransfer’ and also the time the server needed to calculate the result                                                        |
| AppCon time (`time_appconnect`)       | The time, in seconds, it took from the start until the SSL/SSH/etc connect/handshake to the remote host was completed (Added in 7.19.0)                                                                                                                 |
| Redirect time (`time_redirect`)       | The time, in seconds, it took for all redirection steps include name lookup, connect, pretransfer and transfer before the final transaction was started. ‘time_redirect’ shows the complete execution time for multiple redirections. (Added in 7.12.3) |
