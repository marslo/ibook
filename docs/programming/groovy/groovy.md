<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [basic](#basic)
  - [Customizable Operators](#customizable-operators)
  - [Special Operators](#special-operators)
- [string](#string)
  - [substring](#substring)
- [`list`](#list)
  - [filter a list](#filter-a-list)
  - [filter in list via additional conditions](#filter-in-list-via-additional-conditions)
  - [return result instead of original list](#return-result-instead-of-original-list)
  - [A List contains a sublist or not](#a-list-contains-a-sublist-or-not)
  - [pickup item in list random](#pickup-item-in-list-random)
  - [print 2D matrix](#print-2d-matrix)
- [`Map`](#map)
  - [change Map in condition](#change-map-in-condition)
  - [filter via condition](#filter-via-condition)
  - [find a `string` in a nested `Map` by using recursive function](#find-a-string-in-a-nested-map-by-using-recursive-function)
  - [find a `string` exists in a `list` of `Map`](#find-a-string-exists-in-a-list-of-map)
- [elvis operator](#elvis-operator)
  - [if/elseif{if}/else](#ifelseififelse)
- [execute shell commands in groovy](#execute-shell-commands-in-groovy)
  - [Get STDERR & STDERR](#get-stderr--stderr)
  - [Show output during the process](#show-output-during-the-process)
  - [with environment](#with-environment)
- [Closures](#closures)
  - [Closure VS. Method](#closure-vs-method)
  - [break from closure](#break-from-closure)
  - [Curry](#curry)
  - [Memoization](#memoization)
  - [Composition](#composition)
  - [Methods](#methods)
  - [tricky](#tricky)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> reference:
> - [Groovy Cheatsheet](https://onecompiler.com/cheatsheets/groovy)
> - <kbd>[online compiler](https://onecompiler.com/groovy)</kbd>
> - [http://www.cheat-sheets.org/saved-copy/rc015-groovy_online.pdf](http://www.cheat-sheets.org/saved-copy/rc015-groovy_online.pdf)

## basic
### Customizable Operators
|    Operator    | Method          |
|:--------------:|-----------------|
|      `a + b`     | `a.plus(b)`     |
|      `a - b`     | `a.minus(b)`    |
|      `a * b`     | `a.multiply(b)` |
|      `a / b`     | `a.div(b)`      |
|      `a % b`     | `a.mod(b)`      |
| `a++` or `++a` | `a.next()`      |

### Special Operators
|   Operator  | Meaning                                      | Name           |
|:-----------:|----------------------------------------------|----------------|
| `a ? b : c` | `if(a) b else c`                             | ternary if     |
|   `a ?: b`  | ` a ? a : b`                                 | Elvis          |
|    `a.?b`   | `( a==null ) ? a : a.b`                      | null safe      |
|  `a(*list)` | `a(list[0], list[1], ...)`                   | spread         |
| `list*.a()` | `[list[0].a, list[1].a, ...]`                | spread-out     |
|    `a.&b`   | reference to method b in object a as closure | method closure |
|  `a.@field` | direct field access                          | dot-at         |

- [`.&` : Method pointer operator](https://docs.groovy-lang.org/latest/html/documentation/core-operators.html#method-pointer-operator)
  ```groovy
  def str = 'example of method reference'
  def fun = str.&toUpperCase
  assert fun() == str.toUpperCase()
  println fun()

  // result
  EXAMPLE OF METHOD REFERENCE
  ```
  ```groovy
  class Person {
    String name
    Integer age
  }
  def list = [
    new Person( name: 'Bob'   , age: 42 ) ,
    new Person( name: 'Julia' , age: 35 )
  ]
  String describe(Person p) { "$p.name is $p.age" }

  def action = this.&describe
  def transform( List<Person> elements, Closure action ) {
    elements.inject([]){ result, e ->
      result << action(e)
      result
    }
  }

  println transform( list, action )
  // result
  // [Bob is 42, Julia is 35]
  ```

## string
### [substring](http://grails.asia/groovy-substring)
- remove the last x chars
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

- [add char(s) in the end of string](https://dzone.com/articles/concatenate-strings-in-groovy)
  ```groovy
  str.concat('substr')
  ```

## `list`
### filter a list
```groovy
[ 'baz1', 'baz2', 'baz3', 'abz1', 'zba2', 'bza3' ].findAll { it.contains 'baz' }
===> [baz1, baz2, baz3]
```

- [or](https://stackoverflow.com/a/27058389/2940319)
  ```groovy
  [['r':3],['r':5],['r':6],['r':11],['r':10]].findAll { (1..10).contains(it.r) }
  ===> [[r:3], [r:5], [r:6], [r:10]]
  ```

### [filter in list via additional conditions](https://stackoverflow.com/a/19791838/2940319)
```groovy
[
  [ id : 1 , age : 1 , weight : 25 ] ,
  [ id : 2 , age : 2 , weight : 20 ] ,
  [ id : 3 , age : 3 , weight : 25 ]
].findAll {
   it.age in [ 2, 3 ] || it.weight in [ 20, 25 ]
}.id
===> [1,2,3]
```

### [return result instead of original list](https://stackoverflow.com/a/20973116/2940319)
```groovy
[1, 2, 3, 4].findResults { ( it % 2 == 0 ) ? it / 2 : null }
===> [1, 2] ~> [2/2, 4/2]
```
```groovy
[1, 2, 3, 4].findAll { ( it % 2 == 0 ) ? it / 2 : null }
===> [2, 4]
```

### a list contains a sublist or not
```groovy
List parent = [ '1', '2', '3', 'a', 'b' ]
List sub    = [ 'a', '3' ]
sub.every{ parent.contains(it) }
```

- or `containsAll`
  ```groovy
  List parent = [ '1', '2', '3', 'a', 'b' ]
  List sub    = [ 'a', '3' ]
  parent.containsAll(sub)
  ```

- ignore case
  ```groovy
  sub.every{ parent.collect{ it.toLowerCase() }.contains( it.toLowerCase() ) }
  ```

### [pickup item in list random](https://www.baeldung.com/java-random-list-element)
- `Collections.shuffle`
  ```groovy
  List list = [ '1', '2', '3', 'a', 'b' ]
  Collections.shuffle( list )
  println list
  println parent.first()

  // result
  [2, b, 3, 1, a]
  2
  ```

- `Random().nextInt`
  ```groovy
  List list = [ '1', '2', '3', 'a', 'b' ]
  Random random = new Random()
  println list.get(random.nextInt(list.size()))
  println list.get(random.nextInt(list.size()))

  // result
  // 1
  // b
  ```

### print 2D matrix
```groovy
(1..255).collect { color ->
  " █${color}█ "
}.eachWithIndex{ c, idx ->
  print c
  if ( 4 == (idx+1)%6 ) { println '' }
}
```

## `Map`
### [change Map in condition](https://stackoverflow.com/a/20534222/2940319)
```groovy
[ 'a': 1, 'b': 2, 'c': 3 ].collectEntries { ( it.value > 1 ) ? [ "${it.key}" : 4 ] : it }
===> [a:1, b:4, c:4]
```
- or `[ it.key, 4 ]`
  ```groovy
  [ 'a': 1, 'b': 2, 'c': 3 ].collectEntries { ( it.value > 1 ) ? [ it.key, 4 ] : it }
  ```
- or `[ (it.key) : 4 ]`
  ```groovy
  [ 'a': 1, 'b': 2, 'c': 3 ].collectEntries { ( it.value > 1 ) ? [ (it.key) : 4 ] : it }
  ```

### filter via condition
```groovy
[ 'a': 1, 'b': 2, 'c': 3 ].findAll{ it.value > 1 }.collectEntries { [ it.key, 4 ] }
===> [b:4, c:4]
```

### find a `string` in a nested `Map` by using recursive function
```groovy
def hasValue( Map m, String value ) {
  m.containsValue(value) || m.values().find { v -> v instanceof Map && hasValue(v, value) }
}
```

- another version
  > inspired by [stackoverflow: How to search value by key from Map as well as Nested Map](https://stackoverflow.com/a/39749720/2940319)

```groovy
def hasValue( Map m, String value ) {
  if ( m.containsValue(value) ) return m.containsValue(value)
  m.findResult { k, v -> v instanceof Map ? hasValue(v, value) : null }
}
```

### find a `string` exists in a `list` of `Map`
```groovy
def isTargetExists( Map m, String subKey, String value ) {
  def map = m.findAll { it.value instanceof Map }.collect { it.key }
  return m.subMap(map).any { k, v -> v.get(subKey, []).contains(value) }
}

Map<String, Map<String, String>> matrix = [
  dev : [
    user: ['dev1', 'dev2', 'dev3'] ,
    passwd: '123456',
    customer: ['yahoo', 'bing']
  ] ,
  staging : [
    user: ['stg1', 'stg2', 'stg3'] ,
    passwd: 'abcdefg' ,
    customer: ['google', 'huawei']
  ] ,
  prod : [
    user: ['prod1', 'prod2', 'prod3'] ,
    passwd: 'a1b2c3d4'
  ]
]

assert isTargetExists( matrix, 'user', 'dev4' ) == false
assert isTargetExists( matrix, 'release', 'huawei' ) == true
```

## elvis operator
### if/elseif{if}/else
```groovy
// by using if/elseif{if}/else
Map option = [:]
if ( [ 'apple', 'orange' ].contains(fruits) ) {
  option = [ "${fruits}" : '5' ]
} else if ( [ 'watermelon' ].contains(fruits) ) {
  if (mode) {
    option = [ "${fruits}" : mode ]
  }
} else {
  println( 'basket CANNOT be empty while fruits is watermelon' )
}

// by using elvis operator
Map option = ( [ 'apple', 'orange' ].contains(fruits) ) ? [ "${fruits}" : '5' ]
           : ( [ 'watermelon' ].contains(fruits) ) ? ( mode )
              ? [ "${fruits}" : mode ]
              : println( 'basket CANNOT be empty while fruits is watermelon' )
           : null
```

## execute shell commands in groovy
> reference
> - [101 groovy script - Execute commands](https://groovy-lang.gitlab.io/101-scripts/basico/command_local-en.html)
> - [Jenkins Groovy script to execute shell commands](https://stackoverflow.com/a/46488427/2940319)
> - [java.lang.Process](http://docs.groovy-lang.org/latest/html/groovy-jdk/java/lang/Process.html)

### Get STDERR & STDERR

{% hint style='tip' %}
> using `new StringBuffer()` or `new StringBuilder()`
>
> i.e.:
> ```groovy
> def stdout = new StringBuffer(), stderr = new StringBuffer()
> def proc = "cmd".execute()
> proc.waitForProcessOutput( stdout, stderr )
> int exitCode = proc.exitValue()
> println( (exitCode == 0) ? stdout : "exit with ${exitCode}. error: ${stderr}" )
> ```
{% endhint %}

```groovy
def stdout = new StringBuilder(), stderr = new StringBuilder()

def proc = "ls /tmp/NoFile".execute()
proc.consumeProcessOutput( stdout, stderr )
proc.waitForOrKill( 1000 )

int exitCode = proc.exitValue()
println( ( exitCode == 0 ) ? stdout : "error with exit code ${exitCode}.\nSTDERR: ${stderr}" )
```

[or](https://stackoverflow.com/a/159270/2940319)
```groovy
def stdout = new StringBuilder(), stderr = new StringBuilder()
def proc = 'ls /tmp/NoFile'.execute()
proc.consumeProcesstdoutput( stdout, stderr )
proc.waitForOrKill(1000)
println( stdout ? "out> \n${stdout}" : '' + stderr ? "err> \n${stderr}" : '' )
```

### Show output during the process
> using `System.out` and `System.err`

```groovy
def proc = "ls /tmp/NoFile".execute()
proc.waitForProcessOutput( System.out, System.err )
proc.waitForOrKill(1000)

int exitCode = proc.exitValue()
if ( exitCode != 0 ) {
  println "error with exit code ${exitCode}."
}
```

### [with environment](https://stackoverflow.com/a/159270/2940319)
```groovy
def envVars = ["GROOVY_HOME=/fake/path/groovy-3.0.7", "CLASSPATH=.:/fake/path/groovy-3.0.7/lib"]

def proc = './run.sh'.execute( envVars, new File(".") )
proc.waitForProcessOutput( System.out, System.err )
int exitCode = proc.exitValue()

println( (exitCode != 0) ? "exit with ${exitCode}" : '' )
```

- `run.sh`
  ```bash
  env
  echo ${GROOVY_HOME}
  ```

- result
  ![execute with environemnt](../../screenshot/groovy/executeWithEnv.png)

#### with system environment
```groovy
List envVars = System.getenv().collect { k, v -> "${k}=${v}" }

def proc = "./run.sh".execute( envVars, new File(".") )
proc.waitForProcessOutput( System.out, System.err )
int exitCode = proc.exitValue()

println( (exitCode != 0) ? "exit with ${exitCode}" : '' )
```

#### [with partular path](https://gist.github.com/katta/5465317)
> reference:
> - [groovy execute shell with environment and working dir](https://gist.github.com/katta/5465317#gistcomment-3717156)

```groovy
def command = "git log -1"
def proc = command.execute( null, new File('/path/to/folder') )
proc.waitFor()

println """
  ${proc.err.text ?: ''}
  ${proc.in.text ?: ''}
  Process exit code: ${proc.exitValue()}
"""
```

## Closures
> references:
> - [Closures](https://groovy-lang.org/closures.html)
> - [Closures in Groovy](https://www.baeldung.com/groovy-closures)
> - [Groovy Goodness: Passing Closures to Methods](https://blog.mrhaki.com/2009/11/groovy-goodness-passing-closures-to.html)
> - [Groovy Goodness: Closure Arguments](https://blog.mrhaki.com/2009/11/groovy-goodness-closure-arguments.html)
> - [Groovy Goodness: Identity Closure](https://blog.mrhaki.com/2016/10/groovy-goodness-identity-closure.html)

{% hint style='tip' %}
> A closure definition follows this syntax:
> ```
>  { [closureParameters -> ] statements }
> ```
>
> closure.call()
> ```groovy
> Closure clos = { println "Hello World" }
> assert clos.call() == clos()
> ```
{% endhint %}

### [Closure VS. Method](https://www.baeldung.com/groovy-closures)
> closures have benefits over regular methods and are a powerful feature of Groovy:
> - We can pass a Closure as an argument to a method
> - Unary closures can use the implicit it parameter
> - We can assign a Closure to a variable and execute it later, either as a method or with call
> - Groovy determines the return type of the closures at runtime
> - We can declare and invoke closures inside a closure
> - Closures always return a value

- method
  ```groovy
  def formatToLowerCase(name) {
    name.toLowerCase()
  }
  ```

- closure
  ```groovy
  def formatToLowerCaseClosure = { name ->
    name.toLowerCase()
  }
  ```

### [break from closure](https://stackoverflow.com/a/19414187/2940319)
{% hint style='tip' %}
> tips:
> - `return` means continue
> - `return true` means break the loop
{% endhint %}

```groovy
def list = [1, 2, 3, 4, 5]
list.any { element ->
  if (element == 2)
    return // continue

  println element

  if (element == 3)
    return true // break
}
```

### Curry
- left curry
  ```groovy
  def nCopies = { int n, String... str -> str.join('')*n }
  def twice = nCopies.curry(2)
  println twice('|', '\\', '|', '/' )
  assert twice('|', '\\', '|', '/' ) == nCopies( 2, '|', '\\', '|', '/' )
  ```
  - result
  ```
  |\|/|\|/
  ```

- others left curry
  ```groovy
  def multiConcat = { int n, String... args ->
    args.join('')*n
  }
  multiConcat( 3, '*', '-', '=' )
  ```
  - result
    ```
    *-=*-=*-=
    ```

- right curry
  ```groovy
  def nCopies = { int n, String str -> str*n }
  def twice = nCopies.rcurry( '*-=*=-*' )
  println twice(2)
  assert twice(2) == nCopies( 2, '*-=*=-*' )
  ```
  - result
  ```
  *-=*=-**-=*=-*
  ```

- index with curry
  ```groovy
  def volume = { int l, int w, int h -> "l: ${l}\nw: ${w}\nh: ${h}" }
  def fixedWidthVolume = volume.ncurry(1, 2)
  println fixedWidthVolume( 3, 4 )
  ```
  - result
    ```groovy
    l: 3
    w: 2
    h: 4
    ```

### Memoization

- Fibonacci suite

{% hint style='tip' %}
> - `fib(15)` == `fib(14)` + `fib(13)`
> - `fib(14)` == `fib(13)` + `fib(12)`
{% endhint %}

- slow
  ```groovy
  def fib
  fib = { long n -> n<2 ? n : fib(n-1) + fib(n-2) }
  println fib(10)

  // result
  55
  ```
- fast
  > tips: `Closures.memoize()`

  ```groovy
  def fib
  fib = { long n -> n<2 ? n : fib(n-1) + fib(n-2) }.memoize()
  fib(50)

  // result
  12586269025
  ```

### Composition
```groovy
def plus2  = { it + 2 }
def times3 = { it * 3 }
def times3plus2 = plus2 << times3
//                  |        + execute first
//                  + execute second
// result
assert times3plus2(3) == 3*3+2
assert times3plus2(3) == plus2(times3(3))

def plus2times3 = plus2 >> times3
//                  |        + execute last
//                  + execute first
// result
assert plus2times3(3) == (3+2)*3
assert plus2times3(3) == times3(plus2(3))
```

{% hint style='tip' %}
```groovy
assert ( plus2 << times3 )(3)   ==   ( times3 >> plus2 )(3)
           |        + execute first      |       + execute last
           + execute last                + execute first
```
{% endhint %}


### Methods
- various method to call closure
  ```groovy
  def work( String input, Closure cl ) {
    cl(input)
  }

  def assertJava = {
    it == 'Java'
  }

  println work( "Java", assertJava )
  println work("Java", { it == 'Java' }) // ==> work 'Java', { it == 'Java' }
  println work( 'Java' ){
    it == 'Java'
  }
  ```
- frequent usage
  ```groovy
  def on( String name, String dString = 'is' ) {
    [
      skip: { -> println "no params. skip" },

      foo: { String f, Map fmap ->
        foo( name, dString, f, fmap )
        [
          bar: { Map map -> bar( '', map ) }
        ]
      } ,

      bar: { Map map -> bar( name, map ) }
    ]
  }

  def reset( Map m ) {
    m.collect{ k, v -> "${k} : ${v}" }.join('\n')
  }

  def foo( String n, String ds, String f, Map m ) {
    println "${n} ${ds} ${f} !\ndetails :\n\t\t${reset(m)}"
  }

  def bar( String n = '', Map m ) {
    println "${n ? "${n}\n": ''}\t\t${reset(m)}"
  }
  ```
  - result
    ```groovy
    on('marslo')
      .foo( 'awesome', [ 'age' : 34 ] )
      .bar( ['gender' : 'female' ] )

    // result
    marslo is awesome !
    details :
        age : 34
        gender : female
    ```

  or
  ```groovy
  on('marslo')
    .skip()

  // result
  no params. skip
  ```

### tricky
- `this`
  ```groovy
  class Enclosing {
    void run() {
      def whatIsThisObject = { getThisObject() }
      assert whatIsThisObject() == this

      def whatIsThis = { this }
      assert whatIsThis() == this
    }
  }

  Enclosing e = new Enclosing()
  e.run()
  ```
