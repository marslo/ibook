<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [system info](#system-info)
  - [hardware](#hardware)
  - [cpu](#cpu)
  - [memory](#memory)
  - [network](#network)
  - [environment variables](#environment-variables)
- [set system info](#set-system-info)
  - [clear duplicated PATH](#clear-duplicated-path)
  - [set dns for ubuntu](#set-dns-for-ubuntu)
  - [disable firewall](#disable-firewall)
  - [change net.bridge](#change-netbridge)
  - [off swap](#off-swap)
  - [disable selinux](#disable-selinux)
  - [confined and unconfined users](#confined-and-unconfined-users)
- [process](#process)
  - [find the zombie process](#find-the-zombie-process)
  - [about `whatis`](#about-whatis)
- [user management](#user-management)
  - [sssd to use LDAP](#sssd-to-use-ldap)
  - [local user](#local-user)
  - [local group](#local-group)
  - [logout](#logout)
  - [others](#others)
- [system encoding](#system-encoding)
  - [setup via environment](#setup-via-environment)
  - [setup via `locale` command](#setup-via-locale-command)
- [applications](#applications)
- [Q&A](#qa)
  - [yum issue after python upgrade to 3.x](#yum-issue-after-python-upgrade-to-3x)
  - [ls: Argument list too long](#ls-argument-list-too-long)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> drop caches
> ```bash
> $ sudo bash -c "echo 3 > /proc/sys/vm/drop_caches"
> ```
{% endhint %}

## system info

### hardware
```bash
$ sudo dmidecode -s
```

#### system information
```bash
$ sudo dmidecode | grep -A3 '^System Information'
    System Information
            Manufacturer: HPE
            Product Name: ProLiant DL380 Gen10
        Version: Not Specified
# or
$ inxi -M
    Machine:   Type: Server Mobo: HPE model: ProLiant DL380 Gen10 serial: <root required> UEFI: HPE v: U30
               date: 06/15/2018
# or
$ sudo inxi --dmidecode -Mxxx
    Machine:   Type: Rack Mount Chassis Mobo: HPE model: ProLiant DL380 Gen10 serial: PFARA%%LMAZ6XB BIOS: HPE
           v: U30 rev: 1.40 date: 06/15/2018 rom size: 16384 kB
```

#### manufacturer
```bash
$ sudo dmidecode -s system-manufacturer
    HPE

# or
$ sudo dmidecode -s baseboard-manufacturer
HPE

# or
$ cat /sys/devices/virtual/dmi/id/sys_vendor
HPE
```

#### product name and version

#### product name only
```bash
$ sudo dmidecode -s system-product-name
    ProLiant DL380 Gen10

# or
$ sudo dmidecode -s baseboard-product-name
ProLiant DL380 Gen10

# or
$ cat /sys/devices/virtual/dmi/id/product_name
ProLiant DL380 Gen10

# or
$ sudo dmidecode | grep -i prod
        Product Name: Vostro 5560
        Product Name: 04YDT0
```

#### uuid
```bash
$ sudo dmidecode | grep -i uuid | awk '{print $2}' | tr '[:upper:]' '[:lower:]'
```

### cpu

#### [cpu cores](https://www.ryadel.com/en/cpu-cores-threads-number-linux-centos-virtual-machine/)
```bash
$ cat /proc/cpuinfo | egrep "core id|physical id" | tr -d "\n" | sed s/physical/\\nphysical/g | grep -v ^$ | sort | uniq | wc -l
36
```

#### check CPU support 64 bit or not
```bash
$ sudo dmidecode --type=processor | grep -i -A 1 charac
    Characteristics:
            64-bit capable
```

#### cat /etc/cpuinfo
```bash
$ lscpu
Architecture:          i686
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                4
On-line CPU(s) list:   0-3
....
```

### memory
#### print memory only
```bash
$ ps -o comm,%mem,args -u marslo | more
COMMAND         %MEM COMMAND
gnome-keyring-d  0.0 /usr/bin/gnome-keyring-daemon --daemonize --login
init             0.0 init --user
ssh-agent        0.0 ssh-agent
dbus-daemon      0.0 dbus-daemon --fork --session --address=unix:abstract=/tmp/dbus-i5FUVjzADG
upstart-event-b  0.0 upstart-event-bridge
window-stack-br  0.0 /usr/lib/i386-linux-gnu/hud/window-stack-bridge
upstart-dbus-br  0.0 upstart-dbus-bridge --daemon --session --user --bus-name session
upstart-dbus-br  0.0 upstart-dbus-bridge --daemon --system --user --bus-name system
upstart-file-br  0.0 upstart-file-bridge --daemon --user
ibus-daemon      0.1 /usr/bin/ibus-daemon --daemonize --xim
....
```

### network
#### network speed
```bash
$ ifstat -n -i en7
       en7
 KB/s in  KB/s out
    7.35      1.15
    4.91      1.02
    6.05      0.80
    8.36      1.78
```

#### get the public ip address
```bash
$ curl ifconfig.me
```

### environment variables
#### show PATH
```bash
$ echo src::${PATH} | awk 'BEGIN{pwd=ENVIRON["PWD"];RS=":";FS="\n"}!$1{$1=pwd}$1!~/^\//{$1=pwd"/"$1}{print $1}'
/home/marslo/src
/home/marslo
/home/marslo/.vim/tools/bin
/usr/local/mysql/bin
/usr/local/bcompare/bin
/usr/lib/lightdm/lightdm
/usr/local/sbin
/usr/local/bin
/usr/sbin
/usr/bin
/sbin
/bin
/usr/games
/usr/local/games
OR
$ echo "${PATH//:/$'\n'}"
```

## set system info
### clear duplicated PATH
```bash
$ export PATH=`echo -n $PATH | awk -v RS=":" '{ if (!x[$0]++) {printf s $0; s=":"} }'`
```

### [set dns for ubuntu](http://askubuntu.com/questions/130452/how-do-i-add-a-dns-server-via-resolv-conf)
```bash
$ cat /etc/resolv.conf
# Dynamic resolv.conf(5) file for glibc resolver(3) generated by resolvconf(8)
# DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 127.0.1.1

$ cat /etc/resolvconf/resolv.conf.d/head
# Dynamic resolv.conf(5) file for glibc resolver(3) generated by resolvconf(8)
# DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN
nameserver 8.8.8.8
nameserver 8.8.4.4
$ sudo resolvconf -u

# or
$ cat /etc/dhcp/dhclient.conf | grep "prepend domain-name-servers"
prepend domain-name-servers 8.8.8.8, 8.8.4.4;

# or
$ cat /etc/network/interfaces | grep dns
    dns-nameservers 8.8.8.8 8.8.4.4
```

### disable firewall
```bash
$ sudo systemctl stop firewalld
$ sudo systemctl disable firewalld
$ sudo systemctl mask firewalld
```

- check result
  ```bash
  $ sudo systemctl is-enabled firewalld
  $ sudo systemctl is-active firewalld
  $ sudo firewall-cmd --state
  ```

### change net.bridge
```bash
$ sudo modprobe br_netfilter
$ sudo sysctl net.bridge.bridge-nf-call-iptables=1
$ sudo sysctl net.bridge.bridge-nf-call-ip6tables=1

# or
$ sudo bash -c "cat >  /etc/sysctl.d/k8s.conf" << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
```

- check status
  ```bash
  $ sudo sysctl --system
  ```

### off swap
```bash
$ sudo swapoff -a
$ sudo bash -c "/usr/bin/sed -e 's:^\\(.*swap.*\\)$:# \\1:' -i /etc/fstab"
```

### disable selinux
```bash
$ setenforce 0
$ sudo bash -c "/usr/bin/sed 's/^SELINUX=enforcing$/SELINUX=permissive/' -i /etc/selinux/config"
```

### [confined and unconfined users](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/sect-security-enhanced_linux-targeted_policy-confined_and_unconfined_users)

{% hint style='tip' %}
> references:
> - [SELinux笔记](https://my.oschina.net/u/589241/blog/2050011)
> - [SELinux/Users and logins](https://wiki.gentoo.org/wiki/SELinux/Users_and_logins)
{% endhint %}

- installation
  ```bash
  $ yum -y install setools-console
  ```

- setup for exiting account
  ```bash
  $ semanage login -a -s staff_u <account>

  # or
  $ semanage login -a -s staff_u -r s0-s0:c0.c100 <account>
  ```

- Modifying an existing mapping
  ```bash
  $ semanage login -m -s sysadm_u <account>
  ```

- delete a mapping
  ```bash
  $ semanage login -d <account>
  ```

- list mappings
  ```bash
  $ semanage user -l
  ```

## process

### find the zombie process
```bash
$ ps aux | awk '{ print $8 " " $2 " " $11}' | grep -w Z
```

#### sort process by PID
```bash
$ ps -axww
```

#### check the group PID
```bash
$ ps -xj
```

### about `whatis`
```bash
$ whatis whois
whois (1)            - client for the whois directory service
$ whatis which
which (1)            - locate a command
$ whatis whereis
whereis (1)          - locate the binary, source, and manual page files for a command
```

## user management

### [sssd to use LDAP](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_authentication_and_authorization_in_rhel/configuring-sssd-to-use-ldap-and-require-tls-authentication_configuring-authentication-and-authorization-in-rhel)

{% hint style='tip' %}
> references:
> - [understanding sssd and its benefits](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_authentication_and_authorization_in_rhel/understanding-sssd-and-its-benefits_configuring-authentication-and-authorization-in-rhel)
> - [additional configuration for identity and authentication providers](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_authentication_and_authorization_in_rhel/assembly_additional-configuration-for-identity-and-authentication-providers_configuring-authentication-and-authorization-in-rhel#proc_adjusting-how-sssd-interprets-full-user-names_assembly_additional-configuration-for-identity-and-authentication-providers)
> - [sssd client-side view](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_authentication_and_authorization_in_rhel/assembly_sssd-client-side-view_configuring-authentication-and-authorization-in-rhel)
> - [Configuring an LDAP Client to use SSSD](https://docs.oracle.com/cd/E37670_01/E41138/html/ol_sssd_ldap.html)
> - [`/etc/sssd/sssd.conf` sample](https://github.com/marslo/iDevOps/blob/master/centos/sssd/sssd.conf)
> - [Troubleshooting SSSD](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system-level_authentication_guide/trouble)
> - [Linux user authentication with SSSD / LDAP](https://aws.nz/best-practice/sssd-ldap/)
{% endhint %}

#### add user name
```bash
$ sss_override user-add username -n secondary-username

# verification
$ id secondary-username
# display the override
$ sss_override user-show user-name
```

#### override the uid
```bash
# check current uid
$ id -u username

# overwride
$ sss_override user-add <username> -u <new-uid>
$ sss_cache --users
# or
$ sss_cache --user <username>
$ systemctl restart sssd
```

#### override the gid
```bash
# check current gid
$ id -g username

# override
$ sss_override user-add <username> -g <new-gid>
$ sss_cache --users
$ sss_cache --user <username>
$ systemctl restart sssd
```

#### override the home directory
```bash
# check current home directory
$ getent passwd username

# override
$ sss_override user-add username -h /new/home/directory
$ systemctl restart sssd
```

#### override the shell attribute
```bash
# check current
$ getent passwd username

# override
$ sss_override user-add username -s /new/shell
$ systemctl restart sssd
```

#### [managing the sssd cache](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sssd-cache#sssd-cache-purge)
```bash
# clear the cache and update all records
$ sudo sss_cache [-E|--everything]

# clear invalidates cache entries for all user records
$ sudo sss_cache [-U|--users]

# clear all cached entries for a particular domain
$ sudo sss_cache [-E|--everything] [-d|--domain] <ldap_name>

# purge the records for that specific account and leave the rest of the cache intact
$ sudo sss_cache [-u|--user] <username>

# invalidates the cache entry for the specified group
$ sudo sss_cache [-g|--group] <groupname>
```

#### backup and restore
```bash
# export
$ sss_override user-export user-export.bak
$ sss_override group-export group-export.bak

# restore
$ sss_override user-import user-import.bak
$ sss_override group-import group-import.bak
```

#### list all override
```bash
$ sss_override user-find
```
#### [create sssd config](https://serverfault.com/a/749305/129815)

{% hint style='tip' %}
After this in `/etc/sssd/sssd.conf` file
Specify `ldap_default_bind_dn` and `ldap_default_authtok` as default bind dn and password respectively, this depends upon your ldap setup.
{% endhint %}

```bash
$ authconfig --enablesssd \
             --enablesssdauth \
             --enablelocauthorize \
             --enableldap \
             --enableldapauth \
             --ldapserver=ldap://ipaserver.example.com:389 \
             --disableldaptls \
             --ldapbasedn=dc=example,dc=com \
             --enablerfc2307bis \
             --enablemkhomedir \
             --enablecachecreds \
             --update
```

### local user

{% hint style='tip' %}
> references:
> - [how to list users and groups on linux](https://devconnected.com/how-to-list-users-and-groups-on-linux/)
> - [How to Create Groups in Linux (groupadd Command)](https://linuxize.com/post/how-to-create-groups-in-linux/)
> - [understanding /etc/shadow file format on linux](https://www.cyberciti.biz/faq/understanding-etcshadow-file/)
> - [understanding the /etc/shadow file](https://linuxize.com/post/etc-shadow-file/)
> - [linux: instructions on using commands about user and group on linux](https://techbast.com/2019/06/linux-instructions-on-using-commands-about-user-and-group-on-linux.html)
{% endhint %}

{% hint style='tip' %}
> find users
> - `/etc/passwd`
> - `/etc/shadow`
> - `/etc/pam.d/passwd`
> more on users
> - [`/etc/login.defs`](https://www.2daygeek.com/understanding-linux-etc-shadow-file-format/)
{% endhint %}

#### `useradd`

{% hint style='tip' %}
> create user `devops`
{% endhint %}

```bash
$ useradd -c "comments here" \
          -m \
          -d "/home/devops" \
          -u 1000 \
          -g 1000 \
          -s /bin/bash \
          devops
```
- or
  ```bash
  $ useradd --comment "comments here" \
            --create-home \
            --home-dir /home/devops \
            --shell /bin/bash \
            --uid 1000 \
            --gid 1000 \
            --user-group devops
            devops
  ```

- full steps
  ```bash
  $ uid='1000'
  $ gid='1000'
  $ user='devops'

  $ mkdir -p /home/${user}
  $ chown -R ${uid}:${gid} /home/${user}
  $ groupadd -g ${gid} ${user}
  $ useradd -c "create user ${user}" \
            -d "/home/${user}" \
            -u ${uid} \
            -g ${gid} \
            -m \
            -s /bin/bash \
            ${user}
  ```

#### [`deluser`](http://manpages.ubuntu.com/manpages/trusty/man8/deluser.8.html) for ubunut
{% hint style='tip' %}
`deluser`, `delgroup` - remove a user or group from the system
> **SYNOPSIS**
> - deluser  [options]  [--force] [--remove-home] [--remove-all-files] [--backup] [--backup-to DIR] user
> - deluser --group [options] group
> - delgroup [options] [--only-if-empty] group
> - deluser [options] user group
{% endhint %}

```bash
$ deluser <account> <group>
```

### local group

- `/etc/group`
  ![list group in linux](../screenshot/linux/etc-group-file.png)

- `/etc/passwd`
  ![list user in linux](../screenshot/linux/list-users-linux.png)

- `/etc/shadow`
  ![list user in /etc/shadow](../screenshot/linux/etc-shadow-1.jpeg)

{% hint style='tip' %}
> references:
> - [Linux groupadd command](https://www.computerhope.com/unix/groupadd.htm)
{% endhint %}

#### [list all groups](https://www.howtogeek.com/50787/add-a-user-to-a-group-or-second-group-on-linux/)
```bash
$ getent group
```

#### create group with random gid
```bash
$ sudo groupadd <group_name>
```

- get available gid

  {% hint style='tip' %}
  > for error:
  > ```bash
  > groupadd: GID 'xxxx' already exists
  > ```
  {% endhint %}

  ```bash
  $ gname='mytestgroup'
  $ sudo groupadd ${gname}

  $ getent group ${gname} | cut -d: -f3
  # or
  $ sed -nr "s/^${gname}:x:([0-9]+):.*/\1/p" /etc/group
  # or
  $ grep "^${gname}" /etc/group|cut -d: -f3

  # and finally remove the group
  $ sudo groupdel ${gname}
  ```

#### create group with particular gid
```bash
$ sudo groupadd -g <gid> <group_name>
```

#### create group with existing gid

{% hint style='tip' %}
```bash
-o (--non-unique) option the groupadd command allows you to create a group with non-unique GID
```
{% endhint %}

```bash
$ sudo groupadd -o -g <new_gid> <group_name>
```

#### modify gid
```bash
$ sudo groupmod -g <gid> <group_name>
```

#### add user into group
```bash
$ usermod -a -G adm,root,sudo,docker devops
```

#### remove user from group

{% hint style='tip' %}
> - [How to Add or Remove a User from a Group in Linux](https://www.tecmint.com/add-or-remove-user-from-group-in-linux/)
{% endhint %}

```bash
$ gpasswd -d <account> <group>
```

### logout
```bash
$ pkill -KILL -u ${useranme}
```
- or
  ```bash
  $ who -uH
  NAME     LINE         TIME             IDLE          PID COMMENT
  devops   pts/0        2022-06-14 05:44 00:17       41455 (192.168.1.1)
  marslo   pts/1        2022-06-14 05:58   .         50162 (192.168.1.1)
  $ sudo kill  41455
  $ who -uH
  NAME     LINE         TIME             IDLE          PID COMMENT
  marslo   pts/1        2022-06-14 05:58   .         50162 (192.168.1.1)
  ```

### others

#### [view users password properties in linux](https://www.2daygeek.com/understanding-linux-etc-shadow-file-format/)
```bash
$ chage -l marslo
Last password change      : Mar 09, 2022
Password expires          : never
Password inactive         : never
Account expires           : never
Minimum number of days between password change    : 0
Maximum number of days between password change    : 99999
Number of days of warning before password expires : 7
```

#### [hash_algorithm](https://www.2daygeek.com/understanding-linux-etc-shadow-file-format/)

| Code | Algorithm             |
|:----:|-----------------------|
| `$1` | MD5 hashing algorithm |
| `$2` | Blowfish Algorithm    |
| `$3` | Eksblowfish Algorithm |
| `$4` | NT hashing algorithm  |
| `$5` | SHA-256 Algorithm     |
| `$6` | SHA-512 Algorithm     |

## system encoding
{% hint style='tip' %}
> references:
> - [How to Change or Set System Locales in Linux](https://www.tecmint.com/set-system-locales-in-linux/)
>   - `/etc/default/locale` – on Ubuntu/Debian
>   - `/etc/locale.conf` – on CentOS/RHEL
> - [Unicode characters in console logs do not print correctly in Workflow builds](https://issues.jenkins.io/browse/JENKINS-31096?page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel&showAll=true)
> - [Locale](https://help.ubuntu.com/community/Locale)
> - [How to set up a clean UTF-8 environment in Linux](https://perlgeek.de/en/article/set-up-a-clean-utf8-environment)
>
>
> important files:
> - `/etc/default/locale`
> - `/etc/locale.gen`
> - `/etc/environment`
> - `/usr/share/locales`
> - `/var/lib/locales/supported.d/local`
> - `/usr/local/share/i18n/SUPPORTED`
> - `/usr/share/i18n/SUPPORTED`

{% endhint %}

### setup via environment
```bash
$ sudo bash -c 'cat >> /etc/bash.bashrc' << EOF
export LANG=en_US.UTF-8
export LANGUAGE=$LANG
export LC_COLLATE=$LANG
export LC_CTYPE=$LANG
export LC_MESSAGES=$LANG
export LC_MONETARY=$LANG
export LC_NUMERIC=$LANG
export LC_TIME=$LANG
export LC_ALL=$LANG
EOF

$ source /etc/bash.bashrc
```

### setup via `locale` command
```bash
$ apt-get install -y locales

$ sudo locale-gen en_US.UTF-8
$ sudo update-locale LANG=en_US.UTF-8
$ source /etc/default/locale

# or
$ sudo dpkg-reconfigure locales

# or
$ sudo localectl set-locale LANG=en_US.UTF-8,LC_ALL=en_US.UTF-8
```
- setup environment files
  ```bash
  $ sudo bash -c 'cat >> /etc/environment' << EOF
  LANG="en_US.UTF-8"
  LANGUAGE="en_US:en:en_US:en"
  EOF
  ```

## applications
#### sogou Pinyin input method
```bash
$ sudo add-apt-repository ppa:fcitx-team/nightly
$ sudo apt-get update
$ sudo apt-get install fcitx-sogoupinyin
$ # sudo apt-get remove ibus
```

#### specified terminal size
```bash
$ gnome-terminal --geometry=123x42+0+0
```

## Q&A
### yum issue after python upgrade to 3.x
> references:
> - [CentOS 7升级Python到3.6.6后yum出错问题解决总结](https://www.cnblogs.com/kerrycode/p/11553470.html)
> - [yum upgrading error](https://www.linuxquestions.org/questions/linux-newbie-8/yum-upgrading-error-4175632414/#post6071710)

- issue
  ```bash
  SyntaxError: invalid syntax
    File "/usr/libexec/urlgrabber-ext-down", line 28
      except OSError, e:
                    ^
  ```

- solution
  ```bash
  $ sed -r '1s/^(.*python)$/\12/g' -i /usr/libexec/urlgrabber-ext-down
  ```

  - or change shebang from `#! /usr/bin/python` to `#! /usr/bin/python2`
    ```bash
    $ vim /usr/libexec/urlgrabber-ext-down
    ... change '#! /usr/bin/python' to  '#! /usr/bin/python2'
    ```

### ls: Argument list too long

{% hint style='tip' %}
> references:
> - [Argument list too long for ls](https://unix.stackexchange.com/a/38962/29178)
> - [setup ulimit](https://unix.stackexchange.com/a/45584/29178)
> - [How to avoid the limit in a shell](https://www.in-ulm.de/~mascheck/various/argmax/#avoid)
{% endhint %}

#### check the limit
```bash
$ getconf ARG_MAX
```

#### setup `ulimit`
```bash
$ ulimit -s
8192

$ ulimit -s 65536
$ ulimit -s
65536
```
