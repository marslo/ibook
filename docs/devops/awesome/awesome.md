<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [awesome shells](#awesome-shells)
- [`ncdu` : NCurses Disk Usage](#ncdu--ncurses-disk-usage)
- [ansi colors](#ansi-colors)
  - [`c`: bash-colors](#c-bash-colors)
  - [`ansi`](#ansi)
  - [`diff-so-fancy`](#diff-so-fancy)
- [utility](#utility)
  - [`elinks`](#elinks)
  - [`duf`](#duf)
  - [`enhancd`](#enhancd)
  - [watchman](#watchman)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [Best UNIX shell-based tools](https://gist.github.com/mbbx6spp/1429161)
> - [* alebcay/awesome-shell](https://github.com/alebcay/awesome-shell/tree/master) | [* zh-cn](https://github.com/alebcay/awesome-shell/blob/master/README_ZH-CN.md)
>   - [nosarthur/awesome-shell](https://github.com/nosarthur/awesome-shell)
> - [* rockerBOO/awesome-neovim](https://github.com/rockerBOO/awesome-neovim)
> - [sindresorhus/awesome](https://github.com/sindresorhus/awesome)
> - [Sainnhe's Dashboard: os in web browser](https://dashboard.sainnhe.dev/)
>   - [osx](https://macos.sainnhe.dev/) | [windows](https://windows.sainnhe.dev/)
> - others
>   - [bayandin/awesome-awesomeness](https://github.com/bayandin/awesome-awesomeness)
>   - [emijrp/awesome-awesome](https://github.com/emijrp/awesome-awesome)
>   - [kahun/awesome-sysadmin](https://github.com/kahun/awesome-sysadmin)
>   - [stup - Daily notes in the terminal](https://iridakos.com/programming/2020/04/20/stup-cli-notes)
>   - [Awesome Command-Line Tools](https://www.vimfromscratch.com/articles/awesome-command-line-tools)
> - [My Minimalist Over-powered Linux Setup Guide](https://medium.com/@jonyeezs/my-minimal-over-powered-linux-setup-guide-710931efb75b)
> - [* devynspencer/cute_commands.sh](https://gist.github.com/devynspencer/cfdce35b3230e72214ef)
> - [Use Bash Strict Mode (Unless You Love Debugging)](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
> - [Learn Enough Command Line to Be Dangerous](https://www.learnenough.com/command-line-tutorial/basics)
> - [jlevy/the-art-of-command-line](https://github.com/jlevy/the-art-of-command-line)
> - [pv - Pipe Viewer](https://www.ivarch.com/programs/pv.shtml)
{% endhint %}

# awesome shells

- [fzf](./fzf.md)
- [fd](./fd.md)
- [bat](./bat.md)
- [rg/ag](./rg.ag.md)
- [cheatsheet](./cheatsheet.md)
  - [tldr](./cheatsheet.md#tldr)
  - [cht.sh](./cheatsheet.md#chtsh)
  - [cheat](./cheatsheet.md#cheat)

# [`ncdu` : NCurses Disk Usage](https://dev.yorhel.nl/ncdu)

> [!TIP]
> - [code.blicky.net/yorhel/ncdu](https://code.blicky.net/yorhel/ncdu/)
> - [Ncdu 2: Less hungry and more Ziggy](https://dev.yorhel.nl/doc/ncdu2)

```bash
# deps install
$ sudo snap install zig --class --beta
$ sudo apt install libncurses-dev

$ make
$ sudo make install PREFIX=/usr/local

# verify
$ ncdu --version
ncdu 2.3
```

![ncdu](../screenshot/linux/ncdu.png)

> [!NOTE|label:Alternatives:]
> - CLI
>   - [`dust`: bootandy/dust](https://github.com/bootandy/dust)
>   - [`dutree`: nachoparker/dutree](https://github.com/nachoparker/dutree)
>   - [`dua`: Byron/dua-cli](https://github.com/Byron/dua-cli)
>   - [`pdu`: KSXGitHub/parallel-disk-usage](https://github.com/KSXGitHub/parallel-disk-usage)
> - TUI:
>   - [`ncdu`](https://dev.yorhel.nl/ncdu)
>   - [`ds`: scullionw/dirstat-rs](https://github.com/scullionw/dirstat-rs)
>   - [`gdu`: dundee/gdu](https://github.com/dundee/gdu)
>   - [`godu`: viktomas/godu](https://github.com/viktomas/godu)
>   - [`Vifm`](https://vifm.info/manual.shtml)


# ansi colors

> [!NOTE|label:references:]
> - **see more toosl for ansicolor in [* iMarslo: colors](../../cheatsheet/colors.md)**

## [`c`: bash-colors](https://github.com/ppo/bash-colors)

> [!TIP]
> - flags
>   ```css
>   ┌───────┬────────────────┬─────────────────┐   ┌───────┬─────────────────┬───────┐
>   │ Fg/Bg │ Color          │ Octal           │   │ Code  │ Style           │ Octal │
>   ├───────┼────────────────┼─────────────────┤   ├───────┼─────────────────┼───────┤
>   │  K/k  │ Black          │ \e[ + 3/4  + 0m │   │  s/S  │ Bold (strong)   │ \e[1m │
>   │  R/r  │ Red            │ \e[ + 3/4  + 1m │   │  d/D  │ Dim             │ \e[2m │
>   │  G/g  │ Green          │ \e[ + 3/4  + 2m │   │  i/I  │ Italic          │ \e[3m │
>   │  Y/y  │ Yellow         │ \e[ + 3/4  + 3m │   │  u/U  │ Underline       │ \e[4m │
>   │  B/b  │ Blue           │ \e[ + 3/4  + 4m │   │  f/F  │ Blink (flash)   │ \e[5m │
>   │  M/m  │ Magenta        │ \e[ + 3/4  + 5m │   │  n/N  │ Negative        │ \e[7m │
>   │  C/c  │ Cyan           │ \e[ + 3/4  + 6m │   │  h/H  │ Hidden          │ \e[8m │
>   │  W/w  │ White          │ \e[ + 3/4  + 7m │   │  t/T  │ Strikethrough   │ \e[9m │
>   ├───────┴────────────────┴─────────────────┤   ├───────┼─────────────────┼───────┤
>   │  High intensity        │ \e[ + 9/10 + *m │   │   0   │ Reset           │ \e[0m │
>   └────────────────────────┴─────────────────┘   └───────┴─────────────────┴───────┘
>                                                   Uppercase = Reset a style: \e[2*m
>   ```

![bash color](../screenshot/linux/bash-color.gif)

## [`ansi`](https://github.com/fidian/ansi)

> [!NOTE|label:references:]
> - [example](https://github.com/fidian/ansi/tree/master/examples)

- install
  ```bash
  $ curl -sL git.io/ansi -o "${iRCHOME}"/utils/ansi && chmod +x $_
  $ ln -sf $(realpath "${iRCHOME}"/utils/ansi) $(realpath "${iRCHOME}"/bin)/ansi
  ```

  ![ansi color tables](../screenshot/osx/ansi-color-codes.png)

## [`diff-so-fancy`](https://github.com/so-fancy/diff-so-fancy)

> [!NOTE|label:references:]
> - [Aos Dabbagh : diff-so-fancy](https://launchpad.net/~aos1/+archive/ubuntu/diff-so-fancy)

```bash
# ubuntu
$ sudo add-apt-repository ppa:aos1/diff-so-fancy
$ sudo apt update

$ sudo apt install diff-so-fancy

# verify
$ diff-so-fancy --version
Diff-so-fancy: https://github.com/so-fancy/diff-so-fancy
Version      : 1.4.2
```

# utility
## `elinks`

> [!NOTE|label:references:]
> - [ELinks](https://en.wikipedia.org/wiki/ELinks)
> - MacOS:
>   ```bash
>   $ brew install felinks
>   $ which -a elinks
>   /usr/local/bin/elinks
>   ```
> - [* iMarslo : open html in terminal](../vim/tricky.html#open-html-in-terminal)
> - [ELinks - Full-Featured Text WWW Browser](http://elinks.or.cz/)
>   - [elinks.conf](http://elinks.or.cz/documentation/manpages/elinks.conf.5.html)
>   - [elinkskeys](http://elinks.or.cz/documentation/manpages/elinkskeys.5.html)

```bash
$ elinks https://google.com
```

![elinks google.com](../screenshot/linux/elinks.png)

- configure

  > [!NOTE|label:references:]
  > - [Elinks: SSL Error](https://stackoverflow.com/a/40114376/2940319)

  ```bash
  $ cat ~/.elinks/elinks.conf
  set connection.ssl.cert_verify = 0
  ```

## [`duf`](https://unix.stackexchange.com/a/612111/29178)

![duf](../screenshot/linux/duf.png)

## [`enhancd`](https://github.com/babarot/enhancd)

> [!NOTE|label:references:]
> - [mattn/ltsv.vim](https://gist.github.com/mattn/4737234)
> - [* lfromanini/smartcd](https://github.com/lfromanini/smartcd)
> - [* iMarslo : autocmd BufWritePre except](../vim/tricky.html#autocmd-bufwritepre-except)
>   ```vim
>   " original
>   autocmd BufWritePre * :retab!                                   " automatic retab
>
>   " for ltsv
>   if has( "autocmd" )
>     autocmd BufRead,BufNewFile  *.ltsv                 set filetype=ltsv syntax=groovy noexpandtab
>     autocmd BufWritePre         *\(.ltsv\|.diffs\)\@<! :retab!    " automatic retab
>   endif
>   ```

- install
  ```bash
  $ git clone https://github.com/babarot/enhancd && source enhancd/init.sh

  # or
  $ curl -L git.io/enhancd | sh
  ```

- re-mapping cmd
  ```bash
  diff --git a/init.sh b/init.sh
  index 55a9c95..bc3ae89 100644
  --- a/init.sh
  +++ b/init.sh
  @@ -52,8 +52,8 @@ if [[ ! -f ${ENHANCD_DIR}/enhancd.log ]]; then
     touch "${ENHANCD_DIR}/enhancd.log"
   fi

  -# alias to cd
  -eval "alias ${ENHANCD_COMMAND:=cd}=__enhancd::cd"
  +# alias to ce
  +eval "alias ${ENHANCD_COMMAND:=ce}=__enhancd::cd"

   # Set the filter if empty
   if [[ -z ${ENHANCD_FILTER} ]]; then
  ```

- usage
  ```bash
  $ brew install fzy
  # debine
  $ sudo apt install fzy

  $ export ENHANCD_FILTER="fzf --height 35%:fzy"
  $ source /path/to/enhancd/init.sh
  $ ce .
  ```

  ![enhancd](../screenshot/linux/ecd-ec.gif)

## [watchman](https://facebook.github.io/watchman/)
