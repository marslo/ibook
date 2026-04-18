<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [conventional commits](#conventional-commits)
  - [commitlint](#commitlint)
  - [emoji](#emoji)
- [tricky](#tricky)
  - [help and path](#help-and-path)
  - [hidden feature](#hidden-feature)
  - [quick edit gitconfig](#quick-edit-gitconfig)
  - [create git patch](#create-git-patch)
  - [get current branch](#get-current-branch)
  - [get previous branch](#get-previous-branch)
  - [quick push to current branch](#quick-push-to-current-branch)
  - [remove `warning: CRLF will be replaced by LF in xxx file` for `.gitattributes`](#remove-warning-crlf-will-be-replaced-by-lf-in-xxx-file-for-gitattributes)
  - [create multiple commits](#create-multiple-commits)
  - [revision](#revision)
  - [git path](#git-path)
  - [`.gitattributes`](#gitattributes)
  - [who-am-i](#who-am-i)
  - [find bug with bisect](#find-bug-with-bisect)
  - [view file at specific commit](#view-file-at-specific-commit)
  - [edit .gitignore after committing](#edit-gitignore-after-committing)
  - [check file in which branch](#check-file-in-which-branch)
  - [check blob hash in which branch](#check-blob-hash-in-which-branch)
- [trailers](#trailers)
  - [git config](#git-config)
  - [generate trailers](#generate-trailers)
  - [show trailers](#show-trailers)
  - [hook](#hook)
- [filter-repo](#filter-repo)
  - [change commit email](#change-commit-email)
  - [seperate folder into new repo](#seperate-folder-into-new-repo)
  - [rewrite the commit history](#rewrite-the-commit-history)
  - [replace sensitive words in all files](#replace-sensitive-words-in-all-files)
  - [cleanup repo](#cleanup-repo)
- [others](#others)
  - [case-sensitive repo in osx](#case-sensitive-repo-in-osx)
  - [disk size](#disk-size)
  - [how is git commit sha1 formed](#how-is-git-commit-sha1-formed)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [10.5 Git Internals - The Refspec](https://git-scm.com/book/en/v2/Git-Internals-The-Refspec)

## conventional commits

> [!TIP|label:references:]
> - [* Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
> - [@commitlint/config-conventional](https://www.npmjs.com/package/@commitlint/config-conventional)
> - [Commit Message Guidelines](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines)
> - [AngularJS Git Commit Message Conventions](https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit?pli=1&tab=t.0#heading=h.uyo6cb12dt6w)
> - [Add Choice [ chore, revert ] to question "Select the type of change you are committing" #36](https://github.com/commitizen-tools/commitizen/issues/36#issuecomment-520243444)

| TYPE       | FULL NAME     | SIMPLE DESCRIPTION                   | DESCRIPTION                                                                                                 |
|------------|---------------|--------------------------------------|-------------------------------------------------------------------------------------------------------------|
| `build`    |               | 构建系统或外部依赖项的变化           | changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)         |
| `ci`       |               | CI 配置文件和脚本的更改              | changes to our ci configuration files and scripts (example scopes: travis, circle, browserstack, saucelabs) |
| `docs`     | documentation | 仅文档修改                           | documentation only changes                                                                                  |
| `feat`     | feature       | 新功能                               | a new feature                                                                                               |
| `fix`      | bugfix        | 修复问题                             | a bug fix                                                                                                   |
| `perf`     |               | 性能提高                             | a code change that improves performance                                                                     |
| `refactor` |               | 重构 (即不是新增功能, 也不是修改bug) | a code change that neither fixes a bug nor adds a feature                                                   |
| `style`    | formatting    | 格式 (不影响代码运行的变动)          | changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)      |
| `test`     |               | 增加测试                             | adding missing tests or correcting existing tests                                                           |
| `chore`    | maintain      | 构建过程或辅助工具的变动             | changes to the build process or auxiliary tools and libraries such as documentation generation              |

```
docs(changelog): update changelog to beta.5
```

```
fix(release): need to depend on latest rxjs and zone.js

The version in our package.json gets copied to the one we publish, and users need the latest of these.
```

```bash
$ npm i -g @commitlint/config-conventional

# or
$ npm install -g @commitlint/cli @commitlint/config-conventional
```

### commitlint

> [!TIP|label:references:]
> - [commitlint](https://commitlint.js.org/)
> - [commitlint configuration](https://commitlint.js.org/reference/configuration.html)

```js
// ~/.commitlintrc.js
// CommonJS Syntax (most common)
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'header-max-length': [0],                   // disable the header-max-length rule
    'body-max-line-length': [0],                // disable the body-max-line-length rule
  }
};
```

for jira tickets
```js
// .commitlintrc.disable-subject-case.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'header-max-length': [0],                   // disable the header-max-length rule
    'body-max-line-length': [0],                // disable the body-max-line-length rule
    'subject-case': [0],                        // disable the subject-case rule
  },
};
```


### [emoji](https://gist.github.com/risan/41a0e4a462477875217346027879f618)

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
> - [shell tricks: one git alias to rule them all](https://brettterpstra.com/2014/08/04/shell-tricks-one-git-alias-to-rule-them-all/)
{% endhint %}

### help and path
```bash
$ git --info-path
/opt/homebrew/opt/git/share/info

$ git --html-path
/opt/homebrew/opt/git/share/doc/git-doc

$ git --man-path
/opt/homebrew/opt/git/share/man
```

#### [git --list-cmds](https://git-scm.com/docs/git#Documentation/git.txt---list-cmdsgroupgroup)

> [!NOTE|label:references:]
> - [git --list-cmds](https://git-scm.com/docs/git#Documentation/git.txt---list-cmdsgroupgroup)
>> - **porcelain** (High-Level): Designed for humans - pretty output, but may changes between versions
>> - **plumbing** (Low-Level): Designed for machines - stable output, but may be more difficult to use
> - [command-list.txt](https://github.com/git/git/blob/master/command-list.txt)
> - [git-completion.bash](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash)

| CATEGORY               | DESCRIPTION                   | DESCRIPTION      | EXAMPLE                             |
|------------------------|-------------------------------|------------------|-------------------------------------|
| mainporcelain          | Primary User Commands         | 核心用户命令     | `add`, `commit`                     |
| ancillaryinterrogators | Secondary Query Commands      | 辅助查询命令     | `blame`, `status`                   |
| ancillarymanipulators  | Secondary Action Commands     | 辅助操作命令     | `clean`, `gc`                       |
| plumbinginterrogators  | Low-Level Data Extraction     | 底层管道查询     | `cat-file`, `ls-tree`, `rev-parse`  |
| plumbingmanipulators   | Low-Level Object Manipulation | 底层管道操作     | `hash-object`, `update-index`       |
| synchingrepositories   | Network & Sync Commands       | 仓库同步命令     | `fetch`, `pull`, `push`             |
| foreignscminterface    | External SCM Interfaces       | 异构 SCM 接口    | `svn`, `hg`, `p4`                   |
| purehelpers            | Internal Utilities            | 纯内部辅助程序   | `credential`, `mergetool--lib`      |
| synchelpers            | Transport Protocols           | 同步辅助协议     | `remote-http`, `upload-pack`        |
| guide                  | Conceptual Manuals            | 官方指南与教程   | `tutorial`, `revisions`, `glossary` |
| developerinterfaces    | Git Core Dev Tools            | 开发者接口       | -                                   |
| userinterfaces         | Native GUIs                   | 图形化界面 (GUI) | `gitk`, `gui`                       |


```bash
$ git --list-cmds=builtins
$ git --list-cmds=parseopt
$ git --list-cmds=deprecated
$ git --list-cmds=main
$ git --list-cmds=others
$ git --list-cmds=nohelpers
$ git --list-cmds=alias
$ git --list-cmds=config
```

```bash
# list-<category>
$ git --list-cmds=list-ancillaryinterrogators
$ git --list-cmds=list-ancillarymanipulators
$ git --list-cmds=list-developerinterfaces
$ git --list-cmds=list-foreignscminterface
$ git --list-cmds=list-guide
$ git --list-cmds=list-mainporcelain
$ git --list-cmds=list-plumbinginterrogators
$ git --list-cmds=list-plumbingmanipulators
$ git --list-cmds=list-purehelpers
$ git --list-cmds=list-synchelpers
$ git --list-cmds=list-synchingrepositories
$ git --list-cmds=list-userinterfaces

# i.e.:
$ git --list-cmds=list-guide
core-tutorial
credentials
cvs-migration
diffcore
everyday
faq
glossary
namespaces
remote-helpers
submodules
tutorial
tutorial-2
workflows

# and
$ git help tutorial-2
$ git help help
```

### hidden feature

#### [git var](https://git-scm.com/docs/git-var)
```bash
$ git var GIT_COMMITTER_IDENT
marslo <marslo.jiao@gmail.com> 1719963678 -0700

$ git var -l
```

#### [git verify-commit](https://git-scm.com/docs/git-verify-commit)

### quick edit gitconfig
```bash
$ git config --edit --global

# quick replace config
$ git config --global --replace-all core.pager cat
```

### create git patch
```bash
$ git diff --no-color HEAD^..HEAD > <name>.patch

# or
$ git format-patch HEAD^^           # create 3 patch files automatically
$ git format-patch -1 <revision>    # create 1 patch file only
```

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
> - `@`: `@` alone is a shortcut for HEAD.
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

### who-am-i

> [!NOTE|label:references:]
> - [Can I hold git credentials in environment variables?](https://stackoverflow.com/a/78064753/2940319)
> - [git-tool credential](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage#_under_the_hood)

```bash
# show default credential
$ echo -e 'protocol=https\nhost=github.com' | git credential fill
protocol=https
host=github.com
username=marslo
password=gho_jzuA**************************1VRqXz

# show another credential with specific subpath
$ echo -e 'protocol=https\nhost=github.com/<account>' | git credential fill
protocol=https
host=github.com/<account>
username=marslojiao-mvl
password=ghp_ppHq*************************g1PXSvr
```

- reject the cached
  ```bash
  $ echo -e 'protocol=https\nhost=github.com' | git credential reject
  ```

### [find bug with bisect](https://dev.to/jagroop2001/20-git-command-line-tricks-every-developer-should-know-1i21)
```bash
$ git bisect start
$ git bisect bad                 # current commit is bad
$ git bisect good <commit-hash>  # a known good commit
```

### [view file at specific commit](https://dev.to/jagroop2001/20-git-command-line-tricks-every-developer-should-know-1i21)
```bash
$ git show <commit-hash>:path/to/file
```

### [edit .gitignore after committing](https://dev.to/jagroop2001/20-git-command-line-tricks-every-developer-should-know-1i21)
```bash
$ echo "node_modules/" >> .gitignore
$ git rm -r --cached node_modules/
$ git commit -m "Update .gitignore"
```

### check file in which branch
```bash
$ path='path/to/file.txt'

# with detail info
$ while read -r branch; do
    foundit=$(git ls-tree -r "${branch}" "${path}");
    [[ -n "${foundit:-}" ]] && echo -e ">> ${branch} <<\n${foundit}\n";
  done< <(git branch --no-color -r)

# with rev-parse
$ while read -r branch; do
    git rev-parse --verify -q "${branch}":"${path}" && echo -e "\n>> ${branch} <<"
  done< <(git branch --no-color -r)

# with cat-file
$ while read -r branch; do
    git cat-file -e "${branch}":"${path}" 2>/dev/null && echo -e ">> ${branch} <<"
  done< <(git branch -r --no-color)

# to show lfs files
$ while read -r path; do
    echo -e "\n\n\033[7;37m>> ${path}\033[0m"
    git check-attr -a "${path}"; echo ''

    while read -r branch; do
      foundit=$(git ls-tree -r "${branch}" "${path}");
      if [[ -n "${foundit:-}" ]]; then echo -e "\033[0;32m>> ${branch} <<\n${foundit}\033[0m\n"; fi;
    done< <( git for-each-ref refs/remotes/origin --sort=-committerdate --format="%(refname:short)" | grep --color=never -v -E '^origin$' )
  done< <( sed 's:^/::; /^#/d' "$(git rev-parse --show-toplevel)/.gitattributes" | awk '{print $1}' | sort -u )
```

### check blob hash in which branch

> [!NOTE|label:references:]
> hash getting older: `Branch (Ref)` -> `Commit` -> `Tree` -> `Blob` (file content)
> scripts:
> - [git-file-size](https://github.com/marslo/dotfiles/blob/main/.marslo/bin/git-file-size)
> - [git-blob-fd](https://github.com/marslo/dotfiles/blob/main/.marslo/bin/git-blob-fd)

```bash
# find the largest files in the repo
$ git rev-list --objects --all |
  git cat-file --batch-check='%(objectname) %(objecttype) %(objectsize) %(rest)' |
  awk '{printf "%s\t%.2f MB\t%s\n", $1, $3/1024/1024, $4}' |
  sort -rn -k 2 |
  head -5
6e73f2d4dcfb223fe300c324f0f8ce90277a7397  405.65 MB   path/to/largefile.bin

# check which branch contains the blob
$ while read commit_hash; do
    git for-each-ref --contains "${commit_hash}";
  done< <(git log --all --find-object=6e73f2d4dcfb223fe300c324f0f8ce90277a7397 --pretty=format:"%H")
5c70ecd90f3c9329a9f2ac035ed2ff8d979414f1 commit refs/heads/sandbox/temp
08581b446ca928790c7c0f5b0829fe8253071c6c commit refs/heads/sandbox/emulator-20200713
5c70ecd90f3c9329a9f2ac035ed2ff8d979414f1 commit refs/heads/sandbox/temp
37cdb8df0df82db41056d8808bf4b1c0c01ebfa6 tag  refs/tags/sandbox/octeontx2-20200422
4c36260dd076c5e45f29c211f674891daa7a36d7 tag  refs/tags/sandbox/temp-next-20200409-98xx-networking
c8d82b97f17abe97d5054cb61ff6d82c43d56e10 commit refs/heads/sandbox/temp-next-ww09
2c077958364bae76d84f11ea6288d0c7b203d399 commit refs/tags/sandbox/ww09-firmware-booting-20200319
1e5a883c252c239812b47172306c96d9eda57d02 commit refs/heads/sandbox/temp-SDK-10.3.0.0-ED1007
26b6604cfd80df7809509695300dba3042d323e2 commit refs/heads/sandbox/temp-next-new
```

## trailers

> [!NOTE|label:references:]
> - [`git interpret-trailers`](https://git-scm.com/docs/git-interpret-trailers)
> - [`git log`](https://git-scm.com/docs/git-log)
> - [`git commit`](https://git-scm.com/docs/git-commit)
> - [Git Trailers](https://alchemists.io/articles/git_trailers)
> - [mmcclimon/git-slog.pl](https://gist.github.com/mmcclimon/9410bfa7ef7d4302edd3bb49414f0b88)
> - [What is the Sign Off feature in Git for?](https://stackoverflow.com/a/35238070/2940319)
> - [Git magic keywords in commit messages (Signed-off-by, Co-authored-by, Fixes, ...)](https://stackoverflow.com/a/67040353/2940319)

### git config

> [!TIP|label:tips:]
> - if `trailer.sign.command` is not set, the default value is `git var GIT_COMMITTER_IDENT`
> - if `trailer.sign.key` set as `"Signed-off-by: "`, it will impacted the `git log --format=%(trailers:key=Signed-off-by:,valueonly,separator=%x2C)`

```bash
$ git config --global trailer.sign.key "Signed-off-by"
$ git config --global trailer.sign.ifmissing add
$ git config --global trailer.sign.ifexists doNothing
$ git config --global trailer.sign.command "echo \"$(git config user.name) <$(git config user.email)>\""

# or
$ cat ~/.gitconfig
[trailer "sign"]
  key               = Signed-off-by
  ifmissing         = add
  ifexists          = doNothing
  command           = echo \"$(git config user.name) <$(git config user.email)>\"
```

### generate trailers

> [!NOTE|label:references:]
> - [Git sign off previous commits?](https://stackoverflow.com/a/15667644/2940319)

```bash
$ git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/Signed-off-by: \1/p'

## commit-msg.sample

# Uncomment the below to add a Signed-off-by line to the message.
# Doing this in a hook is a bad idea in general, but the prepare-commit-msg
# hook is more suited to it.
#
# SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/Signed-off-by: \1/p')
# grep -qs "^$SOB" "$1" || echo "$SOB" >> "$1"

# This example catches duplicate Signed-off-by lines.
test "" = "$(grep '^Signed-off-by: ' "$1" |
         sort | uniq -c | sed -e '/^[   ]*1[    ]/d')" || {
        echo >&2 Duplicate Signed-off-by lines.
        exit 1
}
```

- by template
  ```bash
  $ cat ~/.git-template
  Signed-off-by: Your Name <your.email@example.com>

  $ git config commit.template ~/.git-template
  ```

#### commit
```bash
$ git commit --signoff
# or
$ git commit -s
```

- with control
  ```bash
  declare signed="$(git log -n1 --format='%(trailers:key=Signed-off-by,valueonly,separator=%x2C)' | command grep -q "$(git config user.email)"; echo $?)";
  if [ 0 -eq ${signed} ]; then
    OPT='commit --amend --allow-empty';
  else
    OPT='commit --signoff --amend --allow-empty';
  fi;
  ```

- i.e.:
  ```bash
  [alias]
  ### [c]omit [a]dd [a]all
  caa         = "!f() { \
                        git add --all; \
                        declare signed=\"$(git log -n1 --format='%(trailers:key=Signed-off-by,valueonly,separator=%x2C)' | command grep -q \"$(git config user.email)\"; echo $?)\"; \
                        if [ 0 -eq ${signed} ]; then \
                          git commit --amend --no-edit --allow-empty;\
                        else \
                          git commit --signoff --amend --no-edit --allow-empty;\
                        fi; \
                      }; f \
  ```

### show trailers

> [!NOTE|label:references:]
> - [Git - Detect if commit is signed off](https://stackoverflow.com/q/31261884/2940319)
> - [Git: How to list specific trailers (footers) in git-log format?](https://stackoverflow.com/a/60423945/2940319)

```bash
$ git log -n1 --format='%(trailers:key=Signed-off-by:,valueonly,separator=%x2C)'
marslo <marslo.jiao@gmail.com>

$ git log -n1 --format='%(trailers:key=Signed-off-by:,keyonly,separator=%x2C)'
Signed-off-by

# or
$ git log -n1 --format=%B | git interpret-trailers --parse
Signed-off-by: marslo <marslo.jiao@gmail.com>
Change-Id: I3cc1cb4cfaf4300d2e7972eb39a7319e81012c65

# or
$ git log -1 --pretty=format:"%b"
Signed-off-by: marslo <marslo.jiao@gmail.com>
Change-Id: I3cc1cb4cfaf4300d2e7972eb39a7319e81012c65

# or
$ git log --pretty=format:"%b" | command grep -E "^(Signed-off-by|Co-authored-by):"
```

#### configure and format
- `Signed-off-by: `
  ```bash
  $ git config --global trailer.sign.key 'Signed-off-by: '
  $ git log -1 --format="%(trailers:key=Signed-off-by,valueonly,separator=%x2C)"

  $ git log -1 --format="%(trailers:key=Signed-off-by: ,valueonly,separator=%x2C)"
  marslo <marslo.jiao@gmail.com>
  ```

- `Signed-off-by`
  ```bash
  $ git config --global trailer.sign.key 'Signed-off-by'

  $ git log -1 --format="%(trailers:key=Signed-off-by: ,valueonly,separator=%x2C)"

  $ git log -1 --format="%(trailers:key=Signed-off-by:,valueonly,separator=%x2C)"
  marslo <marslo.jiao@gmail.com>
  $ git log -1 --format="%(trailers:key=Signed-off-by,valueonly,separator=%x2C)"
  marslo <marslo.jiao@gmail.com>
  ```

### hook

> [!NOTE|label:references:]
> - [git提交待审核代码，报错没有change-id的解决方法](https://www.cnblogs.com/yzhihao/p/8392704.html)
> - [git add Signed-off-by line using format.signoff not working](https://stackoverflow.com/a/46536244/2940319)

- `commit-msg` for signed-off-by

  <!--sec data-title="commit-message for change-id" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  #!/bin/sh

  NAME=$(git config user.name)
  EMAIL=$(git config user.email)

  if [ -z "$NAME" ]; then
    echo "empty git config user.name"
    exit 1
  fi

  if [ -z "$EMAIL" ]; then
    echo "empty git config user.email"
    exit 1
  fi

  git interpret-trailers --if-exists doNothing --trailer \
      "Signed-off-by: $NAME <$EMAIL>" \
      --in-place "$1"
  ```
  <!--endsec-->

- `commit-msg` for change-id

  <!--sec data-title="commit-message for change-id" data-id="section1" data-show=true data-collapse=true ces-->
  ```bash
  #!/bin/sh
  # From Gerrit Code Review 2.6
  #
  # Part of Gerrit Code Review (http://code.google.com/p/gerrit/)
  #
  # Copyright (C) 2009 The Android Open Source Project
  #
  # Licensed under the Apache License, Version 2.0 (the "License");
  # you may not use this file except in compliance with the License.
  # You may obtain a copy of the License at
  #
  # http://www.apache.org/licenses/LICENSE-2.0
  #
  # Unless required by applicable law or agreed to in writing, software
  # distributed under the License is distributed on an "AS IS" BASIS,
  # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  # See the License for the specific language governing permissions and
  # limitations under the License.
  #

  unset GREP_OPTIONS

  CHANGE_ID_AFTER="Bug|Issue"
  MSG="$1"

  # Check for, and add if missing, a unique Change-Id
  #
  add_ChangeId() {
    clean_message=`sed -e '
    /^diff --git a\/.*/{
    s///
    q
    }
    /^Signed-off-by:/d
    /^#/d
    ' "$MSG" | git stripspace`
    if test -z "$clean_message"; then return; fi

    # Does Change-Id: already exist? if so, exit (no change).
    if grep -i '^Change-Id:' "$MSG" >/dev/null; then return; fi

    id=`_gen_ChangeId`
    T="$MSG.tmp.$$"
    AWK=awk
    if [ -x /usr/xpg4/bin/awk ]; then
      # Solaris AWK is just too broken
      AWK=/usr/xpg4/bin/awk
    fi

    # How this works:
    # - parse the commit message as (textLine+ blankLine*)*
    # - assume textLine+ to be a footer until proven otherwise
    # - exception: the first block is not footer (as it is the title)
    # - read textLine+ into a variable
    # - then count blankLines
    # - once the next textLine appears, print textLine+ blankLine* as these
    # aren't footer
    # - in END, the last textLine+ block is available for footer parsing
    $AWK '
    BEGIN {
    # while we start with the assumption that textLine+
    # is a footer, the first block is not.
    isFooter = 0
    footerComment = 0
    blankLines = 0
    }

    # Skip lines starting with "#" without any spaces before it.
    /^#/ { next }

    # Skip the line starting with the diff command and everything after it,
    # up to the end of the file, assuming it is only patch data.
    # If more than one line before the diff was empty, strip all but one.
    /^diff --git a/ {
      blankLines = 0
      while (getline) { }
      next
    }

    # Count blank lines outside footer comments
    /^$/ && (footerComment == 0) {
      blankLines++
      next
    }

    # Catch footer comment
    /^\[[a-zA-Z0-9-]+:/ && (isFooter == 1) {
      footerComment = 1
    }

    /]$/ && (footerComment == 1) {
      footerComment = 2
    }

    # We have a non-blank line after blank lines. Handle this.
    (blankLines > 0) {
      print lines
      for (i = 0; i < blankLines; i++) {
        print ""
      }

      lines = ""
      blankLines = 0
      isFooter = 1
      footerComment = 0
    }

    # Detect that the current block is not the footer
    (footerComment == 0) && (!/^\[?[a-zA-Z0-9-]+:/ || /^[a-zA-Z0-9-]+:\/\//) {
      isFooter = 0
    }

    {
      # We need this information about the current last comment line
      if (footerComment == 2) {
        footerComment = 0
      }
      if (lines != "") {
        lines = lines "\n";
      }
      lines = lines $0
    }

    # Footer handling:
    # If the last block is considered a footer, splice in the Change-Id at the
    # right place.
    # Look for the right place to inject Change-Id by considering
    # CHANGE_ID_AFTER. Keys listed in it (case insensitive) come first,
    # then Change-Id, then everything else (eg. Signed-off-by:).
    #
    # Otherwise just print the last block, a new line and the Change-Id as a
    # block of its own.
    END {
    unprinted = 1
    if (isFooter == 0) {
    print lines "\n"
    lines = ""
    }
    changeIdAfter = "^(" tolower("'"$CHANGE_ID_AFTER"'") "):"
    numlines = split(lines, footer, "\n")
    for (line = 1; line <= numlines; line++) {
    if (unprinted && match(tolower(footer[line]), changeIdAfter) != 1) {
    unprinted = 0
    print "Change-Id: I'"$id"'"
    }
    print footer[line]
    }
    if (unprinted) {
    print "Change-Id: I'"$id"'"
    }
    }' "$MSG" > "$T" && mv "$T" "$MSG" || rm -f "$T"
  }

  _gen_ChangeIdInput() {
    echo "tree `git write-tree`"
    if parent=`git rev-parse "HEAD^0" 2>/dev/null`; then
      echo "parent $parent"
    fi
    echo "author `git var GIT_AUTHOR_IDENT`"
    echo "committer `git var GIT_COMMITTER_IDENT`"
    echo
    printf '%s' "$clean_message"
  }
  _gen_ChangeId() {
    _gen_ChangeIdInput |
    git hash-object -t commit --stdin
  }

  add_ChangeId
  ```
  <!--endsec-->

## filter-repo

> [!TIP]
> - [newren/git-filter-repo](https://github.com/newren/git-filter-repo)
>  ```bash
>  $ brew install git-filter-repo
>  ```


> [!NOTE|label:check keywords in repo history:]
> - [* git summaries](./statistics.md#get-contributors)
>  ```bash
>  # show accounts
>  $ git shortlog -n -s -e
>
>  # find all commits with old email
>  $ git log --all --format='%h %D %ad %ae %ce %s' --date=short | grep -Fi '<KEYWORD>'
>  $ git log --all --format='%ae%n%ce' | grep -i '<KEYWORD>'
>  $ git log --format='%H %ad %cd %ae' --date=iso-strict | grep -i '<KEYWORD>'
>  ```

### change commit email

```bash
$ cd /path/to/repo

# update email in history
$ GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null git filter-repo --force --commit-callback '
old = b"<OLD@DOMAIN.COM>"
new = b"<NEW@EMAIL.COM>"
if commit.author_email == old:
    commit.author_email = new
if commit.committer_email == old:
    commit.committer_email = new
'

# re-add the origin
$ git remote add origin <remote-url>

$ git push origin --all --force
$ git push origin --tags --force
```

```bash
# or with case-insensitive match
$ GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null git filter-repo --force --commit-callback '
keyword = b"<KEYWORD>"
new = b"<NEW@EMAIL.COM>"
if keyword in commit.author_email.lower():
    commit.author_email = new
if keyword in commit.committer_email.lower():
    commit.committer_email = new
'
```

```bash
# or with message repalace
$ GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null git filter-repo --force --commit-callback '
keyword = b"<KEYWORD>"
mail = b"<NEW@EMAIL>COM"

if keyword in commit.author_email.lower():
    commit.author_email = mail
if keyword in commit.committer_email.lower():
    commit.committer_email = mail
' \
  --message-callback '
mail = b"<NEW@EMAIL.COM>"
msg = message.replace(b"<old@domain.com>", mail)
msg = msg.replace(b"<OLD@DOMAMIN.COM>", mail)
return msg
'
```

### seperate folder into new repo

1. create new repo

  ```bash
  # extract folder-1 and its history
  $ GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null \
    git filter-repo --force --subdirectory-filter folder-1/

  # extract multiple folders
  $ GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null \
    git filter-repo --force --path folder-1/ --path folder-2/ --path secret.key

  # extract multiple folders and merge into single folder
  # make sure no file name conflict between the folders
  $ GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null \
    git filter-repo \
      --path folder-1/ --path folder-2/ \
      --path-rename folder-1/: \
      --path-rename folder-2/:
  ```

2. clean in old repo

  ```bash
  $ GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null \
    git filter-repo --path folder-1/ --path folder-2/ --path secret.key --invert-paths

  # -- with glob pattern --
  $ GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null \
    git filter-repo --path-glob 'temp-*/' --path-glob 'logs/*.log' --invert-paths

  # -- with config file --
  $ cat to-delete.txt
  folder-1/
  folder-2/
  config/passwords.json
  internal/test-data/
  $ GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null \
    git filter-repo --paths-from-file to-delete.txt --invert-paths
  ```

### rewrite the commit history
```bash
# `ISSUE-xxx: xxxx` -> `[LEGACY] ISSUE-xxx: xxxx`
$ git filter-repo --message-callback '
  if not message.startswith(b"ISSUE-"):
      return b"[LEGACY] " + message
  return message
'
```

### replace sensitive words in all files
```bash
# `my_secret_password` -> `***REDACTED***` in all files and commit messages
$ cat expressions.txt
regex:my_secret_password==>***REDACTED***
$ git filter-repo --replace-text expressions.txt

# "password" -> "******" in all files and commit messages
$ git filter-repo --replace-text <( echo "password==>******" )

# or with config file
$ cat replace.txt
password==>******
secret==>
$ git filter-repo --replace-text replace.txt
```

### cleanup repo
```bash
# cleanup the repo by removing blobs bigger than 50MB
$ git filter-repo --strip-blobs-bigger-than 50M
```

## others
### case-sensitive repo in osx
```bash
$ hdiutil create -type SPARSE \
          -fs "Case-sensitive APFS" \
          -size 10g  \
          -volname casesensitive \
          /tmp/casesensitive.dmg

$ hdiutil attach ~/casesensitive.dmg.sparseimage

# clone
$ git clone https://github.com/<OWNER>/<REPO>.git /Volumes/casesensitive/<REPO>
```

#### show git alias

{% hint style='tip' %}
```bash
$ git --list-cmds=alias

# or
$ git config --get-regexp '^alias\.'
```
{% endhint %}

### [disk size](https://git-scm.com/docs/git-rev-list#Documentation/git-rev-list.txt)
```bash
# reachable objects
$ git rev-list --disk-usage --objects --all

# plus reflogs
$ git rev-list --disk-usage --objects --all --reflog

# total disk size used
$ du -c .git/objects/pack/*.pack .git/objects/??/*
# alternative to du: add up "size" and "size-pack" fields
$ git count-objects -v

# report the disk size of each branch
$ git for-each-ref --format='%(refname)' |
  while read branch; do
    size=$(git rev-list --disk-usage --objects HEAD..$branch)
    echo "$size $branch"
  done |
  sort -n

# compare the on-disk size of branches in one group of refs, excluding another
$ git rev-list --disk-usage --objects --remotes=$suspect --not --remotes=origin
```

### [how is git commit sha1 formed](https://gist.github.com/masak/2415865)

> [!NOTE|label:references:]
> - [How is the Git hash calculated?](https://stackoverflow.com/q/35430584/2940319)
