Git Command Study and practice
=======

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Appoint](#appoint)
  - [Git Alias](#git-alias)
- [git log](#git-log)
  - [show files and status without comments](#show-files-and-status-without-comments)
  - [show submodule changes](#show-submodule-changes)
- [git commit](#git-commit)
  - [emoji](#emoji)
- [git mv](#git-mv)
  - [case sensitive](#case-sensitive)
- [clean](#clean)
  - [clean untracked directory and item in `.gitignore`](#clean-untracked-directory-and-item-in-gitignore)
- [undo](#undo)
  - [delete after push](#delete-after-push)
  - [change latest comments in local](#change-latest-comments-in-local)
- [checkout](#checkout)
  - [checkout specific commit](#checkout-specific-commit)
  - [checkout single branch](#checkout-single-branch)
- [Rebase](#rebase)
  - [Without Confilite file](#without-confilite-file)
  - [With Confilite file](#with-confilite-file)
- [trick and scripts](#trick-and-scripts)
  - [remove `warning: CRLF will be replaced by LF in xxx file` for `.gitattributes` (reference)](#remove-warning-crlf-will-be-replaced-by-lf-in-xxx-file-for-gitattributes-reference)
  - [fetch merge all](#fetch-merge-all)
  - [fetchall <branch>](#fetchall-branch)
  - [.marslorc](#marslorc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Appoint
### [Git Alias](https://raw.githubusercontent.com/marslo/mylinux/master/confs/home/git/.gitconfig)
```bash
br          = branch
bra         = branch -a
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

## git log
### show files and status without comments
```bash
$ git log --color --stat --abbrev-commit --date=relative --graph --submodule --format="%H"

# or
$ git log --color --stat --abbrev-commit --date=relative --graph --submodule --format="%h %ad- %s [%an]"
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

## git commit
### [emoji](https://gist.github.com/risan/41a0e4a462477875217346027879f618)

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

#### delete multple commits
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


## Rebase
### Without Confilite file
#### Precondiction
```bash
$ git plog
37a0595 - (HEAD, master) 2: 2.txt (5 seconds ago) <Marslo>
1d9bcce - Initial commit (65 minutes ago) <Marslo>

$ git rlog
4e3106e - (origin/master, origin/HEAD) 1: 1.txt (2 minutes ago) <Marslo>
1d9bcce - Initial commit (65 minutes ago) <Marslo>

$ git br
  master

$ git push
To git@github.com:Marslo/GitStudy.git
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'git@github.com:Marslo/GitStudy.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Merge the remote changes (e.g. 'git pull')
hint: before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

#### Merge with rebase
##### Use command: git pulll --rebase
```bash
$ git pull --rebase
First, rewinding head to replay your work on top of it...
Applying: 2: 2.txt
```

##### Check the status after pull rebase
- Check the status

    - The status of meraged file hasn't been changed
    ```bash
    $ git st
    # On branch master
    # Your branch is ahead of 'origin/master' by 1 commit.
    #   (use "git push" to publish your local commits)
    #
    nothing to commit, working directory clean
    ```

    - The branch hasn't been changed
    ```bash
    $ git br
      master
    ```

    - Log added the remote new version
    ```bash
    $ git plog
    7bc54e0 - (HEAD, master) 2: 2.txt (12 seconds ago) <Marslo>
    4e3106e - (origin/master, origin/HEAD) 1: 1.txt (4 minutes ago) <Marslo>
    1d9bcce - Initial commit (68 minutes ago) <Marslo>

    $ git rlog
    4e3106e - (origin/master, origin/HEAD) 1: 1.txt (4 minutes ago) <Marslo>
    1d9bcce - Initial commit (68 minutes ago) <Marslo>
    ```

### With Confilite file
#### Precondiction
```bash
$ git plog
 94a5935 - (HEAD, master) 2: 1 (25 seconds ago) <Marslo>
 1d9bcce - Initial commit (25 minutes ago) <Marslo>

$ git rlog
b9709fe - (origin/master, origin/HEAD) 1: 1 (71 seconds ago) <Mar
1d9bcce - Initial commit (25 minutes ago) <Marslo>

$ git br
  master

$ git push
To git@github.com:Marslo/GitStudy.git
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'git@github.com:Marslo/GitStudy.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Merge the remote changes (e.g. 'git pull')
hint: before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

#### Merge by rebase
##### Using command: git pull --rebase
```bash
$ git pull --rebase
First, rewinding head to replay your work on top of it...
Applying: 2: 1
Using index info to reconstruct a base tree...
M       README.md
Falling back to patching base and 3-way merge...
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Failed to merge in the changes.
Patch failed at 0001 2: 1
The copy of the patch that failed is found in:
   /home/marslo/Tools/Git/2_GitStudy/.git/rebase-apply/patch
When you have resolved this problem, run "git rebase --continue".
If you prefer to skip this patch, run "git rebase --skip" instead.
To check out the original branch and stop rebasing, run "git rebase --abort".
```

##### Check the status after pull rebase
- branch is changed (`master` -> `no branch`)
```bash
$ git br
  (no branch, rebasing master)
  master
```

- Status from `unchanged` and `staged` -> `Umerged`
```bash
$ git st
# HEAD detached at b9709fe
# You are currently rebasing branch 'master' on 'b9709fe'.
#   (fix conflicts and then run "git rebase --continue")
#   (use "git rebase --skip" to skip this patch)
#   (use "git rebase --abort" to check out the original branch)
#
# Unmerged paths:
#   (use "git reset HEAD <file>..." to unstage)
#   (use "git add <file>..." to mark resolution)
#
#       both modified:      README.md
#
no changes added to commit (use "git add" and/or "git commit -a")
```

- Log changed:
    - New committed version has been **removed**
    - Remote new version has been **added*

    ```bash
    $ git rlog
    b9709fe - (HEAD, origin/master, origin/HEAD) 1: 1 (2 minutes ago)
    1d9bcce - Initial commit (26 minutes ago) <Marslo>

    $ git plog
    b9709fe - (HEAD, origin/master, origin/HEAD) 1: 1 (2 minutes ago)
    1d9bcce - Initial commit (26 minutes ago) <Marslo>
    ```

- The confilicted file has been meraged
    ```bash
    $ git add .

    $ git st
    # HEAD detached at b9709fe
    # You are currently rebasing branch 'master' on 'b9709fe'.
    #   (all conflicts fixed: run "git rebase --continue")
    #
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       modified:   README.md
    #

    $ git br
      (no branch, rebasing master)
      master

    $ git diff --staged
    diff --git a/README.md b/README.md
    index b1acca3..12afed2 100644
    --- a/README.md
    +++ b/README.md
    @@ -1 +1,5 @@
    +<<<<<<< HEAD
     1: 1
    +=======
    +2: 1
    +>>>>>>> 2: 1
    ```

#### Return to master branch
```bash
$ git rebase --continue
Applying: 2: 1
```

- Check the status
    - The merged file (`Unmerged`) -> `staged`
    ```bash
    $ git st
    # On branch master
    # Your branch is ahead of 'origin/master' by 1 commit.
    #   (use "git push" to publish your local commits)
    #
    nothing to commit, working directory clean
    ```

    - Log added the remote new version
    ```bash
    $ git plog
    d6962d6 - (HEAD, master) 2: 1 (4 seconds ago) <Marslo>
    b9709fe - (origin/master, origin/HEAD) 1: 1 (3 minutes ago) <Marslo>
    1d9bcce - Initial commit (27 minutes ago) <Marslo>

    $ git rlog
    b9709fe - (origin/master, origin/HEAD) 1: 1 (3 minutes ago) <Marslo>
    1d9bcce - Initial commit (27 minutes ago) <Marslo>
    ```

    - Branch changed `no branch, rebasing master` -> `master`
    ```bash
    $ git br
      master
    ```

## trick and scripts
### remove `warning: CRLF will be replaced by LF in xxx file` for `.gitattributes` ([reference](https://help.github.com/en/github/using-git/configuring-git-to-handle-line-endings))
```bash
$ git add --all -u --renormalize .
```

- or ignore the warning

```bash
$ git config --global core.safecrlf false
```

### fetch merge all
```bash
$ cat ~/.gitconfig
...
[alias]
  fma         = "!bash -c 'while read branch; do \n\
                   git fetch --all --force; \n\
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

### fetchall <branch>
```bash
$ cat ~/.marslorc
...
function fetchall()
{
  if [ 1 -eq $# ]; then
    brName=$1
  else
    brName="development"
  fi
  for i in $(${LS} -1d */); do
    gitFetch "$i" "$brName"
  done
}

function gitFetch() {
  GITDIR=${1%%/}
  GITBRANCH=$2
  ISStashed=false
  pushd . > /dev/null
  cd "${GITDIR}"
  echo -e "\\033[34m=== ${GITDIR} ===\\033[0m"

  if git rev-parse --git-dir > /dev/null 2>&1; then
    utFiles=$(git ls-files --others --exclude-standard)
    mdFiles=$(git ls-files --modified)
    cBranch=$(git rev-parse --abbrev-ref HEAD)
    [ ! -z "${utFiles}" ] && echo -e "\\033[35mUNTRACKED FILES in ${cBranch}: ${utFiles}\\033[0m"

    if ! git branch -a | ${GREP} "${GITBRANCH}" > /dev/null 2>&1; then
      GITBRANCH=master
    fi
    echo -e "\\033[33m~> ${GITBRANCH}\\033[0m"

    # checkout branch to $GITBRANCH
    if [ ! "${cBranch}" = "${GITBRANCH}" ]; then
      if [ ! -z "${mdFiles}" ]; then
        echo -e "\\033[31mGIT STASH: ${GITDIR} : ${cBranch} !!\\033[0m"
        git stash save "auto-stashed by gitFetch command"
        ISStashed=true
      fi
      git checkout "${GITBRANCH}"
    fi

    # remove the local branch if the branch has been deleted in remote
    if git remote prune origin --dry-run | ${GREP} prune; then
      prBranch=$(git remote prune origin --dry-run | ${GREP} prune | awk -F'origin/' '{print $NF}')
      if [ "${cBranch}" = "${prBranch}" ] && [ -z "${mdFiles}" ]; then
        echo -e "\\033[32mThe current branch ${cBranch} has been rmeoved in remote. And the current branch has no modified files!\\033[0m"
        ISStashed=false
      fi

      if git branch | ${GREP} "${prBranch}"; then
        echo -e "\\033[35mREMOVE LOCAL BRNACH ${prBranch}, due to ${prBranch} has been rmeoved in remote.\\033[0m"
        if ! git branch -D "${prBranch}"; then
          echo -e "\\033[32mWARNING: REMOVE LOCAL BRANCH ${prBranch} failed!!\\033[0m"
        fi
      fi
    fi

    # git fetchall on ${GITBRANCH}
    git fetch origin --prune
    git fetch --all --force
    git rebase -v --all refs/remotes/origin/${GITBRANCH}
    git merge --all --progress refs/remotes/origin/${GITBRANCH}
    git remote prune origin

    if git --no-pager config --file "$(git rev-parse --show-toplevel)/.gitmodules" --get-regexp url; then
      git submodule sync --recursive
      git submodule update --init --recursive
    fi

    # restore the current working branch
    if ${ISStashed}; then
      git checkout "${cBranch}"
      git stash pop
      echo -e "\\033[35mGIT STASH POP: ${GITDIR} : ${cBranch}\\033[0m"
    fi
  else
    echo -e "\\033[33mNOT Git Repo!!\\033[0m"
  fi
  popd > /dev/null
}
...
```

### .marslorc
- [.marslorc](https://raw.githubusercontent.com/marslo/mylinux/master/Configs/HOME/.marslo/.marslorc)
