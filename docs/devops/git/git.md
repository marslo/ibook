Git Command Study and practice
=======

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Appoint](#appoint)
  - [Git Alias](#git-alias)
- [git branch](#git-branch)
  - [get current branch](#get-current-branch)
  - [create empty branch](#create-empty-branch)
  - [get branch name from reversion](#get-branch-name-from-reversion)
  - [get upstream branch](#get-upstream-branch)
  - [get local/remote branches](#get-localremote-branches)
  - [sort local branch via `committerdate`](#sort-local-branch-via-committerdate)
- [git log](#git-log)
  - [show files and status without comments](#show-files-and-status-without-comments)
  - [show submodule changes](#show-submodule-changes)
  - [get change from `.git/objects`](#get-change-from-gitobjects)
  - [get change history for deleted files](#get-change-history-for-deleted-files)
  - [by contents](#by-contents)
  - [by message](#by-message)
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
- [git diff](#git-diff)
  - [get difference between two branches](#get-difference-between-two-branches)
- [tag](#tag)
  - [get distance between tags](#get-distance-between-tags)
  - [show all tags for particular revision](#show-all-tags-for-particular-revision)
- [checkout](#checkout)
  - [checkout specific commit](#checkout-specific-commit)
  - [checkout single branch](#checkout-single-branch)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [git reference](https://git-scm.com/docs)
> - [git cheatsheet](https://ndpsoftware.com/git-cheatsheet.html#loc=stash;)
> - [git commands](https://git-scm.com/docs/git#_git_commands)
> - [schacon/plumbing.md](https://gist.github.com/schacon/1153310)
> - [git-tips/tips](https://github.com/git-tips/tips)
> - [521xueweihan/git-tips](https://github.com/521xueweihan/git-tips)
> - [CS Visualized: Useful Git Commands](https://dev.to/lydiahallie/cs-visualized-useful-git-commands-37p1)
{% endhint %}

## Appoint
### [Git Alias](https://raw.githubusercontent.com/marslo/mylinux/master/confs/home/.marslo/.gitalias)
```bash
br      = branch
co      = checkout
coa     = commit --amend --no-edit
pl      = !git --no-pager log --color --graph --pretty=tformat:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit --date=relative --max-count=3
pls     = log --color --graph --pretty=tformat:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit --date=relative
fpl     = log --color --graph --pretty=tformat:'%Cred%H%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit --date=relative
fl      = log -p --graph --color --graph
rlog    = "!bash -c 'while read branch; do \n\
             git fetch --all --force; \n\
             git pl remotes/origin/$branch; \n\
           done < <(git rev-parse --abbrev-ref HEAD) '"
```

## commit
### get commit id
> the `<value>` can be:
> - commit id
> - branch name
> - `HEAD`, `HEAD~n`, `HEAD^^`

```bash
$ git rev-parse <value>^{commit}
```

### get previous commit id
```bash
$ git rev-list --no-walk <commit-id>^
```

## branch
### [get current branch](https://stackoverflow.com/a/19585361/2940319)
```bash
$ git branch --show-current
```
or
```bash
$ git rev-parse --abbrev-ref HEAD
```
or
```bash
$ git symbolic-ref --short HEAD
```
- or
  ```bash
  $ git symbolic-ref HEAD | sed -e "s/^refs\/heads\///"
  ```
- or
  ```bash
  $ git symbolic-ref --quiet --short HEAD || git rev-parse --short
  ```
[or](https://stackoverflow.com/a/33485172/2940319)
```bash
$ git name-rev --name-only HEAD
```

#### [for detached branch](https://stackoverflow.com/a/19457164/2940319)
```bash
$ git st
HEAD detached at d4beb6ac
...

$ git branch --no-color \
             --remote \
             --verbose \
             --no-abbrev \
             --contains |
      sed -rne 's:^[^/]*/([^\ ]+).*$:\1:p'
marslo/sandbox

# or
$ git branch --no-color \
             --remote \
             --verbose \
             --no-abbrev \
             --contains |
      sed -rne 's:^[ \s]*origin/([^\ ]+).*$:\1:p'
```
- or
  ```bash
  $ git name-rev --name-only HEAD |
        sed -rne 's:^[ \s]*([^\]+/){2}([^~]+).*$:\2:p'

  # or
  $ git name-rev --name-only HEAD |
        sed -rne 's:^[ \s]*remotes/origin/([^~]+).*$:\1:p'
  ```

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

  - git alias [`.gitalias`](https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/.gitalias#L120) :
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
                          [ 2 -le $# ] && defaultBr=\"$2\"; \
                          [ 3 -eq $# ] && localDir=\"$3\"; \
                          if [ 0 -eq $# ] || [ 3 -lt $# ]; then \
                            echo \"${help}\"; \
                          else \
                            [ -d ${localDir} ] || mkdir -p ${localDir}; \
                            cd ${localDir} ; \
                            git init && \
                            git remote add origin ${remoteURL} && \
                            git fetch --all --force --quiet && \
                            git checkout -b ${defaultBr}; \
                          fi \
                        }; f \
                  "
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

### get upstream branch
- get current
  ```bash
  $ git rev-parse --abbrev-ref --symbolic-full-name @{u}
  origin/marslo
  ```
  - or
    ```bash
    $ git for-each-ref --format='%(upstream)' $(git symbolic-ref -q HEAD)
    refs/remotes/origin/marslo
    ```
  - or for `meta/config`
    ```bash
    $ git symbolic-ref -q HEAD
    refs/heads/meta/config
    $ git for-each-ref --format='%(upstream)' $(git symbolic-ref -q HEAD)
    refs/remotes/origin/meta/config
    $ git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD)
    origin/meta/config
    ```
  [or](https://stackoverflow.com/a/49418399/2940319)
  ```bash
  $ git status -bsuno
  ## master...origin/master
  ```

- get specific
  ```bash
  $ git rev-parse --abbrev-ref gh-pages@{upstream}
  origin/gh-pages
  ```
  - or
    ```bash
    $ git for-each-ref --format='%(upstream:short)' $(git rev-parse --symbolic-full-name meta/config)
    origin/meta/config
    ```

### [get local/remote branches](https://stackoverflow.com/a/40122019/2940319)
- local
  ```bash
  $ git for-each-ref --format='%(refname:short)' refs/heads/
  ```
- remote
  ```bash
  $ git for-each-ref --format='%(refname:short)' refs/remotes/origin/
  ```

### [sort local branch via `committerdate`](https://stackoverflow.com/a/5188364/2940319)
```bash
$ git for-each-ref --sort=-committerdate refs/heads/

# Or using git branch (since version 2.7.0)
$ git branch --sort=-committerdate  # DESC
$ git branch --sort=committerdate   # ASC
```
- advanced usage
  ```bash
  $ git for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
  ```

## log
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

### [by contents](https://www.atlassian.com/git/tutorials/git-log#filtering-the-commit-history)
```bash
$ git log -S'add' --oneline  -3
6f7877c2 update git for fetch more refs after cloned via --single-branch, and add tricky for vim
30ce195e add jenkins plugin jira-steps
913a7f29 update jenkins recommended plugins
```

### [by message](https://www.atlassian.com/git/tutorials/git-log#filtering-the-commit-history)
```bash
$ git log --grep='jira' --oneline 
30ce195e add jenkins plugin jira-steps
d17dd3aa add jira api
```

## rebase
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

## mv
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
$ git pl --pretty=format:"%h" --no-patch
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

#### revert single file to remotes
```bash
$ git checkout origin/<branch> -- <path/to/file>
```

#### revert changes in submodule
```bash
$ git submodule update -f --init
```

- [or](https://stackoverflow.com/questions/10906554/how-do-i-revert-my-changes-to-a-git-submodule)
  ```bash
  $ git submodule foreach --recursive git reset --hard
  ```
- or
  ```bash
  $ git submodule update -f --recursive
  ```
- or
  ```bash
  $ git submodule foreach --recursive git reset --hard
  $ git submodule update --recursive --init
  ```

#### [Git Reset vs Revert vs Checkout reference](https://www.atlassian.com/git/tutorials/resetting-checking-out-and-reverting)
|     Command    | Scope        | Common use cases                                                     |
|:--------------:|--------------|----------------------------------------------------------------------|
|   `git reset`  | Commit-level | Discard commits in a private branch or throw away uncommited changes |
|   `git reset`  | File-level   | Unstage a file                                                       |
| `git checkout` | Commit-level | Switch between branches or inspect old snapshots                     |
| `git checkout` | File-level   | Discard changes in the working directory                             |
|  `git revert`  | Commit-level | Undo commits in a public branch                                      |
|  `git revert`  | File-level   | (N/A)                                                                |

### change latest comments in local
```bash
$ git commit --amend
```

- change comments in remote
  ```bash
  $ git pl
  * a79d384 - (HEAD -> master, origin/master, origin/HEAD) update (11 seconds ago) <marslo>
  * 7cef7c7 - update (7 hours ago) <marslo>
  * e1d7a64 - update (7 hours ago) <marslo>

  # change comments on a79d384
  $ git commit --amend
  $ git push --force-with-lease origin master

  # result
  $ git fetch --all --force
  $ git pl remotes/origin/master
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
  $ git pls
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

## diff
### [get difference between two branches](https://til.hashrocket.com/posts/18139f4f20-list-different-commits-between-two-branches)
```bash
$ git log --left-right --graph --cherry-pick --oneline origin/<release>..origin/<dev>
```
- [or](https://stackoverflow.com/a/20419458/2940319)
  ```bash
  $ git rev-list --reverse \
                 --pretty="TO_TEST %h (<%ae>) %s" \
                 --cherry-pick \
                 --right-only origin/<release>...origin/<dev> \
                 | grep "^TO_TEST "
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

### [show all tags for particular revision](https://stackoverflow.com/a/37497511/2940319)
```bash
$ git tag --points-at <revision>
```
- get tags for `HEAD`:
  ```bash
  $ git tag --points-at HEAD
  ```
[or](https://stackoverflow.com/a/23394114/2940319)
```bash
$ git name-rev --tags --name-only $(git rev-parse <revision>)
```
- example
  ```bash
  $ git name-rev --tags --name-only $(git rev-parse HEAD)
  ```

## checkout
### [checkout specific commit](https://stackoverflow.com/a/3489576/2940319)
```bash
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
- [add more branches](https://stackoverflow.com/a/17714718/2940319)
  ```bash
  $ git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  $ git fetch origin
  ```
  [or](https://stackoverflow.com/a/35887986/2940319)
  ```bash
  $ cat ~/.marslo/.gitalias
  [alias]
    # [a]dd [f]etch [r]efs
    afr = !bash -c 'git config --add remote.origin.fetch "+refs/heads/$1:refs/remotes/origin/$1"'

  $ git afr 'sandbox/marslo/*'
  ```
