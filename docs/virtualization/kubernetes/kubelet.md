<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [configuration files](#configuration-files)
  - [systemd](#systemd)
  - [kubelet](#kubelet)
- [kuabelet configration](#kuabelet-configration)
  - [change kubelet root dir](#change-kubelet-root-dir)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## [configuration files](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/kubelet-integration/)
### systemd
- service configure : `/etc/systemd/system/kubelet.service.d/10-kubeadm.conf`
- environment file : `/etc/sysconfig/kubelet`

### kubelet
- kubeconfig, kubelet configuration file :
  - `/etc/kubernetes/kubelet.conf`
- kubeConfig file to use for the TLS Bootstrap, (it is only used if `/etc/kubernetes/kubelet.conf` does not exist):
  - `/etc/kubernetes/bootstrap-kubelet.conf`
- file containing the kubelet's ComponentConfig, workflow in `kubelet init` :
  - `/var/lib/kubelet/config.yaml`
- dynamic environment file that contains `KUBELET_KUBEADM_ARGS` :
  - `/var/lib/kubelet/kubeadm-flags.env`
- user-specified flag overrides with `KUBELET_EXTRA_ARGS` :
  - `/etc/default/kubelet` (for DEBs)
  - `/etc/sysconfig/kubelet` (for RPMs)


## kuabelet configration

> [!TIP]
> references: <br>
> - [kubelet flag](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/) 
>   - `--root-dir` string     Default: `/var/lib/kubelet`

### [change kubelet root dir](https://stackoverflow.com/a/53228571/2940319)
```bash
$ cat /etc/sysconfig/kubelet
KUBELET_EXTRA_ARGS=--root-dir=/path/to/extra/folder

$ grep EnvironmentFile /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
EnvironmentFile=-/etc/sysconfig/kubelet

$ systemctl daemon-reload
$ systemctl enable kubelet --now
$ systemctl start kubelet
```
- [or add `KUBELET_EXTRA_ARGS`](https://stackoverflow.com/a/46065250/2940319) :
  ```bash
  $ cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
  ...
  Environment="KUBELET_EXTRA_ARGS=$KUBELET_EXTRA_ARGS --root-dir=/path/to/extra/folder"
  ...
  ```

- full content of `/etc/systemd/system/kubelet.service.d/10-kubeadm.conf`
  ```bash
  $ cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
  # Note: This dropin only works with kubeadm and kubelet v1.11+
  [Service]
  Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
  Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
  # This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
  EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
  # This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
  # the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
  EnvironmentFile=-/etc/sysconfig/kubelet
  ExecStart=
  ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
  ```
