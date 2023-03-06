<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [OSX](#osx)
  - [installation](#installation)
- [Linux](#linux)
  - [vim](#vim)
  - [gvim](#gvim)
- [Windows](#windows)
  - [setup environment ( via cygwin )](#setup-environment--via-cygwin-)
  - [gvim.exe](#gvimexe)
  - [vim.exe](#vimexe)
- [plugins](#plugins)
  - [tabnine](#tabnine)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [* travis : vim/vim](https://github.com/vim/vim/blob/dc9f9e93f5229fd4325472ed62e7b17872d64060/.travis.yml)
> - [* travis : macvim-dev/macvim](https://app.travis-ci.com/github/macvim-dev/macvim/jobs/460902505)
> - [* Compile Customized Vim on Mac OS](https://leons.im/posts/compile-customized-vim-on-mac-os/)
> - [* vim/src/INSTALLmac.txt](https://github.com/vim/vim/blob/master/src/INSTALLmac.txt)
> - [* script to build vim in mac](https://raw.githubusercontent.com/marslo/myvim/master/script/.build.vim.mac)
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


<!--sec data-title="config help" data-id="section0" data-show=true data-collapse=true ces-->
```bash
$ ./configure --help
`configure' configures this package to adapt to many kinds of systems.

Usage: auto/configure [OPTION]... [VAR=VALUE]...

To assign environment variables (e.g., CC, CFLAGS...), specify them as
VAR=VALUE.  See below for descriptions of some of the useful variables.

Defaults for the options are specified in brackets.

Configuration:
  -h, --help              display this help and exit
      --help=short        display options specific to this package
      --help=recursive    display the short help of all the included packages
  -V, --version           display version information and exit
  -q, --quiet, --silent   do not print `checking ...' messages
      --cache-file=FILE   cache test results in FILE [disabled]
  -C, --config-cache      alias for `--cache-file=config.cache'
  -n, --no-create         do not create output files
      --srcdir=DIR        find the sources in DIR [configure dir or `..']

Installation directories:
  --prefix=PREFIX         install architecture-independent files in PREFIX
                          [/usr/local]
  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
                          [PREFIX]

By default, `make install' will install all the files in
`/usr/local/bin', `/usr/local/lib' etc.  You can specify
an installation prefix other than `/usr/local' using `--prefix',
for instance `--prefix=$HOME'.

For better control, use the options below.

Fine tuning of the installation directories:
  --bindir=DIR            user executables [EPREFIX/bin]
  --sbindir=DIR           system admin executables [EPREFIX/sbin]
  --libexecdir=DIR        program executables [EPREFIX/libexec]
  --sysconfdir=DIR        read-only single-machine data [PREFIX/etc]
  --sharedstatedir=DIR    modifiable architecture-independent data [PREFIX/com]
  --localstatedir=DIR     modifiable single-machine data [PREFIX/var]
  --libdir=DIR            object code libraries [EPREFIX/lib]
  --includedir=DIR        C header files [PREFIX/include]
  --oldincludedir=DIR     C header files for non-gcc [/usr/include]
  --datarootdir=DIR       read-only arch.-independent data root [PREFIX/share]
  --datadir=DIR           read-only architecture-independent data [DATAROOTDIR]
  --infodir=DIR           info documentation [DATAROOTDIR/info]
  --localedir=DIR         locale-dependent data [DATAROOTDIR/locale]
  --mandir=DIR            man documentation [DATAROOTDIR/man]
  --docdir=DIR            documentation root [DATAROOTDIR/doc/PACKAGE]
  --htmldir=DIR           html documentation [DOCDIR]
  --dvidir=DIR            dvi documentation [DOCDIR]
  --pdfdir=DIR            pdf documentation [DOCDIR]
  --psdir=DIR             ps documentation [DOCDIR]

X features:
  --x-includes=DIR    X include files are in DIR
  --x-libraries=DIR   X library files are in DIR

Optional Features:
  --disable-option-checking  ignore unrecognized --enable/--with options
  --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
  --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
  --enable-fail-if-missing    Fail if dependencies on additional features
     specified on the command line are missing.
  --disable-darwin        Disable Darwin (Mac OS X) support.
  --disable-smack   Do not check for Smack support.
  --disable-selinux   Do not check for SELinux support.
  --disable-xsmp          Disable XSMP session management
  --disable-xsmp-interact Disable XSMP interaction
  --enable-luainterp=OPTS      Include Lua interpreter.  default=no OPTS=no/yes/dynamic
  --enable-mzschemeinterp      Include MzScheme interpreter.
  --enable-perlinterp=OPTS     Include Perl interpreter.  default=no OPTS=no/yes/dynamic
  --enable-pythoninterp=OPTS   Include Python interpreter. default=no OPTS=no/yes/dynamic
  --enable-python3interp=OPTS  Include Python3 interpreter. default=no OPTS=no/yes/dynamic
  --enable-tclinterp=OPTS      Include Tcl interpreter. default=no OPTS=no/yes/dynamic
  --enable-rubyinterp=OPTS     Include Ruby interpreter.  default=no OPTS=no/yes/dynamic
  --enable-cscope         Include cscope interface.
  --disable-netbeans      Disable NetBeans integration support.
  --disable-channel       Disable process communication support.
  --enable-terminal       Enable terminal emulation support.
  --enable-autoservername Automatically define servername at vim startup.
  --enable-multibyte      Include multibyte editing support.
  --disable-rightleft     Do not include Right-to-Left language support.
  --disable-arabic        Do not include Arabic language support.
  --disable-farsi         Deprecated.
  --enable-xim            Include XIM input support.
  --enable-fontset        Include X fontset output support.
  --enable-gui=OPTS       X11 GUI. default=auto OPTS=auto/no/gtk2/gnome2/gtk3/motif/haiku/photon/carbon
  --enable-gtk2-check     If auto-select GUI, check for GTK+ 2 default=yes
  --enable-gnome-check    If GTK GUI, check for GNOME default=no
  --enable-gtk3-check     If auto-select GUI, check for GTK+ 3 default=yes
  --enable-motif-check    If auto-select GUI, check for Motif default=yes
  --disable-gtktest       Do not try to compile and run a test GTK program
  --disable-icon-cache-update        update disabled
  --disable-desktop-database-update  update disabled
  --disable-largefile     omit support for large files
  --disable-canberra      Do not use libcanberra.
  --disable-libsodium      Do not use libsodium.
  --disable-acl           No check for ACL support.
  --enable-gpm=OPTS       Use gpm (Linux mouse daemon). default=yes OPTS=yes/no/dynamic
  --disable-sysmouse      Don't use sysmouse (mouse in *BSD console).
  --disable-nls           Don't support NLS (gettext()).

Optional Packages:
  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
  --with-mac-arch=ARCH    current, intel, ppc or both
  --with-developer-dir=PATH    use PATH as location for Xcode developer tools
  --with-local-dir=PATH   search PATH instead of /usr/local for local libraries.
  --without-local-dir     do not search /usr/local for local libraries.
  --with-vim-name=NAME    what to call the Vim executable
  --with-ex-name=NAME     what to call the Ex executable
  --with-view-name=NAME   what to call the View executable
  --with-global-runtime=DIR    global runtime directory in 'runtimepath', comma-separated for multiple directories
  --with-modified-by=NAME       name of who modified a release version
  --with-features=TYPE    tiny, normal or huge (default: huge)
  --with-compiledby=NAME  name to show in :version message
  --with-lua-prefix=PFX   Prefix where Lua is installed.
  --with-luajit           Link with LuaJIT instead of Lua.
  --with-plthome=PLTHOME   Use PLTHOME.
  --with-python-command=NAME  name of the Python 2 command (default: python2 or python)
  --with-python-config-dir=PATH  Python's config directory (deprecated)
  --with-python3-command=NAME  name of the Python 3 command (default: python3 or python)
  --with-python3-config-dir=PATH  Python's config directory (deprecated)
  --with-tclsh=PATH       which tclsh to use (default: tclsh8.0)
  --with-ruby-command=RUBY  name of the Ruby command (default: ruby)
  --with-x                use the X Window System
  --with-gnome-includes=DIR Specify location of GNOME headers
  --with-gnome-libs=DIR   Specify location of GNOME libs
  --with-gnome            Specify prefix for GNOME files
  --with-motif-lib=STRING Library for Motif
  --with-tlib=library     terminal library to be used

Some influential environment variables:
  CC          C compiler command
  CFLAGS      C compiler flags
  LDFLAGS     linker flags, e.g. -L<lib dir> if you have libraries in a
              nonstandard directory <lib dir>
  LIBS        libraries to pass to the linker, e.g. -l<library>
  CPPFLAGS    (Objective) C/C++ preprocessor flags, e.g. -I<include dir> if
              you have headers in a nonstandard directory <include dir>
  CPP         C preprocessor
  XMKMF       Path to xmkmf, Makefile generator for X Window System

Use these variables to override the choices made by `configure' or to help
it to find libraries and programs with nonstandard names/locations.

Report bugs to the package provider.
```
<!--endsec-->

```bash
# optional
$ NPROC=$(getconf _NPROCESSORS_ONLN)

$ make distclean && make clean

$ ./configure --with-features=huge \
              --enable-rubyinterp \
              --enable-python3interp \
              --with-python3-config-dir=$(python3-config --configdir) \
              --enable-luainterp \
              --with-lua-prefix=/usr/local \
              --enable-libsodium \
              --enable-multibyte \
              --with-tlib=ncurses \
              --enable-terminal \
              --enable-autoservername \
              --enable-nls \
              --with-macarchs=x86_64 \
              --with-compiledby="marslo <marslo.jiao@gmail.com>" \
              --prefix=/usr/local/vim \
              --exec-prefix=/usr/local/vim \
              --enable-fail-if-missing

## ... build ...
$ make
# or
$ make -j${NPROC}

## ... install ...
$ sudo make install
# or uninstall if necessary
$ sudo make uninstall && sudo make install

## ... validate ...
$ src/vim --version
$ make indenttest
$ make -C runtime/doc vimtags VIMEXE=../../src/vim

## ... check object files ...
$ otool -L "src/vim" |  grep '\.dylib\s' | grep -v '^\s*/usr/lib/'
$ lipo -archs "src/vim" | grep '^x86_64$'

## ... check language support ...
macvim_excmd() {
  ./src/vim -u NONE -i NONE -f -X -V1 -es "$@" -c 'echo ""' -c 'qall!' 2>&1
}
macvim_excmd -c 'lua print("Test")'
macvim_excmd -c 'perl VIM::Msg("Test")'
macvim_excmd -c 'py3 import sys; print("Test")'
macvim_excmd -c 'ruby puts("Test")'
macvim_excmd -c 'lang es_ES' -c 'version' | grep Enlazado
```

- additonal options
  - `--enable-fontset           # no GUI selected; xim has been disabled`
  - `--enable-xim               # no GUI selected; xim has been disabled`
  - `--enable-perlinterp`
  - `--enable-tclinterp`
  - `--enable-rubyinterp`
  - `--with-python3-command=python  # using :python instead of :py`
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


## Linux

### vim
```bash
#!/bin/bash

VIM_SRC=$(dirname $(readlink -f $0))/vimsrc

if [ ! -d "$VIM_SRC" ]; then
  echo "Bad VIM source path. Exit."
  exit 1
fi

pushd $VIM_SRC
git clean -dffx *
git checkout -- *
make clean distclean

git pull
./configure --prefix=$HOME/.marslo/myprograms/vim74 \
            --enable-pythoninterp=yes \
            --with-python-config-dir=/usr/local/lib/python2.7/config \
            --enable-rubyinterp=yes \
            --with-features=huge \
            --disable-smack \
            --enable-fail-if-missing \
            --with-compiledby=marslo@appliance > vim-build.log

make -j3 >> vim-build.log
make install >> vim-build.log

popd
```

### gvim
```bash
#!/bin/bash

VIM_SRC=$(dirname $(readlink -f $0))/vimsrc

if [ ! -d "$VIM_SRC" ]; then
  echo "Bad VIM source path. Exit."
  exit 1
fi

pushd ${VIM_SRC}
git clean -dffx *
git checkout -- *
make clean distclean

git pull
./configure --enable-gui=gnome2 \
            --enable-cscope \
            --enable-multibyte \
            --enable-xim \
            --enable-fontset \
            --with-features=huge \
            --enable-pythoninterp=yes \
            --enable-rubyinterp=yes \
            --enable-python3interp=yes \
            --disable-smack \
            --enable-fail-if-missing \
            --with-compiledby=marslo@china \
            --prefix=/home/marslo/.vim/tools > vim-build.log
make -j3 >> vim-build.log
make install >> vim-build.log

popd
```

## Windows

> [!NOTE]
> by cygwin


### setup environment ( via cygwin )
- mandatory
  - `gcc`
  - `gcc-g++`
  - `make`
  - `ncurses`
  - `bc` (Math)

- optional
  - `Flex`
  - `bison`
  - `gettext`
  - `gettext-devel`
  - `textinfo`

- other
  - `wget`
  - `curl`
  - `tree`
  - `rsync`
  - `scp`
  - `lynx`

#### using apt-cyg to install cygwin package
```bash
$ wget http://rawgit.com/transcode-open/apt-cyg/master/apt-cyg
$ mv apt-cyg{.txt,}
$ install apt-cyg /bin
```

### gvim.exe
```batch
> make -B \
       -f Make_cyg.mak \
       PYTHON=/cygdrive/c/Marslo/MyProgramFiles/Python27 \
       DYNAMIC_PYTHON=yes \
       PYTHON_VER=27 \
       PYTHON3=/cygdrive/c/Marslo/MyProgramFiles/Python35 \
       DYNAMIC_PYTHON3=yes \
       PYTHON3_VER=35 \
       FEATURES=huge \
       IME=yes \
       GIME=yes \
       MBYTE=yes \
       CSCOPE=yes \
       USERNAME=Marslo.Jiao \
       USERDOMAIN=China \
       GUI=yes
```

### vim.exe
```batch
> make -B \
       -f Make_cyg.mak \
       PYTHON=/cygdrive/c/Marslo/MyProgramFiles/Python27 \
       DYNAMIC_PYTHON=yes \
       PYTHON_VER=27 \
       PYTHON3=/cygdrive/c/Marslo/MyProgramFiles/Python35 \
       DYNAMIC_PYTHON3=yes \
       PYTHON3_VER=35 \
       FEATURES=huge \
       IME=yes \
       GIME=yes \
       MBYTE=yes \
       CSCOPE=yes \
       USERNAME=Marslo.Jiao \
       USERDOMAIN=China \
       GUI=no
```

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
  - caused by enabled `--enable-cscope`
  - ~~`$ sudo make uninstall && sudo make install`~~
