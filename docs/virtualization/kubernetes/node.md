<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [list node with label](#list-node-with-label)
  - [update label of node](#update-label-of-node)
- [show](#show)
  - [show with labels](#show-with-labels)
  - [show particular labels](#show-particular-labels)
  - [show with particular columns](#show-with-particular-columns)
  - [show only scheduled nodes](#show-only-scheduled-nodes)
- [cleanup label](#cleanup-label)
- [sort](#sort)
  - [sort via kubelet version](#sort-via-kubelet-version)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## list node with label
```bash
$ kubectl get node -l <label>=<value>
```

### update label of node
```bash
$ kubectl label node <name> <label>=<value> [--overwrite]
```

## show
### show with labels
```bash
$ kubectl get node --show-labels
```

### show particular labels
- `--label-columns`
  ```bash
  $ kubectl get node --label-columns <label-name>
  ```
  - e.g.:
    ```bash
    $ kubectl get nodes --label-columns jenkins
    NAME          STATUS    ROLES    AGE     VERSION   JENKINS
    k8s-node01    Ready     worker   545d    v1.12.3
    k8s-node02    Ready     worker   597d    v1.12.3
    k8s-node03    Ready     worker   217d    v1.12.3
    k8s-node04    Ready     worker   52d     v1.12.3
    k8s-node05    Ready     worker   589d    v1.12.3
    k8s-node06    Ready     master   2y33d   v1.12.3   master
    k8s-node07    Ready     master   589d    v1.12.3
    k8s-node08    Ready     worker   535d    v1.12.3
    ```
- `-l`
  ```bash
  $ kubectl get node --show-labels -l node -role.kubernetes.io/master
  ```

### show with particular columns
```bash
$ kubectl get node -o custom-columns=NAME:.metadata.name,VER:.status.nodeInfo.kubeletVersion
NAME          VER
k8s-node01    v1.12.3
k8s-node02    v1.12.3
k8s-node03    v1.12.3
...
```

### show only scheduled nodes
```bash
$ kubectl get node \
          --output 'jsonpath={range $.items[*]}{.metadata.name} {.spec.taints[*].effect}{"\n"}{end}' |
          awk '!/NoSchedule/{print $1}'
```

## cleanup label
```bash
$ kubectl label node <node_name> <label>-
```
- example
  ```bash
  $ kubectl get node -l jenkins.master
  k8s-node01    Ready    worker   1d     v1.12.3
  k8s-node02    Ready    worker   1d     v1.12.3
  k8s-node03    Ready    worker   1d     v1.12.3
  $ kubectl label node master-01 jenkins.master-
  $ kubectl get node -l jenkins.master
  k8s-node02    Ready    worker   1d     v1.12.3
  k8s-node03    Ready    worker   1d     v1.12.3
  ```

## sort
### sort via kubelet version
```bash
$ kubectl get node --sort-by={.status.nodeInfo.kubeletVersion}
```
- or
  ```bash
  $ kubectl get nodes --sort-by={.metadata.labels."kubernetes\.io\/role"}
  ```
