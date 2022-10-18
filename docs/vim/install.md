<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [OSX](#osx)
  - [installation](#installation)
- [ubuntu](#ubuntu)
- [windows](#windows)
- [plugins](#plugins)
  - [tabnine](#tabnine)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [* travis : vim/vim](https://github.com/vim/vim/blob/dc9f9e93f5229fd4325472ed62e7b17872d64060/.travis.yml)
> - [* travis : macvim-dev/macvim](https://app.travis-ci.com/github/macvim-dev/macvim/jobs/460902505)
> - [* Compile Customized Vim on Mac OS](https://leons.im/posts/compile-customized-vim-on-mac-os/)
> - [* vim/src/INSTALLmac.txt](https://github.com/vim/vim/blob/master/src/INSTALLmac.txt)
> - [Compiling Vim](https://richrose.dev/posts/linux/vim/vim-compile/)
> - [How to Install Vim 8.2 on CentOS 7](https://phoenixnap.com/kb/how-to-install-vim-centos-7)
> - [notmii/install-vim.sh](https://gist.github.com/notmii/8119955)
> - [Building Vim](https://vim.fandom.com/wiki/Building_Vim)
> - [Build Vim in Windows with Cygwin](https://vim.fandom.com/wiki/Build_Vim_in_Windows_with_Cygwin)
> - [joshukraine/compile-vim.md](https://gist.github.com/joshukraine/b9085aeb3dd762cf1d1e1c356974032f)
> - [Building VIM from source code](https://developpaper.com/building-vim-from-source-code/)
> - [travis CI : vim](https://app.travis-ci.com/github/vim/vim)
> - [configurable.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/configurable.nix)
> - [How can I fix this error when making vim on Fedora 23](https://stackoverflow.com/q/34975039/2940319)
{% endhint %}

## OSX
### installation

> [!TIP]
> ```bash
> $ brew install pcre2 gettext libtool
> ```
> tips:
> - [os_mac.txt](https://vimhelp.org/os_mac.txt.html)
>   - `--disable-darwin` will make `-clipboard`

```bash
# optional
$ NPROC=$(getconf _NPROCESSORS_ONLN)

$ make distclean && make clean
$ ./configure --enable-rubyinterp \
              --enable-python3interp \
              --with-python3-config-dir=$(python3-config --configdir) \
              --enable-luainterp \
              --with-lua-prefix=/usr/local \
              --enable-libsodium \
              --with-features=huge \
              --enable-multibyte \
              --with-tlib=ncurses \
              --enable-terminal \
              --enable-autoservername \
              --enable-fontset \
              --enable-xim \
              --enable-nls \
              --with-compiledby="marslo <marslo.jiao@gmail.com>" \
              --enable-fail-if-missing

$ make [-j${NPROC}] && sudo make install
```

- additonal options
  - `--enable-perlinterp`
  - `--enable-tclinterp`
  - `--enable-rubyinterp`
  - `--with-python3-command`
  - `--enable-mzschemeinterp`
  - `--with-mac-arch`
  - `--with-developer-dir`
  - `--with-global-runtime`
  - `--with-modified-by`
  - `--enable-terminal` : `yes`
  - `--enable-browse` : only for [`{Win32, Athena, Motif, GTK and Mac GUI}`](https://groups.google.com/g/vim_use/c/r1cXngmJkrI)

- default options
  - `--with-local-dir` : `/usr/local`
  - `--with-vim-name` : `vim`
  - `--with-ex-name` : `ex`

- dislabed
  - `--disable-smack`
  - `--disable-selinux`
  - `--disable-netbeans` : `no`
  - `--disable-channel` : `no`
  - `--disable-rightleft` : `no`
  - `--disable-arabic` : `no`

- none supported
  - `--with-client-server`
  - `--enable-browse`

- options for GUI

  > [!TIP]
  > references:
  > - [ahmedrmusa/vim--with-x](https://github.com/ahmedrmusa/vim--with-x)
  > - [Vim can't build the athena GUI on macOS High Sierra](https://github.com/vim/vim/issues/2444)

  - `--with-x`
  - `--disable-darwin --enable-gui=athena`
  - `--disable-darwin --with-x --enable-gui=motif`
  - `--disable-darwin --enable-gui=carbon`

  > [!TIP]
  > references:
  > - [Bugreport/Compile Issue >8.1.224 MacOSX, gui_mac.c undefined local symbol](https://www.mail-archive.com/vim_mac@googlegroups.com/msg05361.htm)
  > - [How do I compile vim with the --enable-gui=yes flag on OS X 10.8.2](https://apple.stackexchange.com/a/80463/254265)
  > ```bash
  > export CFLAGS="-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.7.sdk/Developer/Headers/FlatCarbon/"
  > ```
  > <br>
  > in xCode 11.3:
  > - `/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/Headers/CarbonCore.r`
  > - `/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/System/Library/Frameworks/Carbon.framework/Versions/A/Headers/Carbon.h`
  > - `/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/System/Library/Frameworks/Carbon.framework/Versions/A/Headers/Carbon.h`


## ubuntu
## windows

## plugins
### tabnine

- `YouCompleteMe unavailable: module 'collections' has no attribute 'Mapping'`

  > [!TIP]
  > - [Broken on python 3.10 #107](https://github.com/codota/tabnine-vim/issues/107)
  > - [YouCompleteMe#macos](https://github.com/tabnine/YouCompleteMe#macos)
  > <br>
  > python version:
  > ```bash
  > $ python --version
  > Python 3.10.4
  > $ python-config --configdir
  > /usr/local/opt/python@3.10/Frameworks/Python.framework/Versions/3.10/lib/python3.10/config-3.10-darwin
  > ```

  - solution
    ```bash
    # optional
    $ brew install cmake go

    # mandatory
    $ cd ~/.vim/bundle/tabnine-vim
    $ git checkout python3
    $ find . -name "*.pyc" -delete
    $ python3 install.py
    Searching Python 3.10 libraries...
    Found Python library: /usr/local/opt/python@3.10/Frameworks/Python.framework/Versions/3.10/lib/python3.10/config-3.10-darwin/libpython3.10.dylib
    Found Python headers folder: /usr/local/opt/python@3.10/Frameworks/Python.framework/Versions/3.10/include/python3.10
    -- The C compiler identification is AppleClang 12.0.0.12000032
    -- The CXX compiler identification is AppleClang 12.0.0.12000032
    ...
    ```

- `Killed: 9`
  - by enable `--enable-cscope`
