<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [check information](#check-information)
  - [get interface](#get-interface)
  - [get ip address](#get-ip-address)
  - [get mac address](#get-mac-address)
  - [get interface information](#get-interface-information)
- [route](#route)
  - [check route](#check-route)
  - [add a static route item](#add-a-static-route-item)
  - [delete a static route](#delete-a-static-route)
- [vpn](#vpn)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## check information

> [!NOTE|label:references:]
> - [* imarslo : linux/network](../linux/network.html)

```bash
$ scutil --nwi
Network information

IPv4 network interface information
     en8 : flags      : 0x5 (IPv4,DNS)
           address    : 10.1.1.1
           reach      : 0x00000002 (Reachable)
     en0 : flags      : 0x5 (IPv4,DNS)
           address    : 192.168.6.55
           reach      : 0x00000002 (Reachable)

   REACH : flags 0x00000002 (Reachable)

IPv6 network interface information
   No IPv6 states found


   REACH : flags 0x00000000 (Not Reachable)

Network interfaces: en8 en0
```

### get interface
```bash
# default route
$ ip route get $(dig +short github.com | head -1) | sed -rn 's|.*dev\s+(\S+)\s+src.*$|\1|p')
# or
$ ip route get $(nslookup "${githubIp}" | grep Server | awk -F' ' '{print $NF}') | sed -rn 's|.*dev\s+(\S+)\s+src.*$|\1|p'
en8

# all active interface
$ netstat -nr | grep -E 'UG|UGSc' | grep -E '^0.0.0|default' | grep -E '[0-9.]{7,15}' | awk -F' ' '{print $NF}'
en0
en8
```

- list all interfaces
  ```bash
  $ /sbin/ifconfig | grep --color=none flags=8863 | grep -v bridge
  en5: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
  en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
  llw0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
  en8: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500

  # or
  $ scutil --nwi | awk -F': ' '/Network interfaces/ {print $2;exit;}'
  en8 en0
  ```

### get ip address
```bash
$ ipAddr=$(/usr/local/bin/ip a s "${interface}" | sed -rn 's|\W*inet[^6]\W*([0-9\.]{7,15}).*$|\1|p')
# or via `/sbin/ifconfig`
$ ipAddr=$(/sbin/ifconfig "${interface}" | sed -rn 's|^\s+inet\s+([0-9\.]+))
```

### get mac address
```bash
$ ip link show ${interface} | sed -rn 's|.*ether ([0-9a-fA-F:]{17}).*$|\1|p' | sed 's|:||g' | tr [a-z] [A-Z]
```

### get interface information
```bash
#!/bin/bash

while read -r line; do
    sname=$(echo "$line" | awk -F  "(, )|(: )|[)]" '{print $2}')
    sdev=$(echo "$line" | awk -F  "(, )|(: )|[)]" '{print $4}')
    # echo "Current service: $sname, $sdev, $currentservice"
    if [ -n "$sdev" ]; then
        ifout="$(/sbin/ifconfig "$sdev" 2>/dev/null)"
        echo "$ifout" | grep 'status: active' > /dev/null 2>&1
        rc="$?"
        if [ "$rc" -eq 0 ]; then
            currentservice="$sname"
            currentdevice="$sdev"
            currentip=$(echo "${ifout}" | sed -rn 's|^\s+inet\s+([0-9\.]+).*$|\1|p')
            currentmac=$(echo "$ifout" | awk '/ether/{print $2}')
            # may have multiple active devices, so echo it here
            echo "$currentservice, $currentdevice, $currentmac, ${currentip}"
        fi
    fi
done <<< "$(networksetup -listnetworkserviceorder | grep --color=none 'Hardware Port')"
```

## route

> [!NOTE|label:references:]
> - [* imarslo : route](../devops/network.html#route)
> - [* imarslo : ubuntu 17.10 bootup settings](../linux/ubuntu/systemctl.html#ubuntu-1710-bootup-settings)
> - [Adding a Static Route to macOS](https://support.justaddpower.com/kb/article/320-adding-a-static-route-to-macos/)
> - [How to get routing table in terminal [duplicate]](https://apple.stackexchange.com/a/222578/254265)
> - [can we change default gateway and interface in mac through commandline](https://stackoverflow.com/a/37552894/2940319)
> - [Viewing the routing table from the command-line interface](https://library.netapp.com/ecmdocs/ECMP1155586/html/GUID-BA9AD6B9-B994-4F41-B5A0-C22071BAB2A4.html)
>   - [Routing table flags](https://library.netapp.com/ecmdocs/ECMP1155586/html/GUID-07F1F043-7AB7-4749-8F8D-727929233E62.html)
> - [* Chapter 4 Administering TCP/IP (Task)](https://docs.oracle.com/cd/E19683-01/806-4075/6jd69oa7h/index.html)

- route flags


  | FLAG | DESCRIPTION                                                               |
  |:----:|---------------------------------------------------------------------------|
  |   U  | Up—Route is valid                                                         |
  |   G  | Gateway—Route is to a gateway router                                      |
  |   H  | Host name—Route is to a host rather than to a network                     |
  |   R  | Reject—Set by ARP when an entry expires                                   |
  |   D  | Dynamic—Route added by a route redirect or RIP                            |
  |   M  | Modified—Route modified by a route redirect                               |
  |   C  | Cloning—A new route is cloned from this entry when it is used             |
  |   L  | Link—Link-level information, such as the Ethernet MAC address, is present |
  |   S  | Static—Route added with the route command                                 |


### check route
- show all
  ```bash
  # linux-like route -n
  $ netstat -nr
  # or
  $ netstat -nr -f inet

  # via `ip route`
  $ ip route show
  ```

- show particular ip
  ```bash
  $ route get <ip.address>
     route to: ec2-1-1-1-1.compute-1.amazonaws.com
  destination: ec2-1-1-1-1.compute-1.amazonaws.com
      gateway: 192.168.0.1
    interface: en0
        flags: <UP,GATEWAY,HOST,DONE,STATIC>
   recvpipe  sendpipe  ssthresh  rtt,msec    rttvar  hopcount      mtu     expire
         0         0         0        77        11         0      1500         0

  # or via `ip route`
  $ ip route get 1.1.1.1
  1.1.1.1 via 192.168.0.1 dev en0  src 192.168.6.55
  ```

- [display network interface status](https://docs.oracle.com/cd/E19683-01/806-4075/ipconfig-proc-56/index.html)
  ```bash
  $ netstat -i
  ```

- [log network problems](https://docs.oracle.com/cd/E19683-01/806-4075/ipconfig-146/index.html)
  ```bash
  $ /usr/sbin/in.routed /var/logfilename
  ```

### add a static route item
```bash
$ sudo route -nv add -host <ip.address> <gateway>

# or
$ sudo route add -host <ip.address> -iface en1
```

### delete a static route
```bash
$ sudo route delete <ip.address> <gateway>
```

## vpn

> [!NOTE|label:references:]
> - [* use networksetup or scutil](https://apple.stackexchange.com/a/419190/254265)
> - [* determining if the system is connected to a vpn from the command line under os x](https://support.moonpoint.com/os/os-x/vpn_connected.php)

