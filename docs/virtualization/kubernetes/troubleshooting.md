<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [check log](#check-log)
  - [system logs](#system-logs)
  - [pod logs](#pod-logs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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
