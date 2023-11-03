<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [shortcuts](#shortcuts)
  - [combine multiple lines with or without space](#combine-multiple-lines-with-or-without-space)
  - [Capitalize words and regions easily](#capitalize-words-and-regions-easily)
  - [Switching case of characters](#switching-case-of-characters)
- [commands](#commands)
  - [search (in)sensitive](#search-insensitive)
  - [sort lines](#sort-lines)
  - [list all `filetype`](#list-all-filetype)
  - [newline `\r`](#newline-%5Cr)
  - [redirect cmd](#redirect-cmd)
  - [format json in vim](#format-json-in-vim)
  - [run command in multiple buffers](#run-command-in-multiple-buffers)
  - [show ascii under cursor](#show-ascii-under-cursor)
- [config](#config)
  - [disable vim beep](#disable-vim-beep)
- [run vim commands in terminal](#run-vim-commands-in-terminal)
  - [vim open file and go to specific function or linenumber](#vim-open-file-and-go-to-specific-function-or-linenumber)
  - [using vim as a man-page viewer under unix](#using-vim-as-a-man-page-viewer-under-unix)
- [vim regex](#vim-regex)
- [vim pattern](#vim-pattern)
  - [overview of multi items](#overview-of-multi-items)
  - [overview of ordinary atoms](#overview-of-ordinary-atoms)
  - [matches the N pattern](#matches-the-n-pattern)
- [characters](#characters)
- [micro](#micro)
  - [stop macro at the end of line](#stop-macro-at-the-end-of-line)
- [others](#others)
  - [startup-options](#startup-options)
  - [How to Open Files with Vim](#how-to-open-files-with-vim)
  - [comments](#comments)
  - [statueline](#statueline)
  - [ctags](#ctags)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP|label:references:]
> - [* Vim help files](https://vimhelp.org/#reference_toc)
> - [* Vim Cheat Sheet](https://vim.rtorr.com/)
> - [* vim : tip](https://vim.fandom.com/wiki/Category:VimTip)
> - [* vimtricks](https://vimtricks.com/)
> - [* Best Vim Tips](https://vim.fandom.com/wiki/Best_Vim_Tips)
> - [Vim run autocmd on all filetypes EXCEPT](https://stackoverflow.com/a/6496995/2940319)

## shortcuts
### combine multiple lines with or without space
- with space: `J`
- without space: `gJ`

![J-gJ](../screenshot/vim/J-gJ.gif)

### [Capitalize words and regions easily](https://vim.fandom.com/wiki/Capitalize_words_and_regions_easily)

|   shortcut   | comments                                              |
|:------------:|-------------------------------------------------------|
|     `gcw`    | capitalize word (from cursor position to end of word) |
|     `gcW`    | capitalize WORD (from cursor position to end of WORD) |
|    `gciw`    | capitalize inner word (from start to end)             |
|    `gciW`    | capitalize inner WORD (from start to end)             |
|    `gcis`    | capitalize inner sentence                             |
|     `gc$`    | capitalize until end of line (from cursor postition)  |
|    `gcgc`    | capitalize whole line (from start to end)             |
|     `gcc`    | capitalize whole line                                 |
| `{Visual}gc` | capitalize highlighted text                           |

```vim
" vimrc
if ( &tildeop )
  nmap gcw  guw~l
  nmap gcW  guW~l
  nmap gciw guiw~l
  nmap gciW guiW~l
  nmap gcis guis~l
  nmap gc$  gu$~l
  nmap gcgc guu~l
  nmap gcc  guu~l
  vmap gc   gu~l
else
  nmap gcw  guw~h
  nmap gcW  guW~h
  nmap gciw guiw~h
  nmap gciW guiW~h
  nmap gcis guis~h
  nmap gc$  gu$~h
  nmap gcgc guu~h
  nmap gcc  guu~h
  vmap gc   gu~h
endif
```

### [Switching case of characters](https://vim.fandom.com/wiki/Switching_case_of_characters)

> [!NOTE|label:references:]
> - [* Switching case of characters](https://vim.fandom.com/wiki/Switching_case_of_characters#Twiddle_case)
> - [* Changing case with regular expressions](https://vim.fandom.com/wiki/Changing_case_with_regular_expressions)

- lowercase
  ```vim
  gu

  " example
  Hello -> hello
  ```

- uppercase
  ```vim
  gU

  " example
  Hello -> HELLO
  ```

- reverse
  ```vim
  g~

  " example
  Hello -> hELLO
  ```

- more
  - `g~3w` : toggle case of the next three words
  - `g~$` : toggle case to the end of line
  - `g~iw` : toggle case of the current word (inner word – cursor anywhere in word)
  - `g~~` == `g~g~` : toggle case of the current line (same as V~ - cursor anywhere in the line)
  - `gUU` == `gUgU` : to uppercase of the current line (same as V~ - cursor anywhere in the line)
  - `guu` == `gugu` : to lowercase of the current line (same as V~ - cursor anywhere in the line)


## commands

### [search (in)sensitive](https://stackoverflow.com/a/2288438/2940319)

> [!NOTE|label:reference:]
> - [7. Ignoring case in a pattern](https://vimhelp.org/pattern.txt.html#%2F%5Cc)

|   CMD   | `ignorecase` | `smartcase` | MATCHES     |
|:-------:|:------------:|:-----------:|-------------|
|  `foo`  |     `off`    |      -      | foo         |
|  `foo`  |     `on`     |      -      | foo Foo FOO |
|  `foo`  |     `on`     |     `on`    | foo Foo FOO |
|  `Foo`  |     `on`     |     `on`    | Foo         |
|  `Foo`  |     `on`     |      -      | foo Foo FOO |
| `\cfoo` |       -      |      -      | foo Foo FOO |
| `foo\C` |       -      |      -      | foo         |

```vim
:set ignorecase
:set smartcase
/example      " Case insensitive
/Example      " Case sensitive
/example\C    " Case sensitive
/Example\c    " Case insensitive
```
![search-case-sensitive](../screenshot/vim/search-ignoreCase.gif)

#### search with `\V`

|     pattern    | result                                                                                                                                                                                                                                             |
|:--------------:|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|  `/a.k.a<CR>`  | b<span style="background-color:#333; color:#eee">a</span><span style="background-color: #777; color: #eee">ckward</span><br> <span style="background-color:#333; color:#eee">a</span><span style="background-color: #777; color: #eee">.k.a</span> |
| `/a\.k\.a<CR>` | backward<br> <span style="background-color:#333; color:#eee">a</span><span style="background-color: #777; color: #eee">.k.a</span>                                                                                                                 |
|  `/Va.k.a<CR>` | backward<br> <span style="background-color:#333; color:#eee">a</span><span style="background-color: #777; color: #eee">.k.a</span>                                                                                                                 |

### [sort lines](https://vim.fandom.com/wiki/Sort_lines)

> [!NOTE|label:references:]
> - [How to sort using visual blocks](https://vim.fandom.com/wiki/How_to_sort_using_visual_blocks)

- sort
  ```vim
  :{range}sort
  ```
  ![sort lines](../screenshot/vim/sort-lines.gif)

- sort and unique
  ```vim
  :{range}sort u
  ```
  ![sort lines](../screenshot/vim/sort-lines-unqiue.gif)

### [list all `filetype`](https://vi.stackexchange.com/a/14990/7389)
```
:echo getcompletion('', 'filetype')
```
- or
  ```vim
  :echo getcompletion('c', 'filetype')
  ```

- [or](https://vi.stackexchange.com/a/5782/7389) and use: `for f in GetFiletypes() | echo f | endfor`
  ```vim
  function! GetFiletypes()
    " Get a list of all the runtime directories by taking the value of that
    " option and splitting it using a comma as the separator.
    let rtps = split(&runtimepath, ",")
    " This will be the list of filetypes that the function returns
    let filetypes = []

    " Loop through each individual item in the list of runtime paths
    for rtp in rtps
      let syntax_dir = rtp . "/syntax"
      " Check to see if there is a syntax directory in this runtimepath.
      if (isdirectory(syntax_dir))
        " Loop through each vimscript file in the syntax directory
        for syntax_file in split(glob(syntax_dir . "/*.vim"), "\n")
          " Add this file to the filetypes list with its everything
          " except its name removed.
          call add(filetypes, fnamemodify(syntax_file, ":t:r"))
        endfor
      endif
    endfor

    " This removes any duplicates and returns the resulting list.
    " NOTE: This might not be the best way to do this, suggestions are welcome.
    return uniq(sort(filetypes))
  endfunction
  ```

### [newline `\r`](https://stackoverflow.com/a/71334/2940319)

{% hint style='tip' %}
- reference:
  - [Why is \r a newline for Vim?](https://stackoverflow.com/a/73438/2940319)
<p></p>
- [Vim documentation: pattern](http://vimdoc.sourceforge.net/htmldoc/pattern.html#/%5Cr) :
  - `\n` matches an end of line (newline)
  - `\r` matches a carriage return (more precisely it’s treated as the input `CR`))
{% endhint %}

### redirect cmd

> [!NOTE|label:references:]
> - [Vim save highlight info screen to file](https://stackoverflow.com/a/16049993/2940319)
> - [:redir](https://vimdoc.sourceforge.net/htmldoc/various.html#%3aredir)
> - [Capture ex command output](https://vim.fandom.com/wiki/Capture_ex_command_output)
> - [How to redirect ex command output into current buffer or file?](https://stackoverflow.com/a/2573758/2940319)
> - [* vim tips: Capture ex command output](https://vim.fandom.com/wiki/Capture_ex_command_output)

- redir to file
  ```vim
  :redir > ~/Desktop/debug.txt
  :silent highlight
  :redir END
  ```
  - [or](https://stackoverflow.com/a/28314082/2940319)
    ```vim
    :write | redir >> % | silent registers | redir END | edit
    ```

- to new window
  ```bash
  :redir @a | silent digraph | redir END | new +setl\ buftype=nofile\ bufhidden=wipe | put! a
  ```

- to [TabMessage](https://vim.fandom.com/wiki/Capture_ex_command_output)

  > [!NOTE|label:references:]
  > - [Using tab pages](https://vim.fandom.com/wiki/Using_tab_pages)

  ```vim
  function! TabMessage(cmd)
    redir => message
    silent execute a:cmd
    redir END
    if empty(message)
      echoerr "no output"
    else
      tabnew               " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
      setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
      silent put=message
    endif
  endfunction
  command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

  " usage:
  :TabMessage highlight
  ```

![redir to debug](../screenshot/vim/vim-redir.gif)

### format json in vim

> [!NOTE|label:references:]
> - [How to format a JSON file in vim](https://golang.cafe/blog/how-to-format-a-json-file-in-vim.html)
> - [How to format JSON file in Vim](https://vi.stackexchange.com/a/19950/7389)

```vim
:%!jq .

" or
:%!python -m json.tool
```

### [run command in multiple buffers](https://vim.fandom.com/wiki/Run_a_command_in_multiple_buffers)
{% hint style='tip' %}
**related commands**:
- `:argdo` : all files in argument list
- `:bufdo` : all buffers
- `:tabdo` : all tabs
- `:windo` : all windows

**reference**:
- [Search and replace in multiple buffers](https://vim.fandom.com/wiki/Search_and_replace_in_multiple_buffers)
{% endhint %}

```vim
:bufdo <command>
```

- replace
  ```vim
  # regular
  :%s/<str>/<str_new>/ge

  # for all buffers
  :bufdo %s/<str>/<str_new>/ge | update
  ```

- force the `bufdo` to continue without saving files via `:bufdo!`

### show ascii under cursor

> [!NOTE|label:references:]
> - [various.txt](https://vimhelp.org/various.txt.html)
> - [`:as` or `:ascii`](https://vimhelp.org/various.txt.html#%3Aascii)
> - [VimTricks : Inspect Character Under Cursor in Vim](https://vimtricks.com/p/inspect-character-under-cursor-in-vim/)

- keyboard
  - <kbd>g</kbd><kbd>a</kbd>
- commands
  ```vim
  :as
  " or
  :ascii
  ```

![ascii](../screenshot/vim/vim-tricky-ascii.gif)

## config
### disable vim beep
```vim
# ~/.vimrc
set noerrorbells novisualbell visualbell                            " ┐ Turn off
set t_vb=                                                           " ┘ error/normal beep/flash
```

## run vim commands in terminal

> [!NOTE|label:manual:]
> ```vim
> $ man vim
> ...
> OPTIONS
>   +{command}
>   -c {command}
>              {command} will be executed after the first file has been read.  {command} is interpreted
>              as an Ex command.  If the {command} contains spaces it must be enclosed in double quotes
>              (this depends on the shell that is used).  Example: Vim "+set si" main.c
>              Note: You can use up to 10 "+" or "-c" commands.
>
>   --cmd {command}
>              Like using "-c", but the command is executed just before processing any vimrc file.  You
>              can use up to 10 of these commands, independently from "-c" commands.
> ```

```vim
$ vim -es -c "set ff? | q"
  fileformat=unix
```

### [vim open file and go to specific function or linenumber](https://www.cyberciti.biz/faq/linux-unix-command-open-file-linenumber-function/)
```bash
$ vim +commandHere filename

# or
$ vim +linenumber filename
```

- [without fold](https://stackoverflow.com/a/10392451/2940319)
  ```bash
  $ vim +linenumber filename -c 'normal zR'
  ```

### [using vim as a man-page viewer under unix](https://vim.fandom.com/wiki/Using_vim_as_a_man-page_viewer_under_Unix)
```vim
export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
       vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
       -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
       -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""
```

- additional highlight
  ```vim
  " DrChip's additional man.vim stuff
  syn match manSectionHeading "^\s\+[0-9]\+\.[0-9.]*\s\+[A-Z].*$" contains=manSectionNumber
  syn match manSectionNumber "^\s\+[0-9]\+\.[0-9]*" contained
  syn region manDQString start='[^a-zA-Z"]"[^", )]'lc=1 end='"' contains=manSQString
  syn region manSQString start="[ \t]'[^', )]"lc=1 end="'"
  syn region manSQString start="^'[^', )]"lc=1 end="'"
  syn region manBQString start="[^a-zA-Z`]`[^`, )]"lc=1 end="[`']"
  syn region manBQSQString start="``[^),']" end="''"
  syn match manBulletZone transparent "^\s\+o\s" contains=manBullet
  syn case match
  syn keyword manBullet contained o
  syn match manBullet contained "\[+*]"
  syn match manSubSectionStart "^\*" skipwhite nextgroup=manSubSection
  syn match manSubSection ".*$" contained

  hi link manSectionNumber Number
  hi link manDQString String
  hi link manSQString String
  hi link manBQString String
  hi link manBQSQString String
  hi link manBullet Special
  hi manSubSectionStart term=NONE cterm=NONE gui=NONE ctermfg=black ctermbg=black guifg=navyblue guibg=navyblue
  hi manSubSection term=underline cterm=underline gui=underline ctermfg=green guifg=green
  ```


## [vim regex](http://vimregex.com/)

## [vim pattern](https://vimhelp.org/pattern.txt.html)
> reference:
> - [magic](https://vimhelp.org/pattern.txt.html#%2Fmagic)

### overview of multi items

| pattern   | magic       | nomagic     | matches of the preceding atom                        |
| :-------: | :---------: | :---------: | -----------------------------------------------------|
| `/star`   | `*`         | `\*`        | 0 or more  &emsp; (as many as possible)              |
| `/\+`     | `\+`        | `\+`        | 1 or more  &emsp; (as many as possible)              |
| `/\=`     | `\=`        | `\=`        | 0 or 1     &emsp; (as many as possible)              |
| `/\?`     | `\?`        | `\?`        | 0 or 1     &emsp; (as many as possible)              |
| `/\{`     | `\{n,m}`    | `\{n,m}`    | n to m     &emsp; (as many as possible)              |
|           | `\{n}`      | `\{n}`      | n          &emsp; exactly                            |
|           | `\{n,}`     | `\{n,}`     | at least n &emsp; (as many as possible)              |
|           | `\{,m}`     | `\{,m}`     | 0 to m     &emsp; (as many as possible)              |
|           | `\{}`       | `\{}`       | 0 or more  &emsp; (as many as possible. same as `*`) |
| `/\{-`    | `\{-n,m}`   | `\{-n,m}`   | n to m     &emsp; (as few as possible)               |
|           | `\{-n}`     | `\{-n}`     | n    &emsp;&emsp; exactly                            |
|           | `\{-n,}`    | `\{-n,}`    | at least n &emsp; (as few as possible)               |
|           | `\{-,m}`    | `\{-,m}`    | 0 to m     &emsp; (as few as possible)               |
|           | `\{-}`      | `\{-}`      | 0 or more  &emsp; (as few as possible)               |


### overview of ordinary atoms

| pattern |  magic  | nomagic | matches                                         |
|:-------:|:-------:|:-------:|-------------------------------------------------|
|   `/^`  |   `^`   |   `^`   | start-of-line (at start of pattern) /zero-width |
|  `/\^`  |   `\^`  |   `\^`  | literal '^'                                     |
|  `/\_^` |  `\_^`  |  `\_^`  | start-of-line (used anywhere) /zero-width       |
|  ` /$`  |   `$`   |   `$`   | end-of-line (at end of pattern) /zero-width     |
|  `/\$`  |   `\$`  |   `\$`  | literal '$'                                     |
|  `/\_$` |  `\_$`  |  `\_$`  | end-of-line (used anywhere) /zero-width         |
|   `/.`  |   `.`   |   `\.`  | any single character (not an end-of-line)       |
|  `/\_.` |  `\_.`  |  `\_.`  | any single character or end-of-line             |
|  `/\<`  |   `\<`  |  `\< `  | beginning of a word /zero-width                 |
|  `/\>`  |   `\>`  |  `\> `  | end of a word /zero-width                       |
|  `/\zs` |  `\zs`  |  `\zs`  | anything, sets start of match                   |
|  `/\ze` |  `\ze`  |  `\ze`  | anything, sets end of match                     |
|  `/\%^` |  `\%^`  |  `\%^`  | beginning of file /zero-width<br> E71           |
|  `/\%$` |  `\%$`  |  `\%$`  | end of file /zero-width                         |
|  `/\%V` |  `\%V`  |  `\%V`  | inside Visual area /zero-width                  |
|  `/\%#` |  `\%#`  |  `\%#`  | cursor position /zero-width                     |
| `/\%'m` |  `\%'m` |  `\%'m` | mark m position /zero-width                     |
|  `/\%l` | `\%23l` | `\%23l` | in line 23 /zero-width                          |
|  `/\%c` | `\%23c` | `\%23c` | in column 23 /zero-width                        |
|  `/\%v` | `\%23v` | `\%23v` | in virtual column 23 /zero-width                |


### [matches the N pattern](https://stackoverflow.com/a/5424784/2940319)
- every 3rd
  ```vim
  \(.\{-}\zsfoo\)\{3}
  ```
  ![regex every third](../screenshot/vim/regex/vim-regex-every3rd.gif)

- the 3rd
  ```vim
  ^\(.\{-}\zsPATTERN\)\{3}
  ```
  ![regex every third](../screenshot/vim/regex/vim-regex-the3rd.gif)

{% hint style='tip' %}
[`\v`: the following chars in the pattern are "very magic"](https://vimhelp.org/pattern.txt.html#%2F%5Cv):
- `^\(.\{-}\zsPATTERN\)\{N}` == > `\v^(.{-}\zsPATTERN){N}`
- `^\(.\{-}\zs=\)\{N}`       == > `\v^(.{-}\zs\=){N}`

NOTICE: after using `\v` the `=` should using `\=` instead
{% endhint %}

## characters

> [!NOTE|label:references:]
> - [* digraph.txt:digraph-table](https://vimhelp.org/digraph.txt.html#digraph-table)
> - [* :help i_CTRL-V](https://vimhelp.org/insert.txt.html#i_CTRL-V)
> - [* :help i_CTRL-K](https://vimhelp.org/insert.txt.html#i_CTRL-K)
> - [Vim Digraphs and Ligatures](https://alpha2phi.medium.com/vim-digraphs-and-ligatures-7dec3cb0a623)
> - [Vi(m) tip #2: Entering greek/math symbols using vim digraphs](https://www.alecjacobson.com/weblog/?p=443)
> - [Is there a way to search inside the digraphs in Vim](https://stackoverflow.com/a/26234078/2940319)
> - [youtube : Input Special / Foreign / Non-Keyboard Characters - Vim Tips (2)](https://www.youtube.com/watch?v=Za5GRXP1ycM)
> - [vimticks : Insert special • characters](https://vimtricks.com/p/insert-special-characters/)

- [:help i_CTRL-V_digit](https://vimhelp.org/insert.txt.html#i_CTRL-V_digit)

| first      | char        | mode | max nr of chars |   max value  |
|------------|-------------|:----:|:---------------:|:------------:|
| (none)     | decimal     |   3  |       255       |       -      |
| `o` or `O` | octal       |   3  |       377       |     (255)    |
| `x` or `X` | hexadecimal |   2  |        ff       |     (255)    |
| `u`        | hexadecimal |   4  |       ffff      |    (65535)   |
| `U`        | hexadecimal |   8  |     7fffffff    | (2147483647) |


- show all digraphs

  > [!NOTE|label:references:]
  > - [* iMarslo : redirect cmd](#redirect-cmd)

  ```vim
  :redir @a | silent digraph | redir END | new +setl\ buftype=nofile\ bufhidden=wipe | put! a

  : or
  :redir @a | silent digraph | redir END | new +setl\ buftype=nofile\ bufhidden=wipe | put! a | on
  ```

#### insert unicode
- via hex

  > [!NOTE|label:references:]
  > - [* iMarlso : show ascii under cursor](#show-ascii-under-cursor)
  > - [Unicode Chart](https://www.ssec.wisc.edu/~tomw/java/unicode.html)
  > - [List of Unicode characters](https://en.wikipedia.org/wiki/List_of_Unicode_characters)
  > - [List of Unicode Symbols: Complete Unicode Character Table on One Page](https://symbl.cc/en/unicode/table/)

  - i.e.:
    - `2b38` : [⬸  : Leftwards Arrow with Dotted Stem](https://symbl.cc/en/2B38/)
    - `2911` : [⤑ : Rightwards Arrow with Dotted Stem](https://symbl.cc/en/2911/)

    - steps:
      - <kbd>esc</kbd> : return to normal mode ( optional )
      - <kbd>i</kbd> || <kbd>o</kbd> || <kbd>a</kbd> || ... : insert mode
      - <kbd>ctrl</kbd> + <kbd>v</kbd>
      - insert `u2b38` or `u2911` : 4 digits using `u`

    ![i_ctrl-v u](../screenshot/vim/digraphs-i-cv-u-1.gif)

  - emoji
    - `1F92A` : [🤪 : Grinning Face With One Large And One Small Eye Emoji](https://symbl.cc/en/1F92A/)
    - `1F926` : [🤦 : Face Palm Emoji](https://symbl.cc/en/1F926/)

    - steps:
      - <kbd>esc</kbd> : return to normal mode ( optional )
      - <kbd>i</kbd> || <kbd>o</kbd> || <kbd>a</kbd> || ... : insert mode
      - <kbd>ctrl</kbd> + <kbd>v</kbd>
      - insert `U2b38` or `U2911` : >4 digits using `U`

    ![i_ctrl-v U](../screenshot/vim/digraphs-i-cv-U-2.gif)

- via digraph char

  > [!NOTE|label:refrences:]
  > - [:help digraph-table](https://vimhelp.org/digraph.txt.html#digraph-table)
  > - [:help i_ctrl-k](https://vimhelp.org/insert.txt.html#i_CTRL-K)

  - i.e.:
    - `3c ㈢ 12834`
    - `4c ㈣ 12835`
    - `5c ㈤ 12836`

    - steps:
      - <kbd>esc</kbd> : return to normal mode ( optional )
      - <kbd>i</kbd> || <kbd>o</kbd> || <kbd>a</kbd> || ... : insert mode
      - <kbd>ctrl</kbd> + <kbd>k</kbd>
      - insert `3c` or `4c` or `5c`

    ![i_ctrl-k](../screenshot/vim/digraphs -i_ck-1.gif)

## micro

> [!NOTE|label:references:]
> - [How do I stop a recursive macro at the end of the line?](https://vi.stackexchange.com/a/6427/7389)

### stop macro at the end of line
```vim
:let a=line('.')
<....>                  " do micro
:if line('.')==a | exec 'normal @q' | endif
"                                |
"                                v
"                           micro name
```

![stop recursive macro at the end of line](../screenshot/vim/vim-micro-endofline.gif)

## others

> [!NOTE|label:references:]
> - [Insert current date or time](https://vim.fandom.com/wiki/Insert_current_date_or_time)
> - [Insert current directory name](https://vim.fandom.com/wiki/Insert_current_directory_name)
> - [Insert current filename](https://vim.fandom.com/wiki/Insert_current_filename)
> - [Insert line numbers](https://vim.fandom.com/wiki/Insert_line_numbers)
> - [To switch back to normal mode automatically after inaction](https://vim.fandom.com/wiki/To_switch_back_to_normal_mode_automatically_after_inaction)
> - [Using Git from Vim](https://vim.fandom.com/wiki/Using_Git_from_Vim)
> - [Word count](https://vim.fandom.com/wiki/Word_count)

### [startup-options](https://vimhelp.org/starting.txt.html)

> [!NOTE|label:references:]
> - [`:help edit-binary`](https://vimhelp.org/editing.txt.html#edit-binary)

- binary mode by [`-b`](https://vimhelp.org/starting.txt.html#-b)
  - `binary` on
  - `textwidth` 0
  - `modeline` off
  - `expandtab` off

### [How to Open Files with Vim](https://tuckerchapman.com/2021/02/16/vim-open-files/)

### comments

> [!NOTE|label:references:]
> - [Command line tricks](https://vim.fandom.com/wiki/Command_line_tricks)
> - [Comment Lines according to a given filetype](https://vim.fandom.com/wiki/Comment_Lines_according_to_a_given_filetype)
> - [Comment lines in different filetypes](https://vim.fandom.com/wiki/Comment_lines_in_different_filetypes)
> - [Comment your code blocks automatically](https://vim.fandom.com/wiki/Comment_your_code_blocks_automatically)
> - [Insert comment boxes in your code](https://vim.fandom.com/wiki/Insert_comment_boxes_in_your_code)

### statueline

> [!NOTE|label:references:]
> - [Insert current date or time](https://vim.fandom.com/wiki/Insert_current_date_or_time)
> - [Build your own Vim statusline](https://shapeshed.com/vim-statuslines/)

- sample
  ```vim
  if has('statusline')
    set laststatus=2
    set statusline=%#User2#%m%r%*\ %F\ %y,%{&fileformat}
    " set statusline+=\ %{FugitiveStatusline()}                     " set statusline+=\ %{fugitive#statusline()}
    set statusline+=%=\ %-{strftime(\"%H:%M\ %d/%m/%Y\")}\ %b[A],0x%B\ %c%V,%l/%L\ %1*--%n%%--%*\ %p%%\ |
  endif
  ```

- [vim-airline](https://github.com/vim-airline/vim-airline)

### ctags

> [!NOTE|label:references:]
> - [* preservim/tagbar](https://github.com/preservim/tagbar/wiki#ansible)
> - [kornicameister/dotfiles/ctags.d](https://github.com/kornicameister/dotfiles/tree/master/ctags.d)
> - [mfwarren/.ctags for groovy](https://gist.github.com/mfwarren/793482)
> - [ik5/dotfiles/.ctags](https://github.com/ik5/dotfiles/blob/master/ctags)
> - [aiya000/dotfiles/.ctags.d](https://github.com/aiya000/dotfiles/tree/main/.ctags.d)
> - groovy
>   - [groovytags](https://bitbucket.org/sw-samuraj/groovytags/src/develop/)
>   - [sw-samuraj/vim-gradle](https://bitbucket.org/sw-samuraj/vim-gradle/src/develop/)
>   - [vim-scripts/vim-gradle](https://github.com/vim-scripts/vim-gradle)
