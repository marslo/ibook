<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [install](#install)
  - [dependencies](#dependencies)
  - [Nvim development (prerelease) build](#nvim-development-prerelease-build)
  - [building neovim from source](#building-neovim-from-source)
  - [package manager](#package-manager)
    - [`brew install -v --debug`](#brew-install--v---debug)
  - [neovim-nightly](#neovim-nightly)
- [initialize](#initialize)
  - [provider](#provider)
  - [init.vim/init.lua](#initviminitlua)
  - [config](#config)
    - [`config.lua`](#configlua)
    - [standard-path](#standard-path)
  - [lua](#lua)
    - [lua-intro](#lua-intro)
    - [lua-commands](#lua-commands)
  - [Tips](#tips)
    - [true color](#true-color)
  - [config path](#config-path)

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

## [Nvim development (prerelease) build](https://github.com/neovim/neovim/releases/nightly)

- tarball

  > [!TIP]
  > - osx: avoid `unknown developer` warning
  >   ```bash
  >   $ xattr -c ./nvim-macos.tar.gz
  >   ```

  ```bash
  $ curl -fsSL https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz | tar xzf - -C /opt/nvim
  $ /opt/nvim/nvim-macos/bin/nvim
  $ sudo ln -sf /opt/nvim/nvim-macos /usr/local/nvim

  $ export NVIM_HOME=/usr/local/nvim
  $ export PATH=$NVIM_HOME/bin:$PATH
  ```

## building neovim from source

> [!NOTE|label:references:]
> - [Building Neovim from source](https://dev.to/asyncedd/building-neovim-from-source-1794)

## package manager
```bash
# osx
$ brew install nvim

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
$ curl -fsSL -O http://archive.ubuntu.com/ubuntu/pool/universe/n/neovim/neovim_0.7.2-8_amd64.deb
$ sudo dpkg -i neovim_0.7.2-8_amd64.deb
```

### `brew install -v --debug`
```bash
# download
$ /usr/bin/env /usr/local/Homebrew/Library/Homebrew/shims/shared/curl --disable --cookie /dev/null --globoff --show-error --user-agent Homebrew/4.2.17-33-g1bbfe76\ \(Macintosh\;\ Intel\ Mac\ OS\ X\ 14.4.1\)\ curl/8.4.0 --header Accept-Language:\ en --retry 3 --fail --location --silent --head https://raw.githubusercontent.com/Homebrew/homebrew-core/841811d678fcfef856f693a2ec90add1625a4c12/Formula/n/neovim.rb
$ /usr/bin/env /usr/local/Homebrew/Library/Homebrew/shims/shared/curl --disable --cookie /dev/null --globoff --show-error --user-agent Homebrew/4.2.17-33-g1bbfe76\ \(Macintosh\;\ Intel\ Mac\ OS\ X\ 14.4.1\)\ curl/8.4.0 --header Accept-Language:\ en --retry 3 --fail --location --silent --head --request GET https://raw.githubusercontent.com/Homebrew/homebrew-core/841811d678fcfef856f693a2ec90add1625a4c12/Formula/n/neovim.rb
# clone
$ /usr/bin/env git --git-dir /Users/marslo/Library/Caches/Homebrew/neovim--git/.git status -s
$ /usr/bin/env git checkout -f master --
$ /usr/bin/env git --git-dir /Users/marslo/Library/Caches/Homebrew/neovim--git/.git show -s --format=\%cD
Wed, 10 Apr 2024 07:08:49 +0800

# build
$ cmake -S . -B build -DLUV_LIBRARY=/usr/local/opt/luv/lib/libluv.dylib -DLIBUV_LIBRARY=/usr/local/opt/libuv/lib/libuv.dylib -DLPEG_LIBRARY=/usr/local/opt/lpeg/lib/liblpeg.dylib -DCMAKE_INSTALL_PREFIX=/usr/local/Cellar/neovim/HEAD-f494084 -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -Wno-dev -DBUILD_TESTING=OFF -DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk
$ cmake --build build
$ cmake --install build
```

## neovim-nightly

> [!NOTE|label:references:]
> - [#28125 No parser for 'lua' language when opening a lua file](https://github.com/neovim/neovim/issues/28125)
> - [benjiwolff/homebrew-neovim-nightly](https://github.com/benjiwolff/homebrew-neovim-nightly)

```bash
$ brew unlink neovim
Unlinking /usr/local/Cellar/neovim/HEAD-f494084... 35 symlinks removed.

$ brew tap benjiwolff/neovim-nightly
```

# initialize

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

## init.vim/init.lua
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
