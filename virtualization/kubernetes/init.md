<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [teardown](#teardown)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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


## teardown

- yum
  ```bash
  $ sudo yum versionlock list
  Loaded plugins: fastestmirror, versionlock
  0:kubeadm-1.15.3-0.*
  0:kubectl-1.15.3-0.*
  0:kubelet-1.15.3-0.*
  0:kubernetes-cni-0.7.5-0.*
  3:docker-ce-18.09.9-3.el7.*
  1:docker-ce-cli-18.09.9-3.el7.*
  versionlock list done

  $ sudo yum versionlock clear
  Loaded plugins: fastestmirror, versionlock
  versionlock cleared

  $ sudo yum versionlock list
  Loaded plugins: fastestmirror, versionlock
  versionlock list done
  ```
