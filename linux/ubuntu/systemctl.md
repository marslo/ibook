<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [ubuntu 17.10 bootup settings](#ubuntu-1710-bootup-settings)
- [Reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## ubuntu 17.10 bootup settings
#### create Script
```bash
$ cat /usr/local/bin/do_route.sh
##!/bin/bash

## Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
## 0.0.0.0         192.168.10.1    0.0.0.0         UG    0      0        0 eno2
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
- U: Up: 表示此路由当前为启动状态
- H: Host: 表示此网关为一主机
- G: Gateway: 表示此网关为一路有
- R: Reinstate Route: 使用动态路由重新初始化的路由
- D: Dynamically: 此路由是动态性的写入
- M: Modifed: 此路由是有路由守护程序或导向器动态修改
- !: 关闭状态

## Reference
- [How to automatically execute shell script at startup boot on systemd Linux](https://linuxconfig.org/how-to-automatically-execute-shell-script-at-startup-boot-on-systemd-linux)
- [Using systemd to control the Docker daemon](https://success.docker.com/article/Using_systemd_to_control_the_Docker_daemon)
- [systemd_service.5.manual](http://manpages.ubuntu.com/manpages/zesty/man5/systemd.service.5.html)
- [Linux route命令详解：查看和操作IP路由表](http://network.51cto.com/art/201503/469761.htm)
- [ubuntu配置静态路由及重启生效](http://www.mamicode.com/info-detail-1704736.html)
- [Systemd的Unit文件; systemctl增加服务详细介绍](http://blog.csdn.net/shuaixingi/article/details/49641721)
- [SystemdForUpstartUsers](https://wiki.ubuntu.com/SystemdForUpstartUsers)
