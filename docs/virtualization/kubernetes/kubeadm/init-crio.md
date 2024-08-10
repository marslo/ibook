<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [CRI-O](#cri-o)
- [kubeadm](#kubeadm)
  - [show default kubeadm-config.yaml](#show-default-kubeadm-configyaml)
- [init](#init)
  - [add another control plane node](#add-another-control-plane-node)
  - [Uploading control-plane certificates to the cluster](#uploading-control-plane-certificates-to-the-cluster)
- [HA Cluster](#ha-cluster)
  - [extend etcd](#extend-etcd)
- [CNI](#cni)
- [teardown](#teardown)
- [other references](#other-references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


> [!NOTE|label:references:]
> - kubernetes official:
>   - [Container Runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
> - others:
>   - [K8S集群搭建——cri-dockerd版（包含问题解决方案）](https://blog.csdn.net/qq_61468858/article/details/139063860)
>   - [ubernetes那些事 —— 使用cri-o作为容器运行时](https://zhuanlan.zhihu.com/p/334766611)
>   - [* Kubernetes provisioning with CRI-O as container runtime](https://github.com/justmeandopensource/kubernetes/tree/master/misc/kubernetes-with-crio)

## CRI-O

> [!NOTE|label:references:]
> - [cri-o/cri-o-ansible](https://github.com/cri-o/cri-o-ansible)
> - [kubernetes/misc/kubernetes-with-crio](https://github.com/justmeandopensource/kubernetes/tree/master/misc/kubernetes-with-crio)

## kubeadm

> [!NOTE|label:references:]
> - [* Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-runtime)
> - [Installing Kubernetes with deployment tools](https://kubernetes.io/docs/setup/production-environment/tools/)
> - [Bootstrapping clusters with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/)
> - [Troubleshooting kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/)

### show default kubeadm-config.yaml

> [!TIP|label:references:]
> - [* kubeadm Configuration (v1beta3)](https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta3/)
>   - [ClusterConfiguration](https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta3/#kubeadm-k8s-io-v1beta3-ClusterConfiguration)
>   - [InitConfiguration](https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta3/#kubeadm-k8s-io-v1beta3-InitConfiguration)
>   - [JoinConfiguration](https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta3/#kubeadm-k8s-io-v1beta3-JoinConfiguration)

```bash
$ kubeadm config print init-defaults
apiVersion: kubeadm.k8s.io/v1beta3
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 1.2.3.4
  bindPort: 6443
nodeRegistration:
criSocket: unix:///var/run/containerd/containerd.sock   # unix:///var/run/crio/crio.sock ( same with /etc/crictl.yaml )
  imagePullPolicy: IfNotPresent
  name: node
  taints: null
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns: {}
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: registry.k8s.io
kind: ClusterConfiguration
kubernetesVersion: 1.30.0
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
scheduler: {}

```

## init

> [!NOTE|label:references:]
> - official doc:
>   - [* Reconfiguring a kubeadm cluster](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-reconfigure/)
>   - [* Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
> - references:
>   - [* 使用CRI-O 和 Kubeadm 搭建高可用 Kubernetes 集群](https://github.com/xujiyou/blog-data/blob/master/%E4%BA%91%E5%8E%9F%E7%94%9F/CRI-O/%E4%BD%BF%E7%94%A8CRI-O%E5%92%8CKubeadm%E6%90%AD%E5%BB%BA%E9%AB%98%E5%8F%AF%E7%94%A8%20Kubernetes%20%E9%9B%86%E7%BE%A4.md)
>   - [通过cri-o部署k8s集群环境](https://blog.csdn.net/weixin_64334766/article/details/133687425)
>   - [Cri-O方式部署Kubernetes集群](https://blog.csdn.net/weixin_72583321/article/details/139256731)
>   - [* 使用 Kubeadm 和 CRI-O 在 Rocky Linux 8 上安装 Kubernetes 集群](https://blog.csdn.net/wchbest/article/details/131038029)
>   - [Kubernetes provisioning with CRI-O as container runtime](https://github.com/justmeandopensource/kubernetes/tree/master/misc/kubernetes-with-crio)
>   - [Creating Kubernetes Cluster With CRI-O Container Runtime](https://cloudyuga.guru/blogs/creating-kubernetes-cluster-with-cri-o-container-runtime/)
>   - [Kubernetes 1.23 + CRI-O](https://blog.kubesimplify.com/kubernetes-crio)
>   - [How To Deploy a Kubernetes Cluster Using the CRI-O Container Runtime](https://earthly.dev/blog/deploy-kubernetes-cri-o-container-runtime/)
>   - [Using kubeadm with CRI-O](https://projectatomic.io/blog/2017/06/using-kubeadm-with-cri-o/)
>   - [Install Kubernetes using kubeadm](https://blog.codefarm.me/2019/01/28/bootstrapping-kubernetes-clusters-with-kubeadm/)
>   - [Deploying k8s on Oracle Linux 8](https://juanjo.garciaamaya.com/posts/k8s/deploying-k8s-on-oracle-linux-8/)
> - video:
>   - [Kubernetes cluster with CRI-O container runtime | Step by step tutorial](https://www.youtube.com/watch?v=bV5RcNiHlfw)
>   - [Kubernetes CRI-O Challenge | Ping permission denied | Are you root?](https://www.youtube.com/watch?v=ZKJ9oFwjosM)

```bash
$ sudo kubeadm init --config kubeadm-config.yaml --upload-certs
```

### add another control plane node
```bash
$ kubeadm join 10.28.63.16:6443 --token abcdef.0123456789abcdef \
    --discovery-token-ca-cert-hash sha256:23868e8ddd7888c412d5579d8d1d3e6ae7678d19e146bbae86106767c2c45add \
    --control-plane --certificate-key 1c67096a3e1938d552eafbc913f8ef7d0ee966b097da21ce0c508603b29540ea
```

- [`--discovery-token-ca-cert-hash`](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#join-nodes)
  ```bash
  $ openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | \
            openssl rsa -pubin -outform der 2>/dev/null | \
            openssl dgst -sha256 -hex | sed 's/^.* //'
  ```

### [Uploading control-plane certificates to the cluster](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#uploading-control-plane-certificates-to-the-cluster)
```bash
$ sudo kubeadm init phase upload-certs --upload-certs --config=SOME_YAML_FILE
```

## HA Cluster

> [!TIP|label:references:]
> - references:
>   - [Creating Highly Available Clusters with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/)
>   - [kubernetes/kubeadm-ha-keepalived-haproxy](https://github.com/justmeandopensource/kubernetes/tree/master/kubeadm-ha-keepalived-haproxy/external-keepalived-haproxy)
>   - [kubernetes/kubeadm-ha-multi-master](https://github.com/justmeandopensource/kubernetes/tree/master/kubeadm-ha-multi-master)
> - video:
>   - [Set up highly available Kubernetes cluster step by step | Keepalived & Haproxy](https://www.youtube.com/watch?v=SueeqeioyKYSet up multi master Kubernetes cluster using Kubeadm)
>   - [Set up multi master Kubernetes cluster using Kubeadm](https://www.youtube.com/watch?v=c1SCdv2hYDc)

### extend etcd

> [!TIP|label:references:]
> - [Set up a High Availability etcd Cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/)

## CNI

> [!NOTE|label:references:]
> - [Is there a way to assign pod-network-cidr in kubeadm after initialization?](https://stackoverflow.com/a/60944959/2940319)
> - [Install a Network Policy Provider](https://kubernetes.io/docs/tasks/administer-cluster/network-policy-provider/)
>   - [Use Calico for NetworkPolicy](https://kubernetes.io/docs/tasks/administer-cluster/network-policy-provider/calico-network-policy/)
> - [Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/)
> - [Declare Network Policy](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy/)



## teardown

> [!NOTE|label:references:]
> - [Clean up](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tear-down)

```bash
$ sudo kubeadm reset --cri-socket /var/run/crio/crio.sock
$ sudo kubeadm reset
$ iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
$ ipvsadm -C
```

## other references

- `kubeadm config print init-defaults --component-configs KubeletConfiguration`

  <!--sec data-title="KubeletConfiguration" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  $ kubeadm config print init-defaults --component-configs KubeletConfiguration
  apiVersion: kubeadm.k8s.io/v1beta3
  bootstrapTokens:
  - groups:
    - system:bootstrappers:kubeadm:default-node-token
    token: abcdef.0123456789abcdef
    ttl: 24h0m0s
    usages:
    - signing
    - authentication
  kind: InitConfiguration
  localAPIEndpoint:
    advertiseAddress: 1.2.3.4
    bindPort: 6443
  nodeRegistration:
    criSocket: unix:///var/run/containerd/containerd.sock
    imagePullPolicy: IfNotPresent
    name: node
    taints: null
  ---
  apiServer:
    timeoutForControlPlane: 4m0s
  apiVersion: kubeadm.k8s.io/v1beta3
  certificatesDir: /etc/kubernetes/pki
  clusterName: kubernetes
  controllerManager: {}
  dns: {}
  etcd:
    local:
      dataDir: /var/lib/etcd
  imageRepository: registry.k8s.io
  kind: ClusterConfiguration
  kubernetesVersion: 1.30.0
  networking:
    dnsDomain: cluster.local
    serviceSubnet: 10.96.0.0/12
  scheduler: {}
  ---
  apiVersion: kubelet.config.k8s.io/v1beta1
  authentication:
    anonymous:
      enabled: false
    webhook:
      cacheTTL: 0s
      enabled: true
    x509:
      clientCAFile: /etc/kubernetes/pki/ca.crt
  authorization:
    mode: Webhook
    webhook:
      cacheAuthorizedTTL: 0s
      cacheUnauthorizedTTL: 0s
  cgroupDriver: systemd
  clusterDNS:
  - 10.96.0.10
  clusterDomain: cluster.local
  containerRuntimeEndpoint: ""
  cpuManagerReconcilePeriod: 0s
  evictionPressureTransitionPeriod: 0s
  fileCheckFrequency: 0s
  healthzBindAddress: 127.0.0.1
  healthzPort: 10248
  httpCheckFrequency: 0s
  imageMaximumGCAge: 0s
  imageMinimumGCAge: 0s
  kind: KubeletConfiguration
  logging:
    flushFrequency: 0
    options:
      json:
        infoBufferSize: "0"
      text:
        infoBufferSize: "0"
    verbosity: 0
  memorySwap: {}
  nodeStatusReportFrequency: 0s
  nodeStatusUpdateFrequency: 0s
  rotateCertificates: true
  runtimeRequestTimeout: 0s
  shutdownGracePeriod: 0s
  shutdownGracePeriodCriticalPods: 0s
  staticPodPath: /etc/kubernetes/manifests
  streamingConnectionIdleTimeout: 0s
  syncFrequency: 0s
  volumeStatsAggPeriod: 0s
  ```
  <!--endsec-->

