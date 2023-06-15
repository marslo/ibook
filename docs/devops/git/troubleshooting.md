<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [debug](#debug)
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

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


# [debug](https://www.shellhacks.com/git-verbose-mode-debug-fatal-errors/)
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
