<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [set service auto-startup](#set-service-auto-startup)
- [gnome terminal](#gnome-terminal)
- [install ubuntu theme](#install-ubuntu-theme)
- [open font viewer and install font](#open-font-viewer-and-install-font)
- [show launcher icon](#show-launcher-icon)
- [show the softer renderer](#show-the-softer-renderer)
- [specified context menu](#specified-context-menu)
- [disable ubuntu desktop notification](#disable-ubuntu-desktop-notification)
- [recode activity as a gif file](#recode-activity-as-a-gif-file)
- [goldendict installation](#goldendict-installation)
- [shadowsocks](#shadowsocks)
  - [server](#server)
  - [client](#client)
- [shadowsocks-libev](#shadowsocks-libev)
  - [service](#service)
  - [client](#client-1)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [* iMarslo: ubuntu provisioning](./installation.html#dependencies-installation)
> - [使用ssl模块配置同时支持http和https并存](http://blog.csdn.net/weixin_35884835/article/details/52588157)
> - [How To Create an SSL Certificate on Nginx for Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-nginx-for-ubuntu-14-04)
> - [How To Create a Self-Signed SSL Certificate for Nginx in Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04)
> - [Enabling Https with Nginx](https://manual.seafile.com/deploy/https_with_nginx.html)
> - [Enable SSL for HTTPS Configuration on nginx](https://linode.com/docs/security/ssl/enable-ssl-for-https-configuration-on-nginx/)
> - [Nginx+Https配置](https://segmentfault.com/a/1190000004976222)
> - [Test an insecure registry](https://docs.docker.com/registry/insecure/)
> - [Protect the Docker daemon socket](https://docs.docker.com/engine/security/https/)
> - [apt-get install tzdata noninteractive](https://stackoverflow.com/a/44333806/2940319)

## set service auto-startup
```bash
$ sudo sysv-rc-config jenkins on
$ sudo sysv-rc-conf --list | grep jenkins
jenkins      0:off      1:off   2:on    3:on    4:on    5:on    6:off
$ sudo update-rc.d jenkins enable
update-rc.d: warning:  start runlevel arguments (none) do not match jenkins Default-Start values (2 3 4 5)
update-rc.d: warning:  stop runlevel arguments (none) do not match jenkins Default-Stop values (0 1 6)
 Enabling system startup links for /etc/init.d/jenkins ...
 Removing any system startup links for /etc/init.d/jenkins ...
   /etc/rc0.d/K20jenkins
   /etc/rc1.d/K20jenkins
   /etc/rc2.d/S20jenkins
   /etc/rc3.d/S20jenkins
   /etc/rc4.d/S20jenkins
   /etc/rc5.d/S20jenkins
   /etc/rc6.d/K20jenkins
 Adding system startup for /etc/init.d/jenkins ...
   /etc/rc0.d/K20jenkins -> ../init.d/jenkins
   /etc/rc1.d/K20jenkins -> ../init.d/jenkins
   /etc/rc6.d/K20jenkins -> ../init.d/jenkins
   /etc/rc2.d/S20jenkins -> ../init.d/jenkins
   /etc/rc3.d/S20jenkins -> ../init.d/jenkins
   /etc/rc4.d/S20jenkins -> ../init.d/jenkins
   /etc/rc5.d/S20jenkins -> ../init.d/jenkins
```

## gnome terminal
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

<details><summary>click to check details ...</summary>
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

## install ubuntu theme
```bash
$ sudo add-apt-repository ppa:noobslab/themes
$ sudo apt-get update
$ sudo apt-get install nokto-theme
```

## open font viewer and install font
```bash
$ sudo gnome-font-viewer ~/Tools/Monaco/Monaco_Linux.TTF
```

## show launcher icon
```bash
$ gsettings get com.canonical.Unity.Launcher favorites
['application://nautilus.desktop', 'application://gnome-terminal.desktop', 'application://firefox.desktop', 'unity://running-apps', 'application://gvim.desktop', 'unity://desktop-icon', 'unity://expo-icon', 'unity://devices']
```

## show the softer renderer
```bash
$ /usr/lib/nux/unity_support_test -p
OpenGL vendor string:   VMware, Inc.
OpenGL renderer string: Gallium 0.4 on SVGA3D; build: RELEASE;
OpenGL version string:  2.1 Mesa 10.1.0

Not software rendered:    yes
Not blacklisted:          yes
GLX fbconfig:             yes
GLX texture from pixmap:  yes
GL npot or rect textures: yes
GL vertex program:        yes
GL fragment program:      yes
GL vertex buffer object:  yes
GL framebuffer object:    yes
GL version is 1.4+:       yes

Unity 3D supported:       yes
```

## specified context menu
```bash
$ sudo apt-get install nautilus-actions
$ nautilus -q
$ utilus-actions-config-tool
```

## disable ubuntu desktop notification
```bash
$ sudo chmod -x /usr/lib/notify-osd/notify-osd
```

## recode activity as a gif file

> [!NOTE|label:references:]
> - inspired from [here](http://askubuntu.com/a/13462/92979) and [here](http://askubuntu.com/a/107735/92979)

```bash
$ sudo add-apt-repository ppa:fossfreedom/byzanz
$ sudo apt-get update && sudo apt-get install byzanz
```

## goldendict installation
```bash
$ git clone git@github.com:goldendict/goldendict.git
$ sudo apt-get install liblzma-dev qt4-qmake hunspell-dev hunspell build-essential libvorbis-dev zlib1g-dev libhunspell-dev x11proto-record-dev libqt4-dev libqtwebkit-dev libxtst-dev liblzo2-dev libbz2-dev libao-dev libavutil-dev libavformat-dev libtiff5-dev
$ cd goldendict/
$ qmake-qt4
$ qmake "CONFIG+=no_epwing_support"
$ make && sudo make install
```

## shadowsocks
### server
```bash
$ sudo apt install m2crypto git python-pip
$ pip install --upgrade pip
$ pip install git+https://github.com/shadowsocks/shadowsocks.git@master

$ sudo ln -sf /home/marslo/.local/bin/ssserver /usr/local/bin/ssserver
```

#### start
```bash
$ sudo bash -c 'cat > /etc/rc.local' << EOF
## ssserver -c /etc/shadowsocks.json -d start
sudo /home/marslo/.local/bin/ssserver -c /etc/shadowsocks.json -d start
EOF
```

### client
#### ubuntu
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

#### others
```bash
$ sudo apt install python-pip
$ sudo pip install genpac
```

## shadowsocks-libev
### service
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
    $ sudo netstatus -tunpla | grep 1111
    ```

![ss-libev-service](../../screenshot/ss/ss-libev-port.png)

### client

| plugin        | plugin opts                          |
| :-:           | :-:                                  |
| `simple-obfs` | `obfs=http;obfs-host=www.google.com` |

![ss-libev-client](../../screenshot/ss/ss-libev-client.png)
