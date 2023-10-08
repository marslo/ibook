<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [autocmd](#autocmd)
  - [autocmd BufWritePre except](#autocmd-bufwritepre-except)
  - [stop gitblame in diff mode](#stop-gitblame-in-diff-mode)
  - [automatic cleanup tailing space when save](#automatic-cleanup-tailing-space-when-save)
  - [automatic save](#automatic-save)
  - [filetype in vim language](#filetype-in-vim-language)
- [system](#system)
  - [show path of current file](#show-path-of-current-file)
  - [Putting the current file on the Windows clipboard](#putting-the-current-file-on-the-windows-clipboard)
  - [twiddle case](#twiddle-case)
- [functions](#functions)
  - [open html in terminal](#open-html-in-terminal)
  - [OpenInFreshWindowOrNewTab](#openinfreshwindowornewtab)
  - [GetFiletypes](#getfiletypes)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## autocmd

> [!TIP|label:references:]
> - [Triggering a function with BufEnter](https://vi.stackexchange.com/a/11363/7389)
> ```
>  autocmd BufEnter *.p[lm]  nmap <buffer> ;t :call RunPerlTests()<CR>
>  "       |        |        |     |       |  |
>  "       |        |        |     |       |  +-- `{rhs}` of the mapping
>  "       |        |        |     |       +-- `{lhs}` of the mapping
>  "       |        |        |     +-- argument to pass to `:nmap`; limits the scope of the mapping to the current buffer
>  "       |        |        +-- mapping command to execute
>  "       |        +-- pattern to limit the scope of the autocmd to certain filetypes
>  "       +-- event of the autocmd
> ```
> - [Vim’s event model](https://web.archive.org/web/20220121051339/https://developer.ibm.com/tutorials/l-vim-script-5/)
> - [Listing 1. Event sequence in a simple Vim editing session](https://vi.stackexchange.com/a/4495/7389)
>   - `BufWinEnter` : create a default window
>   - `BufEnter`    : create a default buffer
>   - `VimEnter`    : start the Vim session):edit demo.txt
>   - `BufNew`      : create a new buffer to contain demo.txt
>   - `BufAdd`      : add that new buffer to the session’s buffer list
>   - `BufLeave`    : exit the default buffer
>   - `BufWinLeave` : exit the default window
>   - `BufUnload`   : remove the default buffer from the buffer list
>   - `BufDelete`   : deallocate the default buffer
>   - `BufReadCmd`  : read the contexts of demo.txt into the new buffer
>   - `BufEnter`    : activate the new buffer
>   - `BufWinEnter` : activate the new buffer's window
>   - `InsertEnter` : swap into Insert mode

### [autocmd BufWritePre except](https://stackoverflow.com/q/6496778/2940319)

- [funciton](https://stackoverflow.com/a/6496995/2940319)
  ```vim
  fun! StripTrailingWhitespace()
    " don't strip on these filetypes
    if &ft =~ 'ruby\|javascript\|perl'
      return
    endif
    %s/\s\+$//e
  endfun
  autocmd BufWritePre * call StripTrailingWhitespace()

  " or
  fun! StripTrailingWhitespace()
    " only strip if the b:noStripeWhitespace variable isn't set
    if exists('b:noStripWhitespace')
      return
    endif
    %s/\s\+$//e
  endfun

  autocmd BufWritePre * call StripTrailingWhitespace()
  autocmd FileType ruby,javascript,perl let b:noStripWhitespace=1
  ```
  - redraw
    ```vim
    fun! ReplaceTabToSpace()
      # don't strip on these filetypes
      if &ft =~ 'ruby\|javascript\|perl\|ltsv'
        return
      endif
      %s/\s\+$//e
    endfun
    autocmd BufWritePre * call ReplaceTabToSpace()
    ```

- [blacklist](https://stackoverflow.com/a/10410590/2940319)
  ```vim
  let blacklist = ['rb', 'js', 'pl']
  autocmd BufWritePre  *  if index(blacklist, &ft) < 0 | do somthing you like | endif
  ```

- [`@<!`](https://stackoverflow.com/a/67463224/2940319)
  ```vim
  autocmd BufWritePre  *\(.out\|.diffs\)\@<!  <your_command>

  " i.e.:
  autocmd Syntax       *\(^rst\)\@<!          :redraw!
  ```
  - redraw
    ```vim
    autocmd BufWritePre *\(.ltsv\|.diffs\)\@<! :retab!    " automatic retab
    ```

### stop gitblame in diff mode

> [!NOTE|label:references:]
> - [How to disable plugin for vimdiff?](https://www.reddit.com/r/vim/comments/4bh0mo/comment/d19hv5u/?utm_source=share&utm_medium=web2x&context=3)
> - [Make vim switch to other window after opening a diff](https://vi.stackexchange.com/a/8606/7389)

```vim
autocmd BufEnter              *                      if &diff         | let g:blamer_enabled=0 | endif    " ╮ disable diff mode
autocmd BufEnter              *                      if ! empty(&key) | let g:blamer_enabled=0 | endif    " ╯ and encrypt mode
```

### automatic cleanup tailing space when save

```bash
autocmd BufWritePre              *                      :%s/\s\+$//e | %s/\r$//e   " automatic remove trailing space

# others
autocmd FileType                 sh,bash,shell  slient  :redraw
autocmd BufWritePre,BufWritePost *.sh           slient  :redraw                    " for shellcheck lint
```

### automatic save

> [!NOTE|label:references:]
> - [Listing 3. Autocommand to autosave when leaving an editor window](https://web.archive.org/web/20220121051339/https://developer.ibm.com/tutorials/l-vim-script-5/)

```vim
autocmd  FocusLost  *.txt   :    if &modified && g:autosave_on_focus_change
autocmd  FocusLost  *.txt   :    write
autocmd  FocusLost  *.txt   :    echo "Autosaved file while you were absent"
autocmd  FocusLost  *.txt   :    endif
```

- clean way to handle multiple autocommands
  ```vim
  function! Highlight_cursor ()
      set cursorline
      redraw
      sleep 1
      set nocursorline
  endfunction
  function! Autosave ()
     if &modified && g:autosave_on_focus_change
         write
         echo "Autosaved file while you were absent"
     endif
  endfunction

  autocmd  FocusGained  *.txt   :call Highlight_cursor()
  autocmd  FocusLost    *.txt   :call Autosave()
  ```

### [filetype in vim language](https://stackoverflow.com/a/63255521/2940319)
```vim
if index(['vim', 'c', 'cpp'], &filetype) != -1
  echom "hello!"
endif
```

- [or](https://stackoverflow.com/a/29407473/2940319)
  ```vim
  let fts = ['c', 'cpp']
  if index(fts, &filetype) == -1
    " do stuff
  endif
  ```

## system
### show path of current file

> [!TIP]
> references:
> - [How can I see the full path of the current file?](https://vi.stackexchange.com/a/1885/7389)
> - [vimtip : Get the name of the current file](https://vim.fandom.com/wiki/Get_the_name_of_the_current_file)
> - [How to find out which file is currently opened in vim?](https://unix.stackexchange.com/a/104902/29178)

| COMMANDS                  | RESULT                                   | EXPLAIN                                                            |
|---------------------------|------------------------------------------|--------------------------------------------------------------------|
| `:echo @%`                | `tricky.md`                              | directory/name of file (relative to the current working directory) |
| `:echo expand('%:t')`     | `tricky.md`                              | name of file ('tail')                                              |
| `:echo expand('%:p')`     | `/Users/marslo/ibook/docs/vim/tricky.md` | full path                                                          |
| `:echo expand('%:p:h')`   | `/Users/marslo/ibook/docs/vim`           | directory containing file ('head')                                 |
| `:echo expand('%:p:h:t')` | `vim`                                    | direct folder name                                                 |
| `:echo expand('%:r')`     | `tricky`                                 | name of file less one extension ('root')                           |
| `:echo expand('%:e')`     | `md`                                     | name of file's extension ('extension')                             |

- others
  - <kbd>ctrl</kbd> + <kbd>g</kbd>
  - `:f`


### [Putting the current file on the Windows clipboard](https://vim.fandom.com/wiki/Putting_the_current_file_on_the_Windows_clipboard)

> [!NOTE|label:references:]
> - [Using the Windows clipboard in Cygwin Vim](https://vim.fandom.com/wiki/Using_the_Windows_clipboard_in_Cygwin_Vim)

```vim
command! Copyfile let @*=substitute(expand("%:p"), '/', '\', 'g')
:map <Leader>cf :Copyfile<CR>

" or
nn <silent><C-G> :let @*=expand('%:p')<CR>:f<CR>
```

### [twiddle case](https://vim.fandom.com/wiki/Switching_case_of_characters#Twiddle_case)

> [!TIP|label:references:]
> - [change.txt](https://vimhelp.org/change.txt.html)
>   - [`:help s/\u` : next character made uppercase](https://vimhelp.org/change.txt.html#s%2F%5Cu)
>   - examples:
>     - `:s/a\|b/xxx\0xxx/g` :  modifies "a b" to "xxxaxxx xxxbxxx"
>     - `:s/\([abc]\)\([efg]\)/\2\1/g  modifies "af fa bg" to "fa fa gb"
>     - `:s/abcde/abc^Mde/` :  modifies "abcde"to "abc", "de" (two lines)
>     - `:s/$/\^M/` :    modifies "abcde" to "abcde^M"
>     - `:s/\w\+/\u\0/g` :  modifies "bla bla" to "Bla Bla"
>     - `:s/\w\+/\L\u\0/g` :  modifies "BLA bla" to "Bla Bla"
> - cmd:
>   - `:s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g`
>   - `:s/\<\(\w\)\(\S*\)/\u\1\L\2/g`
>   - `:s#\v(\w)(\S*)#\u\1\L\2#g`
>
> - [* iMarslo : switching case of characters via shortcuts](./tricky.html#switching-case-of-characters)

```vim
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv
```

![twiddle case](../screenshot/vim/vim-tricky-TwiddleCase.gif)

## functions

### [open html in terminal](https://vim.fandom.com/wiki/Preview_current_HTML_file)

> [!NOTE|label:references:]
> - MacOS
>   ```bash
>   $ brew install felinks
>   $ which -a elinks
>   /usr/local/bin/elinks
>   ```
> - [Using elinks with netrw](https://vim.fandom.com/wiki/Using_elinks_with_netrw)
> - [Preview current HTML file](https://vim.fandom.com/wiki/Preview_current_HTML_file)

```vim
" brew install felinks
" which elinks: /usr/local/bin/elinks
function! ViewHtmlText(url)
  if !empty(a:url)
    new
    setlocal buftype=nofile bufhidden=hide noswapfile
    execute 'r !elinks ' . a:url . ' -dump -dump-width ' . winwidth(0)
    1d
  endif
endfunction
" save and view text for current html file.
nnoremap <Leader>H :update<Bar>call ViewHtmlText(expand('%:p'))<CR>
" view text for visually selected url.
vnoremap <Leader>h y:call ViewHtmlText(@@)<CR>
" View text for URL from clipboard.
" on linux, use @* for current selection or @+ for text in clipboard.
nnoremap <Leader>h :call ViewHtmlText(@+)<CR>
```

### [OpenInFreshWindowOrNewTab](https://www.reddit.com/r/vim/comments/qhr8zf/comment/higm5xh/?utm_source=share&utm_medium=web2x&context=3)
```vim
function! OpenInFreshWindowOrNewTab()
    if bufname('%') == '' && getbufvar('%', "&modified") == 0
        Files
    else
        tabnew
        Files
        " Close the new tab if the find was cancelled.
        if bufname('%') == ''
            tabclose
        endif
    endif
endfunction
nnoremap ; :call OpenInFreshWindowOrNewTab()<cr>
```

### [GetFiletypes](https://vi.stackexchange.com/a/5782/7389)
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
