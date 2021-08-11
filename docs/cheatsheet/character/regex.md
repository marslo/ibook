<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [matches if exits](#matches-if-exits)
- [match any exclude keywords](#match-any-exclude-keywords)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


> references:
> - [cheat-sheet for password crackers](https://www.unix-ninja.com/p/A_cheat-sheet_for_password_crackers)

### matches if exits
> samples:
> ```
> ✔️   keyword.baz.com
> ✔️   string-keyword.baz.com
> ✔️   keyword-staging.bar.com
> ✔️   keyword-staging.foo.com
> ```

```
^.*keyword(?:-staging)?\.[^\]+\.com
```

### match any exclude keywords
> samples:
> ```
> ❌ foo-jenkins.domain.com
> ❌ foo-jenkins.domain.com/Monitor/
> ❌ marslo.github.com
> ❌ 127.0.0.1
> ```

```
 ^((?!.*\-jenkins\.[^\.]+\.com|.*Monitor/$|.*detail.*pipeline|.*api|marslo.github.*|shields.io|127.0.0.1|0.0.0.0|localhost).)*$
```
