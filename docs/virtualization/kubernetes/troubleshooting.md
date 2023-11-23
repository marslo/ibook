<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [error code](#error-code)
- [debug services](#debug-services)
  - [get podIp](#get-podip)
- [check log](#check-log)
  - [system logs](#system-logs)
  - [pod logs](#pod-logs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP]
> - [Troubleshooting Applications](https://kubernetes.io/docs/tasks/debug/debug-application/)
>   - [Debug Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-pods/)
>   - [Debug Service](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)
>   - [Debug a StatefulSet](https://kubernetes.io/docs/tasks/debug/debug-application/debug-statefulset/)
>   - [Determine the Reason for Pod Failure](https://kubernetes.io/docs/tasks/debug/debug-application/determine-reason-pod-failure/)
>   - [Debug Init Containers](https://kubernetes.io/docs/tasks/debug/debug-application/debug-init-containers/)
>   - [Debug Running Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/)
>   - [Get a Shell to a Running Container](https://kubernetes.io/docs/tasks/debug/debug-application/get-shell-running-container/)
> - [Troubleshooting Clusters](https://kubernetes.io/docs/tasks/debug/debug-cluster/)
>   - [Resource metrics pipeline](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
>   - [Tools for Monitoring Resources](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-usage-monitoring/)
>   - [Monitor Node Health](https://kubernetes.io/docs/tasks/debug/debug-cluster/monitor-node-health/)
>   - [Debugging Kubernetes nodes with crictl](https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl/)
>   - [Debugging Kubernetes Nodes With Kubectl](https://kubernetes.io/docs/tasks/debug/debug-cluster/kubectl-node-debug/)
>   - [Developing and debugging services locally using telepresence](https://kubernetes.io/docs/tasks/debug/debug-cluster/local-debugging/)
>   - [Auditing](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)
>   - [Windows debugging tips](https://kubernetes.io/docs/tasks/debug/debug-cluster/windows/)
> - [Communicate Between Containers in the Same Pod Using a Shared Volume](https://kubernetes.io/docs/tasks/access-application-cluster/communicate-containers-same-pod-shared-volume/)
> - [Translate a Docker Compose File to Kubernetes Resources](https://kubernetes.io/docs/tasks/configure-pod-container/translate-compose-kubernetes/)
> - [pod资源限制和QoS探索](https://blog.csdn.net/qq_38773184/article/details/113484004)
> - [【K8S系列】Pod重启策略及重启可能原因](http://681314.com/A/AB5feaIfxi)
> - [POD的内存限制 和 OOM Killer](https://zhuanlan.zhihu.com/p/142443173?hmsr=toutiao.io)
> - [记一次k8s pod频繁重启的优化之旅](https://www.cnblogs.com/chopper-poet/p/15328054.html)

## error code

| ERROR CODE                            | COMMENTS                                                                  |
|---------------------------------------|---------------------------------------------------------------------------|
| OOMKilled                             | pod运行过程内存需求持续增加超过为pod设置的内存大小                        |
| Pending                               | 调度不成功 or 资源不足 or HostPort 已被占用                               |
| Waiting/ContainerCreating             | 镜像拉取失败 or CNI网络错误 or 容器无法启动 or 磁盘坏道input/output error |
| CrashLoopBackOff                      | 容器曾经启动了但又异常退出                                                |
| ImagePullBackOff                      | 镜像名称配置错误或者私有镜像的密钥配置错误导致                            |
| CrashLoopBackOff                      | 容器退出kubelet正在将它重启                                               |
| InvalidImageName                      | 无法解析镜像名称                                                          |
| ImageInspectError                     | 无法校验镜像                                                              |
| ErrImageNeverPull                     | 策略禁止拉取镜像                                                          |
| ImagePullBackOff                      | 正在重试拉取                                                              |
| RegistryUnavailable                   | 连接不到镜像中心                                                          |
| ErrImagePull                          | 通用的拉取镜像出错                                                        |
| CreateContainerConfigError            | 不能创建kubelet使用的容器配置                                             |
| CreateContainerError                  | 创建容器失败                                                              |
| m.internalLifecycle.PreStartContainer | 执行hook报错                                                              |
| RunContainerError                     | 启动容器失败                                                              |
| PostStartHookError                    | 执行hook报错                                                              |
| ContainersNotInitialized              | 容器没有初始化完毕                                                        |
| ContainersNotReady                    | 容器没有准备完毕                                                          |
| ContainerCreating                     | 容器创建中                                                                |
| PodInitializingpod                    | 初始化中                                                                  |
| DockerDaemonNotReady                  | docker还没有完全启动                                                      |
| NetworkPluginNotReady                 | 网络插件还没有完全启动                                                    |
| Evicte                                | pod被驱赶                                                                 |

## debug services

> [!NOTE|label:reference:]
> - [How to Debug a Kubernetes Service Effectively](https://blog.getambassador.io/how-to-debug-a-kubernetes-service-effectively-3d4eff0b221a)
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
search devops.svc.cluster.local svc.cluster.local cluster.local company.com
options ndots:5

# debug
$ nc -zv jenkins.devops.svc.cluster.local 30338
$ nc -zv 10.111.230.13                    30338
$ ssh -l marslo -p 30338 -i ~/.ssh/id_rsa jenkins.devops.svc.cluster.local list-plugins
$ ssh -l marslo -p 30338 -i ~/.ssh/id_rsa 10.111.230.13                    list-plugins
```

### get podIp
```bash
$ kubectl get pods \
              -l app=hostnames \
              -o go-template='{{range .items}}{{.status.podIP}}{{"\n"}}{{end}}'
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

