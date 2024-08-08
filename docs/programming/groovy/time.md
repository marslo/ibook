<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [get time](#get-time)
  - [current timestamp](#current-timestamp)
  - [data parse](#data-parse)
  - [get current time (timeInMillis)](#get-current-time-timeinmillis)
  - [localDateTime, LocalDate and Calendar](#localdatetime-localdate-and-calendar)
  - [Instant](#instant)
- [Calendar](#calendar)
  - [now](#now)
  - [delta time](#delta-time)
  - [specified time](#specified-time)
  - [get data by `ZonedDateTime`](#get-data-by-zoneddatetime)
- [LocalDateTime](#localdatetime)
  - [current LocalDateTime](#current-localdatetime)
  - [particular localDateTime](#particular-localdatetime)
  - [get detail info from localDateTime](#get-detail-info-from-localdatetime)
  - [additional plus or minus for localDateTime](#additional-plus-or-minus-for-localdatetime)
  - [isBefore(), isAfter() and isEqual()](#isbefore-isafter-and-isequal)
- [convert time](#convert-time)
  - [`Date` to simpleDateFormat or timeInMillis](#date-to-simpledateformat-or-timeinmillis)
    - [current time](#current-time)
    - [particular time](#particular-time)
  - [`Long` to `SimpleDateFormat`](#long-to-simpledateformat)
  - [convert timeInMillis (`Long`) to `Date`](#convert-timeinmillis-long-to-date)
  - [`String` to `Date`](#string-to-date)
  - [`Date` to timeInMillis (`Long`)](#date-to-timeinmillis-long)
  - [`Date` to `LocalDate`](#date-to-localdate)
  - [`Date` to `Calendar`](#date-to-calendar)
  - [`LocalDateTime` to/from `Instant`](#localdatetime-tofrom-instant)
- [timezone](#timezone)
  - [get timezone](#get-timezone)
    - [get available timezone](#get-available-timezone)
  - [`TimeZone` to `ZoneId`](#timezone-to-zoneid)
  - [convert to different timezone](#convert-to-different-timezone)
    - [with `Instance`](#with-instance)
    - [with `LocalDateTime`](#with-localdatetime)
    - [with `SimpleDateFormat`](#with-simpledateformat)
- [formatting date](#formatting-date)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> - API:
>   - [package java.time](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/time/package-summary.html)
>   - [DateTimeFormatter](https://docs.oracle.com/javase/8/docs/api/java/time/format/DateTimeFormatter.html)
> - references:
>   - [Java Date Time Tutorial](https://jenkov.com/tutorials/java-date-time/index.html)
>   - [Java System.currentTimeMillis()](https://jenkov.com/tutorials/java-date-time/system-currenttimemillis.html)
>   - [Java Time Measurement](https://jenkov.com/tutorials/java-date-time/time-measurement.html)
>   - [Java's java.util.Date](https://jenkov.com/tutorials/java-date-time/java-util-date.html)
>   - [Java's java.sql.Date](https://jenkov.com/tutorials/java-date-time/java-sql-date.html)
>   - [Java's java.util.Calendar and GregorianCalendar](https://jenkov.com/tutorials/java-date-time/java-util-calendar.html)
>   - [Java's java.util.TimeZone](https://jenkov.com/tutorials/java-date-time/java-util-timezone.html)
>   - [Parsing and Formatting Dates in Java](https://jenkov.com/tutorials/java-date-time/parsing-formatting-dates.html)
>   - [Java LocalDate](https://jenkov.com/tutorials/java-date-time/localdate.html)
>   - [Java LocalTime](https://jenkov.com/tutorials/java-date-time/localtime.html)
>   - [Java LocalDateTime](https://jenkov.com/tutorials/java-date-time/localdatetime.html)
>   - [Java ZonedDateTime](https://jenkov.com/tutorials/java-date-time/zoneddatetime.html)
>   - [Java DateTimeFormatter](https://jenkov.com/tutorials/java-date-time/datetimeformatter.html)
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
> - [* imarslo: get build time in Jenkins script](../../jenkins/script/build.html#get-build-time)
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

## get current time (timeInMillis)
```groovy
import java.util.Calendar
import java.time.LocalDateTime
import java.time.LocalDate
import java.time.Instant

long curerntTime       = System.currentTimeMillis()
long newDateTime       = new Date().getTime()
long calendarTime      = Calendar.getInstance().getTimeInMillis()
long instanceTime      = Instant.now().toEpochMilli()

LocalDate dateTag      = java.time.LocalDate.now()
LocalDateTime dateTime = LocalDateTime.now()

println """
   curerntTime : ${curerntTime.toString().padRight(30)} : ${curerntTime.getClass()}
   newDateTime : ${newDateTime.toString().padRight(30)} : ${newDateTime.getClass()}
  calendarTime : ${calendarTime.toString().padRight(30)} : ${calendarTime.getClass()}
  instanceTime : ${instanceTime.toString().padRight(30)} : ${calendarTime.getClass()}

       dateTag : ${dateTag.toString().padRight(30)} : ${dateTag.getClass()}
      dateTime : ${dateTime.toString().padRight(30)} : ${dateTime.getClass()}
"""
```

- result
  ```
   curerntTime : 1723087263176                  : class java.lang.Long
   newDateTime : 1723087263176                  : class java.lang.Long
  calendarTime : 1723087263176                  : class java.lang.Long
  instanceTime : 1723087263176                  : class java.lang.Long

       dateTag : 2024-08-07                     : class java.time.LocalDate
      dateTime : 2024-08-07T20:21:03.176906     : class java.time.LocalDateTime
  ```

## localDateTime, LocalDate and Calendar

> [!NOTE|label:see more]
> - [* iMarslo: build time in Jenkins script](../../jenkins/script/build.md#build-time)

```groovy
import java.time.LocalDateTime
import java.time.LocalDate
import java.util.Calendar


final LocalDateTime DATE_TIME = LocalDateTime.now()
final LocalDate DATE_TAG      = java.time.LocalDate.now()
final long CURRENT_TIME       = System.currentTimeMillis()
final long RIGHT_NOW          = Calendar.getInstance().getTimeInMillis()

println """
  >> current time :
        DATE_TIME : ${DATE_TIME}
         DATE_TAG : ${DATE_TAG}
     CURRENT_TIME : ${CURRENT_TIME}
        RIGHT_NOW : ${RIGHT_NOW}
"""
```

- result
  ```
  >> current time :
        DATE_TIME : 2024-08-07T18:26:08.905456
         DATE_TAG : 2024-08-07
     CURRENT_TIME : 1723080368905
        RIGHT_NOW : 1723080368905

  ```

## Instant

> [!NOTE|label:references:]

```groovy
import java.time.Instant
import java.time.ZoneId

println Instant.parse('2022-11-07T00:36:36Z')
               .atZone( ZoneId.of('America/Los_Angeles') )
               .toLocalDate()
println Instant.parse('2022-11-07T00:36:36Z')
               .atZone( ZoneId.of('America/Los_Angeles') )
               .toLocalDateTime()
println Instant.parse('2022-11-07T00:36:36Z')
               .atZone( ZoneId.of('America/Los_Angeles') )
               .toLocalTime()

// 2022-11-06
// 2022-11-06T16:36:36
// 16:36:36
```

# Calendar

> [!TIP|label:reference]
> - [java.util.Calendar](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/Calendar.html)
> - [java.time.ZonedDateTime](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/time/ZonedDateTime.html)

## now
```groovy
import java.util.Calendar
Calendar calendar = Calendar.getInstance()

println """
  time                 : ${calendar.getTime()}
  year                 : ${calendar.get(Calendar.YEAR)} | ${calendar.get(Calendar.YEAR) % 100 }
  month                : ${calendar.get(Calendar.MONTH)} | ${calendar.get(Calendar.MONTH).toString().padLeft( 2, '0' ) }
  date                 : ${calendar.get(Calendar.DATE)}
  hour                 : ${calendar.get(Calendar.HOUR)}
  minute               : ${calendar.get(Calendar.MINUTE)}
  second               : ${calendar.get(Calendar.SECOND)}
  millisecond          : ${calendar.get(Calendar.MILLISECOND)}
  zone offset          : ${calendar.get(Calendar.ZONE_OFFSET)}
  dst offset           : ${calendar.get(Calendar.DST_OFFSET)}
  am/pm                : ${calendar.get(Calendar.AM_PM)}
  am                   : ${Calendar.AM}
  pm                   : ${Calendar.PM}
  short                : ${calendar.get(Calendar.SHORT)}

  day of month         : ${calendar.get(Calendar.DAY_OF_MONTH).toString().padLeft( 2, '0' )}
  week of month        : ${calendar.get(Calendar.WEEK_OF_MONTH).toString().padLeft( 2, '0' )}

  day of week          : ${calendar.get(Calendar.DAY_OF_WEEK).toString().padLeft( 2, '0' )}
  day of week in month : ${calendar.get(Calendar.DAY_OF_WEEK_IN_MONTH)}
  day of year          : ${calendar.get(Calendar.DAY_OF_YEAR)}
"""
```

- result
  ```
  time                 : Wed Aug 07 18:04:38 PDT 2024
  year                 : 2024 | 24
  month                : 7 | 07
  date                 : 7
  hour                 : 6
  minute               : 4
  second               : 38
  millisecond          : 125
  zone offset          : -28800000
  dst offset           : 3600000
  am/pm                : 1
  am                   : 0
  pm                   : 1
  short                : 2024

  day of month         : 07
  week of month        : 02

  day of week          : 04
  day of week in month : 1
  day of year          : 220
  ```

## delta time
```groovy
import java.text.SimpleDateFormat

Calendar calendar = Calendar.getInstance()
SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MMM/dd")

println "NOW               : ${calendar.getTime()} | ${sdf.format(calendar.getTime())}"

calendar.add(Calendar.DAY_OF_MONTH, -10)
println "DAY_OF_MONTH - 10 : ${calendar.getTime()} | ${sdf.format(calendar.getTime())}"

calendar.add(Calendar.MONTH, 1)
println "MONTH + 1         : ${calendar.getTime()} | ${sdf.format(calendar.getTime())}"
```

- result
  ```
  NOW               : Wed Aug 07 19:03:43 PDT 2024 | 2024/Aug/07
  DAY_OF_MONTH - 10 : Sun Jul 28 19:03:43 PDT 2024 | 2024/Jul/28
  MONTH + 1         : Wed Aug 28 19:03:43 PDT 2024 | 2024/Aug/28
  ```

## specified time

> [!NOTE|label:references:]
> - [java.util.GregorianCalendar](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/GregorianCalendar.html)

```groovy
import java.util.GregorianCalendar

Calendar calendar = new GregorianCalendar(2013,1,28,13,24,56)

println """
  year        : ${calendar.get(Calendar.YEAR)}
  month       : ${calendar.get(Calendar.MONTH)}
  dayOfMonth  : ${calendar.get(Calendar.DAY_OF_MONTH)}
  dayOfWeek   : ${calendar.get(Calendar.DAY_OF_WEEK)}
  weekOfYear  : ${calendar.get(Calendar.WEEK_OF_YEAR)}
  weekOfMonth : ${calendar.get(Calendar.WEEK_OF_MONTH)}

  hour        : ${calendar.get(Calendar.HOUR)}
  hourOfDay   : ${calendar.get(Calendar.HOUR_OF_DAY)}
  minute      : ${calendar.get(Calendar.MINUTE)}
  second      : ${calendar.get(Calendar.SECOND)}
  millisecond : ${calendar.get(Calendar.MILLISECOND)}
"""
```

- result
  ```
  year        : 2013
  month       : 1
  dayOfMonth  : 28
  dayOfWeek   : 5
  weekOfYear  : 9
  weekOfMonth : 5

  hour        : 1
  hourOfDay   : 13
  minute      : 24
  second      : 56
  millisecond : 0

  ```

## get data by `ZonedDateTime`

```groovy
import java.time.ZonedDateTime

ZonedDateTime now = Calendar.getInstance().toZonedDateTime()

println """
  ${now.now()}
  ${now.getYear()}/${now.getMonthValue()}/${now.getDayOfMonth()} | ${now.getYear()%100}/${now.getMonthValue().toString().padLeft(2, '0')}/${now.getDayOfMonth().toString().padLeft(2, '0')}
  ${now.getHour()} : ${now.getMinute()} : ${now.getSecond()}

  timezone   : ${now.getZone()} | ${now.getOffset()}
  year       : ${now.getYear()}
  month      : ${now.getMonth()} | ${now.getMonthValue()}
  dayOfMonth : ${now.getDayOfMonth()}
  dayOfWeek  : ${now.getDayOfWeek()}
  dayOfYear  : ${now.getDayOfYear()}
"""
```

- result:
  ```
  2024-08-07T18:21:31.157251-07:00[America/Los_Angeles]
  2024/8/7 | 24/08/07
  18 : 21 : 31

  timezone   : America/Los_Angeles | -07:00
  year       : 2024
  month      : AUGUST | 8
  dayOfMonth : 7
  dayOfWeek  : WEDNESDAY
  dayOfYear  : 220
  ```


# LocalDateTime

> [!TIP]
> - [Java LocalDateTime with different format](https://beginnersbook.com/2017/10/java-localdatetime/)

## current LocalDateTime
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
LocalDateTime localDateTime   = currentDateTime.plusHours(24)

println """
  currentDateTime : ${currentDateTime}
    localDateTime : ${localDateTime}

  currentDataTime == localDateTime ? : ${currentDateTime.isEqual(localDateTime)}
   currentDataTime > localDateTime ? : ${currentDateTime.isAfter(localDateTime)}
   currentDataTime < localDateTime ? : ${currentDateTime.isBefore(localDateTime)}
"""
```

- result
  ```
    currentDateTime : 2021-04-29T01:54:07.917
      localDateTime : 2021-04-30T01:54:07.917

    currentDataTime == localDateTime ? : false
     currentDataTime > localDateTime ? : false
     currentDataTime < localDateTime ? : true
  ```

# convert time

## [`Date` to simpleDateFormat or timeInMillis](https://beginnersbook.com/2014/01/how-to-get-time-in-milliseconds-in-java/)

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
String dateString        = "2021-04-29 00:00:00"

Date date                = simpleDateFormat.parse( dateString )

Calendar calendar        = Calendar.getInstance()
calendar.setTime( date )

String timeInMillis      = date.getTime()
String calendarMillis    = calendar.getTimeInMillis()
def simpleDate           = simpleDateFormat.format( date )

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

## [`Long` to `SimpleDateFormat`](https://stackoverflow.com/a/12504608/2940319)

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

## [`String` to `Date`](https://stackoverflow.com/a/26637209/2940319)
```groovy
import java.text.SimpleDateFormat

String myDate        = "2014/10/29 18:10:45"
SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
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

## [`Date` to timeInMillis (`Long`)](https://stackoverflow.com/a/26637209/2940319)
```groovy
import java.text.SimpleDateFormat

String myDate        = "2014/10/29 18:10:45"
SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
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

## `Date` to `LocalDate`

> [!NOTE|label:references:]
> - [I want to get Year, Month, Day, etc from Java Date to compare with Gregorian Calendar date in Java. Is this possible?](https://stackoverflow.com/a/32363174/2940319)

```groovy
import java.util.Date
import java.time.LocalDate
import java.time.ZoneId

Date date           = new Date()
LocalDate localDate = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate()
println """
  year  : ${localDate.getYear()}
  month : ${localDate.getMonthValue()}
  day   : ${localDate.getDayOfMonth()}
"""
```

- result
  ```
  year  : 2024
  month : 8
  day   : 7
  ```

## `Date` to `Calendar`
```groovy
import java.text.SimpleDateFormat

SimpleDateFormat sdf = new SimpleDateFormat("dd-M-yyyy hh:mm:ss")
String dateInString  = "22-01-2015 10:20:56"
Date date            = sdf.parse(dateInString)

Calendar calendar = Calendar.getInstance()
calendar.setTime(date)
calendar.getTime()

// Result: Thu Jan 22 10:20:56 PST 2015
```

## `LocalDateTime` to/from `Instant`

- `LocalDateTime` -> `Instant`
  ```groovy
  import java.time.Instant
  import java.time.LocalDateTime
  import java.time.ZoneId

  Instant instant = LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant()
  // 2024-08-08T03:36:39.824183Z
  ```

- `LocalDateTime` <- `Instant`
  ```groovy
  import java.time.Instant
  import java.time.LocalDateTime
  import java.time.ZoneId

  LocalDateTime ldt = Instant.parse('2022-11-07T00:36:36Z')
                             .atZone( ZoneId.of('America/Los_Angeles') )
                             .toLocalDateTime()
  // 2022-11-06T16:36:36

  // or
  LocalDateTime ldt = Instant.now()
                             .atZone( ZoneId.of('America/Los_Angeles') )
                             .toLocalDateTime()
  // 2024-08-07T20:36:39.824492
  ```

# timezone

> [!NOTE|label:references:]
> - [java.time.ZoneId](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/time/ZoneId.html)
> - [java.util.TimeZone](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/TimeZone.html)

## get timezone

- get all
  ```groovy
  println TimeZone.getAvailableIDs()
  ```

- get same timezone
  ```groovy
  //                         UTC offset ( +8 )
  //                                 v
  println TimeZone.getAvailableIDs(  8*60*60*1000 )

  println TimeZone.getAvailableIDs( -8*60*60*1000 ).findAll{ it.startsWith( 'America' ) }
  // [America/Ensenada, America/Los_Angeles, America/Santa_Isabel, America/Tijuana, America/Vancouver]

  println TimeZone.getAvailableIDs(  8*60*60*1000 ).collect().sort().join('\n')
  ```

  - result
    ```
    Asia/Brunei
    Asia/Choibalsan
    Asia/Chongqing
    Asia/Chungking
    Asia/Harbin
    Asia/Hong_Kong
    Asia/Irkutsk
    Asia/Kuala_Lumpur
    Asia/Kuching
    Asia/Macao
    Asia/Macau
    Asia/Makassar
    Asia/Manila
    Asia/Shanghai
    Asia/Singapore
    Asia/Taipei
    Asia/Ujung_Pandang
    Asia/Ulaanbaatar
    Asia/Ulan_Bator
    Australia/Perth
    Australia/West
    CTT
    Etc/GMT-8
    Hongkong
    PRC
    Singapore
    ```

- get particular
  ```groovy
  TimeZone tz = TimeZone.getTimeZone( 'America/Los_Angeles' )

  println tz.metaClass.methods*.name.sort().unique()
  // [clone, equals, getAvailableIDs, getClass, getDSTSavings, getDefault, getDisplayName, getID, getOffset, getRawOffset, getTimeZone, hasSameRules, hashCode, inDaylightTime, notify, notifyAll, observesDaylightTime, setDefault, setID, setRawOffset, toString, toZoneId, useDaylightTime, wait]

  println tz.observesDaylightTime()
  // true

  println tz.getRawOffset()/60/60/1000
  // -8

  println tz.getID()
  // America/Los_Angeles

  println tz.getDisplayName()
  // Pacific Standard Time
  ```

### get available timezone

> [!TIP]
> - [Java's java.util.TimeZone](https://jenkov.com/tutorials/java-date-time/java-util-timezone.html)

```groovy
java.util.TimeZone.getAvailableIDs()

// or
java.util.TimeZone.getAvailableIDs().collect { it }

println java.util.TimeZone.getDefault().getDisplayName()
println java.util.TimeZone.getDefault().getID()
println java.util.TimeZone.getDefault().getOffset( System.currentTimeMillis() )
-- result --
Pacific Standard Time
America/Los_Angeles
-28800000
```


## `TimeZone` to `ZoneId`

```groovy
java.time.ZoneId tz = TimeZone.getTimeZone( 'America/Los_Angeles' ).toZoneId()

println tz.metaClass.methods*.name.sort().unique()
// [equals, from, getAvailableZoneIds, getClass, getDisplayName, getId, getRules, hashCode, normalized, notify, notifyAll, of, ofOffset, systemDefault, toString, wait]

println tz.getOffset()
// -07:00

println "${tz.getId()} | ${tz.normalized()}"
// America/Los_Angeles | America/Los_Angeles

println tz.getRules()
// ZoneRules[currentStandardOffset=-08:00]
```

## convert to different timezone

### with `Instance`

> [!NOTE|label:references:]
> - [java.time.Instant](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/time/Instant.html)
> - [Java SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'") gives timezone as IST](https://stackoverflow.com/a/35885084/2940319)

```groovy
import java.time.Instant
import java.time.ZoneId

// local now -> timezone
println Instant.now().atZone( ZoneId.of("Asia/Shanghai") ).toLocalDateTime()
// 2024-08-08T11:09:37.348010

// particular UTC time -> timezone
//                    parse text in standard ISO 8601 format
//                    where the `Z` means UTC, pronounces “Zulu”
//                                         v
println Instant.parse( "2023-02-28T18:46:19Z" ).atZone( ZoneId.of("Asia/Shanghai") ).toLocalDateTime()
// 2023-03-01T02:46:19       -> java.time.LocalDateTime
println Instant.parse( "2023-02-28T18:46:19Z" ).atZone( ZoneId.of("America/Los_Angeles") ).toLocalDateTime()
// 2023-02-28T10:46:19       -> java.time.LocalDateTime
```

### with `LocalDateTime`

> [!NOTE|label:references:]
> - [Changing LocalDateTime based on time difference in current time zone vs. eastern time zone](https://stackoverflow.com/a/42281883/2940319)

```groovy
import java.time.LocalDateTime
import java.time.ZoneId

LocalDateTime.now()
             .atZone( ZoneId.of('America/Los_Angeles') )
             .withZoneSameInstant( ZoneId.of('Asia/Shanghai') )
             .toLocalDateTime()
// 2024-08-08T11:45:02.946899 ( now: 2024-08-07T20:45:02.946899 )

// or parse particular time
LocalDateTime.parse( '2022-11-07T00:36:36' )
             .atZone( ZoneId.of('Asia/Shanghai') )
             .withZoneSameInstant( ZoneId.of('America/Los_Angeles') )
             .toLocalDateTime()
// 2022-11-06T08:36:36
```

- or with `DateTimeFormatter`
  ```groovy
  import java.time.LocalDateTime
  import java.time.ZoneId
  import java.time.format.DateTimeFormatter

  LocalDateTime.parse( '2022-11-07T00:36:36' )
               .atZone( ZoneId.of('Asia/Shanghai') )
               .withZoneSameInstant( ZoneId.of('America/Los_Angeles') )
               .format(DateTimeFormatter.ISO_DATE_TIME)
  // 2022-11-06T08:36:36-08:00[America/Los_Angeles]
  ```

### with `SimpleDateFormat`
```groovy
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.TimeZone

Calendar calendar    = Calendar.getInstance()
calendar.setTime(new Date())
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss")

sdf.setTimeZone(TimeZone.getDefault())
println "${sdf.format(calendar.getTime())} : ${sdf.getTimeZone().getID()}"

sdf.setTimeZone(TimeZone.getTimeZone("UTC"))
println "${sdf.format(calendar.getTime())} : ${sdf.getTimeZone().getID()}"

sdf.setTimeZone(TimeZone.getTimeZone("GMT+8"))
println "${sdf.format(calendar.getTime())} : ${sdf.getTimeZone().getID()}"

sdf.setTimeZone(TimeZone.getTimeZone("Asia/Shanghai"))
println "${sdf.format(calendar.getTime())} : ${sdf.getTimeZone().getID()}"
``````

- result
  ```
  2024-08-07 08:00:05 : America/Los_Angeles
  2024-08-08 03:00:05 : UTC
  2024-08-08 11:00:05 : GMT+08:00
  2024-08-08 11:00:05 : Asia/Shanghai
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

