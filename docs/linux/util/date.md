<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [date](#date)
  - [epoch](#epoch)
  - [timestamps](#timestamps)
  - [utc](#utc)
  - [timezone](#timezone)
  - [Common formats](#common-formats)
- [convert](#convert)
  - [timestamps to epoch](#timestamps-to-epoch)
  - [epoch to timestamps](#epoch-to-timestamps)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## date

### epoch
> [https://en.wikipedia.org/wiki/Unix_time](https://en.wikipedia.org/wiki/Unix_time):
> - It is the number of seconds that have elapsed since the Unix epoch, minus leap seconds; the Unix epoch is 00:00:00 UTC on 1 January 1970
> [What is epoch time?](https://www.epochconverter.com/)

```bash
$ date -u -d '1970-01-01 00:00:00' '+Normal: %F %T %:z%nUnix: %s'
Normal: 1970-01-01 00:00:00 +00:00
Unix: 0

$ date -d '1970-01-01 00:00:00' '+Normal: %F %T %:z%nUnix: %s'
Normal: 1970-01-01 00:00:00 +08:00
Unix: -28800

$ date -u -d '1970-01-01 00:00:00 UTC +1 day' '+Normal: %F %T %:z%nUnix: %s'
Normal: 1970-01-02 00:00:00 +00:00
Unix: 86400
```

```bash
$ date '+%s%3N'
1602231334983

$ date '+%s'
1602231334
```

### timestamps
> `yyyy-MM-dd'T'HH:mm:ss.SSSZ`
>
> `yyyy-MM-dd'T'HH:mm:ss`

| Date Format Option | Meaning                                           |      Example Output     |
|:------------------:|:--------------------------------------------------|:-----------------------:|
|     `date +%c`     | locale’s date time                                | Sat May 9 11:49:47 2020 |
|     `date +%x`     | locale’s date                                     |         05/09/20        |
|     `date +%X`     | locale’s time                                     |         11:49:47        |
|     `date +%A`     | locale’s full weekday name                        |         Saturday        |
|     `date +%B`     | locale’s full month name                          |           May           |
|  `date +%m-%d-%Y`  | MM-DD-YYYY date format                            |        05-09-2020       |
|     `date +%D`     | MM/DD/YY date format                              |         05/09/20        |
|     `date +%F`     | YYYY-MM-DD date format                            |        2020-05-09       |
|     `date +%T`     | HH:MM:SS time format                              |         11:44:15        |
|     `date +%u`     | Day of Week                                       |            6            |
|     `date +%U`     | Week of Year with Sunday as first day of week     |            18           |
|     `date +%V`     | ISO Week of Year with Monday as first day of week |            19           |
|     `date +%j`     | Day of Year                                       |           130           |
|     `date +%Z`     | Timezone                                          |           PDT           |
|     `date +%m`     | Month of year (MM)                                |            05           |
|     `date +%d`     | Day of Month (DD)                                 |            09           |
|     `date +%Y`     | Year (YY)                                         |           2020          |
|     `date +%H`     | Hour (HH)                                         |            11           |
|     `date +%H`     | Hour (HH) in 24-hour clock format                 |            11           |
|     `date +%I`     | Hour in 12-hour clock format                      |            11           |
|     `date +%p`     | locale’s equivalent of AM or PM                   |            AM           |
|     `date +%P`     | same as %p but in lower case                      |            am           |


```bash
$ date -u +"%Y-%m-%dT%H:%M:%SZ"
2020-10-09T08:14:47Z

$ date +%FT%T.%3N%:z
2020-10-09T17:27:18.491+08:00

$ date -u +"%Y-%m-%dT%H:%M:%S.%3NZ"
2020-10-09T08:14:47.167Z

$ date +%Y-%m-%d-T%H:%M:%S.%3N%z
2020-10-09-T17:27:18.491+0800
```

#### time described by STRING
```bash
$ date -u +"%Y-%m-%dT%H:%M:%S.%3NZ" -d '90 day ago'
2020-07-11T08:14:03.145Z

$ date -u +"%Y-%m-%dT%H:%M:%S.%3NZ" -d '3 months ago'
2020-07-09T08:14:47.164Z

$ date -u -d "2019-01-19T05:00:00Z - 2 hours" +%Y-%m-%d_%H:%M:%S
2019-01-19_03:00:00

$ date -d "$(date -Iseconds -d "2018-12-10 00:00:00") - 5 hours - 20 minutes - 5 seconds"
Sun Dec  9 18:39:55 CST 2018

$ date -d "2018-12-10 00:00:00 5 hours ago 20 minutes ago 5 seconds ago"
Sun Dec  9 18:39:55 CST 2018
```

- details
  ```bash
  $ date -u -d "2019-01-19T05:00:00 - 2 hours" +%Y-%m-%d_%H:%M:%S%Z --debug
  date: parsed datetime part: (Y-M-D) 2019-01-19 05:00:00 UTC-02
  date: parsed relative part: +1 hour(s)
  date: input timezone: parsed date/time string (-02)
  date: using specified time as starting value: '05:00:00'
  date: starting date/time: '(Y-M-D) 2019-01-19 05:00:00 TZ=-02'
  date: '(Y-M-D) 2019-01-19 05:00:00 TZ=-02' = 1547881200 epoch-seconds
  date: after time adjustment (+1 hours, +0 minutes, +0 seconds, +0 ns),
  date:     new time = 1547884800 epoch-seconds
  date: timezone: Universal Time
  date: final: 1547884800.000000000 (epoch-seconds)
  date: final: (Y-M-D) 2019-01-19 08:00:00 (UTC)
  date: final: (Y-M-D) 2019-01-19 08:00:00 (UTC+00)
  2019-01-19_08:00:00UTC
  ```

### IOS 8601
> | dates                      | example                                                 |
> | :-:                        | :-                                                      |
> | YYYY                       | 2015                                                    |
> | YYYY-MM                    | 2015-12                                                 |
> | YYYY-MM-DD                 | 2015-12-11                                              |
> | YYYY-MM-DD'T'hh:mmTZD      | 2015-12-11T20:28+01:00 or 2015-12-11T19:28Z             |
> | YYYY-MM-DD'T'hh:mm:ssTZD   | 2015-12-11T20:28:30+01:00 or 2015-12-11T19:28:30Z       |
> | YYYY-MM-DD'T'hh:mm:ss.sTZD | 2015-12-11T20:28:30.45+01:00 or 2015-12-11T19:28:30.45Z |
>
> where:
> YYYY = four-digit year
> MM = two-digit month (01=January, etc.)
> DD = two-digit day of month (01 through 31)
> hh = two digits of hour (00 through 23) (am/pm NOT allowed)
> mm = two digits of minute (00 through 59)
> ss = two digits of second (00 through 59)
> s = one or more digits representing a decimal fraction of a second (i.e. milliseconds)
> TZD = time zone designator (Z or +hh:mm or -hh:mm)

```bash
$ date -I
2020-10-09

$ date -Is && date -Isecond
2020-10-09T16:31:47+08:00
2020-10-09T16:31:47+08:00

$ date -Ih
2020-10-09T16+08:00

$ date -Im
2020-10-09T16:31+08:00
```

### rfc-3339
```bash
$ date --rfc-3339=date
2020-10-09

$ date --rfc-3339=ns
2020-10-09 17:32:14.158684000+08:00

$ date --rfc-3339=seconds
2020-10-09 17:32:14+08:00
```

### utc
```bash
$ date
Fri Oct  9 17:09:34 CST 2020

$ date -u
Fri Oct  9 09:09:34 UTC 2020
```

### timezone
```bash
$ date '+%Z'
CST

$ date '+%z'
+0800

$ date '+%:z'
+08:00

$ date '+%::z'
+08:00:00

$ date '+%:::z'
+08

$ date '+%Z'
CST
```

### Common formats
> [Shell command: date](https://renenyffenegger.ch/notes/Linux/shell/commands/date)
> [Most common Bash date commands for timestamping](https://zxq9.com/archives/795)

| Format/result                     | Command                         | Output                            |
| :-------------------------------: | :-----------------------------: | : ------------------------------: |
| `YYYY-MM-DD`                      | `date -I`                       | 2020-10-09                        |
| `YYYY-MM-DD_hh:mm:ss`             | `date +%F_%T`                   | 2020-10-09_16:48:45               |
| `YYYYMMDD_hhmmss`                 | `date +%Y%m%d_%H%M%S`           | 20201009_164845                   |
| `YYYYMMDD_hhmmss (UTC version)`   | `date --utc +%Y%m%d_%H%M%SZ`    | 20201009_084845Z                  |
| `YYYYMMDD_hhmmss (with local TZ)` | `date +%Y%m%d_%H%M%S%Z`         | 20201009_164845CST                |
| `YYYYMMSShhmmss`                  | `date +%Y%m%d%H%M%S`            | 20201009164845                    |
| `YYYYMMSShhmmssnnnnnnnnn`         | `date +%Y%m%d%H%M%S%N`          | 20201009164845495302000           |
| `YYMMDD_hhmmss`                   | `date +%y%m%d_%H%M%S`           | 201009_164845                     |
| `Seconds since UNIX epoch:`       | `date +%s`                      | 1602233325                        |
| `Nanoseconds only:`               | `date +%N`                      | 505337000                         |
| `Nanoseconds since UNIX epoch:`   | `date +%s%N`                    | 1602233325508581000               |
| `Nanoseconds since UNIX epoch:`   | `date +%s%3N`                   | 1602233325508                     |
| `ISO8601 UTC timestamp`           | `date --utc +%FT%TZ`            | 2020-10-09T08:48:45Z              |
| `ISO8601 UTC timestamp`           | `date --utc +%FT%T%Z`           | 2020-10-09T08:48:45UTC            |
| `ISO8601 UTC timestamp + ms`      | `date --utc +%FT%T.%3NZ`        | 2020-10-09T08:48:45.517Z          |
| `ISO8601 UTC timestamp + ms`      | `date --utc +%FT%T.%3N%Z`       | 2020-10-09T08:48:45.520UTC        |
| `ISO8601 Local TZ timestamp`      | `date +%FT%T%Z`                 | 2020-10-09T16:48:45CST            |
| `YYYY-MM-DD (Short day)`          | `date +%F\(%a\)`                | 2020-10-09(Fri)                   |
| `YYYY-MM-DD (Long day)`           | `date +%F\(%A\)`                | 2020-10-09(Friday)                |

## convert
> ```bash
> $ date +"%Y-%m-%dT%H:%M:%SZ"
> 2020-10-09T17:16:37Z
>
> $ date -u +"%Y-%m-%dT%H:%M:%SZ"
> 2020-10-09T09:16:37Z
>
> $ date -d $(date -u +"%Y-%m-%dT%H:%M:%SZ")
> Fri Oct  9 17:16:37 CST 2020
> ```


|  Human-readable time |      Seconds     |
|:--------------------:|:----------------:|
|        1 hour        |   3600 seconds   |
|         1 day        |   86400 seconds  |
|        1 week        |  604800 seconds  |
| 1 month (30.44 days) |  2629743 seconds |
| 1 year (365.24 days) | 31556926 seconds |

### timestamps to epoch
```bash
$ echo $EPOCHSECONDS
1602235097

$ date -d $(date -u +"%Y-%m-%dT%H:%M:%SZ") +%s
1602235097

$ date --date=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ") +%s%3N
1602235097801
```

### epoch to timestamps
```bash
$ date -u +"%Y-%m-%dT%H:%M:%S.%3NZ"
2020-10-09T09:18:17.795Z

$ date -d @1602235097 +%c
Fri Oct  9 17:18:17 2020

$ date -d @1602235097
Fri Oct  9 17:18:17 CST 2020

$ date -d @1602235097 -u
Fri Oct  9 09:18:17 UTC 2020
```

- convert epoch with milliseconds
> [Convert unix timestamp to hh:mm:ss:SSS (where SSS is milliseconds)](https://unix.stackexchange.com/a/265956/29178)

  ```bash
  d=$(date +%s%3N)
  s=${d%???}
  ms=${d#"$s"}
  date -d "@$s" +"%F %T.$ms %z"
  ```
  result
  ```bash
  2020-10-09 18:28:34.534 +0800

  d: 1602239314534
  s: 1602239314
  ms: 534
  ```

### caculate time different
```bash
$ seconds=$(date +%s)
$ printf "%d days %(%H hours %M minutes %S seconds)T\n" $((seconds/86400)) $seconds
18544 days 18 hours 35 minutes 48 seconds
```

#### [Simple one-liner](https://stackoverflow.com/a/39452629/2940319)
```bash
$ secs=259200
$ printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
72h:0m:0s
```

- with leading zero
  ```bash
  $ printf '%02dh:%02dm:%02ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
  72h:00m:00s
  ```

- with days
  ```bash
  $ printf '%dd:%dh:%dm:%ds\n' $(($secs/86400)) $(($secs%86400/3600)) $(($secs%3600/60))   $(($secs%60))
  3d:0h:0m:0s
  ```

- with nanoseconds
  ```bash
  $ printf '%02dh:%02dm:%02fs\n' $(echo -e "$secs/3600\n$secs%3600/60\n$secs%60"| bc | xargs echo)
  72h:00m:0.000000s
  ```

#### `datediff` (`ddiff`)
```bash
$ datediff -f "%d days, %H hours, %M mins, %S secs" "$(date +'%Y-%m-%d %H:%M:%S')" "$(date +'%Y-%m-%d %H:%M:%S' -d '3 days ago')"
-3 days, 0 hours, 0 mins, 0 secs
```

#### calculate with epoch
```bash
$ awk -v t=$(( $(date -d $(date +"%Y-%m-%dT%H:%M:%SZ") +%s) - $(date -d $(date +"%Y-%m-%dT%H:%M:%SZ" -d '3 days ago') +%s) )) 'BEGIN{
  printf "%d:%02d:%06.3f\n", t/3600, (t/60)%60, t%60}'
72:00:00.000
```

### transfer date format
> ```bash
> $ date +'%Y%m%d%H%M%S'
> 20201009184852
> ```

```bash
$ d1=$(date +'%Y%m%d%H%M%S')
$ date --date "$(echo $d1 | sed -nr 's/(....)(..)(..)(..)(..)(..)/\1-\2-\3 \4:\5:\6/p')"
Fri Oct  9 18:48:52 CST 2020
```
