<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [download nodejs](#download-nodejs)
- [install `yo`](#install-yo)
- [install compass by `gem`](#install-compass-by-gem)
- [install `angular`](#install-angular)
- [startup server](#startup-server)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### download nodejs
- for 64bit
  ```bash
  $ wget http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x64.tar.gz
  ```

- for 32bit
  ```bash
  $ wget http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x86.tar.gz
  ```

### install `yo`
```bash
$ sudo npm install -g yo
```

### install compass by `gem`

> - [The solution](https://github.com/Marslo/MyBlog/blob/master/Programming/Ruby/RubyInstallationQ&A.md#libyaml-0so2--psychso) for `kernel_require.rb:55:in `require': libyaml-0.so.2: cannot open shared object file: No such file or directory - /../../psych.so (LoadError)`

```bash
$ sudo gem install compass
```

### install `angular`
```bash
$ npm install generator-angular
$ yo angular
$ bower install
```

### startup server
```bash
$ grunt serve
```
