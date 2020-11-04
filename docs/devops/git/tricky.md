<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get current branch](#get-current-branch)
- [get previous branch](#get-previous-branch)

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

### get previous branch
#### get previous branch name
```bash
$ git rev-parse --symbolic-full-name @{-1}
refs/heads/sandbox/marslo/291
```
or
```bash
$ git describe --all $(git rev-parse @{-1})
heads/sandbox/marslo/291
```
#### [checkout to previous branch](https://stackoverflow.com/a/7207542/2940319)
```bash
$ git checkout -
```
- or
  ```bash
  $ git checkout @{-1}
  ```

#### quick diff with previous branch
```bash
$ git diff ..@{-1}
```
