<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get into](#get-into)
  - [get IP address by hostname](#get-ip-address-by-hostname)
  - [get active interface](#get-active-interface)
  - [get active IP address](#get-active-ip-address)
  - [get active Mac address](#get-active-mac-address)
  - [check remote server dns](#check-remote-server-dns)
- [nmap](#nmap)
  - [Host Discovery](#host-discovery)
  - [scan `80` or `22` in particular setment](#scan-80-or-22-in-particular-setment)
  - [OS detection with verbosity](#os-detection-with-verbosity)
  - [find printer](#find-printer)
  - [list hostname with mac address](#list-hostname-with-mac-address)
  - [get all server up ip address](#get-all-server-up-ip-address)
- [route](#route)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## get into

### get IP address by hostname
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
interface=$(netstat -nr | grep -E 'UG|UGSc' | grep -E '^0.0.0|default' | grep -E '[0-9.]{7,15}' | awk -F' ' '{print $NF}')

# or get the route to github
interface=$(ip route get $(nslookup github.com | grep Server | awk -F' ' '{print $NF}') | sed -rn 's|.*dev\s+(\S+)\s+src.*$|\1|p')
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


### [Host Discovery](https://nmap.org/book/man-host-discovery.html)

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
  Host: 192.168.1.1 ()	Status: Up
  Host: 192.168.1.1 ()	Ports: 515/closed/tcp//printer///, 631/closed/tcp//ipp///, 9100/closed/tcp//jetdirect///
  Host: 192.168.1.13 ()	Status: Up
  Host: 192.168.1.13 ()	Ports: 515/open/tcp//printer///, 631/open/tcp//ipp///, 9100/open/tcp//jetdirect///
  Host: 192.168.1.1 ()	Status: Up
  Host: 192.168.1.1 ()	Ports: 515/closed/tcp//printer///, 631/closed/tcp//ipp///, 9100/closed/tcp//jetdirect///
  Host: 192.168.1.254 ()	Status: Up
  Host: 192.168.1.254 ()	Ports: 515/filtered/tcp//printer///, 631/filtered/tcp//ipp///, 9100/filtered/tcp//jetdirect///
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

## route
