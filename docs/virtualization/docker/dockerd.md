<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [CLI](#cli)
- [daemon.json](#daemonjson)
  - [`registry-mirrors`](#registry-mirrors)
  - [proxy](#proxy)
  - [hosts for socket](#hosts-for-socket)
  - [storage](#storage)
  - [userns-remap](#userns-remap)
  - [logs](#logs)
  - [full sample file](#full-sample-file)
- [enable tcp port 2375 for external connection to docker](#enable-tcp-port-2375-for-external-connection-to-docker)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


> [!NOTE|label:references:]
> - [dockerd](https://docs.docker.com/reference/cli/dockerd/#daemon-configuration-file)

## CLI
- to verify daemon.json
  ```bash
  $ dockerd --validate --config-file=/etc/docker/daemon.json
  configuration OK

  # or
  $ dockerd --debug --validate --config-file /etc/docker/daemon.json
  configuration OK
  ```

## daemon.json

> [!TIP|label:references:]
> - [Docker daemon configuration overview](https://docs.docker.com/config/daemon/#configure-the-docker-daemon)
>   - linux: `/etc/docker/daemon.json`
>   - linux rootless: `[[ -n "${XDG_CONFIG_HOME}" ]] && ${XDG_CONFIG_HOME}/docker/daemon.json || ~/.config/docker/daemon.json`
>   - windows: `C:\ProgramData\docker\config\daemon.json`
> - [Protect the Docker daemon socket](https://docs.docker.com/engine/security/protect-access/)
> - [Configure and troubleshoot the Docker daemon](https://docs.docker.com/config/daemon/)
> - [Set Up Docker with TLS](https://www.labkey.org/Documentation/wiki-page.view?name=dockerTLS)
> - [How to Configure Docker daemon with a configuration file?](https://www.devopsschool.com/blog/how-to-configure-docker-daemon-with-a-configuration-file/)
> - [* Troubleshooting the Docker daemon](https://docs.docker.com/config/daemon/troubleshoot/#use-the-hosts-key-in-daemonjson-with-systemd)

### `registry-mirrors`

> [!NOTE|label:references:]
> - [How to change the default docker registry from docker.io to my private registry?](https://stackoverflow.com/a/64158584/2940319)
> - [#11815 Allow configuration of additional registries](https://github.com/moby/moby/issues/11815)

```bash
$ cat /etc/docker/daemon.json
{
  "registry-mirrors": ["https://artifactory.domain.com"]
}
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker

# equal to `docker pull artifactory.domain.com/docker-local/image:tag`
$ docker pull docker-local/image:tag

# check status
$ docker info | sed -n '/Registry Mirrors:/{p;n;p;}'
 Registry Mirrors:
  https://artifactory.domain.com/
```

### proxy

> [!NOTE|label:references:]
> - request Docker Engine version 23.0 or later
> - [Proxy configuration](https://docs.docker.com/reference/cli/dockerd/#proxy-configuration)
> - [control and configure Docker with systemd](https://docs.docker.com/config/daemon/systemd/#httphttps-proxy)

```json
{
  "proxies": {
    "http-proxy": "http://proxy.example.com:3128",
    "https-proxy": "https://proxy.example.com:3129",
    "no-proxy": "*.test.example.com,.example.org,127.0.0.0/8"
  }
}
```

### hosts for socket

> [!NOTE|label:references:]
> - [Configuring remote access with daemon.json](https://docs.docker.com/config/daemon/remote-access/#configuring-remote-access-with-daemonjson)

```json
{
  "hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"]
}
```

- or
  ```json
  {
    "hosts": ["unix:///var/run/docker.sock", "fd://", "tcp://0.0.0.0:2375"]
  }
  ```

### storage

> [!TIP]
> - [Supported storage drivers per Linux distribution](https://docs.docker.com/storage/storagedriver/select-storage-driver/#supported-storage-drivers-per-linux-distribution)
>
>
> | LINUX DISTRIBUTION | RECOMMENDED STORAGE DRIVERS | ALTERNATIVE DRIVERS |
> |--------------------|-----------------------------|---------------------|
> | Ubuntu             | overlay2                    | zfs, vfs            |
> | Debian             | overlay2                    | vfs                 |
> | CentOS             | overlay2                    | zfs, vfs            |
> | Fedora             | overlay2                    | zfs, vfs            |
> | SLES 15            | overlay2                    | vfs                 |
> | RHEL               | overlay2                    | vfs                 |
>
>
> - to check current storage driver
>   ```bash
>   $ docker info | sed -n '/Storage Driver/{p;n;p}'
>    Storage Driver: overlay2
>     Backing Filesystem: extfs
>   ```

- `data-root`
  ```json
  {
     "data-root": "/path/to/data/root/"
  }
  ```

- [`storage-driver`](https://docs.docker.com/storage/storagedriver/vfs-driver/#configure-docker-with-the-vfs-storage-driver)
  ```json
  {
    "storage-driver": "vfs",
    "storage-opts": ["size=256M"]
  }
  ```

### [userns-remap](https://docs.docker.com/engine/security/userns-remap/)
```json
{
  "userns-remap": "testuser"
}
```

### logs

> [!NOTE|label:references:]
> - [Configure logging drivers](https://docs.docker.com/config/containers/logging/configure)
> - [Docker: How to clear the logs properly for a Docker container?](https://stackoverflow.com/a/42510314/2940319)

```json
{
   "log-driver": "json-file",
   "log-opts": {
     "max-size": "1g",
     "max-file": "3"
  }
}
```

### [full sample file](https://docs.docker.com/reference/cli/dockerd/#on-linux)

<!--sec data-title="a full example of the allowed configuration options on Linux" data-id="section3" data-show=true data-collapse=true ces-->
```json
{
  "allow-nondistributable-artifacts": [],
  "api-cors-header": "",
  "authorization-plugins": [],
  "bip": "",
  "bridge": "",
  "builder": {
    "gc": {
      "enabled": true,
      "defaultKeepStorage": "10GB",
      "policy": [
        { "keepStorage": "10GB", "filter": ["unused-for=2200h"] },
        { "keepStorage": "50GB", "filter": ["unused-for=3300h"] },
        { "keepStorage": "100GB", "all": true }
      ]
    }
  },
  "cgroup-parent": "",
  "containerd": "/run/containerd/containerd.sock",
  "containerd-namespace": "docker",
  "containerd-plugins-namespace": "docker-plugins",
  "data-root": "",
  "debug": true,
  "default-address-pools": [
    {
      "base": "172.30.0.0/16",
      "size": 24
    },
    {
      "base": "172.31.0.0/16",
      "size": 24
    }
  ],
  "default-cgroupns-mode": "private",
  "default-gateway": "",
  "default-gateway-v6": "",
  "default-network-opts": {},
  "default-runtime": "runc",
  "default-shm-size": "64M",
  "default-ulimits": {
    "nofile": {
      "Hard": 64000,
      "Name": "nofile",
      "Soft": 64000
    }
  },
  "dns": [],
  "dns-opts": [],
  "dns-search": [],
  "exec-opts": [],
  "exec-root": "",
  "experimental": false,
  "features": {},
  "fixed-cidr": "",
  "fixed-cidr-v6": "",
  "group": "",
  "host-gateway-ip": "",
  "hosts": [],
  "proxies": {
    "http-proxy": "http://proxy.example.com:80",
    "https-proxy": "https://proxy.example.com:443",
    "no-proxy": "*.test.example.com,.example.org"
  },
  "icc": false,
  "init": false,
  "init-path": "/usr/libexec/docker-init",
  "insecure-registries": [],
  "ip": "0.0.0.0",
  "ip-forward": false,
  "ip-masq": false,
  "iptables": false,
  "ip6tables": false,
  "ipv6": false,
  "labels": [],
  "live-restore": true,
  "log-driver": "json-file",
  "log-level": "",
  "log-opts": {
    "cache-disabled": "false",
    "cache-max-file": "5",
    "cache-max-size": "20m",
    "cache-compress": "true",
    "env": "os,customer",
    "labels": "somelabel",
    "max-file": "5",
    "max-size": "10m"
  },
  "max-concurrent-downloads": 3,
  "max-concurrent-uploads": 5,
  "max-download-attempts": 5,
  "mtu": 0,
  "no-new-privileges": false,
  "node-generic-resources": [
    "NVIDIA-GPU=UUID1",
    "NVIDIA-GPU=UUID2"
  ],
  "oom-score-adjust": 0,
  "pidfile": "",
  "raw-logs": false,
  "registry-mirrors": [],
  "runtimes": {
    "cc-runtime": {
      "path": "/usr/bin/cc-runtime"
    },
    "custom": {
      "path": "/usr/local/bin/my-runc-replacement",
      "runtimeArgs": [
        "--debug"
      ]
    }
  },
  "seccomp-profile": "",
  "selinux-enabled": false,
  "shutdown-timeout": 15,
  "storage-driver": "",
  "storage-opts": [],
  "swarm-default-advertise-addr": "",
  "tls": true,
  "tlscacert": "",
  "tlscert": "",
  "tlskey": "",
  "tlsverify": true,
  "userland-proxy": false,
  "userland-proxy-path": "/usr/libexec/docker-proxy",
  "userns-remap": ""
}
```
<!--endsec-->

<!--sec data-title="a full example of the allowed configuration options on Windows" data-id="section4" data-show=true data-collapse=true ces-->
```json
{
  "allow-nondistributable-artifacts": [],
  "authorization-plugins": [],
  "bridge": "",
  "containerd": "\\\\.\\pipe\\containerd-containerd",
  "containerd-namespace": "docker",
  "containerd-plugins-namespace": "docker-plugins",
  "data-root": "",
  "debug": true,
  "default-network-opts": {},
  "default-runtime": "",
  "default-ulimits": {},
  "dns": [],
  "dns-opts": [],
  "dns-search": [],
  "exec-opts": [],
  "experimental": false,
  "features": {},
  "fixed-cidr": "",
  "group": "",
  "host-gateway-ip": "",
  "hosts": [],
  "insecure-registries": [],
  "labels": [],
  "log-driver": "",
  "log-level": "",
  "max-concurrent-downloads": 3,
  "max-concurrent-uploads": 5,
  "max-download-attempts": 5,
  "mtu": 0,
  "pidfile": "",
  "raw-logs": false,
  "registry-mirrors": [],
  "shutdown-timeout": 15,
  "storage-driver": "",
  "storage-opts": [],
  "swarm-default-advertise-addr": "",
  "tlscacert": "",
  "tlscert": "",
  "tlskey": "",
  "tlsverify": true
}
```
<!--endsec-->

## [enable tcp port 2375 for external connection to docker](https://gist.github.com/styblope/dc55e0ad2a9848f2cc3307d4819d819f)

{% hint style='tip' %}
> references:
> - [* Configure where the Docker daemon listens for connections](https://docs.docker.com/engine/install/linux-postinstall/#configure-where-the-docker-daemon-listens-for-connections)
> - [* styblope/docker-api-port.md](https://gist.github.com/styblope/dc55e0ad2a9848f2cc3307d4819d819f)
> - [* Configure the daemon](https://docs.docker.com/config/daemon/)
>   - [Configure remote access for Docker daemon](https://docs.docker.com/config/daemon/remote-access/)
>   - [Protect the Docker daemon socket](https://docs.docker.com/engine/security/protect-access/)
>   - [Configure and troubleshoot the Docker daemon](https://docs.docker.com/config/daemon/)
>   - [Control Docker with systemd](https://docs.docker.com/config/daemon/systemd/)
>   - [Configure the daemon for IPv6](https://docs.docker.com/config/daemon/ipv6/)
>   - [Docker and iptables](https://docs.docker.com/network/iptables/)
> - [* Daemon socket option](https://docs.docker.com/reference/cli/dockerd/#daemon-socket-option)
> - [* Protect the Docker daemon socket](https://docs.docker.com/engine/security/protect-access/)
>   - [Create a CA, server and client keys with OpenSSL](https://docs.docker.com/engine/security/protect-access/#create-a-ca-server-and-client-keys-with-openssl)
>   - [Secure by default](https://docs.docker.com/engine/security/protect-access/#secure-by-default)
> - [Docker security : Docker daemon attack surface](https://docs.docker.com/engine/security/#docker-daemon-attack-surface)
{% endhint %}


> [!TIP]
> - to check service
>   ```bash
>   $ sudo systemd-analyze verify <name.service>
>   ```
> - enable service if necessary
>   ```bash
>   $ sudo systemctl enable containerd.service
>   Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /usr/lib/systemd/system/containerd.service
>   ```

```bash
# prepare
$ sudo systemctl stop docker.service
$ sudo systemctl stop docker.socket
```

- via `daemon.json`
  ```bash
  $ cat /etc/docker/daemon.json
  {
    "hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"]
  }
  # or
  $ cat /etc/docker/daemon.json
  {
    "hosts": ["unix:///var/run/docker.sock", "fd://", "tcp://127.0.0.1:2375"]
  }

  $ sudo systemctl edit docker.service
  ```

- via `override.conf`
  ```bash
  $ cat /etc/systemd/system/docker.service.d/override.conf
  [Service]
  ExecStart=
  ExecStart=/usr/bin/dockerd -H fd:// -H tcp://127.0.0.1:2375 [--containerd=/run/containerd/containerd.sock] [--config-file /etc/docker/daemon.json]

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

    $ nc -zv <domain.com> 2375
    Connection to domain.com 2375 port [tcp/*] succeeded!

    $ docker -H tcp://<domain.com>:2375 images
    REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
    ubuntu       18.04     71eaf13299f4   2 weeks ago   63.1MB
    ```

- or modify in `/lib/systemd/system/docker.service`

  > [!TIP]
  > - [Troubleshoot conflicts between the daemon.json and startup scripts](https://docs.docker.com/config/daemon/troubleshoot/#troubleshoot-conflicts-between-the-daemonjson-and-startup-scripts)

  ```diff
  --- Replacing this line:
  ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
  ---                        ╰╴╴╴╴╴╴╯
  ---                     remove `-H fd://`

  +++ With this line:
  ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock [--tls=false]
  ```

- or via `socat`
  ```bash
  exec socat -d TCP-LISTEN:2375,fork UNIX-CONNECT:/var/run/docker.sock
  ```

<!--sec data-title="cat /usr/lib/systemd/system/docker.service" data-id="section0" data-show=true data-collapse=true ces-->
```bash
$ sudo cat /usr/lib/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target docker.socket firewalld.service containerd.service time-set.target
Wants=network-online.target containerd.service
Requires=docker.socket

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
#         remove if enable remote access in /etc/docker/daemon.json
#                          ╭╴╴╴╴╴╴╮
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always

# Note that StartLimit* options were moved from "Service" to "Unit" in systemd 229.
# Both the old, and new location are accepted by systemd 229 and up, so using the old location
# to make them work for either version of systemd.
StartLimitBurst=3

# Note that StartLimitInterval was renamed to StartLimitIntervalSec in systemd 230.
# Both the old, and new name are accepted by systemd 230 and up, so using the old name to make
# this option work for either version of systemd.
StartLimitInterval=60s

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity

# Comment TasksMax if your systemd version does not support it.
# Only systemd 226 and above support this option.
TasksMax=infinity

# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes

# kill only the docker process, not all processes in the cgroup
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
```
<!--endsec-->

