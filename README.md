
## gitbook install

> IMPORTANT !!
> maximum node version supported is v12

### install node v12.22.12
```bash
# install node v12.22.12 (LTS)
$ [[ -d /opt/node ]] || mkdir -p /opt/node
$ curl -fsSL https://nodejs.org/dist/v12.22.12/node-v12.22.12-linux-x64.tar.xz | tar xJf - -C /opt/node/
$ sudo update-alternatives --install /usr/local/bin/npm12  npm12  /opt/node/node-v12.22.12-linux-x64/bin/npm  10
$ sudo update-alternatives --install /usr/local/bin/node12 node12 /opt/node/node-v12.22.12-linux-x64/bin/node 10
$ sudo update-alternatives --install /usr/local/bin/npx12  npx12  /opt/node/node-v12.22.12-linux-x64/bin/npx  10

# setup v12.22.12 as global version temporary
## backup current latst node/npm/npx
$ sudo mv /usr/local/bin/node{,21}
$ sudo mv /usr/local/bin/npm{,21}
$ sudo mv /usr/local/bin/npx{,21}

## setup global environment to v12 temporary
$ sudo ln -sf /usr/local/bin/npx12  /usr/local/bin/npx
$ sudo ln -sf /usr/local/bin/node12 /usr/local/bin/node
$ sudo ln -sf /usr/local/bin/npm12  /usr/local/bin/npm
```

### install gitbook

> [!NOTE]
> - [Setup and Installation of GitBook](https://github.com/GitbookIO/gitbook/blob/master/docs/setup.md)

```bahs
$ sudo npm i -g gitbook-cli

# fix `if (cb) cb.apply(this, arguments)` issue
$ vim /usr/local/lib/node_modules/gitbook-cli/node_modules/npm/node_modules/graceful-fs/polyfills.js
62   // fs.stat = statFix(fs.stat)
63   // fs.fstat = statFix(fs.fstat)
64   // fs.lstat = statFix(fs.lstat)

# install gitboook
$ gitbook fetch
CLI version: 2.3.2
Installing GitBook 3.2.3
gitbook@3.2.3 ../../tmp/tmp-32425LAgPJFMksM6Y/node_modules/gitbook
...

# verify
$ gitbook --version
CLI version: 2.3.2
GitBook version: 3.2.3
```

- others commands
  ```bash
  # to list all versions
  $ gitbook ls-remote
  Available GitBook Versions:
       4.0.0-alpha.6, 4.0.0-alpha.5, 4.0.0-alpha.4, 4.0.0-alpha.3, 4.0.0-alpha.2, 4.0.0-alpha.1, 3.2.3, 3.2.2, 3.2.1, 3.2.0, 3.2.0-pre.1, 3.2.0-pre.0, 3.1.1, 3.1.0, 3.0.3, 3.0.2, 3.0.1, 3.0.0, 3.0.0-pre.15, 3.0.0-pre.14, 3.0.0-pre.13, 3.0.0-pre.12, 3.0.0-pre.11, 3.0.0-pre.10, 3.0.0-pre.9, 3.0.0-pre.8, 3.0.0-pre.7, 3.0.0-pre.6, 3.0.0-pre.5, 3.0.0-pre.4, 3.0.0-pre.3, 3.0.0-pre.2, 3.0.0-pre.1, 2.6.9, 2.6.8, 2.6.7, 2.6.6, 2.6.5, 2.6.4, 2.6.3, 2.6.2, 2.6.1, 2.6.0, 2.5.2, 2.5.1, 2.5.0, 2.5.0-beta.7, 2.5.0-beta.6, 2.5.0-beta.5, 2.5.0-beta.4, 2.5.0-beta.3, 2.5.0-beta.2, 2.5.0-beta.1, 2.4.3, 2.4.2, 2.4.1, 2.4.0, 2.3.3, 2.3.2, 2.3.1, 2.3.0, 2.2.0, 2.1.0, 2.0.4, 2.0.3, 2.0.2, 2.0.1, 2.0.0, 2.0.0-beta.5, 2.0.0-beta.4, 2.0.0-beta.3, 2.0.0-beta.2, 2.0.0-beta.1, 2.0.0-alpha.9, 2.0.0-alpha.8, 2.0.0-alpha.7, 2.0.0-alpha.6, 2.0.0-alpha.5, 2.0.0-alpha.4, 2.0.0-alpha.3, 2.0.0-alpha.2, 2.0.0-alpha.1

  Tags:
       latest : 2.6.9
       pre : 4.0.0-alpha.6


  # install pre version
  $ gitbook fetch 4.0.0-alpha.6

  # to update to latest stable version (2.6.9)
  $ gitbook update
  ```

### setup local node environment
```bash
$ cd /path/to/repo

# install dependencies
$ gitbook install
# or
$ npm install
# or
$ npm12 install
```

- verify local node/gitbook environment
  ```bash
  $ gitbook build --log=debug --debug
  $ gitbook serve
  $ gitbook serve --config=book.json
  ```

### revert global node to latest version
```bash
$ sudo ln -sf /usr/local/bin/node21 /usr/local/bin/node
$ sudo ln -sf /usr/local/bin/npm21  /usr/local/bin/npm
$ sudo ln -sf /usr/local/bin/npx21  /usr/local/bin/npx
```

## basic usage

- check npm run commands:
  ```bash
  $ npm run
  Scripts available in ibook@3.2.3 via `npm run-script`:
    ibook:prepare
      gitbook install
    ibook:watch
      npm run ibook:prepare && gitbook serve
    ibook:dev
      cd books && gitbook serve --config=../book.json
    clean
      [ -d node_modules ] && rm -rf node_modules; [ -d _book ] && rm -rf _book
    builtall
      [ -d node_modules ] && rm -rf node_modules; [ -d _book ] && rm -rf _book; gitbook install && gitbook build --log=debug --debug
    built
      [ -d _book ] && rm -rf _book; gitbook build --log=debug --debug
    ibook
      gitbook install && gitbook serve
    deploy
      bash deploy.sh doDeploy
  ```

- build and deploy
  ```bash
  $ npm run deploy

  # or
  $ npm12 run deploy
  ```
