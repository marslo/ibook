<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [tricky](#tricky)
  - [get current branch](#get-current-branch)
  - [get previous branch](#get-previous-branch)
  - [quick push to current branch](#quick-push-to-current-branch)
  - [remove `warning: CRLF will be replaced by LF in xxx file` for `.gitattributes`](#remove-warning-crlf-will-be-replaced-by-lf-in-xxx-file-for-gitattributes)
  - [create multiple commits](#create-multiple-commits)
  - [revision](#revision)
  - [git commit](#git-commit)
  - [git path](#git-path)
  - [`.gitattributes`](#gitattributes)
  - [git summaries](#git-summaries)
- [scripts](#scripts)
  - [fetch merge all](#fetch-merge-all)
  - [gfall <branch>](#gfall-branch)
  - [iGitOpt](#igitopt)
- [effort](#effort)
  - [`--stat`](#--stat)
  - [`--numstat`](#--numstat)
  - [`--shortstat`](#--shortstat)
- [debug](#debug)
  - [Git Debug Options](#git-debug-options)
  - [Linux](#linux)
  - [windows](#windows)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## tricky

{% hint style='tip' %}
> references:
> - [git-tips/tips](https://github.com/git-tips/tips)
> - [git 的奇技淫巧](https://github.com/521xueweihan/git-tips)
> - [k88hudson/git-flight-rules](https://github.com/k88hudson/git-flight-rules/blob/master/README.md)
> - [git飞行规则(flight rules)](https://github.com/k88hudson/git-flight-rules/blob/master/README_zh-CN.md)
> - [firstaidgit.io](https://firstaidgit.io/)
> - [unixorn/git-extra-commands](https://github.com/unixorn/git-extra-commands)
> - [tj/git-extras](https://github.com/tj/git-extras)
{% endhint %}

### get current branch
```bash
$ git branch
  sandbox/marslo
* master
```
- [`branch`](https://git-scm.com/docs/git-branch)
  ```bash
  $ git branch --show-current

  # or
  $ git branch --show

  # or
  $ git branch | sed -ne 's:^\*\s*\(.*\)$:\1:p'
  master
  ```

- [`symbolic-ref`](https://git-scm.com/docs/git-symbolic-ref)
  ```bash
  $ git symbolic-ref --short HEAD
  master

  $ git symbolic-ref HEAD
  refs/heads/master
  ```

- [`name-rev`](https://git-scm.com/docs/git-name-rev)
  ```bash
  $ git name-rev --name-only HEAD
  remotes/origin/master
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

# or
$ git diff @..@{-1}

# or
$ git diff HEAD..@{-1}
```

### quick push to current branch

{% hint style='tip' %}
- `@`
```bash
@ alone is a shortcut for HEAD.
```

> references:
> - [gitrevisions(7) Manual Page](https://mirrors.edge.kernel.org/pub/software/scm/git/docs/gitrevisions.html)
{% endhint %}


```bash
$ git push origin @

# or
$ git push origin HEAD
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
$ for c in {0..10}; do
    echo "$c" >> squash.txt
    git add squash.txt
    git commit -m "add '${c}' to squash.txt"
done
```

### revision
#### the first revision
```bash
$ git rev-list --max-parents=0 HEAD
```

### git commit
#### [emoji](https://gist.github.com/risan/41a0e4a462477875217346027879f618)


### git path
#### get absolute root path
```bash
$ git rev-parse --show-toplevel
```

#### get relative root path
```bash
$ git rev-parse --show-cdup
```

#### get absolute root path inside submodules
```bash
$ git rev-parse --show-superproject-working-tree
```

#### get `.git` path
```bash
$ git rev-parse --git-dir
```

#### inside the work tree or not
```bash
$ git rev-parse --is-inside-work-tree
```

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

### git summaries
#### get repo active days
```bash
$ git log --pretty='format: %ai' $1 |
      cut -d ' ' -f 2 |
      sort -r |
      uniq |
      awk '{ sum += 1 } END {print sum}'
```

#### get commit count
- since particular commit
  ```bash
  $ git log --oneline <hash-id> |
        wc -l |
        tr -d ' '
  635
  ```
- since the initial commit
  ```bash
  $ git log --oneline |
        wc -l |
        tr -d ' '
  780
  ```

#### get all files count in the repo
```bash
$ git ls-files | wc -l | tr -d ' '
```

#### get contributors
```bash
$ git shortlog -n -s -e
   110   marslo <marslo.jiao@gmail.com>
    31   marslo <marslo@xxx.com>
```

[collection](https://github.com/tj/git-extras/blob/master/bin/git-summary#L81)
```bash
$ git shortlog -n -s -e |
      awk ' {
        sum += $1
        if ($NF in emails) {
            emails[$NF] += $1
        } else {
            email = $NF
            emails[email] = $1
            # set commits/email to empty
            $1=$NF=""
            sub(/^[[:space:]]+/, "", $0)
            sub(/[[:space:]]+$/, "", $0)
            name = $0
            if (name in names) {
                # when the same name is associated with existed email,
                # merge the previous email into the later one.
                emails[email] += emails[names[name]]
                emails[names[name]] = 0
            }
            names[name] = email
        }
      } END {
        for (name in names) {
            email = names[name]
            printf "%6d\t%s\n", emails[email], name
      }
    }'
   141  marslo
```

#### format the author
```bash
$ git shortlog -n -s -e | awk '
  { args[NR] = $0; sum += $0 }
  END {
    for (i = 1; i <= NR; ++i) {
      printf "%s♪%2.1f%%\n", args[i], 100 * args[i] / sum
    }
  }
  ' | column -t -s♪ | sed "s/\\\x09/\t/g"
   110  marslo <marslo.jiao@gmail.com>  78.0%
    31  marslo <marslo@xxx.com>         22.0%
```

#### show diff file only
```bash
$ git log --numstat --pretty="%H" --author=marslo HEAD~3..HEAD
9fdb297ba0d2d51975e91d2b7e40fb5e96be4f5f

8       1       docs/artifactory/artifactory.md
095ec79c89d98831c0a485f55011bf81c6f712ad

49      11      docs/linux/disk.md
5       1       docs/osx/util.md
f15a40c8dea2927db54570268aca4203cd50a416

1       0       docs/SUMMARY.md
-       -       docs/screenshot/tools/ms/outlook-keychain-1.png
81      0       docs/tools/ms.md
```

#### repo age
```bash
$ git log --reverse --pretty=oneline --format="%ar" |
      head -n 1 |
      LC_ALL=C sed 's/ago//'
4 months
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

## effort
> references:
> - [tj/git-extras](https://github.com/tj/git-extras)
> - [How can I calculate the number of lines changed between two commits in Git?](https://stackoverflow.com/questions/2528111/how-can-i-calculate-the-number-of-lines-changed-between-two-commits-in-git)

### `--stat`
```bash
$ git diff --stat HEAD^ HEAD
 docs/programming/groovy/groovy.md |  1 +
 docs/vim/tricky.md                | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 2 files changed, 61 insertions(+), 21 deletions(-)
```

- [for particular account](https://stackoverflow.com/a/2528129/2940319)
  ```bash
  $ git --no-pager diff --author='marslo' --stat HEAD^ HEAD
   docs/programming/groovy/groovy.md |  1 +
   docs/vim/tricky.md                | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
   2 files changed, 61 insertions(+), 21 deletions(-)
  ```

### `--numstat`
```bash
$ git --no-pager log --numstat --author="marslo" HEAD^..HEAD
commit c361ddf2687319f978bb4ec0069b4b996607615f (HEAD -> marslo, origin/marslo)
Author: marslo <marslo.jiao@gmail.com>
Date:   Wed Jul 28 22:21:03 2021 +0800

    add bufdo for vim

1   0   docs/programming/groovy/groovy.md
60  21  docs/vim/tricky.md
```

- for total count of changes
  ```bash
  $ git log --numstat --pretty="%H" --author="marslo" HEAD^..HEAD |
        awk 'NF==3 {plus+=$1; minus+=$2} END {printf("+%d, -%d\n", plus, minus)}'
  +61, -21
  ```

- or [for pretty format](https://stackoverflow.com/a/63501669/2940319)
  ```bash
  $ git log HEAD^..HEAD --numstat --pretty="%H" |
        awk 'NF==3 {added+=$1; deleted+=$2} NF==1 {commit++} END {printf("total lines added: +%d\ntotal lines deleted: -%d\ntotal commits: %d\n", added, deleted, commit)}'
  total lines added: +61
  total lines deleted: -21
  total commits: 1
  ```

- [or](https://stackoverflow.com/a/61945239/2940319)
  ```bash
  $ git log --numstat --format="" HEAD^..HEAD |
        awk '{files += 1}{ins += $1}{del += $2} END{print "total: "files" files, "ins" insertions(+) "del" deletions(-)"}'
  total: 2 files, 61 insertions(+) 21 deletions(-)
  ```

  [git alias](https://stackoverflow.com/a/61945239/2940319)
  ```bash
  [alias]
  summary = "!git log --numstat --format=\"\" \"$@\" | awk '{files += 1}{ins += $1}{del += $2} END{print \"total: \"files\" files, \"ins\" insertions(+) \"del\" deletions(-)\"}' #"
  ```

### [`--shortstat`](https://stackoverflow.com/a/41307958/2940319)
```bash
$ git diff --shortstat HEAD^..HEAD
 2 files changed, 61 insertions(+), 21 deletions(-)
```

- or [check for multiple commits](https://stackoverflow.com/a/53338858/2940319)
  ```bash
  $ git diff  $(git log -5 --pretty=format:"%h" | tail -1) --shortstat
   7 files changed, 253 insertions(+), 24 deletions(-)
  ```

## [debug](https://www.shellhacks.com/git-verbose-mode-debug-fatal-errors/)
### Git Debug Options
| Option                       | Description                                                                                                                   |
| :--------------------------- | :---------------------------------------------------------------------------------------------------------------------------- |
| `GIT_TRACE=true`             | Enable general trace messages                                                                                                 |
| `GIT_CURL_VERBOSE=true`      | Print HTTP headers (similar to `curl -v`)                                                                                     |
| `GIT_SSH_COMMAND="ssh -vvv"` | Print SSH debug messages (similar to `ssh -vvv`)                                                                              |
| `GIT_TRACE_PACK_ACCESS=true` | Enable trace messages for all accesses to any packs                                                                           |
| `GIT_TRACE_PACKET=true`      | Enable trace messages for all packets coming in or out of a given program                                                     |
| `GIT_TRACE_PACKFILE=true`    | Enable tracing of packfiles sent or received by a given program                                                               |
| `GIT_TRACE_PERFORMANCE=true` | Enable performance related trace messages                                                                                     |
| `GIT_TRACE_SETUP=true`       | Enable trace messages printing the .git, working tree and current working directory after Git has completed its setup phase   |
| `GIT_TRACE_SHALLOW=true`     | Enable trace messages that can help debugging fetching/cloning of shallow repositories                                        |


### Linux
```bash
$ GIT_TRACE=true \
  GIT_CURL_VERBOSE=true \
  GIT_SSH_COMMAND="ssh -vvv" \
  GIT_TRACE_PACK_ACCESS=true \
  GIT_TRACE_PACKET=true \
  GIT_TRACE_PACKFILE=true \
  GIT_TRACE_PERFORMANCE=true \
  GIT_TRACE_SETUP=true \
  GIT_TRACE_SHALLOW=true \
  <git command here>
```
- or
  ```bash
  $ GIT_SSH_COMMAND='ssh -vvT' <git command here>
  ```

### windows
```batch
C:\> set GIT_TRACE=true
C:\> set GIT_CURL_VERBOSE=true
C:\> set GIT_SSH_COMMAND=ssh -vvv
C:\> <git command here>
```
