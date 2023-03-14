<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Core design principles](#core-design-principles)
  - [Constants and well-known values and paths](#constants-and-well-known-values-and-paths)
  - [API server](#api-server)
  - [controller manager](#controller-manager)
- [ports and protocols](#ports-and-protocols)
  - [contol plane](#contol-plane)
  - [worker node(s)](#worker-nodes)
- [options](#options)
  - [explain](#explain)
- [kubectl alias](#kubectl-alias)
- [secrets](#secrets)
  - [create secrets](#create-secrets)
  - [duplicate secrets to the other ns](#duplicate-secrets-to-the-other-ns)
- [token](#token)
  - [check token](#check-token)
  - [generate token](#generate-token)
- [tear down](#tear-down)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP]
> `kubernetes.io` add `/_print` as suffix in the url, it will show pages into one page
> i.e.:
> - [https://kubernetes.io/docs/setup/best-practices/](https://kubernetes.io/docs/setup/best-practices/)
> - [https://kubernetes.io/docs/setup/best-practices/_print/](https://kubernetes.io/docs/setup/best-practices/_print/)


{% hint style='tip' %}
> reference
> - [* Glossary](https://kubernetes.io/docs/reference/glossary/?fundamental=true)
> - [* Kubernetes 中文指南/云原生应用架构实战手册](https://jimmysong.io/kubernetes-handbook/)
> - [* Create static Pods](https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/)
> - [* Implementation details](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#core-design-principles)
> - [* Scheduling, Preemption and Eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/_print/)
> - [* Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
> - [* Administer a Cluster](https://kubernetes.io/docs/tasks/administer-cluster/)
> - [KUBERNETES: AN OVERVIEW](https://thenewstack.io/kubernetes-an-overview)
> - [What Is Kubernetes: A Container Orchestration Platform](https://www.metricfire.com/blog/what-is-kubernetes-a-container-orchestration-platform/)
> - [KUBERNETES, OPEN-SOURCE CONTAINER ORCHESTRATION TECHNOLOGY](https://quintagroup.com/cms/technology/kubernetes)
> - [Boosting your kubectl productivity](https://learnk8s.io/blog/kubectl-productivity/)
> - [23 Advanced kubectl commands](https://medium.com/faun/kubectl-commands-cheatsheet-43ce8f13adfb)
> - [8 Kubernetes Tips and Tricks](https://www.ibm.com/cloud/blog/8-kubernetes-tips-and-tricks)
> - [Linux namespace简介](https://blog.csdn.net/chenleiking/article/details/87915185)
> - [Well-Known Labels, Annotations and Taints](https://kubernetes.io/docs/reference/labels-annotations-taints)
> - [* best practices](https://kubernetes.io/docs/setup/best-practices/_print/)
> - [12 Kubernetes Configuration Best Practices](https://cloud.redhat.com/blog/12-kubernetes-configuration-best-practices)
{% endhint %}

![kubernetes orchestration control panel](../../screenshot/k8s/kubernetes-control-plane.png)

![kubernetes technology](../../screenshot/k8s/kubernetes-architecture.jpeg)


## [Core design principles](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#core-design-principles)
### [Constants and well-known values and paths](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#constants-and-well-known-values-and-paths)

#### `/etc/kubernetes/manifests`

> [!TIP]
> `/etc/kubernetes/manifests` as the path where kubelet should look for static Pod manifests. Names of static Pod manifests are:
> - `etcd.yaml`
> - `kube-apiserver.yaml`
> - `kube-controller-manager.yaml`
> - `kube-scheduler.yaml`

#### `/etc/kubernetes`

> [!TIP]
> `/etc/kubernetes/` as the path where kubeconfig files with identities for control plane components are stored. Names of kubeconfig files are:
> - `kubelet.conf` (bootstrap-kubelet.conf during TLS bootstrap)
> - `controller-manager.conf`
> - `scheduler.conf`
> - `admin.conf` for the cluster admin and kubeadm itself

#### names of certificates and key files

> [!TIP]
> - `ca.crt`, `ca.key` for the Kubernetes certificate authority
> - `apiserver.crt`, `apiserver.key` for the API server certificate
> - `apiserver-kubelet-client.crt`, `apiserver-kubelet-client.key` for the client certificate used by the API server to connect to the kubelets securely
> - `sa.pub`, `sa.key` for the key used by the controller manager when signing ServiceAccount
> - `front-proxy-ca.crt`, `front-proxy-ca.key` for the front proxy certificate authority
> - `front-proxy-client.crt`, `front-proxy-client.key` for the front proxy client

### [API server](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#api-server)

#### [static Pod manifest](https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/)

> [!TIP]
> - `apiserver-advertise-address` and `apiserver-bind-port` to bind to; if not provided, those value defaults to the IP address of the default network interface on the machine and port `6443`
> - `service-cluster-ip-range` to use for services
> - If an external etcd server is specified, the `etcd-servers` address and related TLS settings (`etcd-cafile`, `etcd-certfile`, `etcd-keyfile`);
>   - if an external etcd server is not be provided, a local etcd will be used ( via host network )
> - If a cloud provider is specified, the corresponding `--cloud-provider` is configured, together with the `--cloud-config` path if such file exists (this is experimental, alpha and will be removed in a future version)

#### other api server flags

- `--insecure-port=0` to avoid insecure connections to the api server
- `--enable-bootstrap-token-auth=true` to enable the BootstrapTokenAuthenticator authentication module. See TLS Bootstrapping for more details
- `--allow-privileged` to true (required e.g. by kube proxy)
- `--requestheader-client-ca-file` to front-proxy-ca.crt
- `--enable-admission-plugins` to:
  - `NamespaceLifecycle` e.g. to avoid deletion of system reserved namespaces
  - `LimitRanger` and `ResourceQuota` to enforce limits on namespaces
  - `ServiceAccount` to enforce service account automation
  - `PersistentVolumeLabel` attaches region or zone labels to PersistentVolumes as defined by the cloud provider (This admission controller is deprecated and will be removed in a future version. It is not deployed by kubeadm by default with v1.9 onwards when not explicitly opting into using gce or aws as cloud providers)
  - `DefaultStorageClass` to enforce default storage class on PersistentVolumeClaim objects
  - `DefaultTolerationSeconds`
  - `NodeRestriction` to limit what a kubelet can modify (e.g. only pods on this node)
- `--kubelet-preferred-address-types` to `InternalIP`,`ExternalIP`,`Hostname`; this makes `kubectl logs` and other API server-kubelet communication work in environments where the hostnames of the nodes aren't resolvable
- Flags for using certificates generated in previous steps:
  - `--client-ca-file` to `ca.crt`
  - `--tls-cert-file` to `apiserver.crt`
  - `--tls-private-key-file` to `apiserver.key`
  - `--kubelet-client-certificate` to `apiserver-kubelet-client.crt`
  - `--kubelet-client-key` to `apiserver-kubelet-client.key`
  - `--service-account-key-file` to `sa.pub`
  - `--requestheader-client-ca-file` to `front-proxy-ca.crt`
  - `--proxy-client-cert-file` to `front-proxy-client.crt`
  - `--proxy-client-key-file` to `front-proxy-client.key`
- Other flags for securing the front proxy (API Aggregation) communications:
  - `--requestheader-username-headers=X-Remote-User`
  - `--requestheader-group-headers=X-Remote-Group`
  - `--requestheader-extra-headers-prefix=X-Remote-Extra-`
  - `--requestheader-allowed-names=front-proxy-client`

### [controller manager](https://kubernetes.io/docs/reference/setup-tools/kubeadm/implementation-details/#controller-manager)

#### [static Pod manifest]((https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/)
> [!TIP]
> - If kubeadm is invoked specifying a `--pod-network-cidr`, the subnet manager feature required for some CNI network plugins is enabled by setting:
>   - `--allocate-node-cidrs=true`
>   - `--cluster-cidr` and `--node-cidr-mask-size` flags according to the given CIDR
> - If a cloud provider is specified, the corresponding `--cloud-provider` is specified, together with the `--cloud-config` path if such configuration file exists (this is experimental, alpha and will be removed in a future version)

#### other flags
- `--controllers` enabling all the default controllers plus `BootstrapSigner` and `TokenCleaner` controllers for TLS bootstrap. See TLS Bootstrapping for more details
- `--use-service-account-credentials` to true
- Flags for using certificates generated in previous steps:
  - `--root-ca-file` to ca.crt
  - `--cluster-signing-cert-file` to `ca.crt`, if External CA mode is disabled, otherwise to `""`
  - `--cluster-signing-key-file` to `ca.key`, if External CA mode is disabled, otherwise to `""`
  - `--service-account-private-key-file` to sa.key

## [ports and protocols](https://kubernetes.io/docs/reference/ports-and-protocols/)
### contol plane

| Protocol | Direction | Port Range | Purpose                 | Used By              |
|----------|-----------|------------|-------------------------|----------------------|
| TCP      | Inbound   | 6443       | Kubernetes API server   | All                  |
| TCP      | Inbound   | 2379-2380  | etcd server client API  | kube-apiserver, etcd |
| TCP      | Inbound   | 10250      | Kubelet API             | Self, Control plane  |
| TCP      | Inbound   | 10259      | kube-scheduler          | Self                 |
| TCP      | Inbound   | 10257      | kube-controller-manager | Self                 |


### worker node(s)
| Protocol | Direction | Port Range  | Purpose                                                                               | Used By             |
|----------|-----------|-------------|---------------------------------------------------------------------------------------|---------------------|
| TCP      | Inbound   | 10250       | Kubelet API                                                                           | Self, Control plane |
| TCP      | Inbound   | 30000-32767 | [NodePort Services](https://kubernetes.io/docs/concepts/services-networking/service/) | All                 |

## options
### explain
```bash
$ kubectl explain hpa
KIND:     HorizontalPodAutoscaler
VERSION:  autoscaling/v1

DESCRIPTION:
     configuration of a horizontal pod autoscaler.

FIELDS:
   apiVersion <string>
   ...
```

- or
  ```bash
  $ kubectl explain configmap
  KIND:     ConfigMap
  VERSION:  v1

  DESCRIPTION:
       ConfigMap holds configuration data for pods to consume.

  FIELDS:
     apiVersion <string>
       APIVersion defines the versioned schema of this representation of an
       object. Servers should convert recognized schemas to the latest internal
       value, and may reject unrecognized values. More info:
       https://git.k8s.io/community/contributors/devel/api-conventions.md#resources
       ...
  ```

## [kubectl alias](https://learnk8s.io/blog/kubectl-productivity/)
#### `__start_kubectl`
```bash
$ echo 'source <(kubectl completion bash)' >> ~/.bashrc
$ cat >> ~/.bashrc <<EOF
alias k='kubectl'
alias kc='kubectl -n kube-system'
alias ki='kubectl -n ingress-ngxin'
alias kk='kubectl -n kubernetes-dashboard'

for _i in k kc ki kk; do
  complete -F __start_kubectl "${_i}"
done
EOF
$ source ~/.bashrc
```

#### `_complete_alias`
```bash
# download bash_completion.sh for kubectl
$ curl -fsSL https://raw.githubusercontent.com/cykerway/complete-alias/master/bash_completion.sh > ~/.bash_completion.sh
$ chmod +x !$

$ cat >> ~/.bashrc << EOF
source <(kubectl completion bash)
source ~/.bash_completion.sh

alias k='kubectl'
alias kc='kubectl -n kube-system'
alias ki='kubectl -n ingress-ngxin'
alias kk='kubectl -n kubernetes-dashboard'

while read -r _i; do
  complete -F _complete_alias "${_i}"
done < <(sed '/^alias /!d;s/^alias //;s/=.*$//' '~/.bashrc')
EOF
$ source ~/.bashrc
```

## secrets
### create secrets
- by command
  ```bash
  $ kubectl create secret tls my-certs \
            --key .devops/certs/server.key \
            --cert .devops/certs/server.crt \
            -n ingress-nginx
  ```

- by yaml
  ```bash
  $ echo "apiVersion: v1
  kind: Secret
  type: kubernetes.io/tls
  metadata:
    name: mytest-cert
    namespace: ingress-nginx
  data:
    tls.crt: $(cat $HOME/.devops/certs/server.csr | base64 -w0)
    tls.key: $(cat $HOME/.devops/certs/server.key | base64 -w0)" |
  kubectl apply -f -
  ```

### duplicate secrets to the other ns

{% hint style='tip' %}
> reference:
> - [others](https://github.com/jetstack/cert-manager/issues/494)
> - [Pro-Tip – Copying Kubernetes Secrets Between Namespaces](https://www.revsys.com/tidbits/copying-kubernetes-secrets-between-namespaces/)
{% endhint %}

```bash
$ kubectl -n ingress-nginx get secrets my-certs -o yaml --export | kubectl apply -n devops -f -
```

## token
### check token
```bash
$ sudo kubeadm token list
TOKEN                     TTL         EXPIRES                     USAGES                   DESCRIPTION   EXTRA GROUPS
bop765.brol9nsrw820gmbi   <forever>   <never>                     authentication,signing   <none>        system:bootstrappers:kubeadm:default-node-token
khhfwa.jvkvrpiknx4o6ffy   19h         2018-07-13T11:37:43+08:00   authentication,signing   <none>        system:bootstrappers:kubeadm:default-node-token
```

### generate token
```bash
$ sudo kubeadm token create --print-join-command
kubeadm join 192.168.1.100:6443 --token lhb1ln.oj0fqwgd1yl7l9xp --discovery-token-ca-cert-hash sha256:cba8df87dcb70c83c19af72c02e4886fcc7b0cf05319084751e6ece688443bde

$ sudo kubeadm token create --print-join-command --ttl=0
kubeadm join 192.168.1.100:6443 --token bop765.brol9nsrw820gmbi --discovery-token-ca-cert-hash sha256:c8650c56faf72b8bf71c576f0d13f44c93bea2d21d4329c64bb97cba439af5c3
```

## [tear down](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tear-down)

> [!TIP]
> - [How to completely uninstall kubernetes](https://stackoverflow.com/a/71503087/2940319)

- ubuntu
  ```bash
  $ kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
  $ kubectl delete node <node name>

  $ sudo kubeadm  reset
  [preflight] Running pre-flight checks.
  [reset] Stopping the kubelet service.
  [reset] Unmounting mounted directories in "/var/lib/kubelet"
  [reset] Removing kubernetes-managed containers.
  [reset] Deleting contents of stateful directories: [/var/lib/kubelet /etc/cni/net.d /var/lib/dockershim /var/run/kubernetes /var/lib/etcd]
  [reset] Deleting contents of config directories: [/etc/kubernetes/manifests /etc/kubernetes/pki]
  [reset] Deleting files: [/etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf]

  $ systemctl stop kubelet
  $ docker system prune -a -f
  $ systemctl stop docker

  $ sudo rm -rf /etc/kubernetes/
  $ sudo rm -rf /var/lib/cni/
  $ sudo rm -rf /var/lib/kubelet/*
  $ sudo rm -rf /etc/cni/
  $ sudo ifconfig cni0 down
  $ sudo ifconfig flannel.1 down

  $ rm -rf ~/.kube/

  $ sudo apt purge kubeadm kubectl kubelet kubernetes-cni kube*
  $ sudo apt autoremove
  ```

- CentOS/RHEL
  ```bash
  $ kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
  $ kubectl delete node <node name>

  $ sudo kubeadm reset
  $ docker system prune -a -f

  $ systemctl stop kubelet
  $ systemctl disable kubelet
  $ systemctl stop docker
  $ systemctl disable docker

  $ sudo ifconfig cni0 down
  $ sudo ifconfig flannel.1 down
  $ sudo ifconfig docker0 down

  $ sudo yum versionlock delete docker-ce
  $ sudo yum versionlock delete docker-ce-cli
  $ sudo yum versionlock delete kubeadm
  $ sudo yum versionlock delete kubelet
  $ sudo yum versionlock delete kubectl
  $ sudo yum versionlock delete kubernetes-cni
  $ sudo yum remove -y docker-ce docker-ce-cli containerd.io kubectl kubeadm kubelet kubernetes-cni
  $ sudo yum autormeove

  $ rm -rf /home/devops/.kube/
  $ sudo rm -rf /etc/cni
  $ sudo rm -rf /etc/kubernetes/
  $ sudo rm -rf /etc/docker/

  $ sudo rm -rf /etc/systemd/system/multi-user.target.wants/kubelet.service
  $ sudo rm -rf /etc/systemd/system/multi-user.target.wants/docker.service
  $ sudo rm -rf /usr/lib/systemd/system/docker.service
  $ sudo rm -rf /usr/lib/systemd/system/kubelet.service.d/

  $ sudo rm -rf /usr/libexec/docker/
  $ sudo rm -rf /usr/libexec/kubernetes/

  $ sudo rm -rf /var/lib/etcd/               # optional
  $ sudo rm -rf /var/lib/kubelet/
  $ sudo rm -rf /var/lib/dockershim/
  $ sudo rm -rf /var/lib/yum/repos/x86_64/7/kubernetes/
  $ sudo rm -rf /var/log/pods/
  $ sudo rm -rf /var/log/containers/
  $ sudo rm -rf /var/run/docker.sock
  $ sudo rm -rf /var/cache/yum/x86_64/7/kubernetes

  $ sudo yum clean all
  $ sudo rm -rf /var/cache/yum
  $ sudo yum makecache
  ```
