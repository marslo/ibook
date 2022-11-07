<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [basic](#basic)
  - [Program structure](#program-structure)
  - [Customizable Operators](#customizable-operators)
  - [Special Operators](#special-operators)
- [elvis operator](#elvis-operator)
  - [if/elseif{if}/else](#ifelseififelse)
- [execute shell commands in groovy](#execute-shell-commands-in-groovy)
  - [Get STDERR & STDERR](#get-stderr--stderr)
  - [Show output during the process](#show-output-during-the-process)
  - [with environment](#with-environment)
- [Closures](#closures)
  - [Closure VS. Method](#closure-vs-method)
  - [break from closure](#break-from-closure)
  - [curry](#curry)
  - [Memoization](#memoization)
  - [composition](#composition)
  - [Methods](#methods)
  - [tricky](#tricky)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [* Groovy Scripting Reference](https://docs.oracle.com/en/cloud/saas/applications-common/21d/cgsac/index.html)
>   - [groovy basics](https://docs.oracle.com/en/cloud/saas/applications-common/21d/cgsac/groovy-basics.html#groovy-basics)
>   - [groovy tips and techniques](https://docs.oracle.com/en/cloud/saas/applications-common/21d/cgsac/groovy-tips-and-techniques.html#groovy-tips-and-techniques)
> - [* groovy cheatsheet](https://onecompiler.com/cheatsheets/groovy)
> - <kbd>[online compiler](https://onecompiler.com/groovy)</kbd>
> - [http://www.cheat-sheets.org/saved-copy/rc015-groovy_online.pdf](http://www.cheat-sheets.org/saved-copy/rc015-groovy_online.pdf)
> - [Syntax](https://groovy-lang.org/syntax.html)
> - [Java SE Specifications download](https://docs.oracle.com/javase/specs/)
>   - The Java Language Specification, Java SE 19 Edition : [pdf](https://docs.oracle.com/javase/specs/jls/se19/jls19.pdf) | [html](https://docs.oracle.com/javase/specs/jls/se19/html/index.html)
>   - The Java Language Specification, Java SE 18 Edition : [pdf](https://docs.oracle.com/javase/specs/jls/se18/jls18.pdf) | [html](https://docs.oracle.com/javase/specs/jls/se18/html/index.html)
>   - The Java Language Specification, Java SE 17 Edition : [pdf](https://docs.oracle.com/javase/specs/jls/se17/jls17.pdf) | [html](https://docs.oracle.com/javase/specs/jls/se17/html/index.html)
>   - The Java Language Specification, Java SE 16 Edition : [pdf](https://docs.oracle.com/javase/specs/jls/se16/jls16.pdf) | [html](https://docs.oracle.com/javase/specs/jls/se16/html/index.html)
>   - The Java Language Specification, Java SE 15 Edition : [pdf](https://docs.oracle.com/javase/specs/jls/se15/jls15.pdf) | [html](https://docs.oracle.com/javase/specs/jls/se15/html/index.html)
>   - The Java Language Specification, Java SE 14 Edition : [pdf](https://docs.oracle.com/javase/specs/jls/se14/jls14.pdf) | [html](https://docs.oracle.com/javase/specs/jls/se14/html/index.html)
>   - The Java Language Specification, Java SE 13 Edition : [pdf](https://docs.oracle.com/javase/specs/jls/se13/jls13.pdf) | [html](https://docs.oracle.com/javase/specs/jls/se13/html/index.html)
>   - The Java Language Specification, Java SE 12 Edition : [pdf](https://docs.oracle.com/javase/specs/jls/se12/jls12.pdf) | [html](https://docs.oracle.com/javase/specs/jls/se12/html/index.html)
>   - The Java Language Specification, Java SE 11 Edition : [pdf](https://docs.oracle.com/javase/specs/jls/se12/jls11.pdf) | [html](https://docs.oracle.com/javase/specs/jls/se11/html/index.html)
{% endhint %}

> [!TIP]
> [Java Tutorial](https://jenkov.com/tutorials/java/index.html) :
> - [Java Exception Handling](https://jenkov.com/tutorials/java-exception-handling/index.html)
> - [Java Tips, How-tos etc](https://jenkov.com/tutorials/java-howto/index.html)
> - [Java JSON Tutorial](https://jenkov.com/tutorials/java-json/index.html)
> - [Java Logging](https://jenkov.com/tutorials/java-logging/index.html)
> - [Java Performance](https://jenkov.com/tutorials/java-performance/index.html)
> - [Java Regex - Java Regular Expressions](https://jenkov.com/tutorials/java-regex/index.html)
> - [Java Unit Testing](https://jenkov.com/tutorials/java-unit-testing/index.html)

## basic
### [Program structure](https://groovy-lang.org/structure.html)
### Customizable Operators
| Operator         | Method            |
| :--------------: | ----------------- |
| `a + b`          | `a.plus(b)`       |
| `a - b`          | `a.minus(b)`      |
| `a * b`          | `a.multiply(b)`   |
| `a / b`          | `a.div(b)`        |
| `a % b`          | `a.mod(b)`        |
| `a++` or `++a`   | `a.next()`        |

{% hint style='tip' %}
> ```groovy
> assert [ a: true, b: false ]  +  [ a: false ] == [ a: false, b: false ]
> assert [ a: true, b: false  ] << [ a: false ] == [ a: false, b: false ]
> ```
> - [difference `+`(plus) and `<<`(left shift)](https://stackoverflow.com/a/13326983/2940319) :
>   - [`<<` is to add into left hand map](https://github.com/groovy/groovy-core/blob/GROOVY_2_4_X/src/main/org/codehaus/groovy/runtime/DefaultGroovyMethods.java#L12296)
>   - [`+` it constructs a new Map based on the LHS`](https://github.com/groovy/groovy-core/blob/GROOVY_2_4_X/src/main/org/codehaus/groovy/runtime/DefaultGroovyMethods.java#L7433)
{% endhint %}

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

## elvis operator
### if/elseif{if}/else

{% hint style='tip' %}
> references:
> - [5.3. Elvis operator](https://groovy-lang.org/operators.html#_elvis_operator)
> - [Groovy Goodness: The Elvis Assignment Operator](https://blog.mrhaki.com/2020/02/groovy-goodness-elvis-assignment.html)
>
> usage
> - `?:` ( existing Elvis operator )
>   ```groovy
>   displayName = user.name ? user.name : 'Anonymous'
>   displayName = user.name ?: 'Anonymous'
>   ```
> - `?=` ( new elvis assignment shorthand )
>   ```groovy
>   name = name ?: 'Hydrogen'   // existing Elvis operator
>   atomicNumber ?= 2           // new Elvis assignment shorthand
>   ```
{% endhint %}

> condition:
> - if `fruits` is 'apple' or 'orange', get pre-defined number `5` ( `number = 5` )
> - if `fruits` is `watermelon`, get particular given `numbers`. `number` cannot be `null`

```groovy
// by using if/elseif{if}/else
Map option = [:]
if ( [ 'apple', 'orange' ].contains(fruits) ) {
  option = [ "${fruits}" : '5' ]
} else if ( [ 'watermelon' ].contains(fruits) ) {
  if (number) {
    option = [ "${fruits}" : number ]
  }
} else {
  println( 'ERROR: number CANNOT be empty while fruits is watermelon. Exit ...' )
}

// by using elvis operator
Map option = ( [ 'apple', 'orange' ].contains(fruits) ) ? [ "${fruits}" : '5' ]
           : ( [ 'watermelon' ].contains(fruits) ) ? ( number )
              ? [ "${fruits}" : number ]
              : println( 'ERROR: number CANNOT be empty while fruits is watermelon. Exit ...' )
           : [:]
```

- example
  ```groovy
  Closure option = { String fruits, String number = '' ->
      ( [ 'apple', 'orange' ].contains(fruits) ) ? [ (fruits) : '5' ]
      : ( [ 'watermelon' ].contains(fruits) ) ? ( number )
        ? [ (fruits) : number ]
        : println( 'ERROR: number CANNOT be empty while fruits is watermelon. Exit ...' )
      : [:]
  }

  assert option('apple') == ['apple' : '5']
  assert option('watermelon', '100') == [ 'watermelon' : '100' ]
  ```

  {% hint style='tip' %}
  > - using `[ "${fruits}" : '5' ]`, the class of key is `class org.codehaus.groovy.runtime.GStringImpl`
  > - using `[ (fruits) : '5' ]`   , the class of key is `class java.lang.String`
  {% endhint %}


## execute shell commands in groovy

{% hint style='tip' %}
> reference
> - [101 groovy script - Execute commands](https://groovy-lang.gitlab.io/101-scripts/basico/command_local-en.html)
> - [Jenkins Groovy script to execute shell commands](https://stackoverflow.com/a/46488427/2940319)
> - [java.lang.Process](http://docs.groovy-lang.org/latest/html/groovy-jdk/java/lang/Process.html)
> - [gist: Run shell command in groovy](https://gist.github.com/remen/31e798670783261c8a93)
{% endhint %}

### Get STDERR & STDERR

> [!TIP]
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

{% hint style='tip' %}
> using `System.out` and `System.err`
{% endhint %}

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
> - [实战 Groovy: 用 curry 过的闭包进行函数式编程](https://wizardforcel.gitbooks.io/ibm-j-pg/content/10.html)

{% hint style='tip' %}
> A closure definition follows this syntax:
> ```
>  { [closureParameters -> ] statements }
> ```
>
> [closure.call()](https://wizardforcel.gitbooks.io/ibm-j-pg/content/9.html)
> ```groovy
> Closure clos = { println "Hello World" }
> assert clos.call() == clos()
>            |           + implicit call
>            + explicit call
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
  def formatToLowerCase( String name ) {
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

### curry
- left curry
  ```groovy
  def multiply = { x, y -> return x * y }
  def triple = multiply.curry(3)           // triple = { y -> return 3 * y }
  ```

- example
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

  > [!TIP]
  > ```groovy
  > def nCopies = { int n, String str -> str*n }
  >
  > def twice   = nCopies.rcurry( '*-=*=-*' )
  > def divider = nCopies.curry( 2 )
  >
  > assert nCopies( 2, '*-=*=-*' ) == twice( 2 )                // right curry
  > assert nCopies( 2, '-.-.-.-' ) == divider( '-.-.-.-' )      // left  curry
  > ```

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

{% hint style='tip' %}
**Fibonacci suite** :
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

### composition
#### double composition
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
> ```groovy
> assert ( plus2 << times3 )(3)   ==   ( times3 >> plus2 )(3)
>            |        + execute first      |       + execute last
>            + execute last                + execute first
```
{% endhint %}

- [example for recursive in List](https://stackoverflow.com/a/62804996/2940319)
  ```groovy
  def map1 = [a: 10, b:2, c:3]
  def map2 = [b:3, c:2, d:5]
  def maps = [map1, map2]

  def process(def maps, Closure myLambda) {
    maps.sum { it.keySet() }.collectEntries { key ->
      [ key,
        { x ->
          x.subList(1, x.size()).inject(x[0], myLambda)
        }(maps.findResults { it[key] })
      ]
    }
  }

  def sumResult  = process(maps) { a, b -> a + b }
  def prodResult = process(maps) { a, b -> a * b }
  def minResult  = process(maps) { a, b -> a < b ? a : b }

  assert sumResult  == [a:10, b:5, c:5, d:5]
  assert prodResult == [a:10, b:6, c:6, d:5]
  assert minResult  == [a:10, b:2, c:2, d:5]
  ```
  - Resolution
    ```groovy
    assert [2,4,5].inject(1){ a, b -> a + b  }   == 12
    assert [2,4,5].inject(1, { a, b -> a + b  }) == 12
    ```

#### triple composition
```groovy
def multiply = { x, y -> return x * y }
def triple = multiply.curry(3)
def quadruple = multiply.curry(4)
def composition = { f, g, x -> return f(g(x)) }
def twelveTimes = composition.curry(triple, quadruple)      //  twelveTimes = { y -> composition { y -> 3*(4*y) } }
def threeDozen = twelveTimes(3)
```

### Methods
- various method to call closure
  ```groovy
  def work( String input, Closure cl ) {
    cl(input)
  }

  Closure assertJava = {
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
#### `this`
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
