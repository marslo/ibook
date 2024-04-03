<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [timezone](#timezone)
  - [timezone setup](#timezone-setup)
  - [tzdata installation with noninteractive](#tzdata-installation-with-noninteractive)
- [date](#date)
  - [epoch](#epoch)
  - [timestamps](#timestamps)
  - [format](#format)
  - [IOS 8601](#ios-8601)
  - [rfc-3339](#rfc-3339)
  - [utc](#utc)
  - [timezone](#timezone-1)
  - [common formats](#common-formats)
- [convert](#convert)
  - [timestamps to epoch](#timestamps-to-epoch)
  - [epoch to timestamps](#epoch-to-timestamps)
  - [convert in different timezone](#convert-in-different-timezone)
  - [get daylight saving](#get-daylight-saving)
  - [how many days from timestamps](#how-many-days-from-timestamps)
  - [calculate time different](#calculate-time-different)
  - [transfer date format](#transfer-date-format)
- [chrony](#chrony)
  - [install](#install)
  - [conf](#conf)
  - [commands](#commands)
  - [`/usr/libexec/chrony-helper`](#usrlibexecchrony-helper)
  - [set local time with chrony](#set-local-time-with-chrony)
- [systemd-timesyncd](#systemd-timesyncd)
  - [install](#install-1)
  - [config](#config)
  - [commands](#commands-1)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [* imarslo: groovy time ](../../programming/groovy/time.html)
> - [https://en.wikipedia.org/wiki/Unix_time](https://en.wikipedia.org/wiki/Unix_time):
{% endhint %}

## timezone
### timezone setup
```bash
$ sudo dpkg-reconfigure tzdata
```

### tzdata installation with noninteractive

> [!NOTE|label:references:]
> - [apt-get install tzdata noninteractive](https://stackoverflow.com/a/44333806/2940319)

```bash
# in bash
$ DEBIAN_FRONTEND=noninteractive sudo apt-get install -y tzdata

# or
$ export DEBIAN_FRONTEND=noninteractive
$ sudo apt install -y tzdata

# or
$ echo 'tzdata tzdata/Areas select Europe'       | debconf-set-selections
$ echo 'tzdata tzdata/Zones/Europe select Paris' | debconf-set-selections
$ DEBIAN_FRONTEND="noninteractive" sudo apt install -y tzdata

# or
$ sudo ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
$ export DEBIAN_FRONTEND=noninteractive
$ sudo apt-get install -y tzdata
$ sudo dpkg-reconfigure --frontend noninteractive tzdata
```

- or

  > [!NOTE|label:references:]
  > - [Cingulata/Dockerfile.bfv](https://github.com/CEA-LIST/Cingulata/blob/157b4c66441e4e253e06a0abe1508976605100d8/Dockerfile.bfv#L12)

  ```
  $ sudo ln -snf /usr/share/zoneinfo/$(curl https://ipapi.co/timezone) /etc/localtime
  $ sudo apt install -y tzdata
  ```

- or in dockerfile
  ```dockerfile
  RUN apt-get update \
      && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
  ```

- or ENV in dockerfile

  > [!NOTE|label:references:]
  > - [setting it via ENV should be actively discouraged](https://github.com/moby/moby/issues/4032#issuecomment-34597177)

  ```dockerfile
  ENV DEBIAN_FRONTEND noninteractive
  RUN apt-get update \
      && apt-get install -y --no-install-recommends tzdata
  ```

- or `ARG` in dockerfile

  > [!NOTE|label:references:]
  > - [apt-get install tzdata noninteractive](https://stackoverflow.com/a/66327069/2940319)

  ```dockerfile
  from ubuntu:bionic
  ARG DEBIAN_FRONTEND=noninteractive
  RUN apt-get update && apt-get install -y tzdata
  RUN unlink /etc/localtime
  RUN ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
  ```

## date
### epoch

{% hint style='tip' %}
> references:
> - It is the number of seconds that have elapsed since the Unix epoch, minus leap seconds; the Unix epoch is 00:00:00 UTC on 1 January 1970
> - [What is epoch time?](https://www.epochconverter.com/)
{% endhint %}

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

$ date -d '2023-01-01' +%s; date -d '2023-01-01 - 1 year' +%s
1672560000
1641024000

# using now
$ date -d'now' +%s; date -d 'now - 1 day' +%s
1706952065
1706865665
```

```bash
$ date '+%s%3N'
1602231334983

$ date '+%s'
1602231334
```

### timestamps
### format

> [!TIP]
> - `yyyy-MM-dd'T'HH:mm:ss.SSSZ`
> - `yyyy-MM-dd'T'HH:mm:ss`

| DATE FORMAT OPTION | MEANING                                           |      EXAMPLE OUTPUT     |
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

- classical date format
  ```bash
  $ secs=259200

  $ date -u -d @${secs} +"%F"
  1970-01-04
  $ date -u -d @${secs} +"%T"
  00:00:00

  $ date -u -d @${secs} +"%F %T"
  1970-01-04 00:00:00

  $ date -u -d @${secs} -Is
  1970-01-04T00:00:00+00:00
  ```

- date format with timezone
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

> |           FORMAT           | EXAMPLE                                                 |
> |:--------------------------:|---------------------------------------------------------|
> |            YYYY            | 2015                                                    |
> |           YYYY-MM          | 2015-12                                                 |
> |         YYYY-MM-DD         | 2015-12-11                                              |
> |    YYYY-MM-DD'T'hh:mmTZD   | 2015-12-11T20:28+01:00 or 2015-12-11T19:28Z             |
> |  YYYY-MM-DD'T'hh:mm:ssTZD  | 2015-12-11T20:28:30+01:00 or 2015-12-11T19:28:30Z       |
> | YYYY-MM-DD'T'hh:mm:ss.sTZD | 2015-12-11T20:28:30.45+01:00 or 2015-12-11T19:28:30.45Z |
>
> ---
> where:
> - `YYYY` = four-digit year
> - `MM` = two-digit month (01=January, etc.)
> - `DD` = two-digit day of month (01 through 31)
> - `hh` = two digits of hour (00 through 23) (am/pm NOT allowed)
> - `mm` = two digits of minute (00 through 59)
> - `ss` = two digits of second (00 through 59)
> - `s` = one or more digits representing a decimal fraction of a second (i.e. milliseconds)
> - `TZD` = time zone designator (Z or +hh:mm or -hh:mm)

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

> [!NOTE|label:references:]
> - list all timezone:
>   ```bash
>   $ timedatectl list-timezones | more
>
>   # or
>   $ tree /usr/share/zoneinfo/
>   ```
> - [tzdb timezone descriptions](https://ftp.iana.org/tz/tzdb/zone.tab)

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

$ echo $TZ
Asia/Beijing

$ timedatectl
      Local time: Tue 2023-08-22 05:58:45 CST
  Universal time: Mon 2023-08-21 21:58:45 UTC
        RTC time: Mon 2023-08-21 21:53:46
       Time zone: Asia/Beijing (CST, +0800)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a

$ date -d "2024-03-11" +"%Z"
PDT
$ date -d "2024-03-10" +"%Z"
PST
```

### common formats

> [!NOTE|label:references:]
> [Shell command: date](https://renenyffenegger.ch/notes/Linux/shell/commands/date)
> [Most common Bash date commands for timestamping](https://zxq9.com/archives/795)

|           FORMAT/RESULT           | COMMAND                      | OUTPUT                     |
|:---------------------------------:|:-----------------------------|----------------------------|
|            `YYYY-MM-DD`           | `date -I`                    | 2020-10-09                 |
|       `YYYY-MM-DD_hh:mm:ss`       | `date +%F_%T`                | 2020-10-09_16:48:45        |
|         `YYYYMMDD_hhmmss`         | `date +%Y%m%d_%H%M%S`        | 20201009_164845            |
|  `YYYYMMDD_hhmmss (UTC version)`  | `date --utc +%Y%m%d_%H%M%SZ` | 20201009_084845Z           |
| `YYYYMMDD_hhmmss (with local TZ)` | `date +%Y%m%d_%H%M%S%Z`      | 20201009_164845CST         |
|          `YYYYMMSShhmmss`         | `date +%Y%m%d%H%M%S`         | 20201009164845             |
|     `YYYYMMSShhmmssnnnnnnnnn`     | `date +%Y%m%d%H%M%S%N`       | 20201009164845495302000    |
|          `YYMMDD_hhmmss`          | `date +%y%m%d_%H%M%S`        | 201009_164845              |
|    `Seconds since UNIX epoch:`    | `date +%s`                   | 1602233325                 |
|        `Nanoseconds only:`        | `date +%N`                   | 505337000                  |
|  `Nanoseconds since UNIX epoch:`  | `date +%s%N`                 | 1602233325508581000        |
|  `Nanoseconds since UNIX epoch:`  | `date +%s%3N`                | 1602233325508              |
|      `ISO8601 UTC timestamp`      | `date --utc +%FT%TZ`         | 2020-10-09T08:48:45Z       |
|      `ISO8601 UTC timestamp`      | `date --utc +%FT%T%Z`        | 2020-10-09T08:48:45UTC     |
|    `ISO8601 UTC timestamp + ms`   | `date --utc +%FT%T.%3NZ`     | 2020-10-09T08:48:45.517Z   |
|    `ISO8601 UTC timestamp + ms`   | `date --utc +%FT%T.%3N%Z`    | 2020-10-09T08:48:45.520UTC |
|    `ISO8601 Local TZ timestamp`   | `date +%FT%T%Z`              | 2020-10-09T16:48:45CST     |
|      `YYYY-MM-DD (Short day)`     | `date +%F\(%a\)`             | 2020-10-09(Fri)            |
|      `YYYY-MM-DD (Long day)`      | `date +%F\(%A\)`             | 2020-10-09(Friday)         |

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

|  HUMAN-READABLE TIME |      SECONDS     |
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

$ date -d '2023-01-01' +%s; date -d '2023-01-01 - 1 day' +%s
1672560000
1672473600

$ date -d '2023-01-01' +%s; date -d '2023-01-01 - 1 year' +%s
1672560000
1641024000

# using now
$ date -d'now' +%s; date -d 'now - 1 day' +%s
1706952065
1706865665
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

- epoch with 13 digits
  ```bash
  # wrong
  $ date -d @1718731558409 +%c
  Thu 08 Jun 56434 01:53:29 AM PDT

  # solution: epoch/1000
  $ date -d @$((1718731558409/1000)) +%c
  Tue 18 Jun 2024 10:25:58 AM PDT
  ```

- convert epoch with milliseconds

  > [Convert unix timestamp to hh:mm:ss:SSS (where SSS is milliseconds)](https://unix.stackexchange.com/a/265956/29178)

  ```bash
  d=$(date +%s%3N)
  s=${d%???}
  ms=${d#"$s"}
  date -d "@$s" +"%F %T.$ms %z"
  ```
  - result
    ```bash
    2020-10-09 18:28:34.534 +0800

    d: 1602239314534
    s: 1602239314
    ms: 534
    ```

### convert in different timezone

> [!NOTE|label:references:]
> - [CST to UTC conversion](https://www.unix.com/shell-programming-and-scripting/118163-cst-utc-conversion.html)
> - timezone can be found via:
>   ```bash
>   $ cat /usr/share/zoneinfo
>
>   # or
>   $ timedatectl list-timezones | more
>   ```

```bash
$ TZ="Asia/Shanghai" date -d @$(date -d "2023-01-01 00:00:00 GMT" +"%s")
Sun Jan  1 08:00:00 CST 2023

$ TZ="America/Los_Angeles" date -d @$(date -d "2023-01-01 00:00:00 GMT" +"%s")
Sat Dec 31 16:00:00 PST 2022
```

- [convert to another timezone](https://unix.stackexchange.com/a/617692/29178)
  ```bash
  $ date --date='TZ="GTM" 15:00 tomorrow'
  Tue Aug 22 08:00:00 PDT 2023

  $ echo $TZ
  America/Los_Angeles
  $ date --date='TZ="Asia/Shanghai" 16:00 tomorrow'
  Wed Aug 23 01:00:00 PDT 2023

  $ echo $TZ
  America/Los_Angeles
  $ TZ="Asia/Shanghai" date -d 'TZ="America/Los_Angeles" 0:00 tomorrow'
  Tue Aug 22 15:00:00 CST 2023
  ```

- [convert to different timezone with daylight saving](https://stackoverflow.com/a/72918271/2940319)
  ```bash
  $ getDateTime() { echo "$1 | "$( TZ="$1" date '+%Y-%m-%d-%H-%M-%S %Z %z' ); }

  $ getDateTime Asia/Hong_Kong
  Asia/Hong_Kong | 2024-03-01-13-08-02 HKT +0800

  $ getDateTime America/Los_Angeles
  America/Los_Angeles | 2024-02-29-21-08-08 PST -0800

  $ getDateTime America/New_York
  America/New_York | 2024-03-01-00-08-08 EST -0500

  $ getDateTime Pacific/Honolulu
  Pacific/Honolulu | 2024-02-29-19-08-08 HST -1000

  $ getDateTime Asia/Hong_Kong
  Asia/Hong_Kong | 2024-03-01-13-08-09 HKT +0800
  ```

### get daylight saving
```bash
$ date -d "2024-03-11" +%Z
PDT
$ date -d "2024-03-10" +%Z
PST

$ echo $(( ($(date -d "2024-03-10 UTC" +%s) - $(date -d "2024-03-10 PST" +%s))/(60*60) ))
-8
$ echo $(( ($(date -d "2024-03-11 UTC" +%s) - $(date -d "2024-03-11 PDT" +%s))/(60*60) ))
-7
```

- [another](https://stackoverflow.com/a/19902806/2940319)
  ```bash
  $ if perl -e 'exit ((localtime)[8])' ; then
      echo winter
    else
      echo summer
    fi
  ```


### how many days from timestamps

> [!NOTE|label:references:]
> - [How to find the difference in days between two dates?](https://stackoverflow.com/a/6948865/2940319)

```bash
$ echo $(( ($(date --date="230301" +%s) - $(date --date="240301" +%s) )/(60*60*24) )) days
-366 days

# with timezone
#                PST/PDT according to daylight saving
#                                  v
$ echo $(( ($(date -d "2024-03-01 PST" +%s) - $(date -d "2023-03-01 UTC" +%s)) / (60*60*24) ))
366
```

### calculate time different
```bash
$ date -d 'now + 3 weeks'
Fri Oct 30 20:32:04 CST 2020

$ date -d 'now + 3 weeks' +%s
1604061130

$ date -d 'Jan 1 + 11 weeks'
Wed Mar 18 00:00:00 CST 2020

$ date -d 'Jan 1 2021 + 11 weeks'
Fri Mar 19 00:00:00 CST 2021
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

$ date -d '2023-01-01 - 1 year' +"%Y-%m-%d %H:%M:%S"
2022-01-01 00:00:00
```

#### two times different
```bash
$ seconds=$(date +%s)
$ printf "%d days %(%H hours %M minutes %S seconds)T\n" $((seconds/86400)) $seconds
18544 days 18 hours 35 minutes 48 seconds
```

#### [simple one-liner](https://stackoverflow.com/a/39452629/2940319)
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

- or with specific format
  ```bash
  $ ddiff -i '%Y%m%d%H%M%S' 20190817040001 20200312000101
  17956860s

  $ ddiff -f "%d days, %H hours, %M mins, %S secs" -i '%Y%m%d%H%M%S' 20190817040001 20200312000101
  207 days, 20 hours, 1 mins, 0 secs
  ```

#### calculate with epoch
```bash
$ awk -v t=$(( $(date -d $(date +"%Y-%m-%dT%H:%M:%SZ") +%s) - $(date -d $(date +"%Y-%m-%dT%H:%M:%SZ" -d '3 days ago') +%s) )) 'BEGIN{
  printf "%d:%02d:%06.3f\n", t/3600, (t/60)%60, t%60}'
72:00:00.000
```

### transfer date format

> [!TIP]
> ```bash
> $ date +'%Y%m%d%H%M%S'
> 20201009184852
> ```

```bash
$ d1=$(date +'%Y%m%d%H%M%S')
$ date --date "$(echo $d1 | sed -nr 's/(....)(..)(..)(..)(..)(..)/\1-\2-\3 \4:\5:\6/p')"
Fri Oct  9 18:48:52 CST 2020
```

## chrony

### install
- from package management
  ```bash
  # centos/rhel
  $ sudo yum install -y chrony
  ```
- from source

  > [!NOTE]
  > - [asciidoctor 2.0.22](https://rubygems.org/gems/asciidoctor)
  > - [asciidoctor](https://docs.asciidoctor.org/asciidoctor/latest/install/) is required to build docs
  >   ```bash
  >   $ gem install asciidoctor
  >   ```

  ```bash
  $ mkdir -p /opt/chrony
  $ git clone https://gitlab.com/chrony/chrony.git /opt/chrony && cd $_
  $ ./configure --prefix=/usr/local --mandir=/usr/share/man
  $ make && make docs
  $ sudo make install && sudo make install docs
  ```

### conf

> [!NOTE|label:references:]
> - [chrony配置](https://www.cnblogs.com/mountain2011/p/9151667.html)
> - [时钟同步](https://www.kancloud.cn/pshizhsysu/linux/2008045)
> - [CentOS使用Chrony部署内网NTP时间服务器](https://www.osyunwei.com/archives/12126.html)
> - [Chrony详解：代替ntp的时间同步服务](https://chegva.com/3265.html)
> - [Systemd and ntpd problems](https://forums.centos.org/viewtopic.php?t=53335#p226237)
> - [ntp pool project](https://www.ntppool.org/en/) | [授时中心](https://www.cnblogs.com/xzongblogs/p/14658895.html#%E4%BA%94%E6%8E%88%E6%97%B6%E4%B8%AD%E5%BF%83)
>   - [North America — north-america.pool.ntp.org](https://www.ntppool.org/zone/north-america)
>   - `210.72.145.44` 国家授时中心
>   - `ntp.aliyun.com` 阿里云
>   - `s1a.time.edu.cn` 北京邮电大学
>   - `s1b.time.edu.cn` 清华大学
>   - `s1c.time.edu.cn` 北京大学
>   - `s1d.time.edu.cn` 东南大学
>   - `s1e.time.edu.cn` 清华大学
>   - `s2a.time.edu.cn` 清华大学
>   - `s2b.time.edu.cn` 清华大学
>   - `s2c.time.edu.cn` 北京邮电大学
>   - `s2d.time.edu.cn` 西南地区网络中心
>   - `s2e.time.edu.cn` 西北地区网络中心
>   - `s2f.time.edu.cn` 东北地区网络中心
>   - `s2g.time.edu.cn` 华东南地区网络中心
>   - `s2h.time.edu.cn` 四川大学网络管理中心
>   - `s2j.time.edu.cn` 大连理工大学网络中心
>   - `s2k.time.edu.cn` CERNET桂林主节点
>   - `s2m.time.edu.cn` 北京大学
>   - `ntp.sjtu.edu.cn` | `202.120.2.101` 上海交通大学
> - [How to configure chrony as an NTP client or server in Linux](https://www.redhat.com/sysadmin/chrony-time-services-linux)
> - [Red Hat Training: Chapter 18. Configuring NTP Using the chrony Suite](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-configuring_ntp_using_the_chrony_suite)
> - [How to Sync Time in CentOS 8 using Chrony](https://wiki.crowncloud.net/?How_to_Sync_Time_in_CentOS_8_using_Chrony)

- `/etc/chrony.conf`
  ```bash
  # default
  $ cat /etc/chrony.conf | sed -r '/^(#.*)$/d' | sed -r '/^\s*$/d'
  pool 2.centos.pool.ntp.org iburst
  driftfile /var/lib/chrony/drift
  makestep 1.0 3
  rtcsync
  keyfile /etc/chrony.keys
  leapsectz right/UTC
  logdir /var/log/chrony

  # modified
  $ cat /etc/chrony.conf | sed -r '/^(#.*)$/d' | sed -r '/^\s*$/d'
  pool 2.rhel.pool.ntp.org iburst
  driftfile /var/lib/chrony/drift
  makestep 1.0 3
  stratumweight 0
  rtcsync
  hwtimestamp *
  allow 0.0.0.0/0
  bindcmdaddress 127.0.0.1
  bindcmdaddress ::1
  local stratum 10
  keyfile /etc/chrony.keys
  leapsectz right/UTC
  logdir /var/log/chrony
  generatecommandkey
  maxdistance 600.0
  ```

- `/usr/lib/systemd/system/chronyd.service`
  ```bash
  $ cat /usr/lib/systemd/system/chronyd.service
  [Unit]
  Description=NTP client/server
  Documentation=man:chronyd(8) man:chrony.conf(5)
  After=ntpdate.service sntp.service ntpd.service
  Conflicts=ntpd.service systemd-timesyncd.service
  ConditionCapability=CAP_SYS_TIME

  [Service]
  Type=forking
  PIDFile=/run/chrony/chronyd.pid
  EnvironmentFile=-/etc/sysconfig/chronyd
  ExecStart=/usr/sbin/chronyd $OPTIONS
  ExecStartPost=/usr/libexec/chrony-helper update-daemon
  PrivateTmp=yes
  ProtectHome=yes
  ProtectSystem=full

  [Install]
  WantedBy=multi-user.target
  ```

### commands

- services
  ```bash
  $ sudo systemctl enable chronyd.service
  Created symlink /etc/systemd/system/multi-user.target.wants/chronyd.service → /usr/lib/systemd/system/chronyd.service.

  $ sudo systemctl is-active chronyd.service
  active

  $ sudo systemctl is-enabled chronyd.service
  enabled
  ```

- server
  ```bash
  $ sudo chronyd -q 'server 0.north-america.pool.ntp.org iburst'
  2024-04-02T23:51:52Z chronyd version 3.5 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +SIGND +ASYNCDNS +SECHASH +IPV6 +DEBUG)
  2024-04-02T23:51:52Z Initial frequency -19.492 ppm
  2024-04-02T23:51:57Z System clock wrong by 0.003261 seconds (step)
  2024-04-02T23:51:57Z chronyd exiting
  ```

- `chronyc`
  ```bash
  $ chronyc sources -v
  210 Number of sources = 4

    .-- Source mode  '^' = server, '=' = peer, '#' = local clock.
   / .- Source state '*' = current synced, '+' = combined , '-' = not combined,
  | /   '?' = unreachable, 'x' = time may be in error, '~' = time too variable.
  ||                                                 .- xxxx [ yyyy ] +/- zzzz
  ||      Reachability register (octal) -.           |  xxxx = adjusted offset,
  ||      Log2(Polling interval) --.      |          |  yyyy = measured offset,
  ||                                \     |          |  zzzz = estimated error.
  ||                                 |    |           \
  MS Name/IP address         Stratum Poll Reach LastRx Last sample
  ===============================================================================
  ^- 212.227.240.160               3   8   377   103  -5334us[-5080us] +/-  101ms
  ^? ntp1.glypnod.com              2   6     3    37   -869us[ -609us] +/-   14ms
  ^* LAX.CALTICK.NET               2   7   377    36   -408us[ -147us] +/-   12ms
  ^- 131.153.171.22                2   8   377   101  -5931us[-5677us] +/-   60ms

  $ chronyc sourcestats -v
  210 Number of sources = 4
                               .- Number of sample points in measurement set.
                              /    .- Number of residual runs with same sign.
                             |    /    .- Length of measurement set (time).
                             |   |    /      .- Est. clock freq error (ppm).
                             |   |   |      /           .- Est. error in freq.
                             |   |   |     |           /         .- Est. offset.
                             |   |   |     |          |          |   On the -.
                             |   |   |     |          |          |   samples. \
                             |   |   |     |          |          |             |
  Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
  ==============================================================================
  212.227.240.160            25  17   31m     +0.029      0.853   -560us   586us
  ntp1.glypnod.com            2   0    64     -0.104   2000.000   -869us  4000ms
  LAX.CALTICK.NET            12   4  1099     +0.014      2.198   +654ns   614us
  131.153.171.22             25  14   31m     -0.834      2.524  -4084us  1801us

  $ chronyc tracking
  Reference ID    : 2D3F360D (LAX.CALTICK.NET)
  Stratum         : 3
  Ref time (UTC)  : Tue Apr 02 22:53:49 2024
  System time     : 0.000157978 seconds fast of NTP time
  Last offset     : +0.000261040 seconds
  RMS offset      : 0.001216694 seconds
  Frequency       : 19.554 ppm slow
  Residual freq   : +0.014 ppm
  Skew            : 2.387 ppm
  Root delay      : 0.024124343 seconds
  Root dispersion : 0.000968660 seconds
  Update interval : 128.2 seconds
  Leap status     : Normal

  $ sudo chronyc clients
  Hostname                      NTP   Drop Int IntL Last     Cmd   Drop Int  Last
  ===============================================================================
  localhost                       0      0   -   -     -      13      0   4     1
  ```

### `/usr/libexec/chrony-helper`

<!--sec data-title="/usr/libexec/chrony-helper" data-id="section0" data-show=true data-collapse=true ces-->
```bash
$ cat /usr/libexec/chrony-helper
#!/bin/bash
# This script configures running chronyd to use NTP servers obtained from
# DHCP and _ntp._udp DNS SRV records. Files with servers from DHCP are managed
# externally (e.g. by a dhclient script). Files with servers from DNS SRV
# records are updated here using the dig utility. The script can also list
# and set static sources in the chronyd configuration file.

chronyc=/usr/bin/chronyc
chrony_conf=/etc/chrony.conf
chrony_service=chronyd.service
helper_dir=/var/run/chrony-helper
added_servers_file=$helper_dir/added_servers

network_sysconfig_file=/etc/sysconfig/network
dhclient_servers_files="/var/lib/dhclient/chrony.servers.*"
dnssrv_servers_files="$helper_dir/dnssrv@*"
dnssrv_timer_prefix=chrony-dnssrv@

. $network_sysconfig_file &> /dev/null

chrony_command() {
    $chronyc -a -n -m "$1"
}

is_running() {
    chrony_command "tracking" &> /dev/null
}

get_servers_files() {
    [ "$PEERNTP" != "no" ] && echo "$dhclient_servers_files"
    echo "$dnssrv_servers_files"
}

is_update_needed() {
    for file in $(get_servers_files) $added_servers_file; do
        [ -e "$file" ] && return 0
    done
    return 1
}

update_daemon() {
    local all_servers_with_args all_servers added_servers

    if ! is_running; then
        rm -f $added_servers_file
        return 0
    fi

    all_servers_with_args=$(cat $(get_servers_files) 2> /dev/null)

    all_servers=$(
        echo "$all_servers_with_args" |
            while read -r server serverargs; do
                echo "$server"
            done | sort -u)
    added_servers=$( (
        cat $added_servers_file 2> /dev/null
        echo "$all_servers_with_args" |
            while read -r server serverargs; do
                [ -z "$server" ] && continue
                chrony_command "add server $server $serverargs" &> /dev/null &&
                    echo "$server"
            done) | sort -u)

    comm -23 <(echo -n "$added_servers") <(echo -n "$all_servers") |
        while read -r server; do
            chrony_command "delete $server" &> /dev/null
        done

    added_servers=$(comm -12 <(echo -n "$added_servers") <(echo -n "$all_servers"))

    if [ -n "$added_servers" ]; then
        echo "$added_servers" > $added_servers_file
    else
        rm -f $added_servers_file
    fi
}

get_dnssrv_servers() {
    local name=$1 output

    if ! command -v dig &> /dev/null; then
        echo "Missing dig (DNS lookup utility)" >&2
        return 1
    fi

    output=$(dig "$name" srv +short +ndots=2 +search 2> /dev/null) || return 0

    echo "$output" | while read -r _ _ port target; do
        server=${target%.}
        [ -z "$server" ] && continue
        echo "$server port $port ${NTPSERVERARGS:-iburst}"
    done
}

check_dnssrv_name() {
    local name=$1

    if [ -z "$name" ]; then
        echo "No DNS SRV name specified" >&2
        return 1
    fi

    if [ "${name:0:9}" != _ntp._udp ]; then
        echo "DNS SRV name $name doesn't start with _ntp._udp" >&2
        return 1
    fi
}

update_dnssrv_servers() {
    local name=$1
    local srv_file=$helper_dir/dnssrv@$name servers

    check_dnssrv_name "$name" || return 1

    servers=$(get_dnssrv_servers "$name")
    if [ -n "$servers" ]; then
        echo "$servers" > "$srv_file"
    else
        rm -f "$srv_file"
    fi
}

set_dnssrv_timer() {
    local state=$1 name=$2
    local srv_file=$helper_dir/dnssrv@$name servers
    local timer

    timer=$dnssrv_timer_prefix$(systemd-escape "$name").timer || return 1

    check_dnssrv_name "$name" || return 1

    if [ "$state" = enable ]; then
        systemctl enable "$timer"
        systemctl start "$timer"
    elif [ "$state" = disable ]; then
        systemctl stop "$timer"
        systemctl disable "$timer"
        rm -f "$srv_file"
    fi
}

list_dnssrv_timers() {
    systemctl --all --full -t timer list-units | grep "^$dnssrv_timer_prefix" | \
            sed "s|^$dnssrv_timer_prefix\(.*\)\.timer.*|\1|" |
        while read -r name; do
            systemd-escape --unescape "$name"
        done
}

prepare_helper_dir() {
    mkdir -p $helper_dir
    exec 100> $helper_dir/lock
    if ! flock -w 20 100; then
        echo "Failed to lock $helper_dir" >&2
        return 1
    fi
}

is_source_line() {
    local pattern="^[ \t]*(server|pool|peer|refclock)[ \t]+[^ \t]+"
    [[ "$1" =~ $pattern ]]
}

list_static_sources() {
    while read -r line; do
        if is_source_line "$line"; then
            echo "$line"
        fi
    done < $chrony_conf
}

set_static_sources() {
    local new_config tmp_conf

    new_config=$(
        sources=$(
            while read -r line; do
                is_source_line "$line" && echo "$line"
            done)

        while read -r line; do
            if ! is_source_line "$line"; then
                echo "$line"
                continue
            fi

            tmp_sources=$(
                local removed=0

                echo "$sources" | while read -r line2; do
                    if [ "$removed" -ne 0 ] || [ "$line" != "$line2" ]; then
                        echo "$line2"
                    else
                        removed=1
                    fi
                done)

            [ "$sources" == "$tmp_sources" ] && continue
            sources=$tmp_sources
            echo "$line"
        done < $chrony_conf

        echo "$sources"
    )

    tmp_conf=${chrony_conf}.tmp

    cp -a $chrony_conf $tmp_conf &&
        echo "$new_config" > $tmp_conf &&
        mv $tmp_conf $chrony_conf || return 1

    systemctl try-restart $chrony_service
}

print_help() {
    echo "Usage: $0 COMMAND"
    echo
    echo "Commands:"
    echo "  update-daemon"
    echo "  update-dnssrv-servers NAME"
    echo "  enable-dnssrv NAME"
    echo "  disable-dnssrv NAME"
    echo "  list-dnssrv"
    echo "  list-static-sources"
    echo "  set-static-sources < sources.list"
    echo "  is-running"
    echo "  command CHRONYC-COMMAND"
}

case "$1" in
    update-daemon|add-dhclient-servers|remove-dhclient-servers)
        is_update_needed || exit 0
        prepare_helper_dir && update_daemon
        ;;
    update-dnssrv-servers)
        prepare_helper_dir && update_dnssrv_servers "$2" && update_daemon
        ;;
    enable-dnssrv)
        set_dnssrv_timer enable "$2"
        ;;
    disable-dnssrv)
        set_dnssrv_timer disable "$2" && prepare_helper_dir && update_daemon
        ;;
    list-dnssrv)
        list_dnssrv_timers
        ;;
    list-static-sources)
        list_static_sources
        ;;
    set-static-sources)
        set_static_sources
        ;;
    is-running)
        is_running
        ;;
    command|forced-command)
        chrony_command "$2"
        ;;
    *)
        print_help
        exit 2
esac

exit $?
```
<!--endsec-->

### set local time with chrony

> [!NOTE|label:references:]
> - [chrony 详解](https://www.cnblogs.com/xzongblogs/p/14658895.html)

```bash
$ sudo timedatectl set-time "2020-02-23 12:23:01"                # <<========设置系统时间，因为开启了时间同步所以报错
Failed to set time: Automatic time synchronization is enabled
$ sudo systemctl stop chronyd
$ sudo timedatectl set-time "2020-02-23 12:23:01"                # <<==========stop chronyd 后修改系统时间，报错依旧
Failed to set time: Automatic time synchronization is enabled
$ sudo systemctl status chronyd
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: inactive (dead) since 四 2021-04-15 15:45:37 CST; 21s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 13722 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0/SUCCESS)
  Process: 13716 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 13720 (code=exited, status=0/SUCCESS)
 ...

$ date
2021年 04月 15日 星期四 15:46:13 CST

$ sudo timedatectl set-ntp false
$ sudo timedatectl set-time "2020-02-23 12:23:01"
$ sudo systemctl status chronyd
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:chronyd(8)
           man:chrony.conf(5)
           ...

$ sudo timedatectl status      　　　　                      # <<============ 显示当前系统和RTC设置
      Local time: 日 2020-02-23 12:23:39 CST
  Universal time: 日 2020-02-23 04:23:39 UTC
        RTC time: 日 2020-02-23 04:23:39
       Time zone: Asia/Shanghai (CST, +0800)
     NTP enabled: no
NTP synchronized: no
 RTC in local TZ: no
      DST active: n/a
$ sudo timedatectl set-ntp true
$ sudo timedatectl status
      Local time: 日 2020-02-23 12:24:14 CST
  Universal time: 日 2020-02-23 04:24:14 UTC
        RTC time: 日 2020-02-23 04:24:14
       Time zone: Asia/Shanghai (CST, +0800)
     NTP enabled: yes
NTP synchronized: no
 RTC in local TZ: no
      DST active: n/a
$ sudo systemctl start chronyd

$ sudo timedatectl status
      Local time: 四 2021-04-15 15:48:52 CST
  Universal time: 四 2021-04-15 07:48:52 UTC
        RTC time: 日 2020-02-23 04:24:44
       Time zone: Asia/Shanghai (CST, +0800)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a
$ sudo timedatectl set-time "2020-02-23 12:23:01"
Failed to set time: Automatic time synchronization is enabled

$ sudo timedatectl set-ntp false      　　　　               # <<============= 禁用基于NTP的网络时间同步
$ sudo systemctl status chronyd
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:chronyd(8)
           man:chrony.conf(5)
           ...

$ sudo timedatectl set-time "2020-02-23 12:23:01"　　　　　　# <<=========== 再次设置时间成功
$ sudo timedatectl set-ntp true  　　　　                    # <<============ 启用基于NTP的网络时间同步

$ sudo systemctl status chronyd
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since 日 2020-02-23 12:23:25 CST; 4s ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 16110 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0/SUCCESS)
  Process: 16103 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 16105 (chronyd)
    Tasks: 1
   CGroup: /system.slice/chronyd.service
           └─16105 /usr/sbin/chronyd
           ...

$ date
2021年 04月 15日 星期四 15:52:14 CST
```

## systemd-timesyncd

> [!NOTE]
> - issue in `chrony` with timedatactl
>   ```bash
>   $ timedatectl
>                  Local time: Tue 2024-04-02 16:11:02 PDT
>              Universal time: Tue 2024-04-02 23:11:02 UTC
>                    RTC time: Tue 2024-04-02 23:11:02
>                   Time zone: America/Los_Angeles (PDT, -0700)
>   System clock synchronized: yes
>                 NTP service: n/a
>             RTC in local TZ: no
>
>   $ sudo timedatectl set-ntp on
>   Failed to set ntp: NTP not supported
>   ```
> - [systemd-timesyncd](https://wiki.archlinux.org/title/systemd-timesyncd#)

### install

> [!NOTE|label:references:]
> - [* iMarslo: epel install](../apt-yum.html#tools-installation)

```bash
# centos 8
$ sudo dnf reinstall https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
$ sudo yum install -y systemd-timesyncd
```

- enable and start services
  ```bash
  $ sudo systemctl enable systemd-timesyncd.service
  Created symlink /etc/systemd/system/dbus-org.freedesktop.timesync1.service → /usr/lib/systemd/system/systemd-timesyncd.service.
  Created symlink /etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service → /usr/lib/systemd/system/systemd-timesyncd.service.

  $ sudo systemctl start systemd-timesyncd.service

  $ sudo systemctl is-active systemd-timesyncd.service
  active
  $ sudo systemctl is-enabled systemd-timesyncd.service
  enabled
  ```

### config

> [!NOTE]
> - [NTP Pool Project](https://www.ntppool.org/zone/north-america)
> - [timesyncd.conf](https://man.archlinux.org/man/timesyncd.conf.5)
> - [systemd-timesyncd.service](https://man.archlinux.org/man/systemd-timesyncd.8)

```bash
$ cat /etc/systemd/timesyncd.conf | sed -r '/^(#.*)$/d' | sed -r '/^\s*$/d'
[Time]
NTP=0.north-america.pool.ntp.org 1.north-america.pool.ntp.org 2.north-america.pool.ntp.org 3.north-america.pool.ntp.org
FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org

# or
$ sudo systemd-analyze cat-config systemd/timesyncd.conf | sed -r '/^(#.*)$/d' | sed -r '/^\s*$/d'
[Time]
NTP=0.north-america.pool.ntp.org 1.north-america.pool.ntp.org 2.north-america.pool.ntp.org 3.north-america.pool.ntp.org
FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org
```

### commands

- `show-timesync`
  ```bash
  $ timedatectl show-timesync --all
  LinkNTPServers=
  SystemNTPServers=0.north-america.pool.ntp.org 1.north-america.pool.ntp.org 2.north-america.pool.ntp.org 3.north-america.pool.ntp.org
  RuntimeNTPServers=
  FallbackNTPServers=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org
  ServerName=0.north-america.pool.ntp.org
  ServerAddress=104.131.155.175
  RootDistanceMaxUSec=5s
  PollIntervalMinUSec=32s
  PollIntervalMaxUSec=34min 8s
  PollIntervalUSec=1min 4s
  NTPMessage={ Leap=0, Version=4, Mode=4, Stratum=2, Precision=-30, RootDelay=3.097ms, RootDispersion=6.774ms, Reference=408E7A25, OriginateTimestamp=Tue 2024-04-02 16:59:33 PDT, ReceiveTimestamp=Tue 2024-04-02 16:59:33 PDT, TransmitTimestamp=Tue 2024-04-02 16:59:33 PDT, DestinationTimestamp=Tue 2024-04-02 16:59:33 PDT, Ignored=no PacketCount=1, Jitter=0 }
  Frequency=1375360
  ```

- `timesync-status`
  ```bash
  $ timedatectl timesync-status
         Server: 104.131.155.175 (0.north-america.pool.ntp.org)
  Poll interval: 1min 4s (min: 32s; max 34min 8s)
           Leap: normal
        Version: 4
        Stratum: 2
      Reference: 408E7A25
      Precision: 0 (-30)
  Root distance: 8.322ms (max: 5s)
         Offset: +4.077ms
          Delay: 24.042ms
         Jitter: 0
   Packet count: 1
      Frequency: +20.986ppm
  ```

- check log
  ```bash
  $ journalctl -u systemd-timesyncd --no-hostname --since "1 day ago"
  ```
