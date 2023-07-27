<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [debug services](#debug-services)
- [check log](#check-log)
  - [system logs](#system-logs)
  - [pod logs](#pod-logs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## debug services

> [!NOTE|label:reference:]
> - [Debug Services](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)
> - [Access Services Running on Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/access-cluster-services/)
> - [DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
> - svc in cluster can be visit via
>   - `CLUSTER-IP`
>   - `<svc-name>.<namespace>.svc.cluster.local`
> <p>
> - [create pod from cmd](./pod.html#pod)
> - svc status
>   ```bash
>   $ kubectl get svc
>   NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)              AGE
>   jenkins   ClusterIP   10.111.230.13   <none>        8080/TCP,50017/TCP   17h
>   ```

```bash
# create new pod
$ kubectl run ubuntu-marslo \
              --image=ubuntu:18.04 \
              --overrides='{"spec": { "nodeSelector": {"kubernetes.io/hostname": "k8s-node-01"}}}' \
              -it \
              --rm

# check DNS
<ubuntu-marslo> $ cat /etc/resolv.conf
nameserver 10.96.0.10
search devops.svc.cluster.local svc.cluster.local cluster.local marvell.com
options ndots:5

# debug
$ nc -zv jenkins.devops.svc.cluster.local 30338
$ nc -zv 10.111.230.13                    30338
$ ssh -l marslo -p 30338 -i ~/.ssh/id_rsa jenkins.devops.svc.cluster.local list-plugins
$ ssh -l marslo -p 30338 -i ~/.ssh/id_rsa 10.111.230.13                    list-plugins
```

## check log

> [!NOTE|label:references:]
> - [Kubernetes Logging Tutorial For Beginners](https://devopscube.com/kubernetes-logging-tutorial/)


### system logs

```bash
$ journalctl -u <service> -f

# or
$ journalctl -u kubelet -o cat

# or
$ sudo systemctl status <service> -l --no-pager
```

### pod logs

{% hint style='tip' %}
> references:
> - [Kubernetes / kubectl - "A container name must be specified" but seems like it is?](https://stackoverflow.com/a/66965570/2940319)
{% endhint %}

```bash
$ kubectl logs pod <pod_name> --all-containers
```
