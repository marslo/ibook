<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [install](#install)
  - [Nvim development (prerelease) build](#nvim-development-prerelease-build)
  - [building neovim from source](#building-neovim-from-source)
  - [package manager](#package-manager)
- [initialize](#initialize)
  - [config](#config)
    - [`config.lua`](#configlua)
  - [lua](#lua)
    - [lua-intro](#lua-intro)
    - [lua-commands](#lua-commands)
  - [Tips](#tips)

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
>   - osx/linux: `~/.config/nvim/init.vim`
>   - windows: `%LOCALAPPDATA%\nvim\init.vim`


# install

> [!NOTE]
> - [neovim/INSTALL.md](https://github.com/neovim/neovim/blob/master/INSTALL.md)
> - [#19029 ci: build universal release on macOS](https://github.com/neovim/neovim/pull/19029)

## [Nvim development (prerelease) build](https://github.com/neovim/neovim/releases/nightly)

- tarball
  ```bash
  $ curl -fsSL -O https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
  # avoid `unknown developer` warning
  $ xattr -c ./nvim-macos.tar.gz
  $ tar xzf ./nvim-macos.tar.gz
  # run
  $ ./nvim-macos/bin/nvim
  ```

## building neovim from source

> [!NOTE|label:references:]
> - [Building Neovim from source](https://dev.to/asyncedd/building-neovim-from-source-1794)

## package manager
```bash
# osx
$ brew install nvim
```

# initialize

> [!TIP]
> - [Transitioning from Vim](https://neovim.io/doc/user/nvim.html#nvim-from-vim)

- create init.vim
  ```vim
  :exe 'edit '.stdpath('config').'/init.vim'
  :write ++p
  ```

- add content
  ```vim
  # init.vim
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vimrc
  ```

- config file location
  ```vim
  :echo stdpath('config')
  /Users/marslo/.config/nvim
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
