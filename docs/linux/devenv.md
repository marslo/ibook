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
    - [groovy completions](#groovy-completions)
  - [gcc](#gcc)
  - [info-zip](#info-zip)
    - [brew install](#brew-install)
    - [build from source](#build-from-source)
  - [glibc](#glibc)
    - [glibc troubleshooting](#glibc-troubleshooting)
  - [lua](#lua)
  - [ruby](#ruby)
  - [mono](#mono)
  - [cmake](#cmake)
  - [llvm](#llvm)
  - [clang++ in windows](#clang-in-windows)
  - [go](#go)
  - [node && npm](#node--npm)
    - [config](#config)
    - [nodesource/distributions](#nodesourcedistributions)
    - [node/npm troubleshooting](#nodenpm-troubleshooting)
    - [install from private registry](#install-from-private-registry)
    - [upgrade via `n`](#upgrade-via-n)
    - [node warnings](#node-warnings)
  - [gradle](#gradle)
    - [flags for gradle](#flags-for-gradle)
  - [rust](#rust)
  - [haskell](#haskell)
    - [haskell-platform](#haskell-platform)
    - [haskell-stack](#haskell-stack)
  - [docker](#docker)
  - [jfrog-cli](#jfrog-cli)
  - [pandoc](#pandoc)
    - [to pdf](#to-pdf)
    - [to pdf with page header and footer](#to-pdf-with-page-header-and-footer)
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
    - [troubleshooting](#troubleshooting)
  - [tools](#tools)
    - [fzf](#fzf)
    - [npm](#npm)
    - [python](#python-1)
    - [ansible](#ansible)
    - [git](#git)
    - [vault CLI](#vault-cli)
    - [others](#others)
- [lint](#lint)
  - [hadolint](#hadolint)
  - [npm-groovy-lint](#npm-groovy-lint)
  - [commitlint](#commitlint)
  - [Checkpatch](#checkpatch)
- [troubleshooting](#troubleshooting-1)
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

### groovy completions
```bash
# .bash_profile
GROOVY_HOME="$(brew --prefix groovy)"

test -d "${GROOVY_HOME}/bin" && source <( cat "${GROOVY_HOME}"/bin/*_completion )
# or
find "${GROOVY_HOME}/bin" -name '*_completion' -print0 | xargs -0 -I FILE bash -c "source FILE"
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

## info-zip

> [!TIP|label:references]
> - src:
>   - [zip30.zip](ftp://ftp.info-zip.org/pub/infozip/src/zip30.zip) | [zip30.tgz](ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz)
>   - [unzip60.zip](ftp://ftp.info-zip.org/pub/infozip/src/unzip60.zip) | [unzip60.tgz](ftp://ftp.info-zip.org/pub/infozip/src/unzip60.tgz)
>   - [gzip-1_2_4.tar](ftp://ftp.info-zip.org/pub/infozip/src/gzip-1_2_4.tar)
>   - [maczip104.zip](ftp://ftp.info-zip.org/pub/infozip/src/maczip104.zip)
>   - [zcrypt29.zip](ftp://ftp.info-zip.org/pub/infozip/src/zcrypt29.zip) | [zcrypt29-exportable.tgz](ftp://ftp.info-zip.org/pub/infozip/src/zcrypt29-exportable.tgz)
> - mac:
>   - [readme](ftp://ftp.info-zip.org/pub/infozip/mac/readme)
>   - [maczip-docs.zip](ftp://ftp.info-zip.org/pub/infozip/mac/maczip-docs.zip)
>   - [zip_tools_mac_os_x_dmg.gz](ftp://ftp.info-zip.org/pub/infozip/mac/zip_tools_mac_os_x_dmg.gz)
>   - [maczip105c.hqx](ftp://ftp.info-zip.org/pub/infozip/mac/maczip105c.hqx)
>   - [maczip105nc.hqx](ftp://ftp.info-zip.org/pub/infozip/mac/maczip105nc.hqx)
> - beta:
>   - [zip31d.zip](ftp://ftp.info-zip.org/pub/infozip/beta/zip31d.zip)
>   - [zip31c.zip](ftp://ftp.info-zip.org/pub/infozip/beta/zip31c.zip)
>   - [zip31b.zip](ftp://ftp.info-zip.org/pub/infozip/beta/zip31b.zip)
>   - [zip31a.zip](ftp://ftp.info-zip.org/pub/infozip/beta/zip31a.zip)
>   - [unzip610b.zip](ftp://ftp.info-zip.org/pub/infozip/beta/unzip610b.zip)
>   - [unzip610a.zip](ftp://ftp.info-zip.org/pub/infozip/beta/unzip610a.zip)
> - references:
>   - [zipnote crashes when updating filename in a zip file](https://gitlab.alpinelinux.org/alpine/aports/-/issues/8602)

### brew install

> [!NOTE|label:references]
> - [brew formula](https://formulae.brew.sh/formula/zip)
> - [zip.rb](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/z/zip.rb)

```bash
$ brew install zip [unzip]
```

<!--sec data-title="brew install zip -v --debug" data-id="section0" data-show=true data-collapse=true ces-->
```bash
$ brew install zip -v --debug
...
==> Downloading https://ghcr.io/v2/homebrew/core/zip/manifests/3.0-2
/usr/bin/env /opt/homebrew/Library/Homebrew/shims/shared/curl --disable --cookie /dev/null --globoff --show-error --user-agent Homebrew/4.4.11-27-g9783ab0\ \(Macintosh\;\ arm64\ Mac\ OS\ X\ 14.7.2\)\ curl/8.7.1 --header Accept-Language:\ en --fail --retry 3 --header Accept:\ application/vnd.oci.image.index.v1+json --header Authorization:\ Bearer\ QQ== --remote-time --output /Users/marslo/Library/Caches/Homebrew/downloads/794b38c4c17afd41abe76b9b8dc73cabd3543bdb3816b4acca62ff0132aa1225--zip-3.0-2.bottle_manifest.json.incomplete --location https://ghcr.io/v2/homebrew/core/zip/manifests/3.0-2
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 11876  100 11876    0     0  26371      0 --:--:-- --:--:-- --:--:-- 26391
==> Fetching zip
==> Downloading https://ghcr.io/v2/homebrew/core/zip/blobs/sha256:99265457598a09b6312520471980b7b8429ebfef5be40d3e00a0980544ff12c2
/usr/bin/env /opt/homebrew/Library/Homebrew/shims/shared/curl --disable --cookie /dev/null --globoff --show-error --user-agent Homebrew/4.4.11-27-g9783ab0\ \(Macintosh\;\ arm64\ Mac\ OS\ X\ 14.7.2\)\ curl/8.7.1 --header Accept-Language:\ en --fail --retry 3 --header Authorization:\ Bearer\ QQ== --remote-time --output /Users/marslo/Library/Caches/Homebrew/downloads/ebd73b309783778b2985d2b1cec6aa2ba756923db8dd48e300e04d6587ec9ef8--zip--3.0.arm64_sonoma.bottle.2.tar.gz.incomplete --location https://ghcr.io/v2/homebrew/core/zip/blobs/sha256:99265457598a09b6312520471980b7b8429ebfef5be40d3e00a0980544ff12c2
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  307k  100  307k    0     0   407k      0 --:--:-- --:--:-- --:--:--  870k
==> Verifying checksum for 'ebd73b309783778b2985d2b1cec6aa2ba756923db8dd48e300e04d6587ec9ef8--zip--3.0.arm64_sonoma.bottle.2.tar.gz'
==> Verifying attestation for zip
/usr/bin/env GH_TOKEN=****** GH_HOST=github.com /opt/homebrew/bin/gh attestation verify /Users/marslo/Library/Caches/Homebrew/downloads/ebd73b309783778b2985d2b1cec6aa2ba756923db8dd48e300e04d6587ec9ef8--zip--3.0.arm64_sonoma.bottle.2.tar.gz --repo Homebrew/homebrew-core --format json
==> falling back on backfilled attestation for #<Bottle:0x000000016ba57a00>
/usr/bin/env GH_TOKEN=****** GH_HOST=github.com /opt/homebrew/bin/gh attestation verify /Users/marslo/Library/Caches/Homebrew/downloads/ebd73b309783778b2985d2b1cec6aa2ba756923db8dd48e300e04d6587ec9ef8--zip--3.0.arm64_sonoma.bottle.2.tar.gz --repo trailofbits/homebrew-brew-verify --format json
/opt/homebrew/Library/Homebrew/brew.rb (Formulary::FromAPILoader): loading zip
==> Pouring zip--3.0.arm64_sonoma.bottle.2.tar.gz
/usr/bin/env tar --extract --no-same-owner --file /Users/marslo/Library/Caches/Homebrew/downloads/ebd73b309783778b2985d2b1cec6aa2ba756923db8dd48e300e04d6587ec9ef8--zip--3.0.arm64_sonoma.bottle.2.tar.gz --directory /private/tmp/homebrew-unpack-20241212-61524-9jfahk
mv /private/tmp/homebrew-unpack-20241212-61524-9jfahk/zip /opt/homebrew/Cellar/zip
==> Finishing up
==> Caveats
zip is keg-only, which means it was not symlinked into /opt/homebrew,
because macOS already provides this software and installing another version in
parallel can cause all kinds of trouble.

If you need to have zip first in your PATH, run:
  echo 'export PATH="/opt/homebrew/opt/zip/bin:$PATH"' >> /Users/marslo/.bash_profile
==> Summary
🦍  /opt/homebrew/Cellar/zip/3.0: 15 files, 871.6KB
...
```
<!--endsec-->

### build from source

> [!NOTE|label:references]
> - [* build info-zip from source](https://gist.github.com/marslo/70a3f6728633c49bed865da684378b31)
> - [* how to build Info-Zip for macos](https://stackoverflow.com/a/79274638/2940319)

- zip30
  ```bash
  $ curl -fsSL ftp://ftp.info-zip.org/pub/infozip/src/zip30.zip | bsdtar xzf - -C /tmp/
  # for zipnote issue -- rename filename in zip
  $ curl -o /tmp/zipinfo.patch -fsSL https://gist.githubusercontent.com/marslo/70a3f6728633c49bed865da684378b31/raw/cf402112315ededbfb58c0e17629e9a74708e370/zipinfo.patch
  # for macOS
  $ curl -o /tmp/xcode15.patch -fsSL https://raw.githubusercontent.com/Homebrew/formula-patches/d2b59930/zip/xcode15.diff

  $ cd /tmp/zip30

  # apply patches
  $ patch -p1 < /tmp/zipinfo.patch
  $ patch -p1 < /tmp/xcode15.patch
  # or
  $ patch -u zipnote.c -i /tmp/zipinfo.patch
  $ patch -u unix/Makefile -i /tmp/xcode15.patch

  # build
  $ make -f unix/Makefile generic
  # gcc
  $ make -f unix/Makefile generic CC=gcc
  # clang
  $ make -f unix/Makefile generic CC=clang

  # install
  $ sudo make -f unix/Makefile install
  # or customized BINDIR and MANDIR
  $ sudo make -f unix/Makefile BINDIR=/tmp/bin MANDIR=/tmp/man install
  ```

- zip31d
  ```bash
  $ curl -fsSL ftp://ftp.info-zip.org/pub/infozip/beta/zip31d.zip | bsdtar xzf - -C /tmp/
  $ curl -fsSL https://gist.githubusercontent.com/marslo/70a3f6728633c49bed865da684378b31/raw/cea315f1ae855c602515b79ddf205cba71fbb2b0/xcode15-zip31d.patch -o /tmp/xcode15-zip31d.patch

  $ cd /tmp/zip31d
  $ patch -p1 < /tmp/xcode15-zip31d.patch
  # or
  $ patch -u unix/configure -i /tmp/xcode15-zip31d.patch

  # -- build --
  $ make -f unix/Makefile generic
  # gcc
  $ make -f unix/Makefile generic CC=gcc
  # clang
  $ make -f unix/Makefile generic CC=clang

  # install
  $ sudo make -f unix/Makefile install
  # or customized BINDIR and MANDIR
  $ sudo make -f unix/Makefile BINDIR=/tmp/bin MANDIR=/tmp/man install
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

## clang++ in windows

> [!NOTE|label:references:]
> - [Installing clang++ to compile and link on Windows](http://blog.johannesmp.com/2015/09/01/installing-clang-on-windows-pt1/)

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

### config
- list all configure
  ```bash
  $ npm config list -l
  # or
  $ npm info
  ```

- npm prefix
  ```bash
  export NPM_CONFIG_PREFIX="$HOME/.npm"

  # or
  $ cat ~/.npmrc
  prefix = "$HOME/.npm"
  ```

- registry

  ```bash
  $ npm --registry=https://registry.npm.taobao.org install <package-name>

  # set in config
  $ npm config set registry https://registry.npm.taobao.org
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

### node warnings

> [!NOTE|label:references:]
> - [#5253 suppress unnecessary npm WARN related to package.json fields](https://github.com/npm/npm/issues/5253)
> - [#30810 Ability to suppress warnings by type (or just experimental warnings)](https://github.com/nodejs/node/issues/30810)
> - [#10802 Cannot disable warnings when node is launched via a shell script.](https://github.com/nodejs/node/issues/10802)
> - [#47478 Ability to suppress warnings by type](https://github.com/nodejs/node/issues/47478)
> - [#50661 src: add --disable-warning option](https://github.com/nodejs/node/pull/50661)

- `ExperimentalWarning`

  > [!NOTE|label:references:]
  > - to prevent warning as below:
  >   ```bash
  >   Updating...(node:69018) Warning: Setting the NODE_TLS_REJECT_UNAUTHORIZED environment variable to '0' makes TLS connections and HTTPS requests insecure by disabling certificate verification.
  >   (Use `node --trace-warnings ...` to show where the warning was created)
  >   ```

  - [using `shebang`](https://github.com/nodejs/node/issues/30810#issuecomment-1893074931)
    ```bash
    #!/usr/bin/env node --no-warnings=ExperimentalWarning
    ```

  - [using `NODE_NO_WARNINGS`](https://github.com/nodejs/node/issues/10802#issuecomment-472691201)
    ```bash
    export NODE_NO_WARNINGS=1
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

### flags for gradle

> [!NOTE|label:references:]
> - [#5736 Wrapper 4.1-4.8 cause SSL handshake failure MacOs](https://github.com/gradle/gradle/issues/5736)
>   - `-Djavax.net.debug=ssl:handshake:verbose`
>   - `-Djavax.net.debug=ssl`
>   - `-Djavax.net.debug=all`
> - `SSLPoke`
>   - [Unable to Connect to SSL Services Due to 'PKIX Path Building Failed' Error](https://confluence.atlassian.com/kb/unable-to-connect-to-ssl-services-due-to-pkix-path-building-failed-779355358.html)
>   - [download SSLPoke.class](https://confluence.atlassian.com/kb/files/779355358/779355357/1/1441897666313/SSLPoke.class)

```bash
$ curl -fsSL -O https://confluence.atlassian.com/kb/files/779355358/779355357/1/1441897666313/SSLPoke.class

$ $JAVA_HOME/bin/java SSLPoke services.gradle.org 443
Successfully connected

$ $JAVA_HOME/bin/java -Djavax.net.debug=ssl SSLPoke services.gradle.org 443
javax.net.ssl|DEBUG|10|main|2025-02-17 21:53:53.169 PST|SSLCipher.java:432|jdk.tls.keyLimits:  entry = AES/GCM/NoPadding KeyUpdate 2^37. AES/GCM/NOPADDING:KEYUPDATE = 137438953472
javax.net.ssl|DEBUG|10|main|2025-02-17 21:53:53.176 PST|SSLCipher.java:432|jdk.tls.keyLimits:  entry =  ChaCha20-Poly1305 KeyUpdate 2^37. CHACHA20-POLY1305:KEYUPDATE = 137438953472
Successfully connected

# with `truststore`
$ $JAVA_HOME/bin/java -Djavax.net.ssl.trustStore=$JAVA_HOME/lib/security/cacerts -Djavax.net.debug=ssl SSLPoke services.gradle.org 443
javax.net.ssl|DEBUG|10|main|2025-02-17 21:55:55.826 PST|SSLCipher.java:432|jdk.tls.keyLimits:  entry = AES/GCM/NoPadding KeyUpdate 2^37. AES/GCM/NOPADDING:KEYUPDATE = 137438953472
javax.net.ssl|DEBUG|10|main|2025-02-17 21:55:55.833 PST|SSLCipher.java:432|jdk.tls.keyLimits:  entry =  ChaCha20-Poly1305 KeyUpdate 2^37. CHACHA20-POLY1305:KEYUPDATE = 137438953472
Successfully connected
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

## docker

> [!NOTE|label:references:]
> - [Install Docker Desktop on Mac](https://docs.docker.com/desktop/install/mac-install/)

```bash
# amd64
$ curl -o /tmp/Docker.dmg -fsSL -g 'https://desktop.docker.com/mac/main/arm64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-mac-arm64'

# install
$ sudo hdiutil attach Docker.dmg
$ sudo /Volumes/Docker/Docker.app/Contents/MacOS/install
$ sudo hdiutil detach /Volumes/Docker
```

## jfrog-cli

- build from source
  ```bash
  $ git clone https://github.com/jfrog/jfrog-cli.git
  $ go build -o=/opt/homebrew/Cellar/jfrog-cli/HEAD-ce298c1/bin/jf -ldflags=-s -w
  ```

## pandoc

> [!NOTE|label:references:]
> - extra themes
>   - [sindresorhus/github-markdown-css](https://github.com/sindresorhus/github-markdown-css)
>   - [simov/markdown-viewer - themes](https://github.com/simov/markdown-viewer/tree/master/themes)
>   - [cab-1729/Pandoc-Themes](https://github.com/cab-1729/Pandoc-Themes)
>   - [richleland/pygments-css](https://github.com/richleland/pygments-css)
> - [pandoc](https://github.com/jgm/pandoc)/templates
>   - [templates](https://github.com/jgm/pandoc/tree/master/data/templates)
>   - [docx](https://github.com/jgm/pandoc/tree/master/data/docx)
>   - [pptx](https://github.com/jgm/pandoc/tree/master/data/pptx)

```bash
$ brew install pandoc
# or
$ brew install pandoc --HEAD

# -- optional --
$ brew install librsvg python homebrew/cask/basictex
```

### to pdf

> [!NOTE|label:references:]
> - themes:
>   - [simov/markdown-viewer - theme](https://github.com/simov/markdown-viewer/tree/master/themes)
>   - [github.css](https://github.com/simov/markdown-viewer/blob/master/themes/github.css)
>   - [github-dark.css](https://github.com/simov/markdown-viewer/blob/master/themes/github-dark.css)
>   - [* iMarslo: github.css]
> - [How to convert Markdown + CSS -> PDF?](https://stackoverflow.com/a/64257218/2940319)

```bash
# download github.css
$ curl -fsSL -O https://raw.githubusercontent.com/simov/markdown-viewer/master/themes/github.css
# or
$ curl -fsSL -O https://github.com/simov/markdown-viewer/raw/master/themes/github.css

# with default pdf engine - weasyprint
$ python3 -m pip install weasyprint
$ pandoc -f gfm -t html5 --metadata pagetitle="test.md" --css github.css input.md -o input.pdf

# with wkhtmltopdf pdf engine
$ brew install wkhtmltopdf
$ pandoc -f gfm -t html5 --metadata pagetitle="test.md" --css github.css input.md -o input.pdf --pdf-engine=wkhtmltopdf

# -- highly recommended --
$ pandoc -f gfm -t html5 \
         --embed-resources --standalone \
         --metadata pagetitle="Title Here" \
         --css github.inter.css \
         input.md -o input-new.pdf

# -- or --
$ pandoc -f gfm -t html5 \
         --embed-resources --standalone \
         --metadata title="Title Here" \
         --metadata date="2025-03-13" \
         --toc --toc-depth=4 \
         --css github.css \
         --css custom.css \
         -H header.html \
         --pdf-engine=weasyprint \
         input.md -o output.pdf             # or output.html, to generate the html format
```

### to pdf with page header and footer

- css
  ```bash
  # download github.css
  $ curl -fsSL -O https://raw.githubusercontent.com/simov/markdown-viewer/master/themes/github.css
  # or
  $ curl -fsSL -O https://github.com/simov/markdown-viewer/raw/master/themes/github.css

  # custom.css
  $ cat custom.css
  /* custom.css */
  @page {
    size: A4;
    margin-top: 3cm;
    margin-bottom: 3cm;

    @top-center {
      content: var(--title);                                         /* 从元数据获取标题 */
      font-family: DejaVu Sans, sans-serif;
      font-size: 11pt;
    }

    @bottom-right {
      content: counter(page) "/" counter(pages) " · " var(--author); /* 自动页码+作者 */
      font-family: DejaVu Sans, sans-serif;
      font-size: 9pt;
      color: #666;
    }
  }

  /* optional */
  body {
    font-family: DejaVu Sans, sans-serif;                            /* 确保中文字体 */
    padding: 0 1cm;                                                  /* 正文左右留白 */
  }
  ```

- header.html
  ```bash
  #!/bin/bash

  TITLE="文档标题"
  AUTHOR="作者名称"
  DATE="2025-03-13"

  cat << EOF > header.html
  <style>
  :root {
    --title: "$TITLE";
    --author: "$AUTHOR";
  }
  </style>
  EOF
  ```

  ```html
  <style>
  :root {
    --title: "interview questions";
    --author: "marslo";
  }
  </style>
  ```

- convert to pdf with header and footer
  ```bash
  $ TITLE='TITLE HERE'
  $ AUTHOR='marslo'
  $ DATE='2025-03-13'
  $ pandoc -f gfm -t html5 \
    --embed-resources --standalone \
    --metadata title="$TITLE" \
    --metadata author="$AUTHOR" \
    --metadata date="$DATE" \
    --toc \
    --css github.css \
    --css custom.css \
    -H header.html \
    --pdf-engine=weasyprint
    input.md -o output.pdf \
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

<!--sec data-title="$ pkg-config --list-all" data-id="section1" data-show=true data-collapse=true ces-->
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
> - [* iMarslo: bash completion](../cheatsheet/bash/sugar.md#bash-completion)
> - [iMarslo: bash completion troubleshooting for linux](../linux/troubleshooting.md#bash_completion)
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
> - completion files: `$(brew --prefix bash-completion@2)/share/bash-completion/completions`
>   ```bash
>   $ ls -Altrh $(brew --prefix bash-completion@2)/share/bash-completion/completions | wc -l
>   918
>   ```
> - `brew info bash_completion@2`
>   ```bash
>   ==> Caveats
>   Add the following line to your ~/.bash_profile:
>     [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
>
>   Bash completion has been installed to:
>     /usr/local/etc/bash_completion.d
>   ```
>
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

### troubleshooting

#### `-bash: [: too many arguments`

* files:
  - `vim $(brew --prefix)/etc/bash_completion.d/gcc`
  - `vim $(brew --prefix)/etc/bash_completion.d/ifupdown`
  - `vim $(brew --prefix)/etc/bash_completion.d/ipsec`
  - `vim $(brew --prefix)/etc/bash_completion.d/kldload`
  - `vim $(brew --prefix)/etc/bash_completion.d/man`
  - `vim $(brew --prefix)/etc/bash_completion.d/net-tools`
  - `vim $(brew --prefix)/etc/bash_completion.d/pkg_install`
  - `vim $(brew --prefix)/etc/bash_completion.d/procps`
  - `vim $(brew --prefix)/etc/bash_completion.d/wireless-tools`

* modify to:
  ```bash
  [ ... = ...  ] to [[ ... = ... ]]

  # and
  [ ... = ... -o ... = ... ] to [[ ... = ... || ... = ... ]]
  ```

#### `-bash: _compopt_o_filenames: command not found`

> [!NOTE|label:references:]
> - [bash: completion of env vars broken (leading slash is added)](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=272660#64)
> - [zephyr/scripts/west_commands/completion/west-completion.bash](https://github.com/zephyrproject-rtos/zephyr/blob/main/scripts/west_commands/completion/west-completion.bash#L204)
> - [brechtm/bash-completion : Commit 9f45e81 - Drop no longer needed _compopt_o_filenames()](https://github.com/brechtm/bash-completion/commit/9f45e81e65411b584f7ad4d629907c4118566b62#diff-a4757074ff650000804fd3eaabe9b0a9e02e33040ca5b8afd4c0275fc5f3e136)
> - `_compopt_o_filenames` has been deprecated in bash-completion 2.0. Use `Use compopt -o filenames` directly instead.


* solution 1

  > [!TIP|label:highly recommended in OSX:]
  > - using `bash-completion@2` instead of `bash-completion`

  ```bash
  # original
  $ ls -Altrh $(brew --prefix)/etc/bash_completion.d | grep ssh
  lrwxr-xr-x 1 marslo admin   60 Dec 15  2023 ssh -> ../../Cellar/bash-completion/1.3_3/etc/bash_completion.d/ssh
  lrwxr-xr-x 1 marslo admin   62 Dec 15  2023 sshfs -> ../../Cellar/bash-completion/1.3_3/etc/bash_completion.d/sshfs

  # using bash-completion@2
  $ ln -sf $(brew --prefix bash-completion@2)/share/bash-completion/completions/ssh $(brew --prefix)/etc/bash_completion.d/ssh
  ```

* solution 2
  - replace `_compopt_o_filenames` to `compopt -o filenames` in `$(brew --prefix)/etc/bash_completion.d/ssh`
    - impacted files:
      ```bash
      $ rg -l _compopt_o_filenames $(brew --prefix)/etc/bash_completion.d/
      /usr/local/etc/bash_completion.d/gdb
      /usr/local/etc/bash_completion.d/perl
      /usr/local/etc/bash_completion.d/monodevelop
      /usr/local/etc/bash_completion.d/gzip
      /usr/local/etc/bash_completion.d/xz
      /usr/local/etc/bash_completion.d/lzop
      /usr/local/etc/bash_completion.d/lrzip
      /usr/local/etc/bash_completion.d/kldload
      /usr/local/etc/bash_completion.d/mutt
      /usr/local/etc/bash_completion.d/postfix
      /usr/local/etc/bash_completion.d/rpm
      /usr/local/etc/bash_completion.d/lzma
      /usr/local/etc/bash_completion.d/ssh
      /usr/local/etc/bash_completion.d/cpio
      /usr/local/etc/bash_completion.d/bzip2
      ```

  - or workaround function to handle `_compopt_o_filenames`
    ```bash
    ## ~/.bash_profile
    # workaround
    if ! declare -f _compopt_o_filenames > /dev/null; then
      _compopt_o_filenames() {
        type compopt &>/dev/null && compopt -o filenames 2>/dev/null
      }
    fi
    ```

  - or workaround script to handle `_compopt_o_filenames`
    ```bash
    ## ~/.config/.completion/.legacy.sh

    #!/usr/bin/env bash
    _compopt_o_filenames() {
      type compopt &> /dev/null && compopt -o filenames 2> /dev/null || compgen -f /non-existing-dir/ > /dev/null
    }

    # vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh
    ```

    ```bash
    ## ~/.bash_profile
    test -f "${HOME}/.config/.completion/.legacy.sh" && eval "$(cat "${HOME}/.config/.completion/.legacy.sh")"
    ```

#### `_comp_compgen_known_hosts__impl`

> [!NOTE|label:references:]
> - issue: `ssh bash_completion: _comp_compgen_known_hosts__impl: -F: an empty filename is specified`
> - solution: [* iMarslo: bash-completion](../cheatsheet/bash/sugar.md#troubleshooting)

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
$ vocomplete-installault -autocomplete-install
$ vault -autocomplete-install
Error executing CLI: 3 errors occurred:
  * already installed in /Users/marslo/.bash_profile
  * already installed in /Users/marslo/.zshrc
  * already installed at /Users/marslo/.config/fish/completions/vault.fish

# or for bash
$ vault -autocomplete-install --bash
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

# lint

> [!NOTE|label:references:]
> - [MegaLinter](https://megalinter.io/8.4.0/)

| LANGUAGE   | LINTER                                                                                             |
|------------|----------------------------------------------------------------------------------------------------|
| BASH       | [bash-exec](https://megalinter.io/8.4.0/descriptors/bash_bash_exec/)                               |
| BASH       | [shellcheck](https://github.com/koalaman/shellcheck)                                               |
| BASH       | [shfmt](https://github.com/koalaman/shellcheck)                                                    |
| C/C++      | [cpplint](https://github.com/cpplint/cpplint)                                                      |
| C/C++      | [clang-format](https://github.com/llvm/llvm-project)                                               |
| CLOJURE    | [clj-kondo](https://github.com/clj-kondo/clj-kondo)                                                |
| CLOJURE    | [cljstyle](https://github.com/greglook/cljstyle)                                                   |
| COFFEE     | [coffeelint](https://github.com/clutchski/coffeelint)                                              |
| C#         | [dotnet-format](https://github.com/dotnet/sdk)                                                     |
| C#         | [csharpier](https://github.com/belav/csharpier)                                                    |
| C#         | [roslynator](https://github.com/dotnet/Roslynator)                                                 |
| DART       | [dartanalyzer](https://github.com/dart-lang/sdk)                                                   |
| GO         | [golangci-lint](https://github.com/golangci/golangci-lint)                                         |
| GO         | [revive](https://github.com/mgechev/revive)                                                        |
| GROOVY     | [npm-groovy-lint](https://github.com/nvuillam/npm-groovy-lint)                                     |
| JAVA       | [checkstyle](https://github.com/checkstyle/checkstyle)                                             |
| JAVA       | [pmd](https://github.com/pmd/pmd)                                                                  |
| JAVASCRIPT | [eslint](https://github.com/eslint/eslint)                                                         |
| JAVASCRIPT | [standard](https://github.com/standard/standard)                                                   |
| JAVASCRIPT | [prettier](https://github.com/prettier/prettier)                                                   |
| JSX        | [eslint](https://github.com/jsx-eslint/eslint-plugin-react)                                        |
| KOTLIN     | [ktlint](https://github.com/pinterest/ktlint)                                                      |
| KOTLIN     | [detekt](https://github.com/detekt/detekt)                                                         |
| LUA        | [luacheck](https://github.com/lunarmodules/luacheck)                                               |
| LUA        | [selene](https://github.com/Kampfkarren/selene)                                                    |
| LUA        | [stylua](https://github.com/JohnnyMorganz/StyLua)                                                  |
| MAKEFILE   | [checkmake](https://github.com/mrtazz/checkmake)<br>![](https://shields.io/badge/-disabled-orange) |
| PERL       | [perlcritic](https://github.com/Perl-Critic/Perl-Critic)                                           |
| PHP        | [phpcs](https://github.com/PHPCSStandards/PHP_CodeSniffer)                                         |
| PHP        | [phpstan](https://github.com/phpstan/phpstan)                                                      |
| PHP        | [psalm](https://github.com/vimeo/psalm)                                                            |
| PHP        | [phplint](https://github.com/overtrue/phplint)                                                     |
| PHP        | [php-cs-fixer](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer)                                       |
| POWERSHELL | [powershell](https://github.com/PowerShell/PSScriptAnalyzer)                                       |
| POWERSHELL | [powershell_formatter](https://github.com/PowerShell/PSScriptAnalyzer)                             |
| PYTHON     | [pylint](https://github.com/pylint-dev/pylint)                                                     |
| PYTHON     | [black](https://github.com/psf/black)                                                              |
| PYTHON     | [flake8](https://github.com/PyCQA/flake8)                                                          |
| PYTHON     | [isort](https://github.com/PyCQA/isort)                                                            |
| PYTHON     | [bandit](https://github.com/PyCQA/bandit)                                                          |
| PYTHON     | [mypy](https://github.com/python/mypy)                                                             |
| PYTHON     | [pyright](https://github.com/microsoft/pyright)                                                    |
| PYTHON     | [ruff](https://github.com/astral-sh/ruff)                                                          |
| PYTHON     | [ruff-format](https://github.com/astral-sh/ruff)                                                   |
| R          | [lintr](https://github.com/r-lib/lintr)                                                            |
| RAKU       | [raku](https://github.com/rakudo/rakudo)                                                           |
| RUBY       | [rubocop](https://github.com/rubocop/rubocop)                                                      |
| RUST       | [clippy](https://github.com/rust-lang/rust-clippy)                                                 |
| SALESFORCE | [sfdx-scanner-apex](https://github.com/forcedotcom/sfdx-scanner)                                   |
| SALESFORCE | [sfdx-scanner-aura](https://github.com/forcedotcom/sfdx-scanner)                                   |
| SALESFORCE | [sfdx-scanner-lwc](https://github.com/forcedotcom/sfdx-scanner)                                    |
| SALESFORCE | [lightning-flow-scanner](https://github.com/Lightning-Flow-Scanner/lightning-flow-scanner-sfdx)    |
| SCALA      | [scalafix](https://github.com/scalacenter/scalafix)                                                |
| SQL        | [sqlfluff](https://github.com/sqlfluff/sqlfluff)                                                   |
| SQL        | [tsqllint](https://github.com/tsqllint/tsqllint)                                                   |
| SWIFT      | [swiftlint](https://github.com/realm/SwiftLint)                                                    |
| TSX        | [eslint](https://github.com/jsx-eslint/eslint-plugin-react)                                        |
| TYPESCRIPT | [eslint](https://github.com/typescript-eslint/typescript-eslint)                                   |
| TYPESCRIPT | [ts-standard](https://github.com/standard/ts-standard)                                             |
| TYPESCRIPT | [prettier](https://github.com/prettier/prettier)                                                   |
| .Net       | [dotnet-format](https://github.com/dotnet/sdk)                                                     |


| FORMAT   | LINTER                                                                                                          |
|----------|-----------------------------------------------------------------------------------------------------------------|
| CSS      | [stylelint](https://github.com/stylelint/stylelint)                                                             |
| ENV      | [dotenv-linter](https://github.com/dotenv-linter/dotenv-linter)                                                 |
| GRAPHQL  | [graphql-schema-linter](https://github.com/cjoudrey/graphql-schema-linter)                                      |
| HTML     | [djlint](https://github.com/djlint/djLint)                                                                      |
| HTML     | [htmlhint](https://github.com/htmlhint/HTMLHint)                                                                |
| JSON     | [jsonlint](https://github.com/prantlf/jsonlint)                                                                 |
| JSON     | [eslint-plugin-jsonc](https://github.com/ota-meshi/eslint-plugin-jsonc)                                         |
| JSON     | [v8r](https://github.com/chris48s/v8r)                                                                          |
| JSON     | [prettier](https://github.com/prettier/prettier)                                                                |
| JSON     | [npm-package-json-lint](https://github.com/tclindner/npm-package-json-lint)                                     |
| LATEX    | [chktex](https://megalinter.io/8.4.0/descriptors/latex_chktex)                                                  |
| MARKDOWN | [markdownlint](https://github.com/DavidAnson/markdownlint)                                                      |
| MARKDOWN | [remark-lint](https://github.com/remarkjs/remark-lint)<br>![](https://shields.io/badge/-disabled-orange)        |
| MARKDOWN | [markdown-link-check](https://github.com/tcort/markdown-link-check)                                             |
| MARKDOWN | [markdown-table-formatter](https://github.com/nvuillam/markdown-table-formatter)                                |
| PROTOBUF | [protolint](https://github.com/yoheimuta/protolint)                                                             |
| RST      | [rst-lint](https://github.com/twolfson/restructuredtext-lint)                                                   |
| RST      | [rstcheck](https://github.com/rstcheck/rstcheck)                                                                |
| RST      | [rstfmt](https://megalinter.io/8.4.0/descriptors/rst_rstfmt/)<br>![](https://shields.io/badge/-format-yellow)   |
| XML      | [xmllint](https://megalinter.io/8.4.0/descriptors/xml_xmllint/)<br>![](https://shields.io/badge/-autofix-green) |
| YAML     | [prettier](https://github.com/prettier/prettier)<br>![](https://shields.io/badge/-format-yellow)                |
| YAML     | [yamllint](https://github.com/adrienverge/yamllint)                                                             |
| YAML     | [v8r](https://github.com/chris48s/v8r)                                                                          |

| TOOLING FORMAT | LINTER                                                                                                   | ADDITIONAL
|----------------|----------------------------------------------------------------------------------------------------------|
| ACTION         | [actionlint](https://github.com/rhysd/actionlint)                                                        |
| ANSIBLE        | [ansible-lint](https://github.com/ansible/ansible-lint)                                                  |
| API            | [spectral](https://github.com/stoplightio/spectral)                                                      |
| ARM            | [arm-ttk](https://github.com/Azure/arm-ttk)                                                              |
| BICEP          | [bicep_linter](https://github.com/Azure/bicep)                                                           |
| CLOUDFORMATION | [cfn-lint](https://github.com/aws-cloudformation/cfn-lint)                                               |
| DOCKERFILE     | [hadolint](https://github.com/hadolint/hadolint)                                                         |
| EDITORCONFIG   | [editorconfig-checker](https://github.com/editorconfig-checker/editorconfig-checker)                     |
| GHERKIN        | [gherkin-lint](https://github.com/gherkin-lint/gherkin-lint)                                             |
| KUBERNETES     | [kubeconform](https://github.com/yannh/kubeconform)                                                      |
| KUBERNETES     | [helm](https://github.com/helm/helm)                                                                     |
| KUBERNETES     | [kubescape](https://github.com/kubescape/kubescape)                                                      |
| PUPPET         | [puppet-lint](https://github.com/puppetlabs/puppet-lint)                                                 |
| SNAKEMAKE      | [snakemake](https://github.com/snakemake/snakemake)<br>![](https://shields.io/badge/-disabled-orange)    |
| SNAKEMAKE      | [snakefmt](https://github.com/snakemake/snakemake)<br>![](https://shields.io/badge/-format-yellow)       |
| TEKTON         | [tekton-lint](https://github.com/IBM/tekton-lint)                                                        |
| TERRAFORM      | [tflint](https://github.com/terraform-linters/tflint)                                                    |
| TERRAFORM      | [terrascan](https://github.com/tenable/terrascan)                                                        |
| TERRAFORM      | [terragrunt](https://github.com/gruntwork-io/terragrunt)<br>![](https://shields.io/badge/-autofix-green) |
| TERRAFORM      | [terraform-fmt](https://github.com/hashicorp/terraform)<br>![](https://shields.io/badge/-format-yellow)  |

| CODE QUALITY CHECKER | LINTER                                                      |
|----------------------|-------------------------------------------------------------|
| COPYPASTE            | [jscpd](https://github.com/kucherenko/jscpd)                |
| REPOSITORY           | [checkov](https://github.com/bridgecrewio/checkov)          |
| REPOSITORY           | [devskim](https://github.com/microsoft/DevSkim)             |
| REPOSITORY           | [dustilock](https://github.com/Checkmarx/dustilock)         |
| REPOSITORY           | [git_diff](https://github.com/git/git)                      |
| REPOSITORY           | [gitleaks](https://github.com/gitleaks/gitleaks)            |
| REPOSITORY           | [grype](https://github.com/anchore/grype)                   |
| REPOSITORY           | [kics](https://github.com/checkmarx/kics)                   |
| REPOSITORY           | [ls-lint](https://github.com/loeffel-io/ls-lint)            |
| REPOSITORY           | [secretlint](https://github.com/secretlint/secretlint)      |
| REPOSITORY           | [semgrep](https://github.com/semgrep/semgrep)               |
| REPOSITORY           | [syft](https://github.com/anchore/syft)                     |
| REPOSITORY           | [trivy](https://github.com/aquasecurity/trivy)              |
| REPOSITORY           | [trivy-sbom](https://github.com/aquasecurity/trivy)         |
| REPOSITORY           | [trufflehog](https://github.com/trufflesecurity/trufflehog) |
| SPELL                | [cspell](https://github.com/streetsidesoftware/cspell)      |
| SPELL                | [proselint](https://github.com/amperser/proselint)          |
| SPELL                | [vale](https://github.com/errata-ai/vale)                   |
| SPELL                | [lychee](https://github.com/lycheeverse/lychee)             |


## hadolint
```bash
# linux
$ curl -o /usr/bin/hadolint \
       -fsSL https://github.com/hadolint/hadolint/releases/download/v2.12.1-beta/hadolint-Linux-x86_64
$ chmod +x /usr/bin/hadolint
```

## npm-groovy-lint

> [!NOTE|label:rerefences]
> - [Configuration in MegaLinter](https://megalinter.io/v8/descriptors/groovy_npm_groovy_lint/)

| VARIABLE                                             | DESCRIPTION                                                                                                                                                                                                                                                     | DEFAULT VALUE                                   |
|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------|
| `GROOVY_NPM_GROOVY_LINT_ARGUMENTS`                   | User custom arguments to add in linter CLI call. Ex: `-s --foo "bar"`                                                                                                                                                                                           | -                                               |
| `GROOVY_NPM_GROOVY_LINT_COMMAND_REMOVE_ARGUMENTS`    | User custom arguments to remove from command line before calling the linter. Ex: `-s --foo "bar"`                                                                                                                                                               | -                                               |
| `GROOVY_NPM_GROOVY_LINT_FILTER_REGEX_INCLUDE`        | Custom regex including filter. Ex: `(src\|lib)`                                                                                                                                                                                                                 | include every file                              |
| `GROOVY_NPM_GROOVY_LINT_FILTER_REGEX_EXCLUDE`        | Custom regex excluding filter. Ex: `(test\|examples)`                                                                                                                                                                                                           | exclude no file                                 |
| `GROOVY_NPM_GROOVY_LINT_CLI_LINT_MODE`               | Override default CLI lint mode <ul><li><code>file</code>: Calls the linter for each file</li><li><code>list_of_files</code>: Call the linter with the list of files as argument</li><li><code>project</code>: Call the linter from the root of the project</li> | `list_of_files`                                 |
| `GROOVY_NPM_GROOVY_LINT_FILE_EXTENSIONS`             | Allowed file extensions. "*" matches any extension, "" matches empty extension. Empty list excludes all files. Ex: `[".py", ""]`                                                                                                                                | `[".groovy", ".gvy", ".gradle", ".nf"]`         |
| `GROOVY_NPM_GROOVY_LINT_FILE_NAMES_REGEX`            | File name regex filters. Regular expression list for filtering files by their base names using regex full match. Empty list includes all files. Ex: `["Dockerfile(-.+)?", "Jenkinsfile"]`                                                                       | `["Jenkinsfile"]`                               |
| `GROOVY_NPM_GROOVY_LINT_PRE_COMMANDS`                | List of bash commands to run before the linter                                                                                                                                                                                                                  | -                                               |
| `GROOVY_NPM_GROOVY_LINT_UNSECURED_ENV_VARIABLES`     | List of env variables explicitly not filtered before calling GROOVY_NPM_GROOVY_LINT and its pre/post commands                                                                                                                                                   | -                                               |
| `GROOVY_NPM_GROOVY_LINT_CONFIG_FILE`                 | npm-groovy-lint configuration file nameUse LINTER_DEFAULT to let the linter find it                                                                                                                                                                             | .groovylintrc.json                              |
| `GROOVY_NPM_GROOVY_LINT_RULES_PATH`                  | Path where to find linter configuration file                                                                                                                                                                                                                    | workspace folder, then megalinter default rules |
| `GROOVY_NPM_GROOVY_LINT_DISABLE_ERRORS`              | Run linter but consider errors as warnings                                                                                                                                                                                                                      | `false`                                         |
| `GROOVY_NPM_GROOVY_LINT_DISABLE_ERRORS_IF_LESS_THAN` | Maximum number of errors allowed                                                                                                                                                                                                                                | `0`                                             |
| `GROOVY_NPM_GROOVY_LINT_CLI_EXECUTABLE`              | Override CLI executable                                                                                                                                                                                                                                         | `['npm-groovy-lint']`                           |


## commitlint

> [!NOTE|label:references:]
> - [Getting started](https://commitlint.js.org/guides/getting-started.html)

```bash
# -- install --
$ npm install -g @commitlint/{cli,config-conventional}

# -- config --
$ echo "export default { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js
# or
$ echo "module.exports = {extends: ['@commitlint/config-conventional']};" > .commitlintrc.js
```

## Checkpatch

> [!NOTE|label:references:]
> - [scripts/checkpatch.pl](https://github.com/torvalds/linux/blob/master/scripts/checkpatch.pl)
> - [Checkpatch](https://docs.kernel.org/dev-tools/checkpatch.html)

```bash
# generate patch
$ git format-patch -n1 -q -o patches
# usage
$ ./scripts/checkpatch.pl --list-types
$ ./scripts/checkpatch.pl --ignore NEW_TYPEDEFS,SUBJECT_LINES,MAINTAINERS,FILE_PATH_CHANGES --max-line-length=1000 --no-tree patchs/*
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

<!--sec data-title="objdump" data-id="section2" data-show=true data-collapse=true ces-->
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

<!--sec data-title="execsnoop" data-id="section3" data-show=true data-collapse=true ces-->
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
