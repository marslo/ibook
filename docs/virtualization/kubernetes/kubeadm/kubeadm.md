<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [basic environment](#basic-environment)
  - [Ubuntu](#ubuntu)
  - [CentOS/RHEL](#centosrhel)
- [tricky](#tricky)
  - [list images](#list-images)
  - [get or modify kubeadm-cfg.yml](#get-or-modify-kubeadm-cfgyml)
  - [show default `KubeletConfiguration`](#show-default-kubeletconfiguration)
  - [show endpoint](#show-endpoint)
  - [show default kubeadm config](#show-default-kubeadm-config)
  - [kubeadm join](#kubeadm-join)
  - [[kubeadm upgrade](Upgrading kubeadm clusters)](#kubeadm-upgradeupgrading-kubeadm-clusters)
  - [reconfiguring kubeadm](#reconfiguring-kubeadm)
  - [CNI](#cni)
- [troubleshooting](#troubleshooting)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

![how kubeadm init](../../../screenshot/k8s/Kubeadm-init.png)

{% hint style='tip' %}
> - scripts:
>   - [mritd/shell_scripts](https://github.com/mritd/shell_scripts/tree/master)
>     - [init_ubuntu.sh](https://github.com/mritd/shell_scripts/blob/master/init_ubuntu.sh)
> - installation:
>   - [* install tools](https://kubernetes.io/docs/tasks/tools/)
>   - [* Bootstrapping clusters with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/_print/)
>   - [* 使用 kubeadm 创建集群](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
>   - [* kubeadm 搭建 HA kubernetes 集群](https://mritd.com/2020/01/21/set-up-kubernetes-ha-cluster-by-kubeadm/)
>     - [Implementation details](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/)
>   - [* kubeadm Configuration (v1beta3)](https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta3/)
>   - [* Implementation details](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/)
>   - [* How To Setup A Three Node Kubernetes Cluster Step By Step](https://k21academy.com/docker-kubernetes/three-node-kubernetes-cluster/)
>   - [cURLing the Kubernetes API server](https://nieldw.medium.com/curling-the-kubernetes-api-server-d7675cfc398c)
>   - [Troubleshooting kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/)
>   - [* codefarm](https://blog.codefarm.me/category/#kubernetes)
>     - [Kubernetes Recovery from Master Failure with Kubeadm](https://blog.codefarm.me/2019/05/22/kubernetes-recovery-master-failure/)
>     - [1 - Kubernetes Objects](https://blog.codefarm.me/2019/02/22/kubernetes-crash-course-1/)
>     - [2 - Kubernetes Pods](https://blog.codefarm.me/2019/03/04/kubernetes-crash-course-2/)
>     - [3 - Kubernetes Services and Ingress](https://blog.codefarm.me/2019/03/04/kubernetes-crash-course-3/)
>     - [4 - Kubernetes Storage](https://blog.codefarm.me/2019/03/25/kubernetes-crash-course-4/)
>     - [5 - Kubernetes StatefulSet](https://blog.codefarm.me/2020/02/10/kubernetes-crash-course-5/)
>     - [6 - Kubernetes Monitoring](https://blog.codefarm.me/2020/02/10/kubernetes-crash-course-6/)
>   - [authenticating with bootstrap token](https://kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/)
>   - [kubernetes/design-proposals-archive](https://github.com/kubernetes/design-proposals-archive/blob/main/cluster-lifecycle/bootstrap-discovery.md)
>   - [design-proposals-archive/cluster-lifecycle/cluster-deployment.md](https://github.com/kubernetes/design-proposals-archive/blob/main/cluster-lifecycle/cluster-deployment.md)
>   - [How to Upgrade Kubernetes Cluster Using Kubeadm?](https://devopscube.com/upgrade-kubernetes-cluster-kubeadm/)
>   - [在 Kubernetes 上最小化安装 KubeSphere](https://kubesphere.io/zh/docs/v3.4/quick-start/minimal-kubesphere-on-k8s/)
> - management:
>   - [Administering Kubernetes](https://www.ibm.com/docs/en/fci/1.1.0?topic=administering-kubernetes)
> - upgrade:
>   - [Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)
>   - [kubeadm 集群升级](https://mritd.com/2020/01/21/how-to-upgrade-kubeadm-cluster/)
>     ```bash
>     $ kubeadm upgrade plan --config /etc/kubernetes/kubeadm.yaml
>     ```
> - network
>   - [Migrating a cluster from flannel to Calico](https://docs.projectcalico.org/v3.9/getting-started/kubernetes/installation/migration-from-flannel)
>   - [v3.9 Migrating a cluster from flannel to Calico](https://docs.tigera.io/archive/v3.9/getting-started/kubernetes/installation/migration-from-flannel)
>   - [#1817: kube-flannel dial tcp 10.96.0.1:443: i/o timeout](https://github.com/kubernetes/kubeadm/issues/1817)
>   - [Quickstart for Calico on Kubernetes](https://docs.tigera.io/archive/v3.9/getting-started/kubernetes/)

{% endhint %}

> [!NOTE|label:references:]
> - [* Generate Certificates Manually](https://kubernetes.io/docs/tasks/administer-cluster/certificates/)
>   - [easyrsa](https://kubernetes.io/docs/tasks/administer-cluster/certificates/#easyrsa)
>   - [openssl](https://kubernetes.io/docs/tasks/administer-cluster/certificates/#openssl)
>   - [cfssl](https://kubernetes.io/docs/tasks/administer-cluster/certificates/#cfssl)
> - [Manage TLS Certificates in a Cluster](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)
> - [* Manual Rotation of CA Certificates](https://kubernetes.io/docs/tasks/tls/manual-rotation-of-ca-certificates/)


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

#### repo sources
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

# disable swap
$ sudo swapoff -a
$ grep -q -E '^[^#]*swap' /etc/fstab && sudo sed -re 's:^[^#]*swap.*:# &:' -i /etc/fstab
# or
$ sudo bash -c "sed -e 's:^\\(.*swap.*\\)$:# \\1:' -i /etc/fstab"

# disable selinux
$ sudo setenforce 0
$ sudo bash -c "sed 's/^SELINUX=enforcing$/SELINUX=permissive/' -i /etc/selinux/config"

# to avoid /proc/sys/net/bridge/bridge-nf-call-iptables: No such file or directory
# https://gist.github.com/iamcryptoki/ed6925ce95f047673e7709f23e0b9939
$ sudo modprobe br_netfilter

$ sudo sysctl -w net.ipv4.ip_forward=1
$ sudo sysctl net.bridge.bridge-nf-call-iptables=1
$ sudo sysctl net.bridge.bridge-nf-call-ip6tables=1
#or
$ sudo bash -c "cat > /etc/sysctl.d/k8s.conf" << EOF
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
$ sudo sysctl -p /etc/sysctl.d/k8s.conf

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
$ sudo yum check-update
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
$ sudo usermod -a -G root,adm,wheel,docker $(whoami)
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

  # or
  $ grep exclude /etc/yum.repos.d/kubernetes.repo
  exclude=kubelet kubeadm kubectl kubernetes-cni cri-tools
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

- pre-pull
  ```bash
  $ kubeadm config images pull
  I0508 20:24:29.967938  317181 version.go:236] remote version is much newer: v1.27.1; falling back to: stable-1.12
  [config/images] Pulled k8s.gcr.io/kube-apiserver:v1.12.10
  [config/images] Pulled k8s.gcr.io/kube-controller-manager:v1.12.10
  [config/images] Pulled k8s.gcr.io/kube-scheduler:v1.12.10
  [config/images] Pulled k8s.gcr.io/kube-proxy:v1.12.10
  [config/images] Pulled k8s.gcr.io/pause:3.1
  [config/images] Pulled k8s.gcr.io/etcd:3.2.24
  [config/images] Pulled k8s.gcr.io/coredns:1.2.2
  ```


## tricky

{% hint style='tip' %}
> references:
> - [`kubeadm config`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-config/)
>   - [`kubeadm config print [flags]`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-config/#cmd-config-print)
>   - [`kubeadm config print init-defaults [flags]`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-config/#cmd-config-print-init-defaults)
>   - [`kubeadm config print join-defaults [flags]`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-config/#cmd-config-print-join-defaults)
>   - [`kubeadm config migrate [flags]`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-config/#cmd-config-migrate)
>   - [`kubeadm config images list [flags]`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-config/#cmd-config-images-list)
>   - [`kubeadm config images pull [flags]`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-config/#cmd-config-images-pull)
{% endhint %}

### [list images](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#custom-images)
```bash
$ kubeadm config images list
I0629 03:32:46.532520   66831 version.go:236] remote version is much newer: v1.24.2; falling back to: stable-1.12
k8s.gcr.io/kube-apiserver:v1.12.10
k8s.gcr.io/kube-controller-manager:v1.12.10
k8s.gcr.io/kube-scheduler:v1.12.10
k8s.gcr.io/kube-proxy:v1.12.10
k8s.gcr.io/pause:3.1
k8s.gcr.io/etcd:3.2.24
k8s.gcr.io/coredns:1.2.2

# or
$ kubeadm config images list --config=kubeadm.yml

# to pull images
$ kubeadm config images pull [--config=kubeadm.yml]
```

### [get or modify kubeadm-cfg.yml](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#save-the-kubeadm-clusterconfiguration-in-a-configmap-for-later-reference)

> [!TIP]
> kubeadm saves the configuration passed to `kubeadm init` in a ConfigMap named `kubeadm-config` under `kube-system` namespace.
> This will ensure that kubeadm actions executed in future (e.g `kubeadm upgrade`) will be able to determine the actual/current cluster state and make new decisions based on that data.
> Please note that:
> - Before saving the `ClusterConfiguration`, sensitive information like the token is stripped from the configuration
> - Upload of control plane node configuration can be invoked individually with the [`kubeadm init phase upload-config`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init-phase/#cmd-phase-upload-config) command
> <p>
> <p>
> [**get `kubeadm-cfg.yml`**](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/#kubeconfig-additional-users)
> ```bash
> $ kubectl get cm kubeadm-config -n kube-system -o=jsonpath="{.data.ClusterConfiguration}"
> ```

```bash
$ kubectl get cm kubeadm-config -n kube-system -o=jsonpath="{.data.ClusterConfiguration}"
```

### [show default `KubeletConfiguration`](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/kubelet-integration/#configure-kubelets-using-kubeadm)
```bash
$ sudo kubeadm config print init-defaults --component-configs KubeletConfiguration
$ sudo kubeadm config print init-defaults --component-configs KubeProxyConfiguration

# v1.12.3
$ sudo kubeadm config print-default
$ sudo kubeadm config print-defaults
$ sudo kubeadm config print-defaults --api-objects [apis]
```

{% hint style='tip' %}
```bash
[apis]
  Available values: [ InitConfiguration
                      ClusterConfiguration
                      JoinConfiguration
                      KubeProxyConfiguration
                      KubeletConfiguration
                      MasterConfiguration
  ]
```
{% endhint %}

### show endpoint

```bash
$ kubectl get endpoints kubernetes
NAME         ENDPOINTS                                               AGE
kubernetes   192.168.1.55:6443,192.168.1.73:6443,192.168.1.87:6443   4y347d
```


### show default kubeadm config

{% hint style='tip' %}
> - [* imarslo : get or modify kubeadm-cfg.yml](#get-or-modify-kubeadmyaml)
>   ```bash
>   $ kubectl get cm kubeadm-config -n kube-system -o yaml
>   ```
{% endhint %}

```bash
$ sudo kubeadm config view

# or
$ kubectl -n kube-system get cm kubeadm-config -o yaml
# or
$ kubectl get cm kubeadm-config -n kube-system -o=jsonpath="{.data.ClusterConfiguration}"
```

### kubeadm join

> [!TIP]
> reference:
> - [kubeadm join](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/)
>   - `openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'`
>   - [Using init phases with kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#init-phases)
>     - `sudo kubeadm init phase control-plane controller-manager --help`
>     - `sudo kubeadm init phase control-plane --help`
> - [Uploading control-plane certificates to the cluster](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#uploading-control-plane-certificates-to-the-cluster)
> - [kubeadm join](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/#token-based-discovery-with-ca-pinning)
> - [How do I find the join command for kubeadm on the master?](https://stackoverflow.com/a/55078533/2940319)

- swap off
  ```bash
  $ sudo swapoff -a
  $ sudo sed -re 's:^/?swap.+$:# &:' -i /etc/fstab
  ```

- [install docker-ce](../../docker/docker.html#install)
- install kubelet in node
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
  ```

  - verify
    ```bash
    $ sudo dnf list --installed | grep kube
    cri-tools.x86_64                                   1.26.0-0                                              @kubernetes
    kubeadm.x86_64                                     1.12.3-0                                              @kubernetes
    kubectl.x86_64                                     1.12.3-0                                              @kubernetes
    kubelet.x86_64                                     1.12.3-0                                              @kubernetes
    kubernetes-cni.x86_64                              0.6.0-0                                               @kubernetes

    $ journalctl -u kubelet -f
    ```

- normal commands
  ```bash
  $ sudo kubeadm token create --print-join-command

  # or
  $ sudo kubeadm token create --print-join-command --ttl=0

  # list
  $ sudo kubeadm token list
  ```

- [token-based discovery with CA pinning](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/#token-based-discovery-with-ca-pinning)
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

#### [find join command](https://stackoverflow.com/q/51126164/2940319)

- token ca hash
  ```bash
  $ openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt \
      | openssl rsa -pubin -outform der 2>/dev/null \
      | openssl dgst -sha256 -hex \
      | sed 's/^.* //'
  ```

- bootstrap token
  ```bash
  $ kubeadm token list
  ```

- final command
  ```bash
  $ kubeadm join <ip-address>:6443\
      --token=<bootstrap-token> \
      --discovery-token-ca-cert-hash sha256:<ca-hash>
  ```

- function
  ```bash
  # get the join command from the kube master
  CERT_HASH=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt \
                      | openssl rsa -pubin -outform der 2>/dev/null \
                      | openssl dgst -sha256 -hex \
                      | sed 's/^.* //')
  TOKEN=$(kubeadm token list -o json | jq -r '.token' | head -1)
  IP=$(kubectl get nodes -lnode-role.kubernetes.io/master -o json \
               | jq -r '.items[0].status.addresses[] | select(.type=="InternalIP") | .address')
  PORT=6443
  echo "sudo kubeadm join $IP:$PORT --token=$TOKEN --discovery-token-ca-cert-hash sha256:$CERT_HASH"
  ```

#### troubleshooting

- [`ERROR CRI`](https://forum.linuxfoundation.org/discussion/862825/kubeadm-init-error-cri-v1-runtime-api-is-not-implemented)

  > [!NOTE|label:current system:]
  > - os:
  >   ```bash
  >   $ printf "$(uname -srm)\n$(cat /etc/os-release)\n"
  >   Linux 5.15.0-107-generic x86_64
  >   NAME="Ubuntu"
  >   VERSION="20.04.6 LTS (Focal Fossa)"
  >   ID=ubuntu
  >   ID_LIKE=debian
  >   PRETTY_NAME="Ubuntu 20.04.6 LTS"
  >   VERSION_ID="20.04"
  >   HOME_URL="https://www.ubuntu.com/"
  >   SUPPORT_URL="https://help.ubuntu.com/"
  >   BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
  >   PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
  >   VERSION_CODENAME=focal
  >   UBUNTU_CODENAME=focal
  >   ```
  > - packages:
  >   ```bash
  >   $ apt list --installed | grep -E 'kube|container|cri-tools|socat|cni'
  >   containerd.io/focal,now 1.6.33-1 amd64 [installed]
  >   cri-tools/unknown,now 1.28.0-1.1 amd64 [installed,automatic]
  >   kubeadm/unknown,now 1.28.8-1.1 amd64 [installed,upgradable to: 1.28.10-1.1]
  >   kubectl/unknown,now 1.28.8-1.1 amd64 [installed,upgradable to: 1.28.10-1.1]
  >   kubelet/unknown,now 1.28.8-1.1 amd64 [installed,upgradable to: 1.28.10-1.1]
  >   kubernetes-cni/unknown,now 1.2.0-2.1 amd64 [installed,automatic]
  >   socat/focal,now 1.7.3.3-2 amd64 [installed,automatic]
  >   ```

  - error message
    ```bash
    $ sudo kubeadm join 192.168.1.100:6443 --token yspydx.6bhxbnvzojb9vxbr --discovery-token-ca-cert-hash sha256:ef2971478d52cfee63a543fe7ad6f97423d2a943456ff93641c705fc3e82b6c4 --v=5
    [preflight] Running pre-flight checks
      [WARNING Swap]: swap is enabled; production deployments should disable swap unless testing the NodeSwap feature gate of the kubelet
    error execution phase preflight: [preflight] Some fatal errors occurred:
      [ERROR CRI]: container runtime is not running: output: time="2024-06-07T19:42:13-07:00" level=fatal msg="validate service connection: validate CRI v1 runtime API for endpoint \"unix:///var/run/containerd/containerd.sock\": rpc error: code = Unimplemented desc = unknown service runtime.v1.RuntimeService"
    , error: exit status 1
    ```

  - solution
    ```bash
    # uninstall `containerd` if necessary
    $ sudo apt remove -y containerd

    # install containerd.io instead of
    $ sudo apt install -y containerd.io

    # remove default config file
    $ sudo mv /etc/containerd/config.toml{,.bak}

    # restart containerd services
    $ sudo systemctl restart containerd
    ```

### [kubeadm upgrade](Upgrading kubeadm clusters)

### [reconfiguring kubeadm](https://v1-28.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-reconfigure/)

### CNI

> [!NOTE|label:references:]
> - [#2695 dial tcp 10.96.0.1:443 timeout](https://github.com/projectcalico/calico/issues/2695)
> - [k8s安装插件出现dial tcp 10.96.0.1:443: i/o timeout问题解析](https://blog.csdn.net/qq_44847649/article/details/123504663)
> - [kube-flannel.yml](https://www.cnblogs.com/chaojiyingxiong/p/16896593.html)
> - [Kubernetes / Flannel – Failed to list *v1.Service](https://www.thenoccave.com/2020/08/kubernetes-flannel-failed-to-list-v1-service/)
>   - `$ cat /run/flannel/subnet.env`
>   - `$ kubectl get nodes k8s-node-01 -o jsonpath='{.spec.podCIDR}'`

- modify
  ```bash
  $ kubectl edit cm -n kube-system kube-flannel-cfg
  net-conf.json: |
       {
         "Network": "10.244.0.0/16",
         "Backend": {
           "Type": "vxlan"
         }
       }
  ```

- check
  ```bash
  $ kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'

  # e.g.: flannel
  $ kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'
  10.244.21.0/24 10.244.4.0/24 10.244.1.0/24 10.244.10.0/24 10.244.20.0/24 10.244.7.0/24 10.244.5.0/24 10.244.17.0/24 10.244.3.0/24 10.244.0.0/24 10.244.6.0/24 10.244.12.0/24 10.244.13.0/24 10.244.16.0/24 10.244.15.0/24
  ```

## troubleshooting

- `error: open /var/lib/kubelet/config.yaml: no such file or directory`
  ```bash
  Nov 17 19:25:19 kube-node-01 systemd[1]: Started kubelet: The Kubernetes Node Agent.
  Nov 17 19:25:19 kube-node-01 kubelet[28335]: F1117 19:25:19.391266   28335 server.go:190] failed to load Kubelet config file /var/lib/kubelet/config.yaml, error failed to read kubelet config file "/var/lib/kubelet/config.yaml", error: open /var/lib/kubelet/config.yaml: no such file or directory
  Nov 17 19:25:19 kube-node-01 systemd[1]: kubelet.service: Main process exited, code=exited, status=255/n/a
  Nov 17 19:25:19 kube-node-01 systemd[1]: kubelet.service: Failed with result 'exit-code'.
  ```

  - solution:
    - controller: [kubeadm init phase kubelet-start](https://stackoverflow.com/a/60301879/2940319)
      ```bash
      $ kubeadm init phase kubelet-start
      $ swapoff -a
      $ sudo bash -c "sed -e 's:^\\(.*swap.*\\)$:# \\1:' -i /etc/fstab"
      ```

    - node:
      ```bash
      $ kubeadm join api.kubernetes.com:6443 \
                --token 8*****.***************a \
                --discovery-token-ca-cert-hash sha256:e**************************************************************5 \
                --ignore-preflight-errors=all
      ```
