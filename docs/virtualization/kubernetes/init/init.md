## [synopsis](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#synopsis)
```
preflight                    Run pre-flight checks
certs                        Certificate generation
  /ca                          Generate the self-signed Kubernetes CA to provision identities for other Kubernetes components
  /apiserver                   Generate the certificate for serving the Kubernetes API
  /apiserver-kubelet-client    Generate the certificate for the API server to connect to kubelet
  /front-proxy-ca              Generate the self-signed CA to provision identities for front proxy
  /front-proxy-client          Generate the certificate for the front proxy client
  /etcd-ca                     Generate the self-signed CA to provision identities for etcd
  /etcd-server                 Generate the certificate for serving etcd
  /etcd-peer                   Generate the certificate for etcd nodes to communicate with each other
  /etcd-healthcheck-client     Generate the certificate for liveness probes to healthcheck etcd
  /apiserver-etcd-client       Generate the certificate the apiserver uses to access etcd
  /sa                          Generate a private key for signing service account tokens along with its public key
kubeconfig                   Generate all kubeconfig files necessary to establish the control plane and the admin kubeconfig file
  /admin                       Generate a kubeconfig file for the admin to use and for kubeadm itself
  /kubelet                     Generate a kubeconfig file for the kubelet to use *only* for cluster bootstrapping purposes
  /controller-manager          Generate a kubeconfig file for the controller manager to use
  /scheduler                   Generate a kubeconfig file for the scheduler to use
kubelet-start                Write kubelet settings and (re)start the kubelet
control-plane                Generate all static Pod manifest files necessary to establish the control plane
  /apiserver                   Generates the kube-apiserver static Pod manifest
  /controller-manager          Generates the kube-controller-manager static Pod manifest
  /scheduler                   Generates the kube-scheduler static Pod manifest
etcd                         Generate static Pod manifest file for local etcd
  /local                       Generate the static Pod manifest file for a local, single-node local etcd instance
upload-config                Upload the kubeadm and kubelet configuration to a ConfigMap
  /kubeadm                     Upload the kubeadm ClusterConfiguration to a ConfigMap
  /kubelet                     Upload the kubelet component config to a ConfigMap
upload-certs                 Upload certificates to kubeadm-certs
mark-control-plane           Mark a node as a control-plane
bootstrap-token              Generates bootstrap tokens used to join a node to a cluster
kubelet-finalize             Updates settings relevant to the kubelet after TLS bootstrap
  /experimental-cert-rotation  Enable kubelet client certificate rotation
addon                        Install required addons for passing conformance tests
  /coredns                     Install the CoreDNS addon to a Kubernetes cluster
  /kube-proxy                  Install the kube-proxy addon to a Kubernetes cluster
```

## [options](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#options)
- `--apiserver-advertise-address string`
- `--apiserver-bind-port int32`     Default: 6443
- `--apiserver-cert-extra-sans strings`
- `--cert-dir string`     Default: "/etc/kubernetes/pki"
- `--certificate-key string`
- `--config string`
- `--control-plane-endpoint string`
- `--cri-socket string`
- `--dry-run`
- `--feature-gates string` : A set of key=value pairs that describe feature gates for various features
  - `PublicKeysECDSA=true|false` (ALPHA - default=false)
  - `RootlessControlPlane=true|false` (ALPHA - default=false)
  - `UnversionedKubeletConfigMap=true|false` (BETA - default=true)
- `-h`, `--help`
- `--ignore-preflight-errors strings`
- `--image-repository string`     Default: "k8s.gcr.io"
- `--kubernetes-version string`     Default: "stable-1"
- `--node-name string`
- `--patches string`
- `--pod-network-cidr string`
- `--service-cidr string`     Default: "10.96.0.0/12"
- `--service-dns-domain string`     Default: "cluster.local"
- `--skip-certificate-key-print`
- `--skip-phases strings`
- `--skip-token-print`
- `--token string`
- `--token-ttl duration`     Default: 24h0m0s
- `--upload-certs`
- `--rootfs string`

## [init workflow](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#kubeadm-init-workflow-internal-design)
1. [preflight checks](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#preflight-checks)
1. [generate the necessary certificates](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#generate-the-necessary-certificates)
1. [generate kubeconfig files for control plane components](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#generate-kubeconfig-files-for-control-plane-components)
1. [generate static pod manifests for control plane components](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#generate-static-pod-manifests-for-control-plane-components)
  * api server
  * controller-manager
  * scheduler

  > [!TIP]
  > kubeadm writes static Pod manifest files for control plane components to `/etc/kubernetes/manifests`
  > static pod manifest generation for control plane components can be invoked individually with the [`kubeadm init phase control-plane all`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init-phase/#cmd-phase-control-plane) command
  >
  > references:
  > - [using custom images](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#custom-images)

1. [generate static pod manifest for local etcd](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#generate-static-pod-manifest-for-local-etcd)
1. [wait for the control plane to come up](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#wait-for-the-control-plane-to-come-up)

  > [!TIP]
  > kubeadm waits (upto 4m0s) until `localhost:6443/healthz` (kube-apiserver liveness) returns `ok`. However in order to detect deadlock conditions, kubeadm fails fast if `localhost:10255/healthz` (kubelet liveness) or `localhost:10255/healthz/syncloop` (kubelet readiness) don't return `ok` within 40s and 60s respectively.

1. [save the kubeadm clusterconfiguration in a configmap for later reference](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#save-the-kubeadm-clusterconfiguration-in-a-configmap-for-later-reference)
1. [mark the node as control-plane](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#mark-the-node-as-control-plane)

  > [!TIP]
  > Please note that:
  > - The `node-role.kubernetes.io/master` taint is deprecated and will be removed in **kubeadm version 1.25**
  > - Mark control-plane phase phase can be invoked individually with the [`kubeadm init phase mark-control-plane`](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init-phase/#cmd-phase-mark-control-plane) command

1. [configure tls-bootstrapping for node joining](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#configure-tls-bootstrapping-for-node-joining)
  * [create a bootstrap token](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#create-a-bootstrap-token)
  * [allow joining nodes to call csr api](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#allow-joining-nodes-to-call-csr-api)
  * [Setup auto approval for new bootstrap tokens](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#setup-auto-approval-for-new-bootstrap-tokens)
  * [setup nodes certificate rotation with auto approval](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#setup-nodes-certificate-rotation-with-auto-approval)
  * [create the public cluster-info configmap](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#create-the-public-cluster-info-configmap)
1. [install addons](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#install-addons)
  * [proxy](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#proxy)
  * [dns](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#dns)

## init steps

![kubeadm init](../../../screenshot/k8s/Kubeadm-init.png)

> [!NOTE|label:references:]
> - [How to Setup Kubernetes(k8s) Cluster in HA with Kubeadm](https://www.linuxtechi.com/setup-highly-available-kubernetes-cluster-kubeadm/)
> - [Creating Highly Available Clusters with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/)
> - [Multi-Master Kubernetes Cluster Setup with CRI-O and vSphere Storage on CentOS 8](https://blog.yasithab.com/centos/multi-master-kubernetes-cluster-setup-with-crio-and-vsphere-storage-on-centos-8/)
> - [cri-o/tutorials](https://github.com/cri-o/cri-o/tree/main/tutorials)
>   - [Running CRI-O on a Kubernetes cluster](https://github.com/cri-o/cri-o/blob/main/tutorials/kubernetes.md)
> - [在Kubernetes中使用CRI-O运行时](https://zhuanlan.zhihu.com/p/402497610)
> - [使用 Kubeadm 和 CRI-O 在 Rocky Linux 8 上安装 Kubernetes 集群](https://blog.csdn.net/wchbest/article/details/131038029)
> - [kubernetes cri-o浅尝](https://www.bilibili.com/read/cv20869471)
> - [AlmaLinux基于cri-o+Calico用kubeadm搭建1.24版本多master高可用Kubernetes集群](https://blog.csdn.net/lic95/article/details/125025782)
> - [etcd-io/etcd](https://github.com/etcd-io/etcd/release)
> - [详解 K8S 高可用部署](https://mp.weixin.qq.com/s?__biz=MzU0OTE4MzYzMw==&mid=2247550185&sn=6286db333de97b99584301956a339e3a&chksm=fbb18d17ccc60401b232e9ebb54eb2970129caa0595c454f4356f6ee29f87a6b63adc9b97af0)
> - others:
>   - [Kubernetes 1.28 震撼发布，Sidecar Containers 迎面而来](https://baijiahao.baidu.com/s?id=1774263469282248861)
>   - [Manual installation on Kubernetes from scratch with kubectl](https://www.ibm.com/docs/en/cloud-paks/foundational-services/3.23?topic=software-manual-installation-kubernetes-from-scratch-kubectl)

1. [environment setup](./kubeadm/env.md)
1. install container runtime
  * [cri-o](../../crio/crio.md)
  * [docker](../../docker/docker.md)
1. High Availability
  * [keepalived](./kubeadm/env.md#keepalived)
  * [haproxy](./kubeadm/env.md#haproxy)
  * [extenal etcd](./etcd.md#extenal-etcd)
1. [kuberentes packates](./kubeadm/kubeadm.md#kubernetes-packages)
1. [init first control plane](./kubeadm/kubeadm.md#init-first-control-plane-node)
1. [join peer control planes](./kubeadm/kubeadm.md#join-as-control-plane-node)
1. [join work nodes](./kubeadm/kubeadm.md#join-as-worker-node)
1. [install network plugin](./addons.md#cni)
  * [calico](./addons.md#calico)
  * [flannel](./addons.md#flannel)
1. [install ingress](./addons.md#ingress)
  * [ingress-nginx](./addons.md#ingress-nginx)
1. [addons](./addons.md)
  * [monitoring](./addons.md#monitoring)
    * [kubernetes-dashboard](./addons.md#kubernetes-dashboard)
    * [grafana](./addons.md#grafana)
    * [metrics-server](./addons.md#metrics-server)
1. [setup tls](./addons.md#tls)
