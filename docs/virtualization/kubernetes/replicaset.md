<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [list](#list)
  - [list redundant rs](#list-redundant-rs)
  - [remove useless replicasets](#remove-useless-replicasets)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## list
### list redundant rs
```bash
$ k -n <namespace> get rs | awk '{if ($2 + $3 + $4 == 0) print $1}'
```

### [remove useless replicasets](https://stackoverflow.com/a/65154332/2940319)
```bash
$ k -n <namespaced> delete rs $(k -n <namespace> get rs | awk '{if ($2 + $3 + $4 == 0) print $1}')
```