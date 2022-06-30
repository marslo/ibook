<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Yaml](#yaml)
- [ruby](#ruby)
- [Thanks](#thanks)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Yaml
- [download](http://pyyaml.org/download/libyaml/)
- yaml lib installation
  - download by wget
    ```bash
    $ wget http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz
    $ tar xf yaml-0.1.6.tar.gz && cd yaml-0.1.6
    ```

  - compile and installation
    ```bash
    $ ./configure --prefix=/usr/local
    $ make && sudo make install
    ```

### ruby
- [download official webiste](https://www.ruby-lang.org/en/downloads/)
  - [current stable ruby 2.1.2](http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz)
  - [previous stable ruby 2.0.0-p481](http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p481.tar.gz)
  - [old stable ruby 1.9.3-p547](http://cache.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p547.tar.gz)

- ruby installation
  - download by wget
    ```bash
    $ wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz
    $ tar xf ruby-2.1.2.tar.gz && cd ruby-2.1.2
    ```

  - compile and install
    ```bash
    $ ./configure --prefix=/usr/local/ruby --enable-shared --with-opt-dir=/usr/local/lib
    $ make && sudo make install
    ```

  - libs installation
    - openssl
      ```bash
      $ cd ext/openssl
      $ ruby extconf.rb
      $ make && sudo make install
      ```

### Thanks
- [collectiveidea.com](http://collectiveidea.com/blog/archives/2011/10/31/install-ruby-193-with-libyaml-on-centos/)
