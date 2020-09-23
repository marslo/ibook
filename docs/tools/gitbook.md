---
search:
    keywords: ['gitbook']
---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [`gitbook-cli`](#gitbook-cli)
  - [installation](#installation)
  - [initial `book.json`](#initial-bookjson)
- [gitbook format](#gitbook-format)
  - [hints](#hints)
  - [tab](#tab)
  - [emoji](#emoji)
- [Q&A](#qa)
  - [`if (cb) cb.apply(this, arguments)`](#if-cb-cbapplythis-arguments)
- [reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## `gitbook-cli`
### installation
```bash
$ brew install node
$ npm i -g gitbook-cli [--save-dev]
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

  - Error
  ```bash
  $ gitbook serve
  Live reload server started on port: 35729
  Press CTRL+C to quit ...

  info: 7 plugins are installed
  info: 31 explicitly listed

  Error: Couldn't locate plugins "search-plus, simple-page-toc, github, github-buttons, prism, prism-themes, advanced-emoji, anchors, include-codeblock, ace, emphasize, katex, splitter, mermaid-gb3, tbfed-pagefooter, sectionx, local-video, anchor-navigation-ex, favicon, todo, alerts, include-csv, puml, sharing-plus, image-captions, donate, toggle-chapters, navigator, downloadpdf", Run 'gitbook install' to install plugins from registry.
  ```

## gitbook format
### tab

#### code

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


## Q&A
### `if (cb) cb.apply(this, arguments)`
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

### `unexpected token: .`
- issue
  ```bash
  $ git serve
  ...
  unexpected token: .
  ```

- [solution](https://blog.csdn.net/HammerTien/article/details/86613392)

  - raw code
    ```markdown
    invalid code here
    ```

  - fixed code
    {% raw %}
    ```markdown

    {% raw %}
    invalide code here
    {% endraw %}

    ```
    {% endraw %}

## reference
- [gitbook 简明教程](http://www.chengweiyang.cn/gitbook/)
- [gitbook 入门教程](https://yuzeshan.gitbooks.io/gitbook-studying/content/)
- [book.json](http://www.chengweiyang.cn/gitbook/customize/book.json.html)
- [emoji](https://gist.github.com/rxaviers/7360908)
- [gitbook howto](https://coding-notes.readthedocs.io/en/latest/rst/dt/gitbook.html)
- [gitbook 安装配置](http://gitbook.wiliam.me/)
