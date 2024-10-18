<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [highlight output](#highlight-output)
  - [ack](#ack)
  - [less](#less)
  - [grep](#grep)
  - [highlight](#highlight)
  - [ccat](#ccat)
  - [render visualization of hexadecimal colors](#render-visualization-of-hexadecimal-colors)
  - [others](#others)
- [remove highlight](#remove-highlight)
- [alias](#alias)
  - [`bash -<parameter>`](#bash--parameter)
- [get cookie from firefox](#get-cookie-from-firefox)
- [authentication](#authentication)
  - [Special Characters in Usernames and Passwords](#special-characters-in-usernames-and-passwords)
- [downlaods bookmark](#downlaods-bookmark)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## highlight output

>[!TIP]
> references:
> - [Colorized grep -- viewing the entire file with highlighted matches](https://stackoverflow.com/questions/981601/colorized-grep-viewing-the-entire-file-with-highlighted-matches)
> - [Highlight text similar to grep, but don't filter out text [duplicate]](https://stackoverflow.com/questions/7393906/highlight-text-similar-to-grep-but-dont-filter-out-text)
> - [kilobyte/colorized-logs](https://github.com/kilobyte/colorized-logs)


### [ack](https://metacpan.org/pod/ack)
```bash
$ curl -sg https://api.domain.com | ack --passthru 'keyword'
```

### less
```bash
$ curl -sg https://api.domain.com | less -i -p 'keyword'
```

### [grep](https://stackoverflow.com/a/981831/2940319)
```bash
$ command | grep --color=always 'pattern\|$'
$ command | grep --color=always -E 'pattern|$'
$ command | egrep --color=always 'pattern|$'
```
- example
  ```bash
  $ curl -sg 'https://api.domain.com | jq -r . | grep --color=always '.*keyword.*\|$'

  # or
  $ curl -sg 'https://api.domain.com | jq -r . | grep --color=always -E '| .*keyword.*'
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

### render visualization of hexadecimal colors

> [!NOTE|label:references:]
> - [#2705 Render visualization of hexadecimal colors (or other common formats) using true color ANSI escape sequences](https://github.com/sharkdp/bat/issues/2705)
```bash
# colorcat
# - cats a file, but if any line contains N hex colors, it appends the colors
#   (rendered as ansi escape sequences) to the end of the line.
# - input can be stdin, a file, or a hex color in plain text
function colorcat() {
  if [[ "$#" -eq 1 && ! -f "$1" ]]; then
    echo "$1"
  else
    cat "$@"
  fi | while read -r line; do
    local colors=""
    for word in $line; do
      if [[ "$word" =~ ^[^A-Fa-f0-9]*#?([A-Fa-f0-9]{6})[^A-Fa-f0-9]*$ ]]; then
        hex=${BASH_REMATCH[1]}
        local r=$((16#${hex:0:2}))
        local g=$((16#${hex:2:2}))
        local b=$((16#${hex:4:2}))
        local truecolor="\033[48;2;${r};${g};${b}m"
        local reset="\033[0m"
        colors="${colors}${truecolor}  ${reset} "
      fi
    done
      echo -e "$line $colors"
  done
}
```

### others
- [dev-shell-essentials](https://github.com/kepkin/dev-shell-essentials)

## remove highlight

> [!TIP]
> references:
> - [Removing colors from output](https://stackoverflow.com/a/18000433/2940319)
> - [Remove ANSI color codes from a text file using bash](https://stackoverflow.com/a/30938702/2940319)

```bash
$ <cmd> | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g"

# or
$ alias decolorize='sed -r "s/\x1B\[(([0-9]+)(;[0-9]+)*)?[mGKHfJ]//g"'
# deprecated
# $ alias decolorize='sed -r "s/\\x1B\\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"'
$ command | decolorize
```

- tips
  ```bash
  $ git br -a | cat -A
  * ^[[1;32mmarslo^[[m$
    ^[[31mremotes/origin/marslo^[[m$
    ^[[31mremotes/origin/gh-pages^[[m$
    ^[[31mremotes/origin/gitbook^[[m$
    ^[[31mremotes/origin/master^[[m$
    ^[[33mgh-pages^[[m$
    ^[[33mmaster^[[m$
    ^[[31mremotes/origin/sample^[[m$

  $ git br -a | decolorize | cat -A
  * marslo$
    remotes/origin/marslo$
    remotes/origin/gh-pages$
    remotes/origin/gitbook$
    remotes/origin/master$
    gh-pages$
    master$
    remotes/origin/sample$
  ```

## [alias](https://askubuntu.com/a/871435)

> [!NOTE|label:references:]
> - [_complete_alias](https://unix.stackexchange.com/a/332522/29178) | [cykerway/complete-alias](https://github.com/cykerway/complete-alias)
> - [How do I get bash completion for command aliases?](https://unix.stackexchange.com/a/332522/29178)
> - [make-completion-wrapper](https://unix.stackexchange.com/a/4220/29178)
> - [make-completion-wrapper](https://unix.stackexchange.com/a/310089/29178)
> - [bash-completion/README](https://github.com/scop/bash-completion/blob/2.1/README#L113)

```bash
$ echo ${BASH_ALIASES[ls]}
ls --color=always
```

### [`bash -<parameter>`](https://unix.stackexchange.com/a/38363/29178)
- get bash login log ( for rc script debug )
  ```bash
  $ bash -l -v
  ```

- run with only one startup file ( for sharing accounts )
  ```bash
  $ bash -i --rcfile="$HOME/.marslo/.imarslo"
  ```

## get cookie from firefox
```bash
$ grep -oP '"url":"\K[^"]+' $(ls -t ~/.mozilla/firefox/*/sessionstore.js | sed q)
```

## authentication
### [Special Characters in Usernames and Passwords](https://zencoder.support.brightcove.com/general-information/special-characters-usernames-and-passwords.html)

{% hint style='tip' %}
> references:
> - [percent-encoding](https://en.wikipedia.org/wiki/Percent-encoding)
{% endhint %}


|   CHARACTERS   | PERCENT-ENCODED |
|:--------------:|:---------------:|
|       `]`      |      `%5B`      |
|       `[`      |      `%5D`      |
|       `?`      |      `%3F`      |
|       `/`      |      `%2F`      |
|       `<`      |      `%3C`      |
|       `~`      |      `%7E`      |
|       `#`      |      `%23`      |
|       ```      |      `%6D`      |
|       `!`      |      `%21`      |
|       `@`      |      `%40`      |
|       `$`      |      `%24`      |
|       `%`      |      `%25`      |
|       `^`      |      `%5E`      |
|       `&`      |      `%26`      |
|       `*`      |      `%2A`      |
|       `(`      |      `%28`      |
|       `)`      |      `%29`      |
|       `+`      |      `%2B`      |
|       `=`      |      `%3D`      |
|       `}`      |      `%7D`      |
| <code>`</code> |      `%7C`      |
|       `:`      |      `%3A`      |
|       `"`      |      `%22`      |
|       `;`      |      `%3B`      |
|       `'`      |      `%27`      |
|       `,`      |      `%2C`      |
|       `>`      |      `%3E`      |
|       `{`      |      `%7B`      |
|     `space`    |      `%20`      |


## downlaods bookmark

> [!TIP]
> references:
> - [terrorgum.com](https://terrorgum.com/tfox/books/)
>   - [Bash Cookbook](https://terrorgum.com/tfox/books/bashcookbook.pdf)
>   - [Becoming the Hacker](https://terrorgum.com/tfox/books/becomingthehacker.pdf)
>   - [Deep Learning Revolution](https://terrorgum.com/tfox/books/deeplearningrevolution.pdf)
>   - [linux basics for hackers.pdf](https://terrorgum.com/tfox/books/linuxbasicsforhackers.pdf)
>   - [Linux In Nutshell.pdf](https://terrorgum.com/tfox/books/linuxinanutshell.pdf)
> - [pdfprof.com](https://www.pdfprof.com/)
>   - [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/abs-guide.pdf)
>   - [Linux Bash Shell Cheat Sheet](https://oit.ua.edu/wp-content/uploads/2020/12/Linux_bash_cheat_sheet-1.pdf)
> - [dye784/collection](https://github.com/dye784/collection)
