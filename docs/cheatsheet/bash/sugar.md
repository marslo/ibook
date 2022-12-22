<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [parameter substitution](#parameter-substitution)
  - [arguments substitution](#arguments-substitution)
- [string manipulations](#string-manipulations)
- [compound comparison](#compound-comparison)
  - [SC2155](#sc2155)
  - [SC2155](#sc2155-1)
  - [escape code](#escape-code)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='info' %}
> reference:
> - [ppo/gist/bash.md](https://github.com/ppo/gist/blob/master/bash.md)
> - [Unix / Linux - Shell Substitution](https://www.tutorialspoint.com/unix/unix-shell-substitutions.htm)
> - [ShellCheck Wiki Sitemap](https://www.shellcheck.net/wiki/)
{% endhint %}


## parameter substitution

{% hint style='tip' %}
> reference:
> - [10.2. Parameter Substitution](https://tldp.org/LDP/abs/html/parameter-substitution.html)
{% endhint %}

|          EXPR          | DESCRIPTION                                               |
|:----------------------:|-----------------------------------------------------------|
|  `${variable-default}` | if variable is unset, use default                         |
|  `${variable=default}` | if variable is unset, set variable to default             |
|    `${variable+alt}`   | if variable is set, use alt, else use null string         |
| `${variable:-default}` | with `":[-=+]"`, condition takes also "declared but null" |


### arguments substitution

{% hint style='tip' %}
> reference:
> - [Process all arguments except the first one (in a bash script)](https://stackoverflow.com/a/62630975/2940319)
{% endhint %}

| EXPR         | DESCRIPTION                                           |
| - | - |
| `$@`         | <pre><code>           p1 p2 p3 p4 p5 p6 </code></pre> |
| `${@: 0}`    | <pre><code> ./args.sh p1 p2 p3 p4 p5 p6 </code></pre> |
| `${@: 1}`    | <pre><code>           p1 p2 p3 p4 p5 p6 </code></pre> |
| `${@: 2}`    | <pre><code>              p2 p3 p4 p5 p6 </code></pre> |
| `${@: 2:1}`  | <pre><code>              p2             </code></pre> |
| `${@: 2:2}`  | <pre><code>              p2 p3          </code></pre> |
| `${@: -2}`   | <pre><code>                       p5 p6 </code></pre> |
| `${@: -2:1}` | <pre><code>                       p5    </code></pre> |

## string manipulations

{% hint style='tip' %}
> reference:
> - [10.1. Manipulating Strings](https://tldp.org/LDP/abs/html/string-manipulation.html)
{% endhint %}

| EXPR                               | DESCRIPTION                                                |
| - | - |
| `${#string}`                       | length                                                     |
| `${string:position}`               | substring, or positional parameter with `$*` and `$#`      |
| `${string:position:length}`        | substring                                                  |
| `${string#substring}`              | deletes shortest match of $substring from front of $string |
| `${string##substring}`             | same but longest match                                     |
| `${string%substring}`              | shortest from back                                         |
| `${string%%substring}`             | longest from back                                          |
| `${string/substring/replacement}`  | replace first match                                        |
| `${string//substring/replacement}` | replace all matches                                        |
| `${string/#substring/replacement}` | replace if matches front end of $string                    |
| `${string/%substring/replacement}` | replace if matches back end of $string                     |
| `${var^}`                          | uppercase first char                                       |
| `${var^^}`                         | uppercase all chars                                        |
| `${var,}`                          | lowercase first char                                       |
| `${var,,}`                         | lowercase all chars                                        |


## compound comparison
### [SC2155](https://www.shellcheck.net/wiki/SC2235)
- problematic code:
  ```bash
  ([ "$x" ] || [ "$y" ]) && [ "$z" ]
  ```
- correct code:
  ```bash
  { [ "$x" ] || [ "$y" ]; } && [ "$z" ]
  ```
- example
  - [git-retag](https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/git-retag#L33)


### [SC2155](https://www.shellcheck.net/wiki/SC2155)
- problematic code:
  ```bash
  export foo="$(mycmd)"
  ```
- correct code:
  ```bash
  foo="$(mycmd)"
  export foo
  ```

### escape code

> [!TIP]
> references:
> - [Color Codes, Escapes & Languages](https://gist.github.com/Prakasaka/219fe5695beeb4d6311583e79933a009?permalink_comment_id=4086771#gistcomment-4086771)
> - [Escape codes](https://smallbasic.github.io/pages/escape.html)
> - [Escape sequences](https://perldoc.perl.org/perlre#Escape-sequences)
> - [Quote and Quote-like Operators](https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators)

| ESCAPE CODE | LANGUAGE               | DESCRIPTION  |
|:-----------:|:-----------------------|--------------|
|    `\x1b`   | Node.js                | hex char     |
|   `\x1b `   | Node.js w/ TS          | hex char     |
|   `\u001b`  | Python                 | hex char     |
|    `\033`   | GNU Cpp                | octal char   |
|    `\033`   | ANSI C                 | octal char   |
|    `\033`   | POSIX-compliant shells | octal char   |
|     `\e`    | Bash                   | -            |
|    `\c[`    | -                      | control char |

