<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [prune](#prune)
  - [prune build cache](#prune-build-cache)
  - [prune containers](#prune-containers)
  - [prune volumes](#prune-volumes)
  - [prune images](#prune-images)
- [docker rmi](#docker-rmi)
  - [docker rmi for keywords](#docker-rmi-for-keywords)
- [docker rm](#docker-rm)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## [prune](https://docs.docker.com/engine/reference/commandline/system_prune/)
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

- show info

  > [!NOTE|label:see also:]
  > - [iMarslo: show info](./show.html#docker-system)

  ```bash
  $ docker system df
  ```

### [prune build cache](https://docs.docker.com/reference/cli/docker/builder/prune/)
```bash
$ docker builder prune
WARNING! This will remove all dangling build cache. Are you sure you want to continue? [y/N] y
ID                               RECLAIMABLE SIZE    LAST ACCESSED
inqm9ef8j6121j79yti92w2o5        true        0B      3 weeks ago
...

# or
$ docker builder prune [ --all ] [ --force ] [ --keep-storage ]
```

### prune containers
```bash
$ docker container prune
WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N] y
Deleted Containers:
5619dd2ca2fda889dea74a7951715aebabe08c05863eff6a9be0b108394111ec
e777013b304984b0315099f142cc24d942902ac42b62e53ebe1d52a6102912a9
7c09bf8b650968557a975e2cd1f43f6612307af892b5b864ac7b795a59b02d2c
ce2e8698d03f6d6b2a8afcd8655baadc5bb31fbe9eaf425e015e0e4f476e0872
5ee7d62799822a708de6d6b11c2dfbf04114784a77b574da4aa88d63757c180a

Total reclaimed space: 41.47MB

# force
$ docker container prune --force
```

### [prune volumes](https://docs.docker.com/reference/cli/docker/volume/prune/)
```bash
$ docker volume prune
WARNING! This will remove all local volumes not used by at least one container.
Are you sure you want to continue? [y/N] y
...

# all
$ docker volume prune --all

# force
$ docker volume prune --all --force
```

### [prune images](https://docs.docker.com/reference/cli/docker/image/prune/)
```bash
$ docker image prune

# all
$ docker image prune --all

# force
$ docker image prune --all --force
```

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

- or
  ```bash
  $ docker rmi -f $(docker images --filter dangling=true -q)
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

- cleanup all image path with `artifactory.sample.com/docker/marslo/`
  ```bash
  $ docker rmi -f $(docker images artifactory.sample.com/docker/marslo/* -q)
  ```
  - or
    ```bash
    $ docker rmi -f $(docker images artifactory.sample.com/docker/*/* -q)
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
