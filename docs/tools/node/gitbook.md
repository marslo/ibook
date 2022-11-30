---
search:
    keywords: ['gitbook']
---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [gitbook-cli](#gitbook-cli)
  - [installation](#installation)
  - [initial `book.json`](#initial-bookjson)
- [gitbook format](#gitbook-format)
  - [hint](#hint)
  - [tab](#tab)
  - [code](#code)
  - [emoji](#emoji)
- [plugins](#plugins)
  - [Flexible Alerts](#flexible-alerts)
- [Q&A](#qa)
  - [`if (cb) cb.apply(this, arguments)`](#if-cb-cbapplythis-arguments)
  - [`TypeError [ERR_INVALID_ARG_TYPE]` in `git init`](#typeerror-err_invalid_arg_type-in-git-init)
  - [`unexpected token: .`](#unexpected-token-)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [gitbook 简明教程](http://www.chengweiyang.cn/gitbook/)
> - [gitbook 入门教程](https://yuzeshan.gitbooks.io/gitbook-studying/content/)
> - [Gitbook 打造的 Gitbook 说明文档](https://www.mapull.com/gitbook/default/)
>   - [基础命令](https://www.mapull.com/gitbook/comscore/basic/command.html)
>   - [第一本电子书](https://www.mapull.com/gitbook/comscore/basic/hello.html)
> - [book.json](http://www.chengweiyang.cn/gitbook/customize/book.json.html)
> - [emoji](https://gist.github.com/rxaviers/7360908)
> - [gitbook howto](https://coding-notes.readthedocs.io/en/latest/rst/dt/gitbook.html)
> - [gitbook 安装配置](http://gitbook.wiliam.me/)
> - [GitBook插件整理 - book.json](https://blog.csdn.net/qq_43514847/article/details/86598399)
> - [Gitbook常用插件简介](https://blog.csdn.net/qq_37149933/article/details/64170653)
> - [gitbook使用及book.json详细配置](https://blog.csdn.net/gongch0604/article/details/107494736)
> - [GitBookによるドキュメント作成](https://qiita.com/mebiusbox2/items/938af4b0d0bf7a4d3e33)
>
> useful plugins
> - [gitbook-plugin-fbqx](https://ymcatar.gitbooks.io/gitbook-test/content/testing_fbqx.html)
> - alert:
>   - `gitbook-plugin-alerts`
>   - `gitbook-plugin-flexible-alerts`
> - Anchors:
>   - `gitbook-plugin-anchors`
>   - `gitbook-plugin-anchor-navigation-ex`
>   - `gitbook-plugin-back-to-top-button`
> - toggle-chapters:
>   - `gitbook-plugin-chapter-fold`
>   - `gitbook-plugin-expandable-chapters`
> - code:
>   - `gitbook-plugin-code`
>   - `gitbook-plugin-copy-code-button`
> - fold
>   - `gitbook-plugin-expandable-chapters-small`
> - favicon
>   - `gitbook-plugin-favicon`
> - github:
>   - `gitbook-plugin-github`
>   - `gitbook-plugin-github-buttons`
> - Tbfed-pagefooter:
>   - `gitbook-plugin-tbfed-pagefooter`
> - Prism:
>   - `gitbook-plugin-prism`
> - search:
>   - `gitbook-plugin-search-plus`
>   - `gitbook-plugin-search-pro`
> - Sectionx:
>   - `gitbook-plugin-sectionx`
> - sharing:
>   - `gitbook-plugin-sharing-plus`
> - Splitter:
>   - `gitbook-plugin-splitter`
> - toc :
>   - `gitbook-plugin-atoc`
>   - `gitbook-plugin-simple-page-toc`
> - versions-select:
>   - `gitbook-plugin-versions-select`
> - [others](https://www.mapull.com/gitbook/comscore/custom/plugin/other/)
>
> resources:
> - [FontAwesome](https://fontawesome.com/)
> - [Google Font](https://fonts.google.com/)
> - [Google Icon](https://fonts.google.com/icons)
{% endhint %}

## gitbook-cli
### installation

- install
  ```bash
  # mac
  $ brew install node

  # RHEL8 (https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-centos-8)
  $ sudo dnf module list nodejs
  $ sudo dnf module enable nodejs:12
  $ sudo dnf install nodejs

  $ sudo npm i -g gitbook-cli [--save-dev]
  ```

- verify
  ```bash
  $ gitbook --version
  CLI version: 2.3.2
  GitBook version: 3.2.3
  ```

- check packages
  ```bash
  $ npm root -g
  /usr/local/lib/node_modules
  ```

### initial `book.json`
- gitbook install
  ```bash
  $ gitbook install
  info: installing 29 plugins using npm@3.9.2
  info:
  info: installing plugin "search-plus"
  info: install plugin "search-plus" (^0.0.11) from NPM with version 0.0.11
  /Users/marslo/mywork/tools/git/marslo/mbook
  └─┬ gitbook-plugin-search-plus@0.0.11
    └── html-entities@1.2.0
  ....
  ```

  - gitbook install in fresh environment"
    ```bash
    $ gitbook install --log=debug --debug
    Installing GitBook 3.2.3
      SOLINK_MODULE(target) Release/.node
      CXX(target) Release/obj.target/fse/fsevents.o
      SOLINK_MODULE(target) Release/fse.node
      SOLINK_MODULE(target) Release/.node
      CXX(target) Release/obj.target/fse/fsevents.o
      SOLINK_MODULE(target) Release/fse.node
    gitbook@3.2.3 ../../var/folders/s3/mg_f3cv54nn7y758j_t46zt40000gn/T/tmp-10600Rn1q3aFhRWiI/node_modules/gitbook
    ├── escape-html@1.0.3
    ├── escape-string-regexp@1.0.5
    ├── destroy@1.0.4
    ├── ignore@3.1.2
    ├── bash-color@0.0.4
    ├── gitbook-plugin-livereload@0.0.1
    ├── cp@0.2.0
    ...
    ```

  - alternatively
    ```bash
    $ gitbook serve
    Live reload server started on port: 35729
    Press CTRL+C to quit ...

    info: 7 plugins are installed
    info: 31 explicitly listed

    Error: Couldn't locate plugins "search-plus, simple-page-toc, github, github-buttons, prism, prism-themes, advanced-emoji, anchors, include-codeblock, ace, emphasize, katex, splitter, mermaid-gb3, tbfed-pagefooter, sectionx, local-video, anchor-navigation-ex, favicon, todo, alerts, include-csv, puml, sharing-plus, image-captions, donate, toggle-chapters, navigator, downloadpdf", Run 'gitbook install' to install plugins from registry.
    ```

#### gitbook install with proxy
> references:
> - [tbook install is not working when via proxy #33](https://github.com/GitbookIO/gitbook-cli/issues/33)

{% hint style='tip' %}
> Gitbook uses npmi, which requires npm-global, and npm-global further requires the currently installed npm on your machine.
{% endhint %}

```bash
$ npm config set strict-ssl false
$ npm config set proxy $http_proxy -g
$ npm config set https-proxy $https_proxy -g
```

## gitbook format
### hint

> [!TIP]
> references:
> - [Alerts](https://www.mapull.com/gitbook/comscore/custom/plugin/common/alerts.html)
> - [hints](https://github.com/GitbookIO/plugin-hints)
> - [gitbook-plugin-flexible-alerts](https://www.npmjs.com/package/gitbook-plugin-flexible-alerts-static)
> - [Simran-B/gitbook-plugin-callouts](https://github.com/Simran-B/gitbook-plugin-callouts)
> - [Hints and Callouts](https://docs.gitbook.com/editing-content/markdown#hints-and-callouts)


|   styles  | code                                                                                       | gitbook-plugin-flexible-alerts    |
|:---------:|:-------------------------------------------------------------------------------------------|:----------------------------------|
|    info   | {% raw %}`{% hint style='info' %}`{% endraw %}<br> {% raw %}`{% endhint %}`{% endraw %}    | {% raw %}> [!NOTE]{% endraw %}    |
|    tip    | {% raw %}`{% hint style='tip' %}`{% endraw %}<br> {% raw %}`{% endhint %}`{% endraw %}     | {% raw %}> [!TIP]{% endraw %}     |
|   danger  | {% raw %}`{% hint style='danger' %}`{% endraw %}<br> {% raw %}`{% endhint %}`{% endraw %}  | -                                 |
|  warning  | {% raw %}`{% hint style='warning' %}`{% endraw %}<br> {% raw %}`{% endhint %}`{% endraw %} | {% raw %}> [!WARNING]{% endraw %} |
|  success  | {% raw %}`{% hint style='success' %}`{% endraw %}<br> {% raw %}`{% endhint %}`{% endraw %} | -                                 |
| attention | -                                                                                          | {% raw %}> [!DANGER]{% endraw %}  |


#### success
{% hint style='success' %}
```javascript
{% hint style='success' %}
success
{% endhint %}
```
{% endhint %}

- or via `[!NOTE]`

  > [!NOTE]
  > ```javascript
  > > [!NOTE]
  > > tip <br>
  > > tip <br>
  > // or
  > > [!NOTE|style:flat|label:title|iconVisibility:hidden|icon:fa fa-bullhorn]
  > ```



#### tip
{% hint style='tip' %}
```javascript
{% hint style='tip' %}
info
{% endhint %}
```
{% endhint %}

- or via `[!TIP]`

  > [!TIP]
  > ```javascript
  > > [!TIP]
  > > tip <br>
  > > tip <br>
  > // or
  > > [!TIP|style:flat|label:title|iconVisibility:hidden|icon:fa fa-bullhorn]
  > ```

#### danger
{% hint style='danger' %}
```javascript
{% hint style='danger' %}
danger
{% endhint %}
```
{% endhint %}

- or `[!ATTENTION]`

  > [!ATTENTION]
  > ```javascript
  > > [!ATTENTION]
  > // or
  > > [!ATTENTION|style:flat|label:title|iconVisibility:hidden|icon:fa fa-bullhorn]
  > ```



#### warning
{% hint style='warning' %}
```javascript
{% hint style='warning' %}
warning
{% endhint %}
```
{% endhint %}

- or `[!WARNING]`

  > [!WARNING]
  > ```javascript
  > > [!WARNING]
  > // or
  > > [!WARNING|style:flat|label:title|iconVisibility:hidden|icon:fa fa-bullhorn]
  > ```

#### quote
{% hint style='info' %}
**Important info**: this *note* needs to be highlighted

```javascript
{% hint style='info' %}
**Important info**: this *note* needs to be highlighted
{% endhint %}
```
{% endhint %}

- or `[!COMMENT]`

  > [!COMMENT]
  > ```javascript
  > > [!COMMENT]
  > // or
  > > [!COMMENT|style:flat|label:title|iconVisibility:hidden|icon:fa fa-bullhorn]
  > ```

### tab

> [!TIP|style:flat|icon:fa fa-bullhorn]
> this function only for native [gitbook.io](https://www.gitbook.com/) <br>
> example:
> - [imarslo: kubernetes certicates](../../virtualization/kubernetes/certificates.html#check-info)
> <br>
> <br>
> reference:
> -[Templating](https://gitbookio.gitbooks.io/documentation/content/format/templating.html)

### code
- [gitbook.io](https://docs.gitbook.com/editing-content/rich-content/with-command-palette#tabs)
  {% raw %}
  ```
  {% tabs %}
  {% tab title="bash" %}
  {% code title="filename: bash.sh" %}
  # bash
  {% endcode %}
  {% endtab %}

  {% tab title="python" %}
  python
  {% endtab %}
  {% endtabs %}
  ```
  {% endraw %}

- [gitbook-plugin-codetabs](https://www.npmjs.com/package/gitbook-plugin-codetabs)

  {% raw %}
  ```bash
  {% codetabs name="this is bash", type="bash" -%}
  # type="bash"
  {%- language name="this is python", type="python" -%}
  # type="python"
  {%- endcodetabs %}
  ```
  {% endraw %}

### emoji
> **reference**:
> - [gist](https://gist.github.com/rxaviers/7360908)
> - [Emoji](https://github.com/StylishThemes/GitHub-Dark/wiki/Emoji)
> - [broken & new emojis](https://github.com/WebpageFX/emoji-cheat-sheet.com/issues/429)
> - [Emojis list from https://api.github.com/emojis](https://awes0mem4n.github.io/emojis-github.html)
> - [emoji-cheat-sheet.com](https://github.com/WebpageFX/emoji-cheat-sheet.com)

| **emoji**          | **code**             |
| :-:                | :-:                  |
| :joy:              | `:joy:`              |
| :u7981:            | `:u7981:`            |
| :u7121:            | `:u7121:`            |
| :white_check_mark: | `:white_check_mark:` |
| :four_leaf_clover: | `:four_leaf_clover:` |

## plugins
### Flexible Alerts

> [!TIP]
> references:
> - [npm: docsify-plugin-flexible-alerts](https://www.npmjs.com/package/docsify-plugin-flexible-alerts)
> - [fzankl/docsify-plugin-flexible-alerts](https://github.com/fzankl/docsify-plugin-flexible-alerts)
> - [Gitbook book.json 配置文件](https://www.mapull.com/gitbook/comscore/others/book.html)

#### setup
> [!NOTE|style:callout|label:book.json|icon:fa fa-bullhorn]
> - **book.json**:
>   ```json
>   {
>     "plugins": [
>       "flexible-alerts"
>     ],
>     "pluginsConfig": {
>       "flexible-alerts": {
>         "style": "callout",
>         "comment": {
>           "label": "Comment",
>           "icon": "fa fa-comments",
>           "className": "info"
>         }
>       }
>     }
>   }
>   ```
>
> - And then installed via
>   ```bash
>   $ gitbook install
>   # or package.json: { "scripts": { "built": "gitbook build --log=debug --debug" } }
>   $ npm run built
>   ```

#### usage
```markdown
> [!TIP|style:flat|label:My own heading|iconVisibility:hidden]
> An alert of type 'tip' using alert specific style 'flat' which overrides global style 'callout'.
> In addition, this alert uses an own heading and hides specific icon.
```

## Q&A
### `if (cb) cb.apply(this, arguments)`

> [!NOTE|style:callout]
> **reference**:
> - [How I fixed a "cb.apply is not a function" error while using Gitbook](https://flaviocopes.com/cb-apply-not-a-function/)

- issue
  ```bash
  $ gitbook serve
  Live reload server started on port: 35729
  Press CTRL+C to quit ...

  /usr/local/lib/node_modules/gitbook-cli/node_modules/npm/node_modules/graceful-fs/polyfills.js:287
        if (cb) cb.apply(this, arguments)
                   ^

  TypeError: cb.apply is not a function
      at /usr/local/lib/node_modules/gitbook-cli/node_modules/npm/node_modules/graceful-fs/polyfills.js:287:18
  ```

- solution:
  - raw `polyfills.js`
    ```javascript
    62   fs.stat = statFix(fs.stat)
    63   fs.fstat = statFix(fs.fstat)
    64   fs.lstat = statFix(fs.lstat)
    ```

  - fix `polyfills.js`
    ```javascript
    62   // fs.stat = statFix(fs.stat)
    63   // fs.fstat = statFix(fs.fstat)
    64   // fs.lstat = statFix(fs.lstat)
    ```

### `TypeError [ERR_INVALID_ARG_TYPE]` in `git init`
- issue
  ```bash
  $ gitbook init
  warn: no summary file in this book
  info: create README.md
  info: create SUMMARY.md

  TypeError [ERR_INVALID_ARG_TYPE]: The "data" argument must be of type string or an instance of Buffer, TypedArray, or DataView. Received an instance of Promise
  ```
- solution: downgrade the nodejs to `12.x.x`
  - [purge nodejs](../node.md#purge)
    ```bash
    $ brew uninstall node
    $ brew doctor
    $ brew cleanup --prune-prefix
    ```
  - re-install `node@12`
    ```bash
    $ brew install node@12
    $ brew link node@12
    $ cat >> ~/.bash_profile << EOF
    NODE_HOME='/usr/local/opt/node@12'
    LDFLAGS="-L${NODE_HOME}/lib ${LDFLAGS}"
    CPPFLAGS="-I${NODE_HOME}/include ${CPPFLAGS}"
    PATH=${NODE_HOME}/bin:$PATH
    export NODE_HOME LDFLAGS CPPFLAGS PATH
    EOF
    ```

### `unexpected token: .`
- issue
  ```bash
  $ git serve
  ...
  unexpected token: .
  ```

- [solution](https://blog.csdn.net/HammerTien/article/details/86613392)
  - raw code
    {% raw %}
    ```markdown
    '''bash
    $ k -n kube-system get pods \
    -o go-template \
    --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' \
    | head
    '''
    ```
    {% endraw %}

  - fixed code
    {% raw %}
    ```markdown
    {% raw %}
    '''bash
    $ k -n kube-system get pods \
        -o go-template \
        --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' \
        | head
    '''
    {% endraw %}
    ```
    {% endraw %}
