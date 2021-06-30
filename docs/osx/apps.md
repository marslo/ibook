<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Homebrew](#homebrew)
  - [Homebrew Installation](#homebrew-installation)
  - [Homebrew Caskroom Installation](#homebrew-caskroom-installation)
  - [Package Installation](#package-installation)
  - [check formula config files](#check-formula-config-files)
  - [brew debug](#brew-debug)
  - [tricky](#tricky)
- [system settings](#system-settings)
- [accessory](#accessory)
  - [iTerm2](#iterm2)
  - [BackgroundMusic](#backgroundmusic)
  - [Mac CLI](#mac-cli)
  - [Others](#others)
- [Q&A](#qa)
  - [`Failed to connect to raw.githubusercontent.com port 443: Connection refused`](#failed-to-connect-to-rawgithubusercontentcom-port-443-connection-refused)
  - [failure in `brew search` for cask formula](#failure-in-brew-search-for-cask-formula)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Homebrew
### Homebrew Installation
```bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

#### [homebrewCN](https://gitee.com/Busch/HomebrewCN)
```bash
$ /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
```

#### [homebrew for additional source](https://frankindev.com/2020/05/15/replace-homebrew-source/)
- official
  ```bash
  brew_source='https://github.com/Homebrew'
  # brew 程序本身
  git -C "$(brew --repo)" remote set-url origin ${brew_source}/brew.git

  git -C "$(brew --repo homebrew/core)" remote set-url origin ${brew_source}/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin ${brew_source}/homebrew-cask.git
  git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin ${brew_source}/homebrew-cask-fonts.git
  git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin ${brew_source}/homebrew-cask-drivers.git

  brew update
  ```

- tsinghua (清华)
  ```bash
  brew_source='https://mirrors.tuna.tsinghua.edu.cn/git/homebrew'
  # brew 程序本身
  git -C "$(brew --repo)" remote set-url origin ${brew_source}/brew.git
  git -C "$(brew --repo homebrew/core)" remote set-url origin ${brew_source}/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin ${brew_source}/homebrew-cask.git
  git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin ${brew_source}/homebrew-cask-fonts.git
  git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin ${brew_source}/homebrew-cask-drivers.git
  ```
- ustc (中科大)
  ```bash
  brew_source='https://mirrors.ustc.edu.cn'
  # brew 程序本身
  git -C "$(brew --repo)" remote set-url origin ${brew_source}/brew.git

  git -C "$(brew --repo homebrew/core)" remote set-url origin ${brew_source}/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin ${brew_source}/homebrew-cask.git
  ```
- ali (阿里)
  ```bash
  brew_source='https://mirrors.aliyun.com/homebrew'
  # brew 程序本身
  git -C "$(brew --repo)" remote set-url origin ${brew_source}/brew.git
  git -C "$(brew --repo homebrew/core)" remote set-url origin ${brew_source}/homebrew-core.git
  ```

- tencent
  ```bash
  brew_source='https://mirrors.cloud.tencent.com/homebrew'
  # brew 程序本身
  git -C "$(brew --repo)" remote set-url origin ${brew_source}/brew.git

  git -C "$(brew --repo homebrew/core)" remote set-url origin ${brew_source}/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin ${brew_source}/homebrew-cask.git
  git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin ${brew_source}/homebrew-cask-fonts.git
  git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin ${brew_source}/homebrew-cask-drivers.git
  ```

#### Homebrew Bottles
> address:
> - `https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles`
> - `https://mirrors.ustc.edu.cn/homebrew-bottles`
> - `https://mirrors.aliyun.com/homebrew/homebrew-bottles`
> - `https://mirrors.cloud.tencent.com/homebrew-bottles`

```bash
$ export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.cloud.tencent.com/homebrew-bottles
```

### Homebrew Caskroom Installation
```bash
$ brew tap caskroom/versions

$ brew cask outdated
$ brew tap buo/cask-upgrade
$ brew update
$ brew cu --all
```

- home brew cask upgrade
  ```bash
  $ brew cu -a -y -f
  ==> Options
  Include auto-update (-a): true
  Include latest (-f): true
  ==> Updating Homebrew
  Already up-to-date.
  ==> Finding outdated apps
         Cask           Current                                         Latest                                          A/U    Result
   1/10  alfred         3.5.1_883                                       3.5.1_883                                        Y   [   OK   ]
   2/10  android-sdk    3859397,26.0.2                                  3859397,26.0.2                                       [   OK   ]
   3/10  dash           4.1.1                                           4.1.1                                            Y   [   OK   ]
   4/10  etcher         1.2.1                                           1.2.1                                                [   OK   ]
   5/10  firefox        57.0.2                                          57.0.2                                           Y   [   OK   ]
   6/10  imageoptim     1.7.3                                           1.7.3                                            Y   [   OK   ]
   7/10  iterm2-beta    3.1.5.beta.1                                    3.1.5.beta.2                                     Y   [ FORCED ]
   8/10  java8          1.8.0_152-b16,aa0333dd3019491ca4f6ddbe78cdb6d0  1.8.0_152-b16,aa0333dd3019491ca4f6ddbe78cdb6d0       [   OK   ]
   9/10  little-snitch  4.0.4                                           4.0.4                                            Y   [   OK   ]
  10/10  mounty         latest                                          latest                                               [   OK   ]
  ==> Found outdated apps
       Cask         Current       Latest        A/U    Result
  1/1  iterm2-beta  3.1.5.beta.1  3.1.5.beta.2   Y   [ FORCED ]

  ==> Upgrading iterm2-beta to 3.1.5.beta.2
  ==> Satisfying dependencies
  ==> Downloading https://iterm2.com/downloads/beta/iTerm2-3_1_5_beta_2.zip
  ######################################################################## 100.0%
  ==> Verifying checksum for Cask iterm2-beta
  ==> Installing Cask iterm2-beta
  Warning: It seems there is already an App at '/Applications/iTerm.app'; overwriting.
  ==> Removing App '/Applications/iTerm.app'.
  ==> Moving App 'iTerm.app' to '/Applications/iTerm.app'.
  🍺  iterm2-beta was successfully installed!
  ```

  - [or](https://stackoverflow.com/a/31994862/2940319)
  ```bash
  $ brew upgrade --cask --greedy
  ```

### Package Installation
> reference:
> - [Homebrew Formulae - macvim](https://formulae.brew.sh/formula/macvim)
> - [MacVim](https://macvim-dev.github.io/macvim/)
>
> more on [mytools/osx/belloMyOSX](https://github.com/marslo/mytools/blob/master/osx/belloMyOSX.sh#L429)
> ```bash
> systemlist="imagemagick coreutils bash proctools pstree vnstat ncdu ipcalc htop ack lsof trash"
> regularlist="wget tmux corkscrew tig ifstat binutils diffutils gawk gnutls gzip less file-formula stow telnet iproute2mac ctags jshon colordiff tree vifm p7zip git mas htop watch jfrog-cli-go youtube-dl etcd mas figlet screenfetch glances bash-completion@2 dos2unix nmap rename renameutils pipenv inetutils hadolint"
> regularheadlist="shellcheck bats jq gradle-completion git-flow"
> gnulist="gnu-sed gnu-tar gnu-which grep ed findutils gnu-indent"
> ```

```bash
# utils
$ brew install imagemagick coreutils moreutils bash proctools pstree vnstat ncdu ipcalc htop ack lsof trash
$ brew install wget tmux corkscrew telnet figlet
$ brew install gnu-sed --with-default-names
$ brew install stow iproute2mac pandoc
$ brew install macvim

$ brew install wdiff --with-gettext
$ brew install less --with-pcre
```

- deprecated (macvim)
  ```bash
  $ brew install macvim --with-override-system-vim --HEAD
  # OR
  $ brew tap macvim-dev/macvim
  $ brew install --HEAD macvim-dev/macvim/macvim

  $ brew linkapps macvim
  # OR
  $ brew linkapps
  # OR
  $ HOME_APPS = File.expand_path("/Applications")
  # OR (Using none-link Info.plist and PkgInfo in *.app/Contents/)
  $ mkdir -p /Applications/gVim.app/Contents
  $ ln -sf /usr/local/Cellar/macvim/HEAD-a5e0355/gVim.app/Contents/* /Applications/gVim.app/Contents/
  $ mv /Applications/gVim.app/Contents/Info.plist{,.link}
  $ mv /Applications/gVim.app/Contents/PkgInfo{,.link}
  $ cp /Applications/gVim.app/Contents/Info.plist{.link,}
  $ cp /Applications/gVim.app/Contents/PkgInfo{.link,}
  ```

- `brew upgrade` ignore specific formulas
> [Ignore formula on brew upgrade](https://stackoverflow.com/a/48995512/2940319)

```bash
$ brew pin macvim
$ brew list --pinned
macvim

$ brew upgrade
Updating Homebrew...
Error: Not upgrading 1 pinned package:
macvim HEAD-caf7642_1
==> Upgrading 6 outdated packages:
ghostscript 9.53.2 -> 9.53.3
groovy 3.0.5 -> 3.0.6
node 14.12.0 -> 14.13.1
unbound 1.11.0 -> 1.12.0
nmap 7.80_1 -> 7.90
imagemagick 7.0.10-31 -> 7.0.10-34
...
```
  - unpin
  ```bash
  $ brew unpin macvim
  $ brew list --pinned
  ```

#### Spotlight Error
```bash
$ xattr -dr com.apple.quarantine MacVim.app
$ osascript -e 'tell application "Finder" to make alias file to POSIX file "/usr/local/opt/macvim/MacVim.app" at POSIX file "/Applications"'
```

- Warning
  ```bash
  $ brew linkapps macvim
  Warning: `brew linkapps` has been deprecated and will eventually be removed!

  Unfortunately `brew linkapps` cannot behave nicely with e.g. Spotlight using
  either aliases or symlinks and Homebrew formulae do not build "proper" `.app`
  bundles that can be relocated. Instead, please consider using `brew cask` and
  migrate formulae using `.app`s to casks.
  Linking: /usr/local/opt/macvim/MacVim.app
  Linked 1 app to /Applications
  ```

- macvim build install from sourcode
  ```bash
  $ brew install --HEAD macvim-dev/macvim/macvim
  ==> Installing macvim from macvim-dev/macvim
  ==> Installing dependencies for macvim-dev/macvim/macvim: python3, lua
  ==> Installing macvim-dev/macvim/macvim dependency: python3
  ==> Downloading https://homebrew.bintray.com/bottles/python3-3.6.3.high_sierra.bottle.tar.gz
  ==> Pouring python3-3.6.3.high_sierra.bottle.tar.gz
  You can try again using `brew postinstall python3`
  ==> Caveats
  Pip, setuptools, and wheel have been installed. To update them
    pip3 install --upgrade pip setuptools wheel

  You can install Python packages with
    pip3 install <package>

  They will install into the site-package directory
    /usr/local/lib/python3.6/site-packages

  See: https://docs.brew.sh/Homebrew-and-Python.html
  ==> Summary
  🍺  /usr/local/Cellar/python3/3.6.3: 3,009 files, 48MB
  ==> Installing macvim-dev/macvim/macvim dependency: lua
  ==> Downloading https://homebrew.bintray.com/bottles/lua-5.3.4_2.high_sierra.bottle.tar.gz
  ==> Pouring lua-5.3.4_2.high_sierra.bottle.tar.gz
  ==> Caveats
  Please be aware due to the way Luarocks is designed any binaries installed
  via Luarocks-5.3 AND 5.1 will overwrite each other in /usr/local/bin.

  This is, for now, unavoidable. If this is troublesome for you, you can build
  rocks with the `--tree=` command to a special, non-conflicting location and
  then add that to your `$PATH`.
  ==> Summary
  🍺  /usr/local/Cellar/lua/5.3.4_2: 147 files, 752.9KB
  ==> Installing macvim-dev/macvim/macvim --HEAD
  ==> Cloning https://github.com/macvim-dev/macvim.git
  Updating /Users/marslo/Library/Caches/Homebrew/macvim--git
  ==> Checking out branch master
  ==> ./configure --prefix=/usr/local/Cellar/macvim/HEAD-4bf1de8 --with-features=huge --enable-multibyte --enable-terminal --enable-netbeans --with-tlib=ncurses --enable-cscope --enable-termtruecolor --enable-perlinterp=dynamic --enable-pythoninterp=dynamic --enable-python3interp=dynamic --enable-rubyinterp=dynamic --enable-luainterp=dynamic --with-lua-prefix=/usr/local
  ==> make
  ==> PATH=/usr/local/Cellar/gettext/0.19.8.1/bin:$PATH MSGFMT=/usr/local/Cellar/gettext/0.19.8.1/bin/msgfmt INSTALL_DATA=install FILEMOD=644 LOCALEDIR=../../src/MacVim/build/Release/MacVim.app/Contents/Resources/vim/runtime/lang make -C src/po install
  🍺  /usr/local/Cellar/macvim/HEAD-4bf1de8: 2,183 files, 39.7MB, built in 1 minute 13 seconds
  ```

### check formula config files
```bash
$ brew -v edit macvim
Editing /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/macvim.rb
vim /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/macvim.rb
...
    system "./configure", "--with-features=huge",
                          "--enable-multibyte",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-tclinterp",
                          "--enable-terminal",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--with-local-dir=#{HOMEBREW_PREFIX}",
                          "--enable-cscope",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}",
                          "--enable-luainterp",
                          "--enable-python3interp",
                          "--disable-sparkle"
...

# or
$ brew -v edit macvim-dev/macvim/macvim
```
- manual install formula
> [How to prevent homebrew from upgrading a package?](https://stackoverflow.com/a/48343355/2940319)

  ```bash
  $ brew -v edit macvim
  $ brew -v fetch --deps macvim
  $ brew -v install --build-from-source macvim
  $ brew pin macvim
  ```

### brew debug
- info
  ```bash
  $ brew info --analytics
  ```
- doctor
  ```bash
  $ brew doctor
  ```

- info
  ```bash
  $ brew config
  HOMEBREW_VERSION: 2.6.0-211-g2c77a54
  ORIGIN: ${brew_source}/brew
  HEAD: 2c77a540b522c2eee74af0745851167412adb83b
  Last commit: 68 minutes ago
  Core tap ORIGIN: ${brew_source}/homebrew-core
  Core tap HEAD: 4fb418f9d1b35c372d82d0b49b0f1df9143be236
  Core tap last commit: 20 minutes ago
  Core tap branch: master
  HOMEBREW_PREFIX: /usr/local
  HOMEBREW_CASK_OPTS: []
  HOMEBREW_EDITOR: vim
  HOMEBREW_INSTALL_BADGE: ☕️ 🐸
  HOMEBREW_MAKE_JOBS: 12
  Homebrew Ruby: 2.6.3 => /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/bin/ruby
  CPU: dodeca-core 64-bit kabylake
  Clang: 12.0 build 1200
  Git: 2.29.2 => /usr/local/bin/git
  Curl: 7.64.1 => /usr/bin/curl
  Java: 1.8.271.09, 1.8.0_211
  macOS: 11.0.1-x86_64
  CLT: 12.2.0.0.1.1604076827
  Xcode: 12.2
  ```

### tricky
- get info
  ```bash
  $ brew --repository
  /usr/local/Homebrew

  $ brew --prefix python@3
  /usr/local/opt/python@3.9

  $ brew --cache
  /Users/marslo/Library/Caches/Homebre

  $ brew --repo homebrew/core
  /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
  ```

- [cleanup](${brew_source}/brew/issues/3784#issuecomment-364675767)
  ```bash
  # Remove all cache files older than specified days
  $ brew cleanup --prune=1

  # remove all caches
  $ brew cleanup -s
  ```

- check formula
  ```bash
  $ git -C "$(brew --repo homebrew/core)" show a2f05fb0b2^:Formula/rmtrash.rb
  class Rmtrash < Formula
    desc "Move files to macOS's Trash"
    homepage "http://www.nightproductions.net/cli.htm"
    url "http://www.nightproductions.net/downloads/rmtrash_source.tar.gz"
    version "0.3.3"
    ...
  ```

- [list the packages installed from taps](https://stackoverflow.com/a/44358788/2940319)
  ```bash
  $ brew tap-info --installed
  ```

  - [to get formula name](https://apple.stackexchange.com/a/392993/254265)
    ```bash
    $ brew tap-info macvim-dev/macvim --json | jq -r '.[]|(.formula_names[])'
    macvim-dev/macvim/macvim
    ```

## system settings

#### [GNU Coreutils](http://en.wikipedia.org/wiki/GNU_Core_Utilities)
```bash
$ brew install coreutils
```
- GNU Command Line Tools
  ```bash
  $ cat /etc/bashrc
  export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
  ```

#### bash
```bash
$ brew install bash

$ which -a bash
/usr/local/bin/bash
/bin/bash

$ /usr/local/bin/bash --version
GNU bash, version 4.4.12(1)-release (x86_64-apple-darwin17.0.0)
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

$ /bin/bash --version
GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin17)
Copyright (C) 2007 Free Software Foundation, Inc.
```

#### development tools
```bash
$ brew install binutils diffutils gawk ctags jshon colordiff tree p7zip gnutls gzip watch
$ brew install jq --devel --HEAD
$ brew install cmake --with-completion --HEAD
$ brew install ed --with-default-names
$ brew install findutils --with-default-names
$ brew install gnu-tar --with-default-names
$ brew install gnu-which --with-default-names
$ brew install grep --with-default-names
$ brew install gnu-indent --with-default-names
$ brew install file-formula
```

#### applications(brew, cask and [mas](https://github.com/mas-cli/mas))
```bash
$ brew tap homebrew/dupes           # Optional
$ brew tap macvim-dev/macvim

$ brew install vim --override-system-vi
$ brew install macvim --with-override-system-vim --HEAD
# OR
$ brew install --HEAD macvim-dev/macvim/macvim

$ brew install jfrog-cli-go         # JFrog CLI OR $ CURL -FL HTTPS://XRAY.JFROG.IO | SH
$ brew install mas                  # app tools like appstore

$ brew install youtube-dl

$ brew cask install firefox
$ brew cask install google-chrome   # OR $ brew cask install google-chrome-dev
$ brew cask install moom            # instead of mas install 419330170
$ brew cask install dash
$ brew cask install little-snitch
$ brew cask install vlc

$ mas install 1256503523            # System Indicators
$ mas install 836500024             # WeChat
$ mas install 1233593954            # MailMaster
$ mas install 467939042             # Growl
$ mas install 497799835             # Xcode
$ mas install 736473980             # Paint
$ mas install 520993579             # pwSafe
$ mas install 944848654             # NeteaseMusic
$ mas install 419330170             # Moom

$ mas list
1256503523 System Indicators (1.0.6)
836500024 WeChat (2.3.5)
1233593954 MailMaster (2.2.2)
467939042 Growl (2.1.3)
497799835 Xcode (9.2)
736473980 Paint 2 (5.6.5)
520993579 pwSafe (4.11)
944848654 NeteaseMusic (1.5.7)
419330170 Moom (3.2.10)
```

#### Alternative list
```bash
$ find /Applications/*.app/Contents/_MASReceipt/receipt -maxdepth 4 -print | sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'
Alfred.app
Growl.app
MailMaster.app
Moom.app
NeteaseMusic.app
Paint S.app
System Indicators.app
WeChat.app
Xcode.app
pwSafe.app
```

## accessory
### iTerm2
- Install Shell Integration
  ```bash
  $ curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
  ```
- [more settings](../../tools/iterm2.md)

### [BackgroundMusic](https://github.com/kyleneideck/BackgroundMusic)
```bash
$ (set -eo pipefail; URL='https://github.com/kyleneideck/BackgroundMusic/archive/master.tar.gz'; \
    cd $(mktemp -d); echo Downloading $URL to $(pwd); curl -qfL# $URL | gzcat - | tar x && \
    /bin/bash BackgroundMusic-master/build_and_install.sh -w && rm -rf BackgroundMusic-master)
```

- logs
  ```bash
  $ (set -eo pipefail; URL='https://github.com/kyleneideck/BackgroundMusic/archive/master.tar.gz'; \
   ->     cd $(mktemp -d); echo Downloading $URL to $(pwd); curl -qfL# $URL | gzcat - | tar x && \
   ->     /bin/bash BackgroundMusic-master/build_and_install.sh -w && rm -rf BackgroundMusic-master)
  Downloading https://github.com/kyleneideck/BackgroundMusic/archive/master.tar.gz to /var/folders/dm/dblpttpn3c5cdvg_g2rthhvh0000gn/T/tmp.mixzjjg1
  ######################################################################## 100.0%
  About to install Background Music. Please pause all audio, if you can.

  This script will install:
   - /Applications/Background Music.app
   - /Library/Audio/Plug-Ins/HAL/Background Music Device.driver
   - /Library/Application Support/Background Music/BGMXPCHelper.xpc
   - /Library/LaunchDaemons/com.bearisdriving.BGM.XPCHelper.plist

  Continue (y/N)? y
  Password:

  [1/3] Installing the virtual audio device Background Music Device.driver to /Library/Audio/Plug-Ins/HAL
  [2/3] Installing BGMXPCHelper.xpc to /Library/Application Support/Background Music
  [3/3] Installing Background Music.app to /Applications
  Restarting coreaudiod to load the virtual audio device.
  Launching Background Music.
  Done.
  ```

### [Mac CLI](https://github.com/guarinogabriel/Mac-CLI)
```bash
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/marslo/mac-cli/master/mac-cli/tools/install)"
```

- example
  ```bash
  $ mac bluetooth:status
  Bluetooth: ON

  $ mac speedtest
  Testing internet connection speed...

       4.2 Mbps ↓
  ```

### Others
#### [markdown-toc](https://github.com/jonschlinkert/markdown-toc)
```bash
$ npm i -g --save markdown-toc --verbose
```

#### [doctoc](https://github.com/thlorenz/doctoc)
```bash
$ npm install -g doctoc
```

- usage
  ```bash
  $ doctoc --gitlab my_osx.md
  $ doctoc --github --maxlevel 3 */*.md
  ```

#### [gitbook](https://www.npmjs.com/package/gitbook)
```bash
$ npm install gitbook-cli -g
```

- usage
  ```bash
  $ gitbook init
  $ gitbook serve
  $ gitbook build
  ```

#### [gitbook-summary](https://www.npmjs.com/package/gitbook-summary)
```bash
$ npm install -g gitbook-summary
```

- usage:
  ```bash
  $ book sm -d -t 'life is hard, make it easier'
  ```

#### npm-completion
```bash
$ npm i -g npm-completion
```
- usage
  ```bash
  $ PATH_TO_NPM_COMPLETION="/usr/local/lib/node_modules/npm-completion"
  $ source $PATH_TO_NPM_COMPLETION/npm-completion.sh
  ```

#### [reveal.js](https://github.com/hakimel/reveal.js)
```bash
$ git clone git@github.com:hakimel/reveal.js.git
$ cd reveal.js
$ npm i -g
```

- usage
  ```bash
  $ npm start -- --port=8081 (http://localhost:8081)
  ```

#### [gnomon](https://www.npmjs.com/package/gnomon)
```bash
$ npm i -g gnomon
```

- usage
  ```bash
  $ ping  127.0.0.1 | gnomon
     0.0066s   PING 127.0.0.1 (127.0.0.1): 56 data bytes
     0.8694s   18:13:43.219648 64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.048 ms
     0.9999s   18:13:44.221333 64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.116 ms
     1.0004s   18:13:45.221475 64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.088 ms
     1.0047s   18:13:46.222231 64 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=0.059 ms
     1.0001s   18:13:47.226847 64 bytes from 127.0.0.1: icmp_seq=4 ttl=64 time=0.101 ms
     1.0049s   18:13:48.227248 64 bytes from 127.0.0.1: icmp_seq=5 ttl=64 time=0.100 ms
     1.0049s   18:13:49.232354 64 bytes from 127.0.0.1: icmp_seq=6 ttl=64 time=0.093 ms
     0.5038s   18:13:50.237433 64 bytes from 127.0.0.1: icmp_seq=7 ttl=64 time=0.091 ms
  ```

#### [iStats](https://github.com/Chris911/iStats)
```bash
$ sudo gem install iStats -n /usr/local/bin
```

- usage
  ```bash
  $ istats  all
  --- CPU Stats ---
  CPU temp:               57.19°C     ▁▂▃▅▆▇

  --- Fan Stats ---
  Total fans in system:   2
  Fan 0 speed:            2146 RPM    ▁▂▃▅▆▇
  Fan 1 speed:            1985 RPM    ▁▂▃▅▆▇

  --- Battery Stats ---
  Battery health:         unknown
  Cycle count:            34          ▁▂▃▅▆▇  3.4%
  Max cycles:             1000
  Current charge:         6073 mAh    ▁▂▃▅▆▇  100%
  Maximum charge:         6236 mAh    ▁▂▃▅▆▇  85.0%
  Design capacity:        7336 mAh
  Battery temp:           35.8°C

  For more stats run `istats extra` and follow the instructions.
  ```

## Q&A
### [`Failed to connect to raw.githubusercontent.com port 443: Connection refused`](https://www.cnblogs.com/Dylansuns/p/12309847.html)
- issue
  ```bash
  Failed to connect to raw.githubusercontent.com port 443: Connection refused
  ```
- solution
  ```bash
  sudo bash -c " echo '199.232.28.133 raw.githubusercontent.com' >> /etc/hosts"
  ```
  - checking host IP address via [https://www.ipaddress.com/](https://www.ipaddress.com/)

- additional
  > reference:
  > - [DNS查询](http://tool.chinaz.com/dns/)
  > - [iP或域名查询](https://site.ip138.com/)
  > flush DNS via `sudo killall -HUP mDNSResponder`

```bash
sudo bash -c cat >> /etc/hosts << EOF
# GitHub Start
52.74.223.119     github.com
192.30.253.119    gist.github.com
54.169.195.247    api.github.com
185.199.111.153   assets-cdn.github.com
199.232.28.133    raw.githubusercontent.com
# 199.232.96.133  raw.githubusercontent.com
# 151.101.76.133  raw.githubusercontent.com
151.101.76.133    gist.githubusercontent.com
151.101.76.133    cloud.githubusercontent.com
151.101.76.133    camo.githubusercontent.com
151.101.76.133    avatars0.githubusercontent.com
151.101.76.133    avatars1.githubusercontent.com
151.101.76.133    avatars2.githubusercontent.com
151.101.76.133    avatars3.githubusercontent.com
151.101.76.133    avatars4.githubusercontent.com
151.101.76.133    avatars5.githubusercontent.com
151.101.76.133    avatars6.githubusercontent.com
151.101.76.133    avatars7.githubusercontent.com
151.101.76.133    avatars8.githubusercontent.com
# GitHub End
EOF
```

### failure in `brew search` for cask formula
- issue
  ```bash
  $ brew install --cask firefox-developer-edition
  Error: Cask 'firefox-developer-edition' is unavailable: No Cask with this name exists.

  $ brew search firefox
  ==> Casks
  firefox                                                                     multifirefox
  ```

- solution
  ```bash
  $ git -C $(brew --repo homebrew/cask-versions) st
  On branch master
  Your branch is up to date with 'origin/master'.

  Changes not staged for commit:
    (use "git add/rm <file>..." to update what will be committed)
    (use "git restore <file>..." to discard changes in working directory)
    deleted:    Casks/firefox-beta.rb
    deleted:    Casks/firefox-developer-edition.rb
    deleted:    Casks/firefox-esr.rb
    deleted:    Casks/firefox-nightly.rb

  no changes added to commit (use "git add" and/or "git commit -a")

  $ git -C $(brew --repo homebrew/cask-versions) reset --hard
  HEAD is now at 67d487bd6 Update dotnet-preview from 6.0.0-preview.4.21253.7,bab80210-ac54-44fa-bf41-7474c6371cf2:eadcd657b93e347d08bc33c59bd60835 to 6.0.0-preview.5.21301.5,c326f2e1-10ee-482e-9871-5fb8de7f7777:dda8203d3b58e56efeca4a7248cdea67 (#11293)
  ```
