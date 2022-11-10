<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [String](#string)
  - [convert](#convert)
    - [`capitalize`](#capitalize)
    - [uncapitalize](#uncapitalize)
    - [`toLowerCase`](#tolowercase)
    - [`toUpperCase`](#touppercase)
  - [substring](#substring)
    - [string indexing](#string-indexing)
    - [`minus`](#minus)
    - [`take`](#take)
    - [`takeRight`](#takeright)
    - [`takeAfter`](#takeafter)
    - [`takeBefore`](#takebefore)
    - [`takeBetween`](#takebetween)
    - [`takeWhile`](#takewhile)
    - [drop](#drop)
    - [dropWhile](#dropwhile)
    - [`tr`](#tr)
    - [tricky](#tricky)
  - [comparation](#comparation)
    - [`equalsIgnoreCase`](#equalsignorecase)
    - [`compareToIgnoreCase`](#comparetoignorecase)
  - [repalce](#repalce)
    - [`reverse`](#reverse)
    - [`replaceAll`](#replaceall)
    - [`replaceFirst`](#replacefirst)
  - [strip](#strip)
    - [`stripIndent()`](#stripindent)
    - [`stripMargin()`](#stripmargin)
  - [show](#show)
    - [expand](#expand)
    - [unexpand](#unexpand)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


# String

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
{% endhint %}

## convert
### `capitalize`
```groovy
assert 'Groovy' == 'groovy'.capitalize()
```

### uncapitalize
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
assert 'Hello ' == "Hello World".minus( 'World' )
assert ' World' == "Hello World".minus( 'Hello' )
```

### `take`
```groovy
assert 'G'   == 'Groovy'.take(1)
assert 'Gr'  == 'Groovy'.take(2)
assert 'Gro' == 'Groovy'.take(3)
```

### `takeRight`

> [!TIP]
> returns the last num elements from this CharSequence.

```groovy
assert ''    == 'Groovy'.takeRight( 0 )
assert 'y'   == 'Groovy'.takeRight( 1 )
assert 'ovy' == 'Groovy'.takeRight( 3 )
```


### `takeAfter`
```groovy
assert ' development. Groovy team' == 'Groovy development. Groovy team'.takeAfter( 'Groovy' )
assert 'team'                      == 'Groovy development. Groovy team'.takeAfter( ' Groovy ' )
```

### `takeBefore`
```groovy
assert 'Groovy '            == 'Groovy development. Groovy team'.takeBefore( 'development' )
assert 'Groovy development' == 'Groovy development. Groovy team'.takeBefore( '. Groovy ' )
```

### `takeBetween`
```groovy
assert ' development. ' == 'Groovy development. Groovy team'.takeBetween( 'Groovy' )
assert 'marslo'         == 'name = "marslo"'.takeBetween( '"' )

assert '10'  == "t1='10' ms, t2='100' ms".takeBetween( "'"    )
assert '10'  == "t1='10' ms, t2='100' ms".takeBetween( "'", 0 )
assert '100' == "t1='10' ms, t2='100' ms".takeBetween( "'", 1 )
```

### `takeWhile`

> [!TIP]
> returns the longest prefix of this CharSequence where each element passed to the given closure evaluates to true.

```groovy
assert ''   == 'Groovy'.takeWhile{ it < 'A'  }
assert 'G'  == 'Groovy'.takeWhile{ it < 'a'  }
assert 'Gr' == 'Groovy'.takeWhile{ it != 'o' }
```

### drop
```groovy
assert 'ovY' == 'GroovY'.drop(3)
assert ''    == 'GroovY'.drop(10)
```

### dropWhile

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


## strip
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


## show
### expand
```groovy
assert 'Groovy  Grails  Griffon'     == 'Groovy\tGrails\tGriffon'.expand()
assert 'Groovy    Grails    Griffon' == 'Groovy\tGrails\tGriffon'.expand(10)
```

### unexpand
```groovy
assert 'Groovy\tGrails\tGriffon' == 'Groovy  Grails  Griffon'.unexpand()
assert 'Groovy\tGrails\tGriffon' == 'Groovy    Grails    Griffon'.unexpand(10)
```