<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [configuration files](#configuration-files)
  - [systemd](#systemd)
  - [kubelet](#kubelet)

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
