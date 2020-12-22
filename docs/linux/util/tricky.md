<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [save & restore screen](#save--restore-screen)
  - [`tput`](#tput)
  - [`echo`](#echo)
- [Terminfo escape sequences](#terminfo-escape-sequences)
- [others](#others)
  - [clear screen](#clear-screen)
  - [show TERM](#show-term)
  - [show terminal width](#show-terminal-width)
  - [customized colorful output](#customized-colorful-output)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> reference
> - [Terminal codes (ANSI/VT100) introduction](https://wiki.bash-hackers.org/scripting/terminalcodes)
{% endhint %}

## save & restore screen
### `tput`
- clear
  ```bash
  $ tput smcup
  ```
- restore
  ```bash
  $ tput rmcup
  ```

### `echo`
- save
  ```bash
  $ echo -e '\033[?47h'
  ```
- restore
  ```bash
  $ echo -e '\033[?47l'
  ```

## Terminfo escape sequences
```bash
$ infocmp
  ...
  colors#256, cols#80, it#8, lines#24, pairs#32767,
  bel=^G, blink=\E[5m, bold=\E[1m, cbt=\E[Z, civis=\E[?25l,
  clear=\E[H\E[2J, cnorm=\E[?12l\E[?25h, cr=^M,
  ...
```

## others
### clear screen
```bash
$ tput home
```

### show TERM
```bash
$ tput color
```

### show terminal width
```bash
$ tput cols
```

### [customized colorful output](https://unix.stackexchange.com/a/163781/29178)
```bash
$ export GREP_COLORS="sl=0;33;49:ms=1;34;49"
$ find /etc/ -type f | head | grep --color=always '^\|[^/]*$'
```
![customized color output](../../screenshot/colorful-tricky.png)
