<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [combine multiple lines with or without space](#combine-multiple-lines-with-or-without-space)
- [list all `filetype`](#list-all-filetype)
- [run vim commands in terminal](#run-vim-commands-in-terminal)
- [Using vim as a man-page viewer under Unix](#using-vim-as-a-man-page-viewer-under-unix)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



### combine multiple lines with or without space
- with space: `J`
- without space: `gJ`

![J-gJ](../../screenshot/vim/J-gJ.gif)

### [list all `filetype`](https://vi.stackexchange.com/a/14990/7389)
```
:echo getcompletion('', 'filetype')
```
- or
  ```bash
  :echo getcompletion('c', 'filetype')
  ```
- [or](https://vi.stackexchange.com/a/5782/7389) and use: `for f in GetFiletypes() | echo f | endfor`
  ```bash
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

### run vim commands in terminal
{% hint style='tip' %}
```bash
$ man vim
...
OPTIONS
  +{command}
  -c {command}
             {command} will be executed after the first file has been read.  {command} is interpreted
             as an Ex command.  If the {command} contains spaces it must be enclosed in double quotes
             (this depends on the shell that is used).  Example: Vim "+set si" main.c
             Note: You can use up to 10 "+" or "-c" commands.

  --cmd {command}
             Like using "-c", but the command is executed just before processing any vimrc file.  You
             can use up to 10 of these commands, independently from "-c" commands.
```

{% endhint %}

```bash
$ vim -es -c "set ff? | q"
  fileformat=unix
```

### [Using vim as a man-page viewer under Unix](https://vim.fandom.com/wiki/Using_vim_as_a_man-page_viewer_under_Unix)
```bash
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
