<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get](#get)
  - [get JSON](#get-json)
  - [get XML](#get-xml)
  - [get `http_code` or `response_code`](#get-http_code-or-response_code)
  - [get `size_download`](#get-size_download)
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
- [Top 20 Curl Flags](#top-20-curl-flags)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->





{% hint style='tip' %}
> references:
> - [online rest & soap api testing tool : curl](https://reqbin.com/curl)
{% endhint %}

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

### [get `size_download`](https://superuser.com/a/1257030/112396)
```bash
$ curl -R -s -S -w "\nhttp: %{http_code}. size: %{size_download}\n" -o /dev/null https://github.com
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

## [Top 20 Curl Flags](https://reqbin.com/req/c-skhwmiil/curl-flags-example)

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
