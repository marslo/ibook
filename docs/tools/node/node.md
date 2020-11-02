<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [npm configuration](#npm-configuration)
  - [registry](#registry)
- [npm usage](#npm-usage)
  - [upgrade](#upgrade)
- [QnA](#qna)
  - [empty of `npm ls -g`](#empty-of-npm-ls--g)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## npm configuration
### registry
```bash
$ npm config -g set registry https://registry.npm.taobao.org
$ npm config -g get registry
https://registry.npm.taobao.org/
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
