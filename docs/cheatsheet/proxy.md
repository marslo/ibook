<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [proxy for bash](#proxy-for-bash)
- [proxy for curl](#proxy-for-curl)
- [proxy for yum](#proxy-for-yum)
- [proxy for apt](#proxy-for-apt)
- [proxy for docker](#proxy-for-docker)
  - [for docker build](#for-docker-build)
  - [for docker pull](#for-docker-pull)
- [proxy for pip](#proxy-for-pip)
  - [setup via command line](#setup-via-command-line)
  - [using directly](#using-directly)
- [proxy for ssh](#proxy-for-ssh)
  - [nc](#nc)
  - [corkscrew](#corkscrew)
  - [ncat](#ncat)
  - [connect](#connect)
- [proxy for git](#proxy-for-git)
- [proxy for npm](#proxy-for-npm)
- [proxy for nc](#proxy-for-nc)
- [proxy for ssl](#proxy-for-ssl)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [How to Use Netcat Commands: Examples and Cheat Sheets](https://www.varonis.com/blog/netcat-commands)
> - [SSH Tunneling and Proxying](https://www.baeldung.com/linux/ssh-tunneling-and-proxying)
> - [bryanpkc/corkscrew](https://github.com/bryanpkc/corkscrew)
> - [nc / netcat](https://ss64.com/osx/nc.html)
> - [gotoh/ssh-connect](https://github.com/gotoh/ssh-connect)
> - [larryhou/connect-proxy](https://github.com/larryhou/connect-proxy)
{% endhint %}

## proxy for bash
```bash
# global settings
$ cat /etc/bashrc
export http_proxy=http://proxy.example.com:80/
export https_proxy=http://proxy.example.com:80/

# individual account settings
$ cat ~/.bashrc
export http_proxy=http://proxy.example.com:80/
export https_proxy=http://proxy.example.com:80/
```

## proxy for curl
```bash
$ curl -x http://proxy.example.com:80 <https://target.server.com>
```

- to get head only
  ```bash
  $ curl -kvI -x http://proxy.example.com:80 <https://target.server.com>
  ```

## proxy for yum
```bash
$ cat /etc/yum.conf
[main]
proxy=http://proxy.example.com:80
```

## proxy for apt

> [!TIP]
> [imarlso : APT Configuration](../devops/commonTools.html#apt-configuration)

```bash
$ cat /etc/apt/apt.conf
Acquire::http::Proxy "http://proxy.example.com:80";
Acquire::https::Proxy "http://proxy.example.com:80";
Acquire::ftp::Proxy "http://proxy.example.com:80";
```

## proxy for docker

> [!TIP]
> [imarslo : docker proxy](../virtualization/docker/tricks.html#docker-with-proxy)

### for docker build

```json
$ mkdir -p ~/.docker
$ cat > ~/.docker/config.json << EOF
{
        "proxies": {
                "default": {
                        "httpProxy": "http://proxy.example.com:80",
                        "httpsProxy": "http://proxy.example.com:80"
                }
        }
}
EOF
```

- or via cmd directly
  ```bash
  $ docker build \
           --build-arg http_proxy=http://proxy.example.com:80 \
           --build-arg https_proxy=http://proxy.example.com:443 \
  ```

### for docker pull
```bash
# for rootless mode
$ mkdir -p ~/.config/systemd/user/docker.service.d/
# or regular mode
$ sudo mkdir -p /etc/systemd/system/docker.service.d

$ sudo bash -c "cat > /etc/systemd/system/docker.service.d" << EOF
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80"
Environment="HTTPS_PROXY=https://proxy.example.com:443"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"
EOF

$ sudo systemctl daemon-reload
$ sudo systemctl restart docker

# verify
$ systemctl show docker --property Environment
Environment=HTTPS_PROXY=http://proxy.example.com:443 HTTP_PROXY=http://proxy.example.com:80 NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp
```

## proxy for pip

> [!TIP]
> - MS Windows: `%APPDATA%\pip\pip.ini`
> - MacOS: `$HOME/Library/Application Support/pip/pip.conf`
> - Unix: `$HOME/.config/pip/pip.conf`

### setup [via command line](https://stackoverflow.com/a/69568878/2940319)
```bash
$ pip config set global.proxy http://proxy.example.com:80
```

### using directly
```bash
$ pip install --proxy http://proxy.example.com:80 git-review
```

## proxy for ssh
### nc
```bash
$ ssh -vT \
      -o "ProxyCommand=nc -X connect -x proxy.example.com:80 %h %p" \
      -p 22 \
      ssh://remote.git.com
# or
$ ssh -vT \
      -o "ProxyCommand=netcat -X connect -x proxy.example.com:80 %h %p" \
      -p 22 \
      ssh://remote.git.com

$ cat ~/.ssh/config
Host  github.com
      User                my.account@mail.com
      ServerAliveInterval 60
      Hostname            ssh.github.com
      Port                443
      ProxyCommand        nc -X connect -x proxy.example.com:80 %h %p
```
- for socks5
  ```bash
  ProxyCommand        nc -X 5 -x proxy.example.com:80 %h %p
  ```

### corkscrew
```bash
$ brew install corkscrew

$ ssh -vT \
      -o "ProxyCommand=corkscrew proxy.example.com 80 %h %p" \
      -p 22 \
      ssh://remote.git.com

$ cat ~/.ssh/config
Host  github.com
      User                my.account@mail.com
      ServerAliveInterval 60
      Hostname            ssh.github.com
      Port                443
      ProxyCommand        corkscrew proxy.example.com 80 %h %p
```

### [ncat](https://nmap.org/)
```bash
$ brew install nmap

$ ssh -vT \
      -o "ProxyCommand=ncat --proxy proxy.example.com:80 --proxy-type http %h %p" \
      -p 22 \
      ssh://remote.git.com

$ cat ~/.ssh/config
Host  github.com
      User                my.account@mail.com
      ServerAliveInterval 60
      Hostname            ssh.github.com
      Port                443
      ProxyCommand        ncat --proxy proxy.example.com:80 --proxy-type http %h %p
```
- for socks5
  ```bash
  ProxyCommand        ncat --proxy proxy.example.com:80 --proxy-type socks5 %h %p
  ```

### [connect](https://github.com/gotoh/ssh-connect)

> [!NOTE]
> applicable to git for windows

```bash
$ brew install connect

$ ssh -vT \
      -o "ProxyCommand=connect -H proxy.example.com:80 %h %p" \
      -p 22 \
      ssh://remote.git.com

$ cat ~/.ssh/config
Host  github.com
      User                my.account@mail.com
      ServerAliveInterval 60
      Hostname            ssh.github.com
      Port                443
      ProxyCommand        connect -H proxy.example.com:80 %h %p
```

- for socks5
  ```bash
  ProxyCommand        connect -S proxy.example.com:80 %h %p
  ```

## proxy for git

> [!TIP]
> references:
> - [evantoli/GitConfigHttpProxy.md](https://gist.github.com/evantoli/f8c23a37eb3558ab8765)

```bash
$ git config --global https.proxy 'http://127.0.0.1:80'   # using privoxy convert socks to http
$ git config --global http.proxy 'http://127.0.0.1:80'
$ git config --global http.sslVerify false                # unable to access '...': Unknown SSL protocol error in connection to ...:443
```

- for specific url
  ```bash
  $ git config --global http.https://github.com http://proxy.example.com:80
  $ git config --global http.https://chromium.googlesource.com http://proxy.example.com:80
  ```

- or
  ```bash
  $ cat ~/.gitconfig
  [http]
    proxy = http://proxy.example.com:80
  [https]
    proxy = http://proxy.example.com:80
  [http "https://chromium.googlesource.com"]
    proxy = http://proxy.example.com:80
  [http "https://github.com"]
    proxy = http://proxy.example.com:80
  ```

- [for socks5](https://github.com/521xueweihan/git-tips#git-%E9%85%8D%E7%BD%AE-http-%E5%92%8C-socks-%E4%BB%A3%E7%90%86)
  ```bash
  $ git config --global socks.proxy "proxy.example.com:80"

  # or
  $ git config --global socks.proxy "socks5://proxy.example.com:80"
  ```

- additional usage
  ```bash
  $ cat ~/.gitconfig
  ...
  [url "git@ssh.github.com"]
    insteadOf    = git@github.com
  [url "git@ssh.github.com:"]
    insteadOf    = https://github.com/
  [http]
    sslVerify    = false
    postBuffer   = 524288000
    # sslVersion = tlsv1.1
    # sslVersion = tlsv1.2
    # sslVersion = tlsv1.3
  ...
  ```

- show current configure
  ```bash
  $ git config --global --get-regexp http.*
  ```

- unset
  ```bash
  $ git config --global --unset http.proxy
  $ git config --global --unset http.https://github.com

  $ git config --global --unset http.sslVerify
  $ git config --global --unset http.https://domain.com.sslVerify
  ```

## proxy for npm

> [!NOTE]
> references:
> - [npm config](https://docs.npmjs.com/cli/v8/using-npm/config)
> - [Is there a way to make npm install (the command) to work behind proxy?](https://stackoverflow.com/a/10304317/2940319)
> - [How to fix SSL certificate error when running Npm on Windows?](https://stackoverflow.com/a/54538095/2940319)

```bash
$ npm config set proxy http://proxy.example.com:80/
$ npm config set https-proxy http://proxy.example.com:80/
$ npm config set noproxy '127.0.0.1,my.noproxy.com'

# optional
$ npm config set strict-ssl false
```

- or
  ```bash
  $ cat ~/.npmrc
  strict-ssl=false
  proxy=http://proxy.example.com:80/
  https-proxy=http://proxy.example.com:80/
  ```

## proxy for nc

> [!NOTE]
> ```bash
> -X proxy_version
>         Requests that nc should use the specified protocol when talking to the proxy server.
>         Supported protocols are:
>         - “4” (SOCKS v.4)
>         - “5” (SOCKS v.5)
>         - “connect” (HTTPS proxy)
>         If the protocol is not specified, SOCKS version 5 is used.
> ```
> - additional
>   ```bash
>   -T protocols=all
>   ```

```bash
# with proxy
$ nc -zv -X connect -x proxy.example.com:80 google.com 443
nc: Proxy error: "HTTP/1.1 200 Connection established"

# without proxy
$ nc -zv google.com 443
nc: connectx to google.com port 443 (tcp) failed: Operation timed out
```

## [proxy for ssl](https://curl.se/docs/sslcerts.html)

> [!NOTE]
> HTTPS proxy
> Since version 7.52.0, curl can do HTTPS to the proxy separately from the connection to the server. This TLS connection is handled separately from the server connection so instead of `--insecure` and `--cacert` to control the certificate verification, you use `--proxy-insecure` and `--proxy-cacert`. With these options, you make sure that the TLS connection and the trust of the proxy can be kept totally separate from the TLS connection to the server.
