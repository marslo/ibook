<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [add new etcd](#add-new-etcd)
- [grafana](#grafana)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



> [!TIP]
> references:<br>
> - [Operating etcd clusters for Kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)
> - [Set up a High Availability etcd Cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/)


### add new etcd

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
          -endpoints=https://10.69.78.87:2379,https://10.69.78.73:2379,https://10.69.78.55:2379 \
          member list
```

### grafana

> [!TIP]
> references:
> - [Grafana Loki Concise Tutorial](https://www.sobyte.net/post/2021-10/grafana-loki-usage/)
> - [Grafana CLI](https://grafana.com/docs/grafana/latest/administration/cli)
