<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [check where vim executable package](#check-where-vim-executable-package)

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
