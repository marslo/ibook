<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [CRI-O](#cri-o)
- [kubeadm](#kubeadm)
  - [show default kubeadm-config.yaml](#show-default-kubeadm-configyaml)
- [init](#init)
  - [init first control pannel](#init-first-control-pannel)
  - [add another control plane node](#add-another-control-plane-node)
  - [reupload certificate](#reupload-certificate)
  - [HA Cluster](#ha-cluster)
  - [extend etcd](#extend-etcd)
  - [verify](#verify)
- [CNI](#cni)
- [addons](#addons)
  - [helm](#helm)
  - [TSL](#tsl)
  - [kubernetes-dashboard](#kubernetes-dashboard)
  - [ingress-nginx](#ingress-nginx)
  - [grafana](#grafana)
  - [metrics-server](#metrics-server)
- [teardown](#teardown)
- [troubleshooting](#troubleshooting)
  - [scheduler and controller-manager unhealthy](#scheduler-and-controller-manager-unhealthy)
- [other references](#other-references)
  - [calico tools](#calico-tools)
  - [kubecolor](#kubecolor)
  - [bash completion](#bash-completion)
  - [kubeadm-conf.yaml](#kubeadm-confyaml)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


> [!NOTE|label:references:]
> - kubernetes official:
>   - [Container Runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
> - others:
>   - [K8S集群搭建——cri-dockerd版（包含问题解决方案）](https://blog.csdn.net/qq_61468858/article/details/139063860)
>   - [ubernetes那些事 —— 使用cri-o作为容器运行时](https://zhuanlan.zhihu.com/p/334766611)
>   - [* Kubernetes provisioning with CRI-O as container runtime](https://github.com/justmeandopensource/kubernetes/tree/master/misc/kubernetes-with-crio)
>   - [kubeadm keepalived haproxy containerd部署高可用k8s集群](https://blog.csdn.net/shoujiyanzhen/article/details/120673624)
>   - [* kubeadm-conf.yaml: 1、Kubernetes核心技术 - 高可用集群搭建（kubeadm+keepalived+haproxy）](https://blog.csdn.net/Weixiaohuai/article/details/135478349)

## CRI-O

> [!NOTE|label:references:]
> - [cri-o/cri-o-ansible](https://github.com/cri-o/cri-o-ansible)
> - [kubernetes/misc/kubernetes-with-crio](https://github.com/justmeandopensource/kubernetes/tree/master/misc/kubernetes-with-crio)

```bash
$ sudo dnf-3 install -y cri-o-1.30.4-150500.1.1 --disableexcludes=cri-o
$ sudo sed -i 's/10.85.0.0/10.96.0.0/g' /etc/cni/net.d/11-crio-ipv4-bridge.conflist
$ sudo systemctl daemon-reload

$ sudo systemctl enable crio --now
$ sudo systemctl status crio
```

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

### init first control pannel
```bash
$ sudo kubeadm init --config kubeadm-config.yaml --upload-certs --v=5
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

### reupload certificate

> [!NOTE|label:references:]
> - [uploading control-plane certificates to the cluster](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#uploading-control-plane-certificates-to-the-cluster)

```bash
$ sudo kubeadm init phase upload-certs --upload-certs

# or
$ sudo kubeadm init phase upload-certs --upload-certs --config=/path/to/kubeadm-conf.yaml
```

### HA Cluster

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


### verify
#### cluster
- componentstatuses
  ```bash
  $ kubectl get cs
  Warning: v1 ComponentStatus is deprecated in v1.19+
  NAME                 STATUS    MESSAGE   ERROR
  scheduler            Healthy   ok
  controller-manager   Healthy   ok
  etcd-0               Healthy   ok
  ```

#### crio
```bash
$ curl -s --unix-socket /var/run/crio/crio.sock http://localhost/info | jq -r
{
  "storage_driver": "overlay",
  "storage_image": "",
  "storage_root": "/var/lib/containers/storage",
  "cgroup_driver": "systemd",
  "default_id_mappings": {
    "uids": [
      {
        "container_id": 0,
        "host_id": 0,
        "size": 4294967295
      }
    ],
    "gids": [
      {
        "container_id": 0,
        "host_id": 0,
        "size": 4294967295
      }
    ]
  }
}
```

## CNI

> [!NOTE|label:references:]
> - [Is there a way to assign pod-network-cidr in kubeadm after initialization?](https://stackoverflow.com/a/60944959/2940319)
> - [Install a Network Policy Provider](https://kubernetes.io/docs/tasks/administer-cluster/network-policy-provider/)
>   - [Use Calico for NetworkPolicy](https://kubernetes.io/docs/tasks/administer-cluster/network-policy-provider/calico-network-policy/)
> - [Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/)
> - [Declare Network Policy](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy/)


## addons
### helm
```bash
$ curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
Downloading https://get.helm.sh/helm-v3.15.4-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
helm installed into /usr/local/bin/helm
```

### TSL
```bash
$ cat star_sample_com.crt >> star_sample_com.full.crt
$ cat DigiCertCA.crt      >> star_sample_com.full.crt
$ cat TrustedRoot.crt     >> star_sample_com.full.crt

# create secret yaml
$ kubectl -n kube-system create secret tls sample-tls \
          --cert star_sample_com.full.crt \
          --key star_sample_com.key \
          --dry-run=client -o yaml > kube-system.sample-tls.yaml

# apply secret
$ kubectl -n kube-system apply -f kube-system.sample-tls.yaml

# copy to another namespace
$ kubectl --namespace=kube-system get secrets sample-tls -o yaml |
          grep -v '^\s*namespace:\s' |
          kubectl apply --namespace=ingress-nginx -f -
secret/sample-tls created
```

### kubernetes-dashboard

> [!NOTE|label:references:]
> - [Configure Kubernetes Dashboard Web UI hosted with Nginx Ingress Controller](https://gist.github.com/s-lyn/3aba97628c922ddc4a9796ac31a6df2d)

#### install kube-dashboard
```bash
# add kubernetes-dashboard repository
$ helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

# deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
$ helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
```

#### ingress for kubernetes-dashboard
```bash
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kubernetes-dashboard
  namespace: kube-system
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/secure-backends: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - sms-k8s-dashboard.sample.com
    secretName: sample-tls
  rules:
    - host: sms-k8s-dashboard.sample.com
      http:
        paths:
        - path: /
          backend:
            service:
              # or kubernetes-dashboard-kong-proxy for latest version
              name: kubernetes-dashboard
              port:
                number: 443
          pathType: Prefix
```

#### rbac
- clusterrole
  ```bash
  $ kubectl get clusterrole kubernetes-dashboard -o yaml
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRole
  metadata:
    labels:
      k8s-app: kubernetes-dashboard
    name: kubernetes-dashboard
  rules:
  - apiGroups:
    - '*'
    resources:
    - '*'
    verbs:
    - '*'
  ```

- clusterrolebinding
  ```bash
  $ kubectl -n kube-system get clusterrolebindings kubernetes-dashboard -o yaml
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: kubernetes-dashboard
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: kubernetes-dashboard
  subjects:
  - kind: ServiceAccount
    name: kubernetes-dashboard
    namespace: kube-system
  ```

- serviceaccount
  ```bash
  $ kubectl -n kube-system get sa kubernetes-dashboard -o yaml
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    labels:
      k8s-app: kubernetes-dashboard
    name: kubernetes-dashboard
    namespace: kube-system
  ```

- generate token
  ```bash
  $ kubectl -n kube-system create token kubernetes-dashboard
  ey**********************WAA
  ```

### ingress-nginx
```bash
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
```

### grafana
```bash
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo list
NAME                    URL
kubernetes-dashboard    https://kubernetes.github.io/dashboard/
ingress-nginx           https://kubernetes.github.io/ingress-nginx
grafana                 https://grafana.github.io/helm-charts

$ helm repo update
$ helm search repo grafana/grafana

$ helm install grafana grafana/grafana --namespace monitoring --create-namespace
```

### metrics-server
```bash
$ helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
$ helm upgrade --install metrics-server metrics-server/metrics-server --namespace monitoring --create-namespace

# without tls: https://github.com/kubernetes-sigs/metrics-server/issues/1221
$ helm upgrade metrics-server metrics-server/metrics-server --set args="{--kubelet-insecure-tls}" --namespace monitoring
```

## teardown

> [!NOTE|label:references:]
> - [Clean up](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tear-down)
> - ["Failed to setup network for pod \ using network plugins \"cni\": no IP addresses available in network: podnet; Skipping pod" #39557](https://github.com/kubernetes/kubernetes/issues/39557#issuecomment-271944481)

```bash
$ sudo kubeadm reset --cri-socket /var/run/crio/crio.sock --v=5 -f
$ sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
$ sudo ipvsadm -C
```

- [cleanup interface](https://stackoverflow.com/a/46438072/2940319)

  ```bash
  # cni0
  $ sudo ifconfig cni0 down
  $ sudo ip link delete cni0

  # calico
  $ sudo ifconfig vxlan.calico down
  $ sudo ip link delete vxlan.calico

  # flannel
  $ sudo ifconfig flannel.1 down
  $ sudo ip link delete flannel.1
  ```

- clean up images
  ```bash
  $ crictl rmi --prune

  # or
  $ crictl rmi $(crictl images -q | uniq)
  ```

## troubleshooting
### scheduler and controller-manager unhealthy

> [!NOTE|label:references:]
> - **scheduler**: `/etc/kubernetes/manifests/kube-scheduler.yaml`
> - **controller-manager**: `/etc/kubernetes/manifests/kube-controller-manager.yaml`
> - references:
>   - [(9-4)、查看集群状态](https://blog.csdn.net/Weixiaohuai/article/details/135478349)

```bash
$ sudo sed -re 's:^.+port=0$:# &:' -i /etc/kubernetes/manifests/kube-scheduler.yaml
$ sudo sed -re 's:^.+port=0$:# &:' -i /etc/kubernetes/manifests/kube-controller-manager.yaml
```

## other references

### calico tools
```bash
# calicoctl
$ curl -L https://github.com/projectcalico/calico/releases/download/v3.28.1/calicoctl-linux-amd64 -o calicoctl
$ chmod +x calicoctl
$ sudo mv calicoctl /usr/local/bin/

# kubectl-calico
$ curl -L https://github.com/projectcalico/calico/releases/download/v3.28.1/calicoctl-linux-amd64 -o kubectl-calico
$ chmod +x kubectl-calico
$ sudo mv kubectl-calico /usr/local/bin/
```

### kubecolor
```bash
$ sudo mkdir -p /tmp/kubecolor
$ curl -fsSL https://github.com/hidetatz/kubecolor/releases/download/v0.0.25/kubecolor_0.0.25_Linux_x86_64.tar.gz | tar xzf - -C /tmp/kubecolor
$ sudo mv /tmp/kubecolor /usr/local/bin/
$ sudo chmod +x /usr/local/bin/kubecolor
```

### bash completion
```bash
$ sudo dnf install -y bash-completion
$ sudo curl -fsSL https://github.com/marslo/dotfiles/raw/main/.marslo/.completion/complete_alias -o /etc/profile.d/complete_alias.sh

$ sudo bash -c "cat >> /etc/bashrc" << EOF
alias k='kubecolor'
[[ -f /etc/profile.d/complete_alias.sh ]] && source /etc/profile.d/complete_alias.sh
command -v kubectl >/dev/null && source <(kubectl completion bash)
complete -o default -F __start_kubectl kubecolor
complete -o nosort -o bashdefault -o default -F _complete_alias $(alias | sed -rn 's/^alias ([^=]+)=.+kubec.+$/\1/p' | xargs)
EOF
```

### kubeadm-conf.yaml
- [`kubeadm-conf.yaml` for v1.21.3](https://blog.csdn.net/Weixiaohuai/article/details/135478349)
  ```yaml
  apiServer:
    certSANs:
      - k8s-master-01
      - k8s-master-02
      - k8s-master-03
      - master.k8s.io
      - 192.168.1.35
      - 192.168.1.36
      - 192.168.1.39
      - 127.0.0.1
    extraArgs:
      authorization-mode: Node,RBAC
    timeoutForControlPlane: 4m0s
  apiVersion: kubeadm.k8s.io/v1beta2
  certificatesDir: /etc/kubernetes/pki
  clusterName: kubernetes
  controlPlaneEndpoint: "master.k8s.io:16443"
  controllerManager: {}
  dns:
    type: CoreDNS
  etcd:
    local:
      dataDir: /var/lib/etcd
  imageRepository: registry.aliyuncs.com/google_containers
  kind: ClusterConfiguration
  kubernetesVersion: v1.21.3
  networking:
    dnsDomain: cluster.local
    podSubnet: 10.244.0.0/16
    serviceSubnet: 10.1.0.0/16
  scheduler: {}
  ```

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

