<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [convert](#convert)
  - [`capitalize`](#capitalize)
  - [`uncapitalize`](#uncapitalize)
  - [`toLowerCase`](#tolowercase)
  - [`toUpperCase`](#touppercase)
- [substring](#substring)
  - [string indexing](#string-indexing)
  - [`minus`](#minus)
  - [`take`](#take)
  - [`drop`](#drop)
  - [`tr`](#tr)
  - [tricky](#tricky)
- [comparation](#comparation)
  - [`equalsIgnoreCase`](#equalsignorecase)
  - [`compareToIgnoreCase`](#comparetoignorecase)
- [repalce](#repalce)
  - [`reverse`](#reverse)
  - [`replaceAll`](#replaceall)
  - [`replaceFirst`](#replacefirst)
  - [replaceAll with case-insensitive](#replaceall-with-case-insensitive)
  - [Apply proper uppercase and lowercase on a String](#apply-proper-uppercase-and-lowercase-on-a-string)
- [split](#split)
  - [split string by Capital Letters](#split-string-by-capital-letters)
  - [split via patten](#split-via-patten)
- [trim](#trim)
  - [`stripIndent()`](#stripindent)
  - [`stripMargin()`](#stripmargin)
- [output format](#output-format)
  - [`expand`](#expand)
  - [`unexpand`](#unexpand)
  - [`padRright`](#padrright)
  - [`center`](#center)
- [size](#size)
  - [`count`](#count)
  - [`size`](#size)
- [random](#random)
  - [`shuffled`](#shuffled)
  - [`java.util.Random`](#javautilrandom)
- [file](#file)
- [StringTokenizer](#stringtokenizer)
- [URI](#uri)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - java.lang.Object:
>   - [CharSequence](https://docs.groovy-lang.org/latest/html/groovy-jdk/java/lang/CharSequence.html)
>     - [stripMargin()](http://docs.groovy-lang.org/latest/html/groovy-jdk/java/lang/CharSequence.html#stripMargin())
>     - [stripIndent()](http://docs.groovy-lang.org/latest/html/groovy-jdk/java/lang/CharSequence.html#stripIndent())
>   - [String](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html)
>   - [StringJoiner](https://docs.oracle.com/javase/8/docs/api/java/util/StringJoiner.html)
>   - [StringGroovyMethods](http://docs.groovy-lang.org/2.4.7/html/gapi/org/codehaus/groovy/runtime/StringGroovyMethods.html)
> - [Strip indent in Groovy multiline strings](https://stackoverflow.com/a/56188273/2940319)
> - [Is there an operator that can trim indentation in multi-line string?](https://stackoverflow.com/a/22280879/2940319)
> - [Class StringGroovyMethods](http://docs.groovy-lang.org/docs/groovy-2.4.1/html/gapi/org/codehaus/groovy/runtime/StringGroovyMethods.html)
> - [Three Groovy String methods that will make your life Groovier!](https://e.printstacktrace.blog/groovy-string-methods-that-will-make-your-life-groovier/)
{% endhint %}

## convert
### `capitalize`
```groovy
assert 'Groovy' == 'groovy'.capitalize()
```

### `uncapitalize`
```groovy
assert 'groovy'      == 'Groovy'.uncapitalize()
assert 'hello World' == 'Hello World'.uncapitalize()
assert 'hello world' == 'Hello World'.tokenize().collect { it.uncapitalize() }.join(' ')
```

### `toLowerCase`
```groovy
assert 'groovy' == 'GRoOvy'.toLowerCase()
```

### `toUpperCase`
```groovy
assert 'GROOVY' == 'gRoovy'.toUpperCase()
```

## substring
### string indexing
```groovy
assert '123' == '1234567'[0..2]
assert '67'  == '1234567'[-2..-1]
```

### `minus`
```groovy
assert 'Hello ' == 'Hello World'.minus( 'World' )
assert ' World' == 'Hello World'.minus( 'Hello' )
```

- or
  ```groovy
  assert 'Hello ' == 'Hello World' - 'World'
  assert ' World' == 'Hello World' - 'Hello'
  ```

### `take`
```groovy
assert 'G'   == 'Groovy'.take(1)
assert 'Gr'  == 'Groovy'.take(2)
assert 'Gro' == 'Groovy'.take(3)
```

#### `takeRight`

> [!TIP]
> returns the last num elements from this CharSequence.

```groovy
assert ''    == 'Groovy'.takeRight( 0 )
assert 'y'   == 'Groovy'.takeRight( 1 )
assert 'ovy' == 'Groovy'.takeRight( 3 )
```

#### `takeAfter`
```groovy
assert ' development. Groovy team' == 'Groovy development. Groovy team'.takeAfter( 'Groovy' )
assert 'team'                      == 'Groovy development. Groovy team'.takeAfter( ' Groovy ' )
```

#### `takeBefore`
```groovy
assert 'Groovy '            == 'Groovy development. Groovy team'.takeBefore( 'development' )
assert 'Groovy development' == 'Groovy development. Groovy team'.takeBefore( '. Groovy ' )
```

#### `takeBetween`
```groovy
assert ' development. ' == 'Groovy development. Groovy team'.takeBetween( 'Groovy' )
assert 'marslo'         == 'name = "marslo"'.takeBetween( '"' )

assert '10'  == "t1='10' ms, t2='100' ms".takeBetween( "'"    )
assert '10'  == "t1='10' ms, t2='100' ms".takeBetween( "'", 0 )
assert '100' == "t1='10' ms, t2='100' ms".takeBetween( "'", 1 )
```

#### `takeWhile`

> [!TIP]
> returns the longest prefix of this CharSequence where each element passed to the given closure evaluates to true.

```groovy
assert ''   == 'Groovy'.takeWhile{ it < 'A'  }
assert 'G'  == 'Groovy'.takeWhile{ it < 'a'  }
assert 'Gr' == 'Groovy'.takeWhile{ it != 'o' }
```

### `drop`
```groovy
assert 'ovY' == 'GroovY'.drop(3)
assert ''    == 'GroovY'.drop(10)
```

#### `dropWhile`

> [!TIP]
> create **a suffix** of the given CharSequence by dropping as many characters as possible from the front of the original CharSequence such that calling the given closure condition evaluates to true when passed each of the dropped characters.

```groovy
assert 'roovY' == 'GroovY'.dropWhile{ it < 'Z' }
```

### `tr`
```groovy
assert 'hEllO' == 'hello'.tr('aeiou', 'AEIOU')
assert 'HELLO' == 'hello'.tr('a-z', 'A-Z'    )

// if replacementSet is smaller than sourceSet, then the last character from replacementSet is used as the replacement for all remaining source characters as shown here:
assert 'HAAAA WAAAA!' == 'Hello World!'.tr('a-z', 'A')

// if sourceSet contains repeated characters, the last specified replacement is used as shown here:
assert 'He224 W4r2d!' == 'Hello World!'.tr('lloo', '1234')
```

### tricky
#### [remove the last x chars](http://grails.asia/groovy-substring)
```groovy
def removeSuffix( String str ) {
  removeSuffix( str, 1 )
}

/**
 * remove the last char of {@code str}
 * @param str       the string will be removal the last char
 * @param c         remove last {@code c} numbers chars
**/
def removeSuffix( String str, int c ) {
  str.reverse().drop(c).reverse()
}
```

#### [add char(s) in the end of string](https://dzone.com/articles/concatenate-strings-in-groovy)
```groovy
str.concat('substr')
```

## comparation
### `equalsIgnoreCase`
```groovy
assert true == "HELLO World".equalsIgnoreCase( 'hello world' )
```

### `compareToIgnoreCase`
```groovy
assert 0 == "Hello World".compareToIgnoreCase( 'hello world' )
```

## repalce

### `reverse`
```groovy
assert '1234' == '4321'.reverse()
```

### `replaceAll`

> [!TIP]
> public String replaceAll(Pattern pattern, Closure closure)
> - replaces all occurrences of a captured group by the result of a closure call on that text.

```groovy
assert 'hellO wOrld'    == 'hello world'.replaceAll(~"(o)") { it[0].toUpperCase() }

assert 'FOOBAR-FOOBAR-' == 'foobar-FooBar-'.replaceAll(~"(([fF][oO]{2})[bB]ar)", { it[0].toUpperCase() })
// Here,
//   it[0] is the global string of the matched group
//   it[1] is the first string in the matched group
//   it[2] is the second string in the matched group

assert 'FOO-FOO-' == 'foobar-FooBar-'.replaceAll("(([fF][oO]{2})[bB]ar)", { x, y, z -> z.toUpperCase() })
// Here,
//   x is the global string of the matched group
//   y is the first string in the matched group
//   z is the second string in the matched group
```

### `replaceFirst`

> [!TIP]
> [public String replaceFirst(CharSequence regex, Closure closure)](https://docs.groovy-lang.org/latest/html/groovy-jdk/java/lang/CharSequence.html#replaceFirst(java.util.regex.Pattern,%20groovy.lang.Closure))
> - Replaces the first occurrence of a captured group by the result of a closure call on that text.

```groovy
assert 'hellO world' == 'hello world'.replaceFirst("(o)") { it[0].toUpperCase() }   // first match
assert 'hellO wOrld' == 'hello world'.replaceAll("(o)")   { it[0].toUpperCase() }   // all matches

assert '1-FISH, two fish' == 'one fish, two fish'.replaceFirst(/([a-z]{3})\s([a-z]{4})/) { [one:1, two:2][it[1]] + '-' + it[2].toUpperCase() }
assert '1-FISH, 2-FISH'   == 'one fish, two fish'.replaceAll(/([a-z]{3})\s([a-z]{4})/)   { [one:1, two:2][it[1]] + '-' + it[2].toUpperCase() }
```

### replaceAll with case-insensitive

> [!TIP|label:references:]
> - [How to replace case-insensitive literal substrings in Java](https://stackoverflow.com/a/5055036/2940319)
> - [Use replaceAll() to ignore case when replacing one substring with another](http://www.java2s.com/Code/Java/Regular-Expressions/UsereplaceAlltoignorecasewhenreplacingonesubstringwithanother.htm)
> - [Case insensitive String split() method](https://stackoverflow.com/a/16582115/2940319)
> - useful libs:
>   - [Class java.util.regex.Matcher](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Matcher.html)
>   - [Class java.util.regex.Pattern](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html)
>   - Special constructs (non-capturing) : [Constant Field Values](https://docs.oracle.com/javase/8/docs/api/constant-values.html#java.util.regex.Pattern.CASE_INSENSITIVE)
>     - `(?i)` : [public static final int CASE_INSENSITIVE](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#CASE_INSENSITIVE)
>     - `(?d)` : [public static final int UNIX_LINES](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#UNIX_LINES)
>     - `(?m)` : [public static final int MULTILINE](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#MULTILINE)
>     - `(?s)` : [public static final int DOTALL](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#DOTALL)
>     - `(?u)` : [public static final int UNICODE_CASE](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#UNICODE_CASE)
>     - `(?x)` : [public static final int COMMENTS](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#COMMENTS)
> - [tutorial: Methods of the Pattern Class](https://docs.oracle.com/javase/tutorial/essential/regex/pattern.html)
>   - [RegexTestHarness.java](https://docs.oracle.com/javase/tutorial/essential/regex/examples/RegexTestHarness.java)
> - [tutorial: Methods of the Matcher Class](https://docs.oracle.com/javase/tutorial/essential/regex/matcher.html)

| EQUIVALENT EMBEDDED FLAG EXPRESSION | CONSTANT                                                                                                            |
|:-----------------------------------:|---------------------------------------------------------------------------------------------------------------------|
|                `None`               | [Pattern.CANON_EQ](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#CANON_EQ)                 |
|                `(?i)`               | [Pattern.CASE_INSENSITIVE](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#CASE_INSENSITIVE) |
|                `(?x)`               | [Pattern.COMMENTS](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#COMMENTS)                 |
|                `(?m)`               | [Pattern.MULTILINE](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#MULTILINE)               |
|                `(?s)`               | [Pattern.DOTALL](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#DOTALL)                     |
|                `None`               | [Pattern.LITERAL](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#LITERAL)                   |
|                `(?u)`               | [Pattern.UNICODE_CASE](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#UNICODE_CASE)         |
|                `(?d)`               | [Pattern.UNIX_LINES](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#UNIX_LINES)             |

```groovy
String target                 = '++Apple@@Banana | aPPle##BanANa$$'
Map<String, String> p         = [ 'banana' : '--', 'apple' : '==' ]
assert '++==@@-- | ==##--$$' == p.inject('') { injected, k, v ->
                                  injected = ( injected ?: target ).replaceAll( "(?i)${k}", v );
                                  injected
                                }
```

- or
  ```groovy
  import java.util.regex.Pattern

  String parentPath = 'D:\\ifs\\APP\\Checkout'
  String path = 'D:\\IFS\\APP\\Checkout\\trvexp\\client\\Ifs.App\\text.txt'

  assert '\\trvexp\\client\\Ifs.App\\text.txt' == path.replaceAll( "(?i)" + Pattern.quote(parentPath), '' )
  ```

- [or](https://stackoverflow.com/a/11236723/2940319)
  ```groovy
  import java.util.regex.Pattern

  String label = 'table'
  String html  = '<table>aaa</table>'

  assert '<WINDOWS>aaa</WINDOWS>' == Pattern.compile(label, Pattern.CASE_INSENSITIVE).matcher(html).replaceAll("WINDOWS");
  ```

### [Apply proper uppercase and lowercase on a String](http://www.java2s.com/Code/Java/Regular-Expressions/ApplyproperuppercaseandlowercaseonaString.htm)

```groovy
import java.util.regex.Matcher
import java.util.regex.Pattern

String str = "this is a test"

StringBuffer sb = new StringBuffer()
Matcher m = Pattern.compile("([a-z])([a-z]*)", Pattern.CASE_INSENSITIVE).matcher(str)
while ( m.find() ) {
  m.appendReplacement( sb, m.group(1).toUpperCase() + m.group(2).toLowerCase() )
}
assert 'This Is A Test' == m.appendTail(sb).toString()
```

## split
### split string by Capital Letters

> [!NOTE|label:references:]
> - [Java: Split string when an uppercase letter is found](https://stackoverflow.com/a/3752693/2940319)
> - [Split String by Capital letters in Java](https://beginnersbook.com/2022/09/split-string-by-capital-letters-in-java/)
>   - `\p{Lu}` | `\p{Upper}` : shorthand for `\p{Uppercase Letter}`
>   - `\p{Ll}` | `\p{Lower}` : shorthand for `\p{Lowercase Letter}`
> - [Lookahead and Lookbehind Zero-Length Assertions](https://www.regular-expressions.info/lookaround.html)
> - [Java split is eating my characters](https://stackoverflow.com/q/2819933/2940319)
> - [Regex split string but keep separators](https://stackoverflow.com/q/2910536/2940319)
> - [Class java.util.regex.Pattern: POSIX character classes (US-ASCII only)](https://docs.oracle.com/javase/1.5.0/docs/api/java/util/regex/Pattern.html)
>   - `\p{Lower}` : A lower-case alphabetic character: `[a-z]`
>   - `\p{Upper}` : An upper-case alphabetic character: `[A-Z]`
>   - `\p{ASCII}` : All ASCII: `[\x00-\x7F]`
>   - `\p{Alpha}` : An alphabetic character: `[\p{Lower}\p{Upper}]`
>   - `\p{Digit}` : A decimal digit: `[0-9]`
>   - `\p{Alnum}` : An alphanumeric character: `[\p{Alpha}\p{Digit}]`
>   - `\p{Punct}` : Punctuation: One of `!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~`
>   - `\p{Graph}` : A visible character: `[\p{Alnum}\p{Punct}]`
>   - `\p{Print}` : A printable character: `[\p{Graph}\x20]`
>   - `\p{Blank}` : A space or a tab: `[ \t]`
>   - `\p{Cntrl}` : A control character: `[\x00-\x1F\x7F]`
>   - `\p{XDigit}` : A hexadecimal digit: `[0-9a-fA-F]`
>   - `\p{Space}` : A whitespace character: `[ \t\n\x0B\f\r]`

```groovy
// split by Uppercase
'IWantToSplitThisString'.split("(?=\\p{Lu})")
'IWantToSplitThisString'.split("(?=\\p{Upper})")
// result: ['I', 'Want', 'To', 'Split', 'This', 'String']

// split by Lowercase
'iwANTtOsPLITtHISsTRING'.split("(?=\\p{Ll})")
'iwANTtOsPLITtHISsTRING'.split("(?=\\p{Lower})")
// result: ['i', 'wANT', 'tO', 'sPLIT', 'tHIS', 'sTRING']
```

- [or via `[A-Z]`](https://stackoverflow.com/a/3752705/2940319)
  ```groovy
  assert ['this', 'Is', 'My', 'String'] == "thisIsMyString".split("(?=[A-Z])");
  ```

- [or via `String.format`](https://stackoverflow.com/a/2560017/2940319)
  ```groovy
  String splitCamelCase(String s) {
    return s.replaceAll(
      String.format("%s|%s|%s",
         "(?<=[A-Z])(?=[A-Z][a-z])",
         "(?<=[^A-Z])(?=[A-Z])",
         "(?<=[A-Za-z])(?=[^A-Za-z])"
      ),
    " "
    );
  }

  [
    "lowercase",
    "Class",
    "MyClass",
    "HTML",
    "PDFLoader",
    "AString",
    "SimpleXMLParser",
    "GL11Version",
    "99Bottles",
    "May5",
    "BFG9000",
  ].each { test ->
    System.out.println("${test.padRight(16)}: [" + splitCamelCase(test) + "]");
  }
  ```
  - result
    ```groovy
    lowercase       : [lowercase]
    Class           : [Class]
    MyClass         : [My Class]
    HTML            : [HTML]
    PDFLoader       : [PDF Loader]
    AString         : [A String]
    SimpleXMLParser : [Simple XML Parser]
    GL11Version     : [GL 11 Version]
    99Bottles       : [99 Bottles]
    May5            : [May 5]
    BFG9000         : [BFG 9000]
    ```

### split via patten

> [!NOTE|label:expect:]
> - original:
>   ```groovy
>   'h1:aaa:h2:bbb'
>   ```
> - expect:
>   ```groovy
>   '<h1>aaa</h1><h2>bbb</h2>'
>   ```

- via `inject`
  ```groovy
  String title = 'h1:aaa:h2:bbb'
  String pattern = 'h\\d'

  title.trim().split(':')
        .inject([:]) { injected, str ->
           key = str.matches(pattern) ? str : key
           injected[key] = injected.getOrDefault(key, '') + ( ! str.matches(pattern) ? ":${str}" : '')
           injected
        }
        .collectEntries {[ (it.key), it.value.tokenize(':').join(':') ]}
        .collect { "<${it.key}>${it.value}</${it.key}>" }
        .join()
  ```

- via `split`
  ```groovy
  String title = 'h1:aaa:h2:bbb'

  title.trim()
       .split( "(?=h\\d:)" )
       .collect{ it.tokenize(':') }
       .collectEntries{[ (it.first().trim()) : it.last().trim() ]}
       .collect{ "<${it.key}>${it.value}</${it.key}>" }
       .join()
  ```

## trim
### `stripIndent()`
```groovy
"""
    try{
        do this
    } finally {
        do that
    }
""".stripIndent()

==> output :
try{
    do this
} finally {
    do that
}
```

### `stripMargin()`
```groovy
"""try{
    |    do this
    |} finally {
    |    do that
    |}
""".stripMargin()

==> output :
try{
    do this
} finally {
    do that
}
```
- or
  ```groovy
  """try{
     *    do this
     *} finally {
     *    do that
     *}
  """.stripMargin( '*' )
  ```


## output format
### `expand`
```groovy
assert 'Groovy  Grails  Griffon'     == 'Groovy\tGrails\tGriffon'.expand()
assert 'Groovy    Grails    Griffon' == 'Groovy\tGrails\tGriffon'.expand(10)
```

### `unexpand`
```groovy
assert 'Groovy\tGrails\tGriffon' == 'Groovy  Grails  Griffon'.unexpand()
assert 'Groovy\tGrails\tGriffon' == 'Groovy    Grails    Griffon'.unexpand(10)
```

### `padRright`
```groovy
println 'world******'.padRight(15) + 'hello'
println 'world'.padRight(15) + 'hello'

// result
// world******    hello
// world          hello
```

- or
  ```groovy
  println 'world******'.padRight(15, '.') + 'hello'
  println 'world'.padRight(15, '.') + 'hello'

  // result
  // world******....hello
  // world..........hello
  ```

### `center`
```groovy
println " HEADER ".center(50, "-")
println "Number:".padRight(20)      + "20"
println "Name:".padRight(20)        + "John Doe"
println "Address:".padRight(20)     + "34 Some Street, London"
println "Subscriber:".padRight(20)  + "YES"
println "Expired:".padRight(20)     + "NO"

// result
// --------------------- HEADER ---------------------
// Number:             20
// Name:               John Doe
// Address:            34 Some Street, London
// Subscriber:         YES
// Expired:            NO
```

## size
### `count`
```groovy
assert 2 == 'Hello world'.count('o')
assert 2 == 'Hello worlld'.count('ll')
```

### `size`
```groovy
assert 11 == 'Hello world'.size()
assert 11 == 'Hello world'.length()
```

## random

> [!TIP]
> check also in [* imarslo : generate the random String](sugar.html#generate-the-random-string)
>
> references:
> - [How to generate a random password in Groovy?](https://e.printstacktrace.blog/how-to-generate-random-password-in-groovy/)
> - [aelindeman/password.groovy](https://gist.github.com/aelindeman/7a9d78aea5ba0004d1b5401303e241c5)
> - [groovy/example-01-generate-random-string.groovy](https://github.com/mszpiler/postman-soapui-training/blob/master/groovy/example-01-generate-random-string.groovy)
>
> NOTE:
> - `shuffled()` supports for Groovy 3+

### `shuffled`
```groovy
('0'..'z').shuffled().take(10).join()
```
- for number and chars only
  ```groovy
  (('a'..'z')+('A'..'Z')+(0..9)).shuffled().take(10).join()
  ```

### `java.util.Random`
```groovy
new java.util.Random().with { r ->
  def pool = ('a'..'z') + ('A'..'Z') + (0..9)
  (1..10).collect { pool[r.nextInt(pool.size())] }.join('')
}
```

## file

> [!NOTE|label:references:]
> - [Class File](https://docs.oracle.com/javase/8/docs/api/java/io/File.html)
> - [Class FilenameUtils](https://commons.apache.org/proper/commons-io/javadocs/api-1.4/org/apache/commons/io/FilenameUtils.html#getName(java.lang.String))
>   - [FilenameUtils.getName(String)](https://stackoverflow.com/a/39336223/2940319)
> - [Package java.nio.file](https://docs.oracle.com/javase/10/docs/api/java/nio/file/package-summary.html)
> - [Class Paths](https://docs.oracle.com/javase/10/docs/api/java/nio/file/Paths.html) VS. [Interface Path](https://docs.oracle.com/javase/10/docs/api/java/nio/file/Path.html#getFileName())
>   ```groovy
>   // https://stackoverflow.com/a/49019436/2940319
>   assert sun.nio.fs.UnixPath == java.nio.file.Paths.get( '/a/b/c/d.txt' ).getClass()
>   java.nio.file.Path path = java.nio.file.Paths.get( '/a/b/c/d.txt' )
>   ```
>   - [Path getFileName() method in Java with Examples](https://www.geeksforgeeks.org/path-getfilename-method-in-java-with-examples/)
> - [Java Files - java.nio.file.Files Class](https://www.digitalocean.com/community/tutorials/java-files-nio-files-class)

| IO                                                            | NIO                                                                     |
| ------------------------------------------------------------- | ----------------------------------------------------------------------- |
| `File file = new File( 'c:/data' )`<br>`file.createNewFile()` | `Path path = Paths.get( 'c:/data' )`<br>`Files.createFile(path)`        |
| `File file = new File( 'c:/data' )`<br>`file.mkdir()`         | `Path path = Paths.get( 'c:/data' )`<br>`Files.createDirectory(path)`   |
| `File file = new File( 'c:/data' )`<br>`file.mkdirs()`        | `Path path = Paths.get( 'c:/data' )`<br>`Files.createDirectories(path)` |
| `File file = new File( 'c:/data' )`<br>`file.exists()`        | `Path path = Paths.get( 'c:/data' )`<br>`Files.exists(path)`            |


- dirname
  ```groovy
  # via File
  assert '/a/b/c' == ( new File('/a/b/c/d.txt') ).getParentFile().toString()
  assert '/a/b/c' == ( new File('/a/b/c/d.txt') ).getParent()
  assert '/a/b/c' == ( new File('/a/b/c/d.txt') ).parent

  # via java.nio.file.Paths
  assert '/a/b/c' == java.nio.file.Paths.get( '/a/b/c/d.txt' ).getParent().toString()
  assert '/a/b/c' == jhava.nio.file.Paths.get( '/a/b/c/d.txt' ).parent.toString()
  ```

- basename
  ```groovy
  # via File
  assert 'd.txt' == (new File('/a/b/c/d.txt')).getName()
  assert 'd.txt' == (new File('/a/b/c/d.txt')).name

  # via java.nio.file.Paths
  assert 'd.txt' == java.nio.file.Paths.get( '/a/b/c/d.txt' ).getFileName().toString()
  assert 'd.txt' == java.nio.file.Paths.get( '/a/b/c/d.txt' ).fileName.toString()
  ```

- isDirectory || isFile
  ```groovy
  assert true  == ( new File('/Users/marslo/.vimrc') ).isFile()
  assert false == ( new File('/Users/marslo/.vimrc') ).isDirectory()
  ```

## [StringTokenizer](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/StringTokenizer.html)

> [!NOTE|label:references:]
> - [Class java.util.StringTokenizer](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/StringTokenizer.html)

```groovy
import java.util.StringTokenizer

StringTokenizer st = new StringTokenizer("this is a test");
while (st.hasMoreTokens()) { System.out.println(st.nextToken()); }
```

- output
  ```
  this
  is
  a
  test
  ```

- equals
  ```groovy
  String[] result = "this is a test".split("\\s");
  for (int x=0; x<result.length; x++)
      System.out.println(result[x]);
  ```

## URI

- amend URL

  > [!TIP|label:references:]
  > - [Java - Replace host in url?](https://stackoverflow.com/a/46669187/2940319)

  ```groovy
  Closure amendUrl = { String url, String authority ->
    URI uri = new URI( url )
    uri = new URI( uri.scheme, authority, uri.host, uri.port, uri.path, uri.query, uri.fragment )
    uri.toString()
  }

  amendUrl ( 'ssh://github.com/marslo/dotfiles', 'marslo:token' )

  // result
  // ssh://marslo:token@github.com/marslo/dotfiles
  ```
