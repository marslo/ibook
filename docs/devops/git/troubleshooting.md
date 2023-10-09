<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [debug opt](#debug-opt)
  - [git debug options](#git-debug-options)
  - [Linux](#linux)
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
- [`__git_ps1` extreamly slow](#__git_ps1-extreamly-slow)
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

# `__git_ps1` extreamly slow

> [!NOTE|label:references:]
> - [#1071 :2.11.1 slow enough to make it unusable in Windows 10 x64 - upgraded from 2.9 lighting fast](https://github.com/git-for-windows/git/issues/1071#issuecomment-289156610)
>   ```
>   I solved the Radeon/MinTTy issue (for me at least!).
>   After blaming AMD - and updating their driver (twice) hoping for a fix, i checked for an update to my onboard intel driver - and - indeed there was! I updated to the latest for my Intel 530 HD graphics and i'm back to normal!
>   ```
> - [__git_ps1 extremely slow in kernel tree](https://stackoverflow.com/a/4203968/2940319)
> - [Git is extremely slow on Windows](https://superuser.com/questions/1160349/git-is-extremely-slow-on-windows#_=_)
> - [Git Bash (mintty) is extremely slow on Windows 10 OS](https://stackoverflow.com/a/43762587/2940319)
> - [git-prompt.sh](https://opensource.apple.com/source/Git/Git-63/src/git/contrib/completion/git-prompt.sh.auto.html)
> - [bash-git-prompt](https://github.com/magicmonty/bash-git-prompt)


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
      - `GIT_PS1_SHOWDIRTYSTATE=true```
      - `GIT_PS1_SHOWSTASHSTATE=true```
      - `GIT_PS1_SHOWUNTRACKEDFILES=true```
      - `GIT_PS1_SHOWUPSTREAM="auto"```
      - `GIT_PS1_HIDE_IF_PWD_IGNORED=true```
      - `GIT_PS1_SHOWCOLORHINTS=true```

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
