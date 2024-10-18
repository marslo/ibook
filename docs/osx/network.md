<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [check information](#check-information)
  - [get interface](#get-interface)
  - [get ip address](#get-ip-address)
  - [get mac address](#get-mac-address)
  - [get interface information](#get-interface-information)
  - [find local device ip address](#find-local-device-ip-address)
- [networksetup](#networksetup)
  - [show network information](#show-network-information)
  - [change order of networks](#change-order-of-networks)
  - [list hardware](#list-hardware)
  - [list localtion](#list-localtion)
- [wifi](#wifi)
  - [scan available wifi network](#scan-available-wifi-network)
  - [disable ipv6](#disable-ipv6)
  - [show network connection history](#show-network-connection-history)
  - [get wifi password](#get-wifi-password)
- [DNS](#dns)
  - [firewall](#firewall)
- [route](#route)
  - [check route](#check-route)
  - [add a static route item](#add-a-static-route-item)
  - [delete a static route](#delete-a-static-route)
- [vpn](#vpn)
  - [proxy setup](#proxy-setup)

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

> [!NOTE|label:references:]
> - [* iMarslo: get interface](../linux/network.md#get-interface-by-command)
> - [#340 - Multiple unused utun interfaces after macOS upgrade](https://github.com/Tunnelblick/Tunnelblick/issues/340)
> - [Who creates utun0 adapter?](https://apple.stackexchange.com/a/310221/254265)

```bash
# default route
$ ip route get $(dig +short github.com | head -1) | sed -rn 's|.*dev\s+(\S+)\s+src.*$|\1|p')
# or
$ ip route get $(nslookup "${githubIp}" | grep Server | awk -F' ' '{print $NF}') | sed -rn 's|.*dev\s+(\S+)\s+src.*$|\1|p'
en8

# all active interface
$ netstat -nr | grep -E 'UG|UGSc' | grep -E '^0.0.0|default' | grep -E '[0-9.]{7,15}' | awk '{print $NF}'
en0
en8
# osx 15.0
$ netstat -nr | command grep -E '^0.0.0|^default|UG|UGScg' | awk '$2 ~ /([0-9]{1,3}\.){3}[0-9]{1,3}/' | awk '{print $NF}'
en8
en0

$ networksetup -listnetworkserviceorder | grep --color=none 'Hardware Port' | awk -F'(, )|(: )|[)]' '{print $2, "~>", $4}'
USB 10/100/1000 LAN ~> en8
Wi-Fi ~> en0
Thunderbolt Bridge ~> bridge0
```

- get default interface
  ```bash
  $ ip route get 1.1.1.1 | sed -n -re 's/.+via.+dev ([0-9a-zA-Z]+) src.+$/\1/p'
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
    sname=$(echo "$line" | awk -F "(, )|(: )|[)]" '{print $2}')
    sdev=$(echo "$line" | awk -F "(, )|(: )|[)]" '{print $4}')
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

### find local device ip address
```bash
$ arp -a
```

## networksetup
### show network information
```bash
$ networksetup -listnetworkserviceorder
An asterisk (*) denotes that a network service is disabled.
(1) USB 10/100/1000 LAN
(Hardware Port: USB 10/100/1000 LAN, Device: en7)

(2) Wi-Fi
(Hardware Port: Wi-Fi, Device: en0)

...

# or
$ networksetup -listallnetworkservices
An asterisk (*) denotes that a network service is disabled.
USB 10/100/1000 LAN
Wi-Fi
Bluetooth PAN
Thunderbolt Bridge
```

### change order of networks
```bash
$ networksetup -ordernetworkservices "Wi-Fi" "Ethernet" "USB Ethernet"
```

### list hardware
```bash
$ networksetup -listallhardwareports

# list detail of hardware
$ networksetup -getinfo 'USB 10/100/1000 LAN'
DHCP Configuration
IP address: 192.168.1.10
Subnet mask: 255.255.255.0
Router: 192.168.1.1
Client ID:
IPv6: Automatic
IPv6 IP address: none
IPv6 Router: none
Ethernet Address: **:**:**:**:**:**

# or: https://apple.stackexchange.com/a/368047/254265
$ system_profiler SPAirPortDataType
Wi-Fi:

      Software Versions:
      ...
```

### list localtion
```bash
$ networksetup -listlocations
work
automatic
home

$ networksetup -getcurrentlocation
automatic

# create
$ networksetup -createlocation <name>

# delete
$ networksetup -deletelocation <name>

# switch localtion
$ networksetup -switchtolocation <name>
```

## wifi

> [!NOTE|label:references:]
> - [Mac Terminal WIFI Commands](https://www.mattcrampton.com/blog/managing_wifi_connections_using_the_mac_osx_terminal_command_line/)

- get wifi name
  ```bash
  $ networksetup -getairportnetwork en0
  Current Wi-Fi Network: WLAN-PUB
  ```

- get wifi interface
  ```bash
  $ system_profiler SPAirPortDataType | awk -F: '/Interfaces:/{getline; print $1;}'
    en0

  $ ifconfig -i $(system_profiler SPAirPortDataType | awk -F: '/Interfaces:/{getline; print $1;}')
  en0 (6):
    inet address  172.16.5.27
    netmask       255.255.0.0
    broadcast     172.16.255.255
    flags         UP BROADCAST NOTRAILERS RUNNING SIMPLEX MULTICAST
    mtu           1500
  ```

- get current Wifi network
  ```bash
  $ networksetup -getairportnetwork en0
  Current Wi-Fi Network: WLAN-PUB

  $ system_profiler SPAirPortDataType | awk -F':' '/Current Network Information:/ {
        getline
        sub(/^ */, "")
        sub(/:$/, "")
        print
    }'
  WLAN-PUB
  Network Type: Infrastructure
  ```

- connect to another
  ```bash
  $ networksetup -setairportnetwork en0 WLAN-PUB <wifi-password>
  $ networksetup -getairportnetwork en0
  Current Wi-Fi Network: WLAN-PUB

  $ networksetup -setairportnetwork en0 Automation-4G <wifi-password>
  $ networksetup -getairportnetwork en0
  Current Wi-Fi Network: Automation-4G
  ```

- turn on/off wifi
  ```bash
  # check wifi status
  $ system_profiler SPAirPortDataType | awk -F: '/Status:/{print $2}'
   Connected
  # or
  $ networksetup -getairportpower en0
  Wi-Fi Power (en0): On
  # or
  $ networksetup -getairportpower $(networksetup -listallhardwareports | awk -F: '/Wi-Fi/{getline; print $2;}')
  Wi-Fi Power (en0): On

  # turn on
  $ networksetup -setairportpower en0 on
  $ networksetup -getairportpower en0
  Wi-Fi Power (en0): On

  # turn off
  $ networksetup -setairportpower en0 off
  $ networksetup -getairportpower en0
  Wi-Fi Power (en0): Off
  ```

### scan available wifi network
```bash
$ networksetup -setairportpower en0 on

# not available anymore
$ sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s
                            SSID BSSID             RSSI CHANNEL HT CC SECURITY (auth/unicast/group)
                        Customer **:**:**:**:**:** -75  11      N  CN WEP
                        CorpWLAN **:**:**:**:**:** -72  1       Y  CN WPA2(802.1x,Unrecognized(0)/AES/AES)
                           Guest **:**:**:**:**:** -71  1       Y  CN NONE
```

### disable ipv6
```bash
$ networksetup -listallnetworkservices
An asterisk (*) denotes that a network service is disabled.
USB 10/100/1000 LAN
Wi-Fi
Bluetooth PAN
Thunderbolt Bridge

# disable
$ networksetup -setv6off 'USB 10/100/1000 LAN'
$ networksetup -setv6off Wi-fi

# undo
$ networksetup -setv6automatic 'USB 10/100/1000 LAN'
$ networksetup -setv6automatic Wi-Fi
```

### [show network connection history](https://apple.stackexchange.com/a/469507/254265)
```bash
$ networksetup -listpreferredwirelessnetworks en0

# older version
$ defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences \
           | grep LastConnected -A 7
```

### get wifi password

- list connected Wifi
  ```bash
  $ networksetup -listpreferredwirelessnetworks en0

  # older version
  $ defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences | \grep SSIDString
  ...
  SSIDString = "Apple Network Guest";
  ...
  ```

- get password
  ```bash
  $ sudo security find-generic-password -ga "Apple Network Guest"  | grep password\:
  password: "guest@3742"
  ```


## DNS

- get info
  ```bash
  $ scutil --dns
  DNS configuration
  resolver #1
  ...
  resolver #7

  DNS configuration (for scoped queries)
  resolver #1
    search domain[0] : ...
    nameserver[0] : ...
    nameserver[1] : ...
    nameserver[2] : ...
    if_index : ...
    flags    : ...
    reach    : ...
  ```

- setup DNS

  > [!NOTE|label:references:]
  > ```bash
  > $ networksetup -getdnsservers Wi-Fi
  > There aren't any DNS Servers set on Wi-Fi.
  > ```

  ```bash
  $ networksetup -setdnsservers Wi-Fi 192.168.236.5 192.168.35.78 192.168.2.69 192.168.200.139

  $ networksetup -getdnsservers Wi-Fi
  192.168.236.5
  192.168.35.78
  192.168.2.69
  192.168.200.139

  $ cat /etc/resolv.conf
  nameserver 192.168.236.5
  nameserver 192.168.35.78
  nameserver 192.168.2.69
  nameserver 192.168.200.139
  ```

### firewall
- show status
  ```bash
  $ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
  Firewall is disabled. (State = 0)
  ```
- enable firewall
  ```bash
  $ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
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
|  `U` | Up—Route is valid                                                         |
|  `G` | Gateway—Route is to a gateway router                                      |
|  `H` | Host name—Route is to a host rather than to a network                     |
|  `R` | Reject—Set by ARP when an entry expires                                   |
|  `D` | Dynamic—Route added by a route redirect or RIP                            |
|  `M` | Modified—Route modified by a route redirect                               |
|  `C` | Cloning—A new route is cloned from this entry when it is used             |
|  `L` | Link—Link-level information, such as the Ethernet MAC address, is present |
|  `S` | Static—Route added with the route command                                 |


### check route
- show all
  ```bash
  # linux-like route -n
  $ netstat -nr

  # ipv4
  $ netstat -nr -f inet

  # ipv6
  $ netstat -nr -f inet6

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
> - `scutil`
>    ```bash
>    $ scutil --help
>       or: scutil --nc
>           show VPN network configuration information. Use --nc help for full command list
>
>    $ scutil --nc help
>    ```

### proxy setup

> [!NOTE|label:references:]
> ```bash
> $ networksetup -printcommands
> networksetup -getwebproxy <networkservice>
> networksetup -setwebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
> networksetup -setwebproxystate <networkservice> <on off>
> networksetup -getsecurewebproxy <networkservice>
> networksetup -setsecurewebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
> networksetup -setsecurewebproxystate <networkservice> <on off>
> networksetup -getsocksfirewallproxy <networkservice>
> networksetup -setsocksfirewallproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
> networksetup -setsocksfirewallproxystate <networkservice> <on off>
> networksetup -getproxybypassdomains <networkservice>
> networksetup -setproxybypassdomains <networkservice> <domain1> [domain2] [...]
> networksetup -getproxyautodiscovery <networkservice>
> networksetup -setproxyautodiscovery <networkservice> <on off>
> ```

```bash
$ networksetup -getwebproxy Wi-Fi
Enabled: No
Server:
Port: 0
Authenticated Proxy Enabled: 0

$ networksetup -getwebproxy Ethernet
Enabled: No
Server:
Port: 0
Authenticated Proxy Enabled: 0

$ networksetup -getproxybypassdomains Ethernet
*.local
169.254/16

$ scutil --proxy
<dictionary> {
  HTTPEnable : 0
  HTTPSEnable : 0
  ProxyAutoConfigEnable : 1
  ProxyAutoConfigURLString : http://pac.domain.com/global-pac.pac
  SOCKSEnable : 0
}
```
