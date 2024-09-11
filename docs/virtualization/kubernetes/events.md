<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [get info](#get-info)
  - [list all warning events](#list-all-warning-events)
  - [list particular events](#list-particular-events)
  - [list events for pods](#list-events-for-pods)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## get info
### list all warning events
```bash
$ kubectl get events --field-selector type=Warning --all-namespaces --sort-by='{.lastTimestamp}'
```

### list particular events
```bash
$ kubectl get event --field-selector=involvedObject.name =foo -w
```

### list events for pods
```bash
$ kubectl -n monitoring events --for pods/prometheus-stack-prometheus-node-exporter-9764m --watch
```
