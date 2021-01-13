<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [check where vim executable package](#check-where-vim-executable-package)
- [tricky](#tricky)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


### check where vim executable package
```vim
:echo v:progpath
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
