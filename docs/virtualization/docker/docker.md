<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [docker internals](#docker-internals)
  - [cgoups](#cgoups)
  - [namespace](#namespace)
  - [docker daemon](#docker-daemon)
- [enable tcp port 2375 for external connection to docker](#enable-tcp-port-2375-for-external-connection-to-docker)
- [docker completion](#docker-completion)
  - [Linux](#linux)
  - [OSX](#osx)
- [docker build](#docker-build)
- [docker run](#docker-run)
  - [run into dind](#run-into-dind)
  - [run to override entrypoint](#run-to-override-entrypoint)
  - [runtime options with memory, cpus, and gpus](#runtime-options-with-memory-cpus-and-gpus)
  - [run with always restart](#run-with-always-restart)
- [docker exec](#docker-exec)
  - [login docker container as root](#login-docker-container-as-root)
- [docker ps](#docker-ps)
  - [list without wrap](#list-without-wrap)
  - [filter](#filter)
  - [format](#format)
- [docker rmi](#docker-rmi)
  - [docker rmi for keywords](#docker-rmi-for-keywords)
- [docker rm](#docker-rm)
- [docker stats](#docker-stats)
- [docker inspect](#docker-inspect)
  - [show entrypoint](#show-entrypoint)
  - [list environment](#list-environment)
  - [check mounts](#check-mounts)
  - [log path](#log-path)
  - [get full container ID](#get-full-container-id)
  - [check repo tag](#check-repo-tag)
- [docker proxy](#docker-proxy)
  - [docker build proxy](#docker-build-proxy)
  - [docker pull proxy](#docker-pull-proxy)
- [dockerfile](#dockerfile)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [Docker 学习笔记](https://blog.opskumu.com/docker.html)
> - [Understanding the Docker Internals](https://medium.com/%40BeNitinAgarwal/undersanding-the-docker-internals-7ccb052ce9fe)
> - [Ideas for a cgroups UI](https://mairin.wordpress.com/2011/05/13/ideas-for-a-cgroups-ui/)
> - [Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#defining-a-liveness-command)
> - [Docker for Windows: Deploying a docker-compose app to local Kubernetes](https://marcesher.com/2018/03/28/docker-for-windows-deploying-a-docker-compose-app-to-local-kubernetes/)
> - [Windows for Linux Nerds](https://blog.jessfraz.com/post/windows-for-linux-nerds/)
> - [Running Docker on WSL2 without Docker Desktop](https://technotes.adelerhof.eu/wsl/docker_on_wsl2/)
> - [Copy Docker repositories](https://technotes.adelerhof.eu/post/migrate_docker/)
> - [Docker storage drivers](https://docs.docker.com/storage/storagedriver/select-storage-driver/)
{% endhint %}

## docker internals
![docker internals](../../screenshot/docker/docker-internals.png)

### cgoups
![docker cgoups](../../screenshot/docker/docker-cgroup.png)

### namespace
![docker namespace](../../screenshot/docker/docker-namespace.png)

### docker daemon

> [!TIP]
> references:
> - [Protect the Docker daemon socket](https://docs.docker.com/engine/security/protect-access/)
> - [Configure and troubleshoot the Docker daemon](https://docs.docker.com/config/daemon/)
> - [Set Up Docker with TLS](https://www.labkey.org/Documentation/wiki-page.view?name=dockerTLS)
> - [How to Configure Docker daemon with a configuration file?](https://www.devopsschool.com/blog/how-to-configure-docker-daemon-with-a-configuration-file/)

## [enable tcp port 2375 for external connection to docker](https://gist.github.com/styblope/dc55e0ad2a9848f2cc3307d4819d819f)

{% hint style='tip' %}
> references:
> - [* Configure where the Docker daemon listens for connections](https://docs.docker.com/engine/install/linux-postinstall/#configure-where-the-docker-daemon-listens-for-connections)
> - [* styblope/docker-api-port.md](https://gist.github.com/styblope/dc55e0ad2a9848f2cc3307d4819d819f)
> - [* Configure the daemon](https://docs.docker.com/config/daemon/)
>   - [Configure and troubleshoot the Docker daemon](https://docs.docker.com/config/daemon/)
>   - [Control Docker with systemd](https://docs.docker.com/config/daemon/systemd/)
>   - [Configure the daemon for IPv6](https://docs.docker.com/config/daemon/ipv6/)
>   - [Docker and iptables](https://docs.docker.com/network/iptables/)
> - [Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script)
> - [Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)
> - [Docker security : Docker daemon attack surface](https://docs.docker.com/engine/security/#docker-daemon-attack-surface)
{% endhint %}

```bash
$ cat /etc/docker/daemon.json
{
  "hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"]
}

$ sudo systemctl edit docker.service
# or
$ cat /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://127.0.0.1:2375 [--config-file /etc/docker/daemon.json]

$ sudo systemctl daemon-reload
$ sudo systemctl restart docker.service

# result
$ sudo netstat -lntp | grep dockerd
tcp6       0      0 :::2375                 :::*                    LISTEN      5649/dockerd
```

- result
  ```bash
  $ sudo cat /etc/docker/daemon.json
  {
    "hosts": ["unix:///var/run/docker.sock", "fd://", "tcp://0.0.0.0:2375"]
  }

  $ sudo cat /etc/systemd/system/docker.service.d/docker.conf
  [Service]
  ExecStart=
  ExecStart=/usr/bin/dockerd

  $ docker -H tcp://0.0.0.0:2376 pull ubuntu:18.04
  18.04: Pulling from library/ubuntu
  a404e5416296: Pull complete
  Digest: sha256:ca70a834041dd1bf16cc38dfcd24f0888ec4fa431e09f3344f354cf8d1724499
  Status: Downloaded newer image for ubuntu:18.04
  ```
  - verify
    ```bash
    $ ip -4 a s en1
    5: en1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
        inet x.x.x.x/24 brd x.x.x.255 scope global noprefixroute en1
           valid_lft forever preferred_lft forever

    $ nc -zv <target.ip.address> 2375
    Connection to target.ip.address 2375 port [tcp/*] succeeded!

    $ docker -H tcp://<target.ip.address>:2375 images
    REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
    ubuntu       18.04     71eaf13299f4   2 weeks ago   63.1MB
    ```

- or modify in `/lib/systemd/system/docker.service`
  ```bash
  # Replacing this line:
  ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

  # With this line:
  ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock [--tls=false]
  ```

- or via `socat`
  ```bash
  exec socat -d TCP-LISTEN:2375,fork UNIX-CONNECT:/var/run/docker.sock
  ```

## docker completion

{% hint style='tip' %}
> references:
> - [command-line completion](https://docs.docker.com/compose/completion/)
{% endhint %}

### [Linux](https://stackoverflow.com/a/34350381/2940319)
```bash
$ curl -fsSL https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker \
       -o /etc/bash_completion.d/docker
```

- load completion
  ```bash
  $ grep 'bash_completion' /etc/bashrc
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  fi

  $ cat /usr/share/bash-completion/bash_completion
  ...
  2070 # source compat completion directory definitions
  2071 compat_dir=${BASH_COMPLETION_COMPAT_DIR:-/etc/bash_completion.d}
  2072 if [[ -d $compat_dir && -r $compat_dir && -x $compat_dir ]]; then
  2073     for i in "$compat_dir"/*; do
  2074         [[ ${i##*/} != @($_backup_glob|Makefile*|$_blacklist_glob) \
  2075             && -f $i && -r $i ]] && . "$i"
  2076     done
  2077 fi
  2078 unset compat_dir i _blacklist_glob
  2079
  2080 # source user completion file
  2081 user_completion=${BASH_COMPLETION_USER_FILE:-~/.bash_completion}
  2082 [[ ${BASH_SOURCE[0]} != $user_completion && -r $user_completion ]] \
  2083     && . $user_completion
  2084 unset user_completion
  ...
  ```

### OSX
```bash
bashComp="$(brew --prefix)/etc/bash_completion.d"
bashComp2="$(brew --prefix)/etc/profile.d/bash_completion.sh"
dApp="/Applications/Docker.app"
dmver='0.16.2'
gitcontent='https://raw.githubusercontent.com'
dm="${gitcontent}/docker/machine/v${dmver}/contrib/completion/bash/docker-machine.bash"
curlOpt='-x 127.0.0.1:1087 -fsSL'

brew install bash-completion@2
sudo curl ${curlOpt} ${dm} --output ${bashComp}/docker-machine.bash
for _i in docker.bash-completion docker-compose.bash-completion; do
  ln -s ${dApp}/Contents/Resources/etc/${_i} ${bashComp}/${_i}
done

cat > ~/.bash_profile << EOF
if command -v brew > /dev/null; then
  # bash-completion
  [ -f "${bashComp}" ] && export BASH_COMPLETION_COMPAT_DIR="${bashComp}" && source "${bashComp}";
  # bash-completion@2
  [ -f "${bashComp2}" ] && source "${bashComp2}";
fi
EOF
```

- result
  ```bash
  $ complete -p d
  complete -F _complete_alias d
  $ complete -p dls
  complete -F _complete_alias dls

  # others:
  $ complete -p k
  complete -F _complete_alias k
  $ complete -p git
  complete -o bashdefault -o default -o nospace -F __git_wrap__git_main git
  ```

## docker build
> [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
> [Create a base image](https://docs.docker.com/develop/develop-images/baseimages/)
> [Dockerfile reference](https://docs.docker.com/engine/reference/builder/#entrypoint)

```bash
$ docker build \
         --no-cache \
         --build-arg REPO=<private.registry.com> \
         --build-arg TAG=1.4-bionic \
         -t <private.registry.com>/devops/jnlp.bionic \
         -f devops-jnlp .
```

### check docker layer

> [!TIP]
> references:
> - [docker history](https://stackoverflow.com/a/30133768/2940319)

```bash
$ docker history [--no-trunc=true] <image>:<tag>
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
af73a9899a8f        6 months ago        /bin/sh -c #(nop) WORKDIR /home/devops          0B
e96534e326ed        6 months ago        /bin/sh -c #(nop)  VOLUME [/home/devops/.ssh]   0B
4d3392929105        6 months ago        |5 VERSION=1.6 gid=1000 group=devops uid=100…   884B
8abbc25a66a4        6 months ago        |5 VERSION=1.6 gid=1000 group=devops uid=100…   812B
4cf413ae805e        6 months ago        /bin/sh -c #(nop)  USER devops                  0B
d1d88d88e61b        6 months ago        |5 VERSION=1.6 gid=1000 group=devops uid=100…   1.45GB
4b305ec8942c        6 months ago        /bin/sh -c #(nop) COPY file:c19a45386e5be7e4…   411B
a36e97b18597        6 months ago        |5 VERSION=1.6 gid=1000 group=devops uid=100…   398kB
7abf758ac126        6 months ago        /bin/sh -c #(nop)  USER root                    0B
b7cc7e6545cf        6 months ago        /bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=nonin…   0B
4aa2bff1261d        6 months ago        /bin/sh -c #(nop)  ENV HOME=/home/devops        0B
97c1260a833a        6 months ago        /bin/sh -c #(nop)  ARG gid=1000                 0B
1641eb4e6b1a        6 months ago        /bin/sh -c #(nop)  ARG uid=1000                 0B
f550761577d3        6 months ago        /bin/sh -c #(nop)  ARG group=devops             0B
25f225d7fdaa        6 months ago        /bin/sh -c #(nop)  ARG user=devops              0B
ea3b83e6ee69        6 months ago        /bin/sh -c #(nop)  ARG VERSION=1.6              0B
cf8ee6149a83        6 months ago        /bin/sh -c #(nop)  LABEL description=specifi…   0B
3c8433a403ad        6 months ago        /bin/sh -c #(nop)  LABEL maintainer=marslo@x…   0B
e7d65936ff5d        6 months ago        /bin/sh -c #(nop)  LABEL version=1.6            0B
ac9cd6bdb0cf        6 months ago        /bin/sh -c #(nop)  MAINTAINER marslo <marslo…   0B
ad080923604a        7 months ago        /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>           7 months ago        /bin/sh -c #(nop) ADD file:40290d9a94ae76c35…   63.1MB
```

## docker run
### run into dind
```bash
$ docker run \
         --name "marslo" \
         --privileged \
         --rm \
         -it \
         -v /var/run/docker.sock:/var/run/docker.sock
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

## docker exec
### login docker container as root
```bash
$ docker run -d <image>:<tag>
$ docker exec --privileged -u root -it <image-id> /bin/bash
```

## docker ps

{% hint type='tip' %}
> references:
> - [docker ps](https://docs.docker.com/engine/reference/commandline/ps)
{% endhint %}

### list without wrap
```bash
$ docker ps -a --no-trunc
```

- [or](https://github.com/moby/moby/issues/40405#issuecomment-578066973)
  ```bash
  $ curl --unix-socket /var/run/docker.sock 'http://localhost/containers/json'
  ```

- i.e.:
  ```bash
  $ docker ps -a --no-trunc --filter name=marslo*
  ```

#### [list full container id](https://forums.docker.com/t/how-to-get-a-full-id-of-a-certain-container/2418)
```bash
$ docker ps -aq --no-trunc
```

- [or](https://forums.docker.com/t/how-to-get-a-full-id-of-a-certain-container/2418/3)
  {% raw %}
  ```bash
  $ docker inspect --format="{{.Id}}" d40df87b2f87
  d40df87b2f87261152d2541b870c6b801c031f8df969e4bd3e9b3c607e6c1698
  ```
  {%endraw%}

### [filter](https://docs.docker.com/engine/reference/commandline/ps/#filtering)
- filter with image
  ```bash
  $ docker ps -a --no-trunc --filter ancestor='busybox:latest'
  ```
- filter with exit code
  ```bash
  $ docker ps -a --filter 'exited=0'
  ```
- filter with status
  ```bash
  $ docker ps --filter status=running
  ```
- filter with tag
  ```bash
  $ docker images --filter "reference=*/*/*/*:1.4-bionic-dind"
  ```

### [format](https://docs.docker.com/engine/reference/commandline/ps/#formatting)
- id and command

  {% raw %}
  ```bash
  $ docker ps --no-trunc --format "{{.ID}}: {{.Command}}"
  ```
  {% endraw %}

- id, image and commands

  {% raw %}
  ```bash
  $ docker ps --no-trunc --format "{{.ID}}: {{.Command}}: {{.Image}}"
  ```
  {% endraw %}

- [log path](https://stackoverflow.com/a/41147654/2940319)
  > [how to redirect docker logs to a single file](https://www.scalyr.com/blog/how-to-redirect-docker-logs-to-a-single-file)

  {% raw %}
  ```bash
  $ docker inspect --format='{{.LogPath}}' containername
  ```
  {% endraw %}

- [with table](https://stackoverflow.com/q/34748747/2940319)
  {% raw %}
  ```bash
  $ docker ps --format "table {{.Image}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}"
  ```
  {% endraw %}

## docker rmi
- remove via docker image
  {% raw %}
  ```bash
  $ docker rmi -f $(docker images "*/*/*/myimage" --format "{{.ID}}")
  ```
  {% endraw %}

  - or
    {% raw %}
    ```bash
    $ docker images "*/*/*/myimage" --format "{{.ID}}" | xargs docker rmi -f
    ```
    {% endraw %}

- [remove `<none>` tag images](https://stackoverflow.com/a/33913711/2940319)
  ```bash
  $ docker images -q -f "dangling=true" | xargs docker rmi -f --no-trunc
  ```

- [or](https://stackoverflow.com/a/59933159/2940319)
  ```bash
  $ docker image prune --filter="dangling=true"
  ```

### docker rmi for keywords
```bash
$ name='jenkins'
$ tag='2.361.3-lts'
$ if docker images ${name}:${tag} --format \"{{.Tag}}\" >/dev/null ; then
    for imageId in $(docker images ${name} --format \"{{.Tag}}\\t{{.ID}}\" |
                            grep --color=none --fixed-strings ${tag} |
                            awk '{print \$NF}' |
                            uniq);
    do
      docker rmi ${name}:${tag} ;
      docker rmi -f ${imageId} ;
    done ;
  fi
```

## docker rm
- [remove all stopped container](https://stackoverflow.com/a/61866643/2940319)
  {% raw %}
  ```bash
  $ docker ps --filter "status=exited" --format '{{.ID}}' | xargs docker rm -f
  ```
  {% endraw %}
  - or
    ```bash
    $ docker rm $(docker ps -aq --filter "status=exited")
    ```

## docker stats
{% hint style='tip' %}
> reference:
> - [Monitor the Resource Usage of Docker Containers](https://www.cloudsavvyit.com/13715/how-to-monitor-the-resource-usage-of-docker-containers/)
> - [See Memory and CPU Usage for All Your Docker Containers](https://dev.to/rubberduck/how-to-see-memory-and-cpu-usage-for-all-your-docker-containers)

{% endhint %}

{% raw %}
```bash
$ docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```
{% endraw %}

![docker status](../../screenshot/docker/docker-stat-resource-1.gif)

## docker inspect

{% hint style='tip' %}
> reference:
> - [docker inspect](https://docs.docker.com/engine/reference/commandline/inspect/)
> - [See full command of running/stopped container in Docker](https://stackoverflow.com/a/27380853/2940319)
> - [Docker remove <none> TAG images](https://stackoverflow.com/a/33913711/2940319)
> - [Return container settings in JSON format](https://megamorf.gitlab.io/2021/03/14/return-container-settings-in-json-format/)
{% endhint %}

### show entrypoint
{% raw %}
```bash
$ docker inspect -f "{{.Path}} {{.Args}} ({{.Id}})" $(docker ps -a -q)
```
{% endraw %}

- or list <name> only
  {% raw %}
  ```bash
  $ docker inspect -f "{{.Path}} {{.Args}} ({{.Id}})" <name>
  ```
  {% endraw %}

  - i.e.:
    {% raw %}
    ```bash
    $ docker inspect -f "{{.Path}} {{.Args}} ({{.Id}})" bf6f6d166b88
    /usr/bin/tini [-- /usr/local/bin/jenkins.sh] (bf6f6d166b88ed9695b89d859ddc1feb7d2deaf07c64352ad479645b707e0157)
    ```
    {% endraw %}

### [list environment](https://stackoverflow.com/a/43875774/2940319)
{% raw %}
```bash
$ docker inspect \
         --format='{{ .Name }}{{ printf "\n" }}{{ range .Config.Env }}{{ printf "\n\t" }}{{ printf . }}{{ end }}' \
         <containerID>
```
{% endraw %}

### [check mounts](https://stackoverflow.com/a/68096235/2940319)
{% raw %}
```bash
$ docker inspect \
         --format='{{ .Name }}{{ printf "\n" }}{{ range .HostConfig.Binds }}{{ printf "\n\t" }}{{ printf . }}{{ end }}' \
         <containerID>
```
{% endraw %}

- i.e.:
  {% raw %}
  ```bash
  $ docker inspect \
           --format='{{ .Name }}{{ printf ":\n" }}{{ range .HostConfig.Binds }}{{ printf "\n\t" }}{{ printf . }}{{ end }}' \
           <containerID>
  /k8s_jnlp-s31sk-1rvd0_060d5260-8b42-11ed-9c0f-b883034b82d0_0:

    /var/lib/kubelet/pods/060d5260-8b42-11ed-9c0f-b883034b82d0/volumes/kubernetes.io~empty-dir/workspace-volume:/home/marslo
    /var/lib/kubelet/pods/060d5260-8b42-11ed-9c0f-b883034b82d0/volumes/kubernetes.io~secret/default-token-m6bqf:/var/run/secrets/kubernetes.io/serviceaccount:ro
    /var/lib/kubelet/pods/060d5260-8b42-11ed-9c0f-b883034b82d0/etc-hosts:/etc/hosts
    /var/lib/kubelet/pods/060d5260-8b42-11ed-9c0f-b883034b82d0/containers/jnlp/1d0c9319:/dev/termination-log
  ```
{% endraw %}

- or
  {% raw %}
  ```bash
  $ docker inspect \
          -f '{{ .Name }}{{ printf ":\n" }}{{ range .Mounts }}{{ printf "\n\t" }}{{ .Type }}{{ printf "\t" }}{{ if eq .Type "bind" }}{{ .Source }}{{ end }}{{ .Name }} => {{ .Destination }}{{ end }}{{ printf "\n" }}' \
          8e59c4dd2f65
  /k8s_jnlp-s31sk-1rvd0_060d5260-8b42-11ed-9c0f-b883034b82d0_0:

    bind    /var/lib/kubelet/pods/060d5260-8b42-11ed-9c0f-b883034b82d0/volumes/kubernetes.io~secret/default-token-m6bqf => /var/run/secrets/kubernetes.io/serviceaccount
    volume  6c18dbf9b131a9fb245fe896a56b4f4db33f3f32eb1f2b3fcc10c5e50baf7e4f => /home/devops/.jenkins
    bind    /var/lib/kubelet/pods/060d5260-8b42-11ed-9c0f-b883034b82d0/volumes/kubernetes.io~empty-dir/workspace-volume => /home/devops
    bind    /var/lib/kubelet/pods/060d5260-8b42-11ed-9c0f-b883034b82d0/etc-hosts => /etc/hosts
    bind    /var/lib/kubelet/pods/060d5260-8b42-11ed-9c0f-b883034b82d0/containers/jnlp/1d0c9319 => /dev/termination-log
    volume  69c10d1602dc0af1ad305f21ec74f5c568a735c18c64b7b0cb5e04120159e2bd => /home/devops/.ssh
    volume  02668c553b25d1b3f5ba51c85885fab6abf74296a4c0393d35006737d543a174 => /home/devops/agent
  ```
  {% endraw %}

- or
  {% raw %}
  ```bash
  $ docker container inspect \
           -f '{{ range .Mounts }}{{ .Type }} : {{ .Source }}:{{ .Destination }}{{ println }}{{  end  }}' \
           <containerID>
  ```
  {% endraw %}

### [log path](https://stackoverflow.com/a/41147654/2940319)

> [!TIP]
> [how to redirect docker logs to a single file](https://www.scalyr.com/blog/how-to-redirect-docker-logs-to-a-single-file)

{% raw %}
```bash
$ docker inspect --format='{{.LogPath}}' containername
```
{% endraw %}

### [get full container ID](https://forums.docker.com/t/how-to-get-a-full-id-of-a-certain-container/2418/3)
{% raw %}
```bash
$ docker inspect --format="{{.Id}}" d40df87b2f87
d40df87b2f87261152d2541b870c6b801c031f8df969e4bd3e9b3c607e6c1698
```
{%endraw%}

### [check repo tag](https://stackoverflow.com/a/33913711/2940319)
{% raw %}
```bash
$ docker images -q -a | xargs docker inspect --format='{{.Id}}{{range $rt := .RepoTags}} {{$rt}} {{end}}'
```
{% endraw %}

## docker proxy
### [docker build proxy](https://docs.docker.com/network/proxy/)
```bash
$ mkdir -p ~/.docker
$ cat > ~/.docker/config.json << EFO
{
 "proxies":
 {
   "default":
   {
     "httpProxy": "http://proxy.exmaple.com:80",
     "httpsProxy": "http://proxy.example.com:443",
     "ftpProxy": "http://proxy.example.com:443",
     "noProxy": "*.test.example.com,.example2.com,127.0.0.0/8"
   }
 }
}
EOF
```

- or via [`--build-arg`](https://dev.to/zyfa/setup-the-proxy-for-dockerfile-building--4jc8):
  ```bash
  $ docker build \
           --build-arg http_proxy=http://proxy.example.com:80 \
           --build-arg https_proxy=http://proxy.example.com:443 \
          .
  ```

### [docker pull proxy](https://docs.docker.com/config/daemon/systemd/)
```bash
# for rootless mode
$ mkdir -p ~/.config/systemd/user/docker.service.d/
# or regular mode
$ sudo mkdir -p /etc/systemd/system/docker.service.d

$ sudo bash -c "cat > /etc/systemd/system/docker.service.d" << EOF
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80"
Environment="HTTPS_PROXY=https://proxy.example.com:443"
Environment="NO_PROXY=localhost,127.0.0.1,docker-registry.example.com,.corp"
EOF

$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```

## dockerfile

{% hint style='tip' %}
> references:
> - [JDK Script Friendly URLs](https://www.oracle.com/java/technologies/jdk-script-friendly-urls/)
{% endhint %}

```dockerfile
ENV JAVA_PKG=https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz \
      JAVA_HOME=/usr/java/jdk-17

RUN set -eux; \
      JAVA_SHA256=$(curl "$JAVA_PKG".sha256) ; \
      curl --output /tmp/jdk.tgz "$JAVA_PKG" && \
      echo "$JAVA_SHA256 */tmp/jdk.tgz" | sha256sum -c; \
      mkdir -p "$JAVA_HOME"; \
      tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1
```
