<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [regex `Pattern` and `Matcher`](#regex-pattern-and-matcher)
  - [matches to regex (return `Boolean`)](#matches-to-regex-return-boolean)
  - [get all matches](#get-all-matches)
- [encoding & decoding](#encoding--decoding)
  - [recursively encoding](#recursively-encoding)
  - [recursively decoding](#recursively-decoding)
- [unicode](#unicode)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## regex `Pattern` and `Matcher`

{% hint style='tip' %}
> references:
> - [java.util.regex](https://docs.oracle.com/javase/7/docs/api/java/util/regex/Matcher.html)
{% endhint %}

### matches to regex (return `Boolean`)
```groovy
String cpuset  = '/kubepods/burstable/pod59899be8/b60bf42d334be0eff64f325bad5b0ca4750119fbf8a7e80afa4e559040208ab3'
String pattern = '^/kubepods/([^/]+/){2}(\\w{64})$'

assert (cpuset =~ pattern).find()      == true
assert (cpuset =~ pattern).lookingAt() == true
assert (cpuset =~ pattern).matches()   == true
```

### get all matches
```groovy
String text = """
This text contains some numbers like 1024
or 256. Some of them are odd (like 3) or
even (like 2).
"""
String pattern = '\\d+'

assert (text =~ pattern).findAll() == [ '1024', '256', '3', '2' ]
```

#### safely capture the matches
```groovy
String k8sPattern    = '^/kubepods/([^/]+/){2}(\\w{64})$'
String dockerPattern = '^/docker/(\\w{64})$'
String cpuset  = '/kubepods/burstable/pod59899be8/b60bf42d334be0eff64f325bad5b0ca4750119fbf8a7e80afa4e559040208ab3'
int groupIndex = 0
int index      = 1

( cpuset =~ k8sPattern ).findAll()?.getAt(groupIndex)?.getAt(index)    ?: null
( cpuset =~ dockerPattern ).findAll()?.getAt(groupIndex)?.getAt(index) ?: null
```

## encoding & decoding

{% hint style="tip" %}
> reference:
> - [* URL encoding](https://rosettacode.org/wiki/URL_encoding)
> - [* URL decoding](https://rosettacode.org/wiki/URL_decoding#Groovy)
> - [java.net.URLEncoder](https://docs.oracle.com/javase/7/docs/api/java/net/URLEncoder.html)
> - [java.net.URLDecoder](https://docs.oracle.com/javase/7/docs/api/java/net/URLDecoder.html)
> - [Groovy UrlEncode and UrlDecode a map](https://snipplr.com/view/68918/groovy-urlencode-and-urldecode-a-map)
> - [mujahidk/base64coding.groovy](https://gist.github.com/mujahidk/7fdda0c69d11fc3e4a0907ce4ea77537)
> - [Groovy Goodness: Base64 Encoding](https://blog.mrhaki.com/2009/11/groovy-goodness-base64-encoding.html)
{% endhint %}

### recursively encoding
```groovy
import java.net.URLEncoder
import java.nio.charset.StandardCharsets

String encoder ( String url, Integer counter = 1 ) {
  if ( counter == 0 ) return url
  if ( counter >  0 ) return encoder( URLEncoder.encode( url, StandardCharsets.UTF_8 ), counter - 1 )
}
```

### recursively decoding
```groovy
import java.net.URLDecoder
import java.nio.charset.StandardCharsets

String decoder ( String url, Integer counter = 1 ) {
  if ( counter == 0 ) return url
  if ( counter >  0 ) return decoder( URLDecoder.decode( url, StandardCharsets.UTF_8 ), counter - 1 )
}
```

## unicode
```groovy
println """
  \\u22c5 : | \u22c5 |
  \\u23d0 : | \u23d0 |
  \\u2802 : | \u2802 |
  \\u2812 : | \u2812 |
  \\u00a8 : | \u00a8 |
  \\u2810 : | \u2810 |
  \\u22ef : | \u22ef |
  \\u1801 : | \u1801 |
  \\u1802 : | \u1802 |
  \\u1803 : | \u1803 |
  \\u20db : | \u20db |
  \\u20dc : | \u20dc |
  \\u20e8 : | \u20e8 |
  \\u20db : | \u20db |
  \\u20dc : | \u20dc |
  \\u2236 : | \u2236 |
  \\u22ee : | \u22ee |
  \\u22ef : | \u22ef |
  \\u2d48 : | \u2d48 |
  \\u2d42 : | \u2d42 |
  \\u2d57 : | \u2d57 |
  \\u2d67 : | \u2d67 |
  \\u2e31 : | \u2e31 |
  \\u302f : | \u302f |
  \\ua4fd : | \ua4fd |
  \\ua537 : | \ua537 |
  \\ua539 : | \ua539 |
  \\ua789 : | \ua789 |
  \\ufe19 : | \ufe19 |
  \\ufe55 : | \ufe55 |

  \\u2219 : | \u2219 |
  \\u22c5 : | \u22c5 |
  \\u22ef : | \u22ef |

  \\u25b4 : | \u25b4 |
  \\u25b8 : | \u25b8 |
  \\u25be : | \u25be |
  \\u25c2 : | \u25c2 |
  \\u25cf : | \u25cf |
  \\u25b9 : | \u25b9 |
  \\u25bf : | \u25bf |

  \\u2639 : | \u2639 |
  \\u263a : | \u263a |
  \\u263b : | \u263b |
"""
```
- result
  ```
    \u22c5 : | ⋅ |
    \u23d0 : | ⏐ |
    \u2802 : | ⠂ |
    \u2812 : | ⠒ |
    \u00a8 : | ¨ |
    \u2810 : | ⠐ |
    \u22ef : | ⋯ |
    \u1801 : | ᠁ |
    \u1802 : | ᠂ |
    \u1803 : | ᠃ |
    \u20db : |  |
    \u20dc : |  |
    \u20e8 : |  |
    \u20db : |  |
    \u20dc : |  |
    \u2236 : | ∶ |
    \u22ee : | ⋮ |
    \u22ef : | ⋯ |
    \u2d48 : | ⵈ |
    \u2d42 : | ⵂ |
    \u2d57 : | ⵗ |
    \u2d67 : | ⵧ |
    \u2e31 : | ⸱ |
    \u302f : |  |
    \ua4fd : | ꓽ |
    \ua537 : | ꔷ |
    \ua539 : | ꔹ |
    \ua789 : | ꞉ |
    \ufe19 : | ︙ |
    \ufe55 : | ﹕ |

    \u2219 : | ∙ |
    \u22c5 : | ⋅ |
    \u22ef : | ⋯ |

    \u25b4 : | ▴ |
    \u25b8 : | ▸ |
    \u25be : | ▾ |
    \u25c2 : | ◂ |
    \u25cf : | ● |
    \u25b9 : | ▹ |
    \u25bf : | ▿ |

    \u2639 : | ☹ |
    \u263a : | ☺ |
    \u263b : | ☻ |
  ```
