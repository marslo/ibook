<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [execute in pod](#execute-in-pod)
- [management](#management)
  - [reboot po](#reboot-po)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## execute in pod
```bash
$ k -n devops exec -it devops-jenkins-659f4c6d44-d2w76 -- /bin/bash
jenkins@devops-jenkins-659f4c6d44-d2w76:/$ echo $HOME
/var/jenkins_home
jenkins@devops-jenkins-659f4c6d44-d2w76:/$ hostname
devops-jenkins-659f4c6d44-d2w76
```

## management
### reboot po
```bash
$ k -n <namespace> get po <po-name> -o yaml | k replace --force -f -
```
- result
  ```bash
  $ k -n <namespace> get po -w
  NAME                   READY    STATUS    RESTARTS   AGE
  mypo-659f4c6d44-72hb5   1/1     Running   0          47h
  mypo-659f4c6d44-72hb5   1/1     Terminating   0          47h
  mypo-659f4c6d44-d2w76   0/1     Pending       0          0s
  mypo-659f4c6d44-d2w76   0/1     Pending       0          0s
  mypo-659f4c6d44-d2w76   0/1     ContainerCreating   0          0s
  mypo-659f4c6d44-d2w76   1/1     Running             0          2s
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          47h
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          47h
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          47h
  mypo-659f4c6d44-72hb5   0/1     Pending             0          0s
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          0s
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          0s
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          0s
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          1s
  mypo-659f4c6d44-72hb5   0/1     Terminating         0          1s
  ```
