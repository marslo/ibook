<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [debug opt](#debug-opt)
  - [git debug options](#git-debug-options)
  - [Linux](#linux)
    - [example](#example)
    - [windows](#windows)
- [plugins/components](#pluginscomponents)
    - [diff-highlight: command not found](#diff-highlight-command-not-found)
    - [error: RPC failed](#error-rpc-failed)
- [installation](#installation)
  - [Ubuntu](#ubuntu)
    - [`no refs in common and none specified; doing nothing.`](#no-refs-in-common-and-none-specified-doing-nothing)
  - [CentOS](#centos)
    - [/bin/sh: cc](#binsh-cc)
    - [openssl/ssl.h](#opensslsslh)
    - [expat.h](#expath)
    - [asciidoc](#asciidoc)
    - [docbook2x-texi](#docbook2x-texi)
    - [xmlto](#xmlto)
    - [gnu/stubs-64.h](#gnustubs-64h)
- [`git diff` extreamly slow](#git-diff-extreamly-slow)
  - [way to debug](#way-to-debug)
  - [solution](#solution)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


# [debug opt](https://www.shellhacks.com/git-verbose-mode-debug-fatal-errors/)
## git debug options

> [!TIP]
> - [commit 14e2411](https://github.com/git/git/commit/14e24114d9cfe2f878ee540e4df485c2cae8253a), [commit 81590bf](https://github.com/git/git/commit/81590bf77db239c156c8ba5c3042d231b1a5995e), [commit 4527aa1](https://github.com/git/git/commit/4527aa10a6030fc8b4b65f1081b7089a9c6d9457), [commit 4eee6c6](https://github.com/git/git/commit/4eee6c6ddc73a3d09e8703a168fe4bb121162d15) (07 Sep 2016)
>   - Use the new `GIT_TRACE_CURL` environment variable instead of the deprecated `GIT_CURL_VERBOSE`.
> - [`GIT_TRACE_CURL=1` or `GIT_CURL_VERBOSE=1`](https://stackoverflow.com/a/38285866/2940319)
> - [`GIT_TRACE2_PERF_BRIEF=1` and `GIT_TRACE2_PERF=~/log.perf`](https://stackoverflow.com/a/74332242/2940319)
> - [`GIT_TRACE` or `GIT_TR2`](https://stackoverflow.com/a/56094711/2940319)
> - [How can I debug git/git-shell related problems?](https://stackoverflow.com/a/38706495/2940319)


| OPTION                       | DESCRIPTION                                                                                                                   |
| :--------------------------- | :---------------------------------------------------------------------------------------------------------------------------- |
| `GIT_TRACE`                  | Enable general trace messages                                                                                                 |
| `GIT_CURL_VERBOSE`           | DEPRECATED: Print HTTP headers (similar to `curl -v`)                                                                         |
| `GIT_TRACE_CURL`             | Print HTTP headers (similar to `curl -v`)                                                                                     |
| `GIT_TRACE_CURL_NO_DATA`     | -                                                                                                                             |
| `GIT_SSH_COMMAND="ssh -vvv"` | Print SSH debug messages (similar to `ssh -vvv`)                                                                              |
| `GIT_TRACE_PACK_ACCESS`      | Enable trace messages for all accesses to any packs                                                                           |
| `GIT_TRACE_PACKET`           | Enable trace messages for all packets coming in or out of a given program                                                     |
| `GIT_TRACE_PACKFILE`         | Enable tracing of packfiles sent or received by a given program                                                               |
| `GIT_TRACE_PERFORMANCE`      | Enable performance related trace messages                                                                                     |
| `GIT_TRACE_SETUP`            | Enable trace messages printing the .git, working tree and current working directory after Git has completed its setup phase   |
| `GIT_TRACE_SHALLOW`          | Enable trace messages that can help debugging fetching/cloning of shallow repositories                                        |


## Linux
```bash
$ GIT_TRACE=true             \
  GIT_CURL_VERBOSE=true      \
  GIT_SSH_COMMAND="ssh -vvv" \
  GIT_TRACE_PACK_ACCESS=true \
  GIT_TRACE_PACKET=true      \
  GIT_TRACE_PACKFILE=true    \
  GIT_TRACE_PERFORMANCE=true \
  GIT_TRACE_SETUP=true       \
  GIT_TRACE_SHALLOW=true     \
  <git command here>
```
- or
  ```bash
  $ GIT_SSH_COMMAND='ssh -vvT' <git command here>
  ```

- or
  ```bash
  $ set -x;
  $ GIT_TRACE=2             \
    GIT_CURL_VERBOSE=2      \
    GIT_TRACE_PERFORMANCE=2 \
    GIT_TRACE_PACK_ACCESS=2 \
    GIT_TRACE_PACKET=2      \
    GIT_TRACE_PACKFILE=2    \
    GIT_TRACE_SETUP=2       \
    GIT_TRACE_SHALLOW=2     \
   git pull origin master -v -v;
  $ set +x
  ```

### example
- `GIT_TRACE_PACK_ACCESS`
  ```bash
  $ GIT_TRACE_PACK_ACCESS=true git status
  17:25:02.292444 packfile.c:1656         .git/objects/pack/pack-2c56c1344ec68590771337aac300d34d4419b7a8.pack 182822
  17:25:02.292570 packfile.c:1656         .git/objects/pack/pack-2c56c1344ec68590771337aac300d34d4419b7a8.pack 251298
  On branch marslo
  Your branch is up to date with 'origin/marslo'.

  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git restore <file>..." to discard changes in working directory)
          modified:   devops/git/config.md
          modified:   devops/git/troubleshooting.md

  17:25:03.107800 packfile.c:1656         .git/objects/pack/pack-2c56c1344ec68590771337aac300d34d4419b7a8.pack 182822
  17:25:03.115308 packfile.c:1656         .git/objects/pack/pack-2c56c1344ec68590771337aac300d34d4419b7a8.pack 251298
  no changes added to commit (use "git add" and/or "git commit -a")
  ```

- `GIT_TRACE_PACKET`
  ```bash
  $ GIT_TRACE_PACKET=true git ls-remote origin
  17:26:07.252939 pkt-line.c:85           packet:    ls-remote< version 2
  17:26:07.253054 pkt-line.c:85           packet:    ls-remote< agent=git/github-cbc05ce31956
  17:26:07.253061 pkt-line.c:85           packet:    ls-remote< ls-refs=unborn
  17:26:07.253065 pkt-line.c:85           packet:    ls-remote< fetch=shallow wait-for-done filter
  17:26:07.253068 pkt-line.c:85           packet:    ls-remote< server-option
  17:26:07.253072 pkt-line.c:85           packet:    ls-remote< object-format=sha1
  17:26:07.253075 pkt-line.c:85           packet:    ls-remote< 0000
  17:26:07.253080 pkt-line.c:85           packet:    ls-remote> command=ls-refs
  17:26:07.253120 pkt-line.c:85           packet:    ls-remote> agent=git/2.42.0.325.g3a06386e31
  17:26:07.253141 pkt-line.c:85           packet:    ls-remote> object-format=sha1
  17:26:07.253145 pkt-line.c:85           packet:    ls-remote> 0001
  17:26:07.253149 pkt-line.c:85           packet:    ls-remote> peel
  17:26:07.253152 pkt-line.c:85           packet:    ls-remote> symrefs
  17:26:07.253190 pkt-line.c:85           packet:    ls-remote> unborn
  17:26:07.253194 pkt-line.c:85           packet:    ls-remote> 0000
  17:26:07.442198 pkt-line.c:85           packet:    ls-remote< 57cc656c9ba9c0acc8e154e2f90ed71db38d9f9d HEAD symref-target:refs/heads/gh-pages
  17:26:07.442296 pkt-line.c:85           packet:    ls-remote< 27a6c1fecf9884b1b0d29f2f1a49855f071900b1 refs/heads/archive/gitbook
  17:26:07.442309 pkt-line.c:85           packet:    ls-remote< 57cc656c9ba9c0acc8e154e2f90ed71db38d9f9d refs/heads/gh-pages
  17:26:07.442316 pkt-line.c:85           packet:    ls-remote< cc85933d8668be4b27ec6d4e3acfc4a63fb29e91 refs/heads/gitbook
  17:26:07.442322 pkt-line.c:85           packet:    ls-remote< 724d0b8d74cad6ccdb9cb2a57aede7dac74210bc refs/heads/marslo
  17:26:07.442328 pkt-line.c:85           packet:    ls-remote< 5ba1e42dd5cca96e01632f5c72de5ce71710a827 refs/heads/sample
  17:26:07.442335 pkt-line.c:85           packet:    ls-remote< 7b9e77ce7fd9bb3d2af98e3c0769e8d54f197fe2 refs/heads/sandbox/marslo/2f8293596-issue-fix
  17:26:07.442341 pkt-line.c:85           packet:    ls-remote< 7315e94fd4f71492a0b50dc799bde189eb2ad895 refs/pull/1/head
  17:26:07.442348 pkt-line.c:85           packet:    ls-remote< 2fa1e6a8628b628bc46298eb13a68423c9fe0f83 refs/remotes/origin/gh-pages
  17:26:07.442354 pkt-line.c:85           packet:    ls-remote< d16adaeaf61d2f25add763691b1a7c832db12de3 refs/remotes/origin/marslo
  17:26:07.442360 pkt-line.c:85           packet:    ls-remote< 0000
  57cc656c9ba9c0acc8e154e2f90ed71db38d9f9d        HEAD
  27a6c1fecf9884b1b0d29f2f1a49855f071900b1        refs/heads/archive/gitbook
  57cc656c9ba9c0acc8e154e2f90ed71db38d9f9d        refs/heads/gh-pages
  cc85933d8668be4b27ec6d4e3acfc4a63fb29e91        refs/heads/gitbook
  724d0b8d74cad6ccdb9cb2a57aede7dac74210bc        refs/heads/marslo
  5ba1e42dd5cca96e01632f5c72de5ce71710a827        refs/heads/sample
  7b9e77ce7fd9bb3d2af98e3c0769e8d54f197fe2        refs/heads/sandbox/marslo/2f8293596-issue-fix
  7315e94fd4f71492a0b50dc799bde189eb2ad895        refs/pull/1/head
  2fa1e6a8628b628bc46298eb13a68423c9fe0f83        refs/remotes/origin/gh-pages
  d16adaeaf61d2f25add763691b1a7c832db12de3        refs/remotes/origin/marslo
  17:26:07.442965 pkt-line.c:85           packet:    ls-remote> 0000
  ```

- `GIT_TRACE_PERFORMANCE`
  ```bash
  $ GIT_TRACE_PERFORMANCE=true git gc
  17:26:40.366194 trace.c:414             performance: 0.647718530 s: git command: /usr/local/libexec/git-core/git pack-refs --all --prune
  17:26:41.773137 trace.c:414             performance: 1.370108227 s: git command: /usr/local/libexec/git-core/git reflog expire --all
  17:26:42.948989 read-cache.c:2388       performance: 0.005399312 s:  read cache .git/index
  Enumerating objects: 147825, done.
  Counting objects: 100% (147825/147825), done.
  Delta compression using up to 4 threads
  Compressing objects: 100% (29746/29746), done.
  Writing objects: 100% (147825/147825), done.
  Total 147825 (delta 116636), reused 147130 (delta 115980), pack-reused 0
  17:27:22.708361 trace.c:414             performance: 40.753740844 s: git command: /usr/local/libexec/git-core/git pack-objects --local --delta-base-offset .git/objects/pack/.tmp-26505-pack --keep-true-parents --honor-pack-keep --non-empty --all --reflog --indexed-objects
  17:27:24.196894 trace.c:414             performance: 1.380585771 s: git command: /usr/local/libexec/git-core/git pack-objects --local --delta-base-offset .git/objects/pack/.tmp-26505-pack --cruft --cruft-expiration=2.weeks.ago --honor-pack-keep --non-empty
  Removing duplicate objects: 100% (256/256), done.
  17:27:28.456295 trace.c:414             performance: 46.624001391 s: git command: /usr/local/libexec/git-core/git repack -d -l --cruft --cruft-expiration=2.weeks.ago
  17:27:28.540513 read-cache.c:2388       performance: 0.014518135 s:  read cache .git/index
  Checking connectivity: 147825, done.
  17:27:35.103105 trace.c:414             performance: 6.640800087 s: git command: /usr/local/libexec/git-core/git prune --expire 2.weeks.ago
  17:27:35.176525 trace.c:414             performance: 0.052737824 s: git command: /usr/local/libexec/git-core/git worktree prune --expire 3.months.ago
  17:27:35.246068 trace.c:414             performance: 0.067587160 s: git command: /usr/local/libexec/git-core/git rerere gc
  17:27:35.502502 trace.c:414             performance: 55.861145774 s: git command: git gc
  ```

- `GIT_TRACE_SETUP`
  ```bash
  $ GIT_TRACE_SETUP=true git status
  17:28:21.186201 trace.c:314             setup: git_dir: .git
  17:28:21.186281 trace.c:315             setup: git_common_dir: .git
  17:28:21.186288 trace.c:316             setup: worktree: /mnt/c/iMarslo/tools/git/marslo/ibook
  17:28:21.186290 trace.c:317             setup: cwd: /mnt/c/iMarslo/tools/git/marslo/ibook
  17:28:21.186292 trace.c:318             setup: prefix: docs/
  17:28:21.186300 chdir-notify.c:68       setup: chdir from '/mnt/c/iMarslo/tools/git/marslo/ibook' to '/mnt/c/iMarslo/tools/git/marslo/ibook'
  On branch marslo
  Your branch is up to date with 'origin/marslo'.

  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git restore <file>..." to discard changes in working directory)
          modified:   devops/git/config.md
          modified:   devops/git/troubleshooting.md

  17:28:25.320340 trace.c:314             setup: git_dir: .git
  17:28:25.320399 trace.c:315             setup: git_common_dir: .git
  17:28:25.320404 trace.c:316             setup: worktree: /mnt/c/iMarslo/tools/git/marslo/ibook
  17:28:25.320405 trace.c:317             setup: cwd: /mnt/c/iMarslo/tools/git/marslo/ibook
  17:28:25.320407 trace.c:318             setup: prefix: (null)
  17:28:25.630382 trace.c:314             setup: git_dir: .git
  17:28:25.630449 trace.c:315             setup: git_common_dir: .git
  17:28:25.630454 trace.c:316             setup: worktree: /mnt/c/iMarslo/tools/git/marslo/ibook
  17:28:25.630456 trace.c:317             setup: cwd: /mnt/c/iMarslo/tools/git/marslo/ibook
  17:28:25.630458 trace.c:318             setup: prefix: (null)
  no changes added to commit (use "git add" and/or "git commit -a")
  ```

### windows
```batch
C:\> set GIT_TRACE=true
C:\> set GIT_CURL_VERBOSE=true
C:\> set GIT_SSH_COMMAND=ssh -vvv
C:\> <git command here>
```

# plugins/components
### diff-highlight: command not found
- ubuntu
  ```bash
  $ dpkg -L git | grep diff-highlight
  ```
- centos/rhel
  ```bash
  $ rpm -ql git | grep diff-highlight
  ```
- arch
  ```bash
  $ pacman -Ql git | grep diff-highlight
  ```

```bash
$ sudo ln -sf /path/to/diff-highlight /usr/bin/diff-highlight
```

### error: RPC failed

> [!TIP]
> `error: RPC failed; curl 92 LibreSSL SSL_read: error:02FFF03C:system library:func(4095):Operation timed out`
>
> references:
> - [Git push getting failed. error: RPC failed; curl 56 LibreSSL SSL_read: SSL_ERROR_SYSCALL, errno 60](https://stackoverflow.com/a/56067918/2940319)

```bash
$ git config [--global] http.postBuffer 524288000
$ git config [--global] http.sslVerify false
```

# installation
## Ubuntu
### `no refs in common and none specified; doing nothing.`
- error
  ```bash
  $ git push
  No refs in common and none specified; doing nothing.
  Perhaps you should specify a branch such as 'master'.
  Everything up-to-date
  ```

- solution: `git push -u origin master`
  ```bash
  $ git push -u origin master
  Counting objects: 40, done.
  Delta compression using up to 4 threads.
  Compressing objects: 100% (40/40), done.
  Writing objects: 100% (40/40), 133.46 KiB | 0 bytes/s, done.
  Total 40 (delta 6), reused 0 (delta 0)
  To git@github.com:Marslo/LaunchySkins.git
  \* [new branch]      master -> master
  \* Branch master set up to track remote branch master from origin.
  ```

## CentOS
### /bin/sh: cc
- error:
  ```bash
  $ make prefix=/usr/local/myprograms/git
  GIT_VERSION = 2.1.0
      * new build flags
      CC credential-store.o
  /bin/sh: cc: command not found
  make: *** [credential-store.o] Error 127
  ```

- solution:
  ```bash
  $ yum install gcc gcc-g++ g++ make
  ```

### openssl/ssl.h
- error:
  ```bash
  $ make prefix=/usr/local/myprograms/git
      CC credential-store.o
  In file included from cache.h:4,
                   from credential-store.c:1:
  git-compat-util.h:213:25: warning: openssl/ssl.h: No such file or directory
  git-compat-util.h:214:25: warning: openssl/err.h: No such file or directory
  git-compat-util.h:326:25: warning: openssl/evp.h: No such file or directory
  git-compat-util.h:327:26: warning: openssl/hmac.h: No such file or directory
  git-compat-util.h:329:28: warning: openssl/x509v3.h: No such file or directory
  In file included from credential-store.c:1:
  cache.h:12:21: warning: openssl/sha.h: No such file or directory
  cache.h:20:18: warning: zlib.h: No such file or directory
  In file included from credential-store.c:1:
  cache.h:22: error: expected specifier-qualifier-list before ‘z_stream’
  make: *** [credential-store.o] Error 1
  ```

- solution:
  ```bash
  $ yum install openssl openssl-devel zlib-devel libcurl libcurl-devel
  ```

### expat.h
- error:
  ```bash
  $ make prefix=/usr/local/myprograms/git
  http-push.c:17:19: warning: expat.h: No such file or directory
  http-push.c:832: warning: type defaults to ‘int’ in declaration of ‘XML_Char’
  http-push.c:832: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
  ```

- solution:
  ```bash
  $ sudo yum install expat-devel
  ```

### asciidoc


- error:
  ```bash
  /bin/sh: line 1: asciidoc: command not found

  make[1]: *** [git-add.html] Error 127
  make[1]: Leaving directory `/root/Software/git-master/Documentation'
  make: *** [doc] Error 2
  ```

- solution:
  ```bash
  $ sudo yum install docbook-style-xsl
  $ sudo rpm -ivh http://pkgs.repoforge.org/asciidoc/asciidoc-8.6.9-1.el6.rfx.noarch.rpm

  # or

  $ wget http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.6.9/asciidoc-8.6.9.tar.gz
  $ tar xf asciidoc-8.6.9.tar.gz
  $ autoconf
  $ ./configure
  $ make
  $ sudo make install
  ```

### docbook2x-texi

- error:
  ```bash
  DB2TEXI user-manual.texi
  /bin/sh: 2: docbook2x-texi: not found
  make[1]: *** [user-manual.texi] Error 127
  make[1]: Leaving directory `/home/marslo/Tools/Software/Programming/Git/git-master/Documentation'
  make: *** [info] Error 2
  ```

- solution:
  ```bash
  $ sudo yum -y --enablerepo=*epel* install docbook2X
  $ sudo ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
  ```

### xmlto
- error:
  ```bash
  /bin/sh: line 1: xmlto: command not found
  make[1]: *** [git-add.1] Error 127
  make[1]: Leaving directory `/root/Software/git-master/Documentation'
  make: *** [doc] Error 2
  ```

- solution:
  ```bash
  $ sudo yum install xmlto
  ```

### gnu/stubs-64.h
- error:
  ```bash
  In file included from /usr/include/features.h:399:0,
                   from /usr/include/unistd.h:25,
                   from git-compat-util.h:158,
                   from cache.h:4,
                   from credential-store.c:1:
  /usr/include/gnu/stubs.h:10:27: fatal error: gnu/stubs-64.h: No such file or directory
   # include <gnu/stubs-64.h>
                             ^
  compilation terminated.
  make: *** [credential-store.o] Error 1
  ```

- solution:
  ```bash
  $ sudo yum install glibc-devel
  ```

# `git diff` extreamly slow

> [!NOTE|label:references:]
> - [* AMD was contacted but no response...](https://stackoverflow.com/a/48390680/2940319)
>   - [diagram from Windows 10 2018](https://devblogs.microsoft.com/commandline/windows-command-line-introducing-the-windows-pseudo-console-conpty/)
>   - [microsoft/terminal issue 9744](https://github.com/microsoft/terminal/issues/9744)
> - [#1071 : 2.11.1 slow enough to make it unusable in Windows 10 x64 - upgraded from 2.9 lighting fast](https://github.com/git-for-windows/git/issues/1071#issuecomment-289156610)
>   ```
>   I solved the Radeon/MinTTy issue (for me at least!).
>   After blaming AMD - and updating their driver (twice) hoping for a fix, i checked for an update to my onboard intel driver - and - indeed there was! I updated to the latest for my Intel 530 HD graphics and i'm back to normal!
>   ```
> - [__git_ps1 extremely slow in kernel tree](https://stackoverflow.com/a/4203968/2940319)
> - [Git is extremely slow on Windows](https://superuser.com/questions/1160349/git-is-extremely-slow-on-windows#_=_)
> - [Git Bash (mintty) is extremely slow on Windows 10 OS](https://stackoverflow.com/a/43762587/2940319)
> - [git-prompt.sh](https://opensource.apple.com/source/Git/Git-63/src/git/contrib/completion/git-prompt.sh.auto.html)
> - [bash-git-prompt](https://github.com/magicmonty/bash-git-prompt)
> - [#4197 : [wsl2] filesystem performance is much slower than wsl1 in /mnt](https://github.com/microsoft/WSL/issues/4197)
> - [Git is really slow for 100,000 objects. Any fixes?](https://stackoverflow.com/a/43667992/2940319)
> - [way to improve git status performance](https://stackoverflow.com/a/74889434/2940319)
>   - [The performance of git status should improve with Git 2.13 (Q2 2017)](https://stackoverflow.com/a/43644347/2940319)
> - [* Understanding the performance bottlenecks](https://seb.jambor.dev/posts/performance-optimizations-for-the-shell-prompt/)
>   - `GIT_PS1_SHOWDIRTYSTATE`: 58 milliseconds.
>   - `GIT_PS1_SHOWUNTRACKEDFILES`: 106 milliseconds.
>   - `GIT_PS1_SHOWSTASHSTATE`: 8.7 milliseconds.
>   - `GIT_PS1_SHOWUPSTREAM`: 10.6 milliseconds.
>   - [Improving performance](https://seb.jambor.dev/posts/performance-optimizations-for-the-shell-prompt/)


## way to debug

> [!NOTE|label:references:]
> - [__git_ps1 extremely slow in kernel tree](https://stackoverflow.com/a/5076116/2940319)
> - [Diagnosing performance issues](https://github.com/git-for-windows/git/wiki/Diagnosing-performance-issues)

```bash
$ bash -x
$ time __git_ps1
```

- [or](https://unix.stackexchange.com/a/322824/29178)
  ```bash
  $ bash --debugger
  $ PS4='+ ${BASH_SOURCE[0]} '
  $ set -x ; __git_ps1 ; set +x
  ```

## solution

> [!WARN|label:not been fixed yet]
> - [index : git.git](https://git.kernel.org/pub/scm/git/git.git/tree/contrib/completion?id=master)


- check status

  > [!NOTE|label:references:]
  > - [#1070 : Git commands have a 2-3 second delay before returning to the promp](https://github.com/git-for-windows/git/issues/1070)

  ```bash
  $ git --version --build-options
  git version 2.42.0
  cpu: x86_64
  no commit associated with this build
  sizeof-long: 8
  sizeof-size_t: 8
  shell-path: /bin/sh

  > cmd.exe /c ver
  Microsoft Windows [Version 10.0.19044.3448]

  $ cat '/mnt/c/Program Files/Git/etc/install-options.txt'
  Editor Option: VIM
  Custom Editor Path:
  Default Branch Option:
  Path Option: Cmd
  SSH Option: OpenSSH
  Tortoise Option: false
  CURL Option: OpenSSL
  CRLF Option: LFOnly
  Bash Terminal Option: MinTTY
  Git Pull Behavior Option: Rebase
  Use Credential Manager: Enabled
  Performance Tweaks FSCache: Enabled
  Enable Symlinks: Enabled
  Enable Pseudo Console Support: Disabled
  Enable FSMonitor: Disabled
  ```

- modify configures

  > [!NOTE|label:references:]
  > - [remove options for unusable on a tree the size of the kernel](https://stackoverflow.com/a/4203968/2940319)
  > - [Git Bash is extremely slow on Windows 7 x64](https://stackoverflow.com/a/24045966/2940319)

  - GIT_PS1
    ```bash
    $ export GIT_PS1_SHOWDIRTYSTATE=true
    $ export GIT_PS1_SHOWUNTRACKEDFILES=true

    # or
    export GIT_PS1_SHOWDIRTYSTATE=
    export GIT_PS1_SHOWUNTRACKEDFILES=
    ```
    - [more on GIT_PS1 env](https://digitalfortress.tech/tutorial/setting-up-git-prompt-step-by-step/)
      - `GIT_PS1_SHOWDIRTYSTATE=true`
      - `GIT_PS1_SHOWSTASHSTATE=true`
      - `GIT_PS1_SHOWUNTRACKEDFILES=true`
      - `GIT_PS1_SHOWUPSTREAM="auto"`
      - `GIT_PS1_HIDE_IF_PWD_IGNORED=true`
      - `GIT_PS1_SHOWCOLORHINTS=true`

  - bash.showDirtyState
    ```bash
    $ git config --global bash.showDirtyState true

    # and override this for the kernel tree only
    $ git config bash.showDirtyState false
    ```

  - [gc](https://stackoverflow.com/a/24045966/2940319)

    > more:
    > - [`core.fscache`](https://github.com/msysgit/git/commit/64d63240762df22e92b287b145d75a0d68a66988)

    ```bash
    git config --global core.preloadindex true
    git config --global core.fscache true
    git config --global gc.auto 256
    ```

  - [enable parallel index preload](https://stackoverflow.com/a/22208863/2940319)
    ```bash
    $ git config --global core.preloadindex true
    ```

  - [submodule](https://stackoverflow.com/a/40915862/2940319)
    ```bash
    $ git config --global status.submoduleSummary false

    # or
    $ git config --global submodule.fetchJobs 8
    ```

- [AMD Radeon graphics driver](https://github.com/git-for-windows/git/issues/1129#issuecomment-292913224)

  > [!NOTE|label:references:]
  > - [* AMD was contacted but no response...](https://stackoverflow.com/a/48390680/2940319)
  >   - [diagram from Windows 10 2018](https://devblogs.microsoft.com/commandline/windows-command-line-introducing-the-windows-pseudo-console-conpty/)
  >   - [microsoft/terminal issue 9744](https://github.com/microsoft/terminal/issues/9744)
  > - [Git Bash (mintty) is extremely slow on Windows 10 OS](https://stackoverflow.com/a/43762587/2940319)
  > - [#1071 : 2.11.1 slow enough to make it unusable in Windows 10 x64 - upgraded from 2.9 lighting fast](https://github.com/git-for-windows/git/issues/1071)
  > - [#1070 : Git commands have a 2-3 second delay before returning to the promp](https://github.com/git-for-windows/git/issues/1070)
  > - [#1129 : git commands running slow as hell ](https://github.com/git-for-windows/git/issues/1129#issuecomment-292913224)
  >   ```
  >   I had the similar issue as yours on my Lenovo e450c laptop.
  >   And found the performance turned back to normal when I disabled AMD Radeon graphics driver in Windows device manager and switched to integrated Intel HD graphics.
  >   ```

  ![AMD Radeon graphics driver](https://i.stack.imgur.com/FOFML.png)

- [fast_git_ps1](https://stackoverflow.com/a/43142926/2940319)

  ```bash
  fast_git_ps1 () {
      printf -- "$(git branch 2>/dev/null | grep -e '\* ' | sed 's/^..\(.*\)/ {\1} /')"
  }

  PS1='\[\033]0;$MSYSTEM:\w\007
  \033[32m\]\u@\h \[\033[33m\w$(fast_git_ps1)\033[0m\]
  $ '
  ```

  - [or](https://stackoverflow.com/a/19500237/2940319)
    ```bash
    (git symbolic-ref --short -q HEAD || git rev-parse --short HEAD) 2> /dev/null
    ```

  - [no refresh index](https://stackoverflow.com/a/59063356/2940319)
    ```bash
    $ git config core.checkStat minimal
    $ git config core.trustctime false

    # or
    $ git config --global core.checkStat minimal
    $ git config --global core.trustctime false
    ```

  - [`core.preloadIndex`](https://stackoverflow.com/a/48402774/2940319)
    ```bash
    $ git config --global core.preloadIndex true
    ```


- commands
  - [repack](https://stackoverflow.com/a/22234919/2940319)
    ```bash
    $ git repack -ad
    ```

  - [gc](https://stackoverflow.com/a/3313921/2940319)
    ```bash
    $ git gc --aggressive
    ```
