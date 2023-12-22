<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [get into](#get-into)
  - [get interface by command](#get-interface-by-command)
  - [get ipv4 address](#get-ipv4-address)
  - [get ip address by hostname](#get-ip-address-by-hostname)
  - [get active interface](#get-active-interface)
  - [get active IP address](#get-active-ip-address)
  - [get active Mac address](#get-active-mac-address)
  - [check remote server dns](#check-remote-server-dns)
- [nmap](#nmap)
  - [host discovery](#host-discovery)
  - [scan `80` or `22` in particular setment](#scan-80-or-22-in-particular-setment)
  - [OS detection with verbosity](#os-detection-with-verbosity)
  - [find printer](#find-printer)
  - [list hostname with mac address](#list-hostname-with-mac-address)
  - [get all server up ip address](#get-all-server-up-ip-address)
  - [scan ip/host](#scan-iphost)
- [route](#route)
  - [iptables](#iptables)
  - [port forwarding](#port-forwarding)
- [traceroute](#traceroute)
  - [traceroute for port](#traceroute-for-port)
  - [No route to host](#no-route-to-host)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## get into

> [!NOTE|label:references:]
> - [* imarslo : osx/network](../osx/network.md)

### get interface by command
```bash
interface=$(netstat -nr | grep -E 'UG|UGSc' | grep -E '^0.0.0|default' | grep -E '[0-9.]{7,15}' | awk -F' ' '{print $NF}')
# or get the route to github
interface=$(ip route get $(nslookup github.com | grep Server | awk -F' ' '{print $NF}') | sed -rn 's|.*dev\s+(\S+)\s+src.*$|\1|p')
```

### get ipv4 address
```bash
ipAddr=$(ip a s "${interface}" | sed -rn 's|.*inet ([0-9\.]{7,15})/[0-9]{2} brd.*$|\1|p')
```

### get ip address by hostname
- [`ping` & `sed`](https://unix.stackexchange.com/a/45246/29178)
  ```bash
  $ ping -q -c 1 -t 1 github.com | sed -n -re 's:^PING.*\(([0-9\.]{7,15})\).*$:\1:p'
  ```

- [`dig`](https://unix.stackexchange.com/a/20793/29178)
  ```bash
  $ dig +short github.com

  # or
  $ dig github.com | awk '/^;; ANSWER SECTION:$/ { getline ; print $5 }'
  ```

- `nslookup`
  ```bash
  $ nslookup github.com | awk '/Name:/{getline; print $2;}'
  ```

### get active interface
```bash
$ interface=$(netstat -nr | grep -E 'UG|UGSc' | grep -E '^0.0.0|default' | grep -E '[0-9.]{7,15}' | awk -F' ' '{print $NF}')

# or get the route to github
$ interface=$(ip route get $(nslookup github.com | grep Server | awk -F' ' '{print $NF}') | sed -rn 's|.*dev\s+(\S+)\s+src.*$|\1|p')
```

### get active IP address
```bash
$ githubIP=$(dig +short github.com | head -1)

$ interface=$(ip route get ${githubIP} | sed -rn 's|.*dev\s+(\S+)\s+src.*$|\1|p')
$ ipaddr=$(ip a s ${interface} | sed -rn 's|\W*inet[^6]([0-9\.]{7,15}).*$|\1|p')
```

### get active Mac address
```bash
$ githubIP=$(dig +short github.com | head -1)

$ interface=$(ip route get ${githubIP} | sed -rn 's|.*dev\s+(\S+)\s+src.*$|\1|p')
$ macaddr=$(ip link show ${interface} | sed -rn 's|.*ether ([0-9a-fA-F:]{17}).*$|\1|p' | sed 's|:||g' | tr [a-z] [A-Z])
```

#### `dig`
```bash
$ dig +noall +answer <domain.name>
```

### check remote server dns
```bash
$ for _i in {1..10}; do
    echo -e "\n\n ~~~> myserver_${i}"
    ssh -q marslo@myserver_${_i} "cat /etc/resolv.conf | sed -nre 's:^nameserver\s([0-9.]+):\1:p' | xargs -L1 /usr/bin/ping -c 1"
  done
```

## [nmap](https://nmap.org/)
{% hint style='tip' %}
> reference:
> - [SOLUTION: Scan a Large Network for a Certain Open TCP Port](https://nmap.org/book/solution-find-open-port.html)
> - [Nmap Network Scanning](http://nmap.org/book/man-host-discovery.html)
{% endhint %}


### [host discovery](https://nmap.org/book/man-host-discovery.html)

|                       parameter | comments                                                             |
|--------------------------------:|----------------------------------------------------------------------|
|           `-iL <inputfilename>` | Input from list of hosts/networks                                    |
|               `-iR <num hosts>` | Choose random targets                                                |
|                           `-sL` | List Scan - simply list targets to scan                              |
|                           `-sP` | Ping Scan - go no further than determining if host is online         |
|                           `-P0` | Treat all hosts as online -- skip host discovery                     |
|          `-PS/PA/PU [portlist]` | TCP SYN/ACK or UDP discovery probes to given ports                   |
|                     `-PE/PP/PM` | ICMP echo, timestamp, and netmask request discovery probes           |
|                         `-n/-R` | Never do DNS resolution/Always resolve [default ⎮ sometimes resolve] |
|               `-sS/sT/sA/sW/sM` | TCP SYN/Connect()/ACK/Window/Maimon scans                            |
|                     `-sN/sF/sX` | TCP Null, FIN, and Xmas scans                                        |
|                           `-sO` | IP protocol scan                                                     |
| `-sI <zombie host[:probeport]>` | Idlescan                                                             |
|                            `-O` | Enable OS detection                                                  |


### scan `80` or `22` in particular setment
```bash
$ nmap -sT -p 80 -oG - 10 - 1.2.3.* [| grep open]
$ nmap -sT -p 22 -oG - 10 - 1.2.3.* [| grep open]
```

### [OS detection with verbosity](https://nmap.org/book/osdetect-usage.html)
```bash
$ sudo nmap -O -v 192.168.1.0/23
Starting Nmap 7.91 ( https://nmap.org ) at 2021-02-03 15:51 CST
Initiating ARP Ping Scan at 15:51
Scanning 511 hosts [1 port/host]
Completed ARP Ping Scan at 15:51, 2.02s elapsed (511 total hosts)
Initiating Parallel DNS resolution of 118 hosts. at 15:51
Completed Parallel DNS resolution of 118 hosts. at 15:51, 0.18s elapsed
Nmap scan report for 192.168.1.0 [host down]
Nmap scan report for 192.168.1.2 [host down]
...

Nmap scan report for 192.168.1.1
Host is up (0.0016s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE
22/tcp open  ssh
23/tcp open  telnet
MAC Address: C0:**:**:**:**:C8 (Cisco Systems)
OS details: Cisco 2950, 2960, 3550, 3560, 3750, or 4500 switch or 6500 router (IOS 12.1 - 15.0); or Adaptive Security Appliance firewall
Network Distance: 1 hop
TCP Sequence Prediction: Difficulty=264 (Good luck!)
IP ID Sequence Generation: Randomized
...
```

### [find printer](https://serverfault.com/a/154696/129815)
```bash
$ sudo nmap -p 9100,515,631 192.168.1.0/23 [-oX printers.xml]
...
Starting Nmap 7.91 ( https://nmap.org ) at 2021-02-03 16:09 CST
Nmap scan report for 192.168.1.191
Host is up (0.0029s latency).

PORT     STATE  SERVICE
515/tcp  closed printer
631/tcp  closed ipp
9100/tcp open   jetdirect
MAC Address: 08:00:27:96:17:9E (Oracle VirtualBox virtual NIC)

Nmap done: 1 IP address (1 host up) scanned in 0.29 second
...
```

- or
  ```bash
  $ sudo nmap [-sT] -p 9100,515,631 -oG - 192.168.1.0/23
  # Nmap 7.91 scan initiated Wed Feb  3 16:44:20 2021 as: nmap -p 9100,515,631 -oG - 192.168.1.0/23
  Host: 192.168.1.1 ()  Status: Up
  Host: 192.168.1.1 ()  Ports: 515/closed/tcp//printer///, 631/closed/tcp//ipp///, 9100/closed/tcp//jetdirect///
  Host: 192.168.1.13 () Status: Up
  Host: 192.168.1.13 () Ports: 515/open/tcp//printer///, 631/open/tcp//ipp///, 9100/open/tcp//jetdirect///
  Host: 192.168.1.1 ()  Status: Up
  Host: 192.168.1.1 ()  Ports: 515/closed/tcp//printer///, 631/closed/tcp//ipp///, 9100/closed/tcp//jetdirect///
  Host: 192.168.1.254 ()  Status: Up
  Host: 192.168.1.254 ()  Ports: 515/filtered/tcp//printer///, 631/filtered/tcp//ipp///, 9100/filtered/tcp//jetdirect///
  # Nmap done at Wed Feb  3 16:44:28 2021 -- 512 IP addresses (4 hosts up) scanned in 8.37 seconds
  ```

### [list hostname with mac address](https://serverfault.com/a/674347/129815)
```bash
$ sudo nmap -sP 172.31.201.0/24 | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " => "$3;}' | sort
192.168.1.1 => C0:**:**:**:**:C8
192.168.1.108 => 08:**:**:**:**:6B
192.168.1.109 => 08:**:**:**:**:96
...
```

- [get hostname, macaddress, OS](https://serverfault.com/a/939364/129815)
  ```bash
  $ sudo nmap -sn 192.168.1.0/23 | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " => "substr($0, index($0,$3)) }' | sort
  192.168.1.1 => C0:**:**:**:**:C8 (Cisco Systems)
  192.168.1.108 => 08:**:**:**:**:6B (Oracle VirtualBox virtual NIC)
  192.168.1.109 => 08:**:**:**:**:96 (Oracle VirtualBox virtual NIC)
  ...
  ```

### [get all server up ip address](https://serverfault.com/a/586721/129815)
```bash
$ sudo nmap -v -sn -n 192.168.1.0/24 -oG - | awk '/Status: Up/{print $2}'
```
- get down
  ```bash
  $ sudo nmap -v -sn -n 192.168.1.0/24 -oG - | awk '/Status: Down/{print $2}'
  ```

### [scan ip/host](https://www.maketecheasier.com/fix-no-route-to-host-error-linux/)
```bash
$ sudo nmap -sS 1.2.3.4
Starting Nmap 7.94 ( https://nmap.org ) at 2023-08-14 22:52 PDT
Nmap scan report for host.example.com (1.2.3.4)
Host is up (0.00077s latency).
Not shown: 991 filtered tcp ports (no-response), 6 filtered tcp ports (admin-prohibited)
PORT     STATE SERVICE
22/tcp   open  ssh
3389/tcp open  ms-wbt-server
9090/tcp open  zeus-admin

Nmap done: 1 IP address (1 host up) scanned in 4.98 seconds

# or
$ sudo nmap -Pn -sS --reason 1.2.3.4
Starting Nmap 7.94 ( https://nmap.org ) at 2023-08-14 23:02 PDT
Nmap scan report for host.example.com (1.2.3.4)
Host is up, received user-set (0.018s latency).
Not shown: 997 closed tcp ports (reset)
PORT     STATE SERVICE REASON
22/tcp   open  ssh     syn-ack ttl 61
111/tcp  open  rpcbind syn-ack ttl 61
2049/tcp open  nfs     syn-ack ttl 61
```

- [trace with port](https://serverfault.com/q/999723/129815)
  ```bash
  $ nmap --reason -p 16000 192.168.0.104
  ```

## route

### iptables

> [!NOTE|label:references:]
> - [Linux系统运维: Iptables 应用](https://www.yaolong.net/article/linux-ops-iptables/)
> - [How to save/backup existing iptables rules to a file – Iptables commands](https://www.crybit.com/how-to-save-current-iptables-rules/)
> - [How to Backup Iptables Configuration](https://elearning.wsldp.com/pcmagazine/backup-iptables-configuration/)
> - [What's the difference between PREROUTING and FORWARD in iptables?](https://askubuntu.com/a/579242/92979)
>   ```bash
>   $ iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
>   $ iptables -A FORWARD -i eth0 -p tcp --dport 80 -d 192.168.0.4 -j ACCEPT
>   ```
> - [How to list all iptables rules with line numbers on Linux](https://www.cyberciti.biz/faq/how-to-list-all-iptables-rules-in-linux/)
> - [How To Forward Ports through a Linux Gateway with Iptables](https://www.digitalocean.com/community/tutorials/how-to-forward-ports-through-a-linux-gateway-with-iptables)

- show status
  ```bash
  $ sudo iptables -L -nv --line-number
  ```

- backup
  ```bash
  $ sudo iptables-save > iptables-backup-$(date +%F)

  # or
  $ sudo iptables-save > /etc/iptables/rules.v4
  $ sudo ip6tables-save > /etc/iptables/rules.v6 # for ipv6

  # automatic backup
  $ crontab -L
  0 0 * * * root iptables-save > /backup/iptables-backup-$(date +%F)
  ```

- restore
  ```bash
  $ sudo iptables-restore < /path/to/backup/file
  ```

- flush
  ```bash
  $ sudo iptables -F
  ```

### port forwarding

> [!NOTE|label:references:]
> - [How can I port forward with iptables?](https://serverfault.com/a/140626/129815)
> - [Basic iptables NAT port forwarding](https://serverfault.com/a/326577/129815)
> - [How to formulate IP forwarding rule using iptables](https://serverfault.com/a/383348/129815)

```bash
# enable forwarding is allowed
$ echo '1' | sudo tee /proc/sys/net/ipv4/conf/ppp0/forwarding
$ echo '1' | sudo tee /proc/sys/net/ipv4/conf/eth0/forwarding
# or
$ sudo sysctl net.ipv4.conf.eth0.forwarding=1
$ sudo sysctl net.ipv6.conf.eth0.forwarding=1
# or
$ cat << EOF > /etc/sysctl.d/99-forwarding.conf
sysctl net.ipv4.conf.eth0.forwarding=1
sysctl net.ipv6.conf.eth0.forwarding=1
EOF

# port forward
$ sudo iptables -t nat -A PREROUTING -p tcp -i ppp0 --dport 8001 -j DNAT --to-destination 192.168.1.200:8080
$ sudo iptables -A FORWARD -p tcp -d 192.168.1.200 --dport 8080 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# or https://serverfault.com/a/140624/129815
$ sudo iptables -A FORWARD -m state -p tcp -d 192.168.1.200 --dport 8080 --state NEW,ESTABLISHED,RELATED -j ACCEPT
$ sudo iptables -t nat -A PREROUTING -p tcp --dport 8001 -j DNAT --to-destination 192.168.1.200:8080
```

- [more details](https://serverfault.com/a/326577/129815)
  ```bash
  #    PC ----- Ubuntu 10 Server ----- Slashdot
  # (1.2.3.4)      (5.6.7.8)        (216.34.181.45)

  # enable ip forwarding
  $ sudo echo 1 > /proc/sys/net/ipv4/ip_forward

  # add rule
  $ iptables -t nat -A PREROUTING -i eth0 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 216.34.181.45:80
  $ iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source 5.6.7.8

  # use MASQUERADE if the Ubuntu has a dynamic IP
  $ iptables -t nat -A POSTROUTING -j MASQUERADE

  # jumper server
  $ ssh -L 5.6.7.8:8080:216.34.181.45:80 -N user@216.34.181.45

  # more config
  $ cat /etc/rinetd.conf
  5.6.7.8 8080 216.34.181.45 80
  $ /etc/init.d/rinetd start

  # iptable-save
  *nat -A PREROUTING -p tcp -m tcp -i eth0 --dport 8080 -j DNAT --to-destination 216.34.181.45:80 -A POSTROUTING -o eth0 -j SNAT --to-source 5.6.7.8 COMMIT
  ```

- [script](https://serverfault.com/a/743017/129815)

  <!--sec data-title="./port_forward.sh -r 192.168.1.100 3000" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  #!/bin/bash

  # decide which action to use
  action="add"
  if [[ "-r" == "$1" ]]; then
    action="remove"
    shift
  fi

  # break out components
  dest_addr_lan="$1"
  dest_port_wan="$2"
  dest_port_lan="$3"

  # figure out our WAN ip
  wan_addr=`curl -4 -s icanhazip.com`

  # auto fill our dest lan port if we need to
  if [ -z $dest_port_lan ]; then
    dest_port_lan="$dest_port_wan"
  fi

  # print info for review
  echo "Destination LAN Address: $dest_addr_lan"
  echo "Destination Port WAN: $dest_port_wan"
  echo "Destination Port LAN: $dest_port_lan"
  echo "WAN Address: $wan_addr"

  # confirm with user
  read -p "Does everything look correct? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ "remove" == "$action" ]]; then
      iptables -t nat -D PREROUTING  -p tcp -m tcp -d $wan_addr --dport     $dest_port_wan -j DNAT --to-destination $dest_addr_lan:$dest_port_lan
      iptables -D FORWARD -m state -p tcp -d $dest_addr_lan --dport     $dest_port_lan --state NEW,ESTABLISHED,RELATED -j ACCEPT
      iptables -t nat -D POSTROUTING -p tcp -m tcp -s $dest_addr_lan --sport     $dest_port_lan -j SNAT --to-source $wan_addr
      echo "Forwarding rule removed"
    else
      iptables -t nat -A PREROUTING  -p tcp -m tcp -d $wan_addr --dport     $dest_port_wan -j DNAT --to-destination $dest_addr_lan:$dest_port_lan
      iptables -A FORWARD -m state -p tcp -d $dest_addr_lan --dport     $dest_port_lan --state NEW,ESTABLISHED,RELATED -j ACCEPT
      iptables -t nat -A POSTROUTING -p tcp -m tcp -s $dest_addr_lan --sport $dest_port_lan -j SNAT --to-source $wan_addr
      echo "Forwarding rule added"
    fi
  else
    echo "Info not confirmed, exiting..."
  fi
  ```
  <!--endsec-->

## traceroute

> [!NOTE|label:references:]
> - [How does traceroute -T -p work?](https://serverfault.com/q/791718/129815)
> - [What does "!Z" and "!X" mean in a traceroute?](https://serverfault.com/a/434218/129815)
>   - `!X` means "communication administratively prohibited"`
>   - `!Z` means "communication with destination host administratively prohibited"
>   ```bash
>   Since Linux uses UDP for trace-routes, this can originate from a `--reject-with icmp-host-prohibited`
>   To fix this you need to reply with `--reject-with icmp-port-unreachable` on UDP ports 33434 through 33534
>   ```
> - [How to open and close ports on RHEL 8 / CentOS 8 Linux](https://linuxconfig.org/redhat-8-open-and-close-ports)
> - [How To Set Up a Firewall Using firewalld on CentOS 8](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-8)
> - [How to stop/start firewall on RHEL 8 / CentOS 8](https://linuxconfig.org/redhat-8-stop-start-firewall)
> - [How To Fix “No Route To Host” In Linux](https://www.technewstoday.com/no-route-to-host/)

### traceroute for port

> [!NOTE|label:references:]
> - []

```bash
## before firewall open the port 2376
$ sudo traceroute -T -p 2376 1.2.3.4
traceroute to 1.2.3.4 (1.2.3.4), 30 hops max, 60 byte packets
 1  _gateway (127.0.0.1)  0.624 ms  0.603 ms  0.594 ms
 6  host.example.com (1.2.3.4)  14.750 ms !X  14.682 ms !X  23.138 ms !X

## after firewall open the port 2376
$ sudo traceroute -T -p 2376 1.2.3.4
traceroute to 1.2.3.4 (1.2.3.4), 30 hops max, 60 byte packets
 1  _gateway (127.0.0.1)  0.346 ms  0.316 ms  0.310 ms
 6  host.example.com (1.2.3.4)  23.093 ms  14.725 ms  14.625 ms
```

### No route to host

> [!NOTE|label:references:]
> - [Linux系统运维: 防火墙 - Firewalld](https://www.yaolong.net/article/linux-ops-firewalld/)

```bash
$ nc -zv 1.2.3.4 2376
nc: connect to 1.2.3.4 port 2376 (tcp) failed: No route to host

$ traceroute 1.2.3.4
traceroute to 1.2.3.4 (1.2.3.4), 30 hops max, 60 byte packets
 1  _gateway (127.0.0.1)  0.569 ms  0.539 ms  2.512 ms
 2  host.example.com (1.2.3.4)  23.582 ms !X  23.486 ms !X  15.065 ms !X
#                                          ^             ^             ^
#                                    communication administratively prohibited
```

- check firewall status
  ```bash
  $ ssh 1.2.3.4
  $ sudo firewall-cmd --state
  running

  $ sudo firewall-cmd --list-all
  public (active)
    target: default
    icmp-block-inversion: no
    interfaces: enp74s0
    sources:
    services: cockpit dhcpv6-client ssh
    ports: 3389/tcp
    protocols:
    forward: no
    masquerade: no
    forward-ports:
    source-ports:
    icmp-blocks:
    rich rules:

  $ sudo firewall-cmd --zone=public --list-ports
  3389/tcp
  ```

- enable port
  ```bash
  $ sudo firewall-cmd --zone=public --permanent --add-port 2376/tcp
  success

  $ sudo firewall-cmd --zone=public --list-ports
  3389/tcp

  $ sudo firewall-cmd --reload
  success

  $ sudo firewall-cmd --zone=public --list-ports
  2376/tcp 3389/tcp
  ```

- verify
  ```bash
  $ nc -zv 1.2.3.4 2376
  Connection to 1.2.3.4 2376 port [tcp/docker-s] succeeded!

  $ docker -H tcp://1.2.3.4:2376 images
  REPOSITORY     TAG        IMAGE ID       CREATED          SIZE
  ubuntu         18.04      71cb16d32be4   10 months ago    63.1MB
  ```

- other usage
  ```bash
  # get
  $ firewall-cmd --list-all
  $ firewall-cmd --get-default-zone
  $ firewall-cmd --get-active-zones
  $ sudo firewall-cmd --list-all-zones | less
  $ sudo firewall-cmd --zone=public --list-all
  $ sudo firewall-cmd --zone=public --list-services
  $ sudo firewall-cmd --zone=public --change-interface=eth0
  $ firewall-cmd --get-zones
  $ firewall-cmd --get-services
  $ sudo firewall-cmd --runtime-to-permanent

  # add
  $ sudo firewall-cmd --zone=public --add-service=http
  $ sudo firewall-cmd --zone=public --add-service=http --permanent
  $ sudo firewall-cmd --zone=public --add-port 8080/tcp --permanent

  # remove
  $ sudo firewall-cmd --zone=public --permanent --remove-port 2376/tcp
  $ sudo firewall-cmd --reload
  ```

  - add ip range

    > [!NOTE|label:references:]
    > - [How to open port for a specific IP address with firewall-cmd on CentOS? [duplicate]](https://serverfault.com/a/684603/129815)
    > - [How to open port for a specific IP address with firewall-cmd on CentOS? [duplicate]](https://serverfault.com/a/684739/129815)
    > - [open all ports to specific IP with firewalld](https://serverfault.com/a/890421/129815)

    ```bash
    # all ports for ip range
    $ sudo firewall-cmd --zone=trusted --add-source=64.39.96.0/20

    # limited ports for ip range
    $ firewall-cmd --new-zone=special --permanent
    $ firewall-cmd --reload
    $ firewall-cmd --zone=special --add-source=192.0.2.4/32
    $ firewall-cmd --zone=special --add-port=4567/tcp

    # or rich rule
    $ firewall-cmd --permanent --zone=public --add-rich-rule='
        rule family="ipv4"
        source address="1.2.3.4/32"
        port protocol="tcp" port="4567" accept'
    ```

- possibly impacted
  ```bash
  $ echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
  $ sudo sysctl -w net.ipv4.conf.all.route_localnet=1
  ```
