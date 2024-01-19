<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [ubuntu 17.10 bootup settings](#ubuntu-1710-bootup-settings)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [How to automatically execute shell script at startup boot on systemd Linux](https://linuxconfig.org/how-to-automatically-execute-shell-script-at-startup-boot-on-systemd-linux)
> - [Using systemd to control the Docker daemon](https://success.docker.com/article/Using_systemd_to_control_the_Docker_daemon)
> - [systemd_service.5.manual](http://manpages.ubuntu.com/manpages/zesty/man5/systemd.service.5.html)
> - [Linux route命令详解：查看和操作IP路由表](http://network.51cto.com/art/201503/469761.htm)
> - [ubuntu配置静态路由及重启生效](http://www.mamicode.com/info-detail-1704736.html)
> - [Systemd的Unit文件; systemctl增加服务详细介绍](http://blog.csdn.net/shuaixingi/article/details/49641721)
> - [SystemdForUpstartUsers](https://wiki.ubuntu.com/SystemdForUpstartUsers)
> - [How to disable IPv6 address on Ubuntu 22.04 LTS Jammy Jellyfish](https://linuxconfig.org/how-to-disable-ipv6-address-on-ubuntu-22-04-lts-jammy-jellyfish)

## needrestart

> [!NOTE]
> - [liske/needrestart](https://github.com/liske/needrestart)
> - [How to Install Needrestart on Fedora 39, 38 Linux](https://www.linuxcapable.com/how-to-install-needrestart-on-fedora-linux/)
> - [Debian: unattended-upgrades + needrestart](https://blog.cyberfront.org/index.php/2021/10/27/debian-unattended-upgrades-need2restart/)

```bash
$ needrestart -r i -k
Scanning linux images...

Pending kernel upgrade!

Running kernel version:
  6.5.0-14-generic

  Diagnostics:
    The currently running kernel has an ABI compatible upgrade pending.

    Restarting the system to load the new kernel will not be handled automatically, so you should consider
    rebooting. [Return]
```

## dpkg
```bash
$ sudo dpkg --list

# reconfiguring the dpkg package
$ sudo dpkg --configure -a
```

## service

> [!NOTE|label:references:]
> - [how we can see all running services Linux machine?](https://stackoverflow.com/a/66315070/2940319)
> - [GDM](https://wiki.archlinux.org/title/GDM)
> - [GNOME Display Manager](https://wiki.gnome.org/Projects/GDM)
>   - [Display managers](https://wiki.archlinux.org/title/Display_manager) provide [X Window System](https://wiki.archlinux.org/title/X_Window_System) and [Wayland](https://wiki.archlinux.org/title/Wayland) users with a graphical login prompt.

### list all
```bash
$ sudo service --status-all
$ sudo service --status-all | grep '\[ + \]'
$ sudo service --status-all | grep '\[ - \]'

# list all running services on Ubuntu
$ sudo systemctl list-units
$ sudo systemctl list-units --state running
```

```bash
$ sudo service --status-all
 [ + ]  acpid
 [ - ]  alsa-utils
 [ - ]  anacron
 [ + ]  apparmor
 [ + ]  apport
 [ + ]  avahi-daemon
 [ - ]  bluetooth
 [ - ]  console-setup.sh
 [ + ]  cron
 [ + ]  cups
 [ + ]  cups-browsed
 [ + ]  dbus
 [ + ]  gdm3
 [ - ]  grub-common
 [ - ]  hwclock.sh
 [ + ]  irqbalance
 [ + ]  kerneloops
 [ - ]  keyboard-setup.sh
 [ + ]  kmod
 [ - ]  lm-sensors
 [ - ]  lvm2
 [ - ]  lvm2-lvmpolld
 [ + ]  openvpn
 [ - ]  plymouth
 [ + ]  plymouth-log
 [ + ]  procps
 [ - ]  pulseaudio-enable-autospawn
 [ - ]  rsync
 [ - ]  saned
 [ - ]  speech-dispatcher
 [ - ]  spice-vdagent
 [ + ]  ssh
 [ + ]  sssd
 [ + ]  udev
 [ + ]  ufw
 [ + ]  unattended-upgrades
 [ - ]  uuidd
 [ - ]  whoopsie
 [ - ]  x11-common
 [ - ]  xrdp
```

## ubuntu 17.10 bootup settings

#### create script
```bash
$ cat /usr/local/bin/do_route.sh
#!/usr/bin/env bash

# Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
# 0.0.0.0         192.168.10.1    0.0.0.0         UG    0      0        0 eno2
/sbin/route -n | grep "0\.0\.0\.0.*192\.168\.10\.1.*eno2" > /dev/null 2>&1
if [ $? != 0 ]; then
  sudo route add default gw 192.168.10.1
fi

## Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
## 0.0.0.0         130.147.180.65  0.0.0.0         UG    0      0        0 eno1
/sbin/route -n | grep "0\.0\.0\.0.*130\.147\.180\.65.*eno1" > /dev/null 2>&1
if [ $? == 0 ]; then
  sudo route delete -net 0.0.0.0 gw 130.147.180.65 netmask 0.0.0.0
fi

host="161.92.35.78 130.147.236.5 180.166.223.190 140.207.91.234 42.99.164.34 185.46.212.34"
for _h in ${host}; do
    sudo route add -host ${_h} gw 130.147.180.65
done

route="130.147.0.0 130.140.0.0 130.146.0.0 137.55.0.0 161.83.0.0 161.84.0.0 161.85.0.0 161.88.0.0 161.91.0.0 161.92.0.0 185.166.0.0"
for _r in ${route}; do
  sudo route add -net ${_r} netmask 255.255.0.0 eno1
done

touch /home/devops/hi-marslo
```

#### create service
```bash
$ ls -altrh /lib/systemd/system/do_route.service
-rwxr-xr-x 1 root root 140 Jan 15 22:08 /lib/systemd/system/do_route.service

$ cat /lib/systemd/system/do_route.service
[Unit]
Description=Add static route for two interface

[Service]
ExecStart=/usr/local/bin/do_route.sh

[Install]
WantedBy=multi-user.target
Alias=myroute.service
```

#### enable the service
```bash
$ sudo systemctl enable do_route.service
Created symlink /etc/systemd/system/multi-user.target.wants/do_route.service → /lib/systemd/system/do_route.service.
Created symlink /etc/systemd/system/myroute.service → /lib/systemd/system/do_route.service.

$ sudo systemctl start do_route.service
```

#### disable the service
```bash
$ sudo systemctl disable do_route.service
Removed /etc/systemd/system/myroute.service.
Removed /etc/systemd/system/multi-user.target.wants/do_route.service.
```

#### re-enable the service
```bash
$ sudo systemctl enable add_route.service
Created symlink /etc/systemd/system/marslo_route.service → /lib/systemd/system/add_route.service.
Created symlink /etc/systemd/system/multi-user.target.wants/add_route.service → /lib/systemd/system/add_route.service.
```

#### route FLags
- `U`: Up: 表示此路由当前为启动状态
- `H`: Host: 表示此网关为一主机
- `G`: Gateway: 表示此网关为一路有
- `R`: Reinstate Route: 使用动态路由重新初始化的路由
- `D`: Dynamically: 此路由是动态性的写入
- `M`: Modifed: 此路由是有路由守护程序或导向器动态修改
- `!`: 关闭状态
