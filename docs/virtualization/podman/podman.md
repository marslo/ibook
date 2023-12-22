<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [configure files](#configure-files)
- [rootless mode](#rootless-mode)
  - [enable `rootless_storage_path`](#enable-rootless_storage_path)
  - [enable `kernel.unprivileged_userns_clone`](#enable-kernelunprivileged_userns_clone)
  - [setup `subuid` and `subgid`](#setup-subuid-and-subgid)
  - [propagate changes to subuid and subgid](#propagate-changes-to-subuid-and-subgid)
- [Q&A](#qa)
  - [`error creating tmpdir: mkdir /run/user/1001: permission denied`](#error-creating-tmpdir-mkdir-runuser1001-permission-denied)
  - [add pause to process](#add-pause-to-process)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='hint' %}
> references:
> - [podman](https://docs.podman.io/en/latest/markdown/podman.1.html)
> - [Podman](https://wiki.archlinux.org/title/Podman)
> - [Kubernetes 切换到 Containerd](https://mritd.com/2021/05/29/use-containerd-with-kubernetes/)
{% endhint %}


## configure files

| ENVIRONMENT VARIABLES        | FILE NAME         | ROOTFUL                                 | ROOTLESS                                   |
|------------------------------|-------------------|-----------------------------------------|--------------------------------------------|
| `CONTAINERS_CONF`            | `mounts.conf`     | `/etc/containers/mounts.conf`           | `$HOME/.config/containers/mounts.conf`     |
| -                            | `policy.json`     | `/etc/containers/policy.json`           | -                                          |
| `CONTAINERS_REGISTRIES_CONF` | `registries.conf` | `/etc/containers/registries.conf`       | `$HOME/.config/containers/registries.conf` |
| `CONTAINERS_STORAGE_CONF`    | `storage.conf`    | `/etc/containers/storage.conf`          | `$HOME/.config/containers/storage.conf`    |
| -                            | `containers.conf` | `/usr/share/containers/containers.conf` | `$HOME/.config/containers/containers.conf` |


- `short-name-aliases.conf`
  ```bash
  $ cat $HOME/.cache/containers/short-name-aliases.conf
  [aliases]
    "jenkins/jenkins" = "docker.io/jenkins/jenkins"
  ```

- `storage.conf`
  ```bash
  # original version
  $ cat /etc/containers/storage.conf |  sed -e '/^#/ d' -e '/^$/ d'
  [storage]
  driver = "overlay"
  runroot = "/run/containers/storage"
  graphroot = "/var/lib/containers/storage"
  [storage.options]
  additionalimagestores = [
  ]
  [storage.options.overlay]
  mountopt = "nodev,metacopy=on"
  [storage.options.thinpool]
  ```

- `registries.conf`
  ```bash
  $ cat /etc/containers/registries.conf |  sed -e '/^#/ d' -e '/^$/ d'
  unqualified-search-registries = ["registry.fedoraproject.org", "registry.access.redhat.com", "registry.centos.org", "docker.io"]
  short-name-mode = "permissive"
  ```

- `policy.json`
  ```bash
  $ cat /etc/containers/policy.json
  {
      "default": [
          {
              "type": "insecureAcceptAnything"
          }
      ],
      "transports": {
          "docker": {
              "registry.access.redhat.com": [
                  {
                      "type": "signedBy",
                      "keyType": "GPGKeys",
                      "keyPath": "/etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release"
                  }
              ],
              "registry.redhat.io": [
                  {
                      "type": "signedBy",
                      "keyType": "GPGKeys",
                      "keyPath": "/etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release"
                  }
              ]
          },
          "docker-daemon": {
              "": [
                  {
                      "type": "insecureAcceptAnything"
                  }
              ]
          }
      }
  }
  ```

## rootless mode
### enable `rootless_storage_path`
```bash
$ grep rootless_storage_path /etc/containers/storage.conf
rootless_storage_path = "$HOME/.local/share/containers/storage"

$ /usr/bin/podman system migrate
```

- or
  ```bash
  $ cat -n /etc/subgid
       1  marslo:336370:65536
  $ cat -n /etc/subuid
       1  marslo:336370:65536

  $ /usr/bin/podman system migrate
  ```

### enable [`kernel.unprivileged_userns_clone`](https://wiki.archlinux.org/title/Podman#Enable_kernel.unprivileged_userns_clone)
```bash
$ sysctl kernel.unprivileged_userns_clone
```

### setup `subuid` and `subgid`

> [!NOTE]
> Rootless mode
> Podman can also be used as non-root user. When podman runs in rootless mode, a user namespace is automatically created for the user, defined in `/etc/subuid` and `/etc/subgid`
>
> references:
> - [set subuid and subgid](https://wiki.archlinux.org/title/Podman#Set_subuid_and_subgid)

```bash
$ sudo usermod --add-subuids 10000-75535 USERNAME
$ sudo usermod --add-subgids 10000-75535 USERNAME

# or
$ sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 username

# or
$ echo USERNAME:10000:65536 >> /etc/subuid
$ echo USERNAME:10000:65536 >> /etc/subgid
```

### [propagate changes to subuid and subgid](https://wiki.archlinux.org/title/Podman#Propagate_changes_to_subuid_and_subgid)
```bash
$ podman system migrate
```

## Q&A

> [!TIP]
> reference:
> - [podman : troubleshooting](https://wiki.archlinux.org/title/Podman#Troubleshooting)

### `error creating tmpdir: mkdir /run/user/1001: permission denied`

- issue
  ```bash
  $ podman info
  WARN[0000] Conmon at /usr/libexec/podman/conmon invalid: outdated conmon version
  Error: error creating tmpdir: mkdir /run/user/1001: permission denied
  ```

- [solution](https://discussion.fedoraproject.org/t/run-podman-as-non-root-gives-file-permission-errors/8506/19)

  > [!INFO|label:references:]
  > - [podman info, error creating tmpdir: mkdir /run/user/1007: permission denied](https://www.goglides.dev/bkpandey/error-creating-tmpdir-mkdir-runuser1007-permission-denied-443k)
  > - [`loginctl enable-linger my_ci_user`](https://github.com/containers/podman/issues/9002#issuecomment-762399572)
  > - [containers terminate on shell logout](https://wiki.archlinux.org/title/Podman#Containers_terminate_on_shell_logout)

  ```bash
  $ sudo loginctl enable-linger $(whoami)
  ```

  - infomation check
    ```bash
    $ loginctl
    SESSION   UID USER   SEAT  TTY
          2 33637 marslo
         c1    42 gdm    seat0 tty1

    $ podman unshare cat /proc/self/uid_map
    WARN[0000] Conmon at /usr/libexec/podman/conmon invalid: outdated conmon version
    Error: error creating tmpdir: mkdir /run/user/1001: permission denie
    ```

### [add pause to process](https://wiki.archlinux.org/title/Podman#Add_pause_to_process)
```bash
$ sudo echo +cpu +cpuset +io +memory +pids > /sys/fs/cgroup/cgroup.subtree_control
```


