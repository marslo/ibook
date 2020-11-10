<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Repo Sources](#repo-sources)
- [Package Search](#package-search)
- [Installation](#installation)
- [reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Repo Sources
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


## Package Search
```bash
$ apt-cache search kub
python-magnumclient - client library for Magnum API - Python 2.x
python-magnumclient-doc - client library for Magnum API - doc
flannel - Etcd backed network fabric for containers
golang-github-kubernetes-gengo-dev - Library for generating code based on Go files
kubrick - game based on Rubik's Cube
kubuntu-debug-installer - Debug package installer for Kubuntu
kubuntu-debug-installer-dbg - Debug package installer for Kubuntu - debug symbols
kubuntu-desktop - Kubuntu Plasma Desktop/Netbook system
kubuntu-docs - kubuntu system documentation
kubuntu-driver-manager - Driver Manager for Kubuntu
kubuntu-driver-manager-dbg - Driver Manager for Kubuntu -- debug symbols
kubuntu-full - Full Kubuntu Plasma Desktop/Netbook system
kubuntu-notification-helper - Kubuntu system notification helper
kubuntu-notification-helper-dbg - Kubuntu Notification Helper debugging symbols
kubuntu-patched-l10n - Fake package containing absolutely nothing
kubuntu-settings-desktop - Settings and artwork for the Kubuntu (Desktop)
kubuntu-wallpapers-artful - Kubuntu 17.10 Wallpapers
kubuntu-web-shortcuts - web shortcuts for Kubuntu, Ubuntu, Launchpad
ldm-kubuntu-theme - Kubuntu theme for the LTSP Display Manager
libkubuntu-dbg - library for Kubuntu platform integration - debugging files
libkubuntu-dev - library for Kubuntu platform integration - development files
libkubuntu1 - library for Kubuntu platform integration
magnum-api - OpenStack containers as a service
magnum-common - OpenStack containers as a service - API server
magnum-conductor - OpenStack containers as a service - conductor
mecab-jumandic - Juman dictionary compiled for Mecab (deprecated)
mecab-jumandic-utf8 - Juman dictionary encoded in UTF-8 compiled for Mecab
plymouth-theme-kubuntu-logo - graphical boot animation and logger - kubuntu-logo theme
plymouth-theme-kubuntu-text - graphical boot animation and logger - kubuntu-text theme
python-k8sclient - Kubernetes API Python client code - Python 2.7
python-k8sclient-doc - Kubernetes API Python client code - doc
python-magnum - OpenStack containers as a service - Python library
python3-k8sclient - Kubernetes API Python client code - Python 3.x
python3-magnumclient - client library for Magnum API - Python 3.x
ruby-kubeclient - client for Kubernetes REST api
salt-formula-kubernetes - Salt formula for Kubernetes
texlive-games - TeX Live: Games typesetting
ubiquity-slideshow-kubuntu - Ubiquity slideshow for Kubuntu
uck - Tool to customize official Ubuntu Live CDs
unity-scope-home - Home scope that aggregates results from multiple scopes
kubuntu-restricted-addons - Commonly used restricted packages for Kubuntu
kubuntu-restricted-extras - Commonly used media codecs and fonts for Kubuntu
kubeadm - Kubernetes Cluster Bootstrapping Tool
kubectl - Kubernetes Command Line Tool
kubelet - Kubernetes Node Agent
kubernetes-cni - Kubernetes CNI
```

## Installation
```bash
$ sudo apt install kubeadm
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
Do you want to continue? [Y/n]
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
devops@devops-kubernetes-master:/etc/apt$
```

## reference
- [Kubernetes Recovery from Master Failure with Kubeadm](https://codefarm.me/2019/05/22/kubernetes-recovery-master-failure/)
- [1 - Kubernetes Objects](https://codefarm.me/2019/02/22/kubernetes-crash-course-1/)
- [2 - Kubernetes Pods](https://codefarm.me/2019/03/04/kubernetes-crash-course-2/)
- [3 - Kubernetes Services and Ingress](https://codefarm.me/2019/03/04/kubernetes-crash-course-3/)
- [4 - Kubernetes Storage](https://codefarm.me/2019/03/25/kubernetes-crash-course-4/)
