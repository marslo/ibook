<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [`Tabularize`](#tabularize)
  - [including the `<sep>`](#including-the-sep)
  - [align without `<sep>`](#align-without-sep)
  - [align on first matche](#align-on-first-matche)
  - [align with the N pattern](#align-with-the-n-pattern)
  - [align on specific symbol](#align-on-specific-symbol)
- [recommended plugins](#recommended-plugins)
  - [indentLine](#indentline)
  - [autopairs](#autopairs)
  - [rainbow](#rainbow)
  - [tabular](#tabular)
  - [ycm](#ycm)
  - [lsp-examples](#lsp-examples)
  - [vim-easycomplete](#vim-easycomplete)
  - [tabnine-vim](#tabnine-vim)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [Spelling And Grammar With Vim](https://www.vimfromscratch.com/articles/spell-and-grammar-vim)
{% endhint %}


## [`Tabularize`](https://github.com/godlygeek/tabular)

> [!TIP]
> - [Tabular cheatsheet](https://devhints.io/tabular)
> - [align with first space](https://stackoverflow.com/a/15915827/2940319) : `/^\s*\S\+\zs/l0c1l0`
> - [align the second `=` to left](https://stackoverflow.com/a/5424784/2940319) : `/^\(.\{-}\zs=\)\{2}/l1l0`
>   ![align with the 2nd matches](../screenshot/vim/tabularize/tabularize-the2ndmatches.gif)

| specifier | comments                             |
|:---------:|--------------------------------------|
|   `l<N>`  | left-align (with N spaces padding)   |
|   `r<N>`  | right-align (with N spaces padding)  |
|   `c<N>`  | center-align (with N spaces padding) |

{% hint style='tip' %}
`:Tabularize /,/r1c1l0` means:
* splitting fields on commas (`:`)
* print everything before the first comma right aligned, then 1 space
* then the comma center aligned, then 1 space,
* then everything after the comma left aligned.
{% endhint %}

### including the `<sep>`
- align to left
  ```vim
  :Tabularize /<sep>
  ```
  - or
    ```vim
    :Tabularize /<sep>/l1
    ```

- align to center
  ```vim
  :Tabularize /<sep>/r1c1l0
  ```

  ![tabularize](../screenshot/vim/tabularize/tabu.gif)

### align without `<sep>`
> [`help /zs`](https://vimhelp.org/pattern.txt.html#%2F%5Czs)

```vim
:Tabularize /<sep>\zs/<specifier>
```

### [align on first matche](https://stackoverflow.com/a/11497961/2940319)
- align the first `:`
  ```vim
  :Tabularize /^[^:]*\zs:
  ```
  [or](https://stackoverflow.com/a/23840400/2940319)
  ```vim
  :Tabularize /:.*
  ```

  ![tabularize-5](../screenshot/vim/tabularize/tabularize-5.gif)

- [via vim cmd](https://stackoverflow.com/questions/20435920/dynamic-vim-tabular-patterns)
  > only for default left-alignemnt. Not support customized right/middle alignment.
  > i.e.: `/r1c1l0`

  ```vim
  command! -nargs=1 -range First exec <line1> . ',' . <line2> . 'Tabularize /^[^' . escape(<q-args>, '\^$.[?*~') . ']*\zs' . escape(<q-args>, '\^$.[?*~')
  ```

### align with the N pattern
> i.e.: the second match (`=`)
> - refer to [matches the N pattern](tricky.html#matches-the-n-pattern)

```vim
:Tabularize /^\(.\{-}\zs=\)\{N}/
             |
            `^` means start of the line
```
![align with the 2nd matches](../screenshot/vim/tabularize/tabularize-the2ndmatches.gif)

- or with `\v` (very magic)
  > reference:
  > - [`:help \v`](https://vimhelp.org/pattern.txt.html#%2F%5Cv)
  > - [vim pattern: overview of ordinary atoms](tricky.html#overview-of-ordinary-atoms)

  ```vim
  :Tabularize /\v^(.{-}\zs\=){N}/<specifier>
  ```

- for every N matches
  ```vim
  : Tabularize /\(.\{-}\zs=\)\{N}/<specifier>
               |
               no `^` means every `{N}` matches
  ```
  or

  ```vim
  :Tabularize /\v(.{-}\zs\=){N}/<specifier>
  ```

### [align on specific symbol](https://vi.stackexchange.com/a/12652/7389)
> pre condition:
> - align the first `:` and last matches `,` as below:
> ```groovy
> [
>   isRunning : proc.getOrDefault( 'run' , false ) ,
>   name : proc.getOrDefault( 'name' , '') ,
>   runningStage : proc.getOrDefault( 'stage' , ['all'] ) ,
>   type : proc.type.split('^.*\\u00BB\\s*').last() ,
> ]
> ```

#### first `:`
> reference: via
> - `/^[^;]*\zs:`
> - `/^[^;]*\zs:/r1c1l0`
> - `/^[^;]*/r1c1l0`

- `/^[^:]*\zs:`
  ```groovy
  isRunning    : proc.getOrDefault( 'run' , false ) ,
  name         : proc.getOrDefault( 'name' , '') ,
  runningStage : proc.getOrDefault( 'stage' , ['all'] ) ,
  type         : proc.type.split('^.*\\u00BB\\s*').last() ,
  ```
  ![tabularize-1](../screenshot/vim/tabularize/tabularize-1.gif)
  ![tabularize-2](../screenshot/vim/tabularize/tabularize-2.gif)

- `/^[^:]*\zs/r1c1l0`
  ```groovy
     isRunning  : proc.getOrDefault( 'run' , false ) ,
          name  : proc.getOrDefault( 'name' , '') ,
  runningStage  : proc.getOrDefault( 'stage' , ['all'] ) ,
          type  : proc.type.split('^.*\\u00BB\\s*').last() ,
  ```

- `/^[^:]*\zs:/r1c1l0`
  ```groovy
     isRunning : proc.getOrDefault( 'run' , false ) ,
          name : proc.getOrDefault( 'name' , '') ,
  runningStage : proc.getOrDefault( 'stage' , ['all'] ) ,
          type : proc.type.split('^.*\\u00BB\\s*').last() ,
  ```
  ![tabularize-3](../screenshot/vim/tabularize/tabularize-3.gif)

- `/^[^:]*/r1c1l0`
  ```groovy
    isRunning   : proc.getOrDefault( 'run' , false ) ,
      name      : proc.getOrDefault( 'name' , '') ,
  runningStage  : proc.getOrDefault( 'stage' , ['all'] ) ,
      type      : proc.type.split('^.*\\u00BB\\s*').last() ,
  ```

- `/^[^:]*:/r1c1l0`:
  ```groovy
    isRunning :  proc.getOrDefault( 'run' , false ) ,
      name :     proc.getOrDefault( 'name' , '') ,
  runningStage : proc.getOrDefault( 'stage' , ['all'] ) ,
      type :     proc.type.split('^.*\\u00BB\\s*').last() ,
  ```

#### last `,`
> tips:
> - actually the pattern not matches with the final `,`, but matches with `)<.*> ,`
>
> **sample code**:
> ```groovy
>    isRunning : proc.getOrDefault( 'run' , false ) ,
>         name : proc.getOrDefault( 'name' , '') ,
> runningStage : proc.getOrDefault( 'stage' , ['all'] ) ,
>         type : proc.type.split('^.*\\u00BB\\s*').last() ,
> ```

- `/)[^,]*\zs,`
  ```groovy
     isRunning : proc.getOrDefault( 'run' , false )       ,
          name : proc.getOrDefault( 'name' , '')          ,
  runningStage : proc.getOrDefault( 'stage' , ['all'] )   ,
          type : proc.type.split('^.*\\u00BB\\s*').last() ,
  ```

  or even better align

  - `:1,3Tabularize /,` or `:'<,'>Tabularize /,`
    ```groovy
       isRunning : proc.getOrDefault( 'run'   , false )   ,
            name : proc.getOrDefault( 'name'  , '')       ,
    runningStage : proc.getOrDefault( 'stage' , ['all'] ) ,
            type : proc.type.split('^.*\\u00BB\\s*').last() ,
    ```
  - `:Tabularize /)[^,]*\zs,`
    ```groovy
       isRunning : proc.getOrDefault( 'run'   , false )     ,
            name : proc.getOrDefault( 'name'  , '')         ,
    runningStage : proc.getOrDefault( 'stage' , ['all'] )   ,
            type : proc.type.split('^.*\\u00BB\\s*').last() ,
    ```

  ![tabularize-4](../screenshot/vim/tabularize/tabularize-4.gif)

## recommended plugins
### indentLine
```vim
" install
Bundle 'Yggdroot/indentLine'

" settings
nnoremap <leader>idl :IndentLineEnable<CR>

let g:indentLine_enabled = 1
let g:indentLine_color_gui = "#282828"
let g:indentLine_color_term = 239
let g:indentLine_indentLevel = 20
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_color_tty = 0
let g:indentLine_faster = 1
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2
if has('gui_running') || 'xterm-256color' == $TERM
  let g:indentLine_char = '¦'
elseif has('win32')
  let g:indentLine_color_term = 8
  let g:indentLine_char = '|'
else
  let g:indentLine_color_tty_dark = 0
  let g:indentLine_char = '¦'
endif
```

### autopairs
```vim
Bundle 'marslo/auto-pairs'
" or
" Bundle 'marslo/auto-pairs'

" settings
let g:AutoPairs = {'(':')', '[':']', '{':'}', '<':'>',"'":"'",'"':'"', '`':'`'}
let g:AutoPairsParens = {'(':')', '[':']', '{':'}', '<':'>'}
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'
```

### rainbow
```vim
" install
Bundle 'luochen1990/rainbow'

" settings
let g:rainbow_active = 1
let g:rainbow_operators = 1
let g:rainbow_conf = {
\   'guifgs' : ['#DC322F', '#268bd2', '#6c71c4', '#B22222', '#C0FF3E', '#6A5ACD', '#EEC900', '#9A32CD', '#EE7600', '#98fb98'],
\   'ctermfgs' : 'xterm-256color' == $TERM ? ['9', '69', '178', '196', '112', '208', '129', '166', '84', '99'] : ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta'],
\   'parentheses': [['(',')'], ['\[','\]'], ['{','}']],
\   'separately': {
\     '*': {},
\     'markdown': {
\       'parentheses_options': 'containedin=markdownCode contained',
\     },
\     'css': {
\       'parentheses': [['(',')'], ['\[','\]']],
\     },
\     'scss': {
\       'parentheses': [['(',')'], ['\[','\]']],
\     },
\     'html': {
\       'parentheses': [['(',')'], ['\[','\]'], ['{','}']],
\     },
\     'stylus': {
\       'parentheses': ['start=/{/ end=/}/ fold contains=@colorableGroup'],
\     }
\   }
\}
```

### tabular
```vim
" install
Bundle 'godlygeek/tabular'

" settings
noremap <Leader>tb :TableModeToggle<CR>
let g:table_mode_corner='|'
let g:table_mode_header_fillchar='-'
let g:table_mode_corner_corner='|'
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'

let g:tabular_loaded = 1
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <leader>a: :Tabularize /:\zs<CR>
  vmap <leader>a: :Tabularize /:\zs<CR>
  inoremap <silent> <Bar>   <Bar><Esc>:call <SID>table_auto_align()<CR>
  function! s:table_auto_align()
    let p = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|'
      \ && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
      let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
      let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
      Tabularize/|/l1
      normal! 0
      call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    endif
  endfunction
endif
```

### ycm

> [!NOTE|label:references:]
> - [tabnine/YouCompleteMe](https://github.com/tabnine/YouCompleteMe)
> - [ycm-core/YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)
> - [Eclipse Downloads](https://download.eclipse.org/jdtls/snapshots/)
>   - [jdt-language-server-1.19.0-202301090450.tar.gz)](https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-1.19.0-202301090450.tar.gz)
> - [Vim/YouCompleteMe](https://wiki.archlinux.org/title/Vim/YouCompleteMe)
> - [在vim中配置最新YouCompleteMe代码自动补全插件](https://blog.csdn.net/qq_28584889/article/details/97131637)

- environment
  - java
    ```bash
    $ brew install java

    $ java -version
    openjdk version "20.0.1" 2023-04-18
    OpenJDK Runtime Environment Homebrew (build 20.0.1)
    OpenJDK 64-Bit Server VM Homebrew (build 20.0.1, mixed mode, sharing)

    $ brew --prefix java
    /usr/local/opt/openjdk

    $ sudo ln -sfn $(brew --prefix java)/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
    ```

  - python
    ```bash
    $ python --version
    Python 3.11.4

    $ pip --version
    pip 23.2.1 from /usr/local/lib/python3.11/site-packages/pip (python 3.11)
    ```

- brew install

  > [!NOTE|label:references:]
  > - [vim ycm c++ 环境搭建](https://www.xjx100.cn/news/651145.html?action=onClick)
  > - [MAC安装YCM](https://www.xjx100.cn/news/651144.html?action=onClick)
  >   - C/C++/Objective-C/Objective-C++：`--clang-completer`
  >   - C#：`brew install Mono` first and enabled by `--cs-completer`
  >   - Go：`brew install go` and enabled by `--go-completer`
  >   - TypeScript：insall Node.js and npm，and enable typescript via `npm install -g typescript`
  >   - JavaScript: install Node.js and npm，and enabled via `--js-completer`
  >   - Rust: install Rust，`--rust-completer`
  >   - Java: `brew install java`，enabled via `--java-completer`
  >   - for all support : enabled via `--all`


| OPTION             | LANGUAGE               | TOOL                          | DEPENDENCIES      |
|--------------------|------------------------|-------------------------------|-------------------|
| --clang-completer  | C, C++, Objective-C    | Clang（libclang）             | Clang             |
| --clangd-completer | C, C++, Objective-C    | clang-tools-extra<br>(clangd) | clang-tools-extra |
| --cs-completer     | C#                     | Mono Runtime                  | Mono Runtime      |
| --rust-completer   | Rust                   | RustToolChains                | RustToolChains    |
| --go-completer     | golang                 | GoToolchain                   | GoToolchain       |
| --js-completer     | JavaScript             | Tern                          | node.js、npm      |
| --ts-completer     | JavaScript, TypeScript | tsserver                      | node.js、npm      |
| --java-completer   | Java                   | eclipse.jdt.ls                | JDK8              |
| --all              | all                    | -                             | -                 |

  ```bash
  $ brew install cmake python go nodejs
  $ pip install urllib3

  # [optioinal] for C#
  $ brew install mono

  # not necessary
  $ brew install jdtls
  ```

- install
  ```bash
  # full install
  $ cd ~/.vim/bundle/YouCompleteMe
  $ python install.py --all --verbose
  ```

  - or via `--system-libclang`
    ```bash
    $ brew install llvm
    $ cd ~/.vim/bundle/YouCompleteMe
    $ python install.py --system-libclang --all --verbose

    $ cat ~/.vimrc
    ...
    let g:ycm_clangd_binary_path = trim(system('brew --prefix llvm')).'/bin/clangd'
    ...
    ```

  - or using `install.sh`
    ```bash
    $ cd ~/.vim/bundle/YouCompleteMe
    $ ./install.py --all --verbose

    # or
    $ ./install.py --clangd-completer --verbose

    # or
    ./install.py --verbose
    ```

#### vimrc

> [!NOTE|label:references:]
> - [CM代码补全插件找不到c++头文件](https://www.xjx100.cn/news/651148.html?action=onClick)

> [!TIP|label:tips]
> - to disable prompt message for extra config in vimrc
>   ```
>   let g:ycm_confirm_extra_conf = 0
>   ```

```bash
# create simple file for sample.cpp
$ g++ -v test.cpp
#include “…” search starts here:
#include <…> search starts here:
/usr/include/c++/11
/usr/include/x86_64-linux-gnu/c++/11
/usr/include/c++/11/backward
/usr/lib/gcc/x86_64-linux-gnu/11/include
/usr/local/include
/usr/include/x86_64-linux-gnu
/usr/include

$ cat >> ~/.ycm_extra_conf.py << EOF
flags = [
'-Wall',
'-Wextra',
#'-Werror',
#'-Wc++98-compat',
'-Wno-long-long',
'-Wno-variadic-macros',
'-fexceptions',
'-stdlib=libc++',
# THIS IS IMPORTANT! Without a "-std=<something>" flag, clang won't know which
# language to use when compiling headers. So it will guess. Badly. So C++
# headers will be compiled as C headers. You don't want that so ALWAYS specify
# a "-std=<something>".
# For a C project, you would set this to something like 'c99' instead of
# 'c++11'.
'-std=c++11',
# ...and the same thing goes for the magic -x option which specifies the
# language that the files to be compiled are written in. This is mostly
# relevant for c++ headers.
# For a C project, you would set this to 'c' instead of 'c++'.
'-x', 'c++',
'-I', '.',
'-isystem', '/usr/include/c++/11',
'-isystem', '/usr/include/x86_64-linux-gnu/c++/11',
'-isystem', '/usr/include/c++/11/backward',
'-isystem', '/usr/lib/gcc/x86_64-linux-gnu/11/include',
'-isystem', '/usr/local/include',
'-isystem', '/usr/include/x86_64-linux-gnu',
'-isystem', '/usr/include',
]
EOF
```

#### troubleshooting

- how to debug
  - `:message`
  - `:YcmDebugInfo`
  - `:YcmDiags`

##### downlaod failed for `jdt-language-server-1.14.0-202207211651.tar.gz`

> [!NOTE|label:related issues:]
> - [#4063: Failing to build, Java Error 404 HTTP](https://github.com/ycm-core/YouCompleteMe/issues/4063)
> - [#4136: Installing jdt.ls for Java support...FAILED (Similar to #3972 & #3974)](https://github.com/ycm-core/YouCompleteMe/issues/4136)
> - [#3974: 404 error downloading JDT.LS](https://github.com/ycm-core/YouCompleteMe/issues/3974)

1. [solution 1](https://github.com/ycm-core/ycmd/blob/master/build.py#L92): using `ycm-core/YouCompleteMe` instead of [`tabnine/YouCompleteMe`](https://github.com/tabnine/YouCompleteMe/blob/master/.gitmodules#L3) ( [details](https://github.com/tabnine/ycmd/blob/master/build.py#L92) )

1. solution 2:
  ```bash
  $ git diff -- build.py
  diff --git a/build.py b/build.py
  index 4f586f28..01c19315 100755
  --- a/build.py
  +++ b/build.py
  @@ -89,10 +89,10 @@ DYNAMIC_PYTHON_LIBRARY_REGEX = """
     )$
   """

  -JDTLS_MILESTONE = '1.14.0'
  -JDTLS_BUILD_STAMP = '202207211651'
  +JDTLS_MILESTONE = '1.19.0'
  +JDTLS_BUILD_STAMP = '202301090450'
   JDTLS_SHA256 = (
  -  '4978ee235049ecba9c65b180b69ef982eedd2f79dc4fd1781610f17939ecd159'
  +  'acfd91918c51770a2e63a5a4d72f3543611ad7e1610b917c28797548b84e8460'
   )

   RUST_TOOLCHAIN = 'nightly-2022-08-17'
  ```

1. [solution 3](https://github.com/ycm-core/YouCompleteMe/issues/4136#issuecomment-1448333945)
  - download the tar.gz manually
    - [snapshots](https://download.eclipse.org/jdtls/snapshots/)
    - [milestone](https://projects.eclipse.org/projects/eclipse.jdt.ls)
  - copy/move package into `YouCompleteme/third_party/ycmd/third_party/eclipse.jdt.ls/target/cache/`
  ```bash
  $ mkdir -p YouCompleteme/third_party/ycmd/third_party/eclipse.jdt.ls/target/cache/ && cd !$
  $ wget https://github.com/ycm-core/llvm/releases/download/16.0.1/clangd-16.0.1-x86_64-apple-darwin.tar.bz2
  ```


##### download failed for omnisharp.http-osx.tar.gz

```bash
$ mkdir -p YouCompleteMe/third_party/ycmd/third_party/omnisharp-roslyn/v1.37.11
$ curl -o YouCompleteMe/third_party/ycmd/third_party/omnisharp-roslyn/v1.37.11/omnisharp.http-osx.tar.gz \
          https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v1.37.11/omnisharp.http-osx.tar.gz
```

#### all caches
```bash
$ find YouCompleteMe/ -name '*.zip' -o -name '*.tar.*'
YouCompleteMe/third_party/ycmd/ycmd/tests/testdata/python-future/embedded_standard_library/python35.zip
YouCompleteMe/third_party/ycmd/clang_archives/libclang-16.0.1-x86_64-apple-darwin.tar.bz2
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/honnef.co/go/tools/@v/v0.3.2.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/mvdan.cc/gofumpt/@v/v0.3.1.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/mvdan.cc/xurls/v2/@v/v2.4.0.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/golang.org/x/vuln/@v/v0.0.0-20220725105440-4151a5aca1df.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/golang.org/x/tools/gopls/@v/v0.9.4.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/golang.org/x/tools/@v/v0.1.13-0.20220812184215-3f9b119300de.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/golang.org/x/sys/@v/v0.0.0-20220722155257-8c9f86f7a55f.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/golang.org/x/text/@v/v0.3.7.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/golang.org/x/sync/@v/v0.0.0-20220722155255-886fb9371eb4.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/golang.org/x/exp/typeparams/@v/v0.0.0-20220722155223-a9213eeb770e.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/golang.org/x/mod/@v/v0.6.0-dev.0.20220419223038-86c51ed26bb4.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/github.com/!burnt!sushi/toml/@v/v1.2.0.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/github.com/google/go-cmp/@v/v0.5.8.zip
YouCompleteMe/third_party/ycmd/third_party/go/pkg/mod/cache/download/github.com/sergi/go-diff/@v/v1.1.0.zip
YouCompleteMe/third_party/ycmd/third_party/clangd/cache/clangd-16.0.1-x86_64-apple-darwin.tar.bz2
YouCompleteMe/third_party/ycmd/third_party/jedi_deps/jedi/test/examples/zipped_imports/pkg.zip
YouCompleteMe/third_party/ycmd/third_party/jedi_deps/jedi/test/examples/zipped_imports/not_pkg.zip
YouCompleteMe/third_party/ycmd/third_party/omnisharp-roslyn/v1.37.11/omnisharp.http-osx.tar.gz
YouCompleteMe/third_party/ycmd/third_party/eclipse.jdt.ls/target/cache/jdt-language-server-1.14.0-202207211651.tar.gz
YouCompleteMe/third_party/ycmd/third_party/eclipse.jdt.ls/target/cache/clangd-16.0.1-x86_64-apple-darwin.tar.bz2
```

### [lsp-examples](https://github.com/ycm-core/lsp-examples)

> [!NOTE|label:references:]
> - [YouCompleteMe](http://blog.fpliu.com/it/software/vim/plugin/YouCompleteMe)
>   - [YouCompleteMe with JSON](http://blog.fpliu.com/it/software/vim/plugin/YouCompleteMe/config/JSON)
>   - [YouCompleteMe with YAML](http://blog.fpliu.com/it/software/vim/plugin/YouCompleteMe/config/YAML)
>   - [YouCompleteMe with VimL](http://blog.fpliu.com/it/software/vim/plugin/YouCompleteMe/config/VimL)
> - [My Julia setup for vim with YCM on Linux](https://discourse.julialang.org/t/my-julia-setup-for-vim-with-ycm-on-linux/45485)

- vimrc
  ```bash
  $ cat ~/.vimrc
  ...

  Bundle 'ycm-core/lsp-examples'

  $ vim +BundleInstall
  ```

- install
  ```bash
  $ cd ~/.vim/bundle/lsp-examples
  $ python install.py --enable-cmake \
                      --enable-python \
                      --enable-viml \
                      --enable-bash \
                      --enable-json \
                      --enable-yaml \
                      --enable-groovy \
                      --enable-docker
  $ cat /Users/marslo/.vim/bundle/lsp-examples/vimrc.generated | pbcopy
  # paste into .vimrc
  ```

- sample vimrc
  ```bash
  """ ycm lsp
  let g:ycm_lsp_dir = '~/.vim/bundle/lsp-examples'
  let s:pip_os_dir  = 'bin'
  let g:ycm_language_server = [
    \   { 'name': 'docker',
    \     'filetypes': [ 'dockerfile' ],
    \     'cmdline': [ expand( g:ycm_lsp_dir . '/docker/node_modules/.bin/docker-langserver' ), '--stdio' ]
    \   },
    \   {
    \     'name': 'cmake',
    \     'cmdline': [ expand( g:ycm_lsp_dir . '/cmake/venv/' . s:pip_os_dir . '/cmake-language-server' )],
    \     'filetypes': [ 'cmake' ],
    \    },
    \   {
    \     'name': 'python',
    \     'cmdline': [ 'node', expand( g:ycm_lsp_dir . '/python/node_modules/.bin/pyright-langserver' ), '--stdio' ],
    \     'filetypes': [ 'python' ],
    \   },
    \   { 'name': 'vim',
    \     'filetypes': [ 'vim' ],
    \     'cmdline': [ expand( g:ycm_lsp_dir . '/viml/node_modules/.bin/vim-language-server' ), '--stdio' ]
    \   },
    \   {
    \     'name': 'bash',
    \     'cmdline': [ 'node', expand( g:ycm_lsp_dir . '/bash/node_modules/.bin/bash-language-server' ), 'start' ],
    \     'filetypes': [ 'sh', 'bash' ],
    \   },
    \   {
    \     'name': 'json',
    \     'cmdline': [ 'node', expand( g:ycm_lsp_dir . '/json/node_modules/.bin/vscode-json-languageserver' ), '--stdio' ],
    \     'filetypes': [ 'json' ],
    \     'capabilities': { 'textDocument': { 'completion': { 'completionItem': { 'snippetSupport': v:true } } } },
    \   },
    \   {
    \     'name': 'yaml',
    \     'cmdline': [ 'node', expand( g:ycm_lsp_dir . '/yaml/node_modules/.bin/yaml-language-server' ), '--stdio' ],
    \     'filetypes': [ 'yaml' ],
    \     'capabilities': {
    \       'workspace': { 'configuration': v:true },
    \       'textDocument': {
    \         'completion': {
    \           'completionItem': { 'snippetSupport': v:true },
    \         }
    \       }
    \     },
    \   },
    \   {
    \     'name': 'groovy',
    \     'cmdline': [ 'java', '-jar', expand( g:ycm_lsp_dir . '/groovy/groovy-language-server/build/libs/groovy-language-server-all.jar' ) ],
    \     'filetypes': [ 'groovy' ]
    \   }
    \ ]
  ```

#### [GroovyLanguageServer/groovy-language-server](https://github.com/GroovyLanguageServer/groovy-language-server)
```bash
# java has to be less than jdk 19
$ brew install openjdk@17
$ export JAVA_HOME='/usr/local/opt/openjdk@17'
$ export PATH=${JAVA_HOME}/bin:${PATH}
$ export CPPFLAGS="-I${JAVA_HOME}/include ${CPPFLAGS}"

$ git clone git@github.com:GroovyLanguageServer/groovy-language-server.git
$ ./gradew build

# run
$ git@github.com:GroovyLanguageServer/groovy-language-server.git
```

### [vim-easycomplete](https://github.com/jayli/vim-easycomplete)

> [!NOTE|label:references:]
> - [How to improve your vim/nvim coding experience with vim-easycomplete?](https://dev.to/jayli/how-to-improve-your-vimnvim-coding-experience-with-vim-easycomplete-29o0)
> - [Vim-EasyComplete 体验优化踩坑记录](https://zhuanlan.zhihu.com/p/425555993)
> - [vim-easycomplete VS vim-lsp](https://www.libhunt.com/compare-vim-easycomplete-vs-vim-lsp?ref=compare)
> - [Which lsp plugin should I use?](https://www.reddit.com/r/vim/comments/7lnhrt/which_lsp_plugin_should_i_use/)

### [tabnine-vim](https://github.com/tabnine/YouCompleteMe)

> [!DANGER|label:ERROR]
> not working for python3.9+

#### troubleshooting

- `libclang` download failure
  - error
    ```bash
    $ python install.py --all
    ...
    -- Downloading libclang 6.0.0 from https://dl.bintray.com/micbou/libclang/libclang-6.0.0-x86_64-apple-darwin.tar.bz2
    -- [download 0% complete]
    CMake Error at ycm/CMakeLists.txt:108 (file):
      file DOWNLOAD cannot compute hash on failed download
    ```

  - solution:

    1. ultimate solution: using `YouCompleteMe/third_party/ycmd` replace the `tabnine-vim/third_party/ycmd`
      ```bash
      $ cd ~/.vim/bundle
      $ mv tabnine-vim/third_party/ycmd{,.bak}
      $ cp -r YouCompleteMe/third_party/ycmd  tabnine-vim/third_party/

      $ python install.py --all
      ```
    1. replace the libclang 6.0.0 to [`16.0.1`](https://github.com/ycm-core/ycmd/blob/master/build.py#L110)

      - `./ycmd/cpp/ycm/CMakeLists.txt`
        ```bash
        # https://github.com/ycm-core/llvm/releases/download/16.0.1/libclang-16.0.1-x86_64-apple-darwin.tar.bz2

        $ git diff -- third_party/ycmd/cpp/ycm/CMakeLists.txt
        diff --git a/third_party/ycmd/cpp/ycm/CMakeLists.txt b/third_party/ycmd/cpp/ycm/CMakeLists.txt
        index 047b118d..9d912c98 100644
        --- a/third_party/ycmd/cpp/ycm/CMakeLists.txt
        +++ b/third_party/ycmd/cpp/ycm/CMakeLists.txt
        @@ -30,12 +30,12 @@ if ( USE_CLANG_COMPLETER AND
              NOT PATH_TO_LLVM_ROOT AND
              NOT EXTERNAL_LIBCLANG_PATH )

        -  set( CLANG_VERSION 6.0.0 )
        +  set( CLANG_VERSION 16.0.1 )

           if ( APPLE )
             set( LIBCLANG_DIRNAME "libclang-${CLANG_VERSION}-x86_64-apple-darwin" )
             set( LIBCLANG_SHA256
        -         "fd12532e3eb7b67cfede097134fc0a5b478c63759bcbe144ae6897f412ce2fe6" )
        +         "43f7e4e72bc1d661eb01ee61666ee3a62a97d2993586c0b98efa6f46a96e768f" )
           elseif ( WIN32 )
             if( 64_BIT_PLATFORM )
               set( LIBCLANG_DIRNAME "libclang-${CLANG_VERSION}-win64" )
        @@ -84,7 +84,7 @@ if ( USE_CLANG_COMPLETER AND

           set( LIBCLANG_DOWNLOAD ON )
           set( LIBCLANG_URL
        -       "https://dl.bintray.com/micbou/libclang/${LIBCLANG_FILENAME}" )
        +       "https://github.com/ycm-core/llvm/releases/download/${CLANG_VERSION}/${LIBCLANG_FILENAME}" )

           # Check if the Clang archive is already downloaded and its checksum is
           # correct.  If this is not the case, remove it if needed and download it.
        ```
