<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

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
  - [socat](#socat)
- [proxy for git](#proxy-for-git)
  - [http.proxy and https.proxy](#httpproxy-and-httpsproxy)
  - [core.gitproxy](#coregitproxy)
  - [core.sshCommand](#coresshcommand)
- [proxy for npm](#proxy-for-npm)
- [proxy for nc](#proxy-for-nc)
- [proxy for ssl](#proxy-for-ssl)
- [Q&A](#qa)
  - [nc : `nc: Proxy error: "HTTP/1.1 200 Connection established"`](#nc--nc-proxy-error-http11-200-connection-established)
- [proxy with kubeconfig](#proxy-with-kubeconfig)
- [proxy with windows](#proxy-with-windows)

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
export http_proxy=http://proxy.domain.com:80/
export https_proxy=http://proxy.domain.com:80/

# individual account settings
$ cat ~/.bashrc
export http_proxy=http://proxy.domain.com:80/
export https_proxy=http://proxy.domain.com:80/
```

## proxy for curl
```bash
$ curl -x http://proxy.domain.com:80 <https://target.server.com>
```

- to get head only
  ```bash
  $ curl -kvI -x http://proxy.domain.com:80 <https://target.server.com>
  ```

## proxy for yum
```bash
$ cat /etc/yum.conf
[main]
proxy=http://proxy.domain.com:80
```

## proxy for apt

> [!TIP|label:see also]
> - [* imarlso : apt.conf](../linux/apt-yum.html#aptconf)

```bash
$ cat /etc/apt/apt.conf
Acquire::http::Proxy "http://proxy.domain.com:80";
Acquire::https::Proxy "http://proxy.domain.com:80";
Acquire::ftp::Proxy "http://proxy.domain.com:80";
```

## proxy for docker

> [!TIP|label:see also]
> - [* imarslo : docker proxy](../virtualization/docker/tricks.html#docker-with-proxy)

### for docker build

```json
$ mkdir -p ~/.docker
$ cat > ~/.docker/config.json << EOF
{
        "proxies": {
                "default": {
                        "httpProxy": "http://proxy.domain.com:80",
                        "httpsProxy": "http://proxy.domain.com:80"
                }
        }
}
EOF
```

- or via cmd directly
  ```bash
  $ docker build \
           --build-arg http_proxy=http://proxy.domain.com:80 \
           --build-arg https_proxy=http://proxy.domain.com:443 \
  ```

### for docker pull
```bash
# for rootless mode
$ mkdir -p ~/.config/systemd/user/docker.service.d/
# or regular mode
$ sudo mkdir -p /etc/systemd/system/docker.service.d

$ sudo bash -c "cat > /etc/systemd/system/docker.service.d" << EOF
[Service]
Environment="HTTP_PROXY=http://proxy.domain.com:80"
Environment="HTTPS_PROXY=https://proxy.domain.com:443"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"
EOF

$ sudo systemctl daemon-reload
$ sudo systemctl restart docker

# verify
$ systemctl show docker --property Environment
Environment=HTTPS_PROXY=http://proxy.domain.com:443 HTTP_PROXY=http://proxy.domain.com:80 NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp
```

## proxy for pip

> [!TIP|label:paths]
> - MS Windows: `%APPDATA%\pip\pip.ini`
> - MacOS: `$HOME/Library/Application Support/pip/pip.conf`
> - Unix: `$HOME/.config/pip/pip.conf`

### setup [via command line](https://stackoverflow.com/a/69568878/2940319)
```bash
$ pip config set global.proxy http://proxy.domain.com:80
```

### using directly
```bash
$ pip install --proxy http://proxy.domain.com:80 git-review
```

## proxy for ssh
### nc
```bash
$ ssh -vT \
      -o "ProxyCommand=nc -X connect -x proxy.domain.com:80 %h %p" \
      -p 22 \
      ssh://remote.git.com
# or
$ ssh -vT \
      -o "ProxyCommand=netcat -X connect -x proxy.domain.com:80 %h %p" \
      -p 22 \
      ssh://remote.git.com

$ cat ~/.ssh/config
Host  github.com
      User                my.account@mail.com
      ServerAliveInterval 60
      Hostname            ssh.github.com
      Port                443
      ProxyCommand        nc -X connect -x proxy.domain.com:80 %h %p
```
- for socks5
  ```bash
  ProxyCommand        nc -X 5 -x proxy.domain.com:80 %h %p
  ```

### corkscrew
```bash
$ brew install corkscrew

$ ssh -vT \
      -o "ProxyCommand=corkscrew proxy.domain.com 80 %h %p" \
      -p 22 \
      ssh://remote.git.com

$ cat ~/.ssh/config
Host  github.com
      User                my.account@mail.com
      ServerAliveInterval 60
      Hostname            ssh.github.com
      Port                443
      ProxyCommand        corkscrew proxy.domain.com 80 %h %p
```

### [ncat](https://nmap.org/)
```bash
$ brew install nmap

$ ssh -vT \
      -o "ProxyCommand=ncat --proxy proxy.domain.com:80 --proxy-type http %h %p" \
      -p 22 \
      ssh://remote.git.com

$ cat ~/.ssh/config
Host  github.com
      User                my.account@mail.com
      ServerAliveInterval 60
      Hostname            ssh.github.com
      Port                443
      ProxyCommand        ncat --proxy proxy.domain.com:80 --proxy-type http %h %p
```
- for socks5
  ```bash
  ProxyCommand        ncat --proxy proxy.domain.com:80 --proxy-type socks5 %h %p
  ```

### [connect](https://github.com/gotoh/ssh-connect)

> [!NOTE]
> applicable to git for windows

```bash
$ brew install connect

$ ssh -vT \
      -o "ProxyCommand=connect -H proxy.domain.com:80 %h %p" \
      -p 22 \
      ssh://remote.git.com

$ cat ~/.ssh/config
Host  github.com
      User                my.account@mail.com
      ServerAliveInterval 60
      Hostname            ssh.github.com
      Port                443
      ProxyCommand        connect -H proxy.domain.com:80 %h %p
```

- for socks5
  ```bash
  ProxyCommand        connect -S proxy.domain.com:80 %h %p
  ```

### [socat](http://www.dest-unreach.org/socat/)

> [!NOTE]
> - [he socat Command in Linux](https://www.baeldung.com/linux/socat-command)
> - [sit/gitproxy-socat](https://gist.github.com/sit/49288)

## proxy for git

> [!NOTE|label:references]
> - [evantoli/GitConfigHttpProxy.md](https://gist.github.com/evantoli/f8c23a37eb3558ab8765)
> - [Using git with a proxy](https://elinux.org/Using_git_with_a_proxy)
> - [yougg/proxy.md](https://gist.github.com/yougg/5d2b3353fc5e197a0917aae0b3287d64)
> - [evantoli/GitConfigHttpProxy.md](https://gist.github.com/evantoli/f8c23a37eb3558ab8765)
> - [Tutorial: how to use git through a proxy](http://cms-sw.github.io/tutorial-proxy.html)
> - [cms-sw/cms-git-tools](https://github.com/cms-sw/cms-git-tools/blob/master/git-proxy)
> - no ssl verify:
>   - `set GIT_SSL_NO_VERIFY=true`
>   - `echo http{,s} | fmt -1 | xargs -i git config --global {}.sslVerify=false`
> - how to debug:
>   - [https](https://stackoverflow.com/a/128198/2940319) : `GIT_CURL_VERBOSE=1 git ...` or [`GIT_TRACE_CURL=true git ...`](https://stackoverflow.com/a/38285866/2940319)
>   - ssh : `GIT_SSH_COMMAND='ssh -v' git ...` or `git -c sshCommand='ssh -v' ...`
> - [core.gitproxy](https://gist.github.com/coin8086/7228b177221f6db913933021ac33bb92)
>   ```bash
>   A "proxy command" to execute (as command host port) instead of establishing direct connection to the
>   remote server when using the Git protocol for fetching. If the variable value is in the
>   "COMMAND for DOMAIN" format, the command is applied only on hostnames ending with the specified
>   domain string. This variable may be set multiple times and is matched in the given order; the first
>   match wins.
>
>   Can be overridden by the GIT_PROXY_COMMAND environment variable (which always applies universally,
>   without the special "for" handling).
>   ```

### http.proxy and https.proxy
```bash
$ git config --global https.proxy 'http://proxy.domain.com:80'   # using privoxy convert socks to http
$ git config --global http.proxy  'http://proxy.domain.com:80'
$ git config --global https.sslVerify false                       # unable to access '...': Unknown SSL protocol error in connection to ...:443
$ git config --global http.sslVerify false                        # unable to access '...': Unknown SSL protocol error in connection to ...:443
```

- for specific url
  ```bash
  $ git config --global http.https://github.com http://proxy.domain.com:80
  $ git config --global http.https://chromium.googlesource.com http://proxy.domain.com:80
  ```

- or
  ```bash
  $ cat ~/.gitconfig
  [http]
    proxy = http://proxy.domain.com:80
  [https]
    proxy = http://proxy.domain.com:80
  [http "https://chromium.googlesource.com"]
    proxy = http://proxy.domain.com:80
  [http "https://github.com"]
    proxy = http://proxy.domain.com:80
  ```

- [for socks5](https://github.com/521xueweihan/git-tips#git-%E9%85%8D%E7%BD%AE-http-%E5%92%8C-socks-%E4%BB%A3%E7%90%86)
  ```bash
  $ git config --global socks.proxy "proxy.domain.com:80"

  # or
  $ git config --global socks.proxy "socks5://proxy.domain.com:80"
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
  $ git config --global --get-regexp .*proxy.*
  ```

- unset
  ```bash
  $ git config --global --unset http.proxy
  $ git config --global --unset http.https://github.com

  $ git config --global --unset http.sslVerify
  $ git config --global --unset http.https://domain.com.sslVerify
  ```

### core.gitproxy
```bash
$ git config --global core.gitproxy https://proxy.domain.com:80
$ git config --global url.git://github.com/.insteadOf git@github.com:
```

### core.sshCommand

> [!NOTE]
> - [core.sshCommand](https://stackoverflow.com/a/38474137/2940319) since 26 Jun 2016 [commit 3c8ede3](https://github.com/git/git/commit/3c8ede3ff312134e84d1b23a309cd7d2a7c98e9c)
> > A new configuration variable `core.sshCommand` has been added to specify what value for `GIT_SSH_COMMAND` to use per repository.

```bash
$ git config --global core.sshCommand "ssh -v -o 'ProxyCommand=connect -H proxy.domain.com:80 %h %p'"

# or
$ git -c core.sshCommand "ssh -v -o 'ProxyCommand=commect -H proxy.domain.com:80 %h %p'" clone git@github.com/marslo/ibook.git
```

## proxy for npm

> [!NOTE|label:referencs]
> - [npm config](https://docs.npmjs.com/cli/v8/using-npm/config)
> - [Is there a way to make npm install (the command) to work behind proxy?](https://stackoverflow.com/a/10304317/2940319)
> - [How to fix SSL certificate error when running Npm on Windows?](https://stackoverflow.com/a/54538095/2940319)

```bash
$ npm config set proxy http://proxy.domain.com:80/
$ npm config set https-proxy http://proxy.domain.com:80/
$ npm config set noproxy '127.0.0.1,my.noproxy.com'

# optional
$ npm config set strict-ssl false
```

- or
  ```bash
  $ cat ~/.npmrc
  strict-ssl=false
  proxy=http://proxy.domain.com:80/
  https-proxy=http://proxy.domain.com:80/
  ```

## proxy for nc

> [!NOTE|label:manual page]
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
$ nc -zv -X connect -x proxy.domain.com:80 google.com 443
nc: Proxy error: "HTTP/1.1 200 Connection established"

# without proxy
$ nc -zv google.com 443
nc: connectx to google.com port 443 (tcp) failed: Operation timed out
```

## [proxy for ssl](https://curl.se/docs/sslcerts.html)

> [!NOTE|label:https proxy]
> Since version 7.52.0, curl can do HTTPS to the proxy separately from the connection to the server. This TLS connection is handled separately from the server connection so instead of `--insecure` and `--cacert` to control the certificate verification, you use `--proxy-insecure` and `--proxy-cacert`. With these options, you make sure that the TLS connection and the trust of the proxy can be kept totally separate from the TLS connection to the server.

## Q&A
### nc : `nc: Proxy error: "HTTP/1.1 200 Connection established"`
- issue
  ```bash
  $ nc -X connect -x 127.0.0.1:8080 -zv git.domain.com 22
  nc: Proxy error: "HTTP/1.1 200 Connection established"
  ```

- solution
  ```bash
  $ corkscrew 127.0.0.1 8080 git.domain.com 22
  SSH-2.0-GerritCodeReview_2.16.27-RP-1.10.2.4 (SSHD-CORE-2.0.0)
  ^C

  $ ncat --proxy 127.0.0.1:1087 --proxy-type http sample.gerrit.com 29418
  SSH-2.0-GerritCodeReview_2.16.27-RP-1.10.2.4 (SSHD-CORE-2.0.0)
  ^C

  $ cat ~/.ssh/config
    Host  git.domain.com
          Hostname              git.domain.com
          User                  marslo
          Port                  22
          StrictHostKeyChecking no
          UserKnownHostsFile    ~/.ssh/known_hosts
          ProxyCommand          corkscrew 127.0.0.1 8080 %h %p
          # or
          ProxyCommand          ncat --proxy 127.0.0.1:8080 --proxy-type http %h %p

  # verify in ssh
  $ ssh -vT -o "ProxyCommand=corkscrew 127.0.0.1 8080 %h %p" -p 22 git.domain.com
  ```

## proxy with kubeconfig

> [!NOTE|label:see also]
> - [* imarslo : Kubectl context and configuration](../virtualization/kubernetes/kubeconfig.html#with-proxy)

```bash
$ kubectl config set-cluster <my-cluster-name> --proxy-url=<my-proxy-url>

# i.e.
$ kubectl config set-cluster development --proxy-url=http://proxy.domain.com:8080
```

## proxy with windows

> [!NOTE]
> - [How can we configure the .pac proxy to git](https://github.com/desktop/desktop/issues/5516#issuecomment-417357195)
> - [otahi/pacproxy](https://github.com/otahi/pacproxy)

- [add/modify](https://stackoverflow.com/a/27160821/2940319)
  ```batch
  > reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1
  > reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d name:port
  > reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyUser /t REG_SZ /d username
  > reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyPass /t REG_SZ /d password
  > netsh winhttp import proxy source=ie
  ```

- [or](https://stackoverflow.com/a/57613619/2940319)
  ```batch
  > netsh winhttp set proxy proxy-server="socks=localhost:9090" bypass-list="localhost"

  REM show
  > netsh winhttp show proxy

  REM reset
  > netsh winhttp reset proxy
  ```

- [or](https://stackoverflow.com/q/61575646/2940319)
  ```batch
  > netsh winhttp set proxy 127.0.0.1:1080
  > netsh winhttp set proxy proxy-server="socks=127.0.0.1:9150" bypass-list="127.0.0.1"
  > netsh winhttp set proxy proxy-server="socks=localhost:9150" bypass-list="localhost"
  > netsh winhttp set proxy proxy-server="http=127.0.0.1:1080"  bypass-list="127.0.0.1"
  > netsh winhttp set proxy proxy-server="https=127.0.0.1:1080" bypass-list="127.0.0.1"
  ```

- check
  ```batch
  $ reg query "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" | find AutoConfigURL
      AutoConfigURL    REG_SZ    http://proxy.domain.com/file.pac

  REM full list
  $ reg query "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings"

  HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings
      CertificateRevocation    REG_DWORD    0x1
      DisableCachingOfSSLPages    REG_DWORD    0x0
      IE5_UA_Backup_Flag    REG_SZ    5.0
      PrivacyAdvanced    REG_DWORD    0x1
      SecureProtocols    REG_DWORD    0x800
      User Agent    REG_SZ    Mozilla/5.0 (compatible; MSIE 9.0; Win32)
      SecureProtocolsUpdated    REG_DWORD    0x1
      EnableNegotiate    REG_DWORD    0x1
      ProxyEnable    REG_DWORD    0x0
      MigrateProxy    REG_DWORD    0x1
      AutoConfigURL    REG_SZ    http://proxy.domain.com/file.pac
  ```
