<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [shadowsocks service](#shadowsocks-service)
  - [CentOS](#centos)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




## [shadowsocks service](https://github.com/shadowsocks/shadowsocks/tree/master)

### CentOS
#### basic environment
```bash
$ sudo yum install python-setuptools && sudo easy_install pip
$ sudo yum install epel-release
$ sudo yum install libsodium            # for aes-256-gcm
$ sudo yum -y groupinstall "Development Tools"
$ sudo yum -y install python3-pip       # optional
$ sudo -H python3 -m pip install --upgrade pip
```


#### git
```bash
$ sudo bash -c "cat > /etc/yum.repos.d/wandisco-git.repo" << EOF
[wandisco-git]
name=Wandisco GIT Repository
baseurl=http://opensource.wandisco.com/centos/7/git/\$basearch/
enabled=1
gpgcheck=1
gpgkey=http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco
EOF

$ sudo rpm --import http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco
$ sudo yum install -y git
```

- or [nhahv/install_git2.x_on_centos.md](https://gist.github.com/nhahv/7077a638b57f7d91ebe9a3c6caebbe4f)
  ```bash
  $ sudo yum install http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm
  $ sudo yum install -y git
  ```
