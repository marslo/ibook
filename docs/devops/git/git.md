Git Command Study and practice
=======

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Appoint](#appoint)
  - [Git Alias](#git-alias)
- [git branch](#git-branch)
  - [create empty branch](#create-empty-branch)
  - [get branch name from reversion](#get-branch-name-from-reversion)
- [git log](#git-log)
  - [show files and status without comments](#show-files-and-status-without-comments)
  - [show submodule changes](#show-submodule-changes)
  - [get change from `.git/objects`](#get-change-from-gitobjects)
  - [get change history for deleted files](#get-change-history-for-deleted-files)
- [git rebase](#git-rebase)
  - [automatic edit by `git rebase -i`](#automatic-edit-by-git-rebase--i)
  - [auto rebaes](#auto-rebaes)
  - [fix typo in commits](#fix-typo-in-commits)
- [git mv](#git-mv)
  - [case sensitive](#case-sensitive)
- [clean](#clean)
  - [clean untracked directory and item in `.gitignore`](#clean-untracked-directory-and-item-in-gitignore)
- [undo](#undo)
  - [delete after push](#delete-after-push)
  - [change latest comments in local](#change-latest-comments-in-local)
- [tag](#tag)
  - [get distance between tags](#get-distance-between-tags)
- [checkout](#checkout)
  - [checkout specific commit](#checkout-specific-commit)
  - [checkout single branch](#checkout-single-branch)
- [tricky and scripts](#tricky-and-scripts)
  - [commits](#commits)
  - [remove `warning: CRLF will be replaced by LF in xxx file` for `.gitattributes`](#remove-warning-crlf-will-be-replaced-by-lf-in-xxx-file-for-gitattributes)
  - [create multiple commits](#create-multiple-commits)
  - [git commit](#git-commit)
  - [`.gitattributes`](#gitattributes)
  - [fetch merge all](#fetch-merge-all)
  - [fetchall <branch>](#fetchall-branch)
  - [.marslorc](#marslorc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> reference:
> - [git-tips/tips](https://github.com/git-tips/tips)
> - [521xueweihan/git-tips](https://github.com/521xueweihan/git-tips)
> - [CS Visualized: Useful Git Commands](https://dev.to/lydiahallie/cs-visualized-useful-git-commands-37p1)

## Appoint
### [Git Alias](https://raw.githubusercontent.com/marslo/mylinux/master/confs/home/git/.gitconfig)
```bash
br          = branch
co          = checkout
coa         = commit --amend --no-edit
plog        = !git --no-pager log --color --graph --pretty=tformat:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit --date=relative --max-count=3
plogs       = log --color --graph --pretty=tformat:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit --date=relative
fplog       = log --color --graph --pretty=tformat:'%Cred%H%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit --date=relative
flog        = log -p --graph --color --graph
rlog        = "!bash -c 'while read branch; do \n\
               git fetch --all --force; \n\
               git plog remotes/origin/$branch; \n\
             done < <(git rev-parse --abbrev-ref HEAD) '"
```

## git branch
### create empty branch
  - create an empty branch
    ```bash
    $ mkdir <MY_FOLDER> && cd $_
    $ git init
    $ git remote add origin <REMOTE_URL>
    $ git fetch --all --progress --force
    $ git checkout -b <BRANCH_NAME>
    ```

  - push to remote
    ```bash
    $ git add --all .
    $ git commit -m 'inital an empty branch'
    $ git push --force -u origin HEAD:<BRANCH_NAME>
    ```

  - git alias [`~/.gitconfig.alias`](https://raw.githubusercontent.com/marslo/mylinux/master/confs/home/git/.gitconfig.alias):
    ```bash
    [alias]
    init-repo   = "!f() { \
                      declare help=\"\"\"\
                        USAGE: git init-repo <REMOTE_URL> [DEFAULT_BRANCH] [LOCAL_DIR] \n\
                        OPT: \n\
                            REMOTE_URL: mandatory \n\
                            DEFAULT_BRANCH: optinal. default is 'master' \n\
                            LOCAL_DIR: optional. default is current directory: '\"$(pwd)\"' \n\
                      \"\"\"; \
                      declare remoteURL=\"$1\"; \
                      declare defaultBr='master'; \
                      declare localDir='.'; \
                      [ 2 -eq $# ] && defaultBr=\"$2\"; \
                      [ 3 -eq $# ] && localDir=\"$3\"; \
                      if [ 0 -eq $# ]; then \
                        echo \"${help}\"; \
                      else \
                        [ -d ${localDir} ] || mkdir -p ${localDir}; \
                        cd ${localDir} ; \
                        git init && \
                        git remote add origin ${remoteURL} && \
                        git fetch --all --force --quiet && \
                        git checkout -b ${defaultBr}; \
                      fi \
                    }; f"
    ```

### get branch name from reversion
- `branch -a --contians`
  ```bash
  $ git branch -a --contains a3879d3
  * master
    remotes/origin/master
  ```
  or

  ```bash
  $ git branch -r --contains a3879d3
  origin/master
  ```

- `name-rev`
  ```bash
  $ git name-rev a3879d3
  a3879d3 master~12
  ```

## git log
### show files and status without comments
```bash
$ git log --color --stat --abbrev-commit --date=relative --graph --submodule --format="%H"
```

- more
  ```bash
  # or
  $ git log --color --stat --abbrev-commit --date=relative --graph --submodule --format="%h %ad- %s [%an]"

  # or
  $ git log --color --stat --abbrev-commit --date=relative --graph --submodule --format='%C(red)%h%Creset %C(yellow)(%ad)%Creset %s %C(blue)<%an>%Creset'
  ```

- e.g.:
  ```bash
  $ git log -3 --color --stat --abbrev-commit --date=relative --graph --submodule --format="%H"
  * 50ede51fcc3cf0311fd85b3e9c4a36d4beb89e69
  |
  |  devops/git/gerrit.md | 6 ++++--
  |  devops/git/git.md    | 5 +++++
  |  2 files changed, 9 insertions(+), 2 deletions(-)
  * 41d58dabcd0aaee33edd1de7793ffd82c7cffa89
  |
  |  SUMMARY.md | 2 +-
  |  1 file changed, 1 insertion(+), 1 deletion(-)
  * 4460a32d8fddbe7c5c434947aea153273ce215d4
  |
  |  devops/git/{gitStudy.md => git.md} | 117 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
  |  1 file changed, 116 insertions(+), 1 deletion(-)
  ```

### show submodule changes
```bash
$ git submodule status
$ git log -- <submodule name>
```

### get change from `.git/objects`
```bash
$ find .git/objects -type f -printf "%P\n" | sed s,/,,
```

### get change history for deleted files

- [`full-history`](https://stackoverflow.com/a/7203551/2940319)
  ```bash
  $ git log --all --full-history -- <path/to/file>
  ```
 
  [or](https://stackoverflow.com/a/60993503/2940319)
  ```bash
  $ git log --all --full-history --online -- <path/to/file>
  ```

  [or](https://stackoverflow.com/a/42582877/2940319)
  ```bash
  $ git log --oneline --follow -- <path/to/file>
  ```

  or
  ```bash
  $ git log --diff-filter=D --summary | find "delete" | grep <filename>
  ```

- [`--follow`](https://stackoverflow.com/a/36561814/2940319)
  ```bash
  $ git log --follow <path/to/file>
  ```

## git rebase
> about [`GIT_SEQUENCE_EDITOR`](https://stackoverflow.com/a/54970726/2940319)
> [git rebase in depth](https://git-rebase.io/)

### automatic edit by `git rebase -i`
> inspired from [.gitconfig](https://github.com/brauliobo/gitconfig/blob/master/configs/.gitconfig#L220) & [Is there a way to squash a number of commits non-interactively?](https://stackoverflow.com/a/28789332/2940319)

```bash
$ COUNT=$1
$ GIT_EDITOR="sed -i -e '2,$COUNT s/^pick /s /;/# This is the 2nd commit message:/d'" git rebase -i HEAD~$COUNT
```

  [git alias](https://github.com/marslo/mylinux/blob/master/confs/home/git/.gitconfig.alias#L32)

  ```
  [alias]
    sq = ! "f() { TARGET=$1 && GIT_EDITOR=\"sed -i -e '2,$TARGET s/^pick /s /;/# This is the 2nd commit message:/,$ {d}'\" git rebase -i HEAD~$TARGET; }; f"
  ```

  example

![git rebase and squash automatic](../../screenshot/git/gitrebase-isquash-auto.png)

- [or](https://stackoverflow.com/a/25941070/2940319)
  ```bash
  $ GIT_SEQUENCE_EDITOR="sed -i 's/^pick ce5efdb /edit ce5efdb /;/^pick ce6efdb /d'" git rebase -i ${SHA}
  ```

- or edit
  ```bash
  $ GIT_SEQUENCE_EDITOR="sed -i -re 's/^pick 134567/e 1234567/'" git rebase -i 1234567^
  ```

- or [`sequence.editor`](https://stackoverflow.com/a/38234236/2940319)
  ```bash
  $ git -c sequence.editor='sed -i s/pick/reword/' rebase -i ${SHA}
  ```

### [auto rebaes](https://stackoverflow.com/a/19267103/2940319)
- `.gitconfig`
  ```
  [alias]
    arebase = ! ~/.marslo/bin/arebase.sh
  ```

- `~/.marslo/bin/arebase.sh`

  ```bash
  #!/bin/bash

  ACTION=$1
  COMMIT=$(git rev-parse --short $2)
  [[ "$COMMIT" ]] || exit 1
  CORRECT=
  for A in p pick r reword e edit s squash f fixup d drop t split; do
       [[ $ACTION == $A ]] && CORRECT=1
  done 
  [[ "$CORRECT" ]] || exit 1
  git merge-base --is-ancestor $COMMIT HEAD || exit 1
  if [[ $ACTION == "drop" || $ACTION == "d" ]]; then
      GIT_SEQUENCE_EDITOR="sed -i -e '/^pick $COMMIT/d'" git rebase -i $COMMIT^^
  elif [[ $ACTION == "split" || $ACTION == "t" ]]; then
      GIT_SEQUENCE_EDITOR="sed -i -e 's/^pick $COMMIT/edit $COMMIT/'" git rebase -i $COMMIT^^ || exit 1
      git reset --soft HEAD^
      echo "Hints:"
      echo "  Select files to be commited using 'git reset', 'git add' or 'git add -p'"
      echo "  Commit using 'git commit -c $COMMIT'"
      echo "  Finish with 'git rebase --continue'"
  else
      GIT_SEQUENCE_EDITOR="sed -i -e 's/^pick $COMMIT/$1 $COMMIT/'" git rebase -i $COMMIT^^
  fi
  ```

### [fix typo in commits](https://stackoverflow.com/a/12395024/2940319)
```bash
$ EDITOR="sed -i -e 's/borken/broken/g'" GIT_SEQUENCE_EDITOR="sed -i -e 's/pick/reword/g'" git rebase -i --root
```

  or:

  ```bash
  $ VISUAL="sed -i -e '/^[[:blank:]]*Change-Id/ d'" GIT_SEQUENCE_EDITOR="sed -i -e 's/pick/reword/g'" git rebase -i --root
  ```

  or:

  ```bash
  $ GIT_EDITOR="sed -i -e 's/kyewrod/keyword/g'" GIT_SEQUENCE_EDITOR="sed -i -e 's/pick/reword/g'" git rebase -i --root
  ```

## git mv
### case sensitive
- error with regular `git mv`
  ```bash
  $ git config --global core.ignorecase true
  $ git mv Tig tig
  fatal: renaming 'confs/home/Tig' failed: Invalid argument
  ```

- renmae
  ```bash
  $ git mv Tig temp
  $ git aa
  $ git mv temp tig
  $ git aa
  $ git st
  On branch master
  Your branch is up to date with 'origin/master'.

  Changes to be committed:
    (use "git restore --staged <file>..." to unstage)
      renamed:    Tig/.tig/marslo.tigrc -> tig/.tig/marslo.tigrc
      renamed:    Tig/.tigrc -> tig/.tigrc
      renamed:    Tig/.tigrc_latest -> tig/.tigrc_latest
      renamed:    Tig/tigrc_2.4.1_1_example -> tig/tigrc_2.4.1_1_example
      renamed:    Tig/tigrc_Marslo -> tig/tigrc_Marslo
  ```

## clean
### clean untracked directory and item in `.gitignore`
```bash
$ git clean -dfx
```

#### using `-f` twice if you really want to remove such a directory
```bash
$ git st
On branch meta/config
Your branch is based on 'origin/meta/config', but the upstream is gone.
  (use "git branch --unset-upstream" to fixup)

Untracked files:
  (use "git add <file>..." to include in what will be committed)
    my-sbumodule/

nothing added to commit but untracked files present (use "git add" to track)

$ git clean -dfx
Skipping repository my-submodule/

$ git clean -dffx
Removing my-submodule/
```

## undo
### [delete after push](https://ncona.com/2011/07/how-to-delete-a-commit-in-git-local-and-remote/)
#### delete only the latest commit
```bash
$ git push origin +<hash_for_delete>^:<branch>

# e.g.:
$ git plog --pretty=format:"%h" --no-patch
* cb46bdc
* 936543c
* a83ac6b

# delete cb46bdc
$ git push origin +cb46bdc^:master
```

#### delete multiple commits
- revert local
  ```bash
  $ git reset --hard HEAD~

  # or
  $ git reset --hard HEAD^^^

  # or
  $ git reset --hard <commit_hash>

  # or
  $ git rebase -i HEAD~<n>
  ```

- push to remote
  ```bash
  $ git push [--force] origin +<branch>
  # e.g.:
  $ git push [--force] origin +master
  ```

### change latest comments in local
```bash
$ git commit --amend
```

- change comments in remote
  ```bash
  $ git plog
  * a79d384 - (HEAD -> master, origin/master, origin/HEAD) update (11 seconds ago) <marslo>
  * 7cef7c7 - update (7 hours ago) <marslo>
  * e1d7a64 - update (7 hours ago) <marslo>

  # change comments on a79d384
  $ git commit --amend
  $ git push --force-with-lease origin master

  # result
  $ git fetch --all --force
  $ git plog remotes/origin/master
  Fetching origin
  * ba49259 - (HEAD -> master, origin/master, origin/HEAD) update a79d384 for change comments (24 seconds ago) <marslo>
  * 7cef7c7 - update (7 hours ago) <marslo>
  * e1d7a64 - update (7 hours ago) <marslo>
  ```

#### change remote root comments
```bash
$ git rebase -i --root
$ git push origin +<branch>
```

![rebase -i --root](../../screenshot/rebase-i-root.gif)

#### change remote comments
```bash
$ git rebase -i HEAD~<n>

```
And then change `pick` to `reword`

- example
  ```bash
  $ git plogs
  * 1e7d979 - (HEAD -> master, origin/master, origin/HEAD) f (24 seconds ago) <marslo>
  * 9b89ed7 - c (40 seconds ago) <marslo>
  * beb575f - d (51 seconds ago) <marslo>
  * 25d010d - e (57 seconds ago) <marslo>
  * c502e34 - b (64 seconds ago) <marslo>
  * 8890288 - init commit (4 minutes ago) <Marslo Jiao>

  $ git rebase -i HEAD~5
  reword c502e34 b
  pick 25d010d e
  pick beb575f d
  reword 9b89ed7 c
  pick 1e7d979 f

  $ git push --force origin master
  # or
  $ git push origin +master
  ```

## tag
### [get distance between tags](https://stackoverflow.com/a/9752885/2940319)
```bash
$ git describe HEAD --tags
```
or
  ```bash
  $ git describe HEAD --all --long
  ```

## checkout
### checkout specific commit
```bash
# credit belongs to https://stackoverflow.com/a/3489576/2940319

# make a new blank repository in the current directory
git init

# add a remote
git remote add origin url://to/source/repository

# fetch a commit (or branch or tag) of interest
# Note: the full history up to this commit will be retrieved unless
#       you limit it with '--depth=...' or '--shallow-since=...'
git fetch origin <sha1-of-commit-of-interest>

# reset this repository's master branch to the commit of interest
git reset --hard FETCH_HEAD
```

### checkout single branch
```bash
$ git clone --single-branch --branch <branch name> url://to/source/repository [target dir]
```

## tricky and scripts
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

### fetch merge all
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

### [fetchall <branch>](https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/.marslorc#L452)

### .marslorc
- [.marslorc](https://raw.githubusercontent.com/marslo/mylinux/master/Configs/HOME/.marslo/.marslorc)
