<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [highlight output](#highlight-output)
  - [ack](#ack)
  - [less](#less)
  - [grep](#grep)
  - [highlight](#highlight)
  - [ccat](#ccat)
  - [others](#others)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## highlight output

>[!TIP]
> references:
> - [Colorized grep -- viewing the entire file with highlighted matches](https://stackoverflow.com/questions/981601/colorized-grep-viewing-the-entire-file-with-highlighted-matches)
> - [Highlight text similar to grep, but don't filter out text [duplicate]](https://stackoverflow.com/questions/7393906/highlight-text-similar-to-grep-but-dont-filter-out-text)


### [ack](https://metacpan.org/pod/ack)
```bash
$ curl -sg https://my.api.com | ack --passthru 'keyword'
```

### less
```bash
$ curl -sg https://my.api.com | less -i -p 'keyword'
```

### [grep](https://stackoverflow.com/a/981831/2940319)
```bash
$ command | grep --color=always 'pattern\|$'
$ command | grep --color=always -E 'pattern|$'
$ command | egrep --color=always 'pattern|$'
```
- example
  ```bash
  $ curl -sg 'https://my.api.com | jq -r . | grep --color=always '.*keyword.*\|$'

  # or
  $ curl -sg 'https://my.api.com | jq -r . | grep --color=always -E '| .*keyword.*'
  ```

### [highlight](http://www.andre-simon.de/doku/highlight/en/highlight.php)

> [!TIP]
> Highlight was designed to offer a flexible but easy to use syntax highlighter for several output formats. Instead of hardcoding syntax or colouring information, all relevant data is stored in configuration scripts. These scripts may be altered or enhanced with plug-in scripts.

```bash
$ highlight -i git.groovy -o git.groovy.html --syntax groovy --inline-css --include-style --line-numbers
```

### [ccat](https://github.com/owenthereal/ccat)

> [!TIP]
> ccat is the colorizing cat. It works similar to cat but displays content with syntax highlighting.

```bash
$ ccat /path/to/file.groovy

# output html format
$ ccat file.py --bg=dark --html

# get colors
$ ccat --palette
```

### others
- [dev-shell-essentials](https://github.com/kepkin/dev-shell-essentials)

