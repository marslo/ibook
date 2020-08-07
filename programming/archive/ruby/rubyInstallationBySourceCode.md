<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Yaml](#yaml)
- [Ruby](#ruby)
- [Thanks](#thanks)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Yaml
- [Download](http://pyyaml.org/download/libyaml/)
- Yaml Lib Installation
    - Download by wget
        <pre><code>┌─ (marslo@MarsloJiao ~/Tools/SourceCode/Ruby) ->
        └─ $ wget http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz
        ┌─ (marslo@MarsloJiao ~/Tools/SourceCode/Ruby) ->
        └─ $ tar xf yaml-0.1.6.tar.gz && cd yaml-0.1.6
        </code></pre>
    - Compile and installation
        <pre><code>┌─ (marslo@MarsloJiao ~/Tools/SourceCode/Ruby/yaml-0.1.6) ->
        └─ $ ./configure --prefix=/usr/local
        ┌─ (marslo@MarsloJiao ~/Tools/SourceCode/Ruby) ->
        └─ $ make && sudo make install
        </code></pre>

### Ruby
- [Download official webiste](https://www.ruby-lang.org/en/downloads/)
  - [Current Stable Ruby 2.1.2](http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz)
  - [Previous Stable Ruby 2.0.0-p481](http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p481.tar.gz)
  - [Old Stable Ruby 1.9.3-p547](http://cache.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p547.tar.gz)
- Ruby Installation
    - Download by wget
        <pre><code>┌─ (marslo@MarsloJiao ~/Tools/SourceCode/Ruby) ->
        └─ $ wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz
        ┌─ (marslo@MarsloJiao ~/Tools/SourceCode/Ruby) ->
        └─ $ tar xf ruby-2.1.2.tar.gz && cd ruby-2.1.2
        </code></pre>
    - Compile and install
        <pre><code>┌─ (marslo@MarsloJiao ~/Tools/SourceCode/Ruby/ruby-2.1.2) ->
        └─ $ ./configure --prefix=/usr/local/ruby --enable-shared --with-opt-dir=/usr/local/lib
        ┌─ (marslo@MarsloJiao ~/Tools/SourceCode/Ruby/ruby-2.1.2) ->
        └─ $ make && sudo make install
        </code></pre>
    - Libs installation
        - OpenSSL
            <pre><code>┌─ (marslo@MarsloJiao ~/Tools/SourceCode/Ruby/ruby-2.1.2) ->
            └─ $ cd ext/openssl
            ┌─ (marslo@MarsloJiao ~/Tools/SourceCode/Ruby/ruby-2.1.2/ext/openssl) ->
            └─ $ ruby extconf.rb
            ┌─ (marslo@MarsloJiao ~/Tools/SourceCode/Ruby/ruby-2.1.2/ext/openssl) ->
            └─ $ make && sudo make install
            </code></pre>

### Thanks
- [collectiveidea.com](http://collectiveidea.com/blog/archives/2011/10/31/install-ruby-193-with-libyaml-on-centos/)
