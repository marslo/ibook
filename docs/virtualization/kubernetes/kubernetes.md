<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [explain](#explain)
- [kubectl alias](#kubectl-alias)
- [secrets](#secrets)
- [token](#token)
- [tear down](#tear-down)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference
> - [* Kubernetes 中文指南/云原生应用架构实战手册](https://jimmysong.io/kubernetes-handbook/)
> - [KUBERNETES: AN OVERVIEW](https://thenewstack.io/kubernetes-an-overview)
> - [What Is Kubernetes: A Container Orchestration Platform](https://www.metricfire.com/blog/what-is-kubernetes-a-container-orchestration-platform/)
> - [KUBERNETES, OPEN-SOURCE CONTAINER ORCHESTRATION TECHNOLOGY](https://quintagroup.com/cms/technology/kubernetes)
> - [Boosting your kubectl productivity](https://learnk8s.io/blog/kubectl-productivity/)
> - [23 Advanced kubectl commands](https://medium.com/faun/kubectl-commands-cheatsheet-43ce8f13adfb)
> - [8 Kubernetes Tips and Tricks](https://www.ibm.com/cloud/blog/8-kubernetes-tips-and-tricks)
{% endhint %}

![kubernetes orchestration control panel](../../screenshot/k8s/kubernetes-control-plane.png)

![kubernetes technology](../../screenshot/k8s/kubernetes-architecture.jpeg)

### explain
```bash
$ kubectl explain hpa
KIND:     HorizontalPodAutoscaler
VERSION:  autoscaling/v1

DESCRIPTION:
     configuration of a horizontal pod autoscaler.

FIELDS:
   apiVersion	<string>
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
     apiVersion	<string>
       APIVersion defines the versioned schema of this representation of an
       object. Servers should convert recognized schemas to the latest internal
       value, and may reject unrecognized values. More info:
       https://git.k8s.io/community/contributors/devel/api-conventions.md#resources
       ...
  ```

### [kubectl alias](https://learnk8s.io/blog/kubectl-productivity/)
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

### secrets
#### create secrets
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
  k apply -f -
  ```

#### duplicate secrets to the other ns
> reference:
> - [others](https://github.com/jetstack/cert-manager/issues/494)
> - [Pro-Tip – Copying Kubernetes Secrets Between Namespaces](https://www.revsys.com/tidbits/copying-kubernetes-secrets-between-namespaces/)

```bash
$ k -n ingress-nginx get secrets my-certs -o yaml --export | k apply -n devops -f -
```

### token
#### check token
```bash
$ sudo kubeadm token list
TOKEN                     TTL         EXPIRES                     USAGES                   DESCRIPTION   EXTRA GROUPS
bop765.brol9nsrw820gmbi   <forever>   <never>                     authentication,signing   <none>        system:bootstrappers:kubeadm:default-node-token
khhfwa.jvkvrpiknx4o6ffy   19h         2018-07-13T11:37:43+08:00   authentication,signing   <none>        system:bootstrappers:kubeadm:default-node-token
```

#### generate token
```bash
$ sudo kubeadm token create --print-join-command
kubeadm join 192.168.1.100:6443 --token lhb1ln.oj0fqwgd1yl7l9xp --discovery-token-ca-cert-hash sha256:cba8df87dcb70c83c19af72c02e4886fcc7b0cf05319084751e6ece688443bde

$ sudo kubeadm token create --print-join-command --ttl=0
kubeadm join 192.168.1.100:6443 --token bop765.brol9nsrw820gmbi --discovery-token-ca-cert-hash sha256:c8650c56faf72b8bf71c576f0d13f44c93bea2d21d4329c64bb97cba439af5c3
```

### [tear down](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#tear-down)

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
