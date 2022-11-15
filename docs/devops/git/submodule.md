<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [init submodule](#init-submodule)
- [update submodule](#update-submodule)
- [revert changes in submodule](#revert-changes-in-submodule)
- [submodule update history](#submodule-update-history)
- [list submodules](#list-submodules)
  - [HEAD:.gitmodules](#headgitmodules)
  - [get name](#get-name)
  - [get path](#get-path)
  - [get url](#get-url)
  - [get branch](#get-branch)
- [working with submodule](#working-with-submodule)
  - [pull from remote](#pull-from-remote)
  - [push to remote](#push-to-remote)
- [remove submodule](#remove-submodule)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP]
> reference:
> - [Git Submodules](http://bijanebrahimi.github.io/blog/git-submodules.html)
> - [git-submodule - Initialize, update or inspect submodules](https://git-scm.com/docs/git-submodule)
> - [gitmodules - Defining submodule properties](https://git-scm.com/docs/gitmodules)
> - [Gerrit Code Review - Superproject subscription to submodules updates](https://gerrit-review.googlesource.com/Documentation/user-submodules.html)https://gerrit-review.googlesource.com/Documentation/user-submodules.html

## init submodule
```bash
$ git submodule add -b <BranchName> <SubRepoUrl> <NameInSuper>
$ git submodule init
$ git submodule update --init
```

## update submodule
```bash
$ git config -f .gitmodules submodule.<SubmoduleNameInSuperRepo>.branch <NewBranchName>
$ git submodule update --remote
```

## [revert changes in submodule](https://stackoverflow.com/a/27415757/2940319)

{% hint style='info' %}
> references:
> - [How do I revert my changes to a git submodule?](https://stackoverflow.com/a/62792847/2940319)
> - [nicktoumpelis/repo-rinse.sh](https://gist.github.com/nicktoumpelis/11214362)
{% endhint %}

```bash
$ git submodule deinit -f .
$ git submodule update --init
```

- or
  ```bash
  $ git submodule foreach --recursive git clean -dffx
  $ git submodule foreach --recursive git reset --hard
  ```

## submodule update history

{% hint style='info' %}
> references:
> - [Git - View history for a specific submodule with corresponding hashes](https://stackoverflow.com/a/42073934/2940319)
{% endhint %}

```bash
$ git log --oneline [--name-only] -- /path/to/submodule

# list all
$ git config --blob HEAD:.gitmodules --get-regexp path |
  awk '{print $NF}' |
  xargs -I{} bash -c "echo -e \"\\n~~> {}:\"; git log -1 --oneline -- {}"
```

## list submodules

> [!TIP]
> references:
> - [git plumbing command to get submodule remote](https://stackoverflow.com/a/41217484/2940319)
> - [Get submodule hash from bare repository](https://stackoverflow.com/a/30329683/2940319)
> - [How to make shallow git submodules?](https://stackoverflow.com/a/17692710/2940319)
>
> example:
> ```bash
> $ git config --blob HEAD:.gitmodules --get-regexp [url|branch|path]
> # or
> $ git config --blob HEAD:.gitmodules --get-regexp ^submodule.\(.+\).\(path\|url\|branch\)
> ```

### [HEAD:.gitmodules](https://stackoverflow.com/a/41217484/2940319)
```bash
$ git config --blob HEAD:.gitmodules --list
# or
$ git show HEAD:.gitmodules | git config --file - --list
```

- get dynamic refs
  ```bash
  $ git cat-file -p <refs>:.gitmodules

  # or
  $ git show -p <refs>:.gitmodules
  ```

### get name
```bash
$ git submodule foreach --quiet 'echo $name'

# or
$ git submodule foreach --quiet 'echo $name' |
  xargs -I{} bash -c "git ls-tree -z -d HEAD -- {}; echo ''"
```

### get path
```bash
$ git show HEAD:.gitmodules | git config --file - --get-regexp path

# or
$ git --no-pager config \
      --file \$(git rev-parse --show-toplevel)/.gitmodules \
      --get-regexp ^submodule.\\(.+\\).path
```

### get url
```bash
$ git show HEAD:.gitmodules | git config --file - --get-regexp url

# or
$ git --no-pager config \
      --file \$(git rev-parse --show-toplevel)/.gitmodules \
      --get-regexp ^submodule.\\(.+\\).url

# or
$ git submodule foreach -q git config remote.origin.url

# or
$ find .git/modules/ -name config -exec grep url {} \;

# or
$ git config --list | grep -E ^submodule.*.url
```

### get branch
```bash
$ git config --blob HEAD:.gitmodules --get-regexp branch
```

## working with submodule
### pull from remote
- update submodule only
  ```bash
  $ git submodule update --remote --recursive --force --rebase
  ```
- update both super and submodule
  ```bash
  $ git pull [--rebase] --recurse-submodules
  ```

### push to remote
- push submodule only
  ```bash
  $ cd <SubFolder>
  $ git push --recurse-submodule=on-demand
  ```
- push for both super and submodule
  ```bash
  $ cd <SubFolder>
  $ git add --all
  $ git commit -am "<Comments for Sub>"
  $ git push --recurse-submodule=on-demand

  $ cd $(git rev-parse --show-superproject-working-tree)
  # or: https://stackoverflow.com/a/7359782/2940319
  $ cd $(git rev-parse --show-superproject-working-tree --show-toplevel | head -1)

  $ git add --all
  $ git commit -am "<Comments for Super>"
  $ git push origin $(git rev-parse --abbrev-ref HEAD)
  ```

## remove submodule

{% hint style='info' %}
> references:
> - [How do I remove a submodule?](https://stackoverflow.com/a/74331589/2940319)
> - [The best way to remove a submodule from git](https://stackoverflow.com/a/70530218/2940319)
{% endhint %}

```bash
$ git submodule deinit -f <submoduleName>                              ### operational
$ git rm --cached <submoduleName>
$ rm -rf <submodulePath>
$ rm -rf .git/modules/<submoduleName>
$ git config -f .gitmodules --remove-section submodule.<submoduleName> ### or $ rm -rf .gitmodules
$ git config -f .git/config --remove-section submodule.<submoduleName> ### or $ vim .git/config
```

