<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get current branch](#get-current-branch)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



### get current branch

```bash
$ git br
  sandbox/marslo
* master
```

- `sed`
  ```bash
  $ git branch | sed -ne 's:^\*\s*\(.*\)$:\1:p'
  master
  ```

- `symbolic-ref`
  ```bash
  $ git symbolic-ref --short HEAD
  master

  $ git symbolic-ref HEAD
  refs/heads/master
  ```

- `describe`
  ```bash
  $ git describe --contains --all HEAD
  master
  ```
