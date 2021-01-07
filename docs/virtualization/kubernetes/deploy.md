<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

{% hint style='tip' %}
> references:
> - [10 Most Common Reasons Kubernetes Deployments Fail Part 1](https://kukulinski.com/10-most-common-reasons-kubernetes-deployments-fail-part-1/)
> - [10 Most Common Reasons Kubernetes Deployments Fail Part 2](https://kukulinski.com/10-most-common-reasons-kubernetes-deployments-fail-part-2/)
{% endhint %}

- [get](#get)
- [set](#set)
  - [update image](#update-image)
  - [setup limits for deploy via command line](#setup-limits-for-deploy-via-command-line)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## get
- check origial
  ```bash
  $ k -n devops get deploy devops-jenkins -o wide
  NAME             READY   UP-TO-DATE   AVAILABLE   AGE    CONTAINERS       IMAGES                  SELECTOR
  devops-jenkins   1/1     1            1           408d   devops-jenkins   jenkins/jenkins:2.199   app=devops-jenkins
  ```

## set
### update image
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

  $ k -n devops get po -o custom-columns='NAME:metadata.name,IMAGES:spec.containers[*].image'
  NAME                              IMAGES
  devops-jenkins-6bdd4fc6dd-l9spp   jenkins/jenkins:2.2000
  ```

### setup limits for deploy via command line
```bash
$ k run <name> \
    --image=jenkins/jenkins:2.274 \
    -i \
    --tty \
    --limits='cpu=50m,memory=128Mi' \
    --requests='cpu=50m,memory=128Mi'
```
