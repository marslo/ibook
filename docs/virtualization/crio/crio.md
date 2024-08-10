<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [config files](#config-files)
- [tips](#tips)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [cri-o/cri-o](https://github.com/cri-o/cri-o)
> - [Using the CRI-O Container Engine](https://docs.openshift.com/container-platform/3.11/crio/crio_runtime.html)
> - [kubernetes/misc/kubernetes-with-crio](https://github.com/justmeandopensource/kubernetes/tree/master/misc/kubernetes-with-crio)

## config files

- `/etc/crictl.yaml`
  ```bash
  $ sudo cat /etc/crictl.yaml
  runtime-endpoint: "unix:///var/run/crio/crio.sock"
  timeout: 0
  debug: false
  ```

  - [other version](https://github.com/cri-o/cri-o/issues/3791#issuecomment-826867283)
    ```bash
    $ sudo cat /etc/crictl.yaml
    runtime-endpoint: "unix:///run/crio/crio.sock"
    image-endpoint: "unix:///run/crio/crio.sock"
    cgroup-manager: cgroupfs

    timeout: 10
    debug: true
    pull-image-on-create: false
    ```

- [`/etc/modules-load.d/crio.conf`](https://github.com/justmeandopensource/kubernetes/tree/master/misc/kubernetes-with-crio)
  ```bash
  $ sudo cat /etc/modules-load.d/crio.conf
  overlay
  br_netfilter

  $ sudo modprobe overlay
  $ sudo modprobe br_netfilter
  ```

- [`/etc/crio/crio.conf.d/02-cgroup-manager.conf`](https://github.com/justmeandopensource/kubernetes/tree/master/misc/kubernetes-with-crio)
  ```bash
  $ sudo cat /etc/crio/crio.conf.d/02-cgroup-manager.conf
  [crio.runtime]
  conmon_cgroup = "pod"
  cgroup_manager = "cgroupfs"

  # or using `systemd` as default cgroup manager
  $ sudo cat /etc/crio/crio.conf.d/02-cgroup-manager.conf
  [crio.runtime]
  conmon_cgroup = "pod"

  $ sudo systemctl daemon-reload
  $ sudo systemctl restart crio.service
  ```

## tips

> [!NOTE|label:references:]
> - [since CRI-O v1.18.0](https://github.com/cri-o/cri-o/releases/tag/v1.18.0)
> - [#3119 - remove NET_RAW and SYS_CHROOT capability by default](https://github.com/cri-o/cri-o/pull/3119)
>   CRI-O now runs containers without `NET_RAW` and `SYS_CHROOT` capabilities by default.
>   This can result in permission denied errors when the container tries to do something that would require either of these capabilities. For instance, using ping requires `NET_RAW`, unless the container is given the sysctl net.ipv4.ip_forward.
> - [Kubernetes CRI-O Challenge | Ping permission denied | Are you root?](https://www.youtube.com/watch?v=ZKJ9oFwjosM)
