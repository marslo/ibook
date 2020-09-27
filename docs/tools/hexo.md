
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
- in Git repo
  ```bash
  $ git submodule add https://github.com/imarslo/hexo-theme-snark.git themes/snark
  ```

- in independent folder
  ```bash
  $ git clone https://github.com/imarslo/hexo-theme-snark.git themes/snark
  ```

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

```bash
$ sed '/highlight:/{n;s/^.*$/\ \ enable: false/}' -i _config.xml
$ sed '/highlight:/{n;n;s/^.*$/\ \ line_number: false/}' -i _config.xml
```
