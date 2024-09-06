<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [config files](#config-files)
- [install](#install)
  - [prepare](#prepare)
  - [install](#install-1)
  - [verify](#verify)
- [tips](#tips)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [cri-o/cri-o](https://github.com/cri-o/cri-o)
> - [Using the CRI-O Container Engine](https://docs.openshift.com/container-platform/3.11/crio/crio_runtime.html)
> - [kubernetes/misc/kubernetes-with-crio](https://github.com/justmeandopensource/kubernetes/tree/master/misc/kubernetes-with-crio)
> - [Debugging Kubernetes nodes with crictl](https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl/)
> - [在Kubernetes中使用CRI-O运行时](https://juejin.cn/post/6999405898980392996)

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

- [`/etc/cni/net.d/11-crio-ipv4-bridge.conflist`](https://blog.csdn.net/weixin_43323107/article/details/128535741)

  > [!NOTE|label:references:]
  > - [cri-o/cri-o](https://github.com/cri-o/cri-o/blob/main/contrib/cni/11-crio-ipv4-bridge.conflist)
  > - modify via:
  >   ```bash
  >   $ sudo sed -i 's/10.85.0.0/10.244.0.0/g' /etc/cni/net.d/11-crio-ipv4-bridge.conflist
  >   $ sudo systemctl daemon-reload
  >   $ sudo systemctl restart crio.service
  >   ```

  ```bash
  $ cat /etc/cni/net.d/11-crio-ipv4-bridge.conflist
  {
    "cniVersion": "1.0.0",
    "name": "crio",
    "plugins": [
      {
        "type": "bridge",
        "bridge": "cni0",
        "isGateway": true,
        "ipMasq": true,
        "hairpinMode": true,
        "ipam": {
          "type": "host-local",
          "routes": [
              { "dst": "0.0.0.0/0" }
          ],
          "ranges": [
              [{ "subnet": "10.85.0.0/16" }]
          ]
        }
      }
    ]
  }
  ```

## install

### prepare

- enable kernel
  ```bash
  $ sudo modprobe overlay
  $ sudo modprobe br_netfilter
  ```

- modify kernel parameters
  ```bash
  $ sudo bash -c "cat >>/etc/sysctl.d/99-kubernetes-crio.conf" << EOF
  net.ipv4.ip_forward = 1
  net.bridge.bridge-nf-call-iptables = 1
  net.bridge.bridge-nf-call-ip6tables = 1
  EOF
  $ sudo sysctl --system

  # or
  $ sudo sysctl -w net.ipv4.ip_forward=1
  $ sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
  $ sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=1
  ```

### install

> [!NOTE|label:references:]
> - [CRI-O Packaging](https://github.com/cri-o/packaging/blob/main/README.md)
> - [cri-o/packaging actions](https://github.com/cri-o/packaging/actions)
> - version define:
>   ```bash
>   $ CRIO_VERSION='v1.30'
>   ```

- rhel
  ```bash
  $ cat <<EOF | sudo tee /etc/yum.repos.d/cri-o.repo
  [cri-o]
  name=CRI-O
  baseurl=https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/rpm/
  enabled=1
  gpgcheck=1
  gpgkey=https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/rpm/repodata/repomd.xml.key
  exclude=cri-o
  EOF

  $ sudo bash -c "cat >>/etc/modules-load.d/crio.conf" << EOF
  overlay
  br_netfilter
  EOF

  $ sudo dnf install -y container-selinux
  $ sudo dnf install -y cri-o

  $ sudo systemctl enable --now crio.service

  # lock cri-o from auto upgrade
  $ sudo tail -1 /etc/yum.repos.d/cri-o.repo
  exclude=cri-o
  ```

- debian
  ```bash
  $ sudo apt-get update
  $ sudo apt-get install -y software-properties-common curl

  $ curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key |
      gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
  $ echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/stable:/$CRIO_VERSION/deb/ /" |
      tee /etc/apt/sources.list.d/cri-o.list

  $ apt-get update
  $ apt-get install -y cri-o
  ```

- static binary bundles
  ```bash
  # latest
  $ curl https://raw.githubusercontent.com/cri-o/packaging/main/get | bash

  # specific version
  $ curl https://raw.githubusercontent.com/cri-o/packaging/main/get | bash -s -- -t v1.30.0

  # specific architectures
  $ curl https://raw.githubusercontent.com/cri-o/packaging/main/get | bash -s -- -a arm64
  ```

### verify

> [!NOTE|label:references:]
>

```bash
$ curl -v --unix-socket /var/run/crio/crio.sock http://localhost/info
*   Trying /var/run/crio/crio.sock...
* Connected to localhost (/var/run/crio/crio.sock) port 80 (#0)
> GET /info HTTP/1.1
> Host: localhost
> User-Agent: curl/7.61.1
> Accept: */*
>
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Fri, 06 Sep 2024 21:49:40 GMT
< Content-Length: 258
<
* Connection #0 to host localhost left intact
{"storage_driver":"overlay","storage_image":"","storage_root":"/var/lib/containers/storage","cgroup_driver":"systemd","default_id_mappings":{"uids":[{"container_id":0,"host_id":0,"size":4294967295}],"gids":[{"container_id":0,"host_id":0,"size":4294967295}]}}
```

## tips

> [!NOTE|label:references:]
> - [since CRI-O v1.18.0](https://github.com/cri-o/cri-o/releases/tag/v1.18.0)
> - [#3119 - remove NET_RAW and SYS_CHROOT capability by default](https://github.com/cri-o/cri-o/pull/3119)
>   - CRI-O now runs containers without `NET_RAW` and `SYS_CHROOT` capabilities by default.
>   - This can result in permission denied errors when the container tries to do something that would require either of these capabilities. For instance, using ping requires `NET_RAW`, unless the container is given the sysctl net.ipv4.ip_forward.
> - [Kubernetes CRI-O Challenge | Ping permission denied | Are you root?](https://www.youtube.com/watch?v=ZKJ9oFwjosM)
