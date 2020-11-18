<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get into](#get-into)
  - [get IP address by hostname](#get-ip-address-by-hostname)
  - [get current IP address](#get-current-ip-address)
  - [get Mac address](#get-mac-address)
  - [check remote server dns](#check-remote-server-dns)
- [scan](#scan)
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

### get current IP address
```bash
$ githubIP=$(dig +short github.com | head -1)

$ interface=$(ip route get ${githubIP} | sed -rn 's|.*dev\s+(\S+)\s+src.*$|\1|p')
$ ipaddr=$(ip a s ${interface} | sed -rn 's|\W*inet[^6]([0-9\.]{7,15}).*$|\1|p')
```

### get Mac address
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

## scan

- scan `80` or `22` in particular setment
    ```bash
    $ nmap -sT -p 80 -oG - 10 - 1.2.3.* [| grep open]
    $ nmap -sT -p 22 -oG - 10 - 1.2.3.* [| grep open]
    ```

### route
