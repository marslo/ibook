<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [list node names](#list-node-names)
  - [list all Ready nodes](#list-all-ready-nodes)
  - [list nodes metrcs](#list-nodes-metrcs)
- [with status](#with-status)
- [list node with label](#list-node-with-label)
  - [list node with multiple labels](#list-node-with-multiple-labels)
  - [update label of node](#update-label-of-node)
- [show](#show)
  - [show with labels](#show-with-labels)
  - [show particular labels](#show-particular-labels)
  - [show with particular columns](#show-with-particular-columns)
  - [show only scheduled nodes](#show-only-scheduled-nodes)
  - [show common/diff images between nodes](#show-commondiff-images-between-nodes)
- [cleanup label](#cleanup-label)
- [sort](#sort)
  - [sort via kubelet version](#sort-via-kubelet-version)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [Labels and Selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)
{% endhint %}


## list node names
```bash
$ kubectl get no --no-headers -o=custom-columns=NAME:.metadata.name

# or
$ kubectl get nodes -o 'jsonpath={.items[*].metadata.name} | fmt -1
```

### list all Ready nodes

> [!NOTE|label:references:]
> - [* JSONPath to list all nodes in ready state except the ones which are tainted?](https://stackoverflow.com/a/66931164/2940319)
> - [* list node status with jq](https://stackoverflow.com/a/58710967/2940319)
> - [Kubectl Get Nodes: Why and How to Use It](https://loft.sh/blog/kubectl-get-nodes-why-and-how-to-use-it/)
> - [Checking Kubernetes node status](https://www.ibm.com/docs/en/mvi/1.1.1?topic=environment-checking-kubernetes-node-status)
> - [Viewing and finding resources](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-and-finding-resources)
>   ```bash
>   # Check which nodes are ready
>   $ JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}' \
>     && kubectl get nodes -o jsonpath="$JSONPATH" | grep "Ready=True"
>   ```
>
> - see also
>   - [* imarslo : list all ready pods](./pod.html#list-all-ready-pods)

```bash
$ kubectl get nodes -o json | jq -r '.items[] | select(.spec.taints|not) | select(.status.conditions[].reason=="KubeletReady" and .status.conditions[].status=="True") | .metadata.name'
node-vm1
node1
node10
node11
node15
node4
node6
node8
node9
```

- list status
  ```bash
  $ kubectl get nodes -o jsonpath='{range .items[*]} {.metadata.name} {"\t"} {.status.conditions[?(@.type=="Ready")].status} {"\t"} {.spec.taints[].effect} {"\n"} {end}' | awk '$2=="True"' | awk '$3 != "NoSchedule"'
    node-vm1    True
    node1       True
    node10      True
    node11      True
    node15      True
    node4       True
    node6       True
    node8       True
    node9       True

  $ kubectl get nodes -o jsonpath='{range .items[*]} {.metadata.name} {"\t"} {.status.conditions[?(@.type=="Ready")].status} {"\t"} {.spec.taints[].effect} {"\n"} {end}' | awk '$2=="True"'
    node-vm1    True
    node1       True
    node10      True
    node11      True
    node15      True
    node2       True    NoSchedule
    node3       True    NoSchedule
    node4       True
    node5       True    NoSchedule
    node6       True
    node8       True
    node9       True
  ```

### list nodes metrcs

> [!NOTE]
> references:
> - [Need simple kubectl command to see cluster resource usage](https://github.com/kubernetes/kubernetes/issues/17512#issuecomment-313059207)

```bash
$ kubectl get no --no-headers -o=custom-columns=NAME:.metadata.name | xargs -I {} sh -c 'echo   {} ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo '

# alias
$ alias util='kubectl get no --no-headers -o=custom-columns=NAME:.metadata.name | fmt -1 | xargs -I {} sh -c '\''echo   {} ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo '\'''

# simple way
$ kubectl describe nodes | grep 'Name:\|  cpu\|  memory'
# or
$ kubectl describe nodes | grep 'Name:\|Allocated' -A 5 | grep 'Name\|memory'
# or
$ kubectl describe nodes | awk '/Allocated resources/,/Events/' | grep -v "^Events:"
# or with node name
$ kubectl describe nodes | sed -n '/^Allocated /,/^Events:/ { /^  [^(]/ p; } ; /^Name: / p'
```

- [others](https://github.com/kubernetes/kubernetes/issues/17512#issuecomment-317757388)
  ```bash
  $ alias util='kubectl get nodes --no-headers | awk '\''{print $1}'\'' | xargs -I {} sh -c '\''echo {} ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo '\'''

  # Get CPU request total (we x20 because because each m3.large has 2 vcpus (2000m) )
  alias cpualloc='util | grep % | awk '\''{print $1}'\'' | awk '\''{ sum += $1 } END { if (NR > 0) { print sum/(NR*20), "%\n" } }'\'''

  # Get mem request total (we x75 because because each m3.large has 7.5G ram )
  alias memalloc='util | grep % | awk '\''{print $5}'\'' | awk '\''{ sum += $1 } END { if (NR > 0) { print sum/(NR*75), "%\n" } }'\'''
  ```

- [cluster-wide allocation](https://github.com/kubernetes/kubernetes/issues/17512#issuecomment-370269116)
  ```bash
  $ kubectl get po --all-namespaces -o=jsonpath="{range .items[*]}{.metadata.namespace}:{.metadata.name}{'\n'}{range .spec.containers[*]}  {.name}:{.resources.requests.cpu}{'\n'}{end}{'\n'}{end}"
  ```

- [script](https://github.com/kubernetes/kubernetes/issues/17512#issuecomment-367212930)
  ```bash
  #!/bin/bash

  set -e

  KUBECTL="kubectl"
  NODES=$($KUBECTL get nodes --no-headers -o custom-columns=NAME:.metadata.name)

  function usage() {
    local node_count=0
    local total_percent_cpu=0
    local total_percent_mem=0
    local readonly nodes=$@

    for n in $nodes; do
      local requests=$($KUBECTL describe node $n | grep -A2 -E "^\\s*CPU Requests" | tail -n1)
      local percent_cpu=$(echo $requests | awk -F "[()%]" '{print $2}')
      local percent_mem=$(echo $requests | awk -F "[()%]" '{print $8}')
      echo "$n: ${percent_cpu}% CPU, ${percent_mem}% memory"

      node_count=$((node_count + 1))
      total_percent_cpu=$((total_percent_cpu + percent_cpu))
      total_percent_mem=$((total_percent_mem + percent_mem))
    done

    local readonly avg_percent_cpu=$((total_percent_cpu / node_count))
    local readonly avg_percent_mem=$((total_percent_mem / node_count))

    echo "Average usage: ${avg_percent_cpu}% CPU, ${avg_percent_mem}% memory."
  }

  usage $NODES
  ```

- [script](https://github.com/kubernetes/kubernetes/issues/17512#issuecomment-1325137987)
  ```bash
  function kusage() {
      # Function returning resources usage on current kubernetes cluster
    local node_count=0
    local total_percent_cpu=0
    local total_percent_mem=0

      echo "NODE\t\t CPU_allocatable\t Memory_allocatable\t CPU_requests%\t Memory_requests%\t CPU_limits%\t Memory_limits%\t"
    for n in $(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name); do
      local requests=$(kubectl describe node $n | grep -A2 -E "Resource" | tail -n1 | tr -d '(%)')
          local abs_cpu=$(echo $requests | awk '{print $2}')
      local percent_cpu=$(echo $requests | awk '{print $3}')
          local node_cpu=$(echo $abs_cpu $percent_cpu | tr -d 'mKi' | awk '{print int($1/$2*100)}')
          local allocatable_cpu=$(echo $node_cpu $abs_cpu | tr -d 'mKi' | awk '{print int($1 - $2)}')
          local percent_cpu_lim=$(echo $requests | awk '{print $5}')
          local requests=$(kubectl describe node $n | grep -A3 -E "Resource" | tail -n1 | tr -d '(%)')
          local abs_mem=$(echo $requests | awk '{print $2}')
      local percent_mem=$(echo $requests | awk '{print $3}')
          local node_mem=$(echo $abs_mem $percent_mem | tr -d 'mKi' | awk '{print int($1/$2*100)}')
          local allocatable_mem=$(echo $node_mem $abs_mem | tr -d 'mKi' | awk '{print int($1 - $2)}')
          local percent_mem_lim=$(echo $requests | awk '{print $5}')
      echo "$n\t ${allocatable_cpu}m\t\t\t ${allocatable_mem}Ki\t\t ${percent_cpu}%\t\t ${percent_mem}%\t\t\t ${percent_cpu_lim}%\t\t ${percent_mem_lim}%\t"

      node_count=$((node_count + 1))
      total_percent_cpu=$((total_percent_cpu + percent_cpu))
      total_percent_mem=$((total_percent_mem + percent_mem))
    done

    local avg_percent_cpu=$((total_percent_cpu / node_count))
    local avg_percent_mem=$((total_percent_mem / node_count))

    echo "Average usage (requests) : ${avg_percent_cpu}% CPU, ${avg_percent_mem}% memory."
  }
  ```

## with status

```bash
$ kubectl get nodes -o jsonpath='{range .items[*]} {.metadata.name} {"\t"} {.status.conditions[?(@.type=="Ready")].status} {"\t"} {.spec.taints[].effect} {"\n"} {end}'
  node-vm1    True
  node1       True
  node10      True
  node11      True
  node12      Unknown   NoSchedule
  node13      Unknown   NoSchedule
  node14      Unknown   NoSchedule
  node15      True
  node16      Unknown   NoSchedule
  node17      Unknown   NoSchedule
  node2       True      NoSchedule
  node3       True      NoSchedule
  node4       True
  node5       True      NoSchedule
  node6       True
  node7       Unknown   NoSchedule
  node8       True
  node9       True
```

- list all status
  ```bash
  $ kubectl get nodes -o jsonpath="{range .items[*]} {\"\n\"} {@.metadata.name} :{\"\n\"} {\"\t\"}{range @.status.conditions[*]}{@.type}={@.status} {\"\n\t\"} {end}{end}"

  node1 :
    ReadonlyFilesystem=False
    KernelDeadlock=False
    OutOfDisk=False
    MemoryPressure=False
    DiskPressure=False
    PIDPressure=False
    Ready=True

  node2 :
    ReadonlyFilesystem=False
    KernelDeadlock=False
    OutOfDisk=Unknown
    MemoryPressure=Unknown
    DiskPressure=Unknown
    PIDPressure=False
    Ready=Unknown

  node4 :
    OutOfDisk=Unknown
    MemoryPressure=Unknown
    DiskPressure=Unknown
    PIDPressure=False
    Ready=Unknown

  node-vm1 :
    OutOfDisk=False
    MemoryPressure=False
    DiskPressure=False
    PIDPressure=False
    Ready=True
  ```

## list node with label
```bash
$ kubectl get node -l <label>=<value>
```

### [list node with multiple labels](https://stackoverflow.com/a/68479227/2940319)

> [!TIP|label:tips:]
> - [* LIST and WATCH filtering](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#list-and-watch-filtering)

```bash
$ kubectl get node --selector <label>=<value>,<label>=<value>

# or
$ kubectl get node -l '<label> in (<value>), <label> in (<value>)'

# or for same label, different values
$ kubectl get node -l '<label> in (<value_1>, <value_2>)'
# i.e.:
$ kubectl get pods -l 'environment in (production, qa)'

# or `notin`
$ kubectl get node -l '<label> notin (<value>)'
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

### show common/diff images between nodes
- common
  ```bash
  $ comm -1 -2 \
         <(kubectl get node node-01 -o json | jq -re '.status.images[] | select(.names[1]) | .names[1]' | sort) \
         <(kubectl get node node-02 -o json | jq -re '.status.images[] | select(.names[1]) | .names[1]' | sort)
  ```

- diff

  > [!NOTE|label:references:]
  > - [iMarslo: directory diff](../../cheatsheet/good.html#directory-diff)

  ```bash
  $ diff --suppress-common-lines \
         --side-by-side \
         <(kubectl get node node-01 -o json | jq -re '.status.images[] | select(.names[1]) | .names[1]' | sort) \
         <(kubectl get node node-02 -o json | jq -re '.status.images[] | select(.names[1]) | .names[1]' | sort)
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
