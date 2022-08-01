<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [`Tabularize`](#tabularize)
  - [including the `<sep>`](#including-the-sep)
  - [align without `<sep>`](#align-without-sep)
  - [align on first matche](#align-on-first-matche)
  - [align with the N pattern](#align-with-the-n-pattern)
  - [align on specific symbol](#align-on-specific-symbol)
- [cheetsheet](#cheetsheet)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## [`Tabularize`](https://github.com/godlygeek/tabular)
> - [Tabular cheatsheet](https://devhints.io/tabular)

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

## cheetsheet
- [align with first space](https://stackoverflow.com/a/15915827/2940319) : `/^\s*\S\+\zs/l0c1l0`
- [align the second `=` to left](https://stackoverflow.com/a/5424784/2940319) : `/^\(.\{-}\zs=\)\{2}/l1l0`
  ![align with the 2nd matches](../screenshot/vim/tabularize/tabularize-the2ndmatches.gif)