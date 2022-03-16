<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [basic environment](#basic-environment)
  - [Ubuntu](#ubuntu)
  - [CentOS/RHEL](#centosrhel)
- [tricky](#tricky)
  - [show default `KubeletConfiguration`](#show-default-kubeletconfiguration)
  - [show defualt kubeadm config](#show-defualt-kubeadm-config)
  - [kubeadm join](#kubeadm-join)
- [reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## basic environment
### Ubuntu
#### basic
```bash
$ sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

$ sudo usermod -a -G root "$(whoami)"
$ sudo usermod -a -G adm "$(whoami)"
$ sudo usermod -a -G sudo "$(whoami)"

$ [ -f /etc/sysctl.conf ] && sudo mv /etc/sysctl.conf{,.bak.${TIMESTAMPE}}

$ sudo bash -c "cat >> /etc/sysctl.conf" << EOF
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
EOF
```

#### repo sources
```bash
$ cat /etc/apt/sources.list
deb http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu artful main restricted
deb http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu artful-updates main restricted
deb http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu artful universe
deb http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu artful-updates universe
deb http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu artful multiverse
deb http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu artful-updates multiverse
deb http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu artful-backports main restricted universe multiverse
deb http://www.artifactory.mycompany.com/artifactory/debian-remote-canonical artful partner
deb http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu-security artful-security main restricted
deb http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu-security artful-security universe
deb http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu-security artful-security multiverse

$ cat sources.list.d/kubernetes.list
deb http://www.artifactory.mycompany.com/artifactory/debian-remote-google kubernetes-xenial main

$ cat sources.list.d/docker.list
deb [arch=amd64] http://www.artifactory.mycompany.com/artifactory/debian-remote-docker artful edge
# deb [arch=amd64] https://download.docker.com/linux/ubuntu artful edge
```

#### package Search
```bash
$ apt-cache search kub
...
kubeadm - Kubernetes Cluster Bootstrapping Tool
kubectl - Kubernetes Command Line Tool
kubelet - Kubernetes Node Agent
kubernetes-cni - Kubernetes CNI
```

#### installation
```bash
$ sudo apt install kubeadm=1.10.0-00 -y
# or
$ sudo apt install kubeadm=1.10.0-00 kubectl=1.10.0-00 kubelet=1.10.0-00 -y
# or
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
Get:1 http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu artful/main amd64 ebtables amd64 2.0.10.4-3.5ubuntu2 [80.0 kB]
Get:2 http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu artful/main amd64 ethtool amd64 1:4.8-1 [109 kB]
Get:3 http://www.artifactory.mycompany.com/artifactory/debian-remote-google kubernetes-xenial/main amd64 kubernetes-cni amd64 0.6.0-00 [5,910 kB]
Get:4 http://www.artifactory.mycompany.com/artifactory/debian-remote-ubuntu artful/universe amd64 socat amd64 1.7.3.2-1 [342 kB]
Get:5 http://www.artifactory.mycompany.com/artifactory/debian-remote-google kubernetes-xenial/main amd64 kubelet amd64 1.10.0-00 [21.1 MB]
Get:6 http://www.artifactory.mycompany.com/artifactory/debian-remote-google kubernetes-xenial/main amd64 kubectl amd64 1.10.0-00 [8,905 kB]
Get:7 http://www.artifactory.mycompany.com/artifactory/debian-remote-google kubernetes-xenial/main amd64 kubeadm amd64 1.10.0-00 [20.7 MB]
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

- hold the automatic upgrade
  ```bash
  $ sudo apt-mark hold kubeadm
  $ sudo apt-mark hold kubelet
  $ sudo apt-mark hold kubectl

  # check
  $  dpkg -l | grep ^h
  # or
  $ apt-mark showhold
  ```

### CentOS/RHEL
#### basic environment
```bash
$ sudo systemctl stop firewalld
$ sudo systemctl disable firewalld
$ sudo systemctl mask firewalld
$ sudo systemctl is-enabled firewalld
$ sudo systemctl is-active firewalld
$ sudo firewall-cmd --state

$ sudo bash -c "sed -e 's:^\\(.*swap.*\\)$:# \\1:' -i /etc/fstab"
$ sudo swapoff -a

$ sudo setenforce 0
$ sudo bash -c "sed 's/^SELINUX=enforcing$/SELINUX=permissive/' -i /etc/selinux/config"
$ sudo bash -c "sed -e 's:^\\(.*swap.*\\)$:# \\1:' -i /etc/fstab"

$ sudo modprobe br_netfilter
$ sudo sysctl net.bridge.bridge-nf-call-iptables=1
$ sudo sysctl net.bridge.bridge-nf-call-ip6tables=1

$ sudo bash -c "cat >  /etc/sysctl.d/k8s.conf" << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
$ sudo sysctl --system
$ lsmod | grep br_netfilter
```

#### installation
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
$ sudo yum install -y yum-utils \
                      device-mapper-persistent-data \
                      lvm2 \
                      bash-completion*

$ sudo yum search --showduplicates docker-ce | grep 18\.09
$ sudo yum search --showduplicates kubeadm | grep 1\.15\.3

$ sudo yum install -y \
       docker-ce-18.09.9-3.el7.x86_64 \
       docker-ce-cli-18.09.9-3.el7.x86_64 \
       containerd.io

$ sudo yum install -y \
       kubeadm-1.15.3-0.x86_64 \
       kubectl-1.15.3-0.x86_64 \
       kubelet-1.15.3-0.x86_64 \
       --disableexcludes=kubernetes

$ sudo bash -c "echo 'source <(kubectl completion bash)' >> /etc/bashrc"
$ sudo usermod -a -G root,admheel,docker $(whoami)
$ sudo systemctl enable --now docker
$ sudo systemctl enable --now kubelet
```
- version lock
  ```bash
  $ sudo yum versionlock docker-ce
  $ sudo yum versionlock docker-ce-cli
  $ sudo yum versionlock kubeadm
  $ sudo yum versionlock kubelet
  $ sudo yum versionlock kubectl
  $ sudo yum versionlock kubernetes-cni
  $ sudo yum versionlock list
  ```

## tricky
### [show default `KubeletConfiguration`](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/kubelet-integration/#configure-kubelets-using-kubeadm)
```bash
$ sudo kubeadm config print init-defaults --component-configs KubeletConfiguration
$ sudo kubeadm config print init-defaults --component-configs KubeProxyConfiguration

# v1.12.3
$ sudo kubeadm config print-defaults
```

### show defualt kubeadm config
```bash
$ sudo kubeadm config view
```

### kubeadm join

> [!TIP]
> reference:
> - [kubeadm join](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/#token-based-discovery-with-ca-pinning)

- normal commands
  ```bash
  $ sudo kubeadm token create --print-join-command

  # or
  $ sudo kubeadm token create --print-join-command --ttl=0

  # list
  $ sudo kubeadm token list
  ```

- [Token-based discovery with CA pinning](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/#token-based-discovery-with-ca-pinning)
  ```bash
  $ openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt |
            openssl rsa -pubin -outform der 2>/dev/null |
            openssl dgst -sha256 -hex |
            sed 's/^.* //'
  ```
  - for worker nodes
    ```bash
    $ kubeadm join --discovery-token abcdef.1234567890abcdef --discovery-token-ca-cert-hash sha256:1234..cdef 1.2.3.4:6443
    ```
  - for control-plane nodes
    ```bash
    $ kubeadm join --discovery-token abcdef.1234567890abcdef --discovery-token-ca-cert-hash sha256:1234..cdef --control-plane 1.2.3.4:6443
    ```



## reference
- [* Bootstrapping clusters with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/_print/)
- [* 使用 kubeadm 创建集群](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
- [cURLing the Kubernetes API server](https://nieldw.medium.com/curling-the-kubernetes-api-server-d7675cfc398c)
- [Troubleshooting kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/)
- [Kubernetes Recovery from Master Failure with Kubeadm](https://codefarm.me/2019/05/22/kubernetes-recovery-master-failure/)
- [1 - Kubernetes Objects](https://codefarm.me/2019/02/22/kubernetes-crash-course-1/)
- [2 - Kubernetes Pods](https://codefarm.me/2019/03/04/kubernetes-crash-course-2/)
- [3 - Kubernetes Services and Ingress](https://codefarm.me/2019/03/04/kubernetes-crash-course-3/)
- [4 - Kubernetes Storage](https://codefarm.me/2019/03/25/kubernetes-crash-course-4/)
