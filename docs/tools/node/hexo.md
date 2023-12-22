<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [prepare](#prepare)
- [init](#init)
- [add theme](#add-theme)
  - [clone code](#clone-code)
  - [install plugin](#install-plugin)
  - [generate new pages](#generate-new-pages)
  - [diable the default highlight settings](#diable-the-default-highlight-settings)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## prepare
```bash
$ npm i -g hexo-cli
```

## init
```bash
$ mkdir myblog && cd myblog
$ hexo init
```

  <!--sec data-title="init details" data-id="section1" data-show=true data-collapse=true ces-->
  ```bash
  $ hexo init
  INFO  Cloning hexo-starter https://github.com/hexojs/hexo-starter.git
  INFO  Install dependencies
  added 183 packages from 421 contributors and audited 189 packages in 22.277s

  12 packages are looking for funding
    run `npm fund` for details

  found 0 vulnerabilities

  INFO  Start blogging with Hexo!
  ```
  <!--endsec-->

## add theme
> credit belongs to [snark](https://github.com/Litreily/hexo-theme-snark)

### clone code

{% codetabs name="In a Git repo", type="bash" -%}
$ git submodule add https://github.com/imarslo/hexo-theme-snark.git themes/snark
{%- language name="In a folder", type="bash" -%}
$ git clone https://github.com/imarslo/hexo-theme-snark.git themes/snark
$ sed '/highlight:/{n;s/^.*$/\ \ enable: false/}' -i _config.xml
$ sed '/highlight:/{n;n;s/^.*$/\ \ line_number: false/}' -i _config.xml
{%- language name="Update theme", type="bash" -%}
$ git submodule sync --recursive
$ git submodule update --init --recursive
{%- endcodetabs %}

### install plugin
```bash
$ npm install hexo-renderer-pug --save
$ npm install hexo-renderer-sass --save
$ npm install hexo-generator-feed --save
$ npm install hexo-generator-search --save
$ npm install hexo-generator-sitemap --save
```

### generate new pages
```bash
$ hexo new page archives
$ hexo new page categories
$ hexo new page tags
$ hexo new page about
```

### diable the default highlight settings
> default settings in `_config.xml`

{% codetabs name="cmd with sed", type="bash" -%}
$ sed '/highlight:/{n;s/^.*$/\ \ enable: false/;n;s/^.*$/\ \ line_number: false/;}' -i _config.xml
{%- language name="or", type="bash" -%}
$ sed '/highlight:/{n;s/^.*$/\ \ enable: false/}' -i _config.xml
$ sed '/highlight:/{n;n;s/^.*$/\ \ line_number: false/}' -i _config.xml
{%- language name="result", type="bash" -%}
$ grep highlight: _config.yml -A 6
highlight:
  enable: false
  line_number: false
  auto_detect: false
  tab_replace: ''
  wrap: true
  hljs: false
{%- endcodetabs %}
