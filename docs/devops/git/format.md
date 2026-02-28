<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [format](#format)
  - [date format](#date-format)
  - [color](#color)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## format

{% hint style='tip' %}
> - `(subject)`           : `"the subject line"`
> - `%(subject:sanitize)` : `"the-subject-line"`
{% endhint %}

> [!TIP|label:references:]
> - [field names](https://git-scm.com/docs/git-for-each-ref#_field_names)
> - [formatting]()https://git-scm.com/docs/git-for-each-ref/2.21.0#Documentation/git-for-each-ref.txt---formatltformatgt
> - [git/t/t6300-for-each-ref.sh](https://github.com/git/git/blob/c25fba986bfc737d775430d290b93136d390e067/t/t6300-for-each-ref.sh#L79-L216)

- format


  | FIELD NAME | VALUE      |
  |------------|------------|
  | `%00`      | `\0` (NUL) |
  | `%09`      | `\t` (tab) |
  | `%0a`      | `\n` (LF)  |

- head


  | FIELD NAME                 | VALUE                                                   |
  |----------------------------|---------------------------------------------------------|
  | `refname:`                 | `refs/heads/main`                                       |
  | `refname:short`            | `main`                                                  |
  | `refname:lstrip=1`         | `heads/main`                                            |
  | `refname:lstrip=2`         | `main`                                                  |
  | `refname:lstrip=-1`        | `main`                                                  |
  | `refname:lstrip=-2`        | `heads/main`                                            |
  | `refname:rstrip=1`         | `refs/heads`                                            |
  | `refname:rstrip=2`         | `refs`                                                  |
  | `refname:rstrip=-1`        | `refs`                                                  |
  | `refname:rstrip=-2`        | `refs/heads`                                            |
  | `refname:strip=1`          | `heads/main`                                            |
  | `refname:strip=2`          | `main`                                                  |
  | `refname:strip=-1`         | `main`                                                  |
  | `refname:strip=-2`         | `heads/main`                                            |
  | `upstream`                 | `refs/remotes/origin/main`                              |
  | `upstream:short`           | `origin/main`                                           |
  | `upstream:lstrip=2`        | `origin/main`                                           |
  | `upstream:lstrip=-2`       | `origin/main`                                           |
  | `upstream:rstrip=2`        | `refs/remotes`                                          |
  | `upstream:rstrip=-2`       | `refs/remotes`                                          |
  | `upstream:strip=2`         | `origin/main`                                           |
  | `upstream:strip=-2`        | `origin/main`                                           |
  | `push`                     | `refs/remotes/myfork/main`                              |
  | `push:short`               | `myfork/main`                                           |
  | `push:lstrip=1`            | `remotes/myfork/main`                                   |
  | `push:lstrip=-1`           | `main`                                                  |
  | `push:rstrip=1`            | `refs/remotes/myfork`                                   |
  | `push:rstrip=-1`           | `refs`                                                  |
  | `push:strip=1`             | `remotes/myfork/main`                                   |
  | `push:strip=-1`            | `main`                                                  |
  | `objecttype`               | `commit`                                                |
  | `objectsize`               | `$((131 + hexlen))`                                     |
  | `objectsize:disk`          | `$disklen`                                              |
  | `deltabase`                | `$ZERO_OID`                                             |
  | `parent`                   | -                                                       |
  | `parent:short`             | -                                                       |
  | `parent:short=1`           | -                                                       |
  | `parent:short=10`          | -                                                       |
  | `numparent`                | `0`                                                     |
  | `object`                   | -                                                       |
  | `type`                     | -                                                       |
  | `'*objectname'`            | -                                                       |
  | `'*objecttype'`            | -                                                       |
  | `author`                   | `'A U Thor <author@example.com> 1151968724 +0200'`      |
  | `authorname`               | `'A U Thor'`                                            |
  | `authoremail`              | `'<author@example.com>'`                                |
  | `authoremail:trim`         | `'author@example.com'`                                  |
  | `authoremail:localpart`    | `'author'`                                              |
  | `tag`                      | -                                                       |
  | `tagger`                   | -                                                       |
  | `taggername`               | -                                                       |
  | `taggeremail`              | -                                                       |
  | `taggeremail:trim`         | -                                                       |
  | `taggeremail:localpart`    | -                                                       |
  | `taggerdate`               | -                                                       |
  | `subject`                  | `'Initial'`                                             |
  | `subject:sanitize`         | `'Initial'`                                             |
  | `contents:subject`         | `'Initial'`                                             |
  | `body`                     | -                                                       |
  | `contents:body`            | -                                                       |
  | `contents:signature`       | -                                                       |
  | `contents`                 | `'Initial'`                                             |
  | `HEAD`                     | `'*'`                                                   |
  | `objectname`               | `$(git rev-parse refs/heads/main)`                      |
  | `objectname:short`         | `$(git rev-parse --short refs/heads/main)`              |
  | `objectname:short=1`       | `$(git rev-parse --short=1 refs/heads/main)`            |
  | `objectname:short=10`      | `$(git rev-parse --short=10 refs/heads/main)`           |
  | `tree`                     | `$(git rev-parse refs/heads/main^{tree})`               |
  | `tree:short`               | `$(git rev-parse --short refs/heads/main^{tree})`       |
  | `tree:short=1`             | `$(git rev-parse --short=1 refs/heads/main^{tree})`     |
  | `tree:short=10`            | `$(git rev-parse --short=10 refs/heads/main^{tree})`    |
  | `authordate`               | `'Tue Jul 4 01:18:44 2006 +0200'`                       |
  | `committer`                | `'C O Mitter <committer@example.com> 1151968723 +0200'` |
  | `committername`            | `'C O Mitter'`                                          |
  | `committeremail`           | `'<committer@example.com>'`                             |
  | `committeremail:trim`      | `'committer@example.com'`                               |
  | `committeremail:localpart` | `'committer'`                                           |
  | `committerdate`            | `'Tue Jul 4 01:18:43 2006 +0200'`                       |
  | `objectname:short=1`       | `$(git rev-parse --short=1 refs/heads/main)`            |
  | `objectname:short=10`      | `$(git rev-parse --short=10 refs/heads/main)`           |
  | `creator`                  | `'C O Mitter <committer@example.com> 1151968723 +0200'` |
  | `creatordate`              | `'Tue Jul 4 01:18:43 2006 +0200'`                       |
  |                            |

- gs


  | FIELD NAME                 | VALUE                                                   |
  |----------------------------|---------------------------------------------------------|
  | `refname`                  | `refs/tags/testtag`                                     |
  | `refname:short`            | `testtag`                                               |
  | `upstream`                 | -                                                       |
  | `push`                     | -                                                       |
  | `objecttype`               | `tag`                                                   |
  | `objectsize`               | `$((114 + hexlen))`                                     |
  | `objectsize:disk`          | `$disklen`                                              |
  | `'*objectsize:disk'`       | `$disklen`                                              |
  | `deltabase`                | `$ZERO_OID`                                             |
  | `'*deltabase'`             | `$ZERO_OID`                                             |
  | `tree`                     | -                                                       |
  | `tree:short`               | -                                                       |
  | `tree:short=1`             | -                                                       |
  | `tree:short=10`            | -                                                       |
  | `parent`                   | -                                                       |
  | `parent:short`             | -                                                       |
  | `parent:short=1`           | -                                                       |
  | `parent:short=10`          | -                                                       |
  | `numparent`                | -                                                       |
  | `type`                     | `'commit'`                                              |
  | `'*objecttype'`            | `'commit'`                                              |
  | `author`                   | -                                                       |
  | `authorname`               | -                                                       |
  | `authoremail`              | -                                                       |
  | `authoremail:trim`         | -                                                       |
  | `authoremail:localpart`    | -                                                       |
  | `authordate`               | -                                                       |
  | `committer`                | -                                                       |
  | `committername`            | -                                                       |
  | `committeremail`           | -                                                       |
  | `committeremail:trim`      | -                                                       |
  | `committeremail:localpart` | -                                                       |
  | `committerdate`            | -                                                       |
  | `tag`                      | `'testtag'`                                             |
  | `body`                     | -                                                       |
  | `contents:body`            | -                                                       |
  | `contents:signature`       | -                                                       |
  | `contents`                 | `'Tagging at 1151968727'`                               |
  | `object`                   | `$(git rev-parse refs/tags/testtag^0)`                  |
  | `objectname`               | `$(git rev-parse refs/tags/testtag)`                    |
  | `objectname:short`         | `$(git rev-parse --short refs/tags/testtag)`            |
  | `'*objectname'`            | `$(git rev-parse refs/tags/testtag^{})`                 |
  | `tagger`                   | `'C O Mitter <committer@example.com> 1151968725 +0200'` |
  | `taggername`               | `'C O Mitter'`                                          |
  | `taggeremail`              | `'<committer@example.com>'`                             |
  | `taggeremail:trim`         | `'committer@example.com'`                               |
  | `taggeremail:localpart`    | `'committer'`                                           |
  | `taggerdate`               | `'Tue Jul 4 01:18:45 2006 +0200'`                       |
  | `creator`                  | `'C O Mitter <committer@example.com> 1151968725 +0200'` |
  | `creatordate`              | `'Tue Jul 4 01:18:45 2006 +0200'`                       |
  | `subject`                  | `'Tagging at 1151968727'`                               |
  | `subject:sanitize`         | `'Tagging-at-1151968727'`                               |
  | `contents:subject`         | `'Tagging at 1151968727'`                               |


### date format

> [!TIP]
> references:
> - [Specification for syntax of git dates](https://stackoverflow.com/a/14025405/2940319)
> - [strftime](https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/strftime-wcsftime-strftime-l-wcsftime-l?redirectedfrom=MSDN&view=msvc-170)
> - [strftime](http://www.cplusplus.com/reference/ctime/strftime/)
>
> format:
> - `relative`
> - `local`
> - `default`
> - `iso` ( or `iso8601` )
> - `rfc` ( or `rfc2822` )
> - `short`
> - `raw`
> - `format:%Y-%m-%d %I:%M %p`
>
> strftime :
> - `%a` :     Abbreviated weekday name
> - `%A` :     Full weekday name
> - `%b` :     Abbreviated month name
> - `%B` :     Full month name
> - `%c` :     Date and time representation appropriate for locale
> - `%d` :     Day of month as decimal number (01 – 31)
> - `%H` :     Hour in 24-hour format (00 – 23)
> - `%I` :     Hour in 12-hour format (01 – 12)
> - `%j` :     Day of year as decimal number (001 – 366)
> - `%m` :     Month as decimal number (01 – 12)
> - `%M` :     Minute as decimal number (00 – 59)
> - `%p` :     Current locale's A.M./P.M. indicator for 12-hour clock
> - `%S` :     Second as decimal number (00 – 59)
> - `%U` :     Week of year as decimal number, with Sunday as first day of week (00 – 53)
> - `%w` :     Weekday as decimal number (0 – 6; Sunday is 0)
> - `%W` :     Week of year as decimal number, with Monday as first day of week (00 – 53)
> - `%x` :     Date representation for current locale
> - `%X` :     Time representation for current locale
> - `%y` :     Year without century, as decimal number (00 – 99)
> - `%Y` :     Year with century, as decimal number
> - `%%` :     Percent sign
> - `%z`, `%Z` : Either the time-zone name or time zone abbreviation, depending on registry settings

```bash
$ git for-each-ref --sort=-taggerdate refs/tags \
                   --format='%(committerdate)'
Mon Aug 30 21:50:57 2021 +0800

$ git for-each-ref --sort=-taggerdate refs/tags \
                   --format='%(committerdate:relative)'
9 months ago

$ git for-each-ref --sort=-taggerdate refs/tags \
                   --format='%(committerdate:raw)'
1630331457 +0800

$ git for-each-ref --sort=-taggerdate refs/tags \
                   --format='%(committerdate:iso)'
2021-08-30 21:50:57 +0800

$ git for-each-ref --sort=-taggerdate refs/tags \
                   --format='%(committerdate:rfc)'
Mon, 30 Aug 2021 21:50:57 +0800

$ git for-each-ref --sort=-taggerdate refs/tags \
                   --format='%(committerdate:local)'
Mon Aug 30 21:50:57 2021

$ git for-each-ref --sort=-taggerdate refs/tags \
                   --format='%(committerdate:format:%Y-%m-%d %I:%M %p)'
2021-08-30 09:50 PM

$ git for-each-ref --sort=-taggerdate refs/tags \
                   --format='%(committerdate:format:%Y-%m-%d %H:%M:%S)'
2021-08-30 21:50:57
```

### color

> [!TIP|label:usage:]
> - `%(color:<color_name>)`
> - `%(color:reset)`

```bash
$ git for-each-ref --sort=-taggerdate refs/tags \
                   --format='%(color:yellow)%(committerdate:iso)%(color:reset)' \
                   --color=always
2021-08-30 21:50:57 +0800

$ git for-each-ref --sort=-taggerdate refs/tags \
                   --format='%(color:blue)%(committerdate:iso)%(color:reset)' \
                   --color=always
2021-08-30 21:50:57 +0800
```

#### condition

> [!TIP|label:references:]
> - `%(if)...%(then)...%(else)...%(end)`
> - `%(align:<number>,left) ... %(end)`

```bash
$ git for-each-ref --sort=-taggerdate refs/tags \
                   --format='%(if)%(committerdate)%(then)%(committerdate:format:%Y-%m-%d %I:%M %p)%(else)%(taggerdate:format:%Y-%m-%d %I:%M %p)%(end)'
2021-08-30 09:50 PM

$ git for-each-ref --sort=-taggerdate refs/tags \
                   --format='%(align:left,50)[%(objecttype) : %(refname:short)]%(end) (%(committerdate:format:%Y-%m-%d %H:%M)) <%(committername)>' \
                   --color \
                   --count=10
[commit : sandbox/marslo/tag-1]              (2021-08-30 21:50) <marslo>
```
