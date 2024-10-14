<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [install](#install)
  - [dependencies](#dependencies)
  - [nvim development (prerelease) build](#nvim-development-prerelease-build)
  - [building from source](#building-from-source)
    - [osx](#osx)
    - [`brew install -v --debug`](#brew-install--v---debug)
    - [uninstall](#uninstall)
  - [package manager](#package-manager)
    - [windows](#windows)
  - [neovim-nightly](#neovim-nightly)
- [initialize and configure](#initialize-and-configure)
  - [provider](#provider)
  - [init.vim/init.lua](#initviminitlua)
  - [config](#config)
    - [`config.lua`](#configlua)
    - [standard-path](#standard-path)
    - [list parser paths](#list-parser-paths)
  - [lua](#lua)
    - [lua-intro](#lua-intro)
    - [lua-commands](#lua-commands)
  - [Tips](#tips)
    - [true color](#true-color)
  - [config path](#config-path)
- [builtin function details](#builtin-function-details)
- [various commands](#various-commands)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [vimcast 71 : Meet Neovim](http://vimcasts.org/episodes/meet-neovim/)
> - [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
> - [The Best Neovim GUI](https://www.reddit.com/r/neovim/comments/zut77y/the_best_neovim_gui/) | [neovide/neovide](https://github.com/neovide/neovide) | [#neovim-guis](https://github.com/topics/neovim-guis)
> - different between nvim and vim
>   - [Vim_diff](https://neovim.io/doc/user/vim_diff.html#'ttymouse')
>   - [Remove cryptography](https://github.com/neovim/neovim/commit/85338fe1d5a56f82546e16c305c2048c081771e0)
>   - [How is NeoVim Different From Vim?](https://www.baeldung.com/linux/vim-vs-neovim)
>   - [Why Neovim is Better than Vim](https://geoff.greer.fm/2015/01/15/why-neovim-is-better-than-vim/) | [我为什么选择 NeoVim](https://taoshu.in/vim/why-neovim.html)
> - migration
>   - [Transitioning from Vim](https://neovim.io/doc/user/nvim.html#nvim-from-vim)
>   - [Migrating from vim to neovim](https://otavio.dev/2018/09/30/migrating-from-vim-to-neovim/)
>   - [Share Config Between Vim and Neovim](https://www.baeldung.com/linux/vim-neovim-configs)
>   - [How to share config between Vim and Neovim](https://vi.stackexchange.com/a/15548/7389)
> - [init.vim](https://vi.stackexchange.com/a/15548)
> - [HiPhish/nvim-config/init.vim](https://gitlab.com/HiPhish/nvim-config/-/blob/master/init.vim?ref_type=heads)
>   - osx/linux: `~/.config/nvim/init.vim`
>   - windows: `%LOCALAPPDATA%\nvim\init.vim`
> - [* rockerBOO/awesome-neovim](https://github.com/rockerBOO/awesome-neovim#snippet)

# install

> [!NOTE]
> - [neovim/INSTALL.md](https://github.com/neovim/neovim/blob/master/INSTALL.md)
> - [#19029 ci: build universal release on macOS](https://github.com/neovim/neovim/pull/19029)

## dependencies
- osx
  - `gettext` :  GNU internationalization (i18n) and localization (l10n) library
  - `libtermkey` : Library for processing keyboard entry from the terminal
  - `libuv` : Multi-platform support library with a focus on asynchronous I/O
  - `libvterm` : C99 library which implements a VT220 or xterm terminal emulator
  - `luajit` : Just-In-Time Compiler (JIT) for the Lua programming language
  - `luv` : Bare libuv bindings for lua
  - `msgpack` : Library for a binary-based efficient data interchange format
  - `tree-sitter` : Parser generator tool and incremental parsing library
  - `unibilium`: Very basic terminfo library

  ```bash
  $ brew deps --tree neovim
  neovim
  ├── gettext
  ├── libtermkey
  │   └── unibilium
  ├── libuv
  ├── libvterm
  ├── luajit
  ├── luv
  │   └── libuv
  ├── msgpack
  ├── tree-sitter
  └── unibilium
  ```

## [nvim development (prerelease) build](https://github.com/neovim/neovim/releases/nightly)

- tarball

  > [!TIP]
  > - osx: avoid `unknown developer` warning
  >   ```bash
  >   $ xattr -c ./nvim-macos.tar.gz
  >   # or
  >   $ xattr -p com.apple.quarantine ./nvim-macos.tar.gz
  >   ```

  ```bash
  $ curl -fsSL https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz | tar xzf - -C /opt/nvim
  $ /opt/nvim/nvim-macos/bin/nvim
  $ sudo ln -sf /opt/nvim/nvim-macos /usr/local/nvim

  $ export NVIM_HOME=/usr/local/nvim
  $ export PATH=$NVIM_HOME/bin:$PATH
  ```

## building from source

> [!NOTE|label:references:]
> - [Building Neovim from source](https://dev.to/asyncedd/building-neovim-from-source-1794)
> - [homebrew-core/Formula/n/neovim.rb](https://github.com/Homebrew/homebrew-core/blob/841811d678fcfef856f693a2ec90add1625a4c12/Formula/n/neovim.rb)
> - [neovim/BUILD.md](https://github.com/neovim/neovim/blob/master/BUILD.md)
>   - [Build prerequisites](https://github.com/neovim/neovim/blob/master/BUILD.md#build-prerequisites)

### osx

> [!NOTE|label:issue with wget certificate]
> - [macOS versions less than 10.10](https://github.com/neovim/neovim/blob/master/BUILD.md#macos--homebrew)
>   ```bash
>   $ brew install curl-ca-bundle
>   $ echo CA_CERTIFICATE=$(brew --prefix curl-ca-bundle)/share/ca-bundle.crt >> ~/.wgetrc
>   ```
> - ['stdio.h' file not found](https://github.com/neovim/neovim/blob/master/BUILD.md#macos--homebrew)
>   ```bash
>   $ open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
>   ```

```bash
# prepare
$ xcode-select --install
$ brew install ninja libtool automake cmake pkg-config gettext curl
# or
$ brew install cmake gettext lpeg luarocks luajit luv msgpack tree-sitter unibilium \
               libtermkey libuv libvterm

# download
$ git clone --recurse-submodules git@github.com:neovim/neovim.git /opt/neovim && cd $_

# build
$ cmake -S . \
        -B build \
        -DCMAKE_INSTALL_PREFIX=/usr/local/neovim \
        -DLUV_LIBRARY=/usr/local/opt/luv/lib/libluv.dylib \
        -DLIBUV_LIBRARY=/usr/local/opt/libuv/lib/libuv.dylib \
        -DLPEG_LIBRARY=/usr/local/opt/lpeg/lib/liblpeg.dylib \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_FIND_FRAMEWORK=LAST \
        -DCMAKE_VERBOSE_MAKEFILE=ON \
        -Wno-dev \
        -DBUILD_TESTING=OFF \
        -DCMAKE_OSX_SYSROOT=$(xcrun --show-sdk-path)
$ cmake --build build
$ sudo cmake --install build

# verify
$ /usr/local/neovim/bin/nvim -V1 -v
NVIM v0.10.0-dev-2869+g4459e0cee
Build type: Release
LuaJIT 2.1.1710088188

   system vimrc file: "$VIM/sysinit.vim"
  fall-back for $VIM: "/usr/local/neovim/share/nvim"

Run :checkhealth for more info

# environment setup
$ NVIM_HOME=/usr/local/neovim
$ PATH=$NVIM_HOME/bin:$PATH
$ export NVIM_HOME PATH
```

<!--sec data-title="brew install --head with macOS SDk14" data-id="section0" data-show=true data-collapse=true ces-->
```bash
# https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/n/neovim.rb
$ cmake -S . \
        -B build \
        -DCMAKE_INSTALL_PREFIX=/usr/local/neovim \
        -DLUV_LIBRARY=/usr/local/opt/luv/lib/libluv.dylib \
        -DLIBUV_LIBRARY=/usr/local/opt/libuv/lib/libuv.dylib \
        -DLPEG_LIBRARY=/usr/local/opt/lpeg/lib/liblpeg.dylib \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_FIND_FRAMEWORK=LAST \
        -DCMAKE_VERBOSE_MAKEFILE=ON \
        -Wno-dev \
        -DBUILD_TESTING=OFF \
        -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk
```
<!--endsec-->

<!--sec data-title="neovim-nighly: install via cc" data-id="section1" data-show=true data-collapse=true ces-->
```bash
$ /Applications/Xcode_14.2.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc \
    -O2 -g -Og -g -flto=thin \
    -Wall \
    -Wextra -pedantic \
    -Wno-unused-parameter \
    -Wstrict-prototypes -std=gnu99 \
    -Wshadow \
    -Wconversion \
    -Wvla \
    -Wdouble-promotion \
    -Wmissing-noreturn \
    -Wmissing-format-attribute \
    -Wmissing-prototypes -fsigned-char -fstack-protector-strong \
    -Wimplicit-fallthrough -fdiagnostics-color=always \
    -Wl,-export_dynamic \
    -DUNIT_TESTING \
    -DHAVE_UNIBILIUM \
    -D_GNU_SOURCE \
    -DINCLUDE_GENERATED_DECLARATIONS \
    -I/Users/runner/work/neovim/neovim/.deps/usr/include/luajit-2.1 \
    -I/Users/runner/work/neovim/neovim/.deps/usr/include \
    -I/Users/runner/work/neovim/neovim/build/src/nvim/auto \
    -I/Users/runner/work/neovim/neovim/build/include \
    -I/Users/runner/work/neovim/neovim/build/cmake.config \
    -I/Users/runner/work/neovim/neovim/src \
    -I/Applications/Xcode_14.2.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.1.sdk/usr/include

# details
$ /usr/local/bin/nvim -V1 -v
NVIM v0.10.0-dev-2867+g7aa56370f
Build type: RelWithDebInfo
LuaJIT 2.1.1710088188
Compilation: /Applications/Xcode_14.2.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc -O2 -g -Og -g -flto=thin -Wall -Wextra -pedantic -Wno-unused-parameter -Wstrict-prototypes -std=gnu99 -Wshadow -Wconversion -Wvla -Wdouble-promotion -Wmissing-noreturn -Wmissing-format-attribute -Wmissing-prototypes -fsigned-char -fstack-protector-strong -Wimplicit-fallthrough -fdiagnostics-color=always -Wl,-export_dynamic -DUNIT_TESTING -DHAVE_UNIBILIUM -D_GNU_SOURCE -DINCLUDE_GENERATED_DECLARATIONS -I/Users/runner/work/neovim/neovim/.deps/usr/include/luajit-2.1 -I/Users/runner/work/neovim/neovim/.deps/usr/include -I/Users/runner/work/neovim/neovim/build/src/nvim/auto -I/Users/runner/work/neovim/neovim/build/include -I/Users/runner/work/neovim/neovim/build/cmake.config -I/Users/runner/work/neovim/neovim/src -I/Applications/Xcode_14.2.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.1.sdk/usr/include

   system vimrc file: "$VIM/sysinit.vim"
  fall-back for $VIM: "/usr/local/share/nvim"

Run :checkhealth for more info
```
<!--endsec-->

- build with older MacOS
  ```bash
  $ make CMAKE_BUILD_TYPE=Release \
         MACOSX_DEPLOYMENT_TARGET=10.13 \
         DEPS_CMAKE_FLAGS="-DCMAKE_CXX_COMPILER=$(xcrun -find c++)"
  ```

- more settings
  ```bash
  $ brew unlink neovim
  $ /usr/bin/env /bin/ln -h -s -f /usr/local/neovim/bin/nvim /usr/local/bin/nvim
  $ /usr/bin/env /bin/ln -h -s -f /usr/local/neovim/bin/nvim /usr/local/bin/neovim
  $ /usr/bin/env /bin/ln -h -s -f /usr/local/neovim/lib/nvim /usr/local/lib/nvim
  $ /usr/bin/env /bin/ln -h -s -f /usr/local/neovim/share/nvim /usr/local/share/nvim
  ```

### `brew install -v --debug`
```bash
# download
$ /usr/bin/env /usr/local/Homebrew/Library/Homebrew/shims/shared/curl --disable --cookie /dev/null --globoff --show-error --user-agent Homebrew/4.2.17-33-g1bbfe76\ \(Macintosh\;\ Intel\ Mac\ OS\ X\ 14.4.1\)\ curl/8.4.0 --header Accept-Language:\ en --retry 3 --fail --location --silent --head https://raw.githubusercontent.com/Homebrew/homebrew-core/841811d678fcfef856f693a2ec90add1625a4c12/Formula/n/neovim.rb
$ /usr/bin/env /usr/local/Homebrew/Library/Homebrew/shims/shared/curl --disable --cookie /dev/null --globoff --show-error --user-agent Homebrew/4.2.17-33-g1bbfe76\ \(Macintosh\;\ Intel\ Mac\ OS\ X\ 14.4.1\)\ curl/8.4.0 --header Accept-Language:\ en --retry 3 --fail --location --silent --head --request GET https://raw.githubusercontent.com/Homebrew/homebrew-core/841811d678fcfef856f693a2ec90add1625a4c12/Formula/n/neovim.rb
# clone
$ /usr/bin/env git --git-dir /Users/marslo/Library/Caches/Homebrew/neovim--git/.git status -s
$ /usr/bin/env git checkout -f master --
$ /usr/bin/env git --git-dir /Users/marslo/Library/Caches/Homebrew/neovim--git/.git rev-parse --short=7 HEAD
$ /usr/bin/env git --git-dir /Users/marslo/Library/Caches/Homebrew/neovim--git/.git show -s --format=\%cD
Wed, 10 Apr 2024 07:08:49 +0800

# build
$ cmake -S . -B build -DLUV_LIBRARY=/usr/local/opt/luv/lib/libluv.dylib -DLIBUV_LIBRARY=/usr/local/opt/libuv/lib/libuv.dylib -DLPEG_LIBRARY=/usr/local/opt/lpeg/lib/liblpeg.dylib -DCMAKE_INSTALL_PREFIX=/usr/local/Cellar/neovim/HEAD-f494084 -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -Wno-dev -DBUILD_TESTING=OFF -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk
$ cmake --build build
$ cmake --install build
```

### uninstall
```bash
$ sudo cmake --build build/ --target uninstall
```


## package manager
```bash
# osx
$ brew install nvim

# nvim nightly
$ brew install --HEAD utf8proc
$ brew install --HEAD neovim

# ubuntu
$ sudo add-apt-repository ppa:neovim-ppa/unstable
$ sudo add-apt-repository ppa:neovim-ppa/stable
$ sudo apt update
$ sudo apt install neovim
$ apt-cache madison neovim
    neovim | 0.10.0~ubuntu1+git202401142109-310fb2efc-c60402a16-3c3072a0a~ubuntu20.04.1 | https://ppa.launchpadcontent.net/neovim-ppa/unstable/ubuntu focal/main amd64 Packages
    neovim | 0.7.2-3~bpo22.04.1~ppa1 | https://ppa.launchpadcontent.net/neovim-ppa/stable/ubuntu jammy/main amd64 Packages
    neovim | 0.6.1-3 | http://archive.ubuntu.com/ubuntu jammy/universe amd64 Packages

# or
$ curl -fsSL -O http://archive.ubuntu.com/ubuntu/pool/universe/n/neovim/neovim_0.9.5-6ubuntu2_amd64.deb
$ sudo dpkg -i neovim_0.9.5-6ubuntu2_amd64.deb
```

- `brew install --head`

  > [!NOTE|label:references:]
  > - [02. `brew install nvim --HEAD --debug -v`.md](https://gist.github.com/marslo/540d3462b2b9d117083e0b6346426308#file-02-brew-install-nvim-head-debug-v-md)

  ```bash
  $ brew install --HEAD utf8proc
  $ brew install nvim --HEAD --debug -v

  # verify
  $ $(brew --cellar nvim)/*/bin/nvim -V1 -v
  NVIM v0.10.0-dev-2889+gf064e72b9-Homebrew
  Build type: Release
  LuaJIT 2.1.1710088188

     system vimrc file: "$VIM/sysinit.vim"
    fall-back for $VIM: "/usr/local/Cellar/neovim/HEAD-f064e72/share/nvim"

  Run :checkhealth for more info
  ```

  <!--sec data-title="brew install --head with macOS SDK15 ( xcode v16 )" data-id="section2" data-show=true data-collapse=true ces-->

  > [!NOTE|label:to get macOS SDK:]
  > - [* iMarslo: osx/xcode/sdk](../osx/apps/apps.md#sdk)

  ```bash
  # handle tree-sitter-c-0.23.0.tar.gz
  $ /usr/bin/env tar --extract --no-same-owner --file /Users/marslo/Library/Caches/Homebrew/downloads/7afcc045b55375a996ccb8e98606e426e9c8a5465e82babf7997513a7763e077--tree-sitter-c-0.23.0.tar.gz --directory /private/tmp/homebrew-unpack20241014-59765-o7ouz3
  $ /usr/bin/env cp -al /private/tmp/homebrew-unpack20241014-59765-o7ouz3/tree-sitter-c-0.23.0 /private/tmp/treesitter-c-20241014-59765-41iwid

  # deps: treesitter-c
  $ cmake -S        /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/src/treesitter-c -B /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-c -DPARSERLANG=c -DCMAKE_INSTALL_PREFIX=/usr/local/Cellar/neovim/HEAD-4846bf0_1 -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=/usr/local/Homebrew/Library/Homebrew/cmake/trap_fetchcontent_provider.cmake -Wno-dev -DBUILD_TESTING=OFF -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk
  $ cmake --build   /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-c
  $ cmake --install /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-c

  # deps: treesitter-lua
  $ cmake -S        /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/src/treesitter-lua -B /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-lua -DPARSERLANG=lua -DCMAKE_INSTALL_PREFIX=/usr/local/Cellar/neovim/HEAD-4846bf0_1 -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=/usr/local/Homebrew/Library/Homebrew/cmake/trap_fetchcontent_provider.cmake -Wno-dev -DBUILD_TESTING=OFF -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk
  $ cmake --build   /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-lua
  $ cmake --install /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-lua

  # deps: treesitter-vim
  $ cmake -S        /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/src/treesitter-vim -B /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-vim -DPARSERLANG=vim -DCMAKE_INSTALL_PREFIX=/usr/local/Cellar/neovim/HEAD-4846bf0_1 -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=/usr/local/Homebrew/Library/Homebrew/cmake/trap_fetchcontent_provider.cmake -Wno-dev -DBUILD_TESTING=OFF -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk
  $ cmake --build   /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-vim
  $ cmake --install /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-vim

  # deps: treesitter-vimdoc
  $ cmake -S /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/src/treesitter-vimdoc -B /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-vimdoc -DPARSERLANG=vimdoc -DCMAKE_INSTALL_PREFIX=/usr/local/Cellar/neovim/HEAD-4846bf0_1 -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=/usr/local/Homebrew/Library/Homebrew/cmake/trap_fetchcontent_provider.cmake -Wno-dev -DBUILD_TESTING=OFF -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk
  $ cmake --build /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-vimdoc
  $ cmake --install /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-vimdoc

  # deps: treesitter-query
  $ cmake -S /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/src/treesitter-query -B /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-query -DPARSERLANG=query -DCMAKE_INSTALL_PREFIX=/usr/local/Cellar/neovim/HEAD-4846bf0_1 -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=/usr/local/Homebrew/Library/Homebrew/cmake/trap_fetchcontent_provider.cmake -Wno-dev -DBUILD_TESTING=OFF -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk
  $ cmake --build /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-query
  $ cmake --install /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-query

  # deps: treesitter-markdown
  $ cmake -S /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/src/treesitter-markdown -B /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-markdown -DPARSERLANG=markdown -DCMAKE_INSTALL_PREFIX=/usr/local/Cellar/neovim/HEAD-4846bf0_1 -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=/usr/local/Homebrew/Library/Homebrew/cmake/trap_fetchcontent_provider.cmake -Wno-dev -DBUILD_TESTING=OFF -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk
  $ cmake --build /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-markdown
  $ cmake --install /private/tmp/neovim-20241014-59765-vs8k2v/deps-build/build/treesitter-markdown

  # nvim
  $ cmake -S . \
          -B build \
          -DLUV_LIBRARY=/usr/local/opt/luv/lib/libluv.dylib \
          -DLIBUV_LIBRARY=/usr/local/opt/libuv/lib/libuv.dylib \
          -DLPEG_LIBRARY=/usr/local/opt/lpeg/lib/liblpeg.dylib \
          -DCMAKE_INSTALL_PREFIX=/usr/local/Cellar/neovim/HEAD-4846bf0_1 \
          -DCMAKE_INSTALL_LIBDIR=lib \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_FIND_FRAMEWORK=LAST \
          -DCMAKE_VERBOSE_MAKEFILE=ON \
          -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=/usr/local/Homebrew/Library/Homebrew/cmake/trap_fetchcontent_provider.cmake \
          -Wno-dev \
          -DBUILD_TESTING=OFF \
          -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk
  $ cmake --build build
  ```
  <!--endsec-->

### windows

- dependencies

  > [!NOTE|label:references:]
  > - [Windows Install MSVC and clang](https://gist.github.com/mcandre/5ceb67ad44f6b974d33bcddedcb16e89)

  - C Compiler
    - llvm
      ```powershell
      # C:\Program Files\LLVM\bin
      > choco install llvm

      # https://gist.github.com/mcandre/5ceb67ad44f6b974d33bcddedcb16e89
      > choco install cmake
      ```

    - mingw

      > [!TIP|label:packages:]
      > - [mingw 64 bit: x86_64-13.2.0-release-posix-seh-ucrt-rt_v11-rev0.7z](https://github.com/niXman/mingw-builds-binaries/releases/download/13.2.0-rt_v11-rev0/x86_64-13.2.0-release-posix-seh-ucrt-rt_v11-rev0.7z)

      ```powershell
      # C:\ProgramData\mingw64\mingw64
      > choco install mingw
      ```

    - msvc

      > [!TIP|label:packages:]
      > - [visualstudio2022buildtools](https://download.visualstudio.microsoft.com/download/pr/db4c3f2d-694d-406b-8fb6-1924f3fc3580/02f7788cb00c9e0aa87ce0c1e923f7b12921aa1f06d9f78261ee0e3e5c794332/vs_BuildTools.exe)
      >   - `chocolatey-dotnetfx.extension`: `C:\ProgramData\chocolatey\extensions\chocolatey-dotnetfx`
      >   - `dotnetfx`
      > - references:
      >   - [Clang/LLVM support in Visual Studio projects](https://learn.microsoft.com/en-us/cpp/build/clang-support-msbuild?view=msvc-170)

      ```powershell
      # C:\Program Files (x86)\Microsoft Visual Studio\Installer
      > choco install visualstudio2022buildtools

      # former version
      > choco install visualstudio2019buildtools

      # for clang/llvm installation
      # C:\Program Files (x86)\Microsoft Visual Studio\Installer
      > choco install visualstudio-installer
      ```
- nvim
  ```batch
  > curl -fsSL -O https://github.com/neovim/neovim/releases/latest/download/nvim-win64.msi
  REM install via msiexec as administrator
  > msiexec /i nvim-setup.exe [/quiet] [/passive] [/norestart] [/log <log file>] [/l* <log file>]
  ```

## neovim-nightly

> [!NOTE|label:references:]
> - [#28125 No parser for 'lua' language when opening a lua file](https://github.com/neovim/neovim/issues/28125)
> - [benjiwolff/homebrew-neovim-nightly](https://github.com/benjiwolff/homebrew-neovim-nightly)
> - [01. `brew install neovim-nightly -v --debug`.md](https://gist.github.com/marslo/540d3462b2b9d117083e0b6346426308#file-01-brew-install-neovim-nightly-v-debug-md)

```bash
$ brew unlink neovim
Unlinking /usr/local/Cellar/neovim/HEAD-f494084... 35 symlinks removed.

$ brew tap benjiwolff/neovim-nightly
$ brew install neovim-nightly [ -v --debug ]

# verify
$ /usr/local/Caskroom/neovim-nightly/nightly-7aa5637/nvim-macos-x86_64/bin/nvim -V1 -v
NVIM v0.10.0-dev-2867+g7aa56370f
Build type: RelWithDebInfo
LuaJIT 2.1.1710088188
Compilation: /Applications/Xcode_14.2.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc -O2 -g -Og -g -flto=thin -Wall -Wextra -pedantic -Wno-unused-parameter -Wstrict-prototypes -std=gnu99 -Wshadow -Wconversion -Wvla -Wdouble-promotion -Wmissing-noreturn -Wmissing-format-attribute -Wmissing-prototypes -fsigned-char -fstack-protector-strong -Wimplicit-fallthrough -fdiagnostics-color=always -Wl,-export_dynamic -DUNIT_TESTING -DHAVE_UNIBILIUM -D_GNU_SOURCE -DINCLUDE_GENERATED_DECLARATIONS -I/Users/runner/work/neovim/neovim/.deps/usr/include/luajit-2.1 -I/Users/runner/work/neovim/neovim/.deps/usr/include -I/Users/runner/work/neovim/neovim/build/src/nvim/auto -I/Users/runner/work/neovim/neovim/build/include -I/Users/runner/work/neovim/neovim/build/cmake.config -I/Users/runner/work/neovim/neovim/src -I/Applications/Xcode_14.2.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.1.sdk/usr/include

   system vimrc file: "$VIM/sysinit.vim"
  fall-back for $VIM: "/usr/local/share/nvim"

Run :checkhealth for more info
```

- `No such file or directory @ rb_file_s_rename`

  > [!TIP|label:failure details]
  > ```bash
  > error: benjiwolff/neovim-nightly/neovim-nightly: No such file or directory @ rb_file_s_rename - (/usr/local/Caskroom/neovim-nightly/nightly-7aa5637, /usr/local/Caskroom/neovim-nightly/nightly-7aa5637.upgrading)
  > ```

  ```bash
  # solution
  $ brew remove neovim-nightly
  $ rm -rf /usr/local/Caskroom/neovim-nightly

  $ brew install neovim-nightly [ -v --debug --display-times ]
  ```

# initialize and configure

> [!TIP]
> - [Transitioning from Vim](https://neovim.io/doc/user/nvim.html#nvim-from-vim)
> - [vim学习](https://www.kancloud.cn/jiangguowu/vimlearn/1859976)
> - [学习 Neovim 全 lua 配置](https://zhuanlan.zhihu.com/p/571617696)
> - [My Neovim setup for React, TypeScript, Tailwind CSS, etc](https://blog.inkdrop.app/my-neovim-setup-for-react-typescript-tailwind-css-etc-in-2022-a7405862c9a4)
> - [NeoVim for Java Development (COC)](https://javadev.org/devtools/ide/neovim/coc/)
> - [nanotee/nvim-lua-guide](https://github.com/nanotee/nvim-lua-guide)
> - [nshen/learn-neovim-lua](https://github.com/nshen/learn-neovim-lua)
>   - [Neovim 代码高亮插件 nvim-treesitter 的安装与配置](https://www.zhihu.com/tardis/bd/art/441818052?source_id=1001)
>   - [Neovim 内置 LSP 配置 (二)：自动代码补全](https://zhuanlan.zhihu.com/p/445331508)
> - [nshen/InsisVim](https://github.com/nshen/InsisVim)
> - [fanxy1/nvim-dotfile](https://github.com/fanxy1/nvim-dotfile)
> - [Java in Neovim](https://www.chiarulli.me/Neovim/24-neovim-and-java/)
> - [Integralist/dotfiles](https://github.com/Integralist/dotfiles)
>   - [Integralist/nvim](https://github.com/Integralist/nvim)
> - [m4xshen/dotfiles/nvim/nvim](https://github.com/m4xshen/dotfiles/tree/main/nvim/nvim)
> - [Neovim for Beginners — LSP Inlay Hints](https://alpha2phi.medium.com/neovim-for-beginners-lsp-inlay-hints-bf4a8afa6f27)

## [provider](https://neovim.io/doc/user/provider.html)

> `:checkhealth`

```bash
$ python3 -m pip install --user --upgrade pynvim
$ gem install neovim
$ npm install -g neovim
```

- for venv
  ```bash
  $ python3 -m pip install --upgrade pynvim

  # verify
  $ command python3 -c 'import sys; sys.path = [p for p in sys.path if p != ""]; import neovim; print(neovim.__file__)'

  # to list all packages
  $ pip list -v
  ```

## init.vim/init.lua

> [!NOTE|label:references:]
> - [Everything you need to know to configure neovim using lua](https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/)
> - [Porting neovim config to lua](https://www.adrian.idv.hk/2022-05-07-nvim-lua/)
> - [nanotee/nvim-lua-guide](https://github.com/nanotee/nvim-lua-guide)
> - [dotfiles/.config/nvim/init.lua](https://github.com/fsareshwala/dotfiles/blob/master/.config/nvim/init.lua)
> - [web-dev.nvim/src/init.lua](https://github.com/jonathandion/web-dev.nvim/blob/main/src/init.lua)
> - config:
>   - [bdryanovski/dotfiles/packages/vim](https://github.com/bdryanovski/dotfiles/tree/master/packages/vim)
>   - [skbolton/titan/nvim](https://github.com/skbolton/titan/tree/b6c44d3c9b6aab2ae011d6072ca0e2a5a254a82a/nvim)

- create init.vim
  ```vim
  :exe 'edit '.stdpath('config').'/init.vim'
  :write ++p
  ```

- init.lua
  ```lua
  -- ~/.config/nvim/init.lua
  vim.cmd( 'set runtimepath^=~/.vim runtimepath+=~/.vim/after' )
  vim.cmd( 'let &packpath = &runtimepath' )
  vim.cmd( 'source ~/.vimrc' )
  vim.cmd( 'autocmd TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false}' )
  ```

- init.vim
  ```vim
  # ~/.config/nvim/init.vim
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vimrc
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false}
  ```

## config

> [!NOTE|label:references:]
> - [How Did I Setup NeoVim for Rust](https://medium.com/swlh/how-did-i-setup-neovim-for-rust-1763eb2ef98c)
> - [Michał Mieszczak/.dotfiles/.config/nvim](https://gitlab.com/LongerHV/.dotfiles/-/tree/master/.config/nvim)
> - [nathanmsmith/nvim-ale-diagnostic](https://github.com/nathanmsmith/nvim-ale-diagnostic)
> - [LexSong/nvim](https://github.com/LexSong/nvim)
> - [* How to Configure Neovim to make it Amazing -- complete tutorial](https://www.youtube.com/watch?v=J9yqSdvAKXY)
>   - [cpow/cpow-dotfiles](https://github.com/cpow/cpow-dotfiles/tree/master)
> - youtube courses
>   - [Neovim for Newbs. FREE NEOVIM COURSE](https://www.youtube.com/playlist?list=PLsz00TDipIffreIaUNk64KxTIkQaGguqn)
>   - [Neovim Configuration](https://www.youtube.com/playlist?list=PLsz00TDipIffxsNXSkskknolKShdbcALR)

- check status
  ```vim
  :checkhealth
  ```

### `config.lua`

> [!NOTE|label:references:]
> - [NeoVim not loading init.vim file](https://stackoverflow.com/a/75351106/2940319)

```bash
$ cat ~/.config/nvim/lua/config.lua
lua require('config')
```

### standard-path

> [!NOTE|label:references:]
> - [`:help standard-path`](https://neovim.io/doc/user/starting.html#standard-path)
> - [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
> - get data
>   ```vim
>   :echo stdpath("xxx")
>
>   " i.e.:
>   :echo stdpath('config')
>   /Users/marslo/.config/nvim
>   ```
> - using in `init.lua`
>   ```vim
>   -- ~/.config/nvim/init.lua
>   -- to setup undodir to `$HOME/.config/nvim/undo`. debug via `:verbose set undodir`
>   vim.opt.undodir = vim.fn.stdpath('config') .. '/undo'
>   -- or specific path
>   vim.opt.undodir = vim.fn.expand( '~/.vim/undo' )
>   ```

|           NAME           | LINUX/OSX                                      | WINDOWS                        |
|:------------------------:|------------------------------------------------|--------------------------------|
|    `stdpath("config")`   | `$HOME/.config/nvim`                           | `%LOCALAPPDATA%\nvim`          |
|     `stdpath("data")`    | `$HOME/.local/share/nvim`                      | `%LOCALAPPDATA%\nvim-data`     |
|    `stdpath("state")`    | `$HOME/.local/state/nvim`                      | `%LOCALAPPDATA%\nvim-data`     |
|    `stdpath("cache")`    | `$HOME/.cache/nvim`                            | `%LOCALAPPDATA%\Temp\nvim`     |
|     `stdpath("log")`     | `$HOME/.local/state/nvim/log`                  | `%LOCALAPPDATA%\nvim-data\log` |
| `stdpath("config_dirs")` | `['/etc/xdg/nvim']`                            | -                              |
|  `stdpath("data_dirs")`  | `['/usr/local/share/nvim', '/usr/share/nvim']` | -                              |


- using linux slash in windows system

  > [!NOTE|label:references:]
  > - [#13787 - stdpath() returns mixed path separators with shellslash option](https://github.com/neovim/neovim/issues/13787#issue-788571043)

  ```vim
  :set shellslash
  :echo stdpath('data')
  C:/Users/marslo/Appdata/Local/nvim-data
  ```

### list parser paths
```vim
:echo nvim_get_runtime_file('parser/*.so', v:true)
['/Users/marslo/.vim/plugged/nvim-treesitter/parser/bash.so', '/Users/marslo/.vim/plugged/nvim-treesitt
er/parser/c.so', '/Users/marslo/.vim/plugged/nvim-treesitter/parser/cmake.so', '/Users/marslo/.vim/plug
ged/nvim-treesitter/parser/css.so', '/Users/marslo/.vim/plugged/nvim-treesitter/parser/diff.so', '/User
s/marslo/.vim/plugged/nvim-treesitter/parser/dockerfile.so', '/Users/marslo/.vim/plugged/nvim-treesitte
r/parser/gitcommit.so', '/Users/marslo/.vim/plugged/nvim-treesitter/parser/gitignore.so', '/Users/marsl
o/.vim/plugged/nvim-treesitter/parser/git_config.so', '/Users/marslo/.vim/plugged/nvim-treesitter/parse
r/groovy.so', '/Users/marslo/.vim/plugged/nvim-treesitter/parser/ini.so', '/Users/marslo/.vim/plugged/n
vim-treesitter/parser/java.so', '/Users/marslo/.vim/plugged/nvim-treesitter/parser/jq.so', '/Users/mars
lo/.vim/plugged/nvim-treesitter/parser/json.so', '/Users/marslo/.vim/plugged/nvim-treesitter/parser/lua
.so', '/Users/marslo/.vim/plugged/nvim-treesitter/parser/markdown.so', '/Users/marslo/.vim/plugged/nvim
-treesitter/parser/python.so', '/Users/marslo/.vim/plugged/nvim-treesitter/parser/query.so', '/Users/ma
rslo/.vim/plugged/nvim-treesitter/parser/ssh_config.so', '/Users/marslo/.vim/plugged/nvim-treesitter/pa
rser/vim.so', '/Users/marslo/.vim/plugged/nvim-treesitter/parser/vimdoc.so', '/Users/marslo/.vim/plugge
d/nvim-treesitter/parser/xml.so', '/Users/marslo/.vim/plugged/nvim-treesitter/parser/yaml.so', '/usr/lo
cal/Caskroom/neovim-nightly/latest/nvim-macos-x86_64/lib/nvim/parser/c.so', '/usr/local/Caskroom/neovim
-nightly/latest/nvim-macos-x86_64/lib/nvim/parser/lua.so', '/usr/local/Caskroom/neovim-nightly/latest/n
vim-macos-x86_64/lib/nvim/parser/markdown.so', '/usr/local/Caskroom/neovim-nightly/latest/nvim-macos-x8
6_64/lib/nvim/parser/markdown_inline.so', '/usr/local/Caskroom/neovim-nightly/latest/nvim-macos-x86_64/
lib/nvim/parser/query.so', '/usr/local/Caskroom/neovim-nightly/latest/nvim-macos-x86_64/lib/nvim/parser
/vim.so', '/usr/local/Caskroom/neovim-nightly/latest/nvim-macos-x86_64/lib/nvim/parser/vimdoc.so']
```

## lua

> [!NOTE|label:references]
> - [lua](https://neovim.io/doc/user/lua.html)

### [lua-intro](https://neovim.io/doc/user/lua.html#lua-intro)
```vim
:lua vim.print(package.loaded)
```

### [lua-commands](https://neovim.io/doc/user/lua.html#lua-commands)

```vim
:lua print(_VERSION)
Lua 5.1

:lua =jit.version
LuaJIT 2.1.1703358377
```

## [Tips](https://neovim.io/doc/user/tips.html#tips)

### true color

> [!NOTE|label:references:]
> - [#24760 fix(terminal): preserve $COLORTERM value from outer terminal](https://github.com/neovim/neovim/pull/24760)
> - [#24717 Advertise directcolor support in Neovim terminal](https://github.com/neovim/neovim/issues/24717)

```vim
:echo &termguicolors
1
```

```bash
$ echo $TERM $COLORTERM
xterm-256color truecolor
```

- force 16 colors
  ```bash
  $ TERM= COLORTERM= nvim
  ```

## config path

> [!NOTE]
> - SYNTAX FILES: `~/.config/nvim/syntax`
> - ruby : `~/.config/nvim/ruby`

# [builtin function details](https://neovim.io/doc/user/builtin.html#builtin-function-details)

#### math
```vim
:echo abs(1.456)
1.456
:echo abs(-5.456)
5.456

:echo acos(0)
1.570796
:echo acos(-0.5)
2.094395

:echo asin(0.8)
0.927295
:echo asin(-0.5)
-0.523599

:echo cosh(0.5)
1.127626
:echo cosh(-0.5)
1.127626

" exponential
:echo exp(2)
7.389056
:echo exp(-1)
0.367879

" x/y
:echo fmod(12.33, 1.22)
0.13

" smallest integral value greater than or equal to {expr} as a Float
:echo ceil(1.456)
2.0
:echo ceil(-5.456)
-5.0

" largest integral value less than or equal to
:echo floor(1.856)
1.0
:echo floor(-5.456)
-6.0
```

#### assert
```vim
:echo assert_equal('foo', 'bar')
1

:echo assert_match('^f.*o$', 'foobar')
1
```

#### list
```vim
:echo blob2list(0z0102.0304)
[1, 2, 3, 4]
:echo blob2list(0z)
[]
```

- exists
  ```vim
  :let l = [1, 2, 3]
  :echo exists("l[5]")
  0
  :echo exists("l[2]")
  1
  ```

- basic
  ```vim
  :let newlist = [1, 2, 3] + [4, 5]
  :echo newlist
  [1, 2, 3, 4, 5]
  :call extend(newlist, [2, 3], 1)
  :echo newlist
  [1, 2, 3, 2, 3, 4, 5]

  " sort
  :echo sort(extend(newlist, [7, 5]))
  [1, 2, 3, 4, 5, 5, 7]

  " flatten
  :echo flatten([1, [2, [3, 4]], 5])
  [1, 2, 3, 4, 5]
  :echo flatten([1, [2, [3, 4]], 5], 1)
  [1, 2, [3, 4], 5]
  ```

#### system
- api info
  ```vim
  :lua vim.print(vim.fn.api_info())
  {
    error_types = {
      Exception = {
        id = 0
      },
      Validation = {
        id = 1
      }
    },
    ...
  }
  ```

- exists
  ```vim
  :echo exists("&mouse")
  1
  :echo exists("$HOSTNAME")
  0
  :echo exists("*strftime")
  1
  :echo exists("*s:MyFunc")
  0
  :echo exists("*MyFunc")
  0
  :echo exists("*v:lua.Func")
  0
  :echo exists("bufcount")
  0
  :echo exists(":Make")
  0
  :echo exists(":make")
  2
  :echo exists("#CursorHold")
  1
  :echo exists("#BufReadPre#*.gz")
  1
  :echo exists("#filetypeindent")
  1
  :echo exists("#filetypeindent#FileType")
  1
  :echo exists("#filetypeindent#FileType#*")
  1
  :echo exists("##ColorScheme")
  1
  ```

- file
  ```vim
  :echo filereadable('~/.vimrc')
  0
  :echo filereadable(expand('~/.vimrc'))
  1

  " get first line
  :getline(1)
  <!-- START doctoc generated TOC please keep comment here to allow auto update -->
  " get current line
  :echo getline(".")

  " get matches
  :echo getmatches()
  " more
  :let m = getmatches()
  :call clearmatches()
  :echo getmatches()
  ```

- returns the character index of the column position
  ```vim
  "                + cursor
  "                v
  :echo charcol('.')
  22
  :echo col('.')
  22
  ```

- line length
  ```vim
  " corsor can be anywhere of following line
  :echo col("$")
  17
  ```

- env
  ```vim
  :echo has_key(environ(), 'HOME')
  1
  :echo index(keys(environ()), 'HOME', 0, 1) != -1
  1

  :echo escape('c:\program files\vim', ' \')
  c:\\program\ files\\vim
  ```

- execute
  ```vim
  :echo execute('echon "foo"')
  foo

  :echo execute(['echon "foo"', 'echon "bar"'])
  foobar

  :echo execute('args')->split("\n")
  ['[nvim.md] ']
  ```

- path
  ```vim
  :echo expandcmd('make %<.o')
  make nvim.o
  :echo expandcmd('make %<.o', {'errmsg': v:true})
  make nvim.o

  :echo fnameescape('+some str%nge|name')
  \+some\ str\%nge\|name
  :let fname = '+some str%nge|name'
  :exe "edit " .. fnameescape(fname)

  :echo fnamemodify("main.c", ":p:h")
  /home/marslo/ibook/docs/vim
  ```

#### others
- buffer name
  ```bash
  :echo bufname("#")
  nvim.md

  :echo bufname("#")
  cmd
  ```

- buffer number
  ```vim
  :echo "A window containing buffer 1 is " .. (bufwinnr(1))
  A window containing buffer 1 is 1

  :echo "A window containing buffer 1 is " .. (bufwinid(1))
  A window containing buffer 1 is 1000
  ```

- others
  ```vim
  :echo byteidx('a😊😊', 2)
  5
  :echo byteidx('a😊😊', 2, 1)
  1
  :echo byteidx('a😊😊', 3, 1)
  5

  :let s = 'e' .. nr2char(0x301)
  :echo byteidx(s, 1)
  3
  :echo byteidxcomp(s, 1)
  1
  :echo byteidxcomp(s, 2)
  3
  ```

# [various commands](https://neovim.io/doc/user/various.html#various-cmds)
