<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [ssh key](#ssh-key)
  - [generate ssh key](#generate-ssh-key)
  - [get servers public key](#get-servers-public-key)
  - [add ssh key into agent](#add-ssh-key-into-agent)
  - [get public key from private key](#get-public-key-from-private-key)
  - [verify public and private key pair](#verify-public-and-private-key-pair)
  - [generate new passphrase](#generate-new-passphrase)
  - [get fingerprinter](#get-fingerprinter)
  - [with openssl](#with-openssl)
  - [keys performance](#keys-performance)
- [ssh](#ssh)
  - [force use password](#force-use-password)
  - [ssh and tar](#ssh-and-tar)
    - [copy multiple files to remote server](#copy-multiple-files-to-remote-server)
    - [`find` && `tar`](#find--tar)
    - [tar all and extra in remote](#tar-all-and-extra-in-remote)
  - [with proxy](#with-proxy)
    - [using command directly](#using-command-directly)
- [ssh certificate](#ssh-certificate)
  - [SSH User Certificates](#ssh-user-certificates)
    - [ca](#ca)
    - [sign and generate cert key](#sign-and-generate-cert-key)
    - [update for existing key](#update-for-existing-key)
    - [login via specific cert](#login-via-specific-cert)
  - [SSH Host Certificates](#ssh-host-certificates)
- [ssh tunnel](#ssh-tunnel)
  - [two servers](#two-servers)
    - [`-L`](#-l)
    - [`-R`](#-r)
  - [three serves](#three-serves)
    - [scenario 1](#scenario-1)
    - [scenario 2](#scenario-2)
- [config](#config)
  - [ssh config](#ssh-config)
  - [sshd_config](#sshd_config)
    - [banner and motd](#banner-and-motd)
    - [disable login password](#disable-login-password)
    - [disallow group to use password](#disallow-group-to-use-password)
    - [disallowing user to use tcp forwarding](#disallowing-user-to-use-tcp-forwarding)
    - [displaying a special banner for users not in the staff group](#displaying-a-special-banner-for-users-not-in-the-staff-group)
    - [allowing root login from host rootallowed.example.com](#allowing-root-login-from-host-rootallowedexamplecom)
    - [allowing anyone to use gatewayports from the local net](#allowing-anyone-to-use-gatewayports-from-the-local-net)
- [debug](#debug)
  - [debug git](#debug-git)
  - [debug ssh](#debug-ssh)
    - [check sshd log](#check-sshd-log)
  - [tips](#tips)
    - [disconnect](#disconnect)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [SSH port forwarding - Example, command, server config](https://www.ssh.com/academy/ssh/tunneling/example)
> - [透过代理连接SSH](http://blog.csdn.net/asx20042005/article/details/7041294)
> - [SSH ProxyCommand example: Going through one host to reach another server](https://www.cyberciti.biz/faq/linux-unix-ssh-proxycommand-passing-through-one-host-gateway-server/)
> - [OpenSSH/Cookbook/Proxies and Jump Hosts](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts#ProxyCommand_with_Netcat)
> - [Tunneling SSH over PageKite](https://pagekite.net/wiki/Howto/SshOverPageKite/#wrongnetcat)
> - [Transparent Multi-hop SSH](http://sshmenu.sourceforge.net/articles/transparent-mulithop.html)
> - [SSH via HTTP proxy in OSX](http://www.perkin.org.uk/posts/ssh-via-http-proxy-in-osx.html)
> - [ssh key](https://wiki.archlinux.org/index.php/SSH_keys)
> - [6 ssh authentication methods to secure connection (sshd_config)](https://www.golinuxcloud.com/openssh-authentication-methods-sshd-config/)
> - [8 ways to prevent brute force SSH attacks in Linux (CentOS/RHEL 7)](https://www.golinuxcloud.com/prevent-brute-force-ssh-attacks-centos-linux/)
{% endhint %}

# ssh key
## [generate ssh key](https://gist.githubusercontent.com/risan/7c84941067171cef79944978f42b77c6/raw/4c14ef4d660ec84ba48af88c534b7a15439a643d/generate-ed25519-ssh-key.sh)
```bash
$ keyname='marslo@china'

# rsa4096
$ ssh-keygen -t rsa -b 4096 -f ~/.ssh/${keyname} -C "${keyname}" -P "" -q

# ed25519
$ ssh-keygen -t ed25519 -C "${keyname}" -f ~/.ssh/${keyname} -P '' -q
$ ssh-keygen -t ed25519 -o -a 100 -C "${keyname}" -f ~/.ssh/${keyname} -P '' -q
```

## get servers public key
```bash
$ ssh-keyscan -H www.server.com

# or
$ ssh-keyscan -p 29418 -t rsa www.server.com
$ ssh-keyscan -p 29418 -t rsa www.server.com >> ~/.ssh/known_hosts
```

- [upload the local ~/.ssh/know_hosts](https://github.com/orgs/community/discussions/27405#discussioncomment-5458902)

  > [!NOTE|label:references:]
  > - [We updated our RSA SSH host key](https://github.blog/2023-03-23-we-updated-our-rsa-ssh-host-key/)

  ```bash
  $ ssh-keygen -R github.com
  # Host github.com found: line 63
  /home/marslo/.ssh/known_hosts updated.
  Original contents retained as /home/marslo/.ssh/known_hosts.old

  # or
  $ curl -sL https://api.github.com/meta | jq -r '.ssh_keys | .[]'  | sed -e 's/^/github.com /' >> ~/.ssh/know_hosts

  # more details
  $ curl -sL https://api.github.com/meta | jq -r '.ssh_keys | .[]'
  ssh-ed25519 AAAA***9GKJl
  ecdsa-sha2-nistp256 AAAA***ockg=
  ssh-rsa AAAA***wsjk=
  $ curl -sL https://api.github.com/meta | jq -r '.ssh_keys | .[]'  | sed -e 's/^/github.com /'
  github.com ssh-ed25519 AAAA***9GKJl
  github.com ecdsa-sha2-nistp256 AAAA***ockg=
  github.com ssh-rsa AAAA***wsjk=
  ```

## add ssh key into agent
```bash
$ ssh-add ~/.ssh/${keyname}

# e.g.:
$ ssh-add ~/.ssh/id_ed25519
Identity added: /Users/marslo/.ssh/id_ed25519 (marslo@devops)

$ ssh-agent -s
SSH_AUTH_SOCK=/var/folders/s3/mg_f3cv54nn7y758j_t46zt40000gn/T//ssh-MgCrKA3ZS06N/agent.25376; export SSH_AUTH_SOCK;
SSH_AGENT_PID=25377; export SSH_AGENT_PID;
echo Agent pid 25377;
```

## get public key from private key
```bash
$ ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
```

## [verify public and private key pair](https://serverfault.com/a/426429/129815)
```bash
$ diff [-qs] <( ssh-keygen -y -e -f /path/to/private ) \
             <( ssh-keygen -y -e -f /path/to/public.pub )
```

## generate new passphrase
```bash
$ ssh-keygen -p -f /path/to/private
```

## get fingerprinter
* sha256:
  ```bash
  $ ssh-keygen -l -f ~/.ssh/id_rsa

  # or
  $ ssh-keygen -l -f ~/.ssh/id_rsa.pub
  ```

* md5:
  ```bash
  $ ssh-keygen -E md5 -l -f ~/.ssh/id_rsa

  # or
  $ ssh-keygen -E md5 -l -f ~/.ssh/id_rsa.pub
  ```

## with openssl
```bash
$ openssl pkey -in ~/.ssh/ec2/primary.pem -pubout -outform DER | openssl md5 -c
```

## keys performance
```bash
$ openssl speed rsa1024 rsa2048 dsa1024 dsa2048
Doing 1024 bit private rsa's for 10s: 91211 1024 bit private RSA's in 9.97s
Doing 1024 bit public rsa's for 10s: 1161461 1024 bit public RSA's in 9.93s
Doing 2048 bit private rsa's for 10s: 12305 2048 bit private RSA's in 9.94s
Doing 2048 bit public rsa's for 10s: 403455 2048 bit public RSA's in 9.98s
Doing 1024 bit sign dsa's for 10s: 84873 1024 bit DSA signs in 10.00s
Doing 1024 bit verify dsa's for 10s: 109544 1024 bit DSA verify in 9.99s
Doing 2048 bit sign dsa's for 10s: 30010 2048 bit DSA signs in 9.99s
Doing 2048 bit verify dsa's for 10s: 33202 2048 bit DSA verify in 9.98s
OpenSSL 1.0.2t  10 Sep 2019
built on: reproducible build, date unspecified
options:bn(64,64) rc4(ptr,int) des(idx,cisc,16,int) aes(partial) idea(int) blowfish(idx)
compiler: clang -I. -I.. -I../include  -fPIC -fno-common -DOPENSSL_PIC -DOPENSSL_THREADS -D_REENTRANT -DDSO_DLFCN -DHAVE_DLFCN_H -arch x86_64 -O3 -DL_ENDIAN -Wall -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT -DOPENSSL_BN_ASM_MONT5 -DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DMD5_ASM -DAES_ASM -DVPAES_ASM -DBSAES_ASM -DWHIRLPOOL_ASM -DGHASH_ASM -DECP_NISTZ256_ASM
                  sign    verify    sign/s verify/s
rsa 1024 bits 0.000109s 0.000009s   9148.5 116964.9
rsa 2048 bits 0.000808s 0.000025s   1237.9  40426.4
                  sign    verify    sign/s verify/s
dsa 1024 bits 0.000118s 0.000091s   8487.3  10965.4
dsa 2048 bits 0.000333s 0.000301s   3004.0   3326.9
```

# ssh
## force use password
```bash
$ ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no user@target.server
```

## [ssh and tar](https://superuser.com/a/116031/112396)
### [copy multiple files to remote server](https://superuser.com/a/116031/112396)
```bash
$ tar cvzf - -T list_of_filenames | ssh hostname tar xzf -
```

### `find` && `tar`
- backup all `config.xml` in JENKINS_HOME
  ```bash
  $ find ${JENKINS_HOME}/jobs \
         -maxdepth 2 \
         -name config\.xml \
         -type f -print |
    tar czf ~/config.xml.tar.gz --files-from -
  ```

- back build history
  ```bash
  $ find ${JENKINS_HOME}/jobs \
         -name builds \
         -prune -o \
         -type f \
         -print |
    tar czf ~/m.tar.gz --files-from -
  ```

### tar all and extra in remote
```bash
# ssh -C
#    no `-z`      `-C`
#       |           |
#       v           v
$ tar cf - . | ssh -C hostname "cd ~/.marslo/test/; tar xvf -"
Warning: Permanently added '10.69.78.40' (ECDSA) to the list of known hosts.
./
./temp/
./a/
./a/a.txt
./c/
./b/

# tar z-flag
#     `-z`       no `-C`
#       |          |
#       v          v
$ tar cfz - . | ssh hostname "cd ~/.marslo/test/; tar xvzf -"
```

## with proxy
### using command directly
* Linux:
  ```bash
  $ ssh -o 'ProxyCommand nc -x proxy.url.com proxy-port %h %p' -vT user@target.server

  # or
  $ ssh -o 'ProxyCommand corkscrew proxy.url.com proxy-port %h %p' -vT user@target.server
  ```

* windows:
  * git for windows
    ```bash
    $ ssh -o 'ProxyCommand connect -H http://proxy.url.com:proxy-port %h %p' user@target.server
    ```

  * cygwin
    ```bash
    $ apt-cyg install corkscrew
    $ ssh -o 'ProxyCommand corkscrew proxy.url.com proxy-port %h %p' user@target.server

    # or
    $ apt-cyg install nc
    $ ssh -o 'ProxyCommand nc -X connect -x proxy.url.com:proxy-port %h %p' -vT git@github.com
    ```

# ssh certificate

> [!NOTE|label:references:]
> - [* OpenSSH/Cookbook/Certificate-based Authentication](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Certificate-based_Authentication)
> - [* Configure ssh certificate based authentication](https://www.ezeelogin.com/kb/article/configure-ssh-certificate-based-authentication-298.html)
> - [14.3.3. Creating SSH CA Certificate Signing Keys](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sec-creating_ssh_ca_certificate_signing-keys)
>   - [Files Associated with SSH Host Certificates](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Certificate-based_Authentication#Files_Associated_with_SSH_Host_Certificates)
>     - Certificate Authority (ca) - a private key generated for signing other keys
>     - Certificate public key - the public component of the certificate authority
>     - Host Public Key - the actual key that the SSH daemon uses to identify itself to the clients
>     - Host Certificate - the signature made for the Host Public Key using the Certificate Authority
> - [How to Generate and Configure SSH Certificate-Based Authentication](https://goteleport.com/blog/how-to-configure-ssh-certificate-based-authentication/)
> - [If you’re not using SSH certificates you’re doing SSH wrong](https://smallstep.com/blog/use-ssh-certificates/)
> - [How to configure and setup SSH certificates for SSH authentication](https://dev.to/gvelrajan/how-to-configure-and-setup-ssh-certificates-for-ssh-authentication-b52)
> - [How To Configure SSH Key-Based Authentication on a Linux Server](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server)
> - [Tightening SSH access using short-lived SSH certificates](https://www.bastionxp.com/blog/tightening-ssh-access-using-short-lived-ssh-certificates/)
> - [How to setup SSH certificates for SSH authentication](https://ganeshvelrajan.medium.com/how-to-setup-ssh-certificates-for-ssh-authentication-3fb3a56d8607)


## [SSH User Certificates](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Certificate-based_Authentication#SSH_User_Certificates)
### ca
```bash
remote $ ssh-keygen -t ed25519 -b 4096 -f devops@ca -C 'devops@ca' -P '' -q
remote $ sudo cp devops@ca* /etc/ssh/
remote $ echo 'TrustedUserCAKeys /etc/ssh/devops@ca.pub' | sudo tee -a /etc/ssh/sshd_config

remote $ sudo grep TrustedUserCAKeys /etc/ssh/sshd_config
TrustedUserCAKeys /etc/ssh/devops@ca.pub
```

### sign and generate cert key
```bash
# download devops@ca
#                                 key id  principals
#                                    v        v
local $ ssh-keygen -s devops@ca -I marslo -n marslo -V +52w ~/.ssh/marslo.pub
$ ls ~/.ssh/marslo*
/Users/marslo/.ssh/marslo  /Users/marslo/.ssh/marslo-cert.pub  /Users/marslo/.ssh/marslo.pub
```

- verify
  ```bash
  $ ssh-keygen -Lf ~/.ssh/marslo-cert.pub
  /Users/marslo/.ssh/marslo-cert.pub:
          Type: ssh-ed25519-cert-v01@openssh.com user certificate
          Public key: ED25519-CERT SHA256:JfJnCDxjWhLwW3BcBX3XycBr3dT3JtHTwD1M4H3828E
          Signing CA: ED25519 SHA256:5dNlpIIjX/pdoNSpmtfcGQijSrl3W87TByA9KeCe2M0 (using ssh-ed25519)
          Key ID: "marslo"
          Serial: 0
          Valid: from 2023-08-17T17:41:00 to 2024-08-15T17:42:52
          Principals:
                  marslo
          Critical Options: (none)
          Extensions:
                  permit-X11-forwarding
                  permit-agent-forwarding
                  permit-port-forwarding
                  permit-pty
                  permit-user-rc

  $ ssh -i ~/.ssh/marslo marslo@remote "cat /home/marslo/.ssh/authorized_keys; du -hs /home/marslo/.ssh/authorized_keys; hostname"
  0 /home/marslo/.ssh/authorized_keys
  remote
  ```

### update for existing key
```bash
#                                       serial
#                                         v
$ ssh-keygen -s devops@ca -I 'edcba' -z '0002' -n marslo marslo.pub
Signed user key marslo-cert.pub: id "edcba" serial 2 for marslo valid forever

# verify
$ ssh-keygen -f marslo-cert.pub -L
marslo-cert.pub:
        Type: ssh-ed25519-cert-v01@openssh.com user certificate
        Public key: ED25519-CERT SHA256:JfJnCDxjWhLwW3BcBX3XycBr3dT3JtHTwD1M4H3828E
        Signing CA: ED25519 SHA256:5dNlpIIjX/pdoNSpmtfcGQijSrl3W87TByA9KeCe2M0 (using ssh-ed25519)
        Key ID: "edcba"
        Serial: 2
        Valid: forever
        Principals:
                marslo
        Critical Options: (none)
        Extensions:
                permit-X11-forwarding
                permit-agent-forwarding
                permit-port-forwarding
                permit-pty
                permit-user-rc
```

### login via specific cert

> [!NOTE|label:references:]
> - [OpenSSH/Cookbook/Certificate-based Authentication](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Certificate-based_Authentication)
>   ```bash
>   $ ssh -o CertificateFile=server01.ed25519-cert.pub -i server01.ed25519 \
>           fred@server01.example.org
>   ```

```bash
$ ssh marslo@sample.server.com
marslo@sample.server.com's password:

$ ssh -o CertificateFile=marslo-cert.pub marslo@sample.server.com "du -hs ~/.ssh/authorized_keys"
0 /home/marslo/.ssh/authorized_keys

# via config
$ cat ~/.ssh/confg
Host example sample.server.com
     Hostname sample.server.com
     User marslo
     IdentitiesOnly yes
     IdentityFile /home/marslo/.ssh/marslo
     CertificateFile /home/marslo/.ssh/marslo-cert.pub
```

## [SSH Host Certificates](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Certificate-based_Authentication#SSH_Host_Certificates)

# ssh tunnel

{% hint style='tip' %}
> references:
> - [ssh端口转发(跳板机)实战详解](https://zhuanlan.zhihu.com/p/469638489)
> - [SSH 通过跳板机直接访问内网机器](https://zhuanlan.zhihu.com/p/74193910)
{% endhint %}

> [!TIP]
> - key point:
>   - `-L` : `<--`
>   - `-R` : `-->`
>
> - basic command line
>   ```bash
>   $ ssh -Nf -L <localhost/localip>:<local_port>:<target>:<target_port> <to-be-mapping/localhost>
>   ```
> - usage:
>   - `1 -> [2 ->] 3` : `ssh host2:port2:host3:port3 host1:port1`
>   - if ignore `host2`. default using local.host

## two servers

### `-L`

{% hint style='tip' %}
<h4>in jumper</h4>
{% endhint %}

> [!TIP]
> - purpose:
>   ```bash
>   local:22 --> jumper:6666
>   ```

```bash
# -L : <--
$ ssh user@jumper.server
$ ssh -Nf -L [jumper.server:]6666:my.server:22 root@my.server

# verify
$ sudo netstat -an | grep 6666
tcp 0 0 jumper.ip:6666 0.0.0.0:* LISTEN
tcp 0 0 127.0.0.1:6666 0.0.0.0:* LISTEN
tcp 0 0 ::1:6666 :::* LISTEN
```

### `-R`

> [!TIP]
> - status:
>   ```bash
>                  current status
>                       |
>                       v
>          mymac:22 <--------- jumper:22
>
>    purpose:  |                  ^
>              + ---------------> +
>   ```

```bash
# login to jumper first via GUI
                         destination
                             |
                             v
<jumper> $ ssh -Nf -R 6666:<mymac>:22 marslo@<mymac>
<jumper> $ ps auxfww | grep ssh | grep -v grep
marslo    2281  0.0  0.0  11716  4064 ?        Ss   19:55   0:00      \_ ssh -Nf -R 6666:<my.pc.ip>:22 marslo@<my.pc.ip>
<jumper> $ sudo netstat -anp | grep ssh
tcp        0      0 <jumper>:46176    <mymac>:22        ESTABLISHED 2281/ssh

# verify in <mymac>
<mymac> $ netstat -an | grep 6666
tcp4       0      0  127.0.0.1.6666         *.*                    LISTEN
tcp6       0      0  ::1.6666               *.*                    LISTEN

<mymac> $ ssh -p 7777 localhost
## or
<mymac> $ cat ~/.ssh/config
Host  jumper
      Hostname              localhost
      Port                  7777
<mymac> $ ssh jumper
```

## three serves

### scenario 1
{% hint style='tip' %}
<h4>in jumper</h4>
> - purpose:
>   ```bash
>   local:6666 <--- jumper:6666 <--- remote:6666
>   ```
{% endhint %}

```bash
# -R : -->
$ ssh user@jumper
$ ssh -Nf -R [jumper:]6666:local:6666 root@remote

# verify
## in remote
$ ssh root@remote
$ scp -P 6666 root@localhost:/remote/path/file /local/path
## in local
$ scp -P 6666 /local/path/file root@localhost:/remote/path/file

$ ssh user@jumper
<jumper> $ ps awwx | grep ssh | grep 6666
17549 ? Ss 0:00 ssh -Nf -L 6666:remote:22 root@remote
18740 ? Ss 3:50 ssh -Nf -R 6666:local:6666 root@remote
```

### scenario 2

> [!TIP]
> - details :
>   ```bash
>                       current status
>                       --------------
>                      |              |
>
>             mymac  <----  jumper  ----> destination
>
>               |                             ^
>   wants:      v                             |
>                -------------->--------------
>                      visit directly
>   ```

```bash
# login to jumper
<jumper> $ ssh -Nf -R7777:<destination>:22 marslo@<mymac>
<jumper> $ ps auxfww | grep ssh | grep -v grep
marslo      41  0.0  0.0  11716  5832 ?        Ss   21:51   0:00      \_ ssh -Nf -R7777:<destination>:22 marslo@<my.mac.ip>

# verify in mymac
<mymac> $ ssh -p 7777 localhost       # localhost in <mymac> == <destination>
<mymac> $ netstat -an | grep 7777
tcp6       0      0  ::1.7777               ::1.65371              ESTABLISHED
tcp6       0      0  ::1.65371              ::1.7777               ESTABLISHED
tcp4       0      0  127.0.0.1.7777         *.*                    LISTEN
tcp6       0      0  ::1.7777               *.*                    LISTEN
```

# config
## ssh config
```bash
$ cat ~/.ssh/config
HOST  *
      LogLevel              ERROR
      HostkeyAlgorithms     +ssh-rsa
      GSSAPIAuthentication  no
      StrictHostKeyChecking no
      UserKnownHostsFile    /dev/null
      IdentityFile          ~/.ssh/id_ed25519
      IdentityFile          ~/.ssh/id_rsa         # keep the older key if necessary
      # PubkeyAcceptedAlgorithms +ssh-rsa

Include config.d/*

Host  github.com
      User                  marslo.jiao@gmail.com
      Hostname              ssh.github.com
      IdentityFile          /C/Marslo/my@key
      IdentitiesOnly        yes
      Port                  443
      # ProxyCommand        nc -X connect -x proxy.com:8080 %h %p
      # ProxyCommand        /usr/bin/nc -X 5 -x 127.0.0.1:1087 %h %p
      # ProxyCommand        /usr/local/bin/corkscrew 127.0.0.1 1087 %h %p
```

## sshd_config

{% hint style='tip' %}
> references:
> - [Three locks for your SSH door](https://developer.ibm.com/articles/au-sshlocks/)
> - [保护 SSH 的三把锁](https://blogger.lshell.com/2015/09/ssh.html)
> - [7 Default OpenSSH Security Options You Should Change in /etc/ssh/sshd_config](https://www.thegeekstuff.com/2011/05/openssh-options/)
> - [sshd_config (4)](https://docs.oracle.com/cd/E86824_01/html/E54775/sshd-config-4.html)
{% endhint %}

> [!TIP]
> - disable Root Login : `PermitRootLogin`
> - allow only specific users or groups : `AllowUsers`, `AllowGroups`
> - deny specific users or groups : `DenyUsers`, `DenyGroups`
> - change sshd port number : `Port`
> - change login grace time : `LoginGraceTime`
> - Restrict the Interface (IP Address) to Login : `ListenAddress`
> - disconnect ssh when no activity : `ClientAliveInterval`

### banner and motd

> [!TIP]
> files:
> - `/etc/pam.d/sshd` : `session    optional     pam_motd.so` : `/usr/lib64/security/pam_motd.so`
> - `/etc/motd`
> - `/etc/ssh/sshd_config` : `Banner /path/to/banner`

- [force disable all banner or motd](https://askubuntu.com/a/1175798/92979)
  ```bash
  $ ssh user@host
  $ touch ~/.hushlogin
  ```

### disable login password
```bash
$ cat /etc/ssh/sshd_config
ChallengeResponseAuthentication no
PasswordAuthentication no
UsePAM no
```

- scripts:
  ```bash
  TIMESTAMPE=$(date +"%Y%m%d%H%M%S")
  SSHDFILE="/etc/ssh/sshd_config"
  sudo cp "${SSHDFILE}{,.org.${TIMESTAMPE}}"

  sudo bash -c '/bin/sed -i -e "s:^\(UsePAM.*$\):# \1:" ${SSHDFILE}'
  sudo bash -c '/bin/sed -i -e "s:^\(PermitRootLogin.*$\):# \1:" ${SSHDFILE}'
  sudo bash -c '/bin/sed -i -e "s:^\(ChallengeResponseAuthentication.*$\):# \1:" ${SSHDFILE}'
  sudo bash -c '/bin/sed -i -e "s:^\(PasswordAuthentication.*$\):# \1:" ${SSHDFILE}'

  if ! grep 'Add my marslo' ${SSHDFILE} > /dev/null 2>&1; then
    sudo bash -c "cat >> ${SSHDFILE}" << EOF

      # Add my marslo
      PermitRootLogin no
      UsePAM no
      ChallengeResponseAuthentication no
      PasswordAuthentication no
      PrintMotd yes
      Banner /etc/ssh/server.banner
    EOF
  fi
  ```


### disallow group to use password

> [!TIP|label:references:]
> - Directive 'UsePAM' is not allowed within a Match block
> - Directive 'ChallengeResponseAuthentication' is not allowed within a Match block
> - Directive 'PrintMotd' is not allowed within a Match block
> - Directive 'LoginGraceTime' is not allowed within a Match block

```bash
if ! grep 'Add my marslo' ${SSHDFILE} > /dev/null 2>&1; then
  sudo bash -c "cat >> ${SSHDFILE}" << EOF

    # Add my marslo
    Match Group devops
                PasswordAuthentication no
                Banner /etc/ssh/server.banner
                MaxAuthTries 3
                ClientAliveInterval 600       # 60*10 secs
  EOF
fi
```

### disallowing user to use tcp forwarding
```less
Match User testuser
           AllowTcpForwarding no
```

### displaying a special banner for users not in the staff group
```less
Match Group *,!staff
  Banner /etc/banner.text
```

### allowing root login from host rootallowed.example.com
```less
Match Host rootallowed.example.com
  PermitRootLogin yes
```

### allowing anyone to use gatewayports from the local net
```less
Match Address 192.168.0.0/24
  GatewayPorts yes
```

# debug
## debug git

- GIT_SSH_COMMAND
  ```bash
  $ GIT_SSH_COMMAND="ssh -vvT" git clone git@github.com:Marslo/myblog.git
  Cloning into 'myblog'...
  OpenSSH_7.9p1, LibreSSL 2.7.3
  debug1: Reading configuration data /Users/marslo/.ssh/config
  debug1: /Users/marslo/.ssh/config line 1: Applying options for *
  debug1: /Users/marslo/.ssh/config line 13: Applying options for github.com
  debug1: Reading configuration data /etc/ssh/ssh_config
  debug1: /etc/ssh/ssh_config line 48: Applying options for *
  debug1: Connecting to github.com port 22.
  ^C
  ```

- GIT_TRACE
  ```bash
  $ GIT_TRACE=1 git st
  00:30:44.772137 git.c:703               trace: exec: git-st
  00:30:44.772540 run-command.c:663       trace: run_command: git-st
  00:30:44.772894 git.c:384               trace: alias expansion: st => status
  00:30:44.772903 git.c:764               trace: exec: git status
  00:30:44.772907 run-command.c:663       trace: run_command: git status
  00:30:44.777379 git.c:440               trace: built-in: git status
  On branch master
  Your branch is up to date with 'origin/master'.

  00:30:44.782714 run-command.c:663       trace: run_command: GIT_INDEX_FILE=.git/index git submodule summary --cached --for-status --summary-limit -1 HEAD
  00:30:44.787490 git.c:703               trace: exec: git-submodule summary --cached --for-status --summary-limit -1 HEAD
  00:30:44.788038 run-command.c:663       trace: run_command: git-submodule summary --cached --for-status --summary-limit -1 HEAD
  00:30:44.838222 git.c:440               trace: built-in: git rev-parse --git-dir
  00:30:44.845054 git.c:440               trace: built-in: git rev-parse --git-path objects
  00:30:44.852811 git.c:440               trace: built-in: git rev-parse -q --git-dir
  00:30:44.870362 git.c:440               trace: built-in: git rev-parse --show-prefix
  00:30:44.878755 git.c:440               trace: built-in: git rev-parse --show-toplevel
  00:30:44.893984 git.c:440               trace: built-in: git rev-parse -q --verify --default HEAD HEAD
  00:30:44.899709 git.c:440               trace: built-in: git rev-parse --show-toplevel
  00:30:44.905200 git.c:440               trace: built-in: git rev-parse --sq --prefix  --
  00:30:44.911762 git.c:440               trace: built-in: git diff-index --cached --ignore-submodules=dirty --raw 52c94664ffc09cde2308c6bf9824ca0355ff5ff7 --
  00:30:44.917374 run-command.c:663       trace: run_command: GIT_INDEX_FILE=.git/index git submodule summary --files --for-status --summary-limit -1
  00:30:44.922165 git.c:703               trace: exec: git-submodule summary --files --for-status --summary-limit -1
  00:30:44.922568 run-command.c:663       trace: run_command: git-submodule summary --files --for-status --summary-limit -1
  00:30:44.965375 git.c:440               trace: built-in: git rev-parse --git-dir
  00:30:44.972784 git.c:440               trace: built-in: git rev-parse --git-path objects
  00:30:44.979117 git.c:440               trace: built-in: git rev-parse -q --git-dir
  00:30:44.991077 git.c:440               trace: built-in: git rev-parse --show-prefix
  00:30:44.997718 git.c:440               trace: built-in: git rev-parse --show-toplevel
  00:30:45.012365 git.c:440               trace: built-in: git rev-parse -q --verify --default HEAD
  00:30:45.018759 git.c:440               trace: built-in: git rev-parse --show-toplevel
  00:30:45.024687 git.c:440               trace: built-in: git rev-parse --sq --prefix  --
  00:30:45.031664 git.c:440               trace: built-in: git diff-files --ignore-submodules=dirty --raw --
  nothing to commit, working tree clean
  ```

## debug ssh

{% hint style='tip' %}
> references:
> - [OpenSSH Test Mode](https://www.cyberciti.biz/tips/checking-openssh-sshd-configuration-syntax-errors.html)
> - [OpenSSH Tip: Check Syntax Errors before Restarting SSHD Server](https://www.cyberciti.biz/tips/checking-openssh-sshd-configuration-syntax-errors.html)
> - [How to check SSH server's configuration validity](https://www.simplified.guide/ssh/test-config)
{% endhint %}

- debug mode
  ```bash
  $ sudo /usr/sbin/sshd -d [-d] [-d]
  ```
- test mode
  ```bash
  # -T : extended test mode
  $ sudo /usr/sbin/sshd -T [-f /path/to/sshd_config]

  # -t : test mode
  $ sudo /usr/sbin/sshd -t [-f /path/to/sshd_config]
  ```

### check sshd log

> [!NOTE|label:references:]
> - [How to check sshd log?](https://serverfault.com/a/480433/129815)

```bash
# check `/var/log/auth.log`
$ grep 'sshd' /var/log/auth.log
# or
$ tail -f -n 500 /var/log/auth.log | grep 'sshd'

# check with journalctl
## -t, --identifier
$ journalctl -t sshd
## -u, --unit
$ journalctl -u ssh
## -o json-pretty: with json format
$ journalctl -t sshd -o json-pretty
## -b0: since last boot
$ journalctl -t sshd -b0
## reserve order
$ journalctl -t sshd -b0 -r
```

## tips

### disconnect

> [!TIP]
> <kbd>Enter</kbd> + <kbd>~</kbd> + <kbd>.</kbd> + <kbd>Enter</kbd>
>
> references:
> - [Linux / UNIX kill unresponsive hung SSH session](https://www.cyberciti.biz/faq/openssh-linux-unix-osx-kill-hung-ssh-session/)
> - [Kill an unresponsive ssh session without closing the terminal](https://unix.stackexchange.com/a/621066/29178)
> - [How to kill or disconnect hung ssh session in Linux](https://www.golinuxcloud.com/kill-disconnect-hung-ssh-session-linux/)

```bash
$ <Enter>
$ ~?
Supported escape sequences:
 ~.   - terminate connection (and any multiplexed sessions)
 ~B   - send a BREAK to the remote system
 ~C   - open a command line
 ~R   - request rekey
 ~V/v - decrease/increase verbosity (LogLevel)
 ~^Z  - suspend ssh
 ~#   - list forwarded connections
 ~&   - background ssh (when waiting for connections to terminate)
 ~?   - this message
 ~~   - send the escape character by typing it twice
(Note that escapes are only recognized immediately after newline.)
```
