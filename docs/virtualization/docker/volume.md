<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [check data](#check-data)
  - [killed container](#killed-container)
  - [stopped container](#stopped-container)
- [mount](#mount)
  - [mount exists volume to new container](#mount-exists-volume-to-new-container)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [gdiepen/docker-convenience-scripts](https://github.com/gdiepen/docker-convenience-scripts/blob/master/docker_clone_volume.sh)
{% endhint %}


## check data
### killed container
```bash
$ docker volume ls | grep ssd-fw-SC- | head -1
local     5b2e5ca2d4563199cc3a982e74c3f4613a7a1b4a1d91bb948561d5a6a1cf4cfa

$ docker inspect 5b2e5ca2d4563199cc3a982e74c3f4613a7a1b4a1d91bb948561d5a6a1cf4cfa | jq -r .[].Mountpoint
/var/lib/docker/volumes/5b2e5ca2d4563199cc3a982e74c3f4613a7a1b4a1d91bb948561d5a6a1cf4cfa/_data
```

### stopped container

{% raw %}
```bash
$ docker ps -a --format '{{.ID}}'
77745046363d

$ docker inspect $(docker ps -a --format '{{.ID}}' | head -1) | jq -r '.[].Mounts[] | select(.Mode == "rw") | .Source'
/var/lib/docker/volumes/ssd-fw-DESKTOP-KUUJPNF-LAB-p0-18558e0fe2640d50617587518acfe1fc5a10d3e2077a62d26509b679832f3fd1/_data

$ sudo ls -Altrh $(docker inspect $(docker ps -a --format '{{.ID}}' | head -1) | jq -r '.[].Mounts[] | select(.Mode == "rw") | .Source')
```
{% endraw %}

## mount
### mount exists volume to new container
```bash
# $1: exists volume need to be visit
# $2: new volume for new container

$ docker volume create --name $2
$ docker run --rm \
             -i \
             -t \
             -v $1:/from \
             -v $2:/to \
             alpine ash -c "cd /from ; cp -av . /to"
```
