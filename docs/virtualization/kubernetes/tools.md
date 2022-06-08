<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [etcd](#etcd)
  - [check healthy](#check-healthy)
  - [re-add etcd](#re-add-etcd)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## etcd

{% hint style='tip' %}
> references:
> - [Operating etcd clusters for Kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)
> - [Set up a High Availability etcd Cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/)
{% endhint %}


### [check healthy](https://faun.pub/kubectl-commands-cheatsheet-43ce8f13adfb)
```bash
$ kubectl get --raw=/healthz/etcd
```

### re-add etcd

```bash
$ ssh devops@kubernets.master
$ docker run -it \
             -v /var/lib/etcd:/var/lib/etcd \
             -v /etc/kubernetes/pki/etcd:/etc/kubernetes/pki/etcd \
             -p 2380:2380 \
             -p 2379:2379 \
             --network=host \
             k8s.gcr.io/etcd:3.2.24

# running inside docker
$ etcdctl --ca-file /etc/kubernetes/pki/etcd/ca.crt \
          --cert-file /etc/kubernetes/pki/etcd/peer.crt \
          --key-file /etc/kubernetes/pki/etcd/peer.key \
          -endpoints=https://<master3IP>:2379,https://<master2IP>:2379,https://<master1IP>:2379 \
          member list
 >> a874c87fd42044f: name=<master1Hostname> peerURLs=https://<master1IP>:2380 clientURLs=https://<master1IP>:2379 isLeader=true
 >> 3be12ef2ee5f92e7(unstarted): name=<master3Hostname> peerURLs=https://<master3IP>:2380
 >> da3e2155721a00f6: name=<master2Hostname> peerURLs=https://<master2IP>:2380 clientURLs=https://<master2IP>:2379 isLeader=false


# remove "unstarted" node
$ etcdctl --ca-file /etc/kubernetes/pki/etcd/ca.crt \
          --cert-file /etc/kubernetes/pki/etcd/peer.crt \
          --key-file /etc/kubernetes/pki/etcd/peer.key \
          -endpoints=https://<master3IP>:2379,https://<master2IP>:2379,https://<master1IP>:2379 \
          member remove 3be12ef2ee5f92e7

# re-add again
$ etcdctl --ca-file /etc/kubernetes/pki/etcd/ca.crt \
          --cert-file /etc/kubernetes/pki/etcd/peer.crt \
          --key-file /etc/kubernetes/pki/etcd/peer.key \
          -endpoints=https://<master3IP>:2379,https://<master2IP>:2379,https://<master1IP>:2379 \
          member add <master3Hostname> https://<master3IP>:2380
```
