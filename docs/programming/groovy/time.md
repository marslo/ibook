<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get time](#get-time)
  - [current timestamp](#current-timestamp)
  - [data parse](#data-parse)
  - [get available timezone](#get-available-timezone)
  - [get current time (timeInMillis)](#get-current-time-timeinmillis)
- [LocalDateTime](#localdatetime)
  - [current LocalDataTime](#current-localdatatime)
  - [particular localDateTime](#particular-localdatetime)
  - [get detail info from localDateTime](#get-detail-info-from-localdatetime)
  - [additional plus or minus for localDateTime](#additional-plus-or-minus-for-localdatetime)
  - [isBefore(), isAfter() and isEqual()](#isbefore-isafter-and-isequal)
- [convert time](#convert-time)
  - [convert the Date to simpleDateFormat or timeInMillis](#convert-the-date-to-simpledateformat-or-timeinmillis)
    - [current time](#current-time)
    - [particular time](#particular-time)
  - [convert `Long` to `SimpleDateFormat`](#convert-long-to-simpledateformat)
  - [convert timeInMillis (`Long`) to `Date`](#convert-timeinmillis-long-to-date)
  - [convert `String` to `Date`](#convert-string-to-date)
  - [convert `Date` to timeInMillis (`Long`)](#convert-date-to-timeinmillis-long)
- [formatting date](#formatting-date)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [Java Date Time Tutorial](https://jenkov.com/tutorials/java-date-time/index.html)
> - [Java System.currentTimeMillis()](https://jenkov.com/tutorials/java-date-time/system-currenttimemillis.html)
> - [Java Time Measurement](https://jenkov.com/tutorials/java-date-time/time-measurement.html)
> - [Java's java.util.Date](https://jenkov.com/tutorials/java-date-time/java-util-date.html)
> - [Java's java.sql.Date](https://jenkov.com/tutorials/java-date-time/java-sql-date.html)
> - [Java's java.util.Calendar and GregorianCalendar](https://jenkov.com/tutorials/java-date-time/java-util-calendar.html)
> - [Java's java.util.TimeZone](https://jenkov.com/tutorials/java-date-time/java-util-timezone.html)
> - [Parsing and Formatting Dates in Java](https://jenkov.com/tutorials/java-date-time/parsing-formatting-dates.html)
> - [Java LocalDate](https://jenkov.com/tutorials/java-date-time/localdate.html)
> - [Java LocalTime](https://jenkov.com/tutorials/java-date-time/localtime.html)
> - [Java LocalDateTime](https://jenkov.com/tutorials/java-date-time/localdatetime.html)
> - [Java ZonedDateTime](https://jenkov.com/tutorials/java-date-time/zoneddatetime.html)
> - [Java DateTimeFormatter](https://jenkov.com/tutorials/java-date-time/datetimeformatter.html)
{% endhint %}


# get time

> [!TIP]
> references:
> - [Java SimpleDateFormat](https://jenkov.com/tutorials/java-internationalization/simpledateformat.html)
> - [Class SimpleDateFormat](https://docs.oracle.com/javase/8/docs/api/java/text/SimpleDateFormat.html)
> - [Class Date](https://docs.groovy-lang.org/latest/html/groovy-jdk/java/util/Date.html)
> - [Class TimeZone](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/util/TimeZone.html)
> - [Class SimpleDateFormat](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/text/SimpleDateFormat.html)
> - [Class DateFormat](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/text/DateFormat.html)
>
> usage in jenkins
> - [* imarslo: get build time](../../jenkins/script/build.html#get-build-time)
> - [* imarslo: linux date](../../linux/util/date.html)

## current timestamp
```groovy
// 20220706171701
new Date().format( 'YYYYMMddHHmmss' )

// Tuesday 02 August 2022 20:33:11.967 +0800
new Date().format( 'EEEEE dd MMMMM yyyy HH:mm:ss.SSS Z' )

// Tuesday 02 August 2022 20:35:21.565 +0800, 214 days, week 32
new Date().format( 'EEEEE dd MMMMM yyyy HH:mm:ss.SSS Z, DD' ) + ' days, week ' + new Date().format( 'w' )
```

## data parse
```groovy
String oldFormat = '04-DEC-2012'
Date date = Date.parse( 'dd-MMM-yyyy', oldFormat )
assert date.format( 'M-d-yyyy' ) == '12-4-2012'

// or
Date date = Date.parse( 'HH:mm:ss dd-MMM-yyyy, Z', '00:00:00 04-DEC-2022, -0800')
// Sunday 04 12-4-2022 00:00:00, PST
date.format( 'EEEEE dd M-d-yyyy HH:mm:ss, z', timezone=TimeZone.getTimeZone('PST') )
// Sunday 04 12-4-2022 03:00:00, EST
date.format( 'EEEEE dd M-d-yyyy HH:mm:ss, z', timezone=TimeZone.getTimeZone('EST') )
// Sunday 04 12-4-2022 08:00:00, UTC
date.format( 'EEEEE dd M-d-yyyy HH:mm:ss, z', timezone=TimeZone.getTimeZone('UTC') )
// Sunday 04 12-4-2022 16:00:00, +0800
date.format( 'EEEEE dd M-d-yyyy HH:mm:ss, Z', timezone=TimeZone.getTimeZone('Asia/Shanghai') )
// Sunday 04 12-4-2022 16:00:00, CST
date.format( 'EEEEE dd M-d-yyyy HH:mm:ss, z', timezone=TimeZone.getTimeZone('Asia/Shanghai') )

// oneline parse
// Sun Dec 11 00:00:00 CST 2011
Date.parse('yyyy-MM-dd hh:MM:SS', '2012-12-11 00:00:00').format('E MMM dd HH:mm:ss z yyyy')
```

## get available timezone

> [!TIP]
> - [Java's java.util.TimeZone](https://jenkov.com/tutorials/java-date-time/java-util-timezone.html)

```groovy
java.util.TimeZone.getAvailableIDs()

// or
java.util.TimeZone.getAvailableIDs().collect { it }

println java.util.TimeZone.getDefault().getDisplayName();
println java.util.TimeZone.getDefault().getID();
println java.util.TimeZone.getDefault().getOffset( System.currentTimeMillis() )
-- result --
Pacific Standard Time
America/Los_Angeles
-28800000
```

## get current time (timeInMillis)
```groovy
import java.util.Calendar
import java.time.LocalDateTime
import java.time.LocalDate

long curerntTime       = System.currentTimeMillis()
long newDateTime       = new Date().getTime()
long calendarTime      = Calendar.getInstance().getTimeInMillis()

LocalDate dateTag      = java.time.LocalDate.now()
LocalDateTime dateTime = LocalDateTime.now()

println """
   curerntTime : ${curerntTime.toString().padRight(30)} : ${curerntTime.getClass()}
   newDateTime : ${newDateTime.toString().padRight(30)} : ${newDateTime.getClass()}
  calendarTime : ${calendarTime.toString().padRight(30)} : ${calendarTime.getClass()}

       dateTag : ${dateTag.toString().padRight(30)} : ${dateTag.getClass()}
      dateTime : ${dateTime.toString().padRight(30)} : ${dateTime.getClass()}
"""
```

- result
  ```
   curerntTime : 1667810196418                  : class java.lang.Long
   newDateTime : 1667810196418                  : class java.lang.Long
  calendarTime : 1667810196418                  : class java.lang.Long

       dateTag : 2022-11-07                     : class java.time.LocalDate
      dateTime : 2022-11-07T00:36:36.418762     : class java.time.LocalDateTime
  ```

# LocalDateTime

> [!TIP]
> - [Java LocalDateTime with different format](https://beginnersbook.com/2017/10/java-localdatetime/)

## current LocalDataTime
```groovy
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

DateTimeFormatter format = DateTimeFormatter.ofPattern( "yyyy-MM-dd HH:mm:ss a" )

LocalDateTime currentDateTime = LocalDateTime.now()
String currentNewFormat = currentDateTime.format( format )

println """
   currentDateTime : ${currentDateTime}
  currentNewFormat : ${currentNewFormat}
"""
```
- result
  ```
   currentDateTime : 2021-04-29T01:13:27.291
  currentNewFormat : 2021-04-29 01:13:27 AM
  ```

## particular localDateTime
```groovy
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

DateTimeFormatter format = DateTimeFormatter.ofPattern( "yyyy-MM-dd HH:mm:ss a" )

LocalDateTime currentDateTime = LocalDateTime.now()
LocalDateTime localDateTime   = LocalDateTime.of( 2021, 04, 29, 00, 00, 00, 0000 )

String currentNewFormat = currentDateTime.format( format )
String localNewFormat   = localDateTime.format( format )

println """
   currentDateTime : ${currentDateTime}
  currentNewFormat : ${currentNewFormat}

     localDateTime : ${localDateTime}
    localNewFormat : ${localNewFormat}
"""
```
- result
  ```
     currentDateTime : 2021-04-29T01:19:53.928
    currentNewFormat : 2021-04-29 01:19:53 AM

       localDateTime : 2021-04-29T00:00
      localNewFormat : 2021-04-29 00:00:00 AM
  ```

## get detail info from localDateTime

{% hint style='tip' %}
> reference:
> - `int getYear()`            – year
> - `int getDayOfYear()`       – day of year as integer value, from `1` to `365`, or `366` in a leap year
> - `Month getMonth()`         – month.
> - `int getDayOfMonth()       – day of the month as integer value, from `1` to `31`
> - `DayOfWeek getDayOfWeek()` – day of the week.
> - `int getHour()             – hour of the day, from `0` to `23`
> - `int getMinute()`          – minute of the hour, from `0` to `59`
> - `int getSecond()           – second of the minute, from `0` to `59`
> - `int getNano()`            – nanosecond, from `0` to `999,999,999`
{% endhint %}

```groovy
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

DateTimeFormatter format    = DateTimeFormatter.ofPattern( "yyyy-MM-dd HH:mm:ss a" )

LocalDateTime localDateTime = LocalDateTime.of( 2021, 05, 01, 00, 00, 00, 0000 )
String localNewFormat       = localDateTime.format( format )


println """
     localDateTime : ${localDateTime}
    localNewFormat : ${localNewFormat}

           getYear : ${localDateTime.getYear()}
      getDayOfYear : ${localDateTime.getDayOfYear()}
      getDayOfWeek : ${localDateTime.getDayOfWeek()}
     getDayOfMonth : ${localDateTime.getDayOfMonth()}
           getNano : ${localDateTime.getNano()}
"""
```

- result
  ```
       localDateTime : 2021-05-01T00:00
      localNewFormat : 2021-05-01 00:00:00 AM

             getYear : 2021
        getDayOfYear : 121
        getDayOfWeek : SATURDAY
       getDayOfMonth : 1
             getNano : 0
  ```

## additional plus or minus for localDateTime

{% hint style='tip' %}
> **plus**:
> - `plusYears()`   – LocalDateTime with the specified years added
> - `plusMonths()`  – LocalDateTime with the specified months added
> - `plusDays()`    – LocalDateTime with the specified days added
> - `plusHours()`   – LocalDateTime with the specified hours added
> - `plusMinutes()` – LocalDateTime with the specified minutes added
> - `plusSeconds()` – LocalDateTime with the specified seconds added
> - `plusNanos()`   – LocalDateTime with the specified nanoseconds added
>
> **minus**:
> - `minusYears()`   – LocalDateTime with the specified years subtracted
> - `minusMonths()`  – LocalDateTime with the specified months subtracted
> - `minusDays()`    – LocalDateTime with the specified days subtracted
> - `minusHours()`   – LocalDateTime with the specified hours subtracted
> - `minusMinutes()` – LocalDateTime with the specified minutes subtracted
> - `minusSeconds()` – LocalDateTime with the specified seconds subtracted
> - `minusNanos()`   – LocalDateTime with the specified nanoseconds subtracted
{% endhint %}

```groovy
import java.time.LocalDateTime

LocalDateTime currentDateTime = LocalDateTime.now()

println """
    currentDateTime : ${currentDateTime}

       plusYears(2) : ${currentDateTime.plusYears(2)}
    plusMinutes(15) : ${currentDateTime.plusMinutes(15)}

      plusHours(24) : ${currentDateTime.plusHours(24)}
     minusHours(24) : ${currentDateTime.minusHours(24)}

      plusDays(365) : ${currentDateTime.minusDays(365)}
     minusDays(365) : ${currentDateTime.minusDays(365)}

     plusMonths(12) : ${currentDateTime.plusMonths(12)}
    minusMonths(12) : ${currentDateTime.minusMonths(12)}
```
- result
  ```
      currentDateTime : 2021-04-29T01:41:40.026

         plusYears(2) : 2023-04-29T01:41:40.026
      plusMinutes(15) : 2021-04-29T01:56:40.026

        plusHours(24) : 2021-04-30T01:41:40.026
       minusHours(24) : 2021-04-28T01:41:40.026

        plusDays(365) : 2020-04-29T01:41:40.026
       minusDays(365) : 2020-04-29T01:41:40.026

       plusMonths(12) : 2022-04-29T01:41:40.026
      minusMonths(12) : 2020-04-29T01:41:40.026
  ```

## isBefore(), isAfter() and isEqual()
```groovy
import java.time.LocalDateTime

LocalDateTime currentDateTime = LocalDateTime.now()
LocalDateTime localDataTime   = currentDateTime.plusHours(24)

println """
  currentDateTime : ${currentDateTime}
    localDataTime : ${localDataTime}

  currentDataTime == localDataTime ? : ${currentDateTime.isEqual(localDataTime)}
   currentDataTime > localDataTime ? : ${currentDateTime.isAfter(localDataTime)}
   currentDataTime < localDataTime ? : ${currentDateTime.isBefore(localDataTime)}
"""
```

- result
  ```
    currentDateTime : 2021-04-29T01:54:07.917
      localDataTime : 2021-04-30T01:54:07.917

    currentDataTime == localDataTime ? : false
     currentDataTime > localDataTime ? : false
     currentDataTime < localDataTime ? : true
  ```

# convert time

## [convert the Date to simpleDateFormat or timeInMillis](https://beginnersbook.com/2014/01/how-to-get-time-in-milliseconds-in-java/)

> [!TIP]
> reference:
> - [Java – Get time in milliseconds using Date, Calendar and ZonedDateTime](https://beginnersbook.com/2014/01/how-to-get-time-in-milliseconds-in-java/)
>
> tools:
> - [currentDate / Time in Millisecondsmillis](https://currentmillis.com/)
>
> setup simpleDateFormat to UTC timezone
> ```groovy
> simpleDateFormat.setTimeZone(TimeZone.getTimeZone("UTC"))
> ```

```groovy
import java.util.Calendar
import java.util.Date
import java.time.ZonedDateTime

Date date         = new Date()
long timeMilli_d  = date.getTime()

Calendar calendar = Calendar.getInstance()
long timeMilli_c  = calendar.getTimeInMillis()

ZonedDateTime zdt = ZonedDateTime.now()
Long timeMilli_z  = zdt.toInstant().toEpochMilli()

println """
           date : ${date.toString().padRight(35)} : ${date.getClass()}
    timeMilli_d : ${timeMilli_d.toString().padRight(35)} : ${timeMilli_d.getClass()}

  calendar.time : ${calendar.time.toString().padRight(35)} : ${calendar.time.getClass()}
    timeMilli_c : ${timeMilli_c.toString().padRight(35)} : ${timeMilli_c.getClass()}

            zdt : ${zdt.toString().padRight(35)} : ${zdt.getClass()}
    timeMilli_z : ${timeMilli_z.toString().padRight(35)} : ${timeMilli_z.getClass()}
"""
```
- result
  ```
           date : Mon Nov 07 00:45:32 PST 2022        : class java.util.Date
    timeMilli_d : 1667810732825                       : class java.lang.Long

  calendar.time : Mon Nov 07 00:45:32 PST 2022        : class java.util.Date
    timeMilli_c : 1667810732826                       : class java.lang.Long

            zdt : 2022-11-07T00:45:32.826394-08:00[America/Los_Angeles] : class java.time.ZonedDateTime
    timeMilli_z : 1667810732826                       : class java.lang.Long
  ```

### current time
```groovy
import java.util.Calendar
import java.util.Date
import java.text.SimpleDateFormat
import java.text.ParseException

SimpleDateFormat simpleDateFormat = new SimpleDateFormat( "yyyy-MM-dd HH:mm:ss" )

Date date          = new Date()
Calendar calendar  = Calendar.getInstance()

def timeInMillis   = date.getTime()
def calendarMillis = calendar.getTimeInMillis()
def simpleDate     = simpleDateFormat.format( date )

println """
            date : ${date.toString().padRight(30)} : ${date.getClass()}
     simepleDate : ${simpleDate.toString().padRight(30)} : ${simpleDate.getClass()}
    timeInMillis : ${timeInMillis.toString().padRight(30)} : ${timeInMillis.getClass()}
  calendarMillis : ${calendarMillis.toString().padRight(30)} : ${calendarMillis.getClass()}
"""
```

- result
  ```
  // default timezone
              date : Thu Apr 29 00:57:03 PDT 2021   : class java.util.Date
       simepleDate : 2021-04-29 00:57:03            : class java.lang.String
      timeInMillis : 1619683023852                  : class java.lang.Long
    calendarMillis : 1619683023853                  : class java.lang.Long

  // utc timezone
              date : Thu Apr 29 00:57:27 PDT 2021   : class java.util.Date
       simepleDate : 2021-04-29 07:57:27            : class java.lang.String
      timeInMillis : 1619683047726                  : class java.lang.Long
    calendarMillis : 1619683047726                  : class java.lang.Long
  ```

### particular time

> [!TIP]
> i.e.: `2021-04-29 00:00:00` with `SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")`

```groovy
import java.util.Calendar
import java.util.Date
import java.text.SimpleDateFormat

SimpleDateFormat simpleDateFormat = new SimpleDateFormat( "yyyy-MM-dd HH:mm:ss" )
String dateString = "2021-04-29 00:00:00"

Date date = simpleDateFormat.parse( dateString )

Calendar calendar = Calendar.getInstance()
calendar.setTime( date )

String timeInMillis   = date.getTime()
String calendarMillis = calendar.getTimeInMillis()
def simpleDate        = simpleDateFormat.format( date )

println """
            date : ${date}
     simepleDate : ${simpleDate}

    timeInMillis : ${timeInMillis}
  calendarMillis : ${calendarMillis}
"""
```
- result
  ```
            date : Thu Apr 29 00:00:00 PDT 2021
     simepleDate : 2021-04-29 00:00:00

    timeInMillis : 1619679600000
  calendarMillis : 1619679600000
  ```


## [convert `Long` to `SimpleDateFormat`](https://stackoverflow.com/a/12504608/2940319)

> [!TIP]
> reference:
> - [Parsing and Formatting Dates in Java](http://tutorials.jenkov.com/java-date-time/parsing-formatting-dates.html)
> - [get Beijing Date time - Java java.util](http://www.java2s.com/example/java/java.util/get-beijing-date-time.html)

```groovy
import java.util.Date
import java.text.SimpleDateFormat

Long x = 1086073200000
SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss dd/MM/yyyy")
simpleDateFormat.setTimeZone(TimeZone.getTimeZone("Asia/Shanghai"))

println """
  x                        : ${x.toString().padRight(30)} : ${x.getClass()}
  Date(x)                  : ${(new Date(x)).toString().padRight(30)} : ${(new Date(x)).getClass()}
  simpleDateFormat.Date(x) : ${simpleDateFormat.format(new Date(x)).toString().padRight(30)} : ${simpleDateFormat.format( new Date(x) ).getClass()}
  simpleDateFormat.Date(0) : ${simpleDateFormat.format(new Date(0)).toString().padRight(30)} : ${simpleDateFormat.format( new Date(0) ).getClass()}
"""
```
- result
  ```groovy
  x                        : 1086073200000                  : class java.lang.Long
  Date(x)                  : Tue Jun 01 00:00:00 PDT 2004   : class java.util.Date
  simpleDateFormat.Date(x) : 15:00:00 01/06/2004            : class java.lang.String
  simpleDateFormat.Date(0) : 08:00:00 01/01/1970            : class java.lang.String
  ```


## convert timeInMillis (`Long`) to `Date`

> [!TIP]
> via `java.util.Calendar`

```groovy
import java.text.SimpleDateFormat
import java.util.Calendar

Long x = 1086073200000
SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss dd/MM/yyyy")
simpleDateFormat.setTimeZone(TimeZone.getTimeZone("Asia/Shanghai"))

Calendar calendar = Calendar.getInstance()
calendar.setTimeInMillis(x)

println """
  x                                           : ${x.toString().padRight(35)} : ${x.getClass()}
  calendar.getTime()                          : ${calendar.getTime().toString().padRight(35)} : ${calendar.getTime().getClass()}
  simpleDateFormat.format(calendar.getTime()) : ${simpleDateFormat.format(calendar.getTime()).toString().padRight(35)} : ${simpleDateFormat.format(calendar.getTime()).getClass()}
"""
```
- result:
  ```
  x                                           : 1086073200000                       : class java.lang.Long
  calendar.getTime()                          : Tue Jun 01 00:00:00 PDT 2004        : class java.util.Date
  simpleDateFormat.format(calendar.getTime()) : 15:00:00 01/06/2004                 : class java.lang.String
  ```

## [convert `String` to `Date`](https://stackoverflow.com/a/26637209/2940319)
```groovy
import java.text.SimpleDateFormat

String myDate        = "2014/10/29 18:10:45";
SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
Date date            = sdf.parse(myDate)
long millis          = date.getTime()

println """
  myDate : ${myDate.toString().padRight(30)} : ${myDate.getClass()}
  date   : ${date.toString().padRight(30)} : ${date.getClass()}
"""
```
- result
  ```
  myDate : 2014/10/29 18:10:45            : class java.lang.String
  date   : Wed Oct 29 18:10:45 PDT 2014   : class java.util.Date
  ```

## [convert `Date` to timeInMillis (`Long`)](https://stackoverflow.com/a/26637209/2940319)
```groovy
import java.text.SimpleDateFormat

String myDate        = "2014/10/29 18:10:45";
SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
Date date            = sdf.parse(myDate)
long millis          = date.getTime()

println """
  myDate : ${myDate.toString().padRight(30)} : ${myDate.getClass()}
  date   : ${date.toString().padRight(30)} : ${date.getClass()}
  millis : ${millis.toString().padRight(30)} : ${millis.getClass()}
"""
```
- result
  ```
  myDate : 2014/10/29 18:10:45            : class java.lang.String
  date   : Wed Oct 29 18:10:45 PDT 2014   : class java.util.Date
  millis : 1414631445000                  : class java.lang.Long
  ```

# [formatting date](https://beginnersbook.com/2017/11/java-datetimeformatter/)

{% hint style='tip' %}
** reference** :
> - [Class DateTimeFormatter](https://docs.oracle.com/javase/8/docs/api/java/time/format/DateTimeFormatter.html)

**DateTimeFormatter** :

> - `BASIC_ISO_DATE`       : `'20110103'`
> - `ISO_LOCAL_DATE`       : `'2011-12-03'`
> - `ISO_OFFSET_DATE`      : `'2011-12-03+01:00'`
> - `ISO_DATE`             : `'2011-12-03+01:00'; '2011-12-03'`
> - `ISO_LOCAL_TIME`       : `'10:15:30'`
> - `ISO_OFFSET_TIME`      : `'10:15:30+01:00'`
> - `ISO_TIME`             : `'10:15:30+01:00'; '10:15:30'`
> - `ISO_LOCAL_DATE_TIME`  : `'2011-12-03T10:15:30'`
> - `ISO_OFFSET_DATE_TIME` : `'2011-12-03T10:15:30+01:00'`
> - `ISO_ZONED_DATE_TIME`  : `'2011-12-03T10:15:30+01:00[Europe/Paris]'`
> - `ISO_DATE_TIME`        : `'2011-12-03T10:15:30+01:00[Europe/Paris]'`
> - `ISO_ORDINAL_DATE`     : `'2012-337'`
> - `ISO_WEEK_DATE`        : `'2012-W48-6`
> - `ISO_INSTANT`          : `'2011-12-03T10:15:30Z'`
> - `RFC_1123_DATE_TIME`   : `'Tue, 3 Jun 2008 11:05:30 GMT'`


**Patterns for Formatting and Parsing** :

| Symbol   | Meaning                      | Presentation   | Examples                                         |
| :------: | ---------------------------- | -------------- | ------------------------------------------------ |
| `G`      | era                          | text           | AD; Anno Domini; A                               |
| `u`      | year                         | year           | 2004; 04                                         |
| `y`      | year-of-era                  | year           | 2004; 04                                         |
| `D`      | day-of-year                  | number         | 189                                              |
| `M/L`    | month-of-year                | number/text    | 7; 07; Jul; July; J                              |
| `d`      | day-of-month                 | number         | 10                                               |
|          |                              |                |                                                  |
| `Q/q`    | quarter-of-year              | number/text    | 3; 03; Q3; 3rd quarter                           |
| `Y`      | week-based-year              | year           | 1996; 96                                         |
| `w`      | week-of-week-based-year      | number         | 27                                               |
| `W`      | week-of-month                | number         | 4                                                |
| `E`      | day-of-week                  | text           | Tue; Tuesday; T                                  |
| `e/c`    | localized day-of-week        | number/text    | 2; 02; Tue; Tuesday; T                           |
| `F`      | week-of-month                | number         | 3                                                |
|          |                              |                |                                                  |
| `a`      | am-pm-of-day                 | text           | PM                                               |
| `h`      | clock-hour-of-am-pm (1-12)   | number         | 12                                               |
| `K`      | hour-of-am-pm (0-11)         | number         | 0                                                |
| `k`      | clock-hour-of-am-pm (1-24)   | number         | 0                                                |
|          |                              |                |                                                  |
| `H`      | hour-of-day (0-23)           | number         | 0                                                |
| `m`      | minute-of-hour               | number         | 30                                               |
| `s`      | second-of-minute             | number         | 55                                               |
| `S`      | fraction-of-second           | fraction       | 978                                              |
| `A`      | milli-of-day                 | number         | 1234                                             |
| `n`      | nano-of-second               | number         | 987654321                                        |
| `N`      | nano-of-day                  | number         | 1234000000                                       |
|          |                              |                |                                                  |
| `V`      | time-zone ID                 | zone-id        | America/Los_Angeles; Z; -08:30                   |
| `z`      | time-zone name               | zone-name      | Pacific Standard Time; PST                       |
| `O`      | localized zone-offset        | offset-O       | GMT+8; GMT+08:00; UTC-08:00;                     |
| `X`      | zone-offset 'Z' for zero     | offset-X       | Z; -08; -0830; -08:30; -083015; -08:30:15;       |
| `x`      | zone-offset                  | offset-x       | +0000; -08; -0830; -08:30; -083015; -08:30:15;   |
| `Z`      | zone-offset                  | offset-Z       | +0000; -0800; -08:00;                            |
|          |                              |                |                                                  |
| `p`      | pad next                     | pad modifier   | 1                                                |
|          |                              |                |                                                  |
| `'`      | escape for text              | delimiter      |                                                  |
| `''`     | single quote                 | literal        | '                                                |
| `[`      | optional section start       |                |                                                  |
| `]`      | optional section end         |                |                                                  |
| `#`      | reserved for future use      |                |                                                  |
| `{`      | reserved for future use      |                |                                                  |
| `}`      | reserved for future use      |                | .                                                |

{% endhint %}


```groovy
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

LocalDateTime currentDateTime = LocalDateTime.now()

DateTimeFormatter basicISODate = DateTimeFormatter.BASIC_ISO_DATE
DateTimeFormatter isoLocalDate = DateTimeFormatter.ISO_LOCAL_DATE
DateTimeFormatter isoLocalTime = DateTimeFormatter.ISO_LOCAL_TIME
DateTimeFormatter isoLocalDateTime = DateTimeFormatter.ISO_LOCAL_DATE_TIME

println """
      currentDateTime : ${currentDateTime}

       BASIC_ISO_DATE : ${basicISODate.format(currentDateTime)}
       ISO_LOCAL_DATE : ${isoLocalDate.format(currentDateTime)}
       ISO_LOCAL_TIME : ${isoLocalTime.format(currentDateTime)}
  ISO_LOCAL_DATE_TIME : ${isoLocalDateTime.format(currentDateTime)}
"""
```
- result
  ```
        currentDateTime : 2021-04-29T02:45:37.501

         BASIC_ISO_DATE : 20210429
         ISO_LOCAL_DATE : 2021-04-29
         ISO_LOCAL_TIME : 02:45:37.501
    ISO_LOCAL_DATE_TIME : 2021-04-29T02:45:37.501
  ```


