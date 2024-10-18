<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [brew command](#brew-command)
- [homebrew installation](#homebrew-installation)
- [alternative sources](#alternative-sources)
  - [homebrewCN](#homebrewcn)
  - [tsinghua (清华)](#tsinghua-%E6%B8%85%E5%8D%8E)
  - [ustc (中科大)](#ustc-%E4%B8%AD%E7%A7%91%E5%A4%A7)
  - [ali (阿里)](#ali-%E9%98%BF%E9%87%8C)
  - [tencent (腾讯)](#tencent-%E8%85%BE%E8%AE%AF)
  - [homebrew bottles](#homebrew-bottles)
- [homebrew caskroom installation](#homebrew-caskroom-installation)
- [brew install](#brew-install)
  - [batch install](#batch-install)
- [reinstall/downgrade](#reinstalldowngrade)
  - [get formula folder](#get-formula-folder)
  - [get proper revision](#get-proper-revision)
  - [reinstall](#reinstall)
- [tricky](#tricky)
  - [check formula](#check-formula)
  - [check formula config files](#check-formula-config-files)
  - [brew debug](#brew-debug)
  - [paths](#paths)
  - [cleanup](#cleanup)
  - [list the packages installed from taps](#list-the-packages-installed-from-taps)
  - [manual download and install from local](#manual-download-and-install-from-local)
  - [`brew gist-log`](#brew-gist-log)
  - [get formula info](#get-formula-info)
  - [check homebrew env](#check-homebrew-env)
  - [force the link and overwrite everything](#force-the-link-and-overwrite-everything)
  - [rerurn postinstall](#rerurn-postinstall)
  - [check brew configure file](#check-brew-configure-file)
  - [whatprovide alternatives](#whatprovide-alternatives)
  - [tricky](#tricky-1)
  - [brew analytics](#brew-analytics)
- [troubleshooting](#troubleshooting)
  - [`would clobber existing tag`](#would-clobber-existing-tag)
  - [Cask `firefox-nightly` is not installed.](#cask-firefox-nightly-is-not-installed)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference
> - [Mac OS X Server Command-Line Administration](https://www.apple.com.cn/server/docs/Command_Line.pdf)
{% endhint %}

## brew command

| COMMAND                                  | DESCRIPTION                                                                                                |
|------------------------------------------|------------------------------------------------------------------------------------------------------------|
| `brew --cache`                           | Print path to Homebrew’s download cache (usually ~/Library/Caches/Homebrew)                                |
| `brew --cellar`                          | Print path to Homebrew’s Cellar (usually /usr/local/Cellar)                                                |
| `brew --config`                          | Print system configuration info                                                                            |
| `brew --env`                             | Print Homebrew’s environment                                                                               |
| `brew --prefix`                          | Print path to Homebrew’s prefix (usually /usr/local)                                                       |
| `brew --prefix [formula]`                | Print where formula is installed                                                                           |
| `brew audit`                             | Audit all formulae for common code and style issues                                                        |
| `brew cleanup [formula]`                 | Remove older versions from the Cellar for all (or specific) formulae1                                      |
| `brew create [url]`                      | Generate formula for downloadable file at url and open it in $HOMEBREW_EDITOR or $EDITOR2                  |
| `brew create [tarball-url] --cache`      | Generate formula (including MD5), then download the tarball                                                |
| `brew create --fink [formula]`           | Open Fink’s search page in your browser, so you can see how they do formula                                |
| `brew create --macports [formula]`       | Open MacPorts’ search page in your browser, so you can see how they do formula                             |
| `brew deps [formula]`                    | List dependencies for formula                                                                              |
| `brew doctor`                            | Check your Homebrew installation for common issues                                                         |
| `brew edit`                              | Open all of Homebrew for editing in TextMate                                                               |
| `brew edit [formula]`                    | Open [formula] in $HOMEBREW_EDITOR or $EDITOR                                                              |
| `brew fetch --force -v --HEAD [formula]` | Download source package for formula; for tarballs, also prints MD5, SHA1, and SHA256 checksums             |
| `brew home`                              | Open Homebrew’s homepage in your browser                                                                   |
| `brew home [formula]`                    | Opens formula ’s homepage in your browser                                                                  |
| `brew info`                              | Print summary of installed packages                                                                        |
| `brew info [formula]`                    | Print info for formula (regardless of whether formula is installed)                                        |
| `brew info --github [formula]`           | Open Github’s History page for formula in your browser                                                     |
| `brew install [formula]`                 | Install formula                                                                                            |
| `brew install --HEAD [formula]`          | Install the HEAD version of formula (if its formula defines HEAD)                                          |
| `brew install --force --HEAD [formula]`  | Install a newer HEAD version of formula (if its formula defines HEAD)                                      |
| `brew link [formula]`                    | Symlink all installed files for formula into the Homebrew prefix3                                          |
| `brew list [formula]`                    | List all installed files for formula (or all installed formulae with no arguments )                        |
| `brew options [formula]`                 | Display install options specific to formula                                                                |
| `brew outdated`                          | List formulae that have an updated version available (brew install formula will install the newer version) |
| `brew prune`                             | Remove dead symlinks from Homebrew’s prefix4                                                               |
| `brew remove [formula]`                  | Uninstall formula                                                                                          |
| `brew search`                            | List all available formula                                                                                 |
| `brew search [formula]`                  | Search for formula in all available formulae                                                               |
| `brew search /[formula]/`                | Search for /formula/ (as regex) in all available formulae                                                  |
| `brew test [formula]`                    | If formula defines a test, run it                                                                          |
| `brew unlink [formula]`                  | Unsymlink formula from Homebrew’s prefix                                                                   |
| `brew update`                            | Update formulae and Homebrew itself                                                                        |
| `brew upgrade`                           | Install newer versions of outdated packages                                                                |
| `brew upgrade [formula]`                 | Install newer version of formula                                                                           |
| `brew versions [formula]`                | List previous versions of formulae, along with a command to checkout each version                          |
| `brew analytics [state]`                 | Display the current state of Homebrew's analytics                                                          |

## homebrew installation
```bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

- default source
  ```bash
  $ git -C "$(brew --repo)" remote -v
  origin  git@github.com:Homebrew/brew (fetch)
  origin  git@github.com:Homebrew/brew (push)

  $ git -C "$(brew --repo homebrew/core)" remote -v
  origin  git@github.com:Homebrew/homebrew-core (fetch)
  origin  git@github.com:Homebrew/homebrew-core (push)
  ```

## alternative sources

> [!TIP|label:references:]
> - [Mac 下 brew 切换为国内源](https://cloud.tencent.com/developer/article/1614039)
> - [homebrew for additional source](https://frankindev.com/2020/05/15/replace-homebrew-source/)

### [homebrewCN](https://gitee.com/Busch/HomebrewCN)
```bash
$ /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
```

- official


  > [!NOTE|label:revert back]
  > ```bash
  > $ brew doctor
  > Please note that these warnings are just used to help the Homebrew maintainers
  > with debugging if you file an issue. If everything you use Homebrew for is
  > working fine: please don't worry or file an issue; just ignore this. Thanks!
  >
  > Warning: Suspicious https://github.com/Homebrew/brew git origin remote found.
  > The current git origin is:
  >   https://mirrors.ustc.edu.cn/brew.git
  >
  > With a non-standard origin, Homebrew won't update properly.
  > You can solve this by setting the origin remote:
  >   git -C "/usr/local/Homebrew" remote set-url origin https://github.com/Homebrew/brew
  >
  > Warning: Suspicious https://github.com/Homebrew/homebrew-core git origin remote found.
  > The current git origin is:
  >   https://mirrors.ustc.edu.cn/homebrew-core.git
  >
  > With a non-standard origin, Homebrew won't update properly.
  > You can solve this by setting the origin remote:
  >   git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core" remote set-url origin https://github.com/Homebrew/homebrew-core
  > ```

  ```bash
  $ brew_source='https://github.com/Homebrew'
  # brew 程序本身
  $ git -C "$(brew --repo)" remote set-url origin ${brew_source}/brew.git

  $ git -C "$(brew --repo homebrew/core)" remote set-url origin ${brew_source}/homebrew-core.git
  $ git -C "$(brew --repo homebrew/cask)" remote set-url origin ${brew_source}/homebrew-cask.git
  $ git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin ${brew_source}/homebrew-cask-fonts.git
  $ git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin ${brew_source}/homebrew-cask-drivers.git

  $ brew update
  ```

### tsinghua (清华)
```bash
$ brew_source='https://mirrors.tuna.tsinghua.edu.cn/git/homebrew'
# brew 程序本身
$ git -C "$(brew --repo)" remote set-url origin ${brew_source}/brew.git
$ git -C "$(brew --repo homebrew/core)" remote set-url origin ${brew_source}/homebrew-core.git
$ git -C "$(brew --repo homebrew/cask)" remote set-url origin ${brew_source}/homebrew-cask.git
$ git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin ${brew_source}/homebrew-cask-fonts.git
$ git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin ${brew_source}/homebrew-cask-drivers.git

$ brew update
```

### ustc (中科大)
```bash
$ brew_source='https://mirrors.ustc.edu.cn'
# brew 程序本身
$ git -C "$(brew --repo)" remote set-url origin ${brew_source}/brew.git

$ git -C "$(brew --repo homebrew/core)" remote set-url origin ${brew_source}/homebrew-core.git
$ git -C "$(brew --repo homebrew/cask)" remote set-url origin ${brew_source}/homebrew-cask.git

$ brew update
```

### ali (阿里)
```bash
$ brew_source='https://mirrors.aliyun.com/homebrew'
# brew 程序本身
$ git -C "$(brew --repo)" remote set-url origin ${brew_source}/brew.git
$ git -C "$(brew --repo homebrew/core)" remote set-url origin ${brew_source}/homebrew-core.git

$ brew update
```

### tencent (腾讯)
```bash
$ brew_source='https://mirrors.cloud.tencent.com/homebrew'
# brew 程序本身
$ git -C "$(brew --repo)" remote set-url origin ${brew_source}/brew.git

$ git -C "$(brew --repo homebrew/core)" remote set-url origin ${brew_source}/homebrew-core.git
$ git -C "$(brew --repo homebrew/cask)" remote set-url origin ${brew_source}/homebrew-cask.git
$ git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin ${brew_source}/homebrew-cask-fonts.git
$ git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin ${brew_source}/homebrew-cask-drivers.git

$ brwe update
```

### homebrew bottles

> [!NOTE|label:address:]
> - `https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles`
> - `https://mirrors.ustc.edu.cn/homebrew-bottles`
> - `https://mirrors.aliyun.com/homebrew/homebrew-bottles`
> - `https://mirrors.cloud.tencent.com/homebrew-bottles`

```bash
$ export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.cloud.tencent.com/homebrew-bottles
```

## homebrew caskroom installation
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

## brew install

> [!NOTE|label:references:]
> - [Homebrew Formulae - macvim](https://formulae.brew.sh/formula/macvim)
> - [MacVim](https://macvim-dev.github.io/macvim/)
>
> - more on [mytools/osx/belloMyOSX](https://github.com/marslo/mytools/raw/master/osx/belloMyOSX.sh#L429)
>   ```bash
>   systemlist="imagemagick coreutils bash proctools pstree vnstat ncdu ipcalc htop ack lsof trash"
>   regularlist="wget tmux corkscrew tig ifstat binutils diffutils gawk gnutls gzip less file-formula stow telnet iproute2mac ctags jshon colordiff tree vifm p7zip git mas htop watch jfrog-cli-go youtube-dl etcd mas figlet screenfetch glances bash-completion@2 dos2unix nmap rename renameutils pipenv inetutils hadolint"
>   regularheadlist="shellcheck bats jq gradle-completion git-flow"
>   gnulist="gnu-sed gnu-tar gnu-which grep ed findutils gnu-indent"
>   ```

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

  > [!NOTE]
  > - [Ignore formula on brew upgrade](https://stackoverflow.com/a/48995512/2940319)

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

### batch install

> [!NOTE|label:references:]
> - [List of all packages installed using Homebrew](https://apple.stackexchange.com/a/101092/254265)

```bash
$ xargs brew install < list.txt
```

- [make backup](https://apple.stackexchange.com/a/322371/254265)
  ```bash
  $ brew leaves > list.txt
  ```

## reinstall/downgrade

> [!NOTE|label:references]
> - [Install icu4c version 63 with Homebrew](https://stackoverflow.com/a/55828190/2940319)
> - [Finding the right version of the formula](https://blog.sandipb.net/2021/09/02/installing-a-specific-version-of-a-homebrew-formula/)
> - [Homebrew install specific version of formula?](https://stackoverflow.com/a/67399779/2940319)
> - [homebrew - how to install older versions](https://stackoverflow.com/a/46306176/2940319)
>
> - error log in node@12.22 after `icu4c` upgraded from 71.1 to 72.1:
>   ```bash
>   dyld[43773]: Library not loaded: /usr/local/opt/icu4c/lib/libicui18n.71.dylib
>     Referenced from: <57CC95E2-F00F-30F7-9252-4671B72F7B9E> /usr/local/Cellar/node@12/12.22.12_1/bin/node
>     Reason: tried: '/usr/local/opt/icu4c/lib/libicui18n.71.dylib' (no such file), '/System/Volumes/Preboot/Cryptexes/OS/usr/local/opt/icu4c/lib/libicui18n.71.dylib' (no such file), '/usr/local/opt/icu4c/lib/libicui18n.71.dylib' (no such file), '/usr/local/lib/libicui18n.71.dylib' (no such file), '/usr/lib/libicui18n.71.dylib' (no such file, not in dyld cache), '/usr/local/Cellar/icu4c/72.1/lib/libicui18n.71.dylib' (no such file), '/System/Volumes/Preboot/Cryptexes/OS/usr/local/Cellar/icu4c/72.1/lib/libicui18n.71.dylib' (no such file), '/usr/local/Cellar/icu4c/72.1/lib/libicui18n.71.dylib' (no such file), '/usr/local/lib/libicui18n.71.dylib' (no such file), '/usr/lib/libicui18n.71.dylib' (no such file, not in dyld cache)
>   ```

### get formula folder
```bash
$ cd $(brew --repo homebrew/core)

# or
$ cd $(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-core/Formula   # intel
$ cd $(brew --prefix)/Library/Taps/homebrew/homebrew-core/Formula            # m1

# or
$ hcore="$(brew --repo homebrew/core)"
$ alias git="git -C ${hcore}"
```

### get proper revision
- from git history
  ```bash
  $ git log --oneline -5 --follow icu4c.rb
  11249c583b5 icu4c: update 72.1 bottle.
  025d9d1deaf icu4c 72.1
  e3317b86c11 (icu4c-71.1) icu4c: update 71.1 bottle.                 # proper version
  54fb3277728 icu4c: update 71.1 bottle.
  c013b416f31 icu4c: update homepage url

  $ git rev-parse e3317b86c11
  e3317b86c11c644e88c762e03eb7b310c3337587
  ```

- via `brew extract`
  ```bash
  $ brew extract --force --version=71.1 icu4c homebrew/cask
  ==> Searching repository history
  ==> Writing formula for icu4c from revision e3317b8 to:           # `e3317b8` is the revision
  /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask/Formula/icu4c@71.1.rb

  $ git -C $(brew --repo homebrew/core) rev-parse e3317b8
  e3317b86c11c644e88c762e03eb7b310c3337587
  ```

### reinstall

> [!NOTE]
> - without auto update : `HOMEBREW_NO_AUTO_UPDATE=1`
> - without install dependents : `HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1`
>
> ```bash
> $ brew install --help
>
> Unless `HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK` is set, `brew upgrade` or `brew
> reinstall` will be run for outdated dependents and dependents with broken
> linkage, respectively.
>
> Unless `HOMEBREW_NO_INSTALL_CLEANUP` is set, `brew cleanup` will then be run for
> the installed formulae or, every 30 days, for all formulae.
>
> Unless `HOMEBREW_NO_INSTALL_UPGRADE` is set, `brew install` formula will
> upgrade formula if it is already installed but outdated.
> ```

#### via new tap

> [!TIP|label:references:]
> - [Install specific git version on MacOS using brew](https://stackoverflow.com/a/69549488/2940319)

- setup environment (tap)
  ```bash
  $ brew tap-new marslo/icu4c-71-1
  Initialized empty Git repository in /usr/local/Homebrew/Library/Taps/marslo/homebrew-icu4c-71-1/.git/
  .git/hooks/post-commit: line 8: git-stats: command not found
  [main (root-commit) ed01d30] Create marslo/icu4c-71-1 tap
   3 files changed, 90 insertions(+)
   create mode 100644 .github/workflows/publish.yml
   create mode 100644 .github/workflows/tests.yml
   create mode 100644 README.md
  ==> Created marslo/icu4c-71-1
  /usr/local/Homebrew/Library/Taps/marslo/homebrew-icu4c-71-1

  # extract
  $ brew extract --version=71.1 icu4c marslo/icu4c-71-1
  ==> Searching repository history
  ==> Writing formula for icu4c from revision e3317b8 to:
  /usr/local/Homebrew/Library/Taps/marslo/homebrew-icu4c-71-1/Formula/icu4c@71.1.rb
  ```

- install
  ```bash
  $ brew search /icu4c/
  ==> Formulae
  homebrew/cask/icu4c@71.1                       icu4c ✔                                        marslo/icu4c-71-1/icu4c@71.1

  # will be installed in /usr/local/Cellar/icu4c@71.1
  $ HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 HOMEBREW_NO_AUTO_UPDATE=1 brew install marslo/icu4c-71-1/icu4c@71.1

  # mapping libs : https://stackoverflow.com/a/55024755/2940319
  $ ln -sf /usr/local/Cellar/icu4c@71.1/71.1/lib/*.dylib /usr/local/lib/

  # verify
  $ ls -Altrh /usr/local/lib | grep icu4c
  lrwxr-xr-x   1 marslo admin   59 Jun 26 15:34 libicudata.71.1.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicudata.71.1.dylib
  lrwxr-xr-x   1 marslo admin   57 Jun 26 15:34 libicudata.71.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicudata.71.dylib
  lrwxr-xr-x   1 marslo admin   54 Jun 26 15:34 libicudata.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicudata.dylib
  lrwxr-xr-x   1 marslo admin   59 Jun 26 15:34 libicui18n.71.1.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicui18n.71.1.dylib
  lrwxr-xr-x   1 marslo admin   57 Jun 26 15:34 libicui18n.71.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicui18n.71.dylib
  lrwxr-xr-x   1 marslo admin   54 Jun 26 15:34 libicui18n.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicui18n.dylib
  lrwxr-xr-x   1 marslo admin   57 Jun 26 15:34 libicuio.71.1.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicuio.71.1.dylib
  lrwxr-xr-x   1 marslo admin   55 Jun 26 15:34 libicuio.71.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicuio.71.dylib
  lrwxr-xr-x   1 marslo admin   52 Jun 26 15:34 libicuio.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicuio.dylib
  lrwxr-xr-x   1 marslo admin   59 Jun 26 15:34 libicutest.71.1.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicutest.71.1.dylib
  lrwxr-xr-x   1 marslo admin   57 Jun 26 15:34 libicutest.71.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicutest.71.dylib
  lrwxr-xr-x   1 marslo admin   54 Jun 26 15:34 libicutest.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicutest.dylib
  lrwxr-xr-x   1 marslo admin   57 Jun 26 15:34 libicutu.71.1.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicutu.71.1.dylib
  lrwxr-xr-x   1 marslo admin   55 Jun 26 15:34 libicutu.71.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicutu.71.dylib
  lrwxr-xr-x   1 marslo admin   52 Jun 26 15:34 libicutu.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicutu.dylib
  lrwxr-xr-x   1 marslo admin   57 Jun 26 15:34 libicuuc.71.1.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicuuc.71.1.dylib
  lrwxr-xr-x   1 marslo admin   55 Jun 26 15:34 libicuuc.71.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicuuc.71.dylib
  lrwxr-xr-x   1 marslo admin   52 Jun 26 15:34 libicuuc.dylib -> /usr/local/Cellar/icu4c@71.1/71.1/lib/libicuuc.dylib
  ```

  <!--sec data-title="result" data-id="section1" data-show=true data-collapse=true ces-->
  ```bash
  ==> Fetching marslo/icu4c-71-1/icu4c@71.1
  ==> Downloading https://github.com/unicode-org/icu/releases/download/release-71-1/icu4c-71_1-src.tgz
  ==> Downloading from https://objects.githubusercontent.com/github-production-release-asset-2e65be/49244766/6a045371-02a9-431c-81b8-be6721ce
  #################################################################################################################################### 100.0%
  ==> Reinstalling marslo/icu4c-71-1/icu4c@71.1
  Warning: Your Xcode (14.1) is outdated.
  Please update to Xcode 14.3 (or delete it).
  Xcode can be updated from the App Store.

  ==> ./configure --prefix=/usr/local/Cellar/icu4c@71.1/71.1 --disable-samples --disable-tests --enable-static --with-library-bits=64
  ==> make
  ==> make install
  ==> Caveats
  icu4c@71.1 is keg-only, which means it was not symlinked into /usr/local,
  because macOS provides libicucore.dylib (but nothing else).

  If you need to have icu4c@71.1 first in your PATH, run:
    echo 'export PATH="/usr/local/opt/icu4c@71.1/bin:$PATH"' >> /Users/marslo/.bash_profile
    echo 'export PATH="/usr/local/opt/icu4c@71.1/sbin:$PATH"' >> /Users/marslo/.bash_profile

  For compilers to find icu4c@71.1 you may need to set:
    export LDFLAGS="-L/usr/local/opt/icu4c@71.1/lib"
    export CPPFLAGS="-I/usr/local/opt/icu4c@71.1/include"

  For pkg-config to find icu4c@71.1 you may need to set:
    export PKG_CONFIG_PATH="/usr/local/opt/icu4c@71.1/lib/pkgconfig"
  ==> Summary
  ☕️ 🐸  /usr/local/Cellar/icu4c@71.1/71.1: 262 files, 76.2MB, built in 2 minutes 55 seconds
  ==> Running `brew cleanup icu4c@71.1`...
  Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
  Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
  Warning: HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK is set: not checking for outdated
  dependents or dependents with broken linkage!
  ```
  <!--endsec-->


#### via fully-qualified name
```bash
$ brew --cache --force-bottle icu4c@71.1
Error: Formulae found in multiple taps:
       * homebrew/cask/icu4c@71.1
       * marslo/icu4c-71-1/icu4c@71.1
Please use the fully-qualified name (e.g. homebrew/cask/icu4c@71.1) to refer to the formula.

# will be installed in /usr/local/Cellar/icu4c@71.1
$ HOMEBREW_NO_AUTO_UPDATE=1 brew install homebrew/cask/icu4c@71.1
==> Fetching homebrew/cask/icu4c@71.1
==> Downloading https://github.com/unicode-org/icu/releases/download/release-71-1/icu4c-71_1-src.tgz
Already downloaded: /Users/marslo/Library/Caches/Homebrew/downloads/ff9ece63f455ff1d6aa066340111e22abfc72c249a7f3d1e492ffef111cb0752--icu4c-71_1-src.tgz
==> Installing icu4c@71.1 from homebrew/cask
...

# mapping libs
$ ln -sf /usr/local/Cellar/icu4c@71.1/71.1/lib/*.dylib /usr/local/lib/
```

<!--sec data-title="installation full log" data-id="section0" data-show=true data-collapse=true ces-->
```bash
$ HOMEBREW_NO_AUTO_UPDATE=1 brew install homebrew/cask/icu4c@71.1
==> Fetching homebrew/cask/icu4c@71.1
==> Downloading https://github.com/unicode-org/icu/releases/download/release-71-1/icu4c-71_1-src.tgz
Already downloaded: /Users/marslo/Library/Caches/Homebrew/downloads/ff9ece63f455ff1d6aa066340111e22abfc72c249a7f3d1e492ffef111cb0752--icu4c-71_1-src.tgz
==> Installing icu4c@71.1 from homebrew/cask
==> ./configure --prefix=/usr/local/Cellar/icu4c@71.1/71.1 --disable-samples --disable-tests --enable-static --with-library-bits=64
==> make
==> make install
==> Caveats
icu4c@71.1 is keg-only, which means it was not symlinked into /usr/local,
because macOS provides libicucore.dylib (but nothing else).

If you need to have icu4c@71.1 first in your PATH, run:
  echo 'export PATH="/usr/local/opt/icu4c@71.1/bin:$PATH"' >> /Users/marslo/.bash_profile
  echo 'export PATH="/usr/local/opt/icu4c@71.1/sbin:$PATH"' >> /Users/marslo/.bash_profile

For compilers to find icu4c@71.1 you may need to set:
  export LDFLAGS="-L/usr/local/opt/icu4c@71.1/lib"
  export CPPFLAGS="-I/usr/local/opt/icu4c@71.1/include"

For pkg-config to find icu4c@71.1 you may need to set:
  export PKG_CONFIG_PATH="/usr/local/opt/icu4c@71.1/lib/pkgconfig"
==> Summary
☕️ 🐸  /usr/local/Cellar/icu4c@71.1/71.1: 262 files, 76.2MB, built in 2 minutes 44 seconds
==> Running `brew cleanup icu4c@71.1`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
```
<!--endsec-->

#### via url

> [!INFO]
> - url should be : `https://raw.githubusercontent.com/Homebrew/homebrew-core/<git-revision>/Formula/<formula-name>.rb`

```bash
$ HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 \
  HOMEBREW_NO_AUTO_UPDATE=1 \
  brew reinstall https://raw.githubusercontent.com/Homebrew/homebrew-core/e3317b86c11c644e88c762e03eb7b310c3337587/Formula/icu4c.rb
```

#### via local cache
```bash
$ git log -p -G url.*icu4c -- Formula/icu4c.rb | grep -e ^commit -e https://github.com
-  url "https://github.com/unicode-org/icu/releases/download/release-71-1/icu4c-71_1-src.tgz"
+  url "https://github.com/unicode-org/icu/releases/download/release-72-1/icu4c-72_1-src.tgz"
-  url "https://github.com/unicode-org/icu/releases/download/release-70-1/icu4c-70_1-src.tgz"
+  url "https://github.com/unicode-org/icu/releases/download/release-71-1/icu4c-71_1-src.tgz"
-  url "https://github.com/unicode-org/icu/releases/download/release-69-1/icu4c-69_1-src.tgz"
+  url "https://github.com/unicode-org/icu/releases/download/release-70-1/icu4c-70_1-src.tgz"
   ...

$ curl -O "https://github.com/unicode-org/icu/releases/download/release-71-1/icu4c-71_1-src.tgz"
$ mv icu4c-71_1-src.tgz $(brew --cache -s icu4c)
$ HOMEBREW_NO_AUTO_UPDATE=1 brew install -f $(brew --cache -s icu4c)
```

#### via formula file (.rb)
```bash
$ git checkout -b icu4c-71.1 e3317b86c11

$ HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 HOMEBREW_NO_AUTO_UPDATE=1 brew reinstall ./icu4c.rb
Error: Failed to load cask: ./icu4c.rb
Cask 'icu4c' is unreadable: wrong constant name #<Class:0x00007f7a52b2d4e0>
Warning: Treating ./icu4c.rb as a formula.
==> Fetching icu4c
==> Downloading https://ghcr.io/v2/homebrew/core/icu4c/manifests/71.1
Already downloaded: /Users/marslo/Library/Caches/Homebrew/downloads/afc80f921cbba7963984e5d24567fbff5b3ba72dfc409cbf7c7f02ccaf0bebab--icu4c-71.1.bottle_manifest.json
==> Downloading https://ghcr.io/v2/homebrew/core/icu4c/raws/sha256:012f882f239863200f0f87150541ea695d609aa14c14a390909d249352ae51f9
Already downloaded: /Users/marslo/Library/Caches/Homebrew/downloads/f0134d8542652b3e26e7a482164caededc27b5ff5925270efdb6f268467f51ae--icu4c--71.1.ventura.bottle.tar.gz
==> Reinstalling icu4c
Warning: icu4c 72.1 is available and more recent than version 71.1.
==> Pouring icu4c--71.1.ventura.bottle.tar.gz
☕️ 🐸  /usr/local/Cellar/icu4c/71.1: 262 files, 76.2MB
==> Running `brew cleanup icu4c`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
Removing: /Users/marslo/Library/Caches/Homebrew/icu4c--71.1... (28.2MB)
Warning: HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK is set: not checking for outdated
dependents or dependents with broken linkage!

# revert formula branch
$ git checkout master
```

- pin formula
  ```bash
  $ brew pin icu4c
  $ brew list --pinned
  icu4c
  ```

#### spotlight error
```bash
$ xattr -dr com.apple.quarantine MacVim.app
$ osascript -e 'tell application "Finder" to make alias file to POSIX file "/usr/local/opt/macvim/MacVim.app" at POSIX file "/Applications"'
```

- warning
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

  <!--sec data-title="macvim build install from sourcode" data-id="section2" data-show=true data-collapse=true ces-->
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
  <!--endsec-->

## tricky

> [!NOTE|label:references]
> - [Tips and Tricks](https://docs.brew.sh/Tips-N%27-Tricks#installing-previous-versions-of-formulae)

### check formula
```bash
$ git -C "$(brew --repo homebrew/core)" show a2f05fb0b2^:Formula/rmtrash.rb
class Rmtrash < Formula
  desc "Move files to macOS's Trash"
  homepage "http://www.nightproductions.net/cli.htm"
  url "http://www.nightproductions.net/downloads/rmtrash_source.tar.gz"
  version "0.3.3"
  ...
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

  > [!NOTE|label:references:]
  > [How to prevent homebrew from upgrading a package?](https://stackoverflow.com/a/48343355/2940319)

  ```bash
  $ brew -v edit macvim
  $ brew -v fetch --deps macvim
  $ brew -v install --build-from-source macvim
  $ brew pin macvim
  ```

- via `brew --repo`
  ```bash
  $ brew --repo benjiwolff/neovim-nightly
  /usr/local/Homebrew/Library/Taps/benjiwolff/homebrew-neovim-nightly

  $ cat $(brew --repo benjiwolff/neovim-nightly)/Casks/*rb
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

### paths
- repos

  ```bash
  # repo
  $ brew --repository
  /usr/local/Homebrew
  $ brew --repo
  /usr/local/Homebrew

  $ brew --prefix
  /usr/local

  $ brew --cellar
  /usr/local/Cellar

  $ brew --caskroom
  /usr/local/Caskroom

  $ brew --cache
  /Users/marslo/Library/Caches/Homebre

  $ brew --repo homebrew/core
  /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
  $ brew --repo benjiwolff/neovim-nightly
  /usr/local/Homebrew/Library/Taps/benjiwolff/homebrew-neovim-nightly
  ```

- formula
  ```
  $ brew --prefix python@3
  /usr/local/opt/python@3.9

  $ brew --cellar python@3
  /usr/local/Cellar/python@3.9
  ```

### [cleanup](${brew_source}/brew/issues/3784#issuecomment-364675767)
```bash
# Remove all cache files older than specified days
$ brew cleanup --prune=1

# remove all caches
$ brew cleanup -s
```

### [list the packages installed from taps](https://stackoverflow.com/a/44358788/2940319)
```bash
$ brew tap-info --installed

# or
$ brew info $(brew list) | grep '^From:' | sort
# or
$ brew leaves | xargs brew info | grep '^From:'
```

- [to get formula name](https://apple.stackexchange.com/a/392993/254265)
  ```bash
  $ brew tap-info macvim-dev/macvim --json | jq -r '.[]|(.formula_names[])'
  macvim-dev/macvim/macvim

  # or
  $ brew tap                                             # get tap name
  $ TAP='homebrew/cask'
  $ brew tap-info $TAP --json | jq -r '.[]|(.cask_tokens[])'
  $ brew tap-info $TAP --json | jq -r '.[]|(.cask_tokens[])' | grep whatsapp
  homebrew/cask/chatmate-for-whatsapp
  homebrew/cask/whatsapp
  ```

### [manual download and install from local](https://apple.stackexchange.com/a/361603/254265)
```bash
# download manually due to proxy issue
$ curl -O https://downloads.sourceforge.net/gptfdisk/gdisk-1.0.9.pkg
$ mv gdisk-1.0.9.pkg $(brew --cache -s gdisk)

# check `formula` local cache path
$ brew --cache -s <formula>
```

### `brew gist-log`

> [!TIP|label:generate token via:]
> - [Create a GitHub personal access token](https://github.com/settings/tokens/new?scopes=gist&description=Homebrew)

```bash
$ echo 'export HOMEBREW_GITHUB_API_TOKEN=your_token_here' >> ~/.bash_profile
$ source ~/.bash_profile

$ brew gist-logs node
https://gist.github.com/marslo/353904e6472536e94d0c8f51a8a23a84
```

### get formula info
```bash
$ brew info neovim-nightly

# or
$ brew desc neovim-nightly --cask --eval-all
```

### check homebrew env
```bash
$ brew shellenv
export HOMEBREW_PREFIX="/usr/local";
export HOMEBREW_CELLAR="/usr/local/Cellar";
export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}";
export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/usr/local/share/info:${INFOPATH:-}";

# or
$ brew --env
HOMEBREW_CC: clang
HOMEBREW_CXX: clang++
MAKEFLAGS: -j12
CMAKE_PREFIX_PATH: /usr/local
CMAKE_INCLUDE_PATH: /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/System/Library/Frameworks/OpenGL.framework/Versions/Current/Headers
CMAKE_LIBRARY_PATH: /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/System/Library/Frameworks/OpenGL.framework/Versions/Current/Libraries
PKG_CONFIG_LIBDIR: /usr/lib/pkgconfig:/usr/local/Homebrew/Library/Homebrew/os/mac/pkgconfig/14
HOMEBREW_GIT: git
HOMEBREW_SDKROOT: /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk
ACLOCAL_PATH: /usr/local/share/aclocal
PATH: /usr/local/Homebrew/Library/Homebrew/shims/mac/super:/usr/bin:/bin:/usr/sbin:/sbin
```

### force the link and overwrite everything
```bash
$ brew link --overwrite <formula>

# i.e.:
$ brew link --overwrite --dry-run python@3.8
Would remove:
/usr/local/bin/python3 -> /usr/local/Cellar/python@3.9/3.9.0/bin/python3.9

If you need to have this software first in your PATH instead consider running:
  echo 'export PATH="/usr/local/opt/python@3.8/bin:$PATH"' >> /Users/marslo/.bash_profile
```

### rerurn postinstall
```bash
$ brew postinstall <formula>

# i.e.:
$ sudo chown marslo:admin -R /usr/local/lib/python3.8/site-packages
$ brew postinstall python@3.8
==> Postinstalling python@3.8
==> /usr/local/Cellar/python@3.8/3.8.6_1/bin/python3 -s setup.py --no-user-cfg install --force --verbose --install-scripts=/usr/local/Cellar/python@3.8
==> /usr/local/Cellar/python@3.8/3.8.6_1/bin/python3 -s setup.py --no-user-cfg install --force --verbose --install-scripts=/usr/local/Cellar/python@3.8
==> /usr/local/Cellar/python@3.8/3.8.6_1/bin/python3 -s setup.py --no-user-cfg install --force --verbose --install-scripts=/usr/local/Cellar/python@3.8

# update homebrew-cask
$ git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask" fetch --unshallow
```

### check brew configure file
```bash
$ brew -v edit <formula>

# i.e.:
$ brew -v edit openjdk
```

![brew -v](../screenshot/osx/brew-v.png)

#### manual install formula
```bash
$ brew -v edit macvim
$ brew -v fetch --deps macvim
$ brew -v install --build-from-source macvim
$ brew pin macvim
```

### whatprovide alternatives
```bash
$ pkgutil --file-info /usr/bin/qlmanage
volume: /
path: /usr/bin/qlmanage

pkgid: com.apple.pkg.Core
pkg-version: 10.15.0.1.1.1569789135
install-time: 1570542610
uid: 0
gid: 0
mode: 755
```

- for brew formula
  ```bash
  $ while read formula; do
      brew list --formula "${formula}" | grep -w magick;
    done < <(brew list --formula)
  ```

### tricky

> [!TIP|label:reference:]
> - [Tips and Tricks](https://docs.brew.sh/Tips-N'-Tricks)

- interactive homebrew shell
  ```bash
  $ brew irb
  ==> Interactive Homebrew Shell
  Example commands available with: brew irb --examples

  WARNING: This version of ruby is included in macOS for compatibility with legacy software.
  In future versions of macOS the ruby runtime will not be available by
  default, and may require you to install an additional package.

  irb(main):001:0>
  ```

- list dependencies
  ```bash
  $ brew deps macvim
  Warning: Treating macvim as a formula. For the cask, use homebrew/cask/macvim
  cscope
  gdbm
  gettext
  libyaml
  lua
  openssl@1.1
  python@3.9
  readline
  ruby
  sqlite
  xz
  ```

- list who depends on
  ```bash
  $ brew uses --installed cscope
  macvim
  ```

- list all formula dpendencies
  ```bash
  $ brew list | while read cask; do
      echo -e -n "\e[1;34m$cask ->\e[0m";
      brew deps $cask | awk '{printf(" %s ", $0)}';
      echo "";
    done

  # i.e.:
  $ brew list | while read cask; do
      echo -e -n "\e[1;34m$cask ->\e[0m";
      brew deps $cask | awk '{printf(" %s ", $0)}';
      echo "";
    done

  Warning: Calling `brew list` to only list formulae is deprecated! Use `brew list --formula` instead.
  ack ->
  adns ->
  aom ->
  autoconf ->
  autoconf-archive -> autoconf
  automake -> autoconf
  bash ->
  bash-completion ->
  bash-completion@2 -> bash
  bats ->
  bdw-gc ->
  berkeley-db -> openssl@1.1
  binutils ->
  cabal-install -> ghc
  cairo -> fontconfig  freetype  gdbm  gettext  glib  libffi  libpng  lzo  openssl@1.1  pcre  pixman  python@3.8  readline  sqlite  xz
  ...
  ```

### [brew analytics](https://stackoverflow.com/a/19688479/2940319)
```bash
# turn on/off
$ export HOMEBREW_NO_ANALYTICS=1/0
$ brew analytics off/on

# check status
$ brew analytics
InfluxDB analytics are enabled.
Google Analytics were destroyed.
```

## troubleshooting

### `would clobber existing tag`

```bash
$ brew install --HEAD neovim
...
==> Cloning https://github.com/neovim/neovim.git
Updating /Users/marslo/Library/Caches/Homebrew/neovim--git
From https://github.com/neovim/neovim
 ! [rejected]            nightly    -> nightly  (would clobber existing tag)
 ! [rejected]            stable     -> stable  (would clobber existing tag)
Error: neovim: Failed to download resource "neovim"
Failure while executing; `/usr/bin/env git fetch origin` exited with 1. Here's the output:
From https://github.com/neovim/neovim
 ! [rejected]            nightly    -> nightly  (would clobber existing tag)
 ! [rejected]            stable     -> stable  (would clobber existing tag)
```

- solution
  ```bash
  $ rm -rf /Users/marslo/Library/Caches/Homebrew/neovim--git
  $ brew install --HEAD neovim
  ```

### Cask `firefox-nightly` is not installed.

```bash
$ brew uninstall firefox-nightly
Warning: Formula homebrew/cask-versions/firefox-nightly was renamed to homebrew/cask/firefox@nightly.
Warning: Cask homebrew/cask-versions/firefox-nightly was renamed to firefox@nightly.
Error: Cask 'firefox@nightly' is not installed.
```

- solution
  ```bash
  # check
  $ ls -Altrh /usr/local/Caskroom | grep firefox-nightly
  lrwxr-xr-x  1 marslo admin  15 May 28 17:13 firefox-nightly -> firefox@nightly

  # fix
  $ command rm -rf /usr/local/Caskroom/firefox-nightly
  ```
