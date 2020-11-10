<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get info](#get-info)
  - [list all warning events](#list-all-warning-events)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## get info
### list all warning events
```bash
$ kubectl get events --field-selector type=Warning --all-namespaces --sort-by='{.lastTimestamp}'
```
