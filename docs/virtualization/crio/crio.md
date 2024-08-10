<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [tips](#tips)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [cri-o/cri-o](https://github.com/cri-o/cri-o)

## tips

> [!NOTE|label:references:]
> - [since CRI-O v1.18.0](https://github.com/cri-o/cri-o/releases/tag/v1.18.0)
> - [#3119 - remove NET_RAW and SYS_CHROOT capability by default](https://github.com/cri-o/cri-o/pull/3119)
>   CRI-O now runs containers without `NET_RAW` and `SYS_CHROOT` capabilities by default.
>   This can result in permission denied errors when the container tries to do something that would require either of these capabilities. For instance, using ping requires `NET_RAW`, unless the container is given the sysctl net.ipv4.ip_forward.
> - [Kubernetes CRI-O Challenge | Ping permission denied | Are you root?](https://www.youtube.com/watch?v=ZKJ9oFwjosM)
