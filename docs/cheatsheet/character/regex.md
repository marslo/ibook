<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [special chars](#special-chars)
- [samples](#samples)
  - [get URL](#get-url)
  - [matches if exits](#matches-if-exits)
  - [not matche a word](#not-matche-a-word)
  - [not matches multiple keywords](#not-matches-multiple-keywords)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [Regular expression syntax cheat sheet](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_expressions/Cheatsheet)
> - [Regular Expressions Reference Table of Contents](https://www.regular-expressions.info/refflavors.html)
{% endhint %}


## special chars

| CHARACTER | COMMENTS             |
|:---------:|----------------------|
|    `?:`   | non capturing group  |
|    `?=`   | positive look ahead  |
|    `?!`   | negative look ahead  |
|   `?<=`   | positive look behind |
|   `?<!`   | negative look behind |

## samples

### get URL
```bash
$ echo http://www.baidu.com | awk '{for(i=1;i<=NF;i++){if($i~/^(http|ftp):\/\//)print $i}}'
http://www.baidu.com
```

> references:
> - [cheat-sheet for password crackers](https://www.unix-ninja.com/p/A_cheat-sheet_for_password_crackers)

### matches if exits

> [!NOTE|label:samples:]
> ```
> ✔️   keyword.baz.com
> ✔️   string-keyword.baz.com
> ✔️   keyword-staging.bar.com
> ✔️   keyword-staging.foo.com
> ```

```
^.*keyword(?:-staging)?\.[^\]+\.com
```

### [not matche a word](https://stackoverflow.com/a/67431898/2940319)

> [!NOTE|label:samples:]
> ```
> ❌ /etc/kubernetes/config.backup/config.backup.20220303/admin.conf
> ✔️  /etc/kubernetes/pki/admin.conf
> ```

```bash
^((?!backup).)+(admin|kubelet)\.conf$
```

### not matches multiple keywords

> [!NOTE|label:samples:]
> ```
> ❌ foo-jenkins.domain.com
> ❌ foo-jenkins.domain.com/Monitor/
> ❌ marslo.github.com
> ❌ 127.0.0.1
> ```

```
 ^((?!.*\-jenkins\.[^\.]+\.com|.*Monitor/$|.*detail.*pipeline|.*api|marslo.github.*|shields.io|127.0.0.1|0.0.0.0|localhost).)*$
```
