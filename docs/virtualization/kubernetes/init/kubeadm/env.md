<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [environment setup](#environment-setup)
  - [swapoff](#swapoff)
  - [selinux disable](#selinux-disable)
  - [sysctl](#sysctl)
  - [modules](#modules)
  - [firewall disable](#firewall-disable)
- [package install](#package-install)
  - [Ubuntu](#ubuntu)
    - [repos](#repos)
    - [apt install](#apt-install)
  - [CentOS/RHEL](#centosrhel)
    - [environment](#environment)
    - [yum install](#yum-install)
- [HA](#ha)
  - [keepalived](#keepalived)
    - [install keepalived](#install-keepalived)
    - [`/etc/keepalived/keepalived.conf`](#etckeepalivedkeepalivedconf)
  - [haproxy](#haproxy)
    - [install haproxy](#install-haproxy)
    - [`/etc/haproxy/haproxy.cfg`](#etchaproxyhaproxycfg)
    - [`haproxy.service`](#haproxyservice)
    - [verify haproxy](#verify-haproxy)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# environment setup

- pre-setup
  ```bash
  # debian
  $ sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

  # rhel/centos
  $ sudo dnf install -y conntrack-tools socat ipvsadm ipset yum-utils jq \
             bash-completion net-tools htop rsync rsync-daemon traceroute

  $ sudo usermod -a -G root,adm,sudo "$(whoami)"
  ```

## swapoff
```bash
$ sudo swapoff -a
$ grep -q -E '^[^#]*swap' /etc/fstab && sudo sed -re 's:^[^#]*swap.*:# &:' -i /etc/fstab
```

## selinux disable
```bash
$ sudo setenforce 0
$ sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# verify
$ sestatus
SELinux status:                 disabled
$ getenforce
Disabled
```

## sysctl
```bash
$ sudo grep -q -E '^[^#]*ipv4.ip_forward' /etc/sysctl.conf && sudo sed -re 's:^[^#]*ipv4.ip_forward.*:# &:' -i /etc/sysctl.conf
$ sudo bash -c "cat >> /etc/sysctl.d/k8s.conf" << EOF
net.ipv4.ip_forward = 1
net.ipv4.ip_nonlocal_bind = 1
vm.swappiness = 0
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

$ sudo sysctl -p /etc/sysctl.conf
$ sudo sysctl -p /etc/sysctl.d/k8s.conf
$ sudo sysctl --system
```
- or
  ```bash
  $ [ -f /etc/sysctl.conf ] && sudo mv /etc/sysctl.conf{,.bak.${TIMESTAMPE}}

  $ sudo bash -c "cat >> /etc/sysctl.conf" << EOF
  net.ipv4.ip_forward=1
  net.bridge.bridge-nf-call-iptables=1
  net.bridge.bridge-nf-call-ip6tables=1
  EOF

  # or
  $ sudo sysctl -w net.ipv4.ip_forward=1
  $ sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=1
  $ sudo sysctl -w net.bridge.bridge-nf-call-iptables=1

  # or
  $ sudo sysctl -w net.ipv4.ip_forward=1
  $ sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
  $ sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
  $ sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
  $ sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=1
  $ sudo sysctl -w net.bridge.bridge-nf-call-iptables=1

  $ sudo sysctl --system
  ```

- [or network setup](https://malaty.net/how-to-setup-and-configure-on-prem-kubernetes-high-available-cluster-part-1/)
  ```bash
  SYSCTLDIRECTIVES='net.bridge.bridge-nf-call-iptables net.ipv4.conf.all.forwarding net.ipv4.conf.default.forwarding net.ipv4.ip_forward'

  for directive in ${SYSCTLDIRECTIVES}; do
    if cat /etc/sysctl.d/99-sysctl.conf | grep -q "${directive}"; then
      echo "Directive ${directive} is loaded"
    else
      echo "${directive}=1" >> /etc/sysctl.d/99-sysctl.conf
    fi
  done

  sysctl -p /etc/sysctl.d/99-sysctl.conf
  ```

## modules

> [!NOTE|label:references:]
> - [kubespray/roles/kubernetes/node/defaults/main.yml](https://github.com/kubernetes-sigs/kubespray/blob/master/roles/kubernetes/node/defaults/main.yml#L256)
> - [Kubernetes接入CRI-O](https://www.cnblogs.com/layzer/articles/kubernetes-crio.html)

```bash
$ sudo modprobe br_netfilter
$ sudo modprobe overlay
$ sudo modprobe bridge                   # optional
$ sudo bash -c "cat /etc/modules-load.d/k8s.conf" << EOF
overlay
br_netfilter
bridge
EOF

# check
$ sudo lsmod | grep br_netfilter

# module for ipvs (optional)
$ cat << EOF >> ./ipvs.module
modprobe -- ip_vs
modprobe -- ip_vs_sh
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- nf_conntrack
EOF
$ chmod 755 ./ipvs.module && ./ipvs.module

# or
$ sudo bash -c "cat /etc/modules-load.d/ipvs.conf" << EOF
ip_vs
ip_vs_sh
ip_vs_rr
ip_vs_wrr
nf_conntrack
EOF
$ sudo modprobe -- ip_vs
```

## firewall disable
```bash
# rhel/centos
$ sudo systemctl stop firewalld
$ sudo systemctl disable firewalld
$ sudo systemctl mask firewalld
```

# package install
## Ubuntu

### repos
- via artifactory
  ```bash
  $ cat /etc/apt/sources.list
  deb http://sample.artifactory.com/artifactory/debian-remote-ubuntu artful main restricted
  deb http://sample.artifactory.com/artifactory/debian-remote-ubuntu artful-updates main restricted
  deb http://sample.artifactory.com/artifactory/debian-remote-ubuntu artful universe
  deb http://sample.artifactory.com/artifactory/debian-remote-ubuntu artful-updates universe
  deb http://sample.artifactory.com/artifactory/debian-remote-ubuntu artful multiverse
  deb http://sample.artifactory.com/artifactory/debian-remote-ubuntu artful-updates multiverse
  deb http://sample.artifactory.com/artifactory/debian-remote-ubuntu artful-backports main restricted universe multiverse
  deb http://sample.artifactory.com/artifactory/debian-remote-canonical artful partner
  deb http://sample.artifactory.com/artifactory/debian-remote-ubuntu-security artful-security main restricted
  deb http://sample.artifactory.com/artifactory/debian-remote-ubuntu-security artful-security universe
  deb http://sample.artifactory.com/artifactory/debian-remote-ubuntu-security artful-security multiverse

  $ cat sources.list.d/kubernetes.list
  deb http://sample.artifactory.com/artifactory/debian-remote-google kubernetes-xenial main

  $ cat sources.list.d/docker.list
  deb [arch=amd64] http://sample.artifactory.com/artifactory/debian-remote-docker artful edge
  ## deb [arch=amd64] https://download.docker.com/linux/ubuntu artful edge
  ```

- package Search
  ```bash
  $ apt-cache search kub

  ...
  kubeadm - Kubernetes Cluster Bootstrapping Tool
  kubectl - Kubernetes Command Line Tool
  kubelet - Kubernetes Node Agent
  kubernetes-cni - Kubernetes CNI
  ```

### apt install
```bash
$ sudo apt install kubeadm=1.10.0-00 -y
# or
$ sudo apt install kubeadm -y
# or
$ sudo apt install kubeadm=1.10.0-00 kubectl=1.10.0-00 kubelet=1.10.0-00 -y
```

<!--sec data-title="apt install log" data-id="section0" data-show=true data-collapse=true ces-->
```bash
$ sudo apt install kubeadm -y
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  ebtables ethtool kubectl kubelet kubernetes-cni socat
The following NEW packages will be installed:
  ebtables ethtool kubeadm kubectl kubelet kubernetes-cni socat
0 upgraded, 7 newly installed, 0 to remove and 0 not upgraded.
Need to get 57.1 MB of archives.
After this operation, 411 MB of additional disk space will be used.
Get:1 http://sample.artifactory.com/artifactory/debian-remote-ubuntu artful/main amd64 ebtables amd64 2.0.10.4-3.5ubuntu2 [80.0 kB]
Get:2 http://sample.artifactory.com/artifactory/debian-remote-ubuntu artful/main amd64 ethtool amd64 1:4.8-1 [109 kB]
Get:3 http://sample.artifactory.com/artifactory/debian-remote-google kubernetes-xenial/main amd64 kubernetes-cni amd64 0.6.0-00 [5,910 kB]
Get:4 http://sample.artifactory.com/artifactory/debian-remote-ubuntu artful/universe amd64 socat amd64 1.7.3.2-1 [342 kB]
Get:5 http://sample.artifactory.com/artifactory/debian-remote-google kubernetes-xenial/main amd64 kubelet amd64 1.10.0-00 [21.1 MB]
Get:6 http://sample.artifactory.com/artifactory/debian-remote-google kubernetes-xenial/main amd64 kubectl amd64 1.10.0-00 [8,905 kB]
Get:7 http://sample.artifactory.com/artifactory/debian-remote-google kubernetes-xenial/main amd64 kubeadm amd64 1.10.0-00 [20.7 MB]
Fetched 57.1 MB in 1min 22s (697 kB/s)
Selecting previously unselected package ebtables.
(Reading database ... 195476 files and directories currently installed.)
Preparing to unpack .../0-ebtables_2.0.10.4-3.5ubuntu2_amd64.deb ...
Unpacking ebtables (2.0.10.4-3.5ubuntu2) ...
Selecting previously unselected package ethtool.
Preparing to unpack .../1-ethtool_1%3a4.8-1_amd64.deb ...
Unpacking ethtool (1:4.8-1) ...
Selecting previously unselected package kubernetes-cni.
Preparing to unpack .../2-kubernetes-cni_0.6.0-00_amd64.deb ...
Unpacking kubernetes-cni (0.6.0-00) ...
Selecting previously unselected package socat.
Preparing to unpack .../3-socat_1.7.3.2-1_amd64.deb ...
Unpacking socat (1.7.3.2-1) ...
Selecting previously unselected package kubelet.
Preparing to unpack .../4-kubelet_1.10.0-00_amd64.deb ...
Unpacking kubelet (1.10.0-00) ...
Selecting previously unselected package kubectl.
Preparing to unpack .../5-kubectl_1.10.0-00_amd64.deb ...
Unpacking kubectl (1.10.0-00) ...
Selecting previously unselected package kubeadm.
Preparing to unpack .../6-kubeadm_1.10.0-00_amd64.deb ...
Unpacking kubeadm (1.10.0-00) ...
Setting up kubernetes-cni (0.6.0-00) ...
Processing triggers for ureadahead (0.100.0-20) ...
Setting up socat (1.7.3.2-1) ...
Processing triggers for doc-base (0.10.7) ...
Processing 1 added doc-base file...
Processing triggers for systemd (234-2ubuntu12.3) ...
Setting up ebtables (2.0.10.4-3.5ubuntu2) ...
Created symlink /etc/systemd/system/multi-user.target.wants/ebtables.service → /lib/systemd/system/ebtables.service.
update-rc.d: warning: start and stop actions are no longer supported; falling back to defaults
Setting up kubectl (1.10.0-00) ...
Processing triggers for man-db (2.7.6.1-2) ...
Setting up ethtool (1:4.8-1) ...
Setting up kubelet (1.10.0-00) ...
Created symlink /etc/systemd/system/multi-user.target.wants/kubelet.service → /lib/systemd/system/kubelet.service.
Setting up kubeadm (1.10.0-00) ...
Processing triggers for systemd (234-2ubuntu12.3) ...
Processing triggers for ureadahead (0.100.0-20) ...
```
<!--endsec-->

- vesion lock
  ```bash
  $ sudo apt-mark hold kubeadm
  $ sudo apt-mark hold kubelet
  $ sudo apt-mark hold kubectl

  ## check
  $ dpkg -l | grep ^h
  # or
  $ apt-mark showhold
  ```

## CentOS/RHEL

> [!NOTE]
> - [solution to fix Centos7](https://github.com/philyuchkoff/HAProxy-2-RPM-builder?tab=readme-ov-file#solution-1)
>   ```bash
>   $ sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
>   $ sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
>   ```

### environment

> [!NOTE]
> - [How to install Kubernetes cluster on CentOS 8](https://upcloud.com/resources/tutorials/install-kubernetes-cluster-centos-8)
> - open necessary ports used by kubernetes
>   ```bash
>   $ firewall-cmd --zone=public --permanent --add-port={6443,2379,2380,10250,10251,10252}/tcp
>   $ firewall-cmd --zone=public --permanent --add-port={10250,30000-32767}/tcp
>   ```
> - allow docker access from another node
>   ```bash
>   $ firewall-cmd --zone=public --permanent --add-rich-rule 'rule family=ipv4 source address=worker-IP-address/32 accept'
>   ```
> - allow access to the host’s localhost from the docker container
>   ```bash
>   $ firewall-cmd --zone=public --permanent --add-rich-rule 'rule family=ipv4 source address=172.17.0.0/16 accept'
>   ```
> - make the changes permanent
>   ```bash
>   $ firewall-cmd --reload
>   ```

```bash
$ sudo systemctl stop firewalld
$ sudo systemctl disable firewalld
$ sudo systemctl mask firewalld
$ sudo systemctl is-enabled firewalld
$ sudo systemctl is-active firewalld
$ sudo firewall-cmd --state

## disable swap
$ sudo swapoff -a
$ grep -q -E '^[^#]*swap' /etc/fstab && sudo sed -re 's:^[^#]*swap.*:# &:' -i /etc/fstab
# or
$ sudo bash -c "sed -e 's:^\\(.*swap.*\\)$:# \\1:' -i /etc/fstab"

## disable selinux
$ sudo setenforce 0
$ sudo bash -c "sed 's/^SELINUX=enforcing$/SELINUX=permissive/' -i /etc/selinux/config"
# check
$ sestatus
SELinux status:                 disabled

## to avoid /proc/sys/net/bridge/bridge-nf-call-iptables: No such file or directory
## https://gist.github.com/iamcryptoki/ed6925ce95f047673e7709f23e0b9939
$ sudo modprobe br_netfilter

$ sudo sysctl -w net.ipv4.ip_forward=1
$ sudo sysctl net.bridge.bridge-nf-call-iptables=1
$ sudo sysctl net.bridge.bridge-nf-call-ip6tables=1
##or
$ sudo bash -c "cat > /etc/sysctl.d/k8s.conf" << EOF
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
$ sudo sysctl -p /etc/sysctl.d/k8s.conf

$ sudo sysctl --system
$ lsmod | grep br_netfilter
```

### yum install

#### ol8 v1.30.4
```bash
$ cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

# get version
$ sudo dnf search --showduplicates kubeadm | grep 1.30.4

# install
$ VERSION='1.30.4-150500.1.1'
$ sudo dnf install -y kubelet-${VERSION} kubeadm-${VERSION} kubectl-${VERSION} --disableexcludes=kubernetes
$ sudo systemctl enable --now kubelet.service

# lock kube* for auto upgrade
$ sudo tail -1 /etc/yum.repos.d/kubernetes.repo
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
```

#### el7 v1.15.3
```bash
$ sudo bash -c 'cat > /etc/yum.repos.d/kubernetes.repo' <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

$ sudo yum clean all
$ sudo yum makecache
$ sudo yum check-update
$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2 bash-completion*

$ sudo yum search --showduplicates docker-ce | grep 18\.09
$ sudo yum search --showduplicates kubeadm   | grep 1\.15\.3

$ DOCKER_VERSION=18.09.9-3.el7
$ sudo yum install -y \
       docker-ce-${DOCKER_VERSION}.x86_64 \
       docker-ce-cli-${DOCKER_VERSION}.x86_64 \
       containerd.io

$ KUBE_VERSION=1.15.3-0
$ sudo yum install -y kubeadm-${KUBE_VERSION}.x86_64 \
                      kubectl-${KUBE_VERSION}.x86_64 \
                      kubelet-${KUBE_VERSION}.x86_64 \
                      --disableexcludes=kubernetes

$ sudo bash -c "echo 'source <(kubectl completion bash)' >> /etc/bashrc"
$ sudo usermod -a -G root,adm,wheel,docker $(whoami)
$ sudo systemctl enable --now docker
$ sudo systemctl enable --now kubelet
```

- full repo files
  ```
  $ cat /etc/yum.repos.d/kubernetes.repo
  [kubernetes]
  name=Kubernetes
  baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch
  enabled=1
  gpgcheck=1
  gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
  exclude=kubelet kubeadm kubectl kubernetes-cni cri-tools
  ```

#### el7 v1.12.3
```bash
$ sudo bash -c 'cat > /etc/yum.repos.d/kubernetes.repo' <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

$ sudo yum makecache
$ sudo dnf install -y kubelet-1.12.3-0 \
                      kubeadm-1.12.3-0 \
                      kubectl-1.12.3-0 \
                      --disableexcludes=kubernetes

$ sudo systemctl enable --now kubelet
Created symlink /etc/systemd/system/multi-user.target.wants/kubelet.service → /etc/systemd/system/kubelet.service.

# verify
$ sudo dnf list --installed | grep kube
cri-tools.x86_64             1.26.0-0      @kubernetes
kubeadm.x86_64               1.12.3-0      @kubernetes
kubectl.x86_64               1.12.3-0      @kubernetes
kubelet.x86_64               1.12.3-0      @kubernetes
kubernetes-cni.x86_64        0.6.0-0       @kubernetes

$ journalctl -u kubelet -f
```

#### version lock
```bash
$ sudo yum versionlock docker-ce
$ sudo yum versionlock docker-ce-cli
$ sudo yum versionlock kubeadm
$ sudo yum versionlock kubelet
$ sudo yum versionlock kubectl
$ sudo yum versionlock kubernetes-cni
$ sudo yum versionlock list

# or
$ grep exclude /etc/yum.repos.d/kubernetes.repo
exclude=kubelet kubeadm kubectl kubernetes-cni cri-tools
```

# HA

| Node   | IP Address  | Hostname | Role          |
|--------|-------------|----------|---------------|
| k8s-01 | 10.69.78.40 | k8s-01   | contrl pannel |
| k8s-02 | 10.69.78.41 | k8s-02   | contrl pannel |
| k8s-03 | 10.69.78.42 | k8s-03   | contrl pannel |
| -      | 10.69.78.15 | lb-01    | load balancer |

## keepalived

> [!NOTE|label:references:]
> - [Keepalived User Guide](https://keepalived.readthedocs.io/en/latest/index.html#)

### install keepalived

- from package manager
  ```bash
  # debian
  $ sudo apt-get install keepalived

  # rhel/centos
  $ sudo yum install keepalived
  ```

- [from source](https://keepalived.readthedocs.io/en/latest/installing_keepalived.html#compiling-and-building-from-source)
  - basic packages
    ```bash
    # debian
    $ sudo apt-get install curl gcc libssl-dev libnl-3-dev libnl-genl-3-dev libsnmp-dev

    # rhel/centos
    $ sudo yum install curl gcc openssl-devel libnl3-devel net-snmp-devel
    ```

  ```bash
  $ keepalivedUrl='https://www.keepalived.org/software'
  $ mkdir -p ~/temp
  $ sudo mkdir -p /etc/keepalived/

  # 2.0.18
  $ curl -fsSL ${keepalivedUrl}/keepalived-2.0.18.tar.gz | tar xzf - -C ~/temp
  # 2.3.1
  $ curl -fsSL ${keepalivedUrl}/keepalived-2.3.1.tar.gz  | tar xzf - -C ~/temp

  $ pushd .
  $ cd ~/temp/keepalived-2.0.18

  $ ./configure && make
  # or
  $ ./configure --prefix=/usr/local/keepalived-2.0.18 && make

  $ sudo make install
  $ sudo cp keepalived/keepalived.service /etc/systemd/system/
  $ popd
  $ rm -rf ~/temp
  ```

### `/etc/keepalived/keepalived.conf`

- without HAProxy

  > [!NOTE]
  > - `/etc/keepalived/keepalived.conf`
  > - `/etc/keepalived/check_apiserver.sh`

  ```bash
  $ cat /etc/keepalived/keepalived.conf
  ! Configuration File for keepalived
  global_defs {
    router_id LVS_DEVEL
  }
  vrrp_script check_apiserver {
    script "/etc/keepalived/check_apiserver.sh"
    interval 3
    weight -2
    fall 10
    rise 2
  }
  vrrp_instance VI_1 {
    state MASTER
    interface ens192
    virtual_router_id 51
    priority 101
    authentication {
      auth_type PASS
      auth_pass 4be37dc3b4c90194d1600c483e10ad1d
    }
    virtual_ipaddress {
      ${VIRTUAL_IP}
    }
    track_script {
      check_apiserver
    }
  }

  $ cat /etc/keepalived/check_apiserver.sh
  #!/bin/sh
  errorExit() { echo "*** $*" 1>&2; exit 1; }
  curl --silent --max-time 2 --insecure https://localhost:6443/ -o /dev/null || errorExit "Error GET https://localhost:6443/"
  if ip addr | grep -q ${VIRTUAL_IP}; then
    curl --silent --max-time 2 --insecure https://${VIRTUAL_IP}:6443/ -o /dev/null || errorExit "Error GET https://${VIRTUAL_IP}:6443/"
  fi
  ```

- with HAProxy
  ```bash
  $ cat /etc/keepalived/keepalived.conf
  ! Configuration File for keepalived

  global_defs {
    router_id LVS_DEVEL
  }

  vrrp_script check_haproxy {
    script "killall -0 haproxy"
    interval 3
    weight -2
    fall 10
    rise 2
  }

  vrrp_instance VI_1 {
    state MASTER
    interface ${INTERFACE}
    virtual_router_id 51
    priority 50
    advert_int 1
    authentication {
      auth_type PASS
      auth_pass 35f18af7190d51c9f7f78f37300a0cbd
    }
    virtual_ipaddress {
      ${VIRTUAL_IP}
    }
    track_script {
      check_haproxy
    }
  }
  ```

## haproxy

### install haproxy

- from package manager

  > [!NOTE|label:references:]
  > - [philyuchkoff/HAProxy-2-RPM-builder](https://github.com/philyuchkoff/HAProxy-2-RPM-builder)

  ```bash
  # debian

  # rhel/centos
  $ sudo dnf install -y haproxy              # 1.8.27-493ce0b

  # or via official repo
  $ sudo curl -o /etc/yum.repo.d/zenetys-latest.repo -fsSL https://packages.zenetys.com/latest/redhat/zenetys-latest.repo
  $ sudo dnf update
  $ sudo dnf install -y haproxy30z-3.0.4-1.el8.zenetys.x86_64

  # or
  $ sudo dnf install -y https://github.com/philyuchkoff/HAProxy-3-RPM-builder/releases/download/3.0.3/haproxy-3.0.3-1.el8.x86_64.rpm
  ```

- [from source](https://github.com/haproxy/haproxy/blob/master/INSTALL)

  > [!NOTE|label:references:]
  > - [How to install HAProxy load balancer on CentOS](https://upcloud.com/resources/tutorials/haproxy-load-balancer-centos)
  > - [* Install latest HAProxy on Linux : step by step](https://maggiminutes.com/install-latest-haproxy-on-linux-step-by-step/)
  > - [Installing HAProxy From Source on CentOS 8](https://tylersguides.com/guides/installing-haproxy-from-source-on-centos-8/)

  - basic environment
    ```bash
    # debian
    $ sudo apt-get install build-essential

    # rhel/centos
    $ sudo yum groupinstall "Development Tools"
    ```

  ```bash
  # download
  $ git clone --branch v3.0.0 git@github.com:haproxy/haproxy.git && cd haproxy
  # or
  $ curl -fsSL http://www.haproxy.org/download/3.0/src/haproxy-3.0.0.tar.gz | tar xzf - -C ~

  # install
  $ make clean
  $ make -j $(nproc) TARGET=linux-glibc \
         USE_OPENSSL=1 USE_QUIC=1 USE_QUIC_OPENSSL_COMPAT=1 \
         USE_LUA=1 USE_PCRE2=1
  $ sudo make install

  # configure
  $ sudo cp haproxy-3.0.0/examples/haproxy.init /etc/init.d/haproxy
  $ sudo chmod 755 /etc/init.d/haproxy
  $ sudo systemctl daemon-reload
  $ sudo chkconfig haproxy on
  $ sudo useradd -r haproxy
  ```

  ```bash
  # v2.8 with lua
  $ sudo dnf -y install wget yum-utils gcc perl pcre-devel openssl-devel zlib-devel readline-devel systemd-devel tar lua lua-devel make
  $ make -j $(nproc) TARGET=linux-glibc \
         USE_OPENSSL=1 USE_PCRE=1 USE_NS=1 \
         USE_TFO=1 USE_ZLIB=1 USE_SYSTEMD=1 USE_LIBCRYPT=1 USE_THREAD=1
  $ make TARGET=linux-glibc install-bin install-man
  $ sudo cp /usr/local/sbin/haproxy /usr/sbin/haproxy
  $ sudo mkdir -p /var/lib/haproxy /etc/haprox

  # environment variable
  cat << EOT | sudo tee /etc/sysconfig/haproxy
  # Command line options to pass to HAProxy at startup
  # The default is:
  CLI_OPTIONS="-Ws"

  # Specify an alternate configuration file. The default is:
  CONFIG_FILE=/etc/haproxy/haproxy.cfg

  # File used to track process IDs. The default is:
  PID_FILE=/var/run/haproxy.pid
  EOT

  # services
  ## rhel/centos: /usr/local/lib/systemd/system/haproxy.service
  $ cat << 'EOT' | sudo tee /etc/systemd/system/haproxy.service
  [Unit]
  Description=HAProxy Load Balancer
  After=syslog.target network.target

  [Service]
  Type=notify
  EnvironmentFile=/etc/sysconfig/haproxy
  ExecStart=/usr/local/sbin/haproxy -f $CONFIG_FILE -p $PID_FILE $CLI_OPTIONS
  ExecReload=/bin/kill -USR2 $MAINPID
  ExecStop=/bin/kill -USR1 $MAINPID

  [Install]
  WantedBy=multi-user.target
  EOT

  # enable service
  $ sudo systemctl daemon-reload
  ```

- [HAProxy Enterprise](https://www.haproxy.com/documentation/haproxy-enterprise/getting-started/installation/linux/)
  ```bash
  $ curl -fssSL -O https://www.haproxy.com/static/install_haproxy_enterprise.sh

  # debian
  $ curl -fsSL -O https://www.haproxy.com/static/install_haproxy_enterprise.sh.sha512.asc
  $ sudo gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 0xCA2DF14657C5A207
  $ sudo gpg --verify ./install_haproxy_enterprise.sh.sha512.asc

  # install
  $ sudo bash ./install_haproxy_enterprise.sh --version "2.9r1" --key "<HAProxy Enterprise key>"
  ```

### `/etc/haproxy/haproxy.cfg`

> [!NOTE]
> - API service: `16443`
> - control pannel API service: `6443`
> - HAProxy stats: `8000`
> - references:
>   - [Eine Tomcat 9 / ORDS 23 / APEX 23 Umgebung unter Oracle Linux mit dem HAProxy betreiben](https://www.pipperr.de/dokuwiki/doku.php?id=prog:oracle_apex_haproxy)
>     - santiy check for config: `haproxy -f /etc/haproxy/haproxy.cfg -c`
>   - [How to Install and Configure HAProxy on CentOS 8 / RHEL 8](https://www.linuxtechi.com/install-configure-haproxy-centos-8-rhel-8/)

```bash
$ grep -Env '#|^$|^\[' /etc/haproxy/haproxy.cfg
12:global
26:    log         127.0.0.1 local2
28:    chroot      /var/lib/haproxy
29:    pidfile     /var/run/haproxy.pid
30:    maxconn     4000
31:    user        haproxy
32:    group       haproxy
33:    daemon
36:    stats socket /var/lib/haproxy/stats
42:defaults
43:    mode                    http
44:    log                     global
45:    option                  httplog
46:    option                  dontlognull
47:    option http-server-close
48:    option forwardfor       except 127.0.0.0/8
49:    option                  redispatch
50:    retries                 3
51:    timeout http-request    10s
52:    timeout queue           1m
53:    timeout connect         10s
54:    timeout client          1m
55:    timeout server          1m
56:    timeout http-keep-alive 10s
57:    timeout check           10s
58:    maxconn                 3000
63:frontend kubernetes-apiserver
64:    mode                 tcp
65:    bind                 *:16443
66:    option               tcplog
67:    default_backend      kubernetes-apiserver
72:backend kubernetes-apiserver
73:    mode        tcp
74:    balance     roundrobin
75:    option      tcplog
76:    option      tcp-check
77:    server      k8s-01    10.69.78.40:6443 check
78:    server      k8s-02    10.69.78.41:6443 check
79:    server      k8s-03    10.69.78.42:6443 check
84:listen stats
86:    bind                 :8000
87:    stats auth           admin:awesomePassword
88:    maxconn              50
89:    stats refresh        10s
90:    stats realm          HAProxy\ Statistics
91:    stats uri            /healthy
```

- [v2.8](https://maggiminutes.com/install-latest-haproxy-on-linux-step-by-step/)
  ```bash
  $ cat << EOT | sudo tee /etc/haproxy/haproxy.cfg
  global
      log         127.0.0.1 local2

      chroot      /var/lib/haproxy
      maxconn     4000
      daemon

      stats socket /var/lib/haproxy/stats mode 600 level admin
      stats timeout 2m

      tune.ssl.default-dh-param 2048
      ssl-default-bind-ciphers ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS
      ssl-default-bind-options ssl-min-ver TLSv1.2 no-sslv3 no-tls-tickets
      ssl-default-server-ciphers ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS
      ssl-default-server-options ssl-min-ver TLSv1.2 no-sslv3 no-tls-tickets

  defaults
      mode http
      log global
      option httplog
      option dontlognull
      option http-server-close
      option forwardfor       except 127.0.0.0/8
      option redispatch
      retries 3
      timeout http-request    10s
      timeout queue           1m
      timeout connect         10s
      timeout client          1m
      timeout server          1m
      timeout http-keep-alive 10s
      timeout check           10s
      maxconn                 3000

  listen stats
      bind *:9201
      mode http
      stats enable
      stats hide-version
      stats realm Haproxy\ Statistics
      stats auth admin:password
      stats uri  /haproxy?stats
      stats refresh 5s
      stats show-node
  EOT

  # verify configure
  $ /usr/local/sbin/haproxy -c -V -f /etc/haproxy/haproxy.cfg
  ```

### `haproxy.service`
- v2.0.6
  ```bash
  $ sudo cat /usr/lib/systemd/system/haproxy.service
  [Unit]
  Description=HAProxy Load Balancer
  After=network.target syslog.service
  Wants=syslog.service

  [Service]
  Environment="CONFIG=/etc/haproxy/haproxy.cfg" "PIDFILE=/run/haproxy.pid"
  EnvironmentFile=-/etc/default/haproxy
  ExecStartPre=/usr/sbin/haproxy -f $CONFIG -c -q
  ExecStart=/usr/sbin/haproxy -W -f $CONFIG -p $PIDFILE $EXTRAOPTS
  ExecReload=/usr/sbin/haproxy -f $CONFIG -c -q $EXTRAOPTS $RELOADOPTS
  ExecReload=/bin/kill -USR2 $MAINPID
  KillMode=mixed
  Restart=always
  Type=forking

  [Install]
  WantedBy=multi-user.target

  $ ps auxfww | grep haproxy
  /usr/sbin/haproxy -W -f /etc/haproxy/haproxy.cfg -p /run/haproxy.pid
  ```

- 1.8.27-493ce0b
  ```bash
  $ cat /usr/local/lib/systemd/system/haproxy.service
  [Unit]
  Description=HAProxy Load Balancer
  After=network-online.target
  Wants=network-online.target

  [Service]
  Environment="CONFIG=/etc/haproxy/haproxy.cfg" "PIDFILE=/run/haproxy.pid" "CFGDIR=/etc/haproxy/conf.d"
  EnvironmentFile=/etc/sysconfig/haproxy
  ExecStartPre=/usr/sbin/haproxy -f $CONFIG -f $CFGDIR -c -q $OPTIONS
  ExecStart=/usr/sbin/haproxy -Ws -f $CONFIG -f $CFGDIR -p $PIDFILE $OPTIONS
  ExecReload=/usr/sbin/haproxy -f $CONFIG -f $CFGDIR -c -q $OPTIONS
  ExecReload=/bin/kill -USR2 $MAINPID
  SuccessExitStatus=143
  KillMode=mixed
  Type=notify

  [Install]
  WantedBy=multi-user.target

  $ cat /etc/sysconfig/haproxy
  # Add extra options to the haproxy daemon here. This can be useful for
  # specifying multiple configuration files with multiple -f options.
  # See haproxy(1) for a complete list of options.
  OPTIONS=""

  $ ps auxfww | grep haproxy
  /usr/sbin/haproxy -Ws -f /etc/haproxhaproxy.cfg -f /etc/haproxy/conf.d -p /run/haproxy.pid
  ```

### verify haproxy

> [!TIP]
> visit :
>  - http://load_balancer:<port>/<stats uri>
>  - i.e.: http://load_balancer:8000/healthy

- list service details
  ```bash
  $ sudo systemctl list-dependencies haproxy
  haproxy.service
  ● ├─system.slice
  ● ├─network-online.target
  ● │ └─NetworkManager-wait-online.service
  ● └─sysinit.target
  ●   ├─dev-hugepages.mount
  ●   ├─dev-mqueue.mount
  ●   ├─dracut-shutdown.service
  ●   ├─import-state.service
  ●   ├─kmod-static-nodes.service
  ●   ├─ldconfig.service
  ●   ├─loadmodules.service
  ●   ├─lvm2-lvmpolld.socket
  ●   ├─lvm2-monitor.service
  ●   ├─multipathd.service
  ●   ├─nis-domainname.service
  ●   ├─plymouth-read-write.service
  ●   ├─plymouth-start.service
  ●   ├─proc-sys-fs-binfmt_misc.automount
  ●   ├─selinux-autorelabel-mark.service
  ●   ├─sys-fs-fuse-connections.mount
  ●   ├─sys-kernel-config.mount
  ●   ├─sys-kernel-debug.mount
  ●   ├─systemd-ask-password-console.path
  ●   ├─systemd-binfmt.service
  ●   ├─systemd-firstboot.service
  ●   ├─systemd-hwdb-update.service
  ●   ├─systemd-journal-catalog-update.service
  ●   ├─systemd-journal-flush.service
  ●   ├─systemd-journald.service
  ●   ├─systemd-machine-id-commit.service
  ●   ├─systemd-modules-load.service
  ●   ├─systemd-random-seed.service
  ●   ├─systemd-sysctl.service
  ●   ├─systemd-sysusers.service
  ●   ├─systemd-tmpfiles-setup-dev.service
  ●   ├─systemd-tmpfiles-setup.service
  ●   ├─systemd-udev-trigger.service
  ●   ├─systemd-udevd.service
  ●   ├─systemd-update-done.service
  ●   ├─systemd-update-utmp.service
  ●   ├─cryptsetup.target
  ●   ├─local-fs.target
  ●   │ ├─-.mount
  ●   │ ├─boot.mount
  ●   │ ├─systemd-fstab-generator-reload-targets.service
  ●   │ └─systemd-remount-fs.service
  ●   └─swap.target
  ```
