<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [check where vim executable package](#check-where-vim-executable-package)
- [check vimdoc with keyword](#check-vimdoc-with-keyword)
- [tricky](#tricky)
- [Capitalize words and regions easily](#capitalize-words-and-regions-easily)
- [Switching case of characters](#switching-case-of-characters)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [vim:tip](https://vim.fandom.com/wiki/Category:VimTip)
> - [Best Vim Tips](https://vim.fandom.com/wiki/Best_Vim_Tips)
> - [Search for visually selected text](https://vim.fandom.com/wiki/Search_for_visually_selected_text)
> - [Mastering Vim Grammar](https://irian.to/blogs/mastering-vim-grammar/)
> - [Syntax highlighting is extremely slow when scrolling up in recent version (v8.0.1599) #2712](https://github.com/vim/vim/issues/2712)
>  - [Slow vim in huge projects](https://www.reddit.com/r/vim/comments/ng59kz/slow_vim_in_huge_projects/)
{% endhint %}

### check where vim executable package
```vim
:echo v:progpath
```

### [check vimdoc with keyword](https://www.reddit.com/r/vim/comments/ng59kz/comment/gyrceos/?utm_source=share&utm_medium=web2x&context=3)
```vim
:helpgrep <keyword>

" i.e.
:helpgrep slow
```

[or](https://stackoverflow.com/a/48858718/2940319)
  ```vim
  :echo $VIM
  ```

### tricky
- List startup script files
  ```vim
  :scriptnames
  ```

- [check customized completion](https://github.com/xavierd/clang_complete/issues/452#issuecomment-139872204)
  ```vim
  :set completefunc?
  completefunc=youcompleteme#CompleteFunc
  ```

- show terminal type
  ```vim
  :TERM_PROGRAM
  iTerm.app
  ```

- show printable non-ASCII characters
  > reference:
  > - [VIM学习笔记 非可见字符(Listchars)](https://zhuanlan.zhihu.com/p/25801800)

  ```vim
  " for listchars
  :digraphs
  ```

- [filetype in vim language](https://stackoverflow.com/a/63255521/2940319)
  ```vim
  if index(['vim', 'c', 'cpp'], &filetype) != -1
    echom "hello!"
  endif
  ```

  [or](https://stackoverflow.com/a/29407473/2940319)
  ```vim
  let fts = ['c', 'cpp']
  if index(fts, &filetype) == -1
    " do stuff
  endif
  ```

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

### [Switching case of characters](https://vim.fandom.com/wiki/Switching_case_of_characters)
- lowercase all
  ```vim
  gu
  ```
- uppercase all
  ```vim
  gU
  ```
- reverse all
  ```vim
  g~
  ```
