<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [ip address](#ip-address)
- [check port](#check-port)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### ip address
- get subnet IP address
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

### check port
```bash
$ sudo lsof -i:1111
COMMAND   PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
ss-server 903 nobody    8u  IPv4  20522      0t0  UDP *:1111
obfs-serv 909   root    7u  IPv4  20649      0t0  TCP *:1111 (LISTEN)

$ sudo netstatus -tunpla | grep 1111
tcp        0      0 0.0.0.0:1111            0.0.0.0:*               LISTEN      909/obfs-server
udp        0      0 0.0.0.0:1111            0.0.0.0:*                           903/ss-server
```
