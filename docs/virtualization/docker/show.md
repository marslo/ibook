<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [docker list](#docker-list)
- [docker inspect](#docker-inspect)
  - [show docker image](#show-docker-image)
  - [show entrypoint](#show-entrypoint)
  - [list environment](#list-environment)
  - [check mounts](#check-mounts)
  - [log path](#log-path)
  - [get full container ID](#get-full-container-id)
  - [check repo tag](#check-repo-tag)
- [docker stats](#docker-stats)
- [docker system](#docker-system)
  - [df](#df)
  - [events](#events)
  - [prune](#prune)
- [ps format](#ps-format)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## docker list

- sort by image size

  {% raw %}
  ```bash
  $ docker images --format "{{.ID}}\t{{.Size}}\t{{.Repository}}:{{.Tag}}" | sort -k 2 -hr
  ```
  {%endraw%}

## docker inspect

{% hint style='tip' %}
> reference:
> - [docker inspect](https://docs.docker.com/engine/reference/commandline/inspect/)
> - [See full command of running/stopped container in Docker](https://stackoverflow.com/a/27380853/2940319)
> - [Docker remove <none> TAG images](https://stackoverflow.com/a/33913711/2940319)
> - [Return container settings in JSON format](https://megamorf.gitlab.io/2021/03/14/return-container-settings-in-json-format/)
{% endhint %}

### show docker image
{% raw %}
```bash
$ docker inspect 5b4299c238e5 -f '{{ .Config.Image }}'
```
{% endraw %}

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

## docker stats

{% hint style='tip' %}
> reference:
> - [Monitor the Resource Usage of Docker Containers](https://www.cloudsavvyit.com/13715/how-to-monitor-the-resource-usage-of-docker-containers/)
> - [See Memory and CPU Usage for All Your Docker Containers](https://dev.to/rubberduck/how-to-see-memory-and-cpu-usage-for-all-your-docker-containers)
> - [How to See Memory and CPU Usage for All Your Docker Containers (on CentOS 6)](https://dev.to/rubberduck/how-to-see-memory-and-cpu-usage-for-all-your-docker-containers)
> - [How to Monitor the Resource Usage of Docker Containers](https://www.howtogeek.com/devops/how-to-monitor-the-resource-usage-of-docker-containers/)
{% endhint %}

{% raw %}
```bash
$ docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" <CONTAINER_ID>

# or show all
$ docker ps -q | xargs  docker stats --no-stream
```
{% endraw %}

![docker status](../../screenshot/docker/docker-stat-resource-1.gif)


## docker system
### [df](https://docs.docker.com/engine/reference/commandline/system_df/)
```bash
$ docker system df
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          5         1         9.81GB    8.384GB (85%)
Containers      1         0         0B        0B
Local Volumes   4449      4         172.2GB   156.7GB (90%)
Build Cache     0         0         0B        0B
```

### [events](https://docs.docker.com/engine/reference/commandline/system_events/)
```bash
$ docker system events --since '24h'
```

### [prune](https://docs.docker.com/engine/reference/commandline/system_prune/)
```bash
$ docker system prune --all
WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all dangling images
        - all build cache
Are you sure you want to continue? [y/N] y

# prune volume only
$ docker system prune --volumes
```

## [ps format](https://docs.docker.com/engine/reference/commandline/ps/#formatting)

{% raw %}
```bash
$ docker ps -a --format 'CONTAINER ID : {{.ID}} | Name: {{.Names}} | Image:  {{.Image}} |  Ports: {{.Ports}}'
```
{% endraw %}

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

  > [!NOTE]
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
