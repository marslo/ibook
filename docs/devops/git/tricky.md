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
  - [git summaries](#git-summaries)
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
   110	marslo <marslo.jiao@gmail.com>  78.0%
    31	marslo <marslo@xxx.com>         22.0%
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
