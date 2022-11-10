<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [common](#common)
  - [String](#string)
  - [Boolean](#boolean)
  - [get the first item if exists or null if empty](#get-the-first-item-if-exists-or-null-if-empty)
  - [split and trim in string](#split-and-trim-in-string)
  - [`indices` & `indexed()`](#indices--indexed)
  - [elegant way to merge Map&#60;String, List&#60;String&#62;&#62; structure by using groovy](#elegant-way-to-merge-map60string-list60string6262-structure-by-using-groovy)
  - [fuzzy search and merge `Map<String, Map<String, Map<String, String>>>`](#fuzzy-search-and-merge-mapstring-mapstring-mapstring-string)
  - [groupBy `List<List<String>>` to `Map<String, List>`](#groupby-listliststring-to-mapstring-list)
  - [get object id (`python -c 'id('abc')`)](#get-object-id-python--c-idabc)
  - [loop if not empty](#loop-if-not-empty)
  - [getField()](#getfield)
  - [generate the random String](#generate-the-random-string)
- [run groovy from docker](#run-groovy-from-docker)
- [MetaClass](#metaclass)
  - [get supported methods](#get-supported-methods)
  - [A Bit of metaClass DSL](#a-bit-of-metaclass-dsl)
  - [get class name](#get-class-name)
  - [dynamically call methods](#dynamically-call-methods)
- [others](#others)
  - [groovy cli (args) with options](#groovy-cli-args-with-options)
  - [Get variable value for its name](#get-variable-value-for-its-name)
  - [groovy.lang.Binding](#groovylangbinding)
- [load groovy file](#load-groovy-file)
  - [`GroovyShell()`](#groovyshell)
  - [`GroovyClassLoader()`](#groovyclassloader)
  - [metaClass](#metaclass)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [Groovy Cookbook](https://e.printstacktrace.blog/groovy-cookbook/)
>   - [Three Groovy String methods that will make your life Groovier!](https://e.printstacktrace.blog/groovy-string-methods-that-will-make-your-life-groovier/)
>   - [Groovy: split string and avoid getting IndexOutOfBoundsException](https://e.printstacktrace.blog/groovy-split-string-and-avoid-getting-index-out-of-bounds-exception/)
{% endhint %}


## common

### String
```groovy
println " HEADER ".center(50, "-")
println "Number".padRight(20)      + ": 20"
println "Name".padRight(20)        + ": John Doe"
println "Address".padRight(20)     + ": 34 Some Street, London"
println "Subscriber".padRight(20)  + ": YES"
println "Expired".padRight(20)     + ": NO"
```

- result
  ```
  --------------------- HEADER ---------------------
  Number              : 20
  Name                : John Doe
  Address             : 34 Some Street, London
  Subscriber          : YES
  Expired             : NO
  ```

### Boolean

{% hint style='tip' %}
> usage scenarios:
> ```groovy
> Boolean doMap( Map m ) { return true|false }
> if ( map ) {
>   doMap( map )
> } else {
>   return true
> }
>
> ==> map ? doMap(map) : true
>
> ==> ! map || doMap(map)
> ```
>
> <kbd>[try online](https://onecompiler.com/groovy/3yn95j3ge)</kbd>
{% endhint %}

```groovy
assert ( true ? foo() : true ) == ( ! true || foo() )
```

#### substring for integers
```groovy
String str = 'abc12'
assert 'abc' == "${str - ~/\d+\s*/}"
```

### get the first item if exists or null if empty
```groovy
assert [:]?.find{true} == null
assert []?.find{true} == null
assert ['a']?.find{true} == 'a'
['a': '1'].find{ true }.each { println it.key + ' ~> ' + it.value }
println (['a': '1'].find{ true }.getClass())

// result
// a ~> 1
// class java.util.LinkedHashMap$Entry
```

### split and trim in string
- [spread operator](https://groovy-lang.org/operators.html#_spread_operator): `*.`
  ```groovy
  groovy:000> 'a  , b, ccc  ,d'.split(',')*.trim()
  ===> [a, b, ccc, d]
  ```

- [regular expression `\s*<opt>\s*`](https://stackoverflow.com/a/41953571/2940319)
  ```groovy
  groovy:000> 'a  , b, ccc  ,d'.trim().split("\\s*,\\s*")
  ===> [a, b, ccc, d]
  ```


### `indices` & `indexed()`
```groovy
def rows = ['foo', 'bar']
println rows.indices
println rows.indexed()

===> result
0..<2
[0:foo, 1:bar]
```

- [usage](https://stackoverflow.com/a/34637213/2940319)
  ```groovy
  def userList = [
    [name: 'user1', id:0, ip: '127.0.0.1'],
    [name: 'user2', id:1, ip: '127.0.0.2'],
    [name: 'user3', id:2, ip: '127.0.0.3']
  ]
  def rows = ['foo', 'bar']

  println rows.indices.collect { index ->                   // Using indices
    userList.find { it.id == index }
  }
  println rows.indexed().collect { index, item ->           // Using indexed()
    userList.find { it.id == index }
  }

  ===> result
  [[name:user1, id:0, ip:127.0.0.1], [name:user2, id:1, ip:127.0.0.2]]
  [[name:user1, id:0, ip:127.0.0.1], [name:user2, id:1, ip:127.0.0.2]]
  ```


### [elegant way to merge Map&#60;String, List&#60;String&#62;&#62; structure by using groovy](https://stackoverflow.com/q/62466451/2940319)

<table>
<tr> <td> original Map structure </td> <td> wanted result</td> </tr>
<tr> <td>
<pre lang="groovy"><code lang="groovy">
Map&#60;String, List&#60;String&#62;&#62; case_pool = [
  dev : [
    funcA : ['devA'] ,
    funcB : ['devB'] ,
    funcC : ['devC']
  ],
  'dev/funcA' : [
    funcA : ['performanceA']
  ],
  'dev/funcA/feature' : [
    funcA : ['performanceA', 'feature']
  ],
  staging : [
   funcB : ['stgB'] ,
   funcC : ['stgC']
  ]
]
</code></pre>
</td> <td>
<pre lang="groovy"><code>
String branch = 'dev/funcA/feature-1.0'

result:
[
  funcA: [ "devA", "performanceA", "feature" ],
  funcB: [ "devB" ],
  funcC: [ "devC" ]
]
</code></pre>
</td>
</tr>
</table>


- original map structure:
  ```groovy
  Map<String, List<String>> case_pool = [
    dev : [
      funcA : ['devA'] ,
      funcB : ['devB'] ,
      funcC : ['devC']
    ],
    'dev/funcA' : [
      funcA : ['performanceA']
    ],
    'dev/funcA/feature' : [
      funcA : ['performanceA', 'feature']
    ],
    staging : [
     funcB : ['stgB'] ,
     funcC : ['stgC']
    ]
  ]
  ```

- method 1st: by using loop
  ```groovy
  String branch = 'dev/funcA/feature-1.0'
  def result = [:].withDefault { [] as Set }
  case_pool.keySet().each {
    if ( branch.contains(it) ) {
      case_pool.get(it).each { k, v ->
        result[k].addAll(v)
      }
    }
  }
  println 'result: ' + result
  ```

- method 2nd: by using closure
  ```groovy
  String branch = 'dev/funcA/feature-1.0'
  def result = [:].withDefault { [] as Set }
  case_pool.findAll{ k, v -> branch.contains(k) }
           .collectMany{ k, v ->
              v.collect{ c, l ->
                result[c].addAll(l)
              }
            }
  println 'result: ' + result
  ```

- method 3rd: by using closure elegantly
  ```groovy
  def result = case_pool.inject([:].withDefault { [] as Set }) { result, key, value ->
    if (branch.contains(key)) {
      value.each { k, v -> result[k] += v }
    }; result
  }
  println 'result: ' + result
  ```

### fuzzy search and merge `Map<String, Map<String, Map<String, String>>>`
```groovy
/**
 * "fuzzy" search and merge the {@code Map<String, Map<String, String>>} according to keywords.
 * To replace the hardcode 'keyword' search {@code case_pool.get(stg).get(keyword).values()}. example:
 * <pre><code>
 * keyword = 'dev/funcA/feature1'
 * fuzzyFindAll( case_pool, keyword )
 *  => Result: [funcA:[devA, performanceA, feature], funcB:[devB], funcC:[devC]]
 * </pre></code>
 *
 * @param map       the map structure for {@code Map<String, Map<String, String>>}
 * @param keyword   use branch as keyword normally
**/
def fuzzyFindAll( Map map, String keyword ) {
  Map result = [:]
  map.findAll{ k, v -> keyword.toLowerCase().contains(k.toLowerCase()) }.collect { k, v ->
    v.each { key, value ->
      result[key] = [ result.getOrDefault(key,[]) + value ].flatten().unique()
    }
  }
  return result
}
```

### [groupBy `List<List<String>>` to `Map<String, List>`](https://stackoverflow.com/questions/40981393/group-by-in-groovy)
> requirements:
>
> `[ ["GX 470","Model"], ["Lexus","Make"], ["Jeep","Make"], ["Red","Color"], ["blue","Color"] ]`
>
>   ⇣⇣
>
> `["Model":["GX 470"],"Make":["Lexus","Jeep"],"Color":["Red", "blue"]]`

- solution
  ```groovy
  def list = [
      ["GX-470","Model"],
      ["Lexus","Make"],
      ["Jeep","Make"],
      ["Red","Color"],
      ["blue","Color"]
  ]

  list.groupBy{ it[1] }.collectEntries{ k, v -> [(k): v.collect{it.get(0)}] }
  ```

[alternatives](https://stackoverflow.com/a/40982023/2940319)
  ```groovy
  list.inject([:].withDefault{[]}) { map, elem ->
    map[elem[1]] << elem[0]
    map
  }
  ```

### get object id (`python -c 'id('abc')`)
```groovy
java.lang.System.identityHashCode( obj )
```
- example
  ```bash
  String s = 'abc'
  String x = s
  println java.lang.System.identityHashCode(s)
  println java.lang.System.identityHashCode(x)
  x = s + 'aa'
  println java.lang.System.identityHashCode(x)

  ==>
  51571311
  51571311
  733591550
  ```

- example for `identityHashCode() and hashCode()`
  ```groovy
  String a = new String("hhh")
  String b = new String("hhh")

  assert System.identityHashCode(a) != System.identityHashCode(b)
  assert a.hashCode() == b.hashCode()
  ```

### loop if not empty
```groovy
[]?.each{ println it } ?: println( 'empty' )
[:]?.each{ k, v -> println "${k} :: ${v}" } ?: println( 'empty' )
```
- details
  ```groovy
  assert [:]?.each{ k, v -> println "${k} :: ${v}" } == true
              |                                      |
              [:]                                    false
  ```

### getField()
```groovy
groovy:000 > 'aaa'.getClass().getFields()
===> [public static final java.util.Comparator java.lang.String.CASE_INSENSITIVE_ORDER]
```

### generate the random String
```groovy
String alphabet = (('a'..'z') + ('A'..'Z') + ('0'..'9')).join()
println new Random().with { (1..8).collect { alphabet[ nextInt( alphabet.length() ) ] }.join() }
```
- [or](https://newbedev.com/groovy-generate-random-string-from-given-character-set)
  ```groovy
  Closure generator = { String alphabet, int n ->
    new Random().with {
      (1..n).collect { alphabet[ nextInt( alphabet.length() ) ] }.join()
    }
  }
  String charset = (('A'..'Z')+('0'..'9')+('a'..'z')).join()
  randomValue = generator( charset, 15 )
  ```

## [run groovy from docker](https://groovy-lang.gitlab.io/101-scripts/docker/basico.html)
```bash
$ docker run \
         --rm \
         -e hola=caracola \
         -it \
         groovy:latest groovy -e "System.getenv().each{ println it }"
```

- mount volume
  ```bash
  $ docker run \
           --rm \
           -v "$PWD":/home/marslo/scripts \
           -w /home/marslo/scripts \
           groovy:latest \
           groovy DockerBasico.groovy -a
  ```
  - `DockerBasico.groovy`
    ```groovy
    if ( options.a ) {
      println "------------------------------------------------------------------"
      System.getenv().each{ println it }
      println "------------------------------------------------------------------"
    }
    ```
- with Json
  ```bash
  $ docker run \
    --rm \
    -v "$PWD":/home/marslo/scripts \
    -w /home/marslo/scripts \
    groovy:latest groovy DockerBasico.groovy -d
  ```

  - `DockerBasico.groovy`
    {% hint style='tip' %}
    > how to download the image via json
    {% endhint %}

    ```groovy
    if( options.d ){
      def json = new groovy.json.JsonSlurper().parse( new URL("https://dog.ceo/api/breed/hound/images/random")  )
      if( json.status=='success' ){
        new File('perrito.jpg').bytes =  new URL(json.message).bytes
      }
    }
    ```

## MetaClass
### get supported methods
```groovy
String s = 'aa'
println s.metaClass.methods.name
```
- result
  ```
  [equals, getClass, hashCode, notify, notifyAll, toString, wait, wait, wait, charAt, codePointAt, codePointBefore, codePointCount, compareTo, compareToIgnoreCase, concat, contains, contentEquals, contentEquals, copyValueOf, copyValueOf, endsWith, equals, equalsIgnoreCase, format, format, getBytes, getBytes, getBytes, getBytes, getChars, hashCode, indexOf, indexOf, indexOf, indexOf, intern, isEmpty, join, join, lastIndexOf, lastIndexOf, lastIndexOf, lastIndexOf, length, matches, offsetByCodePoints, regionMatches, regionMatches, replace, replace, replaceAll, replaceFirst, split, split, startsWith, startsWith, subSequence, substring, substring, toCharArray, toLowerCase, toLowerCase, toString, toUpperCase, toUpperCase, trim, valueOf, valueOf, valueOf, valueOf, valueOf, valueOf, valueOf, valueOf, valueOf]
  ```

- [or print by sort](https://stackoverflow.com/questions/40307037/how-to-get-a-list-of-running-jenkins-builds-via-groovy-script)
  ```groovy
  println <var>.metaClass.methods*.name.sort().unique()
  ```

### [A Bit of metaClass DSL](https://blog.mrhaki.com/2009/11/groovy-goodness-bit-of-metaclass-dsl.html)
```groovy
String.metaClass {
    or << { String s -> delegate.plus(' or ').plus(s) }
    or << { List l -> delegate.findAll("(${l.join('|')})") }
    and { String s -> delegate.plus(' and ').plus(s) }
    'static' {
        groovy { 'Yeah man!' }
    }
}

assert 'Groovy or Java?' == ("Groovy" | "Java?")
assert ['o', 'o', 'y'] == ("Groovy" | ['o', 'y'])
assert 'Groovy and Java!' == ("Groovy" & "Java!")
assert 'Yeah man!' == String.groovy()
```

- [metaClass with Closure](https://stackoverflow.com/a/3050218/2940319)
  ```groovy
  List.metaClass.eachUntilGreaterThanFive = { closure ->
    for ( value in delegate ) {
      if ( value  > 5 ) break
      closure(value)
    }
  }

  [1, 2, 3, 4, 5, 6, 7].eachUntilGreaterThanFive {
    println it
  }
  ```

### get class name
```groovy
Sting s = 'string'
println s.metaClass.getTheClass()   // Class
println s.getClass()                // Class
println s.class.name                // String
```
- output
```
class java.lang.String
class java.lang.String
java.lang.String
```

### dynamically call methods
> references:
> - [Get variable dynamically](https://stackoverflow.com/questions/18594598/get-variable-dynamically)

```groovy
def doPrint( String platform, String string ) {
 this."do${platform.toLowerCase().capitalize()}Print"( string )
}

def doLinuxPrint( String string ) {
  println "from Linux: ${string}"
}

def doWindowsPrint( String string ) {
  println "from Windows: ${string}"
}

def doDockerPrint( String string ) {
  println "from Docker: ${string}"
}

doPrint( 'LINUX', 'awesome marslo!' )
doPrint( 'dOCKER', 'awesome marslo!' )
```
- result
  ```
  from Linux: awesome marslo!
  from Docker: awesome marslo!
  ```

## others
### groovy cli (args) with options

> reference:
> - [groovy script 101 - Dockery Groovy (basic)](https://groovy-lang.gitlab.io/101-scripts/docker/basico.html)

```groovy
def cli = new CliBuilder(usage: 'groovy DockerBasico.groovy]')

cli.with {
  h(longOpt: 'help',    'Usage Information \n', required: false)
  a(longOpt: 'Hello','Al seleccionar "a" te saludara ', required: false)
  d(longOpt: 'Dogs', 'Genera imagenes de perros', required:false)
}

def options = cli.parse(args)

if ( !options || options.h ) {
  cli.usage
  return
}

//tag::hello[]
if ( options.a ) {
  println "------------------------------------------------------------------"
  println "Hello"
  System.getenv().each{ println it }
  println "------------------------------------------------------------------"
}
//end::hello[]

//tag::dogs[]
if ( options.d ){
  def json = new groovy.json.JsonSlurper().parse( new URL("https://dog.ceo/api/breed/hound/images/random")  )
  if( json.status=='success' ){
    new File('perrito.jpg').bytes =  new URL(json.message).bytes
  }
}
//end::dogs[]
```

### [Get variable value for its name](https://stackoverflow.com/a/6356124/2940319)
```groovy
import groovy.text.SimpleTemplateEngine

def binding = [ VAL1:'foo', VAL2:'bar' ]
def template = 'hello ${VAL1}, please have a ${VAL2}'     // single quotes

println new SimpleTemplateEngine().createTemplate( template ).make( binding ).toString()
```

### [groovy.lang.Binding](https://docs.groovy-lang.org/latest/html/api/groovy/lang/Binding.html)
- [`this.binding`](https://stackoverflow.com/a/293149/2940319)
  > reference:
  > - [Binding variables access in Groovy script's defined classes](https://stackoverflow.com/a/14380610/2940319)

  ```groovy
  baz = [ 'a':'b' ]
  foo = "abc"
  bar = "def"

  println this.binding.hasVariable('baz')
  this.binding.variables.each{ println "${it.key} : ${it.value}" }
  ```
  - result
    ```
    true
    args : []
    baz : [a:b]
    foo : abc
    bar : def
    ```

- [`new Binding()`](https://www.codota.com/code/java/classes/groovy.lang.Binding?snippet=5ce6f4b0e5946700041724ee)
  ```groovy
  String beans = 'aabbcc-beans-ddeeff'
  Binding b = new Binding();
  b.setVariable("beans", beans);
  b.variables.each{ println "${it.key} : ${it.value}" }
  ```

- [`binding.setVariable()`](https://www.codota.com/code/java/classes/groovy.lang.Binding?snippet=5ce6d57ce594670004f99989)
  ```groovy
  m = [ 'a' : '1', 'b' : '2' ]
  binding.setVariable("a", m)
  this.binding.variables.each{ println "${it.key} : ${it.value}" }
  ```
  - result
    ```
    args : []
    m : [a:1, b:2]
    a : [a:1, b:2]
    ```

## load groovy file
{% hint style='tip' %}
> **sample.groovy**:
>
> ```
> #!/usr/bin/env groovy
> import groovy.transform.Field
>
> @Field final Map<String, Map<String, String>> SAMPLE = [
>   k1 : [ 'k11' : 'v11' ] ,
>   k2 : [ 'k21' : 'v21', 'k22' : 'v22' ]
> ]
> ```
{% endhint %}

> references:
> - [Integrating Groovy in a Java application](http://docs.groovy-lang.org/latest/html/documentation/guide-integrating.html#_groovy_integration_mechanisms)
> - [GroovyShell](http://docs.groovy-lang.org/latest/html/documentation/guide-integrating.html#integ-groovyshell)
> - [GroovyClassLoader](http://docs.groovy-lang.org/latest/html/documentation/guide-integrating.html#groovyclassloader)

### [`GroovyShell()`](https://stackoverflow.com/a/46330456/2940319)
- ` new GroovyShell().parse(new File('/path/to/file'))`
  ```groovy
  Object sample = new GroovyShell().parse(new File('/path/to/sample.groovy'))
  println """
    sample.getClass() : ${sample.getClass()}
     sample.SAMPLE.k1 : ${sample.SAMPLE.k1}
  """
  ```
  - result
    ```groovy
      sample.getClass() : class sample
       sample.SAMPLE.k1 : [k11:v11]
    ```

- [`Object.with{}`](https://stackoverflow.com/a/9006034/2940319)
  ```groovy
  Object sample = new GroovyShell().parse(new File('/path/to/sample.groovy'))
  sample.with{
    println SAMPLE
    println SAMPLE.k1
  }
  ```
  - result
    ```groovy
    [k1:[k11:v11], k2:[k21:v21, k22:v22]]
    [k11:v11]
    ```

### [`GroovyClassLoader()`](https://stackoverflow.com/a/15904699/2940319)
- `new GroovyClassLoader().parseClass("/path/to/sample.groovy" as File)`
  ```groovy
  Class clazz = new GroovyClassLoader().parseClass("/path/to/sample.groovy" as File)
  println """
               clazz.getClass() : ${clazz.getClass()}
     clazz.newInstance().SAMPLE : ${clazz.newInstance().SAMPLE}
  """
  ```
  - result
    ```groovy
               clazz.getClass() : class java.lang.Class
     clazz.newInstance().SAMPLE : [k1:[k11:v11], k2:[k21:v21, k22:v22]]
    ```

- [`this.class.classLoader.parseClass(new File("/path/to/sample.groovy"))`](https://stackoverflow.com/a/20229953/2940319)
  ```groovy
  Class myClazz = this.class.classLoader.parseClass(new File("/Users/marslo/Desktop/sample.groovy"))
  println """
             myClazz.getClass() : ${myClazz.getClass()}
   myClazz.newInstance().SAMPLE : ${myClazz.newInstance().SAMPLE}
  """
  ```
  - result
    ```groovy
               myClazz.getClass() : class java.lang.Class
     myClazz.newInstance().SAMPLE : [k1:[k11:v11], k2:[k21:v21, k22:v22]]
    ```

- `new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File("/path/to/sample.groovy"))`
  ```groovy
  Class gClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File("/path/to/sample.groovy"));
  println """
              gClass.getClass() : ${gClass.getClass()}
    gClass.newInstance().SAMPLE : ${gClass.newInstance().SAMPLE}
  """
  ```
  - result
    ```groovy
              gClass.getClass() : class java.lang.Class
    gClass.newInstance().SAMPLE : [k1:[k11:v11], k2:[k21:v21, k22:v22]]
    ```

### metaClass
```groovy
Object sample = new GroovyShell().parse(new File('/path/to/sample.groovy'))
println sample.metaClass.hasProperty(sample, 'SAMPLE').type
println sample.metaClass.hasProperty(sample, 'SAMPLE').name
```
- result
  ```groovy
  interface java.util.Map
  SAMPLE
  ```

or

```groovy
Class clazz = new GroovyClassLoader().parseClass("/path/to/sample.groovy" as File)
println clazz.metaClass.hasProperty(clazz, 'SAMPLE').dump()
```
- result
  ```groovy
  <org.codehaus.groovy.reflection.CachedField@6b915a64 field=final java.util.Map sample.SAMPLE madeAccessible=true name=SAMPLE type=interface java.util.Map>
  ```

#### [more](https://stackoverflow.com/a/52361714/2940319)
```groovy
def importScript(def scriptFile) {
  def script = new GroovyShell().parse(new File(scriptFile))
    script.metaClass.methods.each {
      if (it.declaringClass.getTheClass() == script.class && ! it.name.contains('$') && it.name != 'main' && it.name != 'run') {
      this.metaClass."$it.name" = script.&"$it.name"
    }
  }
}

importScript('File1.groovy')
method()
```