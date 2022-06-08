<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get pods qos](#get-pods-qos)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




## get pods qos
```bash
$ kubectl get pods --all-namespaces \
                   -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,QOS-CLASS:.status.qosClass
```
