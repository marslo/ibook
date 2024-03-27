<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [prune](#prune)
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
