<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [basic environment](#basic-environment)
  - [Ubuntu](#ubuntu)
  - [CentOS/RHEL](#centosrhel)
  - [Q&A](#qa)
- [tricky](#tricky)
  - [list images](#list-images)
  - [get or modify kubeadm.yaml](#get-or-modify-kubeadmyaml)
  - [show default `KubeletConfiguration`](#show-default-kubeletconfiguration)
  - [show defualt kubeadm config](#show-defualt-kubeadm-config)
  - [kubeadm join](#kubeadm-join)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference :
> - [* install tools](https://kubernetes.io/docs/tasks/tools/)
> - [* Bootstrapping clusters with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/_print/)
> - [* 使用 kubeadm 创建集群](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
> - [* Implementation details](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/)
> - [cURLing the Kubernetes API server](https://nieldw.medium.com/curling-the-kubernetes-api-server-d7675cfc398c)
> - [Troubleshooting kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/)
> - [Kubernetes Recovery from Master Failure with Kubeadm](https://codefarm.me/2019/05/22/kubernetes-recovery-master-failure/)
> - [1 - Kubernetes Objects](https://codefarm.me/2019/02/22/kubernetes-crash-course-1/)
> - [2 - Kubernetes Pods](https://codefarm.me/2019/03/04/kubernetes-crash-course-2/)
> - [3 - Kubernetes Services and Ingress](https://codefarm.me/2019/03/04/kubernetes-crash-course-3/)
> - [4 - Kubernetes Storage](https://codefarm.me/2019/03/25/kubernetes-crash-course-4/)
> - [authenticating with bootstrap token](https://kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/)
> - [kubernetes/design-proposals-archive](https://github.com/kubernetes/design-proposals-archive/blob/main/cluster-lifecycle/bootstrap-discovery.md)
> - [design-proposals-archive/cluster-lifecycle/cluster-deployment.md](https://github.com/kubernetes/design-proposals-archive/blob/main/cluster-lifecycle/cluster-deployment.md)
> - [How to Upgrade Kubernetes Cluster Using Kubeadm?](https://devopscube.com/upgrade-kubernetes-cluster-kubeadm/)
{% endhint %}


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

### Q&A
#### [problem with installed package podman](https://forums.docker.com/t/problem-with-installed-package-podman/116529/2)

- issue
  ```bash
  $ sudo yum install docker-ce-19.03.15-3.el8 docker-ce-cli-19.03.15-3.el8 containerd.io docker-buildx-plugin docker-compose-plugin
  Docker CE Stable - x86_64                                                              272 kB/s |  43 kB     00:00
  Error:
   Problem 1: problem with installed package podman-1.6.4-10.module_el8.2.0+305+5e198a41.x86_64
    - package podman-1.6.4-10.module_el8.2.0+305+5e198a41.x86_64 requires runc >= 1.0.0-57, but none of the providers can be installed
    - package podman-3.3.1-9.module_el8.5.0+988+b1f0b741.x86_64 requires runc >= 1.0.0-57, but none of the providers can be installed
    - package containerd.io-1.6.21-3.1.el8.x86_64 conflicts with runc provided by runc-1.0.0-65.rc10.module_el8.2.0+305+5e198a41.x86_64
    - package containerd.io-1.6.21-3.1.el8.x86_64 obsoletes runc provided by runc-1.0.0-65.rc10.module_el8.2.0+305+5e198a41.x86_64
    - package containerd.io-1.6.21-3.1.el8.x86_64 conflicts with runc provided by runc-1.0.2-1.module_el8.5.0+911+f19012f9.x86_64
    - package containerd.io-1.6.21-3.1.el8.x86_64 obsoletes runc provided by runc-1.0.2-1.module_el8.5.0+911+f19012f9.x86_64
    - cannot install the best candidate for the job
    - package runc-1.0.0-66.rc10.module_el8.5.0+1004+c00a74f5.x86_64 is filtered out by modular filtering
    - package runc-1.0.0-72.rc92.module_el8.5.0+1006+8d0e68a2.x86_64 is filtered out by modular filtering
   Problem 2: problem with installed package buildah-1.11.6-7.module_el8.2.0+305+5e198a41.x86_64
    - package buildah-1.11.6-7.module_el8.2.0+305+5e198a41.x86_64 requires runc >= 1.0.0-26, but none of the providers can be installed
    ...
    - package buildah-1.11.6-7.module_el8.2.0+305+5e198a41.x86_64 requires runc >= 1.0.0-26, but none of the providers can be installed
    - package buildah-1.22.3-2.module_el8.5.0+911+f19012f9.x86_64 requires runc >= 1.0.0-26, but none of the providers can be installed
    - package containerd.io-1.3.7-3.1.el8.x86_64 conflicts with runc provided by runc-1.0.0-65.rc10.module_el8.2.0+305+5e198a41.x86_64
    ...
  ```
- [solution : remove podman](https://www.ibm.com/docs/en/eam/4.2?topic=questions-troubleshooting-tips#uninstall_podman)
  ```bash
  $ yum remove buildah skopeo podman containers-common atomic-registries docker container-tools
  $ rm -rf /etc/containers/* /var/lib/containers/* /etc/docker /etc/subuid* /etc/subgid*
  $ cd ~ && rm -rf /.local/share/containers/
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
$ kubeadm config images list --config=config.yaml

# to pull images
$ kubeadm config images pull [--config=config.yaml]
```

### [get or modify kubeadm.yaml](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#save-the-kubeadm-clusterconfiguration-in-a-configmap-for-later-reference)

> [!TIP]
> kubeadm saves the configuration passed to `kubeadm init` in a ConfigMap named `kubeadm-config` under `kube-system` namespace.
> This will ensure that kubeadm actions executed in future (e.g `kubeadm upgrade`) will be able to determine the actual/current cluster state and make new decisions based on that data.
> Please note that:
> - Before saving the `ClusterConfiguration`, sensitive information like the token is stripped from the configuration
> - Upload of control plane node configuration can be invoked individually with the [`kubeadm init phase upload-config`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init-phase/#cmd-phase-upload-config) command

```bash
$ k -n kube-system get cm kubeadm-config -o yaml
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

### show defualt kubeadm config

{% hint style='tip' %}
[imarslo: get or modify kubeadm.yaml](#get-or-modify-kubeadmyaml)
{% endhint %}

```bash
$ sudo kubeadm config view

# or
$ kubectl -n kube-system get cm kubeadm-config -o yaml
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
