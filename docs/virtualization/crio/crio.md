<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [install](#install)
  - [prepare](#prepare)
  - [install package](#install-package)
  - [verify](#verify)
- [config](#config)
- [crictl](#crictl)
  - [remove](#remove)
- [tips](#tips)
  - [get cgroups](#get-cgroups)
- [troubleshooting](#troubleshooting)
  - [cni0](#cni0)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [cri-o/cri-o](https://github.com/cri-o/cri-o)
> - [Using the CRI-O Container Engine](https://docs.openshift.com/container-platform/3.11/crio/crio_runtime.html)
> - [kubernetes/misc/kubernetes-with-crio](https://github.com/justmeandopensource/kubernetes/tree/master/misc/kubernetes-with-crio)
> - [* Debugging Kubernetes nodes with crictl](https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl/)
> - [在Kubernetes中使用CRI-O运行时](https://juejin.cn/post/6999405898980392996)


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

### install package

> [!NOTE|label:references:]
> - [CRI-O Packaging](https://github.com/cri-o/packaging/blob/main/README.md)
> - [cri-o/packaging actions](https://github.com/cri-o/packaging/actions)
> - veriables:
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
  $ sudo dnf install -y cri-o --disableexcludes=cri-o
  # or
  $ sudo dnf install -y cri-o-1.30.3-150500.1.1.x86_64 --disableexcludes=cri-o

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
> - [#2416 - server status: add cgroup manager](https://github.com/cri-o/cri-o/pull/2416)

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

# or
$ crio status info
INFO[2024-09-06 19:23:21.790806581-07:00] Starting CRI-O, version: 1.30.4, git: dbc00ffd41a487c847158032193b6dca9b49e821(clean)
cgroup driver: systemd
storage driver: overlay
storage graph root: /var/lib/containers/storage
storage image:
default GID mappings (format <container>:<host>:<size>):
  0:0:4294967295
default UID mappings (format <container>:<host>:<size>):
  0:0:4294967295
```

## config

- `/etc/crictl.yaml`
  ```bash
  $ sudo cat /etc/crictl.yaml
  runtime-endpoint: "unix:///var/run/crio/crio.sock"
  timeout: 0
  debug: false
  ```

  - [or](https://github.com/cri-o/cri-o/issues/3791#issuecomment-826867283)
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

  # modify
  $ sudo sed -i 's/10.85.0.0/10.185.0.0/g' /etc/cni/net.d/11-crio-ipv4-bridge.conflist
  $ sudo systemctl daemon-reload
  $ sudo systemctl restart crio.service
  ```

- [`/etc/crio/crio.conf.d/01-metrics.conf`](https://github.com/cri-o/cri-o/blob/main/tutorials/metrics.md)
  ```bash
  $ sudo cat /etc/crio/crio.conf.d/01-metrics.conf
  [crio.metrics]
  enable_metrics = true
  # default is 9090
  metrics_port = 9090
  ```

  - verify:
    ```bash
    $ curl localhost:9090/metrics | grep -v '^#'
    ```

    <!--sec data-title="localhot:9090/metrics" data-id="section0" data-show=true data-collapse=true ces-->
    ```bash
    $ curl -s localhost:9090/metrics | grep -v '^#'
    container_runtime_crio_containers_events_dropped_total 0
    container_runtime_crio_containers_oom_total 0
    container_runtime_crio_image_pulls_layer_size_bucket{le="1000"} 0
    container_runtime_crio_image_pulls_layer_size_bucket{le="1e+06"} 0
    container_runtime_crio_image_pulls_layer_size_bucket{le="1e+07"} 0
    container_runtime_crio_image_pulls_layer_size_bucket{le="5e+07"} 0
    container_runtime_crio_image_pulls_layer_size_bucket{le="1e+08"} 0
    container_runtime_crio_image_pulls_layer_size_bucket{le="2e+08"} 0
    container_runtime_crio_image_pulls_layer_size_bucket{le="3e+08"} 0
    container_runtime_crio_image_pulls_layer_size_bucket{le="4e+08"} 0
    container_runtime_crio_image_pulls_layer_size_bucket{le="5e+08"} 0
    container_runtime_crio_image_pulls_layer_size_bucket{le="1e+09"} 0
    container_runtime_crio_image_pulls_layer_size_bucket{le="1e+10"} 0
    container_runtime_crio_image_pulls_layer_size_bucket{le="+Inf"} 0
    container_runtime_crio_image_pulls_layer_size_sum 0
    container_runtime_crio_image_pulls_layer_size_count 0
    container_runtime_crio_image_pulls_success_total 0
    container_runtime_crio_operations_errors_total{operation="ContainerStatus"} 5
    container_runtime_crio_operations_latency_seconds{operation="ContainerStatus"} 1.1523e-05
    container_runtime_crio_operations_latency_seconds{operation="CreateContainer"} 0.475484217
    container_runtime_crio_operations_latency_seconds{operation="ExecSync"} 0.090543277
    container_runtime_crio_operations_latency_seconds{operation="ImageFsInfo"} 0.00072969
    container_runtime_crio_operations_latency_seconds{operation="ImageStatus"} 0.000149831
    container_runtime_crio_operations_latency_seconds{operation="ListContainers"} 4.0299e-05
    container_runtime_crio_operations_latency_seconds{operation="ListImages"} 0.000504493
    container_runtime_crio_operations_latency_seconds{operation="ListPodSandbox"} 3.8221e-05
    container_runtime_crio_operations_latency_seconds{operation="PodSandboxStatus"} 2.5519e-05
    container_runtime_crio_operations_latency_seconds{operation="RemoveContainer"} 0.018241849
    container_runtime_crio_operations_latency_seconds{operation="RemoveImage"} 0.984503771
    container_runtime_crio_operations_latency_seconds{operation="RemovePodSandbox"} 0.001697702
    container_runtime_crio_operations_latency_seconds{operation="RunPodSandbox"} 0.123417422
    container_runtime_crio_operations_latency_seconds{operation="StartContainer"} 0.013815194
    container_runtime_crio_operations_latency_seconds{operation="Status"} 3.274e-05
    container_runtime_crio_operations_latency_seconds{operation="StopContainer"} 0.019264189
    container_runtime_crio_operations_latency_seconds{operation="StopPodSandbox"} 5.6215e-05
    container_runtime_crio_operations_latency_seconds{operation="Version"} 9.5257e-05
    container_runtime_crio_operations_latency_seconds{operation="network_setup_overall"} 0.117112005
    container_runtime_crio_operations_latency_seconds{operation="network_setup_pod"} 0.116541711
    container_runtime_crio_operations_latency_seconds_total{operation="ContainerStatus",quantile="0.5"} 1.7527e-05
    container_runtime_crio_operations_latency_seconds_total{operation="ContainerStatus",quantile="0.9"} 2.8625e-05
    container_runtime_crio_operations_latency_seconds_total{operation="ContainerStatus",quantile="0.99"} 4.0209e-05
    container_runtime_crio_operations_latency_seconds_total_sum{operation="ContainerStatus"} 0.09174170199999988
    container_runtime_crio_operations_latency_seconds_total_count{operation="ContainerStatus"} 4672
    container_runtime_crio_operations_latency_seconds_total{operation="CreateContainer",quantile="0.5"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="CreateContainer",quantile="0.9"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="CreateContainer",quantile="0.99"} NaN
    container_runtime_crio_operations_latency_seconds_total_sum{operation="CreateContainer"} 1.181032842
    container_runtime_crio_operations_latency_seconds_total_count{operation="CreateContainer"} 10
    container_runtime_crio_operations_latency_seconds_total{operation="ExecSync",quantile="0.5"} 0.085431263
    container_runtime_crio_operations_latency_seconds_total{operation="ExecSync",quantile="0.9"} 0.092410725
    container_runtime_crio_operations_latency_seconds_total{operation="ExecSync",quantile="0.99"} 0.154495402
    container_runtime_crio_operations_latency_seconds_total_sum{operation="ExecSync"} 111.94222211099996
    container_runtime_crio_operations_latency_seconds_total_count{operation="ExecSync"} 813
    container_runtime_crio_operations_latency_seconds_total{operation="ImageFsInfo",quantile="0.5"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="ImageFsInfo",quantile="0.9"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="ImageFsInfo",quantile="0.99"} NaN
    container_runtime_crio_operations_latency_seconds_total_sum{operation="ImageFsInfo"} 0.001633457
    container_runtime_crio_operations_latency_seconds_total_count{operation="ImageFsInfo"} 2
    container_runtime_crio_operations_latency_seconds_total{operation="ImageStatus",quantile="0.5"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="ImageStatus",quantile="0.9"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="ImageStatus",quantile="0.99"} NaN
    container_runtime_crio_operations_latency_seconds_total_sum{operation="ImageStatus"} 0.005077591
    container_runtime_crio_operations_latency_seconds_total_count{operation="ImageStatus"} 21
    container_runtime_crio_operations_latency_seconds_total{operation="ListContainers",quantile="0.5"} 3.4691e-05
    container_runtime_crio_operations_latency_seconds_total{operation="ListContainers",quantile="0.9"} 4.667e-05
    container_runtime_crio_operations_latency_seconds_total{operation="ListContainers",quantile="0.99"} 6.4189e-05
    container_runtime_crio_operations_latency_seconds_total_sum{operation="ListContainers"} 0.2532365459999996
    container_runtime_crio_operations_latency_seconds_total_count{operation="ListContainers"} 6666
    container_runtime_crio_operations_latency_seconds_total{operation="ListImages",quantile="0.5"} 0.000490407
    container_runtime_crio_operations_latency_seconds_total{operation="ListImages",quantile="0.9"} 0.000571354
    container_runtime_crio_operations_latency_seconds_total{operation="ListImages",quantile="0.99"} 0.000753937
    container_runtime_crio_operations_latency_seconds_total_sum{operation="ListImages"} 0.3214459439999998
    container_runtime_crio_operations_latency_seconds_total_count{operation="ListImages"} 582
    container_runtime_crio_operations_latency_seconds_total{operation="ListPodSandbox",quantile="0.5"} 3.9654e-05
    container_runtime_crio_operations_latency_seconds_total{operation="ListPodSandbox",quantile="0.9"} 5.0074e-05
    container_runtime_crio_operations_latency_seconds_total{operation="ListPodSandbox",quantile="0.99"} 6.4293e-05
    container_runtime_crio_operations_latency_seconds_total_sum{operation="ListPodSandbox"} 0.25878698800000016
    container_runtime_crio_operations_latency_seconds_total_count{operation="ListPodSandbox"} 6193
    container_runtime_crio_operations_latency_seconds_total{operation="PodSandboxStatus",quantile="0.5"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="PodSandboxStatus",quantile="0.9"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="PodSandboxStatus",quantile="0.99"} NaN
    container_runtime_crio_operations_latency_seconds_total_sum{operation="PodSandboxStatus"} 0.0011793539999999996
    container_runtime_crio_operations_latency_seconds_total_count{operation="PodSandboxStatus"} 37
    container_runtime_crio_operations_latency_seconds_total{operation="RemoveContainer",quantile="0.5"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="RemoveContainer",quantile="0.9"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="RemoveContainer",quantile="0.99"} NaN
    container_runtime_crio_operations_latency_seconds_total_sum{operation="RemoveContainer"} 0.113517279
    container_runtime_crio_operations_latency_seconds_total_count{operation="RemoveContainer"} 9
    container_runtime_crio_operations_latency_seconds_total{operation="RemoveImage",quantile="0.5"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="RemoveImage",quantile="0.9"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="RemoveImage",quantile="0.99"} NaN
    container_runtime_crio_operations_latency_seconds_total_sum{operation="RemoveImage"} 0.984530913
    container_runtime_crio_operations_latency_seconds_total_count{operation="RemoveImage"} 1
    container_runtime_crio_operations_latency_seconds_total{operation="RemovePodSandbox",quantile="0.5"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="RemovePodSandbox",quantile="0.9"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="RemovePodSandbox",quantile="0.99"} NaN
    container_runtime_crio_operations_latency_seconds_total_sum{operation="RemovePodSandbox"} 0.013869093
    container_runtime_crio_operations_latency_seconds_total_count{operation="RemovePodSandbox"} 6
    container_runtime_crio_operations_latency_seconds_total{operation="RunPodSandbox",quantile="0.5"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="RunPodSandbox",quantile="0.9"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="RunPodSandbox",quantile="0.99"} NaN
    container_runtime_crio_operations_latency_seconds_total_sum{operation="RunPodSandbox"} 0.76309194
    container_runtime_crio_operations_latency_seconds_total_count{operation="RunPodSandbox"} 6
    container_runtime_crio_operations_latency_seconds_total{operation="StartContainer",quantile="0.5"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="StartContainer",quantile="0.9"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="StartContainer",quantile="0.99"} NaN
    container_runtime_crio_operations_latency_seconds_total_sum{operation="StartContainer"} 0.18009194600000003
    container_runtime_crio_operations_latency_seconds_total_count{operation="StartContainer"} 10
    container_runtime_crio_operations_latency_seconds_total{operation="Status",quantile="0.5"} 2.3927e-05
    container_runtime_crio_operations_latency_seconds_total{operation="Status",quantile="0.9"} 3.4041e-05
    container_runtime_crio_operations_latency_seconds_total{operation="Status",quantile="0.99"} 4.2226e-05
    container_runtime_crio_operations_latency_seconds_total_sum{operation="Status"} 0.021624871000000014
    container_runtime_crio_operations_latency_seconds_total_count{operation="Status"} 809
    container_runtime_crio_operations_latency_seconds_total{operation="StopContainer",quantile="0.5"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="StopContainer",quantile="0.9"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="StopContainer",quantile="0.99"} NaN
    container_runtime_crio_operations_latency_seconds_total_sum{operation="StopContainer"} 0.411804006
    container_runtime_crio_operations_latency_seconds_total_count{operation="StopContainer"} 6
    container_runtime_crio_operations_latency_seconds_total{operation="StopPodSandbox",quantile="0.5"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="StopPodSandbox",quantile="0.9"} NaN
    container_runtime_crio_operations_latency_seconds_total{operation="StopPodSandbox",quantile="0.99"} NaN
    container_runtime_crio_operations_latency_seconds_total_sum{operation="StopPodSandbox"} 1.156116755
    container_runtime_crio_operations_latency_seconds_total_count{operation="StopPodSandbox"} 12
    container_runtime_crio_operations_latency_seconds_total{operation="Version",quantile="0.5"} 8.5387e-05
    container_runtime_crio_operations_latency_seconds_total{operation="Version",quantile="0.9"} 0.000112424
    container_runtime_crio_operations_latency_seconds_total{operation="Version",quantile="0.99"} 0.000529564
    container_runtime_crio_operations_latency_seconds_total_sum{operation="Version"} 0.03793896699999996
    container_runtime_crio_operations_latency_seconds_total_count{operation="Version"} 396
    container_runtime_crio_operations_total{operation="ContainerStatus"} 4672
    container_runtime_crio_operations_total{operation="CreateContainer"} 10
    container_runtime_crio_operations_total{operation="ExecSync"} 813
    container_runtime_crio_operations_total{operation="ImageFsInfo"} 2
    container_runtime_crio_operations_total{operation="ImageStatus"} 21
    container_runtime_crio_operations_total{operation="ListContainers"} 6666
    container_runtime_crio_operations_total{operation="ListImages"} 582
    container_runtime_crio_operations_total{operation="ListPodSandbox"} 6193
    container_runtime_crio_operations_total{operation="PodSandboxStatus"} 37
    container_runtime_crio_operations_total{operation="RemoveContainer"} 9
    container_runtime_crio_operations_total{operation="RemoveImage"} 1
    container_runtime_crio_operations_total{operation="RemovePodSandbox"} 6
    container_runtime_crio_operations_total{operation="RunPodSandbox"} 6
    container_runtime_crio_operations_total{operation="StartContainer"} 10
    container_runtime_crio_operations_total{operation="Status"} 809
    container_runtime_crio_operations_total{operation="StopContainer"} 6
    container_runtime_crio_operations_total{operation="StopPodSandbox"} 12
    container_runtime_crio_operations_total{operation="Version"} 396
    container_runtime_crio_processes_defunct 0
    containerd_cri_input_bytes_total 0
    containerd_cri_input_entries_total 0
    containerd_cri_output_bytes_total 0
    containerd_cri_output_entries_total 0
    containerd_cri_split_entries_total 0
    go_gc_duration_seconds{quantile="0"} 5.5867e-05
    go_gc_duration_seconds{quantile="0.25"} 9.8548e-05
    go_gc_duration_seconds{quantile="0.5"} 0.00012298
    go_gc_duration_seconds{quantile="0.75"} 0.000165111
    go_gc_duration_seconds{quantile="1"} 0.000303457
    go_gc_duration_seconds_sum 0.012383793
    go_gc_duration_seconds_count 92
    go_goroutines 38
    go_info{version="go1.22.0"} 1
    go_memstats_alloc_bytes 1.1737336e+07
    go_memstats_alloc_bytes_total 6.76651384e+08
    go_memstats_buck_hash_sys_bytes 1.570182e+06
    go_memstats_frees_total 5.838505e+06
    go_memstats_gc_sys_bytes 3.905472e+06
    go_memstats_heap_alloc_bytes 1.1737336e+07
    go_memstats_heap_idle_bytes 9.37984e+06
    go_memstats_heap_inuse_bytes 1.7620992e+07
    go_memstats_heap_objects 86421
    go_memstats_heap_released_bytes 4.440064e+06
    go_memstats_heap_sys_bytes 2.7000832e+07
    go_memstats_last_gc_time_seconds 1.7260239921528594e+09
    go_memstats_lookups_total 0
    go_memstats_mallocs_total 5.924926e+06
    go_memstats_mcache_inuse_bytes 38400
    go_memstats_mcache_sys_bytes 46800
    go_memstats_mspan_inuse_bytes 447200
    go_memstats_mspan_sys_bytes 489600
    go_memstats_next_gc_bytes 1.8742896e+07
    go_memstats_other_sys_bytes 4.298866e+06
    go_memstats_stack_inuse_bytes 2.359296e+06
    go_memstats_stack_sys_bytes 2.359296e+06
    go_memstats_sys_bytes 3.9671048e+07
    go_threads 29
    process_cpu_seconds_total 11.68
    process_max_fds 1.048576e+06
    process_open_fds 58
    process_resident_memory_bytes 8.318976e+07
    process_start_time_seconds 1.72601996066e+09
    process_virtual_memory_bytes 3.351724032e+09
    process_virtual_memory_max_bytes 1.8446744073709552e+19
    promhttp_metric_handler_requests_in_flight 1
    promhttp_metric_handler_requests_total{code="200"} 6
    promhttp_metric_handler_requests_total{code="500"} 0
    promhttp_metric_handler_requests_total{code="503"} 0
    ```
    <!--endsec-->

- `/etc/containers/registries.conf.d/01-unqualified.conf`

  ```bash
  unqualified-search-registries = ["docker.io", "quay.io"]
  ```

## crictl

### remove
- stop all pods
  ```bash
  $ crictl pods -q | xargs -r crictl -t 60s stopp

  # force remove all
  $ crictl rmp -a -f

  # or (rescue)
  $ ip netns list | cut -d' ' -f 1 | xargs -n1 ip netns delete && crictl rmp -a -f
  ```

- remove all containers
  ```bash
  $ crictl ps -a -q | xargs crictl rm

  # or
  $ crictl rm -a -q
  ```

## tips

> [!NOTE|label:references:]
> - [since CRI-O v1.18.0](https://github.com/cri-o/cri-o/releases/tag/v1.18.0)
> - [#3119 - remove NET_RAW and SYS_CHROOT capability by default](https://github.com/cri-o/cri-o/pull/3119)
>   - CRI-O now runs containers without `NET_RAW` and `SYS_CHROOT` capabilities by default.
>   - This can result in permission denied errors when the container tries to do something that would require either of these capabilities. For instance, using ping requires `NET_RAW`, unless the container is given the sysctl net.ipv4.ip_forward.
> - [Kubernetes CRI-O Challenge | Ping permission denied | Are you root?](https://www.youtube.com/watch?v=ZKJ9oFwjosM)

### get cgroups
```bash
$ curl -s --unix-socket /var/run/crio/crio.sock http://localhost/info | jq -r .cgroup_driver
systemd
```

## troubleshooting
### cni0

> [!NOTE|label:references:]
> - [#6131 - contrib/cni/11-crio-ipv4-bridge.conf does not work out of the box](https://github.com/cri-o/cri-o/issues/6131)
>   ```bash
>   # debug via:
>   $ strace -s2048 -f -p $(pidof crio)
>   ```
> - [#2411 - cri-o w/ Kubernetes v1.14 connects pods to wrong subnets when using Weave or kube-router or Flannel CNI plugin](https://github.com/cri-o/cri-o/issues/2411)
> - [Kubernetes之network: failed to set bridge addr: “cni0“ already has an IP address different from xxx问题](https://blog.csdn.net/qq_40460909/article/details/114706367)
> - [解决k8s"failed to set bridge addr: "cni0" already has an IP address different from 10.244.1.1/24"](https://blog.csdn.net/Wuli_SmBug/article/details/104712653)
> - [#3555 - crio on minikube: could not add IP address to "cni0": permission denied](https://github.com/cri-o/cri-o/issues/3555)
> - [#5799 - what the Additional steps for crio when install Third party network plugin like calico flannel](https://github.com/cri-o/cri-o/issues/5799)
> - [#2572 - kubeadm init with pod-network-cidr but still remains using 10.85.0.0](https://github.com/kubernetes/kubeadm/issues/2572)
> - [#39557 - "Failed to setup network for pod \ using network plugins \"cni\": no IP addresses available in network: podnet; Skipping pod"](https://github.com/kubernetes/kubernetes/issues/39557)
