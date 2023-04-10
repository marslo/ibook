<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [list node names](#list-node-names)
  - [list nodes metrcs](#list-nodes-metrcs)
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

## list node names
```bash
$ kubectl get no --no-headers -o=custom-columns=NAME:.metadata.name

# or
$ kubectl get nodes -o 'jsonpath={.items[*].metadata.name} | fmt -1
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
