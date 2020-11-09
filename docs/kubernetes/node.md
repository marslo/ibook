<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [list node with label](#list-node-with-label)
  - [update label of node](#update-label-of-node)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## list node with label
```bash
$ k get no -l <label>=<value>
```

### update label of node
```bash
$ k label no <node-name> <label>=<value> [--overwrite]
```
