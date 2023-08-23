<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [docker exec](#docker-exec)
  - [login docker container as root](#login-docker-container-as-root)
- [docker run](#docker-run)
  - [run into dind](#run-into-dind)
  - [run to override entrypoint](#run-to-override-entrypoint)
  - [run commands to override entrypoint](#run-commands-to-override-entrypoint)
  - [runtime options with memory, cpus, and gpus](#runtime-options-with-memory-cpus-and-gpus)
  - [run with always restart](#run-with-always-restart)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## docker exec
### login docker container as root
```bash
$ docker run -d <image>:<tag>
$ docker exec --privileged -u root -it <image-id> /bin/bash
```

## docker run
### run into dind
```bash
$ docker run \
         --name "marslo" \
         --entrypoint /bin/bash \
         --privileged \
         --rm \
         -it \
         -v /var/run/docker.sock:/var/run/docker.sock \
         docker:dind

$ ubuntu@01acbffd94ec:~$ docker --version
Docker version 18.06.1-ce, build e68fc7a
```

### run to override entrypoint
```bash
$ docker run \
         --name marslo \
         -it \
         --entrypoint /bin/bash \
         docker:dind
```

### run commands to override entrypoint
```bash
$ docker run  \
         -it  \
         --rm \
         --entrypoint /bin/bash \
         docker:dind \
         -c 'cat /etc/*-release'
```

### [runtime options with memory, cpus, and gpus](https://docs.docker.com/config/containers/resource_constraints/)
> reference:
> - [Docker容器CPU、memory资源限制](https://blog.csdn.net/czz1141979570/article/details/105980641/)
> - [Memory Resource Controller](https://www.kernel.org/doc/Documentation/cgroup-v1/memory.txt)
> - [CPU Accounting Controller](https://www.kernel.org/doc/Documentation/cgroup-v1/cpuacct.txt)
> - [CFS Bandwidth Control](https://www.kernel.org/doc/Documentation/scheduler/sched-bwc.txt)
> - [RedHat: 3.3. CPUACCT](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/resource_management_guide/sec-cpuacct)
> - [RedHat: 3.4. CPUSET](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/resource_management_guide/sec-cpuset)

{% hint style='tip' %}

> Brief summary of control files
> - `/sys/fs/cgroup/memory/docker/ID/memory.usage_in_bytes` : show current usage for memory
> - `/sys/fs/cgroup/memory/docker/ID/memory.limit_in_bytes` : set/show limit of memory usage
> - `/sys/fs/cgroup/cpuacct/docker/ID/cpuacct.usage` : show the total CPU time (in nanoseconds) consumed by all tasks in this cgroup
> - `/sys/fs/cgroup/cpuacct/docker/ID/cpuacct.stat` : show the user and system CPU time consumed by all tasks in this cgroup
> - `/sys/fs/cgroup/cpuacct/docker/ID/cpuacct.usage_percpu`: show the CPU time (in nanoseconds) consumed on each CPU by all tasks in this cgroup
{% endhint %}

- memory
  ```bash
  $ docker run \
           --name marslo \
           -it \
           --entrypoint /bin/bash \
           --memory=4G \
           --oom-kill-disable \         // optional
           docker:dind
  ```

- cpu
  ```bash
  $ docker run \
           --name marslo \
           -it \
           --entrypoint /bin/bash \
           --cpus="4" \
           docker:dind
  ```


### run with always restart
{% hint style='tip' %}
> `docker: Conflicting options: --restart and --rm.`
{% endhint %}

```bash
$ docker run \
         -d \
         --name ss-libev \
         --restart=always \
         -p 8443:8443 \
         -p 8443:8443/udp \
         -v /etc/shadowsocks-libev:/etc/shadowsocks-libev \
         teddysun/shadowsocks-libev
```

- visit via
  ```bash
  $ docker exec -it ss-libev /bin/sh
  ```
