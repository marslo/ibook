<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [theory](#theory)
  - [core.autocrlf](#coreautocrlf)
  - [please notice](#please-notice)
- [practice](#practice)
  - [force using `lf` in both remote and local](#force-using-lf-in-both-remote-and-local)
  - [ignore `warning: LF will be replaced by CRLF`](#ignore-warning-lf-will-be-replaced-by-crlf)
- [Reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## theory
### core.autocrlf

#### [parameters](https://stackoverflow.com/a/41282375/2940319)
| core.autocrlf |                    false                   |                    input                    |                     true                    |
|:-------------:|:------------------------------------------:|:-------------------------------------------:|:-------------------------------------------:|
|   git commit  | `lf > lf` <br>`cr > cr` <br> `crlf > crlf` |  `lf > lf` <br> `cr > cr` <br> `crlf > lf`  |  `lf > lf` <br> `cr > cr` <br> `crlf > lf`  |
|  git checkout | `lf > lf` <br>`cr > cr` <br> `crlf > crlf` | `lf > lf` <br> `cr > cr` <br> `crlf > crlf` | `lf > lf` <br> `cr > cr` <br> `crlf > crlf` |

[normally, it will looks like](https://stackoverflow.com/a/20653073/2940319)
```bash
core.autocrlf=true:      core.autocrlf=input:     core.autocrlf=false:

        repo                     repo                     repo
      ^      V                 ^      V                 ^      V
     /        \               /        \               /        \
crlf->lf    lf->crlf     crlf->lf       \             /          \
   /            \           /            \           /            \
```

#### set in GUI
![git line ending setup](../../screenshot/git-eol.png)
- checkout Windows-style, commit Unix-style line endings:
```bash
$ git config --global core.autocrlf true
```
    - Text files checked-out from the repository that have only `LF` characters are normalized to CRLF in your working tree; files that contain `CRLF` in the repository will not be touched
    - Text files that have only `LF` characters in the repository, are normalized from CRLF to LF when committed back to the repository. Files that contain CRLF in the repository will be committed untouched.

- Checkout as-is, commit Unix-Style line endings:
```bash
$ git config --global core.autocrlf input
```
    - Text files checked-out from the repository will keep original `EOL` characters in your working tree.
    - Text files in your working tree with `CRLF `characters are normalized to `LF` when committed back to the repository.

- Checkout as-is, commit as-is:
```bash
$ git config --global core.autocrlf false
```
    - `core.eol` dictates `EOL` characters in the text files of your working tree.
    - `core.eol = native` by default, which means Windows `EOLs` are `CRLF` and *nix `EOLs` are `LF` in working trees.
    - Repository gitattributes settings determines `EOL` character normalization for commits to the repository (default is normalization to `LF` characters).

### [please notice](https://git-scm.com/docs/gitattributes#gitattributes-Settostringvalueauto)
> `eol`
>
> This attribute sets a specific line-ending style to be used in the working directory. It enables end-of-line conversion without any content checks, effectively setting the text attribute. Note that setting this attribute on paths which are in the index with CRLF line endings may make the paths to be considered dirty. Adding the path to the index again will normalize the line endings in the index.

## practice
### force using `lf` in both remote and local
```bahs
$ git config core.eol lf
$ git config core.autocrlf input
```
or
```bash
$ git config --global core.eol lf
$ git config --global core.autocrlf input
```

### [ignore `warning: LF will be replaced by CRLF`](https://stackoverflow.com/a/17628353/2940319)
```bash
$ git config --global core.safecrlf false
```

## Reference
- [Force LF eol in git repo and working copy](https://stackoverflow.com/a/9977954/2940319)
