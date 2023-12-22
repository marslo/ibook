<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [list](#list)
  - [list redundant rs](#list-redundant-rs)
  - [remove useless replicasets](#remove-useless-replicasets)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## list
### list redundant rs
```bash
$ kubectl -n <namespace> get rs | awk '{if ($2 + $3 + $4 == 0) print $1}'
```

### [remove useless replicasets](https://stackoverflow.com/a/65154332/2940319)
```bash
$ kubectl -n <namespaced> delete rs $(kubectl -n <namespace> get rs | awk '{if ($2 + $3 + $4 == 0) print $1}')
```
