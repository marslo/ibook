<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [installer](#installer)
  - [sdkman](#sdkman)
  - [cargo](#cargo)
  - [snap](#snap)
- [application](#application)
  - [python](#python)
  - [vim](#vim)
  - [nvim](#nvim)
  - [copilot](#copilot)
  - [java](#java)
  - [groovy](#groovy)
  - [gcc](#gcc)
  - [glibc](#glibc)
    - [glibc troubleshooting](#glibc-troubleshooting)
  - [lua](#lua)
  - [ruby](#ruby)
  - [mono](#mono)
  - [cmake](#cmake)
  - [llvm](#llvm)
  - [go](#go)
  - [node && npm](#node--npm)
    - [nodesource/distributions](#nodesourcedistributions)
    - [node/npm troubleshooting](#nodenpm-troubleshooting)
    - [install from private registry](#install-from-private-registry)
    - [upgrade via `n`](#upgrade-via-n)
  - [gradle](#gradle)
  - [rust](#rust)
  - [haskell](#haskell)
    - [haskell-platform](#haskell-platform)
    - [haskell-stack](#haskell-stack)
  - [hadolint](#hadolint)
  - [mysql](#mysql)
    - [built from source code](#built-from-source-code)
    - [install from apt repo](#install-from-apt-repo)
  - [mysql-connector (jdbc)](#mysql-connector-jdbc)
  - [vncserver](#vncserver)
- [compiler environment](#compiler-environment)
  - [pkg-config](#pkg-config)
  - [ldconfig](#ldconfig)
- [auto completion](#auto-completion)
  - [bash-completion](#bash-completion)
  - [bash-completion@2](#bash-completion2)
    - [troubleshooting for `bash-completion@2`](#troubleshooting-for-bash-completion2)
  - [tools](#tools)
    - [fzf](#fzf)
    - [npm](#npm)
    - [python](#python-1)
    - [ansible](#ansible)
    - [git](#git)
    - [vault CLI](#vault-cli)
    - [others](#others)
  - [script](#script)
    - [groovy](#groovy-1)
- [troubleshooting](#troubleshooting)
  - [issues](#issues)
  - [cheatsheet](#cheatsheet)
    - [to use the bundled libc++ please add the following LDFLAGS](#to-use-the-bundled-libc-please-add-the-following-ldflags)
    - [check osx compilers](#check-osx-compilers)
    - [check *.o file](#check-o-file)
- [env](#env)
  - [manpath](#manpath)
- [others](#others-1)
  - [GitHubDaily/GitHubDaily](#githubdailygithubdaily)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP]
> - [* iMarslo : devenv troubleshooting](../../linux/troubleshooting.html)

# installer

> [!NOTE]
> - [package info/download for Linux system](https://pkgs.org/)

## [sdkman](https://sdkman.io/install)
```bash
$ curl -s "https://get.sdkman.io" | bash
$ source "$HOME/.sdkman/bin/sdkman-init.sh"

$ sdk version
SDKMAN!
script: 5.18.2
native: 0.4.6

$ sdk install gradle
```

## [cargo](https://doc.rust-lang.org/cargo/index.html)
```bash
$ curl https://sh.rustup.rs -sSf | sh
```

## [snap](https://snapcraft.io/)
```bash
# debine
$ sudo apt update
$ sudo apt install snapd

# fedora
$ sudo dnf install snapd
$ sudo ln -s /var/lib/snapd/snap /snap
```

# application
## [python](../programming/python/config.html#install-from-source-code)
## [vim](../vim/install.html)

* [osx](../vim/install.html#osx)
* [linux](../vim/install.html#linux)
* [windows](../vim/install.html#windows)

## [nvim](../vim/nvim.html)
## copilot

> [!NOTE|label:references]
> - [microsoft/Mastering-GitHub-Copilot-for-Paired-Programming](https://github.com/microsoft/Mastering-GitHub-Copilot-for-Paired-Programming)

## java
* download jdk 1.8.0_121
  ```bash
  $ mkdir -p /opt/java && cd /opt/java
  $ wget --no-check-certificate \
         -c \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz

  # or
  $ curl -L -C - -b "oraclelicense=accept-securebackup-cookie" \
         -O http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
  $ tar xf jdk-8u121-linux-x64.tar.gz

  # or
  $ curl -L -C - -b "oraclelicense=accept-securebackup-cookie" \
         -fsS http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz |
    tar xzf - -C /opt/java
  ```

* setup java environment
  ```bash
  $ sudo bash -c 'cat >> /etc/bash.bashrc' << EOF
  JAVA_HOME="/opt/java/jdk1.8.0_121"
  CLASSPATH=".:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar"
  PATH=/home/marslo/.marslo/myprograms/vim80/bin:$JAVA_HOME/bin:$PATH
  export JAVA_HOME CLASSPATH PATH
  EOF
  ```

* setup default jdk
  ```bash
  $ sudo update-alternatives --install /usr/bin/java java /opt/java/jdk1.8.0_121/bin/java 999
  $ sudo update-alternatives --auto java
  $ sudo update-alternatives --install /usr/bin/javac javac /opt/java/jdk1.8.0_121/bin/javac 999
  $ sudo update-alternatives --auto javac
  ```

## groovy
* download groovy binary pakcage
  ```bash
  $ mkdir -p /opt/groovy && cd /opt/groovy
  $ wget --no-check-certificate -c https://akamai.bintray.com/1c/1c4dff3b6edf9a8ced3bca658ee1857cee90cfed1ee3474a2790045033c317a9?__gda__=exp=1490346679~hmac=6d64a1c3596da50e470fb6a46b182ba2cacab553c66843c8ea292e1e70e4e243&response-content-disposition=attachment%3Bfilename%3D%22apache-groovy-binary-2.4.10.zip%22&response-content-type=application%2Foctet-stream&requestInfo=U2FsdGVkX19cWhR3RJcR6SCy74HUcDg470ifD-nH2EiE5uxtdI5EbUiW_jGoHgZZTVR3qgks9tiU5441axygT9z3ykqpL45d_-9oyTlOp8Gild5Z7iGRzCiwf0kba9uza8iWDxnIxgnUIg5tDe6N8ZQ3R0yFCY4c4w7czwBGyK0
  $ unzip apache-groovy-binary-2.4.10.zip
  ```

* setup groovy environment
  ```bash
  $ sudo bash -c 'cat >> /etc/bash.bashrc' << EOF
  export GROOVY_HOME="/opt/groovy/groovy-2.4.10"'
  export PATH=$GROOVY_HOME/bin:$PATH'
  EOF
  ```

* set default groovy
  ```bash
  $ sudo update-alternatives --install /usr/bin/groovy groovy /opt/groovy/groovy-2.4.10/bin/groovy 999999999
  $ sudo update-alternatives --auto groovy

  # or
  $ sudo alternatives --config groovy
  ```

## gcc

> [!NOTE]
> - [Index of /sites/sourceware.org/pub/gcc/releases/](https://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases)
> - [gcc.gnu.org](https://gcc.gnu.org/)
> - [Installing GCC](https://gcc.gnu.org/wiki/InstallingGCC)
> - [How To Install GCC on CentOS 7](https://linuxhostsupport.com/blog/how-to-install-gcc-on-centos-7/)
> - [Host/Target specific installation notes for GCC](https://gcc.gnu.org/install/specific.html)

- install
  ```bash
  $ mdir -p /opt/gcc
  $ curl -fsSL https://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.gz | tar xzf - -C /opt/gcc
  $ cd /opt/gcc/gcc-13.2.0

  # prerequisites
  gcc-13.2.0 $ grep base_url= contrib/download_prerequisites
  base_url='http://gcc.gnu.org/pub/gcc/infrastructure/'
  gcc-13.2.0 $ ./contrib/download_prerequisites

  # config
  gcc-13.2.0 $ mkdir ../objdir && cd $_
  objdir $ ../gcc-13.2.0/configure --disable-multilib

  # make
  objdir $ NPROC="$(nproc)"
  objdir $ tmux                # it will take very long time to build, better using tmux to avoid interrupt by ssh session down
  objdir $ make -j${NPROC} [ | tee make.log ]

  # install
  objdir $ sudo make install
  ```

- configure
  ```bash
  $ sudo mv /usr/bin/g++{,.8.5.0}
  $ sudo mv /usr/bin/gcc{,.8.5.0}
  $ sudo mv /usr/bin/c++{,.8.5.0}

  $ sudo alternatives --install /usr/bin/g++ g++ /usr/local/bin/g++ 50
  $ sudo alternatives --install /usr/bin/gcc gcc /usr/local/bin/gcc 50
  $ sudo alternatives --install /usr/bin/c++ c++ /usr/local/bin/c++ 50
  ```

- verify
  ```bash
  $ gcc --version
  gcc (GCC) 13.2.0
  Copyright (C) 2023 Free Software Foundation, Inc.
  This is free software; see the source for copying conditions.  There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  $ g++ --version
  g++ (GCC) 13.2.0
  Copyright (C) 2023 Free Software Foundation, Inc.
  This is free software; see the source for copying conditions.  There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  $ c++ --version
  c++ (GCC) 13.2.0
  Copyright (C) 2023 Free Software Foundation, Inc.
  This is free software; see the source for copying conditions.  There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  ```

## glibc

> [!NOTE|label:references:]
> - [Reverting installation of glibc to CentOS libraries](https://forums.centos.org/viewtopic.php?t=76973)
>   ```bash
>   # crash
>   build $ ../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
>   ```
> - [Index of /gnu/glibc](https://ftp.gnu.org/gnu/glibc/)
> - upgrade glibc due to
>   ```bash
>   /lib64/libc.so.6: version `GLIBC_2.18’ not found`
>   ```
> - [glibc-2.28-246.el8.aarch64.rpm](https://pkgs.org/download/glibc)
> - [safely upgrade glibc on CentOS 7](https://serverfault.com/a/894689/129815)
> - [How to upgrade glibc from version 2.12 to 2.14 on CentOS?](https://stackoverflow.com/a/38317265/2940319)
> - [* Glibc installation](https://leistech.blogspot.com/2015/06/glibc-installation.html)
> - [* 谨慎操作. libc.so.6: version `GLIBC_2.14’ not found.](https://feng1o.github.io/01.glibc/)
> - [harv/glibc-2.17_centos6.sh](https://gist.github.com/harv/f86690fcad94f655906ee9e37c85b174)

```bash
$ mkdir -p /opt/glibc
$ curl -fsSL https://ftp.gnu.org/gnu/glibc/glibc-2.38.tar.xz | tar -xJf - -C /opt/glibc
$ mkdir -p /opt/glibc/glibc-2.38/build && cd $_

build $ ../configure --prefix=/opt/glibc/2.38
# or
build $ ../configure --prefix `pwd`/../install

build $ make -j $(nproc)
build $ sudo make install
# highly recommended
build $ make install DESTDIR=/root/glibc-2.14/staging
```

### [glibc troubleshooting](https://leistech.blogspot.com/2015/06/glibc-installation.html)

- No rule to make target `glibc-build/Versions.all`, needed by `glibc-build/abi-versions.h`. Stop.
  ```bash
  $ sudo dnf install gawk texinfo
  ```

- make[2]: *** [/mnt/lfs/sources/glibc-build/misc/syslog.o] Error 1
  ```bash
  $ make clean
  $ make -j2 CFLAGS="-U_FORTIFY_SOURCE -O2 -fno-stack-protector"
  ```

- ldconfig: Can't open configuration
  ```bash
  /opt/glibc-2.14/etc $ sudo sh -c "echo '/usr/local/lib' >> ld.so.conf"
  /opt/glibc-2.14/etc $ sudo sh -c "echo '/opt/lib' >> ld.so.conf"
  ```

- manpath
  ```bash
  $ echo $MANPATH
  /usr/local/opt/coreutils/libexec/gnuman:/usr/local/share/man:/usr/share/man:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/man

  $ eclr
  >> unset MANPATH
  .. /usr/local/opt/coreutils/libexec/gnuman:/usr/local/share/man:/usr/share/man:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/man
  $ echo $MANPATH

  $ manpath
  /Users/marslo/.local/share/man:/usr/local/Cellar/icu4c@71.1/71.1/share/man:/usr/local/vim/share/man:/Applications/MacVim.app/Contents/man:/usr/local/nvim/share/man:/usr/local/opt/gnu-getopt/share/man:/usr/local/opt/binutils/share/man:/usr/local/opt/ruby/share/man:/usr/local/opt/tcl-tk/share/man:/usr/local/opt/node@21/share/man:/usr/local/Cellar/openjdk/21.0.1/libexec/openjdk.jdk/Contents/Home/man:/usr/local/opt/ed/share/man:/usr/local/opt/gettext/share/man:/usr/local/opt/file-formula/share/man:/usr/local/opt/curl/share/man:/usr/local/opt/openssl/share/man:/usr/local/opt/libiconv/share/man:/usr/local/opt/sqlite/share/man:/usr/local/share/man:/usr/share/man:/Library/Apple/usr/share/man:/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/share/man:/Applications/Xcode.app/Contents/Developer/usr/share/man:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/man
  ```

## lua

> [!NOTE]
> - [lua download](https://luabinaries.sourceforge.net/download.html)
> - [LuaBinaries Files](https://sourceforge.net/projects/luabinaries/files/)
> - [How to compile Lua 5.4.0 for Linux as a shared library](https://blog.spreendigital.de/2020/05/24/how-to-compile-lua-5-4-0-for-linux-as-a-shared-library/)
> - [Compiling Lua - create .so files?](https://stackoverflow.com/a/28773470/2940319)
>   - [dcarrith/Makefile.patch](https://gist.github.com/dcarrith/899047f3a2d603b25a58)
>   - [dcarrith/src.Makefile.patch](https://gist.github.com/dcarrith/6095183b8dc60c909779)
> - [* iMarslo : patch for build lua v5.4.6 as a shared library (liblua.so)](https://gist.github.com/marslo/767e339e32e0dbc038a3e00e3c8a7cba)

```bash
$ mkdir -p /opt/lua
$ curl -fsSL https://www.lua.org/ftp/lua-5.4.6.tar.gz | tar xzf - -C /opt/lua
$ cd /opt/lua/lua-5.4.6

$ make all test
$ sudo make install
```

- build with `.so` file

  ```bash
  $ patch --ignore-whitespace < <(curl -fsSL https://gist.githubusercontent.com/marslo/767e339e32e0dbc038a3e00e3c8a7cba/raw/01f29ac774a468221082f4d504b013d264435567/Makefile.patch)
  $ cd src
  $ patch --ignore-whitespace < <(curl -fsSL https://gist.githubusercontent.com/marslo/767e339e32e0dbc038a3e00e3c8a7cba/raw/01f29ac774a468221082f4d504b013d264435567/src.Makefile.patch)

  $ make all test && sudo make install
  ```

## ruby

> [!NOTE|label:references:]
> - [How to Install Ruby 3.2 on CentOS & RHEL using RVM](https://tecadmin.net/install-ruby-3-on-centos/)
> - [rbenv/rbenv](https://github.com/rbenv/rbenv)
> - [rbenv/rbenv-installer](https://github.com/rbenv/rbenv-installer)
> - [* ftp:pub/ruby](https://ftp.ruby-lang.org/pub/ruby/)

- rbenv
  ```bash
  # debine
  $ sudo apt install libffi-dev libyaml-dev

  $ curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
  # or
  $ wget -q https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer -O- | bash

  $ ~/.rbenv/bin/rbenv init
  $ echo 'export PATH="$PATH:$HOME/.rbenv/bin"' >> ~/.bashrc
  $ echo 'eval "$(/home/marslo/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc

  # list latest available versions
  $ rbenv install -l
  3.0.6
  3.1.4
  3.2.2
  3.3.0
  jruby-9.4.5.0
  mruby-3.2.0
  picoruby-3.0.0
  truffleruby-23.1.1
  truffleruby+graalvm-23.1.1

  # install
  $ rbenv install 3.3.0
  ==> Downloading ruby-3.3.0.tar.gz...
  -> curl -q -fL -o ruby-3.3.0.tar.gz https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.0.tar.gz
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
  100 21.0M  100 21.0M    0     0  27.6M      0 --:--:-- --:--:-- --:--:-- 27.5M
  ==> Installing ruby-3.3.0...
  # linux
  -> ./configure "--prefix=$HOME/.rbenv/versions/3.3.0" --enable-shared --with-ext=openssl,psych,+
  # osx
  -> ./configure "--prefix=$HOME/.rbenv/versions/3.3.0" --enable-shared --with-readline-dir=/usr/local/opt/readline --with-libyaml-dir=/usr/local/opt/libyaml --with-gmp-dir=/usr/local/opt/gmp --with-ext=openssl,psych,+ --with-openssl-dir=/usr/local/opt/openssl
  -> make -j 32
  -> make install
  ==> Installed ruby-3.3.0 to /home/marslo/.rbenv/versions/3.3.0

  $ rbenv global 3.3.0
  ```

  - [install offline package](https://stackoverflow.com/a/35589999)

    > [!TIP]
    > - [#2184 Installing Ruby 3.2.2 on FreeBSD fails due to missing libyaml even when it is installed](https://github.com/rbenv/ruby-build/issues/2184#issuecomment-1508529361)

    ```bash
    # online machine
    $ curl -q -fL -o ruby-3.3.0.tar.gz https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.0.tar.gz
    $ scp ruby-3.3.0.tar.gz account@server.com:~/.rbenv/cache

    # offline machine
    $ sudo apt install libyaml-dev libyaml-doc
    $ export CPPFLAGS=-I/usr/local/include
    $ export LDFLAGS=-L/usr/local/lib
    $ rbenv install 3.3.0
    ==> Installing ruby-3.3.0...
    -> ./configure "--prefix=$HOME/.rbenv/versions/3.3.0" --enable-shared --with-ext=openssl,psych,+
    -> make -j 128
    -> make install
    ==> Installed ruby-3.3.0 to /home/marslo/.rbenv/versions/3.3.0
    $ rbenv global 3.3.0
    ```

  - result
    ```bash
    $ ruby --version
    ruby 3.3.0 (2023-12-25 revision 5124f9ac75) [x86_64-linux]

    $ bundler --version
    Bundler version 2.5.3
    ```

- rvm
  ```bash
  $ sudo yum update -y
  $ sudo yum install curl gpg gcc gcc-c++ make libyaml-devel openssl-devel readline-devel zlib-devel -y

  $ command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
  $ command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
  $ curl -sSL https://get.rvm.io | bash -s stable
  $ echo "export PATH=\"$PATH:$HOME/.rvm/bin\"" >> ~/.bashrc

  # verify
  $ rvm --version
  rvm 1.29.12 (latest) by Michal Papis, Piotr Kuczynski, Wayne E. Seguin [https://rvm.io]

  # install ruby
  $ rvm install 3.3
  $ rvm use 3.3 --default
  ```

## mono

> [!NOTE]
> - [mono download](https://www.mono-project.com/download/stable/)
> - [mono repo](https://download.mono-project.com/repo/)

```bash
# centos 7
$ sudo su -c 'curl https://download.mono-project.com/repo/centos7-stable.repo |tee /etc/yum.repos.d/mono-centos7-stable.repo'

# centos 8
$ sudo rpm --import 'http://pool.sks-keyservers.net/pks/lookup?op=get&search=0x3fa7e0328081bff6a14da29aa6a19b38d3d831ef'
$ sudo dnf config-manager --add-repo https://download.mono-project.com/repo/centos8-stable.repo

$ sudo yum install mono-devel
$ mono --version
Mono JIT compiler version 6.12.0.107 (tarball Wed Dec  9 21:44:58 UTC 2020)
Copyright (C) 2002-2014 Novell, Inc, Xamarin Inc and Contributors. www.mono-project.com
        TLS:           __thread
        SIGSEGV:       altstack
        Notifications: epoll
        Architecture:  amd64
        Disabled:      none
        Misc:          softdebug
        Interpreter:   yes
        LLVM:          yes(610)
        Suspend:       hybrid
        GC:            sgen (concurrent by default)

# optional
$ sudo yum install mono-complete
```

- repo files
  ```bash
  $ cat -pp mono-centos7-stable.repo
  [mono-centos7-stable]
  name=mono-centos7-stable
  baseurl=https://download.mono-project.com/repo/centos7-stable/
  enabled=1
  gpgcheck=1
  gpgkey=https://download.mono-project.com/repo/xamarin.gpg

  $ cat -pp mono-centos8-stable.repo
  [mono-centos8-stable]
  name=mono-centos8-stable
  baseurl=https://download.mono-project.com/repo/centos8-stable/
  enabled=1
  gpgcheck=1
  gpgkey=https://download.mono-project.com/repo/xamarin.gpg
  ```

## cmake

> [!NOTE|label:references]
> - [How to install cmake 3.2 on Ubuntu](https://askubuntu.com/a/1254438/92979)
> - [#2756: CMake Error,no libclang found](https://github.com/ycm-core/YouCompleteMe/issues/2756)

```bash
# snap
$ sudo snap install cmake --classic

# pip
$ pip install --user cmake

# dnf
$ sudo dnf install cmake make
```

## llvm

> [!NOTE|label:references:]
> - [PDF: Red Hat Developer Tools 1: Using LLVM 13.0.1 Toolset](https://access.redhat.com/documentation/en-us/red_hat_developer_tools/1/pdf/using_llvm_13.0.1_toolset/red_hat_developer_tools-1-using_llvm_13.0.1_toolset-en-us.pdf)
> - [Using LLVM 13.0.1 Toolset](https://access.redhat.com/documentation/en-us/red_hat_developer_tools/1/html/using_llvm_13.0.1_toolset/assembly_llvm#proc_installing-comp-toolset_assembly_llvm)
> - [Getting Started with the LLVM System](https://llvm.org/docs/GettingStarted.html)

```bash
# dnf
$ sudo dnf install llvm llvm-libs
```

## go

> [!NOTE|label:references:]
> - [Go: Download and install](https://go.dev/doc/install)
> - [Managing Go installations](https://go.dev/doc/manage-install#linux-mac-bsd)

```bash
# snap
$ sudo snap install go --classic

# apt
$ sudo apt install golang-1.21 golang-1.21-go golang-1.21-doc
# or
$ sudo apt install golang-go
$ sudo update-alternatives --install /usr/bin/go go /usr/lib/go-1.21/bin/go 99
$ sudo update-alternatives --install /usr/bin/gofmt gofmt /usr/lib/go-1.21/bin/gofmt 99
$ sudo update-alternatives --auto go
$ sudo update-alternatives --auto gofmt
$ go version
go version go1.21.5 linux/amd64

# standalone pacakge
$ mkdir -p /opt/go
$ curl -fsSL https://dl.google.com/go/go1.21.5.linux-amd64.tar.gz | tar xzf - -C /opt/go

$ cat >> ~/.bashrc << EOF
export GOPATH=/opt/go
export PATH=$GOPATH/bin:$PATH
EOF
```

## node && npm
```bash
# snap
$ sudo snap install node --classic --channel=15
# upgrade version to 20.x
$ sudo snap refresh --channel=20 node
node (20/stable) 20.8.0 from OpenJS Foundation (iojs✓) refreshed
```

### [nodesource/distributions](https://github.com/nodesource/distributions)
#### [nodejs for ubuntu/debian](https://deb.nodesource.com/)
```bash
# via apt
$ sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg
$ curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
$ NODE_MAJOR=20
$ echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
$ sudo apt-get update && sudo apt-get install nodejs -y

# via script
$ curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
```

#### [nodejs for centos/rhel](https://rpm.nodesource.com/)
```bash
# via rpm
$ sudo yum install https://rpm.nodesource.com/pub_20.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
$ sudo yum install nsolid -y

# via script
$ curl -fsSL https://rpm.nodesource.com/setup_21.x | sudo bash -
$ yum install -y nodejs
```

### node/npm troubleshooting

> [!NOTE]
> - [Don’t use `sudo` with `npm`](https://medium.com/@ExplosionPills/dont-use-sudo-with-npm-5711d2726aa3)
> - [issue with `sudo npm install -g`](https://stackoverflow.com/a/18414606)
> - [How to fix npm throwing error without sudo](https://stackoverflow.com/a/18414606)
>   ```bash
>   $ npm config get prefix
>   /usr/local
>   ```

```bash
$ sudo chown -R $USER /usr/local/lib/node_modules
$ npm install -g ..

# or
$ export NPM_CONFIG_PREFIX="$HOME/.npm"
$ npm config set prefix "$NPM_CONFIG_PREFIX"
$ export PATH="$PATH:$NPM_CONFIG_PREFIX/bin"
$ npm install -g ..

# or
$ sudo groupadd nodegrp
$ sudo usermode -aG nodegrp `logname`
# without re-login
$ newgrp nodegrp
$ sudo chgrp -R nodegrp /usr/lib/node_modules
$ sudo chgrp nodegrp /usr/bin/node
$ sudo chgrp nodegrp /usr/bin/npm
$ npm instal -g ...
```

### install from private registry
```bash
$ npm config set registry https://artifactory.sample.com/artifactory/api/npm/npm-remote/
$ sudo mkdir -p /usr/local/n && sudo chwon -R $(whoami) /usr/local/n
$ sudo n latest
$ npm i -g npm-completion --verbose
```

### upgrade via `n`
```bash
# upgrade nodejs
$ node --version
v12.22.5
$ sudo npm i -g n
$ sudo mkdir -p /usr/local/n && sudo chown -R $(whoami) /usr/local/n
$ sudo n latest
$ which -a node
/usr/local/bin/node
/usr/bin/node
$ node --version
v20.8.1
$ /usr/bin/node --version
v12.22.5
```

## gradle

> [!NOTE]
> - [Installing Gradle](https://docs.gradle.org/current/userguide/installation.html#ex-installing-manually)
> - [Gradle Installing manually](https://gradle.org/install/#manually)
> - [ubuntu gradle ppa](https://launchpad.net/~cwchien/+archive/ubuntu/gradle)

```bash
# snap
$ sudo snap install gradle --classic

# standalone package
$ curl -O https://services.gradle.org/distributions/gradle-7.6.1-bin.zip    # download somewhere and sync to server
$ unzip gradle-7.6.1-bin.zip -d /opt/gradle
$ ln -sf /opt/gradle/gradle-7.6.1 /opt/gradle/latest
$ sudo update-alternatives --install /usr/local/bin/gradle gradle /opt/gradle/latest/bin/gradle 99
$ sudo update-alternatives --auto gradle

# ubuntu
$ sudo add-apt-repository ppa:cwchien/gradle
$ sudo apt-get update
$ sudo apt upgrade gradle
```

## rust
```bash
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## haskell

> [!NOTE|label:references:]
> - [#506 - Failed to build hadolint locally on Ubuntu 20.04.](https://github.com/hadolint/hadolint/issues/506)
> - [haskell stack install and upgrade](https://docs.haskellstack.org/en/stable/install_and_upgrade/#using-an-http-proxy)

### haskell-platform
```bash
$ sudo apt install -y haskell-platform
```

### haskell-stack
```bash
$ curl -sSL https://get.haskellstack.org/ | sh
# or
$ wget -qO- https://get.haskellstack.org/ | sh
# or
$ sudo apt install -y haskell-stack
```

- system dependency
  ```bash
  # ubuntu/debian
  $ sudo apt-get install g++ gcc libc6-dev libffi-dev libgmp-dev make xz-utils zlib1g-dev git gnupg netbase
  # centos/fedora
  $ sudo dnf install perl make automake gcc gmp-devel libffi zlib zlib-devel xz tar git gnupg
  ```

## hadolint
```bash
# linux
$ curl -o /usr/bin/hadolint \
       -fsSL https://github.com/hadolint/hadolint/releases/download/v2.12.1-beta/hadolint-Linux-x86_64
$ chmod +x /usr/bin/hadolint
```

## mysql
### built from source code
* build
  ```bash
  $ sudo groupadd mysql
  $ sudo useradd -g mysql mysql
  $ wget http://cdn.mysql.com/archives/mysql-5.5/mysql-5.5.41.tar.gz
  $ apt install ncurses-dev

  $ cd myaql-5.5.41
  $ cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
  -DDEFAULT_CHARSET=utf8 \
  -DDEFAULT_COLLATION=utf8_general_ci \
  -DENABLED_LOCAL_INFILE=ON \
  -DWITH_INNOBASE_STORAGE_ENGINE=1 \
  -DWITH_FEDERATED_STORAGE_ENGINE=1 \
  -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
  -DMYSQL_UNIX_ADDR=/tmp/mysqld.sock \
  -DWITH_DEBUG=0 \
  -DMYSQL_TCP_PORT=3306
  $ make
  $ sudo make install

  $ sudo systemctl enable mysqld
  # or
  $ sysv-rc-conf mysqld on
  ```

* configure
  ```bash
  $ sudo chown -R mysql:mysql /usr/local/mysql
  $ /usr/local/mysql/scripts/mysql_install_db --user=mysql
  $ sudo cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
  $ sudo chown -R root /usr/local/mysql/
  $ sudo chown -R mysql /usr/local/mysql/data
  $ /usr/local/mysql/bin/mysqld_safe --user=mysql &

  $ /usr/local/mysql/bin/mysqladmin -u root password '<PASSWORD>'
  # or
  $ /usr/local/mysql/bin/mysql_secure_installtion
  ```

### install from apt repo
```bash
$ sudo apt install mysql-server
```

#### install old version
```bash
$ sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'
$ sudo apt update
$ sudo apt install mysql-server-5.6 mysql-client-5.6 -y
$ sudo mysql_secure_installation
```

#### reconfiguration
```bash
$ sudo service mysql start
$ sudo mysql_secure_installation
```

## mysql-connector (jdbc)
* download `mysql-connector-java-*.tar.gz` in [mysql official website](http://dev.mysql.com/downloads/connector/j) -> _Platform Independent_
  ```bash
  $ wget http://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.40.tar.gz
  ```

## vncserver
```bash
$ sudo apt install vnc4server
$ sudo apt install gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal
```

# compiler environment
## pkg-config

```bash
$ pkg-config --cflags openssl
-I/usr/local/Cellar/openssl@3/3.2.0_1/include
$ pkg-config --variable pc_path pkg-config
/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/pkgconfig:/usr/local/Homebrew/Library/Homebrew/os/mac/pkgconfig/11.0

# list all
$ pkg-config --list-all
```

<!--sec data-title="$ pkg-config --list-all" data-id="section0" data-show=true data-collapse=true ces-->
```bash
$ pkg-config --list-all
sqlite3                          SQLite - SQL database engine
libgcrypt                        libgcrypt - General purpose cryptographic library
xcb-xevie                        XCB Xevie - XCB Xevie Extension
xcb-damage                       XCB Damage - XCB Damage Extension
pixman-1                         Pixman - The pixman library (version 1)
gmodule-export-2.0               GModule - Dynamic module loader for GLib
libevent_pthreads                libevent_pthreads - libevent_pthreads adds pthreads-based threading support to libevent
cairo-svg                        cairo-svg - SVG surface backend for cairo graphics library
recordproto                      RecordProto - Record extension headers
libmagic                         libmagic - Magic number recognition library
nettle                           Nettle - Nettle low-level cryptographic library (symmetric algorithms)
gnutls                           GnuTLS - Transport Security Layer implementation for the GNU system
fmt                              fmt - A modern formatting library
libpcreposix                     libpcreposix - PCREPosix - Posix compatible interface to libpcre
imlib2                           imlib2 - Powerful image loading and rendering library
lqr-1                            lqr-1 - LiquidRescale seam-carving library
libglog                          libglog - Google Log (glog) C++ logging framework
jemalloc                         jemalloc - A general purpose malloc(3) implementation that emphasizes fragmentation avoidance and scalable concurrency support.
lua-5.4                          Lua - An Extensible Extension Language
cairo-tee                        cairo-tee - Tee surface backend for cairo graphics library
applewmproto                     AppleWMProto - AppleWM extension headers
xcb-render                       XCB Render - XCB Render Extension
ImageMagick-7.Q16HDRI            ImageMagick - ImageMagick - convert, edit, and compose images (ABI Q16HDRI)
xwaylandproto                    XwaylandProto - Xwayland extension headers
libjq                            libjq - Library to process JSON using a query language
libpcre2-16                      libpcre2-16 - PCRE2 - Perl compatible regular expressions C library (2nd API) with 16 bit character support
dri3proto                        DRI3Proto - DRI3 extension headers
libfolly                         libfolly - Facebook (Folly) C++ library
dpmsproto                        DPMSProto - DPMS extension headers
libjxl_threads                   libjxl_threads - JPEG XL multi-thread runner using std::threads.
cairo-png                        cairo-png - PNG functions for cairo graphics library
libcurl                          libcurl - Library to transfer files with ftp, http, etc.
gflags                           gflags - A commandline flags library that allows for distributed flags.
xcmiscproto                      XCMiscProto - XCMisc extension headers
libidn                           Libidn - IETF stringprep, nameprep, punycode, IDNA text processing.
libxslt                          libxslt - XSLT library version 2.
yaml-0.1                         LibYAML - Library to parse and emit YAML
python3-embed                    Python - Embed Python into an application
xf86vidmodeproto                 XF86VidModeProto - XF86VidMode extension headers
python-3.10-embed                Python - Embed Python into an application
xbuild12                         XBuild 12.0 - XBuild/MSBuild 12.0
caca                             caca - Colour ASCII-Art library
damageproto                      DamageProto - Damage extension headers
libraw_r                         libraw - Raw image decoder library (thread-safe)
mono-options                     Mono.Options - Command Line Parsing Library
odbccr                           odbccr (unixODBC) - unixODBC Cursor Library
videoproto                       VideoProto - Video extension headers
cairo-xlib                       cairo-xlib - Xlib surface backend for cairo graphics library
xcb-xvmc                         XCB XvMC - XCB XvMC Extension
gnutls-dane                      GnuTLS-DANE - DANE security library for the GNU system
kbproto                          KBProto - KB extension headers
expat                            expat - expat XML parser
gmp                              GNU MP - GNU Multiple Precision Arithmetic Library
xf86dgaproto                     XF86DGAProto - XF86DGA extension headers
libpcre2-8                       libpcre2-8 - PCRE2 - Perl compatible regular expressions C library (2nd API) with 8 bit character support
libraw                           libraw - Raw image decoder library (non-thread-safe)
uuid                             uuid - Universally unique id library
xcb-dri2                         XCB DRI2 - XCB DRI2 Extension
xcb-dri3                         XCB DRI3 - XCB DRI3 Extension
libpcre2-32                      libpcre2-32 - PCRE2 - Perl compatible regular expressions C library (2nd API) with 32 bit character support
randrproto                       RandrProto - Randr extension headers
apr-util-1                       APR Utils - Companion library for APR
libhwy                           libhwy - Efficient and performance-portable SIMD wrapper
Magick++                         Magick++ - Magick++ - C++ API for ImageMagick (ABI Q16HDRI)
MagickWand-7.Q16HDRI             MagickWand - MagickWand - C API for ImageMagick (ABI Q16HDRI)
libjxl_cms                       libjxl_cms - CMS support library for libjxl
x265                             x265 - H.265/HEVC video encoder
scrnsaverproto                   ScrnSaverProto - ScrnSaver extension headers
MagickCore-7.Q16HDRI             MagickCore - MagickCore - C API for ImageMagick (ABI Q16HDRI)
libtasn1                         libtasn1 - Library for ASN.1 and DER manipulation
dri2proto                        DRI2Proto - DRI2 extension headers
OpenEXR                          OpenEXR - OpenEXR image library
harfbuzz-cairo                   harfbuzz-cairo - HarfBuzz cairo support
system.web.mvc                   System.Web.Mvc - System.Web.Mvc - ASP.NET MVC
dotnet                           Standard libraries in a .NET setup - References all the standard .NET libraries for compilation
cairo-ps                         cairo-ps - PostScript surface backend for cairo graphics library
libheif                          libheif - HEIF image codec.
p11-kit-1                        p11-kit - Library and proxy module for properly loading and sharing PKCS
fixesproto                       FixesProto - X Fixes extension headers
gpg-error                        gpg-error - GPG Runtime
libcares                         c-ares - asynchronous DNS lookup library
python-3.11-embed                Python - Embed Python into an application
python3                          Python - Build a C extension for Python
xcb-dpms                         XCB DPMS - XCB DPMS Extension
gmodule-2.0                      GModule - Dynamic module loader for GLib
ImageMagick                      ImageMagick - ImageMagick - convert, edit, and compose images (ABI Q16HDRI)
reactive                         Reactive Extensions - Reactive Extensions
libvmaf                          libvmaf - VMAF, Video Multimethod Assessment Fusion
libargon2                        libargon2 - Development libraries for libargon2
libutf8proc                      libutf8proc - UTF8 processing
libturbojpeg                     libturbojpeg - A SIMD-accelerated JPEG codec that provides the TurboJPEG API
xcb-xinput                       XCB XInput - XCB XInput Extension (EXPERIMENTAL)
Magick++-7.Q16HDRI               Magick++ - Magick++ - C++ API for ImageMagick (ABI Q16HDRI)
Imath                            Imath - Imath library: vector/matrix and math operations, plus the half type.
xcb-dbe                          XCB Dbe - XCB Double Buffer Extension
lua                              Lua - An Extensible Extension Language
xcb-xtest                        XCB XTEST - XCB XTEST Extension
libsodium                        libsodium - A modern and easy-to-use crypto library
libedit                          libedit - command line editor library provides generic line editing, history, and tokenization functions.
xcb-ge                           XCB GenericEvent - XCB GenericEvent Extension
fontsproto                       FontsProto - Fonts extension headers
xineramaproto                    XineramaProto - Xinerama extension headers
guile-3.0                        GNU Guile - GNU's Ubiquitous Intelligent Language for Extension
compositeproto                   CompositeExt - Composite extension headers
xf86bigfontproto                 XF86BigFontProto - XF86BigFont extension headers
aspnetwebstack                   AspNetWebStack - References Microsoft ASP.NET Web Stack
xcb-xselinux                     XCB SELinux - XCB SELinux Extension
libpcre                          libpcre - PCRE - Perl compatible regular expressions C library with 8 bit character support
ksba                             ksba - X.509 and CMS support library
libpcre16                        libpcre16 - PCRE - Perl compatible regular expressions C library with 16 bit character support
cairo-xcb-shm                    cairo-xcb-shm - XCB/SHM functions for cairo graphics library
libavif                          libavif - Library for encoding and decoding .avif files
glproto                          GLProto - GL extension headers
cairo-pdf                        cairo-pdf - PDF surface backend for cairo graphics library
libevent_openssl                 libevent_openssl - libevent_openssl adds openssl-based TLS support to libevent
lcms2                            lcms2 - LCMS Color Management Library
dmxproto                         DMXProto - DMX extension headers
xcb-glx                          XCB GLX - XCB GLX Extension
aom                              aom - Alliance for Open Media AV1 codec library v3.8.0.
python-3.12-embed                Python - Embed Python into an application
libusb-1.0                       libusb-1.0 - C API for USB device access from Linux, Mac OS X, Windows, OpenBSD/NetBSD and Solaris userspace
gthread-2.0                      GThread - Thread support for GLib
x11-xcb                          X11 XCB - X Library XCB interface
xf86driproto                     XF86DRIProto - XF86DRI extension headers
libssl                           OpenSSL-libssl - Secure Sockets Layer and cryptography libraries
libpcrecpp                       libpcrecpp - PCRECPP - C++ wrapper for PCRE
cairo-xcb                        cairo-xcb - XCB surface backend for cairo graphics library
xcb-screensaver                  XCB Screensaver - XCB Screensaver Extension
lua5.4                           Lua - An Extensible Extension Language
xcb-composite                    XCB Composite - XCB Composite Extension
odbcinst                         odbcinst (unixODBC) - unixODBC Configuration Library
cairo-quartz-image               cairo-quartz-image - Quartz Image surface backend for cairo graphics library
mpfr                             mpfr - C library for multiple-precision floating-point computations
MagickWand                       MagickWand - MagickWand - C API for ImageMagick (ABI Q16HDRI)
libxml-2.0                       libXML - libXML library version2.
harfbuzz-subset                  harfbuzz-subset - HarfBuzz font subsetter
apr-1                            APR - The Apache Portable Runtime library
xcb-xv                           XCB Xv - XCB Xv Extension
xextproto                        XExtProto - XExt extension headers
cairo-gobject                    cairo-gobject - cairo-gobject for cairo graphics library
dotnet35                         Standard libraries in a .NET setup - References all the standard .NET libraries for compilation (.NET Framework 3.5 compatibility)
gmodule-no-export-2.0            GModule - Dynamic module loader for GLib
libde265                         libde265 - H.265/HEVC video decoder.
libbrotlienc                     libbrotlienc - Brotli encoder library
libcrypto                        OpenSSL-libcrypto - OpenSSL cryptography library
bdw-gc                           Boehm-Demers-Weiser Conservative Garbage Collector - A garbage collector for C and C++
x11                              X11 - X Library
xcb-res                          XCB Res - XCB X-Resource Extension
system.web.extensions.design_1.0 System.Web.Extensions.Design - System.Web.Extensions.Design ASP.NET 2.0 add-on
bigreqsproto                     BigReqsProto - BigReqs extension headers
jasper                           JasPer - Image Processing/Coding Tool Kit with JPEG-2000 Support
libpcre32                        libpcre32 - PCRE - Perl compatible regular expressions C library with 32 bit character support
libjxl                           libjxl - Loads and saves JPEG XL files
libevent                         libevent - libevent is an asynchronous notification event loop library
libopenjp2                       openjp2 - JPEG2000 library (Part 1 and 2)
gsl                              GSL - GNU Scientific Library
cairo-quartz-font                cairo-quartz-font - Quartz font backend for cairo graphics library
hogweed                          Hogweed - Nettle low-level cryptographic library (public-key algorithms)
resourceproto                    ResourceProto - Resource extension headers
libexslt                         libexslt - EXSLT Extension library
libassuan                        libassuan - IPC library for the GnuPG components
cecil                            Mono Internal -- Do not use. - Mono Internal Libraries -- Do not use
bash                             bash - Bash headers for bash loadable builtins
cairo-fc                         cairo-fc - Fontconfig font backend for cairo graphics library
z3                               z3 - The Z3 Theorem Prover
cairo                            cairo - Multi-platform 2D graphics library
glib-2.0                         GLib - C Utility Library
libevent_core                    libevent_core - libevent_core
tidy                             tidy - tidy - HTML syntax checker
cairo-ft                         cairo-ft - FreeType font backend for cairo graphics library
jbig2dec                         libjbig2dec - JBIG2 decoder library.
xcb-sync                         XCB Sync - XCB Sync Extension
xcb-xprint                       XCB Xprint - XCB Xprint Extension
gio-unix-2.0                     GIO unix specific APIs - unix specific headers for glib I/O library
MagickCore                       MagickCore - MagickCore - C API for ImageMagick (ABI Q16HDRI)
cairo-quartz                     cairo-quartz - Quartz surface backend for cairo graphics library
system.web.mvc2                  System.Web.Mvc2 - System.Web.Mvc - ASP.NET MVC v2
system.web.mvc3                  System.Web.Mvc3 - System.Web.Mvc - ASP.NET MVC v3
presentproto                     PresentProto - Present extension headers
xcb-xfixes                       XCB XFixes - XCB XFixes Extension
librtmp                          librtmp - RTMP implementation
libwebpdecoder                   libwebpdecoder - Library for the WebP graphics format (decode only)
python-3.10                      Python - Build a C extension for Python
python-3.11                      Python - Build a C extension for Python
monodoc                          Monodoc - Monodoc - Mono Documentation Tools
python-3.12                      Python - Build a C extension for Python
libssh2                          libssh2 - Library for SSH-based communication
libnghttp2                       libnghttp2 - HTTP/2 C library
xcb-xkb                          XCB XKB - XCB Keyboard Extension (EXPERIMENTAL)
libpng                           libpng - Loads and saves PNG files
libpcre2-posix                   libpcre2-posix - Posix compatible interface to libpcre2-8
libwebpdemux                     libwebpdemux - Library for parsing the WebP graphics format container
wcf                              WCF - References WCF for compilation
odbc                             odbc (unixODBC) - unixODBC Driver Manager library
libhwy-contrib                   libhwy-contrib - Additions to Highway: dot product, image, math, sort
lzo2                             lzo2 - LZO - a real-time data compression library
mono-2                           Mono - Mono Runtime
xcb-randr                        XCB RandR - XCB RandR Extension
IlmBase                          IlmBase - Base math and exception libraries
cairo-script-interpreter         cairo-script-interpreter - script surface backend for cairo graphics library
freetype2                        FreeType 2 - A free, high-quality, and portable font engine.
xext                             Xext - Misc X Extension Library
libjpeg                          libjpeg - A SIMD-accelerated JPEG codec that provides the libjpeg API
xcb-xf86dri                      XCB XFree86-DRI - XCB XFree86-DRI Extension
libtiff-4                        libtiff - Tag Image File Format (TIFF) library.
xau                              Xau - X authorization file management library
system.web.extensions_1.0        System.Web.Extensions - System.Web.Extensions ASP.NET 2.0 add-on
xcb-record                       XCB Record - XCB Record Extension
xcb-present                      XCB Present - XCB Present Extension
harfbuzz                         harfbuzz - HarfBuzz text shaping library
libbrotlidec                     libbrotlidec - Brotli decoder library
openssl                          OpenSSL - Secure Sockets Layer and cryptography libraries and tools
mono-cairo                       Mono.Cairo - Cairo bindings for Mono
libuv                            libuv - multi-platform support library with a focus on asynchronous I/O.
libwebpmux                       libwebpmux - Library for manipulating the WebP graphics format container
libzstd                          zstd - fast lossless compression algorithm library
libevent_extra                   libevent_extra - libevent_extra
cairo-script                     cairo-script - script surface backend for cairo graphics library
libzip                           libzip - library for handling zip archives
ncursesw                         ncursesw - ncurses 5.7 library
libffi                           libffi - Library supporting Foreign Function Interfaces
xcb-shape                        XCB Shape - XCB Shape Extension
libqrencode                      libqrencode - A QR Code encoding library
harfbuzz-icu                     harfbuzz-icu - HarfBuzz text shaping library ICU integration
pthread-stubs                    pthread stubs - Meta package for pthread symbols - defaults to heavyweight ones if the C runtime does not provide lightweight ones.
isl                              isl - isl Library
shared-mime-info                 shared-mime-info - Freedesktop common MIME database
caca++                           caca++ - Colour ASCII-Art library C++ bindings
gdlib                            gd - GD graphics library
gmpxx                            GNU MP C++ - GNU Multiple Precision Arithmetic Library (C++ bindings)
liblz4                           lz4 - extremely fast lossless compression algorithm library
xrender                          Xrender - X Render Library
inputproto                       InputProto - Input extension headers
xproto                           Xproto - Xproto headers
libgit2                          libgit2 - The git library, take 2
xcb-shm                          XCB Shm - XCB Shm Extension
monosgen-2                       Mono - Mono Runtime
oniguruma                        oniguruma - Regular expression library
libpng16                         libpng - Loads and saves PNG files
mono                             Mono - Mono Runtime
xcb                              XCB - X-protocol C Binding
graphite2                        Graphite2 - Font rendering engine for Complex Scripts
liblzma                          liblzma - General purpose data compression library
python-3.9-embed                 Python - Embed Python into an application
mono-lineeditor                  Mono.Terminal.LineEditor - Terminal text entry editor using System.Console.
libunbound                       unbound - Library with validating, recursive, and caching DNS resolver
libwebp                          libwebp - Library for the WebP graphics format
ncurses                          ncurses - ncurses 5.7 library
jansson                          Jansson - Library for encoding, decoding and manipulating JSON data
fontconfig                       Fontconfig - Font configuration and customization library
libsharpyuv                      libsharpyuv - Library for sharp RGB to YUV conversion
cairo-xlib-xrender               cairo-xlib-xrender - Xlib Xrender surface backend for cairo graphics library
harfbuzz-gobject                 harfbuzz-gobject - HarfBuzz text shaping library GObject integration
libbrotlicommon                  libbrotlicommon - Brotli common dictionary library
zlib                             zlib - zlib compression library
python-3.9                       Python - Build a C extension for Python
gobject-2.0                      GObject - GLib Type, Object, Parameter and Signal Library
libidn2                          libidn2 - Library implementing IDNA2008 and TR46
gio-2.0                          GIO - glib I/O library
xdmcp                            Xdmcp - X Display Manager Control Protocol library
xcb-xinerama                     XCB Xinerama - XCB Xinerama Extension
libiodbc                         iODBC - iODBC Driver Manager
renderproto                      RenderProto - Render extension headers
```
<!--endsec-->

## ldconfig

```bash
# rebuild ldconfig
$ sudo ldconfig

# show all
$ sudo ldconfig --print-cache
```

# auto completion

> [!NOTE|label:references:]
> - check all commands: `compgen -c`

## bash-completion

> [!TIP|label:references:]
> - [scop/bash-completion](https://github.com/scop/bash-completion) | [scop/bash-completion/bash_completion](https://github.com/scop/bash-completion/blob/main/bash_completion)
> - [debian/bash-completion/bash_completion](https://salsa.debian.org/debian/bash-completion/blob/master/bash_completion)
> - local files
>   ```bash
>   $ ls -Altrh /usr/local/etc/ | grep comp
>   lrwxr-xr-x   1 marslo admin   51 Dec 15 12:19 bash_completion -> ../Cellar/bash-completion/1.3_3/etc/bash_completion
>   drwxr-xr-x 226 marslo admin 7.1K May 21 17:39 bash_completion.d
>   ```
> - [Bash Completion](https://sourabhbajaj.com/mac-setup/BashCompletion/)
> - `brew info bash-completion`
>   ```bash
>   ==> Caveats
>   Add the following line to your ~/.bash_profile:
>     [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
>
>   Bash completion has been installed to:
>     /usr/local/etc/bash_completion.d
>   ```

```bash
# osx
HOMEBREW_PREFIX="$(brew --prefix)"
BASH_COMPLETION="$(brew --prefix bash-completion)/etc/bash_completion"       # for bash_completion 1.3_3 BASH_COMPLETION="${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
BASH_COMPLETION_DIR="$(brew --prefix)/etc/bash_completion.d"                 # BASH_COMPLETION="${HOMEBREW_PREFIX}/opt/bash-completion/etc/bash_completion"

if [[ $(command -v brew) != '' ]] && [[  -f $(brew --prefix)/etc/bash_completion ]]; then
  source $(brew --prefix)/etc/bash_completion;
fi
# or
[[ -f '/usr/local/etc/bash_completion' ]] && source /usr/local/etc/bash_completion

# debian
BASH_COMPLETION_DIR=$(pkg-config --variable=completionsdir bash-completion)
```

## bash-completion@2

> [!NOTE|label:references:]
> - `brew info bash_completion@2`
>   ```bash
>   ==> Caveats
>   Add the following line to your ~/.bash_profile:
>     [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
>
>   Bash completion has been installed to:
>     /usr/local/etc/bash_completion.d
>   ```
> - local files:
>   ```bash
>   $ ls -Altrh /usr/local/etc/bash_completion
>   lrwxr-xr-x 1 marslo admin 51 Dec 15 12:19 /usr/local/etc/bash_completion -> ../Cellar/bash-completion/1.3_3/etc/bash_completion
>   $ ls -Altrh /usr/local/etc/profile.d/bash_completion.sh
>   lrwxr-xr-x 1 marslo admin 70 May 21 16:47 /usr/local/etc/profile.d/bash_completion.sh -> ../../Cellar/bash-completion@2/2.14.0/etc/profile.d/bash_completion.sh
>   $ ls -Altrh /usr/local/Cellar/bash-completion@2/2.14.0/share/bash-completion/bash_completion
>   -rw-r--r-- 1 marslo staff 120K May 21 16:47 /usr/local/Cellar/bash-completion@2/2.14.0/share/bash-completion/bash_completion
>   ```

```bash
BASH_COMPLETION="$(brew --prefix bash-completion@2)/etc/profile.d/bash_completion.sh"
# or
BASH_COMPLETION="$(brew --prefix)/opt/bash-completion@2/etc/profile.d/bash_completion.sh"
BASH_COMPLETION_2_DIR="$(brew --prefix bash-completion@2)/share/bash-completion/completions"

test -f "${BASH_COMPLETION}" && source "${BASH_COMPLETION}"
if test -d "${BASH_COMPLETION_DIR}"; then
  source <( cat "${BASH_COMPLETION_DIR}"/{brew,tmux,tig-completion.bash} )
  if ls "${BASH_COMPLETION_DIR}"/*git*    >/dev/null 2>&1; then source <( cat "${BASH_COMPLETION_DIR}"/*git* )    ; fi
  if ls "${BASH_COMPLETION_DIR}"/*docker* >/dev/null 2>&1; then source <( cat "${BASH_COMPLETION_DIR}"/*docker* ) ; fi
fi
```

### troubleshooting for `bash-completion@2`

> [!TIP|label:references:]
> for issue:
> - `-bash: [: too many arguments`

- `vim /usr/local/etc/bash_completion.d/gcc`
- `vim /usr/local/etc/bash_completion.d/ifupdown`
- `vim /usr/local/etc/bash_completion.d/ipsec`
- `vim /usr/local/etc/bash_completion.d/kldload`
- `vim /usr/local/etc/bash_completion.d/man`
- `vim /usr/local/etc/bash_completion.d/net-tools`
- `vim /usr/local/etc/bash_completion.d/pkg_install`
- `vim /usr/local/etc/bash_completion.d/procps`
- `vim /usr/local/etc/bash_completion.d/wireless-tools`

to modify:
```bash
[ ... = ...  ] to [[ ... = ... ]]

# and
[ ... = ... -o ... = ... ] to [[ ... = ... || ... = ... ]]
```

## tools
### fzf
```bash
if test -f "$HOME"/.fzf.bash; then
  source "$HOME"/.fzf.bash
else
  [[ '1' = "$(isOSX)" ]] && FZF_HOME="$(brew --prefix fzf)" || FZF_HOME="${iRCHOME}"/utils/fzf
  command -v fzf >/dev/null                     && eval "$(fzf --bash)"
  test -f "${FZF_HOME}/shell/key-bindings.bash" && source "${FZF_HOME}/shell/key-bindings.bash"
fi

## or `fzf --bash` can be also:
[[ $- == *i* ]] && test -f "${FZF_HOME}/shell/completion.bash" && source "${FZF_HOME}/shell/completion.bash" 2> /dev/null
```

### npm

> [!NOTE|label:references:]
> - [npm-completion](https://docs.npmjs.com/cli/v7/commands/npm-completion)

```bash
command -v npm >/dev/null && source <( npm completion )
# or
NPM_COMPLETION_PATH="/usr/local/lib/node_modules/npm-completion"               # https://github.com/Jephuff/npm-bash-completion
```

### python
- pipenv
  ```bash
  # $(brew --prefix bash-completion@2)/share/bash-completion/completions/_pipenv
  $ brew install bash-completion@2

  # or
  $ command -v pipenv >/dev/null && eval "$(pipenv --completion)"
  ```

- pipx
  ```bash
  $ command -v pipx    >/dev/null && eval "$(register-python-argcomplete pipx)"
  ```

- pip
  ```bash
  $ command -v pip     >/dev/null && eval "$(pip completion --bash)"
  ```

### ansible
```bash
ANSIBLE_COMPLETION_PATH="${iRCHOME}/.completion/ansible-completion"            # https://github.com/dysosmus/ansible-completion
test -d "${ANSIBLE_COMPLETION_PATH}" && source <( cat "${ANSIBLE_COMPLETION_PATH}"/*.bash )
```

### git
```bash
if ls "${BASH_COMPLETION_DIR}"/*git* >/dev/null 2>&1; then source <( cat "${BASH_COMPLETION_DIR}"/*git* )    ; fi
# or
ls "${BASH_COMPLETION_DIR}"/*git* >/dev/null 2>&1; [ $? -eq 0 ] && source "${BASH_COMPLETION_DIR}"/*git*

# or
GIT_COMPLETION_DIR="$(brew --prefix)"/opt/git/etc/bash_completion.d
# or
GIT_COMPLETION_DIR="$(brew --prefix git)"/etc/bash_completion.d
[[ -d "${GIT_COMPLETION_DIR}" ]] && source "${GIT_COMPLETION_DIR}/*git*"

# or
source $(brew --prefix git)/etc/bash_completion.d/git-prompt.sh
source $(brew --prefix git)/etc/bash_completion.d/git-completion.bash
```

### [vault CLI](https://developer.hashicorp.com/vault/docs/commands#autocompletion)
```bash
$ vault -autocomplete-install
$ vault -autocomplete-install
Error executing CLI: 3 errors occurred:
  * already installed in /Users/marslo/.bash_profile
  * already installed in /Users/marslo/.zshrc
  * already installed at /Users/marslo/.config/fish/completions/vault.fish

# or
command -v vault >/dev/null && complete -C /usr/local/bin/vault vault
```

### others
```bash
ADDITIONAL_COMPLETION="${iRCHOME}/.completion/bash_completion_init_completion" # workaround: https://github.com/mobile-shell/mosh/issues/675#issuecomment-156457108
MACCLI_COMPLETION='/usr/local/bin/mac-cli/completion/bash_completion'
VBOX_COMPLETION="${iRCHOME}/.completion/vbox/VBoxManage-completion.bash"       # ╮ https://github.com/gryf/vboxmanage-bash-completion
                                                                               # ╯ https://github.com/mug896/virtualbox-bash-completion
test -f "${ADDITIONAL_COMPLETION}"  && source "${ADDITIONAL_COMPLETION}"
test -f "${MACCLI_COMPLETION}"      && source "${MACCLI_COMPLETION}"
test -f "${VBOX_COMPLETION}"        && source "${VBOX_COMPLETION}"
```

## script
### groovy
```bash
GROOVY_HOME="$(brew --prefix groovy)"

test -d "${GROOVY_HOME}/bin" && source <( cat "${GROOVY_HOME}"/bin/*_completion )
# or
find "${GROOVY_HOME}/bin" -name '*_completion' -print0 | xargs -0 -I FILE bash -c "source FILE"
```

# troubleshooting
## issues
- `macOS 14.1 on arm64 using ruby-build 20231107`

  > [!NOTE]
  > - [#2309 Build failures on macOS Sonoma 14.1](https://github.com/rbenv/ruby-build/discussions/2309)
  > - [#2178 BUILD FAILED (macOS 13.2.1 using ruby-build 20230330)](https://github.com/rbenv/ruby-build/discussions/2178)


- `"ld: multiple errors: archive member '/' not a mach-o file"`

  > [!NOTE]
  > - [iMarslo : build git from source](../devops/git/config.html#ld-archive-member--not-a-mach-o-file)
  > - [Clang archive or linking issue. Xcode 15.0.1](https://developer.apple.com/forums/thread/741149)
  > - [build and install git from source on macOS Sonama 14.x: "ld: multiple errors: archive member '/' not a mach-o file"](https://stackoverflow.com/q/77626259/2940319)

## cheatsheet
### [to use the bundled libc++ please add the following LDFLAGS](https://formulae.brew.sh/formula/llvm)
```bash
LDFLAGS="-L$HOMEBREW_PREFIX/opt/llvm/lib/c++ -Wl,-rpath,$HOMEBREW_PREFIX/opt/llvm/lib/c++"
```

### check osx compilers
```bash
$ while read -r _compiler; do
  echo -e '\n';
  which -a "${_compiler}";
  "${_compiler}" --version;
done < <(echo 'cc c++ gcc g++ clang clang++' | fmt -1)

/usr/bin/cc
Apple clang version 15.0.0 (clang-1500.1.0.2.5)
Target: x86_64-apple-darwin23.2.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

/usr/bin/c++
Apple clang version 15.0.0 (clang-1500.1.0.2.5)
Target: x86_64-apple-darwin23.2.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

/usr/bin/gcc
Apple clang version 15.0.0 (clang-1500.1.0.2.5)
Target: x86_64-apple-darwin23.2.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

/usr/bin/g++
Apple clang version 15.0.0 (clang-1500.1.0.2.5)
Target: x86_64-apple-darwin23.2.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

/usr/bin/clang
Apple clang version 15.0.0 (clang-1500.1.0.2.5)
Target: x86_64-apple-darwin23.2.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

/usr/bin/clang++
Apple clang version 15.0.0 (clang-1500.1.0.2.5)
Target: x86_64-apple-darwin23.2.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
```

### check *.o file

<!--sec data-title="objdump" data-id="section1" data-show=true data-collapse=true ces-->
```bash
$ objdump -d ar-test1.o
ar-test1.o:     file format mach-o-x86-64

Disassembly of section .text:

0000000000000000 <_ar_test1>:
   0: 55                    push   %rbp
   1: 48 89 e5              mov    %rsp,%rbp
   4: 48 8d 3d 09 00 00 00  lea    0x9(%rip),%rdi        # 14 <_ar_test1+0x14>
   b: b0 00                 mov    $0x0,%al
   d: e8 00 00 00 00        call   12 <_ar_test1+0x12>
  12: 5d                    pop    %rbp
  13: c3                    ret
```
<!--endsec-->

<!--sec data-title="execsnoop" data-id="section2" data-show=true data-collapse=true ces-->
```bash
$ sudo execsnoop -a -c ar-test1.o
dtrace: system integrity protection is on, some features will not be available

dtrace: invalid probe specifier
 /*
  * Command line arguments
  */
 inline int OPT_dump  = 0;
 inline int OPT_cmd   = 1;
 inline int OPT_time  = 1;
 inline int OPT_timestr = 1;
 inline int OPT_zone  = 0;
 inline int OPT_safe  = 0;
 inline int OPT_proj  = 1;
 inline int FILTER  = 1;
 inline string COMMAND  = "ar-test1.o";

 #pragma D option quiet
 #pragma D option switchrate=10hz

 /*
  * Print header
  */
 dtrace:::BEGIN
 {
  /* print optional headers */
  OPT_time    ? printf("%-14s ", "TIME") : 1;
  OPT_timestr ? printf("%-20s ", "STRTIME") : 1;
  OPT_zone    ? printf("%-10s ", "ZONE") : 1;
  OPT_proj    ? printf("%5s ", "PROJ") : 1;

  /* print main headers */
  /* APPLE: Removed "ZONE" header, it has no meaning in darwin */
  OPT_dump    ? printf("%s %s %s %s %s %s %s\n",
      "TIME", "PROJ", "UID", "PID", "PPID", "COMM", "ARGS") :
      printf("%5s %6s %6s %s\n", "UID", "PID", "PPID", "ARGS");
 }

 /*
  * Print exec event
  */
 /* SOLARIS: syscall::exec:return, syscall::exece:return */
proc:::exec-success
 /(FILTER == 0) || (OPT_cmd == 1 && COMMAND == strstr(COMMAND, execname)) || (OPT_cmd == 1 && execname == strstr(execname, COMMAND))/
 {
  /* print optional fields */
  OPT_time ? printf("%-14d ", timestamp/1000) : 1;
  OPT_timestr ? printf("%-20Y ", walltimestamp) : 1;
  OPT_zone ? printf("%-10s ", zonename) : 1;
  OPT_proj ? printf("%5d ", curpsinfo->pr_projid) : 1;

  /* print main data */
  /* APPLE: Removed the zonename output, it has no meaning in darwin */
  OPT_dump ? printf("%d %d %d %d %d %s ", timestamp/1000,
      curpsinfo->pr_projid, uid, pid, ppid, execname) :
      printf("%5d %6d %6d ", uid, pid, ppid);
  OPT_safe ? printf("%S\n", curpsinfo->pr_psargs) :
      printf("%s\n", curpsinfo->pr_psargs);
 }
: probe description proc:::exec-success does not match any probes. System Integrity Protection is on
```
<!--endsec-->

# env

## manpath

> [!NOTE|label:references:]
> - [macOS Terminal not using correct manpath](https://apple.stackexchange.com/q/376901/254265)
> - [`apropos` Linux Command Explained {with Examples}](https://phoenixnap.com/kb/apropos-linux)

- show manpath
  ```bash
  $ man -aw bash
  /usr/local/share/man/man1/bash.1
  /usr/share/man/man1/bash.1
  /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/share/man/man1/bash.1

  $ manpath | tr ':' '\n'
  # or
  $ manpath | perl -nE 's/:/\n/g; print'
  /Users/marslo/perl5/man
  /Users/marslo/.local/share/man
  /usr/local/Cellar/icu4c@71.1/71.1/share/man
  /usr/local/vim/share/man
  /Applications/MacVim.app/Contents/man
  /usr/local/opt/llvm/share/man
  /usr/local/opt/util-linux/share/man
  /usr/local/opt/gnu-getopt/share/man
  /usr/local/opt/binutils/share/man
  /usr/local/opt/ruby/share/man
  /usr/local/opt/tcl-tk/share/man
  /usr/local/Cellar/node/21.1.0/share/man
  /usr/local/Cellar/openjdk/21.0.2/libexec/openjdk.jdk/Contents/Home/man
  /usr/local/opt/ed/share/man
  /usr/local/opt/git-extras/share/man
  /usr/local/opt/gettext/share/man
  /usr/local/opt/file-formula/share/man
  /usr/local/opt/openldap/share/man
  /usr/local/opt/curl/share/man
  /usr/local/opt/openssl/share/man
  /usr/local/opt/libiconv/share/man
  /usr/local/opt/sqlite/share/man
  /usr/local/share/man
  /usr/local/man
  /usr/share/man
  /Library/Apple/usr/share/man
  /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/share/man
  /Applications/Xcode.app/Contents/Developer/usr/share/man
  /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/man
  ```

- config file
  ```bash
  $ cat /private/etc/man.conf | sed -r '/^(#.*)$/d;/^\s*$/d'
  MANPATH   /usr/share/man
  MANPATH   /usr/local/share/man
  MANPATH   /usr/X11/man
  MANPATH   /Library/Apple/usr/share/man
  MANSECT   1:1p:8:2:3:3p:4:5:6:7:9:0p:tcl:n:l:p:o

  $ cat /etc/man.conf | sed -r '/^(#.*)$/d;/^\s*$/d'
  MANPATH   /usr/share/man
  MANPATH   /usr/local/share/man
  MANPATH   /usr/X11/man
  MANPATH   /Library/Apple/usr/share/man
  MANSECT   1:1p:8:2:3:3p:4:5:6:7:9:0p:tcl:n:l:p:o

  $ cat /etc/manpaths
  /usr/share/man
  /usr/local/share/man
  ```

- manpath
  ```bash
  $ manpath -d
  -- Searching PATH for man directories
  --   Adding /Users/marslo/perl5/man to manpath
  --   Adding /Users/marslo/.local/share/man to manpath
  --   Adding /usr/local/Cellar/icu4c@71.1/71.1/share/man to manpath
  --   Adding /usr/local/vim/share/man to manpath
  --   Adding /Applications/MacVim.app/Contents/man to manpath
  --   Adding /usr/local/opt/llvm/share/man to manpath
  --   Adding /usr/local/opt/util-linux/share/man to manpath
  --   Adding /usr/local/opt/gnu-getopt/share/man to manpath
  --   Adding /usr/local/opt/binutils/share/man to manpath
  --   Adding /usr/local/opt/ruby/share/man to manpath
  --   Adding /usr/local/opt/tcl-tk/share/man to manpath
  --   Adding /usr/local/Cellar/node/21.1.0/share/man to manpath
  --   Adding /usr/local/Cellar/openjdk/21.0.2/libexec/openjdk.jdk/Contents/Home/man to manpath
  --   Adding /usr/local/opt/ed/share/man to manpath
  --   Adding /usr/local/opt/git-extras/share/man to manpath
  --   Adding /usr/local/opt/gettext/share/man to manpath
  --   Adding /usr/local/opt/file-formula/share/man to manpath
  --   Adding /usr/local/opt/openldap/share/man to manpath
  --   Adding /usr/local/opt/curl/share/man to manpath
  --   Adding /usr/local/opt/openssl/share/man to manpath
  --   Adding /usr/local/opt/libiconv/share/man to manpath
  --   Adding /usr/local/opt/sqlite/share/man to manpath
  --   Adding /usr/local/share/man to manpath
  --   Adding /usr/local/man to manpath
  --   Adding /usr/share/man to manpath
  --   Adding /Library/Apple/usr/share/man to manpath
  --   Adding /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/share/man to manpath
  --   Adding /Applications/Xcode.app/Contents/Developer/usr/share/man to manpath
  --   Adding /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/man to manpath
  -- Adding default manpath entries
  -- Parsing config file: /etc/man.conf
  -- Using manual path: /Users/marslo/perl5/man:/Users/marslo/.local/share/man:/usr/local/Cellar/icu4c@71.1/71.1/share/man:/usr/local/vim/share/man:/Applications/MacVim.app/Contents/man:/usr/local/opt/llvm/share/man:/usr/local/opt/util-linux/share/man:/usr/local/opt/gnu-getopt/share/man:/usr/local/opt/binutils/share/man:/usr/local/opt/ruby/share/man:/usr/local/opt/tcl-tk/share/man:/usr/local/Cellar/node/21.1.0/share/man:/usr/local/Cellar/openjdk/21.0.2/libexec/openjdk.jdk/Contents/Home/man:/usr/local/opt/ed/share/man:/usr/local/opt/git-extras/share/man:/usr/local/opt/gettext/share/man:/usr/local/opt/file-formula/share/man:/usr/local/opt/openldap/share/man:/usr/local/opt/curl/share/man:/usr/local/opt/openssl/share/man:/usr/local/opt/libiconv/share/man:/usr/local/opt/sqlite/share/man:/usr/local/share/man:/usr/local/man:/usr/share/man:/Library/Apple/usr/share/man:/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/share/man:/Applications/Xcode.app/Contents/Developer/usr/share/man:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/man
  /Users/marslo/perl5/man:/Users/marslo/.local/share/man:/usr/local/Cellar/icu4c@71.1/71.1/share/man:/usr/local/vim/share/man:/Applications/MacVim.app/Contents/man:/usr/local/opt/llvm/share/man:/usr/local/opt/util-linux/share/man:/usr/local/opt/gnu-getopt/share/man:/usr/local/opt/binutils/share/man:/usr/local/opt/ruby/share/man:/usr/local/opt/tcl-tk/share/man:/usr/local/Cellar/node/21.1.0/share/man:/usr/local/Cellar/openjdk/21.0.2/libexec/openjdk.jdk/Contents/Home/man:/usr/local/opt/ed/share/man:/usr/local/opt/git-extras/share/man:/usr/local/opt/gettext/share/man:/usr/local/opt/file-formula/share/man:/usr/local/opt/openldap/share/man:/usr/local/opt/curl/share/man:/usr/local/opt/openssl/share/man:/usr/local/opt/libiconv/share/man:/usr/local/opt/sqlite/share/man:/usr/local/share/man:/usr/local/man:/usr/share/man:/Library/Apple/usr/share/man:/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/share/man:/Applications/Xcode.app/Contents/Developer/usr/share/man:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/man
  ```

# others

> [!NOTE|label:references:]
> - [Integralist/New Laptop Configuration. Summary.md](https://gist.github.com/Integralist/05e5415de6743e66b112574a1a5c1970)

## [GitHubDaily/GitHubDaily](https://github.com/GitHubDaily/GitHubDaily)
- [Stirling-Tools/Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF)
- [xitanggg/open-resume](https://github.com/xitanggg/open-resume)
