<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [proxy for bash](#proxy-for-bash)
- [proxy for yum](#proxy-for-yum)
- [proxy for apt](#proxy-for-apt)
- [proxy for docker](#proxy-for-docker)
- [proxy for pip](#proxy-for-pip)
- [proxy for ssh](#proxy-for-ssh)
- [proxy for git](#proxy-for-git)
- [proxy for npm](#proxy-for-npm)
- [proxy for ssl](#proxy-for-ssl)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### proxy for bash
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

### proxy for yum
```bash
$ cat /etc/yum.conf
[main]
proxy=http://proxy.example.com:80
```

### proxy for apt

> [!TIP]
> [imarlso : APT Configuration](../devops/commonTools.html#apt-configuration)

```bash
$ cat /etc/apt/apt.conf
Acquire::http::Proxy "http://proxy.example.com:80";
Acquire::https::Proxy "http://proxy.example.com:80";
Acquire::ftp::Proxy "http://proxy.example.com:80";
```

### proxy for docker

> [!TIP]
> details can be found in [imarslo : docker proxy](../virtualization/docker/docker.html#docker-proxy)

#### for docker build
```json
$ cat ~/.docker/config.json
{
        "proxies": {
                "default": {
                        "httpProxy": "http://proxy.example.com:80",
                        "httpsProxy": "http://proxy.example.com:80"
                }
        }
}
```

- or via cmd directly
  ```bash
  $ docker build \
           --build-arg http_proxy=http://proxy.example.com:80 \
           --build-arg https_proxy=http://proxy.example.com:443 \
  ```

#### for docker pull
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
```

### proxy for pip

> [!TIP]
> - MS Windows: `%APPDATA%\pip\pip.ini`
> - MacOS: `$HOME/Library/Application Support/pip/pip.conf`
> - Unix: `$HOME/.config/pip/pip.conf`

#### setup [via command line](https://stackoverflow.com/a/69568878/2940319)
```bash
$ pip config set global.proxy http://proxy.example.com:80
```

#### using directly
```bash
$ pip install --proxy http://proxy.example.com:80 git-review
```

### proxy for ssh
```bash
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

- usage for git
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

### proxy for git
```bash
$ git config --global https.proxy 'http://127.0.0.1:80'   # using privoxy convert socks to http
$ git config --global http.proxy 'http://127.0.0.1:80'
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

### proxy for npm
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

### [proxy for ssl](https://curl.se/docs/sslcerts.html)

> HTTPS proxy
> Since version 7.52.0, curl can do HTTPS to the proxy separately from the connection to the server. This TLS connection is handled separately from the server connection so instead of --insecure and --cacert to control the certificate verification, you use --proxy-insecure and --proxy-cacert. With these options, you make sure that the TLS connection and the trust of the proxy can be kept totally separate from the TLS connection to the server.

