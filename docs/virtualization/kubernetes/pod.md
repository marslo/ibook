<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [execute in pod](#execute-in-pod)
- [list, filter and sort](#list-filter-and-sort)
  - [`--field-selector`](#--field-selector)
  - [`--sort-by`](#--sort-by)
  - [List Pods name](#list-pods-name)
  - [List all Error Status pods](#list-all-error-status-pods)
  - [get QOS](#get-qos)
  - [get images running](#get-images-running)
  - [show pods running](#show-pods-running)
- [management](#management)
  - [restart po](#restart-po)
- [others](#others)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## execute in pod
```bash
$ k -n devops exec -it devops-jenkins-659f4c6d44-d2w76 -- /bin/bash
jenkins@devops-jenkins-659f4c6d44-d2w76:/$ echo $HOME
/var/jenkins_home
jenkins@devops-jenkins-659f4c6d44-d2w76:/$ hostname
devops-jenkins-659f4c6d44-d2w76
```

## list, filter and sort
### `--field-selector`
- filter via Node Name
  ```bash
  $ k -n <namespace> get po -o wide --field-selector spec.nodeName=master-node01
  NAME                              READY   STATUS    RESTARTS   AGE     IP            NODE            NOMINATED NODE   READINESS GATES
  devops-jenkins-659f4c6d44-d2w76   1/1     Running   0          2d22h   **.***.*.**   master-node01   <none>           <none>
  ```

### `--sort-by`
- sort by restart count
  ```bash
  $ k -n <namespace> get pods --sort-by=.status.containerStatuses[0].restartCount
  ```

- sort via start time
  ```bash
  $ k -n <namespace> get po --sort-by=.status.startTime
  ```

  - get the oldest pod
  > `-1:` means the last in the list

    ```bash
    $ k -n <namepsace> get pods --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1:].metadata.name}'
    ```
- sort via created  time
  ```bash
  $ k -n <namespace> get pods --sort-by=.metadata.creationTimestamp
  ```

### List Pods name
[Inspired from here](https://stackoverflow.com/a/51612372/2940319)

- `-o name`
  ```bash
  $ k -n kube-system get pods -o name | head
  pod/coredns-c7ddbcccb-5cj5z
  pod/coredns-c7ddbcccb-lxsw6
  pod/coredns-c7ddbcccb-prjfk
  pod/etcd-node03
  pod/etcd-node04
  pod/etcd-node01
  pod/kube-apiserver-node03
  pod/kube-apiserver-node04
  pod/kube-apiserver-node01
  pod/kube-controller-manager-node03
  ```

- `--template`
  {% raw %}
  ```bash
  $ k -n kube-system get pods \
      -o go-template \
      --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' \
      | head
  coredns-c7ddbcccb-5cj5z
  coredns-c7ddbcccb-lxsw6
  coredns-c7ddbcccb-prjfk
  etcd-node03
  etcd-node04
  etcd-node01
  kube-apiserver-node03
  kube-apiserver-node04
  kube-apiserver-node01
  kube-controller-manager-node03
  ```
  {% endraw %}

  or

  {% raw %}
  ```bash
  $ k -n kube-system get pods \
      --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' \
      | head
  coredns-c7ddbcccb-5cj5z
  coredns-c7ddbcccb-lxsw6
  coredns-c7ddbcccb-prjfk
  etcd-node03
  etcd-node04
  etcd-node01
  kube-apiserver-node03
  kube-apiserver-node04
  kube-apiserver-node01
  kube-controller-manager-node03
  ```
  {% endraw %}

- [`-o custom-columns=":metadata.name"`](https://stackoverflow.com/a/52691455/2940319)
  ```bash
  $ k -n kube-system get pods -o custom-columns=":metadata.name" | head

  coredns-c7ddbcccb-5cj5z
  coredns-c7ddbcccb-lxsw6
  coredns-c7ddbcccb-prjfk
  etcd-node03
  etcd-node04
  etcd-node01
  kube-apiserver-node03
  kube-apiserver-node04
  kube-apiserver-node01
  ```

- `jsonpath={.items..metadata.name}`
  ```bash
  $ k -n kube-system get pods --output=jsonpath={.items..metadata.name}
  coredns-c7ddbcccb-5cj5z coredns-c7ddbcccb-lxsw6 coredns-c7ddbcccb-prjfk ...
  ```
  - or
    ```bash
    $ k -n kube-system get po -o jsonpath="{range .items[*]}{@.metadata.name}{'\n'}{end}" | head -10
    coredns-c7ddbcccb-5cj5z
    coredns-c7ddbcccb-lxsw6
    coredns-c7ddbcccb-prjfk
    etcd-node03
    etcd-node04
    etcd-node01
    kube-apiserver-node03
    kube-apiserver-node04
    kube-apiserver-node01
    kube-controller-manager-node03
    ```

### [List all Error Status pods](https://stackoverflow.com/a/53327330/2940319)
> reference:
> - [Viewing, finding resources](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-finding-resources)
> - [`kubectl get` should have a way to filter for advanced pods status](https://github.com/kubernetes/kubernetes/issues/49387)

```bash
$ k -n <namespace> get po --field-selector status.phase=Failed
```
- delete all Error status pods
  ```bash
  $ k -n <namespace> delete pods --field-selector status.phase=Failed
  ```

[or](https://github.com/kubernetes/kubernetes/issues/49387#issuecomment-346746104)
```bash
$ k -n <namespace> get po --field-selector=status.phase!=Running
```

[or](https://github.com/kubernetes/kubernetes/issues/49387#issuecomment-504405180)
```bash
$ k get po --all-namespaces --field-selector=status.phase!=Running,status.phase!=Succeeded
```

[or](https://github.com/kubernetes/kubernetes/issues/49387#issuecomment-346573122)
```bash
$ k get po --all-namespaces -o json  \
        | jq -r '.items[] \
        | select(.status.phase != "Running" \
                 or ([ .status.conditions[] | select(.type == "Ready" and .status == "False") ] | length ) == 1 \
                ) \
        | .metadata.namespace + "/" + .metadata.name'
```

[or all pods statuses only](https://medium.com/faun/kubectl-commands-cheatsheet-43ce8f13adfb)
```bash
$ k -n <namespace> get po -o=jsonpath='{.items[*].status.phase}'
Running Running Running Running Running Running Running Running Running
```

### get QOS
```bash
$ k -n kube-system get po -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,QOS-CLASS:.status.qosClass
NAME                                        NAMESPACE     QOS-CLASS
coredns-59dd98b545-7t25l                    kube-system   Burstable
coredns-59dd98b545-lnklx                    kube-system   Burstable
coredns-59dd98b545-ltj5p                    kube-system   Burstable
etcd-k8s-node01                             kube-system   BestEffort
etcd-k8s-node02                             kube-system   BestEffort
etcd-k8s-node03                             kube-system   BestEffort
kube-apiserver-k8s-node01                   kube-system   Burstable
kube-apiserver-k8s-node02                   kube-system   Burstable
kube-apiserver-k8s-node03                   kube-system   Burstable
kube-controller-manager-k8s-node01          kube-system   Burstable
kube-controller-manager-k8s-node02          kube-system   Burstable
kube-controller-manager-k8s-node03          kube-system   Burstable
kube-flannel-ds-amd64-627bn                 kube-system   Guaranteed
kube-flannel-ds-amd64-7hdqd                 kube-system   Guaranteed
kube-flannel-ds-amd64-b4th7                 kube-system   Guaranteed
...
```

### get images running
```bash
$ k4 -n <namespace> get po -o jsonpath="{..image}" | \
     tr -s '[[:space:]]' '\n' | \
     sort | \
     uniq -c
      2 gcr.io/kubernetes-helm/tiller:v2.14.3
      6 k8s.gcr.io/coredns:1.2.2
      6 k8s.gcr.io/etcd:3.2.24
      6 k8s.gcr.io/kube-apiserver:v1.12.3
      6 k8s.gcr.io/kube-controller-manager:v1.12.3
     30 k8s.gcr.io/kube-proxy:v1.12.3
      6 k8s.gcr.io/kube-scheduler:v1.12.3
      4 k8s.gcr.io/metrics-server-amd64:v0.3.6
     30 k8s.gcr.io/node-problem-detector:v0.8.1
      2 kubernetesui/dashboard:v2.0.0-beta1
      4 kubernetesui/metrics-scraper:v1.0.1
     60 quay.io/coreos/flannel:v0.10.0-amd64
```

### show pods running
```bash
$ k -n <namespace> get po -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName
NAME                                        STATUS    NODE
coredns-59dd98b545-7t25l                    Running   k8s-node01
coredns-59dd98b545-lnklx                    Running   k8s-node02
coredns-59dd98b545-ltj5p                    Running   k8s-node03
...
```

#### sorting pods by nodeName
```bash
$ k -n <namespace> get po -o wide --sort-by="{.spec.nodeName}"
```

#### sort pods by restartCount
```bash
$ k -n <namespace> get po --sort-by="{.status.containerStatuses[:1].restartCount}"
```

#### get pods running in particular nodes
{% raw %}
```bash
$ k -n <namespace> get po --template '{{range .items}}{{if eq .spec.nodeName "<nodeName>"}}{{.metadata.name}}{{"\n"}}{{end}}}{{end}}'
```
{% endraw %}

## management
### restart po
```bash
$ k -n <namespace> get po <po-name> -o yaml | k replace --force -f -
```
- result
  ```bash
  $ k -n <namespace> get po -w
  NAME                   READY    STATUS    RESTARTS   AGE
  mypo-659f4c6d44-72hb5   1/1     Running   0          47h
  mypo-659f4c6d44-72hb5   1/1     Terminating   0          47h
  mypo-659f4c6d44-d2w76   0/1     Pending       0          0s
  mypo-659f4c6d44-d2w76   0/1     Pending       0          0s
  mypo-659f4c6d44-d2w76   0/1     ContainerCreating   0          0s
  mypo-659f4c6d44-d2w76   1/1     Running             0          2s
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          47h
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          47h
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          47h
  mypo-659f4c6d44-72hb5   0/1     Pending             0          0s
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          0s
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          0s
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          0s
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          1s
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          1s
  ```
  - or
    ```bash
    $ k -n <namespace> scale deployment <name> --replicas=0 -n service
    ```



## others
- get the first deploy name in namespace
  ```bash
  $ k -n <namespace> get deploy -o=jsonpath={.items[0].metadata.name}
  ```
- get all names
  ```bash
  $ k -n <namespace> get deploy -o=jsonpath='{.items[*].metadata.name}'
  ```
