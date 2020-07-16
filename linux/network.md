<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get into](#get-into)
  - [get IP address](#get-ip-address)
  - [get Mac address](#get-mac-address)

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
$ ipaddr=$(ip a s ${interface} | sed -rn 's|.*inet ([0-9\.]{11}).*$|\1|p')
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

## scan

- scan `80` or `22` in particular setment
    ```bash
    $ nmap -sT -p 80 -oG - 10 - 1.2.3.* [| grep open]
    $ nmap -sT -p 22 -oG - 10 - 1.2.3.* [| grep open]
    ```

### route
