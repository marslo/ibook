<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [git submodule](#git-submodule)
  - [init submodule](#init-submodule)
  - [update submodule](#update-submodule)
  - [revert changes in submodule](#revert-changes-in-submodule)
  - [working with submodule](#working-with-submodule)
  - [remove submodule](#remove-submodule)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## git submodule
> reference:
> - [gitmodules - Defining submodule properties](https://git-scm.com/docs/gitmodules)
> - [Gerrit Code Review - Superproject subscription to submodules updates](https://gerrit-review.googlesource.com/Documentation/user-submodules.html)https://gerrit-review.googlesource.com/Documentation/user-submodules.html

### init submodule
```bash
$ git submodule add -b <BranchName> <SubRepoUrl> <NameInSuper>
$ git submodule init
$ git submodule update --init
```

### update submodule
```bash
$ git config -f .gitmodules submodule.<SubmoduleNameInSuperRepo>.branch <NewBranchName>
$ git submodule update --remote
```

### [revert changes in submodule](https://stackoverflow.com/a/27415757/2940319)
```bash
$ git submodule deinit -f .
$ git submodule update --init
```

- [or](https://stackoverflow.com/a/62792847/2940319)
  > [or](https://gist.github.com/nicktoumpelis/11214362)
  ```bash
  $ git submodule foreach --recursive git clean -dffx
  $ git submodule foreach --recursive git reset --hard
  ```

### working with submodule
#### list submodules
- [HEAD:.gitmodules](https://stackoverflow.com/a/41217484/2940319)
  ```bash
  $ git show HEAD:.gitmodules | git config --file - --list
  ```

#### pull from remote
- update submodule only
  ```bash
  $ git submodule update --remote --recursive --force --rebase
  ```
- update both super and submodule
  ```bash
  $ git pull [--rebase] --recurse-submodules
  ```

#### push to remote
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


### remove submodule
```bash
$ git rm --cached <SubmoudleName>
$ rm -rf <SubmodulePath>
$ rm -rf .gitmodules
$ rm -rf .git/modules/<SubmoduleName>
$ vim .git/config
```

