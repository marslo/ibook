<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [filter via `--field-selector`](#filter-via---field-selector)
  - [list all `Failed` pods](#list-all-failed-pods)
  - [filter via Node Name](#filter-via-node-name)
  - [filter via json](#filter-via-json)
  - [list pod details for failure pods](#list-pod-details-for-failure-pods)
- [sort via `--sort-by`](#sort-via---sort-by)
  - [sorting pods by nodeName](#sorting-pods-by-nodename)
  - [sort pods by restartCount](#sort-pods-by-restartcount)
  - [sort by restart count](#sort-by-restart-count)
  - [sort via start time](#sort-via-start-time)
  - [get the oldest pod](#get-the-oldest-pod)
  - [sort via created time](#sort-via-created-time)
- [run & create](#run--create)
  - [pod](#pod)
  - [deploy](#deploy)
  - [svc](#svc)
- [list](#list)
  - [watch pods with timestamp](#watch-pods-with-timestamp)
  - [list pod status with timestamp](#list-pod-status-with-timestamp)
  - [list pod with nodename](#list-pod-with-nodename)
  - [list all ready pods](#list-all-ready-pods)
  - [list error status pods](#list-error-status-pods)
  - [list all pods statuses only](#list-all-pods-statuses-only)
  - [list running images](#list-running-images)
  - [list running pods](#list-running-pods)
  - [list pods on nodes](#list-pods-on-nodes)
  - [list all containers](#list-all-containers)
  - [list container images by pod](#list-container-images-by-pod)
  - [get port enabled in pod](#get-port-enabled-in-pod)
  - [get podIP](#get-podip)
  - [get the first deploy name in namespace](#get-the-first-deploy-name-in-namespace)
  - [get all deploy names](#get-all-deploy-names)
  - [`item.metadata.name`](#itemmetadataname)
- [output](#output)
  - [`-o name`](#-o-name)
  - [`--template`](#--template)
  - [custom-columns](#custom-columns)
- [management](#management)
  - [execute in pod](#execute-in-pod)
  - [restart po](#restart-po)
- [resource managemenet](#resource-managemenet)
  - [resource management for pods and containers](#resource-management-for-pods-and-containers)
  - [assign cpu resources to containers and pods](#assign-cpu-resources-to-containers-and-pods)
  - [managing kubernetes resource limits](#managing-kubernetes-resource-limits)
- [troubleshooting](#troubleshooting)
  - [debug svc](#debug-svc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [* Create static Pods](https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/)
> - [* Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle)
> - [Pods](https://kubernetes.io/docs/concepts/workloads/pods/_print/)
> - [Field Selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/field-selectors/)
> - [Kubernetes Daemonset: A Comprehensive Guide](https://devopscube.com/kubernetes-daemonset/)
> - [Kubernetes Pod Priority, PriorityClass, and Preemption Explained](https://devopscube.com/pod-priorityclass-preemption/)
{% endhint %}


> [!NOTE|label:pod phase]
>
> |   VALUE   | DESCRIPTION                                                                                                                      |
> |:---------:|----------------------------------------------------------------------------------------------------------------------------------|
> |  Pending  | The Pod has been accepted by the Kubernetes cluster, but one or more of the containers has not been set up and made ready to run |
> |  Running  | The Pod has been bound to a node, and all of the containers have been created                                                    |
> | Succeeded | All containers in the Pod have terminated in success, and will not be restarted.                                                 |
> |   Failed  | All containers in the Pod have terminated, and at least one container has terminated in failure                                  |
> |  Unknown  | For some reason the state of the Pod could not be obtained                                                                       |

## [filter via `--field-selector`](https://stackoverflow.com/a/50811992/2940319)
### list all `Failed` pods
```bash
$ kubectl -n <namespace> get po \
    --field-selector status.phase=Failed
```

### filter via Node Name
```bash
$ kubectl -n <namespace> get po \
    [-o wide] \
    --field-selector spec.nodeName=master-node01
NAME                              READY   STATUS    RESTARTS   AGE     IP            NODE            NOMINATED NODE   READINESS GATES
devops-jenkins-659f4c6d44-d2w76   1/1     Running   0          2d22h   **.***.*.**   master-node01   <none>           <none>
```

- filter all pods running in particular node
  ```bash
  $ kubectl --all-namespaces get po \
      [-o wide] \
      --field-selector spec.nodeName=<node_name>
  ```

- filter all pods running in particular node via `--template`
  {% raw %}
  ```bash
  $ kubectl -n <namespace> get po \
            --template '{{range .items}}{{if eq .spec.nodeName "<nodeName>"}}{{.metadata.name}}{{"\n"}}{{end}}}{{end}}'
  ```
  {% endraw %}

- [via api](https://stackoverflow.com/a/45518056/2940319)
  ```bash
  $ curl --cacert ca.crt \
         --cert apiserver.crt \
         --key apiserver.key \
         https://<server>:<port>/api/v1/namespaces/<namespace>/pods?fieldSelector=spec.nodeName%3Dsomenodename
  ```

### [filter via json](https://gist.github.com/so0k/42313dbb3b547a0f51a547bb968696ba)
```bash
$ kubectl get po -o json |
          jq -r '.items | sort_by(.spec.nodeName)[] | [.spec.nodeName,.metadata.name] | @tsv'
```

### list pod details for failure pods
```bash
$ ns='my-namespace'
$ kubectleyword='tester'
$ for p in $(kubectl -n ${ns} get po --field-selector status.phase=Failed -o=name | /bin/grep ${keyword}); do
    echo "--- ${p} --- ";
    kubectl -n ${ns} describe ${p} | grep -E 'Annotations|Status|Reason|Message';
done
```

## [sort via `--sort-by`](https://stackoverflow.com/a/39235513/2940319)

### sorting pods by nodeName
```bash
$ kubectl -n <namespace> get po \
    -o wide \
    --sort-by="{.spec.nodeName}"
```

### sort pods by restartCount
```bash
$ kubectl -n <namespace> get po --sort-by="{.status.containerStatuses[:1].restartCount}"
```

### sort by restart count
```bash
$ kubectl -n <namespace> get pods --sort-by=.status.containerStatuses[0].restartCount
```

### sort via start time
```bash
$ kubectl -n <namespace> get po \
    --sort-by=.status.startTime
```

### get the oldest pod

{% hint style="tip" %}
> `-1:` means the last in the list
{% endhint %}

```bash
$ kubectl -n <namepsace> get pods \
    --sort-by=.metadata.creationTimestamp \
    -o jsonpath='{.items[-1:].metadata.name}'
```

### sort via created time
```bash
$ kubectl -n <namespace> get pods \
    --sort-by=.metadata.creationTimestamp
```

## run & create

### pod

```bash
# create and login
$ kubectl run debug --image=busybox -it --rm
# create and sleep
$ kubectl run debug --image=busybox -- sleep infinity
pod/debug created
# created with specific nodeSelector
$ kubectl run debug \
              --image=busybox \
              --overrides='{"spec": { "nodeSelector": {"kubernetes.io/hostname": "k8s-node-01"} }}'

$ kubectl get pod
NAME    READY   STATUS    RESTARTS   AGE
debug   1/1     Running   0          6s

# delete
$ kubectl delete pod/debug
pod "debug" deleted

# attach
$ kubectl attach <pod-name> -c <container-name> -it
# i.e.:
$ kubectl attach debug -c debug -it
```

### deploy
```bash
# format
$ kubectl create deployment <name> --image=<image:tag> [--replicas=n]
# i.e.:
$ kubectl create deployment nginx --image=nginx --replicas=2
deployment.apps/nginx created

# optional
$ kubectl scale deployment nginx --replicas=3

$ kubectl get pod
NAME                     READY   STATUS    RESTARTS   AGE
nginx-6799fc88d8-6clhp   1/1     Running   0          9s
nginx-6799fc88d8-cjz56   1/1     Running   0          9s

# delete
$ kubectl delete deployment nginx
deployment.apps "nginx" deleted
```

### svc
```bash
$ kubectl expose deployment <name> --port=80 --target-port=9376
```

## list
### watch pods with timestamp

> [!NOTE|label:references:]
> - [Append timestamp to kubernetes --watch-only command](https://stackoverflow.com/q/63252502/2940319)

```bash
$ kubectl get pods --watch-only |
  while read line ; do echo -e "$(date +"%Y-%m-%d %H:%M:%S.%3N")\t pods\t $line" ; done
```

### list pod status with timestamp

> [!NOTE|label:references:]
> - [Can kubectl describe show timestamp of pod events?](https://stackoverflow.com/a/59846576/2940319)

- via evnets
  ```bash
  $ kubectl get events -o custom-columns=FirstSeen:.firstTimestamp,LastSeen:.lastTimestamp,Count:.count,From:.source.component,Type:.type,Reason:.reason,Message:.message \
            --field-selector involvedObject.kind=Pod,involvedObject.name=<pod-name>
  ```

- via pod json
  ```bash
  $ kubectl get po <pod-name> -o json | jq -r '.status.conditions'
  [
    {
      "lastProbeTime": null,
      "lastTransitionTime": "2023-09-28T08:15:33Z",
      "status": "True",
      "type": "Initialized"
    },
    {
      "lastProbeTime": null,
      "lastTransitionTime": "2023-11-23T02:33:09Z",
      "message": "containers with unready status: [config-reload]",
      "reason": "ContainersNotReady",
      "status": "False",
      "type": "Ready"
    },
    {
      "lastProbeTime": null,
      "lastTransitionTime": "2023-11-23T02:33:09Z",
      "message": "containers with unready status: [config-reload]",
      "reason": "ContainersNotReady",
      "status": "False",
      "type": "ContainersReady"
    },
    {
      "lastProbeTime": null,
      "lastTransitionTime": "2023-09-28T08:15:16Z",
      "status": "True",
      "type": "PodScheduled"
    }
  ]
  ```

### list pod with nodename
- filter
  ```bash
  $ kubectl get po --all-namespaces -o wide --field-selector spec.nodeName=<nodeName>
  ```

- [list](https://stackoverflow.com/a/64047982/2940319)
  ```bash
  $ kubectl get pods \
                --all-namespaces \
                --output 'jsonpath={range .items[*]}{.spec.nodeName}{"\t"}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}
  ```
- [or list with custom-columns](https://stackoverflow.com/a/48983984/2940319)
  ```bash
  $ kubectl get pod \
                --all-namespaces
                -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName \
  ```

- [list nodeName with podIP](https://stackoverflow.com/a/48983623/2940319)
  ```bash
  $ kubectl get pod \
                --all-namespaces \
                -o json |
                jq '.items[] | .spec.nodeName + " " + .status.podIP'
  ```

### [list all ready pods](https://stackoverflow.com/a/58993242/2940319)

> [!NOTE|label:references]
> - [* imarslo : list all ready nodes](./node.html#list-all-ready-nodes)

```bash
$ kubectl get pods --all-namespaces -o json |
          jq -r '.items[] | select(.status.phase = "Ready" or ([ .status.conditions[] | select(.type == "Ready") ] | length ) == 1 ) | .metadata.namespace + "\t" + .metadata.name'
```

- [list all `ImagePullBackOff` pods](https://stackoverflow.com/a/57222958/2940319)

  > [!NOTE|label:references]
  > - [How can I view pods with kubectl and filter based on having a status of ImagePullBackOff?](https://stackoverflow.com/a/57222793/2940319)

  ```bash
  $ kubectl get pod --all-namespaces \
                    -o=json |
                    jq '.items[]|select(any( .status.containerStatuses[]; .state.waiting.reason=="ImagePullBackOff"))|.metadata.name'

  # or
  $ kubectl get pod --all-namespaces \
                    -o jsonpath='{.items[?(@.status.containerStatuses[*].state.waiting.reason=="ImagePullBackOff")].metadata.name}'
  ```

### [list error status pods](https://stackoverflow.com/a/53327330/2940319)

{% hint style='tip' %}
> reference:
> - [Viewing, finding resources](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#viewing-finding-resources)
> - [`kubectl get` should have a way to filter for advanced pods status](https://github.com/kubernetes/kubernetes/issues/49387)
{% endhint %}

```bash
$ kubectl -n <namespace> get po \
          --field-selector status.phase=Failed
```

#### list and delete all error status pods
```bash
$ for i in $(kubectl get po --no-headers --all-namespaces --field-selector status.phase=Failed -o=custom-columns=NAMESPACE:.metadata.namespace | sort -u); do
    kubectl -n $i delete po --field-selector status.phase=Failed --force --grace-period=0
  done
```

- or
  ```bash
  $ kubectl -n <namespace> delete po \
            --field-selector status.phase=Failed
  ```

- [or](https://github.com/kubernetes/kubernetes/issues/49387#issuecomment-346746104)
  ```bash
  $ kubectl -n <namespace> get po \
            --field-selector=status.phase!=Running
  ```

- [or](https://github.com/kubernetes/kubernetes/issues/49387#issuecomment-504405180)
  ```bash
  $ kubectl --all-namespaces get po \
            --field-selector=status.phase!=Running,status.phase!=Succeeded
  ```

- [or](https://github.com/kubernetes/kubernetes/issues/49387#issuecomment-346573122)
  ```bash
  $ kubectl get po --all-namespaces -o json  \
          | jq -r '.items[] \
          | select(.status.phase != "Running" \
                   or ([ .status.conditions[] | select(.type == "Ready" and .status == "False") ] | length ) == 1 \
                  ) \
          | .metadata.namespace + "/" + .metadata.name'
  ```

### [list all pods statuses only](https://medium.com/faun/kubectl-commands-cheatsheet-43ce8f13adfb)
```bash
$ kubectl -n <namespace> get po \
          -o=jsonpath='{.items[*].status.phase}'
Running Running Running Running Running Running Running Running Running
```

### list running images
```bash
$ kubectl4 -n <namespace> get po -o jsonpath="{..image}" |
     tr -s '[[:space:]]' '\n' |
     sort |
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

### list running pods
```bash
$ kubectl -n <namespace> get po \
          -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName
NAME                                        STATUS    NODE
coredns-59dd98b545-7t25l                    Running   k8s-node01
coredns-59dd98b545-lnklx                    Running   k8s-node02
coredns-59dd98b545-ltj5p                    Running   k8s-node03
...
```

### [list pods on nodes](https://stackoverflow.com/a/39235513/2940319)

- specific nodes
  ```bash
  $ kubectl get pods --all-namespaces \
                     -o wide \
                     --field-selector spec.nodeName=<node>
  ```

- all nodes
  ```bash
  $ kubectl get pods -o wide \
                     --sort-by="{.spec.nodeName}"
  ```

  - via label filter
    ```bash
    $ for n in $(kubectl get nodes -l your_label_key=your_label_value --no-headers | cut -d " " -f1); do
        kubectl get pods --all-namespaces  --no-headers --field-selector spec.nodeName=${n}
      done
    ```

  - via API
    ```bash
    $ curl --cacert ca.crt \
           --cert apiserver.crt \
           --key apiserver.key \
           https://<server>:<port>/api/v1/namespaces/<namespace>/pods?fieldSelector=spec.nodeName%3Dsomenodename
    ```

### list all containers

> [!NOTE|label:references:]
> - [List All Container Images Running in a Cluster](https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/)

- list container images

  {% raw %}
  ```bash
  $ kubectl get po -o jsonpath="{.items[*].spec['initContainers', 'containers'][*].image}" |
            tr -s '[[:space:]]' '\n' |
            sort |
            uniq -c
        2 jenkins:2.452.2-lts-jdk17
        2 docker.io/kiwigrid/k8s-sidecar:1.27.4

  # or
  $ kubectl get pods -o go-template --template="{{range .items}}{{range .spec.containers}}{{.image}} {{end}}{{end}}"
  jenkins:2.452.2-lts-jdk17 docker.io/kiwigrid/k8s-sidecar:1.27.4
  ```
  {% endraw %}

  - for all namespaces
    - [list all container images in all namespaces](https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/)
    ```bash
    $ kubectl get pods \
                  --all-namespaces \
                  -o jsonpath="{.items[*].spec.containers[*].image}" |
                  tr -s '[[:space:]]' '\n' |
                  sort |
                  uniq -c
    # or
    $ kubectl get pods \
                  --all-namespaces \
                  -o jsonpath="{.items[*].spec.containers[*].image}"
    ```

### [list container images by pod](https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/#list-container-images-by-pod)
  ```bash
  $ kubectl get pods \
                --all-namespaces \
                -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' |
                sort
  ```

- list container names
  ```bash
  $ kubectl get po -o jsonpath="{.items[*].spec['initContainers', 'containers'][*].name}" |
          tr -s '[[:space:]]' '\n' |
          sort |
          uniq -c
        1 config-reload
        1 config-reload-init
        1 init
        1 jenkins
  ```

- list container image by pod
  ```bash
  $ kubectl get po -o jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' | sort

  staging-jenkins-0:        jenkins:2.452.2-lts-jdk17, docker.io/kiwigrid/k8s-sidecar:1.27.4,
  ```

### get port enabled in pod
```bash
$ kubectl get po jenkins-0 -o jsonpath='{.spec.containers[*].ports[*]}'
{"containerPort":8080,"name":"http","protocol":"TCP"} {"containerPort":50000,"name":"agent-listener","protocol":"TCP"} {"containerPort":50017,"name":"sshd-listener","protocol":"TCP"}

# or
$ kubectl get po jenkins-0 -o jsonpath="{range .spec.containers[*].ports[*]}{@.*}{'\n'}{end}" | column -t
http            8080   TCP
agent-listener  50000  TCP
sshd-listener   50017  TCP
```

### [get podIP](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)
```bash
$ kubectl get po <pod-name> -o go-template='{{range .items}}{{.status.podIP}}{{"\n"}}{{end}}'
10.244.140.106
```

### get the first deploy name in namespace
```bash
$ kubectl -n <namespace> get deploy -o=jsonpath={.items[0].metadata.name}
```

### get all deploy names
```bash
$ kubectl -n <namespace> get deploy -o=jsonpath='{.items[*].metadata.name}'
```

### `item.metadata.name`
- list via `jsonpath={.items..metadata.name}`
  ```bash
  $ kubectl -n kube-system get po --output=jsonpath={.items..metadata.name}
  coredns-c7ddbcccb-5cj5z coredns-c7ddbcccb-lxsw6 coredns-c7ddbcccb-prjfk ...
  ```
  - or
    ```bash
    $ kubectl -n kube-system get po -o jsonpath="{range .items[*]}{@.metadata.name}{'\n'}{end}" |
              head -10
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


## output

{% hint style='tip' %}
> references:
> - [Inspired from here](https://stackoverflow.com/a/51612372/2940319)
> - [Kubectl - Introduce "custom-columns" variant to add additional columns to output](https://github.com/kubernetes/kubernetes/issues/98368#issuecomment-767298880)
{% endhint %}

### `-o name`
```bash
$ kubectl -n kube-system get pods -o name | head
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

### `--template`
{% raw %}
```bash
$ kubectl -n kube-system get pods \
          -o go-template \
          --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' |
          head
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

- or
  {% raw %}
  ```bash
  $ kubectl -n kube-system get pods \
            --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' |
            head
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

### custom-columns
- `Name:.metadata.name`
  ```bash
  $ kubectl get po --all-namespaces \
                   -o=custom-columns=NAMESPACE:.metadata.namespace
  ```
- `NODE:.spec.nodeName`
- `IPS:status.podIPs`
- `PHASE:.status.phase`
- `RESTARTS:RESTART:.status.containerStatuses[0].restartCount`
- `IMAGE:.spec.containers[0].image`
- `CREATED:.metadata.creationTimestamp`
- `LABELS:.metadata.labels`
- `QOS-CLASS:.status.qosClass`

#### [list all images running in particular namespace](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#formatting-output)
  ```bash
  $ kubectl -n <namespace> get po \
            --output=custom-columns="NAME:.metadata.name,IMAGE:.spec.containers[*].image"
  ```

  - list all images exclude `'k8s.gcr.io/coredns:1.6.2'`
    ```bash
    $ kubectl --all-namespaces get pods \
              -o=custom-columns='DATA:spec.containers[?(@.image!="k8s.gcr.io/coredns:1.6.2")].image'
    ```

#### [list via `-o custom-columns=":metadata.name"`](https://stackoverflow.com/a/52691455/2940319)
```bash
$ kubectl -n kube-system get pods -o custom-columns=":metadata.name" | head
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

#### QOS
```bash
$ kubectl -n kube-system get po \
          -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,QOS-CLASS:.status.qosClass
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

## management

### execute in pod
```bash
$ kubectl -n devops exec -it devops-jenkins-659f4c6d44-d2w76 -- /bin/bash
jenkins@devops-jenkins-659f4c6d44-d2w76:/$ echo $HOME
/var/jenkins_home
jenkins@devops-jenkins-659f4c6d44-d2w76:/$ hostname
devops-jenkins-659f4c6d44-d2w76
```

### restart po

{% hint style='tip' %}
> reference:
> - [Restarting Kubernetes Pods](https://phoenixnap.com/kb/how-to-restart-kubernetes-pods)
> - [How to Restarting Kubernetes Pods](https://www.cloudytuts.com/tutorials/kubernetes/how-to-restarting-kubernetes-pods/)
> - [How to gracefully remove a node from Kubernetes?](https://stackoverflow.com/a/68910564/2940319)
> for kubernetes version 1.15+
> - `kubectl -n <namespace> rollout restart deployment <name>`
{% endhint %}

```bash
$ kubectl -n <namespace> get po <po-name> -o yaml | kubectl replace --force -f -
```
- result
  ```bash
  $ kubectl -n <namespace> get po -w
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
    $ kubectl -n <namespace> scale deployment <name> --replicas=0
    ```

## resource managemenet

### [resource management for pods and containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
### [assign cpu resources to containers and pods](https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/)
### [managing kubernetes resource limits](https://www.densify.com/kubernetes-tools/kubernetes-resource-limits/)


## troubleshooting

> [!NOTE|label:references:]
> - [How To Troubleshoot Kubernetes Pods: Beginners Guide](https://devopscube.com/troubleshoot-kubernetes-pods/)

- [simple pods](https://tonybai.com/2017/05/15/setup-a-ha-kubernetes-cluster-based-on-kubeadm-part2/)
  ```yaml
  # run-nginx.yml

  apiVersion: extensions/v1beta1
  kind: Deploy
  metadata:
    name: my-nginx
  spec:
    replicas: 2
    template:
      metadata:
        labels:
          run: my-ngxin
      spec:
        containers:
        - name: my-nginx
          image: nginx:1.10.1
          ports:
          - containerPort: 80
  ```

- kubectl run
  ```bash
  $ kubectl run ubuntu-marslo \
                --image=ubuntu:18.04 \
                --overrides='{"spec": { "nodeSelector": {"kubernetes.io/hostname": "k8s-node-01"}}}' \
                -- sleep infinity

  # or
  $ kubectl run ubuntu-marslo \
                --image=ubuntu:18.04 \
                --overrides='{"spec": { "nodeSelector": {"kubernetes.io/hostname": "k8s-node-01"}}}' \
                -it \
                --rm
  ```

### debug svc

> [!NOTE|labels:referencds:]
> - [DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
> - svc in cluster can be visit via
>   - `CLUSTER-IP`
>   - `<svc-name>.<namespace>.svc.cluster.local`

```bash
# current svc
$ kubectl get svc
NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)              AGE
jenkins   ClusterIP   10.111.230.13   <none>        8080/TCP,30338/TCP   18h

# create new pod
$ kubectl run ubuntu-marslo \
              --image=ubuntu:18.04 \
              --overrides='{"spec": { "nodeSelector": {"kubernetes.io/hostname": "k8s-node-01"}}}' \
              -it \
              --rm

# check DNS
<ubuntu-marslo> $ cat /etc/resolv.conf
nameserver 10.96.0.10
search devops.svc.cluster.local svc.cluster.local cluster.local company.com
options ndots:5

# debug
$ nc -zv jenkins.devops.svc.cluster.local 30338
$ nc -zv 10.111.230.13                    30338
$ ssh -l marslo -p 30338 -i ~/.ssh/id_rsa jenkins.devops.svc.cluster.local list-plugins
$ ssh -l marslo -p 30338 -i ~/.ssh/id_rsa 10.111.230.13                    list-plugins
```
