<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [what is kubectl](#what-is-kubectl)
- [get](#get)
  - [get po](#get-po)
- [list](#list)
  - [list image from a single deploy](#list-image-from-a-single-deploy)
  - [list Container images by Pod](#list-container-images-by-pod)
  - [list all Container images in all namespaces](#list-all-container-images-in-all-namespaces)
  - [list Container images filtering by Pod namespace](#list-container-images-filtering-by-pod-namespace)
  - [list Container images using a go-template instead of jsonpath](#list-container-images-using-a-go-template-instead-of-jsonpath)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## [what is kubectl](https://learnk8s.io/blog/kubectl-productivity/#introduction-what-is-kubectl-)
![kubectl](../screenshot/k8s/k-1.svg)


## get

> [output options](https://learnk8s.io/blog/kubectl-productivity/#3-use-the-custom-columns-output-format):
> -o custom-columns=<header>:<jsonpath>[,<header>:<jsonpath>]...

### get po

- name

```bash
$ k -n devops get po -o custom-columns='NAME:metadata.name'
```

- or
```bash
$ k -n devops get deploy jenkins -o custom-columns="NAME:metadata.name, IMAGES:..image"
NAME              IMAGES
jenkins   jenkins/jenkins:2.187
```

## list

### list image from a single deploy
```bash
$ k -n devops get deployment jenkins -o=jsonpath='{.spec.template.spec.containers[:1].image}'
jenkins/jenkins:2.187
```
- or

```bash
$ k -n devops get deploy jenkins -o jsonpath="{..image}"
jenkins/jenkins:2.187
```

### [list Container images by Pod](https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/#list-container-images-by-pod)
```bash
$ k get pods --all-namespaces -o=jsonpath="{..image}" -l app=nginx
```

- [or](https://learnk8s.io/blog/kubectl-productivity/#3-use-the-custom-columns-output-format)

```bash
$ k4 -n devops get po \
  -> -o custom-columns='NAME:metadata.name,IMAGES:spec.containers[*].image'
```

### [list all Container images in all namespaces](https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/#list-all-container-images-in-all-namespaces)

```bash
$ k get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}"
```

- or

```bash
$ k get pods --all-namespaces -o jsonpath="{..image}" |\
> tr -s '[[:space:]]' '\n' |\
> sort |\
> uniq -c
```

### [list Container images filtering by Pod namespace](https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/#list-container-images-filtering-by-pod-namespace)
```bash
$ k get pods --namespace kube-system -o jsonpath="{..image}"
```

### [list Container images using a go-template instead of jsonpath](https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/#list-container-images-using-a-go-template-instead-of-jsonpath)
```bash
$ k get pods --all-namespaces -o go-template --template="{{range .items}}{{range .spec.containers}}{{.image}} {{end}}{{end}}"
```

- [or](https://stackoverflow.com/a/52736186/2940319)

```bash
$ k get deployment -o=jsonpath="{range .items[*]}{'\n'}{.metadata.name}{':\t'}{range .spec.template.spec.containers[*]}{.image}{', '}{end}{end}"
```
