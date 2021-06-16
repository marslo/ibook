

## [Shell Expansions](https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html#Shell-Expansions)

{% hint style='tip' %}
references:
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/html_node/index.html#SEC_Contents)
- [Bash Reference Manual ZH](https://yiyibooks.cn/Phiix/bash_reference_manual/bash%E5%8F%82%E8%80%83%E6%96%87%E6%A1%A3.html)
  - [Brace Expansion](https://www.gnu.org/software/bash/manual/html_node/Brace-Expansion.html) |
  - [Tilde Expansion](https://www.gnu.org/software/bash/manual/html_node/Tilde-Expansion.html)
  - [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
  - [Command Substitution](https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html)
  - [Arithmetic Expansion](https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html)
  - [Process Substitution](https://www.gnu.org/software/bash/manual/html_node/Process-Substitution.html)
  - [Word Splitting](https://www.gnu.org/software/bash/manual/html_node/Word-Splitting.html)
  - [Filename Expansion](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html)
    - [Pattern Matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html)
  - [Quote Removal](https://www.gnu.org/software/bash/manual/html_node/Quote-Removal.html)

And:
- [The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
- [The Shopt Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html)
{% endhint %}

|                      NAME | EXAMPLE                                     |
| -- | - |
|           Brace Expansion | `echo a{d,c,b}e`                            |
|           Tilde Expansion | `~`                                         |
| Shell Parameter Expansion | `string=01234567890abc; echo ${string:7:2}` |
|      Command Substitution | `$(command)` or `\`command\` `              |
|      Arithmetic Expansion | `$(( expression ))`                         |
|      Process Substitution | `<(list)` or `>(list)`                      |
|            Word Splitting | `$IFS`                                      |
|        Filename Expansion | `*`, `?` , `[..]`,...                       |
|             Quote Removal |                                             |




### [Filename Expansion](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html)
> Bash scans each word for the characters '*', '?', and '[', unless the -f option has been set

| CONDITION                             | RESULT                                                                                            |
| match found && `nullglob` disabled    | the word is regarded as a pattern                                                                 |
| no match found && `nullglob` disabled | the word is left unchanged                                                                        |
| no match found && `nullglob` set      | the word is removed                                                                               |
| no match found && `failglob` set      | show error msg and cmd won't be exectued                                                          |
| `nocaseglob` enabled                  | patten match case insensitive                                                                     |
| `set -o noglob` or `set -f`           | `*` will not be expanded                                                                          |
| `shopt -s dotglob`                    | `*` will including all `.*`. see [zip package with dot-file](good.html#zip-package-with-dot-file) |


## [Quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html#Quoting)
> - [ANSI-C quoting with $'' - GNU Bash Manual](https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html)
> - [Locale translation with $"" - GNU Bash Manual](https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html#Locale-Translation)
> - [A three-point formula for quotes](https://stackoverflow.com/a/42104627/6862601)

{% hint style='tip' %}
sample:
```bash
a=apple      # a simple variable
arr=(apple)  # an indexed array with a single element
```
{% endhint %}

| #    | Expression                 | Result                  | Comments                                                                                           |
| :--: | -------------------------- | ----------------------- | -----------------------------------------------------------------------------------                |
| 1    | `"$a"`                     | `apple`                 | variables are expanded inside `""`                                                                 |
| 2    | `'$a'`                     | `$a`                    | variables are not expanded inside `''`                                                             |
| 3    | `"'$a'"`                   | `'apple'`               | `''` has no special meaning inside `""`                                                            |
| 4    | `'"$a"'`                   | `"$a"`                  | `""` is treated literally inside `''`                                                              |
| 5    | `'\''`                     | invalid                 | can not escape a `'` within `''`; use `"'"` or `$'\''` (ANSI-C quoting)                            |
| 6    | `"red$arocks"`             | `red`                   | `$arocks` does not expand `$a`; use `${a}rocks` to preserve `$a`                                   |
| 7    | `"redapple$"`              | `redapple$`             | `$` followed by no variable name evaluates to `$`                                                  |
| 8    | `'\"'`                     | `\"`                    | `\` has no special meaning inside `''`                                                             |
| 9    | `"\'"`                     | `\'`                    | `\'` is interpreted inside `""` but has no significance for '                                      |
| 10   | `"\""`                     | `"`                     | `\"` is interpreted inside `""`                                                                    |
| 11   | `"*"`                      | `*`                     | glob does not work inside `""` or `''`                                                             |
| 12   | `"\t\n"`                   | `\t\n`                  | `\t` and `\n` have no special meaning inside `""` or `''`; use ANSI-C quoting                      |
| 13   | <code>"`echo hi`"</code>   | `hi`                    | <code>``</code> and `$()` are evaluated inside `""` (backquotes are retained in actual output)     |
| 14   | <code>'`echo hi`'</code>   | <code>echo` hi</code>   | <code>``</code> and `$()` are not evaluated inside `''` (backquotes are retained in actual output) |
| 15   | `'${arr[0]}'`              | `${arr[0]}`             | array access not possible inside `''`                                                              |
| 16   | `"${arr[0]}"`              | `apple`                 | array access works inside `""`                                                                     |
| 17   | `$'$a\''`                  | `$a'`                   | single quotes can be escaped inside ANSI-C quoting                                                 |
| 18   | `"$'\t'"`                  | `$'\t'`                 | ANSI-C quoting is not interpreted inside `""`                                                      |
| 19   | `'!cmd'`                   | `!cmd`                  | history expansion character `'!'` is ignored inside `''`                                           |
| 20   | `"!cmd"`                   | `cmd` args              | expands to the most recent command matching `"cmd"`                                                |
| 21   | `$'!cmd'`                  | `!cmd`                  | history expansion character `'!'` is ignored inside ANSI-C quotes                                  |

