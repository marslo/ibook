<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [tricky](#tricky)
  - [get current branch](#get-current-branch)
  - [get previous branch](#get-previous-branch)
  - [commits](#commits)
  - [remove `warning: CRLF will be replaced by LF in xxx file` for `.gitattributes`](#remove-warning-crlf-will-be-replaced-by-lf-in-xxx-file-for-gitattributes)
  - [create multiple commits](#create-multiple-commits)
  - [git commit](#git-commit)
  - [`.gitattributes`](#gitattributes)
- [scripts](#scripts)
  - [fetch merge all](#fetch-merge-all)
  - [gfall <branch>](#gfall-branch)
  - [iGitOpt](#igitopt)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## tricky
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

### commits
  - the first commit
    ```bash
    $ git rev-list --max-parents=0 HEAD
    ```

### [remove `warning: CRLF will be replaced by LF in xxx file` for `.gitattributes`](https://help.github.com/en/github/using-git/configuring-git-to-handle-line-endings)
```bash
$ git add --all -u --renormalize .
```

- or ignore the warning
  ```bash
  $ git config --global core.safecrlf false
  ```

### [create multiple commits](https://git-rebase.io/)
```bash
for c in {0..10}; do
  echo "$c" >>squash.txt
  git add squash.txt
  git commit -m"Add '$c' to squash.txt"
done
```

### git commit
#### [emoji](https://gist.github.com/risan/41a0e4a462477875217346027879f618)

### `.gitattributes`
#### [Refreshing the repository after committing .gitattributes](https://www.droidship.com/posts/gitattributes/)
> reference:
> - [Please Add .gitattributes To Your Git Repository](https://dev.to/deadlybyte/please-add-gitattributes-to-your-git-repository-1jld)
> - [Git tip: Add a .gitattributes file to deal with line endings](https://www.droidship.com/posts/gitattributes/)
> - [gitattributes - Defining attributes per path](https://git-scm.com/docs/gitattributes)
> - [Force LF eol in git repo and working copy](https://stackoverflow.com/a/34810209/2940319)

```bash
$ rm -rf .git/index
# or
$ git rm --cached -r .
# or
$ git ls-files -z | xargs -0 rm

$ git reset --hard
```

[or](https://git-scm.com/docs/gitattributes)
```bash
$ echo "* text=auto" >.gitattributes
$ git add --renormalize .
$ git status        # Show files that will be normalized
$ git commit -m "Introduce end-of-line normalization"
```

#### format
> reference [Be a Git ninja: the .gitattributes file](https://medium.com/@pablorsk/be-a-git-ninja-the-gitattributes-file-e58c07c9e915)

```bash
$ cat .gitattributes
*             text=auto
*.sh          eol=lf
path/to/file  eol=lf
```

## scripts
### [fetch merge all](https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/.gitalias#L183)
```bash
$ cat ~/.gitconfig
...
[alias]
  ua          = "!bash -c 'while read branch; do \n\
                   echo -e \"\\033[1;33m~~> ${branch}\\033[0m\" \n\
                   git fetch --all --force; \n\
                   if [ 'meta/config' == \"${branch}\" ]; then \n\
                     git fetch origin --force refs/${branch}:refs/remotes/origin/${branch} \n\
                   fi \n\
                   git rebase -v refs/remotes/origin/${branch}; \n\
                   git merge --all --progress refs/remotes/origin/${branch}; \n\
                   git remote prune origin; \n\
                   if git --no-pager config --file $(git rev-parse --show-toplevel)/.gitmodules --get-regexp url; then \n\
                     git submodule sync --recursive; \n\
                     git submodule update --init --recursive \n\
                   fi \n\
                 done < <(git rev-parse --abbrev-ref HEAD) '"
...
```
### [gfall <branch>](https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/ig.sh#L117)

### iGitOpt
- [ig.sh](https://raw.githubusercontent.com/marslo/mylinux/master/confs/home/.marslo/bin/ig.sh)
