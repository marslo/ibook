<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [execute in pod](#execute-in-pod)
- [list, filter and sort](#list-filter-and-sort)
  - [`--field-selector`](#--field-selector)
  - [`--sort-by`](#--sort-by)
  - [List Pods name](#list-pods-name)
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
