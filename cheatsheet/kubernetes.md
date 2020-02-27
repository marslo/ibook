<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [kubectl alias](#kubectl-alias)
- [update image for deploy](#update-image-for-deploy)
- [secrets](#secrets)
- [token](#token)
- [tear down](#tear-down)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### [kubectl alias](https://learnk8s.io/blog/kubectl-productivity/)
#### `__start_kubectl`
```bash
echo 'source <(kubectl completion bash)' >> ~/.bashrc
cat >> ~/.bashrc <<EOF
alias k='kubectl'
alias kc='kubectl -n kube-system'
alias ki='kubectl -n ingress-ngxin'
alias kk='kubectl -n kubernetes-dashboard'

for _i in k kc ki kk; do
  complete -F __start_kubectl "${_i}"
done
EOF
source ~/.bashrc
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
source ~/.bashrc
```
### update image for deploy
```bash
$ k -n devops set image deployments/devops-jenkins devops-jenkins=jenkins/jenkins:2.200
deployment.extensions/devops-jenkins image updated
```
- result

```bash
$ k -n devops get pods -w
NAME                              READY   STATUS    RESTARTS   AGE
devops-jenkins-54d6db68ff-bz5b6   1/1     Running   0          6d17h
devops-jenkins-6bdd4fc6dd-l9spp   0/1     Pending   0          0s
devops-jenkins-6bdd4fc6dd-l9spp   0/1     Pending   0          0s
devops-jenkins-6bdd4fc6dd-l9spp   0/1     ContainerCreating   0          0s
devops-jenkins-6bdd4fc6dd-l9spp   1/1     Running             0          8s
devops-jenkins-54d6db68ff-bz5b6   1/1     Terminating         0          6d17h
devops-jenkins-54d6db68ff-bz5b6   0/1     Terminating         0          6d17h
devops-jenkins-54d6db68ff-bz5b6   0/1     Terminating         0          6d17h
devops-jenkins-54d6db68ff-bz5b6   0/1     Terminating         0          6d17h

$ k -n devops get deploy -w
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
devops-jenkins   1/1     1            1           22d
devops-jenkins   1/1     1            1           22d
devops-jenkins   1/1     1            1           22d
devops-jenkins   1/1     0            1           22d
devops-jenkins   1/1     1            1           22d
devops-jenkins   2/1     1            2           22d
devops-jenkins   1/1     1            1           22d

$ k -n devops get deploy devops-jenkins -o yaml --export | grep image\:
Flag --export has been deprecated, This flag is deprecated and will be removed in future.
        image: jenkins/jenkins:2.200
```

### secrets

#### create secrets
- by command``
``
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
  tls.crt: $(cat $HOME/.devops/certs/server.csr | base64 | tr -d '\n')
  tls.key: $(cat $HOME/.devops/certs/server.key | base64 | tr -d '\n')" | k apply -f -
```

#### duplicate secrets to the other ns
```bash
$ k -n ingress-nginx get secrets my-certs -o yaml --export | k apply -n devops -f -
```

- [others](https://github.com/jetstack/cert-manager/issues/494)
- [Pro-Tip – Copying Kubernetes Secrets Between Namespaces](https://www.revsys.com/tidbits/copying-kubernetes-secrets-between-namespaces/)

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
$ sudo yum versionlock delete docker-ce
$ sudo yum versionlock delete docker-ce-cli
$ sudo yum versionlock delete kubeadm
$ sudo yum versionlock delete kubelet
$ sudo yum versionlock delete kubectl
$ sudo yum versionlock delete kubernetes-cni

$ sudo yum remove -y docker-ce docker-ce-cli containerd.io kubectl kubeadm kubelet kubernetes-cni

$ rm -rf /home/devops/.kube
$ sudo rm -rf /var/log/pods/
$ sudo rm -rf /var/log/containers/
$ sudo rm -rf /etc/kubernetes/
$ sudo rm -rf /var/lib/yum/repos/x86_64/7/kubernetes
$ sudo rm -rf /usr/libexec/kubernetes
$ sudo rm -rf /var/cache/yum/x86_64/7/kubernetes
$ sudo rm -rf /etc/systemd/system/multi-user.target.wants/kubelet.service
$ sudo rm -rf /usr/lib/systemd/system/kubelet.service.d
$ sudo rm -rf /var/lib/kubelet
$ sudo rm -rf /usr/libexec/kubernetes

$ sudo yum clean all
$ sudo rm -rf /var/cache/yum
$ sudo yum makecache
```
