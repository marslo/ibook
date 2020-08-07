<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Download NodeJs](#download-nodejs)
- [Install `yo`](#install-yo)
- [Install compass by `gem`](#install-compass-by-gem)
- [Install `Angular`](#install-angular)
- [Startup server](#startup-server)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Download NodeJs
- For 64bit
    <pre><code>┌─ (marslo@MarsloJiao ~) ->
    └─ $ wget http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x64.tar.gz
    </code></pre>

- For 32bit
    <pre><code>┌─ (marslo@MarsloJiao ~) ->
    └─ $ wget http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x86.tar.gz
    </code></pre>

### Install `yo`
    ┌─ (marslo@MarsloJiao ~) ->
    └─ $ sudo npm install -g yo
    
### Install compass by `gem`
    ┌─ (marslo@MarsloJiao ~) ->
    └─ $ sudo gem install compass

- [The solution](https://github.com/Marslo/MyBlog/blob/master/Programming/Ruby/RubyInstallationQ&A.md#libyaml-0so2--psychso) for `kernel_require.rb:55:in `require': libyaml-0.so.2: cannot open shared object file: No such file or directory - /../../psych.so (LoadError)`
    
### Install `Angular`
    ┌─ (marslo@MarsloJiao ~/client) ->
    └─ $ npm install generator-angular
    ┌─ (marslo@MarsloJiao ~/client) ->
    └─ $ yo angular
    ┌─ (marslo@MarsloJiao ~/client) ->
    └─ $ bower install
    
### Startup server
    ┌─ (marslo@MarsloJiao ~/client) ->
    └─ $ grunt serve
