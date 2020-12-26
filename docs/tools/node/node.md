<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [npm configuration](#npm-configuration)
  - [registry](#registry)
- [npm usage](#npm-usage)
  - [upgrade](#upgrade)
- [npm packages](#npm-packages)
  - [view details](#view-details)
- [purge](#purge)
  - [macOS](#macos)
- [QnA](#qna)
  - [empty of `npm ls -g`](#empty-of-npm-ls--g)
  - [env: node: No such file or directory](#env-node-no-such-file-or-directory)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> reference:
> - [package.json](https://deleav.gitbooks.io/hellojs-gitbook/content/npmAndHexo/packagejson/)
> - [NodeJs Quick Start](https://nodejs.dev/learn/introduction-to-nodejs)
{% endhint %}

## npm configuration
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

## npm usage
### upgrade
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

## npm packages
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

## purge
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

## QnA
### empty of `npm ls -g`
```bash
$ npm ls -g
/usr/local/Cellar/node/15.0.1/lib
└── (empty)
```

#### [solution](https://github.com/npm/cli/issues/1962#issuecomment-715436030)
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
#### verify
```bash
$ npm ls -g
/usr/local/lib
├── -@0.0.1
├── commitizen@4.2.1
├── ...
└── verify-junit-xml@0.0.3
```

#### how to reproduce
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

#### [deep investigation](https://github.com/npm/cli/issues/1962#issuecomment-715911549)
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

### env: node: No such file or directory

#### possible cause
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

#### [solution](https://github.com/nvm-sh/nvm/issues/1702#issuecomment-444309875)
```bash
$ which node
/usr/local/opt/node@12/bin/node

$ sudo chown -R $(whoami) $(brew --prefix)/*

$ brew link --overwrite node@12
Linking /usr/local/Cellar/node@12/12.20.0... 3808 symlinks created

If you need to have this software first in your PATH instead consider running:
  echo 'export PATH="/usr/local/opt/node@12/bin:$PATH"' >> /Users/marslo/.bash_profile
```
