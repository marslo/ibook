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

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> download
> - [apach software foundatin distribution directory](https://dlcdn.apache.org/)
> - [groovy](https://dlcdn.apache.org/groovy/)
>   - [2.4.21](https://dlcdn.apache.org/groovy/2.4.21/)
>   - [2.5.19](https://dlcdn.apache.org/groovy/2.5.19/)
>   - [3.0.13](https://dlcdn.apache.org/groovy/3.0.13/)
>   - [4.0.6](https://dlcdn.apache.org/groovy/4.0.6/)
> <br>
> reference:
> - [* Groovy Language Documentation](https://docs.groovy-lang.org/latest/html/documentation)
> - [* Groovy Scripting Reference](https://docs.oracle.com/en/cloud/saas/applications-common/21d/cgsac/index.html)
>   - [groovy basics](https://docs.oracle.com/en/cloud/saas/applications-common/21d/cgsac/groovy-basics.html#groovy-basics)
>   - [groovy tips and techniques](https://docs.oracle.com/en/cloud/saas/applications-common/21d/cgsac/groovy-tips-and-techniques.html#groovy-tips-and-techniques)
> - [* groovy cheatsheet](https://onecompiler.com/cheatsheets/groovy)
> - [* Groovy Cookbook](https://e.printstacktrace.blog/groovy-cookbook/)
> - [* varargs in Groovy](https://docs.groovy-lang.org/latest/html/documentation/#_varargs)
> - [varargs : Variable Arguments (Varargs) in Java](https://www.geeksforgeeks.org/variable-arguments-varargs-in-java/)
> - <kbd>[online compiler](https://onecompiler.com/groovy)</kbd>
> - [http://www.cheat-sheets.org/saved-copy/rc015-groovy_online.pdf](http://www.cheat-sheets.org/saved-copy/rc015-groovy_online.pdf)
> - [Syntax](https://groovy-lang.org/syntax.html)
> - [Five Cool Things You Can Do With Groovy Scripts](http://www.kellyrob99.com/blog/2011/12/04/five-cool-things-you-can-do-with-groovy-scripts/)
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
