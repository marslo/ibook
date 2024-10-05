<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [node](#node)
  - [install](#install)
    - [n](#n)
    - [nvm](#nvm)
    - [volta](#volta)
  - [upgrade](#upgrade)
  - [purge node](#purge-node)
    - [macOS](#macos)
- [npm](#npm)
  - [configuration](#configuration)
    - [registry](#registry)
    - [completion](#completion)
  - [usage](#usage)
    - [npm upgrade](#npm-upgrade)
  - [packages](#packages)
    - [view details](#view-details)
- [troubleshooting](#troubleshooting)
  - [empty of `npm ls -g`](#empty-of-npm-ls--g)
  - [env: node: No such file or directory](#env-node-no-such-file-or-directory)
  - [`dyld[70742]: Library not loaded: /usr/local/opt/icu4c/lib/libicui18n.73.dylib`](#dyld70742-library-not-loaded-usrlocalopticu4cliblibicui18n73dylib)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> reference:
> - [package.json](https://deleav.gitbooks.io/hellojs-gitbook/content/npmAndHexo/packagejson/)
> - [NodeJs Quick Start](https://nodejs.dev/learn/introduction-to-nodejs)
{% endhint %}

# node
## install

> [!NOTE|label:references:]
> - [How to install latest version of Node using Brew](https://stackoverflow.com/a/27008484/2940319)
> - [4 ways to update to the latest Node.js version on a Mac](https://bytearcher.com/articles/ways-to-get-the-latest-node.js-version-on-a-mac/)
> - [Installing Node.js via package manager](https://nodejs.org/en/download/package-manager)

### [n](https://www.npmjs.com/package/n)

> [!NOTE|label:references:]
> - [tj/n](https://github.com/tj/n)
> - [mklement0/n-install](https://github.com/mklement0/n-install)
> - [Install Node.js to install n to install Node.js?](https://stackoverflow.com/a/30967671/2940319)

```bash
# tj/n
$ git clone --depth=1 https://github.com/tj/n /tmp/n && cd $_
$ sudo make install
# or
$ curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash

# n-install
$ curl -L https://bit.ly/n-install | bash
# install n to ~/util/n
$ curl -L https://bit.ly/n-install | N_PREFIX=~/util/n bash -s -- -y
```

### nvm

> [!NOTE|label:references:]
> - [nvm-sh/nvm](https://github.com/nvm-sh/nvm)

```bash
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# or
$ wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# or
$ curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash

# or
$ brew install nvm
```

- configure
```bash
$ cat >> ~/.bash_profile <<EOF
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
EOF

# or
$ cat >> ~/.bash_profile <<EOF
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
EOF

$ source ~/.bash_profile
```

- verify
  ```bash
  $ nvm install v12
  ```

### volta

> [!NOTE|label:references:]
> - [volta.sh](https://volta.sh/)

```bash
# install volta
$ curl https://get.volta.sh | bash
$ tail -n 2 ~/.bash_profile
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# install node@12
$ volta install node@12
success: installed and set node@12.22.12 (with npm@6.14.16) as default

# verify
$ node --version
v12.22.12
$ command -v node
/Users/marslo/.volta/bin/node
```

## upgrade
```bash
$ brew unlink node@12 --dry-run
Would remove:
/usr/local/include/node
/usr/local/lib/dtrace/node.d
/usr/local/share/doc/node
/usr/local/share/systemtap

$ brew unlink node@12
Unlinking /usr/local/Cellar/node@12/12.22.12_1... 4 symlinks removed.

$ brew link --overwrite node
Linking /usr/local/Cellar/node/21.6.2_1... 2019 symlinks created.
```

## purge node
### macOS

> reference:
> - [uninstall node js from mac](https://www.codegrepper.com/app/profile.php?id=49492)

```bash
sudo rm -rf ~/.npm ~/.nvm ~/node_modules ~/.node-gyp ~/.npmrc ~/.node_repl_history
sudo rm -rf /usr/local/bin/npm /usr/local/bin/node-debug /usr/local/bin/node /usr/local/bin/node-gyp
sudo rm -rf /usr/local/share/man/man1/node* /usr/local/share/man/man1/npm*
sudo rm -rf /usr/local/include/node /usr/local/include/node_modules
sudo rm -rf /usr/local/lib/node /usr/local/lib/node_modules /usr/local/lib/dtrace/node.d
sudo rm -rf /opt/local/include/node /opt/local/bin/node /opt/local/lib/node
sudo rm -rf /usr/local/share/doc/node
sudo rm -rf /usr/local/share/systemtap/tapset/node.stp

brew uninstall node
brew doctor
brew cleanup --prune-prefix
```

# npm
## configuration
### registry
```bash
$ npm config -g set registry https://registry.npm.taobao.org
$ npm config -g get registry
https://registry.npm.taobao.org/
```
- default:
  ```bash
  $ npm config get registry
  https://registry.npmjs.org/

  $ npm config -g get registry
  https://registry.npmjs.org/
  ```

### completion
- via npm
  ```bash
  $ command -v npm > /dev/null && source <( npm completion )
  # or
  $ command -v npm > /dev/null && eval $(npm completion)
  ```

- via [`Jephuff/npm-completion`]()https://github.com/Jephuff/npm-completion
  ```bash
  $ npm i -g npm-completion
  # for windows
  $ npm i -g npm-completion@windows

  $ npm-completion-setup
  $ npm-completion-upgrade
  ```
  - config
    ```bash
    # https://github.com/Jephuff/npm-bash-completion
    $ NPM_COMPLETION_PATH="/usr/local/lib/node_modules/npm-completion"
    $ test -f "${NPM_COMPLETION_PATH}/npm-completion.sh" && source "${NPM_COMPLETION_PATH}/npm-completion.sh"
    ```

## usage
### npm upgrade
```bash
$ npm install -g npm-check-updates
$ ncu -u
```
- [or](https://docs.npmjs.com/updating-packages-downloaded-from-the-registry)
  ```bash
  $ npm outdated -g --depth=0
  Package       Current  Wanted  Latest  Location
  react-sticky    5.0.8   5.0.8   6.0.3  global

  $ npm update -g react-sticky
  ```

## packages
### view details
```bash
$ npm view <package>
```
  - example
    ```bash
    $ npm view gitbook-cli

    gitbook-cli@2.3.2 | Apache-2.0 | deps: 11 | versions: 21
    CLI to generate books and documentation using gitbook
    https://www.gitbook.com

    bin: gitbook

    dist
    .tarball: https://registry.npm.taobao.org/gitbook-cli/download/gitbook-cli-2.3.2.tgz
    .shasum: 5e893582e1f743f6fa920c3c3eb36b62ea4a31a0

    dependencies:
    bash-color: 0.0.4 fs-extra: 3.0.1   npm: 5.1.0        optimist: 0.6.1   semver: 5.3.0     user-home: 2.0.0
    commander: 2.11.0 lodash: 4.17.4    npmi: 1.0.1       q: 1.5.0          tmp: 0.0.31

    maintainers:
    - aymeric-gb <aymeric@gitbook.com>
    - gitbook-bot <contact@gitbook.com>
    - jpreynat <johan.preynat@gmail.com>
    - samypesse <samypesse@gmail.com>

    dist-tags:
    latest: 2.3.2

    published over a year ago by aarono <aaron.omullan@gmail.com>
    ```

# troubleshooting
## empty of `npm ls -g`
```bash
$ npm ls -g
/usr/local/Cellar/node/15.0.1/lib
└── (empty)
```

- [solution](https://github.com/npm/cli/issues/1962#issuecomment-715436030)
  ```bash
  $ brew rm node
  Uninstalling /usr/local/Cellar/node/15.0.1... (3,331 files, 61MB)

  $ brew install node
  Updating Homebrew...
  ==> Auto-updated Homebrew!
  Updated 2 taps (homebrew/core and homebrew/cask).
  ==> Updated Formulae
  Updated 3 formulae.
  ==> Updated Casks
  ithoughtsx

  ==> Downloading https://homebrew.bintray.com/bottles/node-15.0.1.catalina.bottle.tar.gz
  ==> Downloading from https://d29vzk4ow07wi7.cloudfront.net/9cdf039763f006eef0cc0aaebb13bc8173f017d961ac41c30f26d45a23ecffe0?response-content-dispositio
  ######################################################################## 100.0%
  ==> Pouring node-15.0.1.catalina.bottle.tar.gz
  ==> Caveats
  Bash completion has been installed to:
    /usr/local/etc/bash_completion.d
  ==> Summary
  ☕️ 🐸  /usr/local/Cellar/node/15.0.1: 3,331 files, 61MB
  ```

- verify
  ```bash
  $ npm ls -g
  /usr/local/lib
  ├── -@0.0.1
  ├── commitizen@4.2.1
  ├── ...
  └── verify-junit-xml@0.0.3
  ```

- how to reproduce
  ```bash
  $ npm --version
  7.0.3
  $ npm root -g
  /usr/local/lib/node_module

  $ npm i -g npm@latest
  removed 51 packages, and changed 197 packages in 4s
  2 packages are looking for funding
    run `npm fund` for details
  $ npm -v
  6.14.8
  $ npm root -g
  /usr/local/Cellar/node/15.0.1/lib/node_modules

  $ npm i -g npm@7.0.3
  /usr/local/Cellar/node/15.0.1/bin/npm -> /usr/local/Cellar/node/15.0.1/lib/node_modules/npm/bin/npm-cli.js
  /usr/local/Cellar/node/15.0.1/bin/npx -> /usr/local/Cellar/node/15.0.1/lib/node_modules/npm/bin/npx-cli.js
  + npm@7.0.3
  updated 248 packages in 6.481s
  $ npm -v
  6.14.8
  $ npm root -g
  /usr/local/Cellar/node/15.0.1/lib/node_modules
  ```

- [deep investigation](https://github.com/npm/cli/issues/1962#issuecomment-715911549)
  ```bash
  $ npm config -g ls -l | grep prefix
  ; prefix = "/usr/local/Cellar/node/15.0.1" ; overridden by builtin
  save-prefix = "^"
  tag-version-prefix = "v"
  prefix = "/usr/local"

  $ npm i -g npm@7.0.5
  changed 1 package in 6s
  10 packages are looking for funding
    run `npm fund` for details
  $ npm config -g ls -l | grep prefix
  prefix = "/usr/local/Cellar/node/15.0.1"
  save-prefix = "^"
  tag-version-prefix = "v"
  $ npm -v
  7.0.5
  $ npm ls -g
  /usr/local/Cellar/node/15.0.1/lib
  └── (empty)

  $ npm config -g set prefix '/usr/local'
  $ npm ls -g
  /usr/local/lib
  ├── -@0.0.1
  ├── commitizen@4.2.1
  ├── diff-so-fancy@1.3.0
  ├── ...
  ```

## env: node: No such file or directory

- possible cause
  ```bash
     ╭─────────────────────────────────────────────────────────────────╮
     │                                                                 │
     │      New patch version of npm available! 6.14.8 → 6.14.10       │
     │   Changelog: https://github.com/npm/cli/releases/tag/v6.14.10   │
     │                Run npm install -g npm to update!                │
     │                                                                 │
     ╰─────────────────────────────────────────────────────────────────╯

  $ npm i -g npm
  /usr/local/bin/npx -> /usr/local/lib/node_modules/npm/bin/npx-cli.js
  /usr/local/bin/npm -> /usr/local/lib/node_modules/npm/bin/npm-cli.js
  + npm@6.14.10
  added 435 packages from 887 contributors in 4.481s
  ```

- [solution](https://github.com/nvm-sh/nvm/issues/1702#issuecomment-444309875)
  ```bash
  $ which node
  /usr/local/opt/node@12/bin/node

  $ sudo chown -R $(whoami) $(brew --prefix)/*

  $ brew link --overwrite node@12
  Linking /usr/local/Cellar/node@12/12.20.0... 3808 symlinks created

  If you need to have this software first in your PATH instead consider running:
    echo 'export PATH="/usr/local/opt/node@12/bin:$PATH"' >> /Users/marslo/.bash_profile
  ```

- info

  <!--sec data-title="more info" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  $ brew info node@12
  ==> node@12: stable 12.22.12 (bottled) [pinned at 12.22.12_1, keg-only]
  Platform built on V8 to build network applications
  https://nodejs.org/
  Disabled because it is not supported upstream!
  /usr/local/Cellar/node@12/12.22.12_1 (3,875 files, 51.6MB) *
    Poured from bottle on 2022-09-21 at 05:19:58
  From: https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/node@12.rb
  License: MIT
  ==> Dependencies
  Build: pkg-config ✔, python@3.9 ✔
  Required: brotli ✔, c-ares ✔, icu4c ✔, libnghttp2 ✔, libuv ✔, openssl@1.1 ✔, macos-term-size ✔
  ==> Caveats
  node@12 is keg-only, which means it was not symlinked into /usr/local,
  because this is an alternate version of another formula.

  If you need to have node@12 first in your PATH, run:
    echo 'export PATH="/usr/local/opt/node@12/bin:$PATH"' >> /Users/marslo/.bash_profile

  For compilers to find node@12 you may need to set:
    export LDFLAGS="-L/usr/local/opt/node@12/lib"
    export CPPFLAGS="-I/usr/local/opt/node@12/include"

  $ brew info node
  ==> node: stable 20.8.0 (bottled), HEAD
  Platform built on V8 to build network applications
  https://nodejs.org/
  /usr/local/Cellar/node/20.5.1 (2,356 files, 58MB)
    Poured from bottle using the formulae.brew.sh API on 2023-08-14 at 23:26:23
  /usr/local/Cellar/node/20.6.0 (2,398 files, 58.4MB)
    Poured from bottle using the formulae.brew.sh API on 2023-09-06 at 22:37:08
  /usr/local/Cellar/node/20.7.0 (2,517 files, 59.3MB)
    Poured from bottle using the formulae.brew.sh API on 2023-09-21 at 23:31:27
  /usr/local/Cellar/node/20.8.0 (2,517 files, 59.2MB)
    Poured from bottle using the formulae.brew.sh API on 2023-10-05 at 13:31:50
  From: https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/node.rb
  License: MIT
  ==> Dependencies
  Build: pkg-config ✔, python@3.11 ✔
  Required: brotli ✔, c-ares ✔, icu4c ✔, libnghttp2 ✔, libuv ✔, openssl@3 ✔
  ==> Options
  --HEAD
    Install HEAD version
  ==> Caveats
  Bash completion has been installed to:
    /usr/local/etc/bash_completion.d
  ==> Analytics
  install: 236,495 (30 days), 613,011 (90 days), 1,316,363 (365 days)
  install-on-request: 202,391 (30 days), 538,160 (90 days), 1,166,207 (365 days)
  build-error: 360 (30 days)
  ```
  <!--endsec-->

## `dyld[70742]: Library not loaded: /usr/local/opt/icu4c/lib/libicui18n.73.dylib`

- info
  ```bash
  $ node --version
  dyld[73388]: Library not loaded: /usr/local/opt/icu4c/lib/libicui18n.73.dylib
    Referenced from: <EC40B82A-EB42-3D50-9D84-18BC05643BD3> /usr/local/Cellar/node/21.1.0/bin/node
    Reason: tried: '/usr/local/opt/icu4c/lib/libicui18n.73.dylib' (no such file), '/System/Volumes/Preboot/Cryptexes/OS/usr/local/opt/icu4c/lib/libicui18n.73.dylib' (no such file), '/usr/local/opt/icu4c/lib/libicui18n.73.dylib' (no such file), '/usr/local/Cellar/icu4c/74.2/lib/libicui18n.73.dylib' (no such file), '/System/Volumes/Preboot/Cryptexes/OS/usr/local/Cellar/icu4c/74.2/lib/libicui18n.73.dylib' (no such file), '/usr/local/Cellar/icu4c/74.2/lib/libicui18n.73.dylib' (no such file)
  Abort trap: 6

  $ which -a node
  /usr/local/Cellar/node/21.1.0/bin/node
  /usr/local/bin/node
  ```

  <!--sec data-title="more info" data-id="section1" data-show=true data-collapse=true ces-->
  ```bash
  $ brew unlink node@12 --dry-run
  Would remove:
  /usr/local/include/node
  /usr/local/lib/dtrace/node.d
  /usr/local/share/doc/node
  /usr/local/share/systemtap
  ```
  <!--endsec-->

- debug

  > [!NOTE|label:references:]
  > - [Node installation in homebrew vs miniconda](https://stackoverflow.com/q/77998023/2940319)

  ```bash
  $ otool -L $(which node) | grep icu4c
    /usr/local/opt/icu4c/lib/libicui18n.73.dylib (compatibility version 73.0.0, current version 73.2.0)
    /usr/local/opt/icu4c/lib/libicuuc.73.dylib (compatibility version 73.0.0, current version 73.2.0)
    /usr/local/opt/icu4c/lib/libicudata.73.dylib (compatibility version 73.0.0, current version 73.2.0)
    /usr/local/opt/icu4c/lib/libicui18n.71.dylib (compatibility version 71.0.0, current version 71.1.0)
    /usr/local/opt/icu4c/lib/libicuuc.71.dylib (compatibility version 71.0.0, current version 71.1.0)
    /usr/local/opt/icu4c/lib/libicudata.71.dylib (compatibility version 71.0.0, current version 71.1.0)
  ```

  <!--sec data-title="full list of otool" data-id="section2" data-show=true data-collapse=true ces-->
  ```bash
  $ otool -L $(which node)
  /usr/local/Cellar/node/21.1.0/bin/node:
    /usr/lib/libz.1.dylib (compatibility version 1.0.0, current version 1.2.12)
    /usr/local/opt/libuv/lib/libuv.1.dylib (compatibility version 2.0.0, current version 2.0.0)
    /usr/local/opt/brotli/lib/libbrotlidec.1.dylib (compatibility version 1.0.0, current version 1.1.0)
    /usr/local/opt/brotli/lib/libbrotlienc.1.dylib (compatibility version 1.0.0, current version 1.1.0)
    /usr/local/opt/c-ares/lib/libcares.2.dylib (compatibility version 2.0.0, current version 2.7.1)
    /usr/local/opt/libnghttp2/lib/libnghttp2.14.dylib (compatibility version 40.0.0, current version 40.0.0)
    /usr/local/opt/openssl@3/lib/libcrypto.3.dylib (compatibility version 3.0.0, current version 3.0.0)
    /usr/local/opt/openssl@3/lib/libssl.3.dylib (compatibility version 3.0.0, current version 3.0.0)
    /usr/local/opt/icu4c/lib/libicui18n.73.dylib (compatibility version 73.0.0, current version 73.2.0)
    /usr/local/opt/icu4c/lib/libicuuc.73.dylib (compatibility version 73.0.0, current version 73.2.0)
    /usr/local/opt/icu4c/lib/libicudata.73.dylib (compatibility version 73.0.0, current version 73.2.0)
    /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation (compatibility version 150.0.0, current version 2048.1.255)
    /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1600.151.0)
    /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1336.0.0)
  /usr/local/bin/node:
    /usr/lib/libz.1.dylib (compatibility version 1.0.0, current version 1.2.11)
    /usr/local/opt/brotli/lib/libbrotlidec.1.dylib (compatibility version 1.0.0, current version 1.0.9)
    /usr/local/opt/brotli/lib/libbrotlienc.1.dylib (compatibility version 1.0.0, current version 1.0.9)
    /usr/local/opt/c-ares/lib/libcares.2.dylib (compatibility version 2.0.0, current version 2.5.1)
    /usr/local/opt/libnghttp2/lib/libnghttp2.14.dylib (compatibility version 38.0.0, current version 38.0.0)
    /usr/local/opt/openssl@1.1/lib/libcrypto.1.1.dylib (compatibility version 1.1.0, current version 1.1.0)
    /usr/local/opt/openssl@1.1/lib/libssl.1.1.dylib (compatibility version 1.1.0, current version 1.1.0)
    /usr/local/opt/icu4c/lib/libicui18n.71.dylib (compatibility version 71.0.0, current version 71.1.0)
    /usr/local/opt/icu4c/lib/libicuuc.71.dylib (compatibility version 71.0.0, current version 71.1.0)
    /usr/local/opt/icu4c/lib/libicudata.71.dylib (compatibility version 71.0.0, current version 71.1.0)
    /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation (compatibility version 150.0.0, current version 1858.112.0)
    /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1311.100.3)
    /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1300.23.0)
  ```
  <!--endsec-->

- solution
  ```bash
  $ showpath
  ...
  /usr/local/Cellar/node/21.1.0/bin
  ..

  # issue fix
  $ NODE_HOME=$(brew --prefix node)
  $ export PATH=$NODE_HOME:$PATH

  # verify
  $ node --version
  v21.6.2
  $ otool -L $(which node) | grep icu4c
    /usr/local/opt/icu4c/lib/libicui18n.74.dylib (compatibility version 74.0.0, current version 74.2.0)
    /usr/local/opt/icu4c/lib/libicuuc.74.dylib (compatibility version 74.0.0, current version 74.2.0)
    /usr/local/opt/icu4c/lib/libicudata.74.dylib (compatibility version 74.0.0, current version 74.2.0)
  ```
