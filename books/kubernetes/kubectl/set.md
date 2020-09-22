<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [update image for deploy](#update-image-for-deploy)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


### update image for deploy
```bash
$ k -n devops set image deployments/devops-jenkins devops-jenkins=jenkins/jenkins:2.200
deployment.extensions/devops-jenkins image updated
```
- result

```bash
$ k -n devops get pods -w
NAME                              READY   STATUS    RESTARTS   AGE
devops-jenkins-54d6db68ff-bz5b6   1/1     Running   0          6d17h
devops-jenkins-6bdd4fc6dd-l9spp   0/1     Pending   0          0s
devops-jenkins-6bdd4fc6dd-l9spp   0/1     Pending   0          0s
devops-jenkins-6bdd4fc6dd-l9spp   0/1     ContainerCreating   0          0s
devops-jenkins-6bdd4fc6dd-l9spp   1/1     Running             0          8s
devops-jenkins-54d6db68ff-bz5b6   1/1     Terminating         0          6d17h
devops-jenkins-54d6db68ff-bz5b6   0/1     Terminating         0          6d17h
devops-jenkins-54d6db68ff-bz5b6   0/1     Terminating         0          6d17h
devops-jenkins-54d6db68ff-bz5b6   0/1     Terminating         0          6d17h

$ k -n devops get deploy -w
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
devops-jenkins   1/1     1            1           22d
devops-jenkins   1/1     1            1           22d
devops-jenkins   1/1     1            1           22d
devops-jenkins   1/1     0            1           22d
devops-jenkins   1/1     1            1           22d
devops-jenkins   2/1     1            2           22d
devops-jenkins   1/1     1            1           22d

$ k -n devops get deploy devops-jenkins -o yaml --export | grep image\:
Flag --export has been deprecated, This flag is deprecated and will be removed in future.
        image: jenkins/jenkins:2.200
```

