<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [pre-config](#pre-config)
  - [dependencies installation](#dependencies-installation)
  - [account](#account)
  - [MOTD](#motd)
  - [ip address](#ip-address)
- [proxy servers](#proxy-servers)
  - [shadowsocks](#shadowsocks)
  - [shadowsocks-libev](#shadowsocks-libev)
- [squid](#squid)
- [applications](#applications)
  - [terminal configurations](#terminal-configurations)
  - [vncserver](#vncserver)
- [artifactory](#artifactory)
  - [add insecure-regiestry](#add-insecure-regiestry)
  - [docker login & logout](#docker-login--logout)
  - [docker pull](#docker-pull)
  - [docker push](#docker-push)
- [X Windows](#x-windows)
  - [get screen solution](#get-screen-solution)
  - [desktop sharing](#desktop-sharing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [使用ssl模块配置同时支持http和https并存](http://blog.csdn.net/weixin_35884835/article/details/52588157)
> - [How To Create an SSL Certificate on Nginx for Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-nginx-for-ubuntu-14-04)
> - [How To Create a Self-Signed SSL Certificate for Nginx in Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04)
> - [Enabling Https with Nginx](https://manual.seafile.com/deploy/https_with_nginx.html)
> - [Enable SSL for HTTPS Configuration on nginx](https://linode.com/docs/security/ssl/enable-ssl-for-https-configuration-on-nginx/)
> - [Nginx+Https配置](https://segmentfault.com/a/1190000004976222)
> - [Test an insecure registry](https://docs.docker.com/registry/insecure/)
> - [Protect the Docker daemon socket](https://docs.docker.com/engine/security/https/)

> [!TIP|label:download deb only]
> - [Is there an apt command to download a deb file from the repositories to the current directory?](https://askubuntu.com/a/30581/92979)
>   ```bash
>   # get package name
>   $ sudo apt list --installed | grep <keywords>
>   $ apt-get install --reinstall --print-uris -qq <package-name> | cut -d"'" -f2
>   ```

## pre-config
### dependencies installation
```bash
$ sudo apt install -y apt-file \
                      autoconf \
                      automake \
                      bash-completion* \
                      binutils \
                      binutils-doc \
                      bison \
                      build-essential \
                      cmake \
                      cpp \
                      cpp-5 \
                      cpp-doc \
                      curl \
                      debian-keyring \
                      dlocate \
                      dos2unix \
                      dpkg-dev \
                      dstat \
                      fakeroot \
                      flex \
                      g++ \
                      g++-5 \
                      g++-5-multilib \
                      g++-multilib \
                      gcc \
                      gcc-5 \
                      gcc-5-doc \
                      gcc-5-locales \
                      gcc-5-multilib \
                      gcc-doc \
                      gcc-multilib \
                      gdb \
                      git \
                      htop \
                      ifstat \
                      iftop \
                      iptables-persistent \
                      jq \
                      landscape-common \
                      libasan2 \
                      libasan2-dbg \
                      libatomic1 \
                      libatomic1-dbg \
                      libbz2-dev \
                      libc-dev-bin \
                      libc6-dev \
                      libcc1-0 \
                      libcilkrts5 \
                      libcilkrts5-dbg \
                      libexpat-dev \
                      libexpat1-dev \
                      libfakeroot \
                      libgcc1-dbg \
                      libgomp1-dbg \
                      libisl15 \
                      libitm1 \
                      libitm1-dbg \
                      liblsan0 \
                      liblsan0-dbg \
                      liblxc1 \
                      libmpc3 \
                      libmpx0 \
                      libmpx0-dbg \
                      libncurses-dev \
                      libncurses5-dev \
                      libncursesw5-dev \
                      libpython-all-dev \
                      libpython2.7 \
                      libquadmath0 \
                      libquadmath0-dbg \
                      libsensors4 \
                      libssl-dev \
                      libstdc++-5-dev \
                      libstdc++-5-doc \
                      libstdc++6-5-dbg \
                      libtool \
                      libtsan0 \
                      libtsan0-dbg \
                      libubsan0 \
                      libubsan0-dbg \
                      linux-libc-dev \
                      lxc-common \
                      lxcfs \
                      m4 \
                      mailutils \
                      make \
                      manpages-dev \
                      ncurses-doc \
                      net-tools \
                      netfilter-persistent \
                      policycoreutils \
                      python-docutils \
                      python-pip \
                      python-setuptools-doc \
                      ruby \
                      sysstat \
                      texinfo \
                      traceroute \
                      tree \
                      update-motd \
                      update-notifier-common \
                      zlib1g-dev
```

#### tzdata installation with noninteractive

> [!NOTE|label:references:]
> - [apt-get install tzdata noninteractive](https://stackoverflow.com/a/44333806/2940319)

```bash
# in bash
$ DEBIAN_FRONTEND=noninteractive sudo apt-get install -y tzdata

# or
$ export DEBIAN_FRONTEND=noninteractive
$ sudo apt install -y tzdata

# or
$ echo 'tzdata tzdata/Areas select Europe'       | debconf-set-selections
$ echo 'tzdata tzdata/Zones/Europe select Paris' | debconf-set-selections
$ DEBIAN_FRONTEND="noninteractive" sudo apt install -y tzdata

# or
$ sudo ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
$ export DEBIAN_FRONTEND=noninteractive
$ sudo apt-get install -y tzdata
$ sudo dpkg-reconfigure --frontend noninteractive tzdata
```

- or

  > [!NOTE|label:references:]
  > - [Cingulata/Dockerfile.bfv](https://github.com/CEA-LIST/Cingulata/blob/157b4c66441e4e253e06a0abe1508976605100d8/Dockerfile.bfv#L12)

  ```
  $ sudo ln -snf /usr/share/zoneinfo/$(curl https://ipapi.co/timezone) /etc/localtime
  $ sudo apt install -y tzdata
  ```

- or in dockerfile
  ```dockerfile
  RUN apt-get update \
      && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
  ```

- or ENV in dockerfile

  > [!NOTE|label:references:]
  > - [setting it via ENV should be actively discouraged](https://github.com/moby/moby/issues/4032#issuecomment-34597177)

  ```dockerfile
  ENV DEBIAN_FRONTEND noninteractive
  RUN apt-get update \
      && apt-get install -y --no-install-recommends tzdata
  ```

- or `ARG` in dockerfile

  > [!NOTE|label:references:]
  > - [apt-get install tzdata noninteractive](https://stackoverflow.com/a/66327069/2940319)

  ```dockerfile
  from ubuntu:bionic
  ARG DEBIAN_FRONTEND=noninteractive
  RUN apt-get update && apt-get install -y tzdata
  RUN unlink /etc/localtime
  RUN ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
  ```

### account
```bash
$ sudo usermod -a -G sudo,adm,root,docker devops
```

### MOTD
```bash
$ sudo chmod -x /etc/update-motd.d/00-header \
                /etc/update-motd.d/10-help-text \
                /etc/update-motd.d/50-motd-news

$ cat << 'EOF' > /etc/landscape/client.conf
[sysinfo]
exclude_sysinfo_plugins = Temperature, LandscapeLink
EOF
```

### ip address
- get subnet ip address
  ```bash
  $ ip addr show eno1 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
  192.168.1.105
  fe80::e5ca:1027:b572:9998
  ```

- get public IP address
  ```bash
  $ curl -4 icanhazip.com
  182.150.46.248
  ```

## proxy servers
### shadowsocks
#### server
```bash
# ubuntu
$ sudo apt install m2crypto git python-pip
# centos
$ sudo yum install m2crypto git python3-pip

$ pip install --upgrade pip
# or
$ pip3 install --upgrade pip
# or
$ sudo /usr/bin/python3 -m pip install --upgrade pip

$ pip install git+https://github.com/shadowsocks/shadowsocks.git@master

$ sudo ln -sf /home/marslo/.local/bin/ssserver /usr/local/bin/ssserver
```

##### start
```bash
$ sudo bash -c 'cat > /etc/rc.local' << EOF
## ssserver -c /etc/shadowsocks.json -d start
sudo /home/marslo/.local/bin/ssserver -c /etc/shadowsocks.json -d start
EOF
```

#### client
##### ubuntu
```bash
$ sudo add-apt-repository ppa:hzwhuang/ss-qt5
 Shadowsocks-Qt5 is a cross-platform Shadowsocks GUI client.

Shadowsocks is a lightweight tool that helps you bypass firewall(s).

This PPA mainly includes packages for Shadowsocks-Qt5, which means it also includes libQtShadowsocks packages.
 More info: https://launchpad.net/~hzwhuang/+archive/ubuntu/ss-qt5
Press [ENTER] to continue or Ctrl-c to cancel adding it.

gpg: keybox '/tmp/tmpaegs6_x4/pubring.gpg' created
gpg: /tmp/tmpaegs6_x4/trustdb.gpg: trustdb created
gpg: key 6DA746A05F00FA99: public key "Launchpad PPA for Symeon Huang" imported
gpg: Total number processed: 1
gpg:               imported: 1
OK

$ sudo apt update
$ sudo apt install shadowsocks-qt5
```

##### others
```bash
$ sudo apt install python-pip
$ sudo pip install genpac
```

### shadowsocks-libev
#### service
- started by docker image `teddysun/shadowsocks-libev`
    ```bash
    $ mkdir -p /etc/shadowsocks-libev
    $ sudo bash -c "cat > /etc/shadowsocks-libev/config.json" << EOF
    {
        "server":"0.0.0.0",
        "server_port":1111,
        "password":"password0",
        "timeout":300,
        "user":"nobody",                // optional
        "method":"aes-256-gcm",
        "fast_open":false,
        "nameserver":"8.8.8.8",         // be careful for this in private sub-network
        "mode":"tcp_and_udp",
        "plugin":"obfs-server",
        "plugin_opts":"obfs=http"
    }
    EOF

    $ docker run -d -p 1111:1111 \
                    -p 1111:1111/udp \
                    --name ss-libev \
                    --restart=always \
                    -v /etc/shadowsocks-libev:/etc/shadowsocks-libev \
                    teddysun/shadowsocks-libev
    $ docker logs -f ss-libev
    ```

- started by `/etc/init.d/shadowsocks-libev`
    ```bash
    $ wget --no-check-certificate \
           -O shadowsocks-all.sh \
           https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
    $ chmod +x shadowsocks-all.sh
    $ ./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log
    ...

    Which Shadowsocks server you'd select:
    1) Shadowsocks-Python
    2) ShadowsocksR
    3) Shadowsocks-Go
    4) Shadowsocks-libev
    Please enter a number (Default Shadowsocks-Python): 4
    You choose = Shadowsocks-libev
    ...

    [Info] Starting install package autoconf
    Do you want install simple-obfs for Shadowsocks-libev? [y/n]
    (default: n): y
    You choose = y

    Please select obfs for simple-obfs:
    1) http
    2) tls
    Which obfs you'd select(Default: http): 1
    obfs = http
    ...
    ```
    - service
      ```bash
      $ sudo /etc/init.d/shadowsocks-libev start
      $ sudo /etc/init.d/shadowsocks-libev stop
      $ sudo /etc/init.d/shadowsocks-libev restart
      $ sudo /etc/init.d/shadowsocks-libev status
      Shadowsocks-libev (pid 903) is running...
      ```
    - config
      ```bash
      $ /etc/shadowsocks-libev/config.json
      {
          "server":"0.0.0.0",
          "server_port": 1111,
          "password":"mypassword",
          "timeout":300,
          "user":"nobody",                  // optinal
          "method":"aes-256-cfb",
          "fast_open":false,
          "nameserver":"1.0.0.1",           // be careful for dns resolve in private network
          "mode":"tcp_and_udp",
          "plugin":"obfs-server",
          "plugin_opts":"obfs=http"
      }
      ```

- check status
  ```bash
  $ sudo lsof -i:1111
  COMMAND   PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
  ss-server 903 nobody    8u  IPv4  20522      0t0  UDP *:1111
  obfs-serv 909   root    7u  IPv4  20649      0t0  TCP *:1111 (LISTEN)
  $ sudo netstatus -tunpla | grep 1111
  tcp        0      0 0.0.0.0:1111            0.0.0.0:*               LISTEN      909/obfs-server
  udp        0      0 0.0.0.0:1111            0.0.0.0:*                           903/ss-server
  ```

![ss-libev-service](../../screenshot/ss/ss-libev-port.png)

#### client

| plugin        | plugin opts                          |
| :-----------: | :----------------------------------: |
| `simple-obfs` | `obfs=http;obfs-host=www.google.com` |

![ss-libev-client](../../screenshot/ss/ss-libev-client.png)


## [squid](http://www.squid-cache.org/Doc/)

> [!NOTE|label:references:]
> - [About Squid proxy servers](https://ubuntu.com/server/docs/proxy-servers-squid)
> - [Squid installation and configuration in Ubuntu](https://help.ubuntu.com/community/Squid)
> - [SquidGuard in ubuntu](https://help.ubuntu.com/community/SquidGuard)
> - [How to configure an SSH proxy server with Squid](https://fedoramagazine.org/configure-ssh-proxy-server/)
> - [Use Squid as HTTP / HTTPS / SSH Proxy](https://www.squins.com/knowledge/squid-http-https-ssh-proxy/)
> - [Tunnelling SSH/SFTP over Squid proxy](https://www.seniorlinuxadmin.co.uk/ssh-over-proxy.html)
> - [How to Set Up a Proxy Server on Your Mac Using SquidMan](https://howchoo.com/mac/how-to-set-up-a-proxy-server-on-mac)
> - [brew install squid on macOS but can't run squid](https://serverfault.com/a/1069392/129815)

## applications
### terminal configurations
- backup
  ```bash
  $ dconf dump /org/gnome/terminal/ > ubuntu1710_terminal_backup.bak
  ```

- restore
  ```bash
  $ dconf load /org/gnome/terminal/ < ubuntu1710_terminal_backup.bak
  ```

- reset
  ```bash
  $ dconf reset -f /org/gnome/terminal
  ```

- list
  ```bash
  $ gsettings list-recursively | grep -i org.gnome.Terminal
  ```

<details><summary>Click to check details</summary>
<pre><code>$ gsettings list-recursively | grep -i org.gnome.Terminal
org.gnome.Terminal.ProfilesList list ['b1dcc9dd-5262-4d8d-a863-c897e6d979b9']
org.gnome.Terminal.ProfilesList default 'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'
org.gnome.shell favorite-apps ['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']
org.gnome.Terminal.Legacy.Settings new-terminal-mode 'window'
org.gnome.Terminal.Legacy.Settings menu-accelerator-enabled true
org.gnome.Terminal.Legacy.Settings tab-position 'top'
org.gnome.Terminal.Legacy.Settings confirm-close true
org.gnome.Terminal.Legacy.Settings shell-integration-enabled true
org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
org.gnome.Terminal.Legacy.Settings default-show-menubar true
org.gnome.Terminal.Legacy.Settings mnemonics-enabled false
org.gnome.Terminal.Legacy.Settings schema-version uint32 3
org.gnome.Terminal.Legacy.Settings encodings ['UTF-8']
org.gnome.Terminal.Legacy.Settings shortcuts-enabled true
org.gnome.Terminal.Legacy.Settings tab-policy 'automatic'
org.gnome.Terminal.Legacy.Keybindings toggle-menubar 'disabled'
org.gnome.Terminal.Legacy.Keybindings reset-and-clear 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-14 'disabled'
org.gnome.Terminal.Legacy.Keybindings zoom-normal '<Ctrl>0'
org.gnome.Terminal.Legacy.Keybindings read-only 'disabled'
org.gnome.Terminal.Legacy.Keybindings new-profile 'disabled'
org.gnome.Terminal.Legacy.Keybindings zoom-out '<Ctrl>minus'
org.gnome.Terminal.Legacy.Keybindings move-tab-left '<Ctrl><Shift>Page_Up'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-20 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-21 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-22 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-23 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-24 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-25 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-26 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-27 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-28 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-29 'disabled'
org.gnome.Terminal.Legacy.Keybindings zoom-in '<Ctrl>plus'
org.gnome.Terminal.Legacy.Keybindings detach-tab 'disabled'
org.gnome.Terminal.Legacy.Keybindings move-tab-right '<Ctrl><Shift>Page_Down'
org.gnome.Terminal.Legacy.Keybindings close-tab '<Ctrl><Shift>w'
org.gnome.Terminal.Legacy.Keybindings paste '<Ctrl><Shift>v'
org.gnome.Terminal.Legacy.Keybindings reset 'disabled'
org.gnome.Terminal.Legacy.Keybindings new-tab '<Ctrl><Shift>t'
org.gnome.Terminal.Legacy.Keybindings find-previous '<Control><Shift>H'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-30 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-31 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-32 'disabled'
org.gnome.Terminal.Legacy.Keybindings select-all 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-34 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-35 'disabled'
org.gnome.Terminal.Legacy.Keybindings preferences 'disabled'
org.gnome.Terminal.Legacy.Keybindings prev-tab '<Control>Page_Up'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-33 'disabled'
org.gnome.Terminal.Legacy.Keybindings find-next '<Control><Shift>G'
org.gnome.Terminal.Legacy.Keybindings find '<Control><Shift>F'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-1 '<Alt>1'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-2 '<Alt>2'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-3 '<Alt>3'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-4 '<Alt>4'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-5 '<Alt>5'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-6 '<Alt>6'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-7 '<Alt>7'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-8 '<Alt>8'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-9 '<Alt>9'
org.gnome.Terminal.Legacy.Keybindings help 'F1'
org.gnome.Terminal.Legacy.Keybindings copy '<Ctrl><Shift>c'
org.gnome.Terminal.Legacy.Keybindings close-window '<Ctrl><Shift>q'
org.gnome.Terminal.Legacy.Keybindings new-window '<Ctrl><Shift>n'
org.gnome.Terminal.Legacy.Keybindings save-contents 'disabled'
org.gnome.Terminal.Legacy.Keybindings find-clear '<Control><Shift>J'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-10 '<Alt>0'
org.gnome.Terminal.Legacy.Keybindings full-screen 'F11'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-12 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-13 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-11 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-15 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-16 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-17 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-18 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-19 'disabled'
org.gnome.Terminal.Legacy.Keybindings profile-preferences 'disabled'
org.gnome.Terminal.Legacy.Keybindings next-tab '<Control>Page_Down'
</code></pre>
</details>

### vncserver
#### install
```bash
$ sudo apt install vnc4server
$ sudo apt install gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal
```

## artifactory
### add insecure-regiestry
```bash
$ cat ~/.docker/daemon.json
{
  "debug" : true,
  "experimental" : true,
  "insecure-registries" : ["www.artifactory.mycompany.com", "www.artifactory.mycompany.com:2500", "www.artifactory.mycompany.com:2501", "docker-1.artifactory", "docker-1.artifactory:443"]
}

$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```

### docker login & logout
```bash
$ docker --debug -l debug login --username admin  https://docker-1.artifactory
Password:
Login Succeeded

$ docker --debug -l debug logout docker-1.artifactory
Removing login credentials for docker-1.artifactory
```

### docker pull
```bash
$ docker pull docker-1.artifactory/nginx:latest
latest: Pulling from nginx
e7bb522d92ff: Pull complete
0f4d7753723e: Pulling fs layer
91470a14d63f: Download complete
0f4d7753723e: Pull complete
91470a14d63f: Pull complete
Digest: sha256:3eff18554e47c4177a09cea5d460526cbb4d3aff9fd1917d7b1372da1539694a
Status: Downloaded newer image for docker-1.artifactory/nginx:latest
```

### docker push
```bash
$ docker pull hello-world
$ docker tag hello-world docker-1.artifactory/bello-marslo:2.0
$ docker login --username admin docker-1.artifactory
$ docker push docker-1.artifactory/bello-marslo:2.0
```

## X Windows
### get screen solution
```bash
$ xrandr --verbose
Screen 0: minimum 320 x 200, current 1920 x 1080, maximum 8192 x 8192
XWAYLAND0 connected 1920x1080+0+0 (0x22) normal (normal left inverted right x axis y axis) 480mm x 270mm
    Identifier: 0x21
    Timestamp:  3807
    Subpixel:   unknown
    Gamma:      1.0:1.0:1.0
    Brightness: 0.0
    Clones:
    CRTC:       0
    CRTCs:      0
    Transform:  1.000000 0.000000 0.000000
                0.000000 1.000000 0.000000
                0.000000 0.000000 1.000000
               filter:
  1920x1080 (0x22) 173.000MHz -HSync +VSync *current +preferred
        h: width  1920 start 2048 end 2248 total 2576 skew    0 clock  67.16KHz
        v: height 1080 start 1083 end 1088 total 1120           clock  59.96Hz
```

### desktop sharing
#### enable remote access
```bash
##!/bin/bash
export DISPLAY=:0
read -e -p "VNC Password: " -i "ubuntu" password
dconf write /org/gnome/desktop/remote-access/enabled true
dconf write /org/gnome/desktop/remote-access/prompt-enabled false
dconf write /org/gnome/desktop/remote-access/authentication-methods "['vnc']"
dconf write /org/gnome/desktop/remote-access/require-encryption false08/03/2018
dconf write /org/gnome/desktop/remote-access/vnc-password \"\'$(echo -n $password | base64)\'\"
dconf dump /org/gnome/desktop/remote-access/
## sudo service lightdm restart
```

- or
  ```bash
  $ vino-preference
  $ dconf-editor
  ```

#### start x server
```bash
$ export DISPLAY=:0
$ /usr/lib/vino/vino-server --display=:0 &
```

#### [reset vnc password](https://access.redhat.com/solutions/346033)
```bash
$ echo -n 'awesome' | base64
$ gconftool-2 -s -t string /desktop/gnome/remote_access/vnc_password $(echo -n "<YOURPASSWORD>" | base64)
$ gconftool-2 --type string --set /desktop/gnome/remote_acess/vnc_password '123456'
```

#### [wayland known error](https://askubuntu.com/a/967538)
```bash
cat <<EOF | sudo tee /etc/xdg/autostart/xhost.desktop
[Desktop Entry]
Name=xhost
Comment=Fix graphical root applications
Exec="xhost +si:localuser:root"
Terminal=false
Type=Application
EOF
```

#### check using wayland or xorg
```bash
$ echo $XDG_SESSION_TYPE
```

- Ubuntu: Wayland (Wayland)
- Ubuntu on Xorg: Xorg (X11)
