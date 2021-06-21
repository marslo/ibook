<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Pipeline Utility Steps](#pipeline-utility-steps)
  - [findFiles](#findfiles)
  - [send mail with catch error](#send-mail-with-catch-error)
  - [tips](#tips)
  - [DSL with groovy](#dsl-with-groovy)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## [Pipeline Utility Steps](https://www.jenkins.io/doc/pipeline/steps/pipeline-utility-steps/)
### findFiles
- jenkinsfile
  ```groovy
  sh "touch a.txt"
  def files = findFiles (glob: "**/*.txt")
  println """
            name : ${files[0].name}
            path : ${files[0].path}
       directory : ${files[0].directory}
          length : ${files[0].length}
    lastModified : ${files[0].lastModified}
  """
  ```
- result
  ```groovy
  [Pipeline] sh (hide)
  + touch a.txt
  [Pipeline] findFiles
  [Pipeline] echo

                name : a.txt
                path : a.txt
           directory : false
              length : 0
        lastModified : 1605525397000
  ```

### [send mail with catch error](https://github.com/jenkinsci/workflow-basic-steps-plugin/blob/master/CORE-STEPS.md#plain-catch-blocks)
```groovy
try {
  sh 'might fail'
  mail subject: 'all well', to: 'admin@somewhere', body: 'All well.'
} catch (e) {
  def w = new StringWriter()
  e.printStackTrace(new PrintWriter(w))
  mail subject: "failed with ${e.message}", to: 'admin@somewhere', body: "Failed: ${w}"
  throw e
}
```

### tips
#### java.io.NotSerializableException: groovy.lang.IntRange
> refenrece:
> - [Groovy Range Examples](http://grails.asia/groovy-range-examples)
> - [Groovy For Loop Examples](http://grails.asia/groovy-for-loop-examples)

- caused via
  ```groovy
  (1..5).each { println it }
  ```

- solution
  - [`IntRange.flatten()`](https://stackoverflow.com/a/34881180/2940319)
    ```groovy
    (1..5).flatten().each { println it }
    ```
  - [`IntRange.toList()`](https://stackoverflow.com/a/55210625/2940319)
    ```groovy
    (1..5).toList().each { println it }
    ```

### DSL with groovy
{% hint style='info' %}
**original DSL**:
```groovy
cleanWs(
  deleteDirs: true,
  disableDeferredWipeout: true,
  notFailBuild: true,
  patterns: [
    [pattern: '*', type: 'INCLUDE'],
    [pattern: 'a.txt', type: 'INCLUDE']
  ]
)
```
{% endhint %}

- [Spread Operator](https://www.logicbig.com/tutorials/misc/groovy/spread-operator.html)
  > [Groovy Goodness: the Spread Operato](https://blog.mrhaki.com/2009/09/groovy-goodness-spread-operator.html)

  ```groovy
  List p = [ 'a.txt', 'b.txt' ]

  cleanWs(
    deleteDirs: true,
    disableDeferredWipeout: true,
    notFailBuild: true,
    patterns: [
      *p.collect {
        [pattern: "${it}", type: 'INCLUDE']
      }
    ]
  )
  ```

- `List.collect`
  ```groovy
  List p = [ 'a.txt', 'b.txt' ]

  cleanWs(
    deleteDirs: true,
    disableDeferredWipeout: true,
    notFailBuild: true,
    patterns: p.collect { [pattern: "${it}", type: 'INCLUDE'] }
  )
  ```

- `with API`
  ```groovy
  import hudson.plugins.ws_cleanup.Pattern
  import hudson.plugins.ws_cleanup.Pattern.PatternType

  List p = [ 'a.txt', 'b.txt' ]

  cleanWs(
    deleteDirs: true,
    disableDeferredWipeout: true,
    notFailBuild: true,
    patterns: p.collect { new Pattern(it, PatternType.INCLUDE) }
  )
  ```

- pure API
  > Javadoc:
  > - [hudson.plugins.ws_cleanup.WsCleanup](https://javadoc.jenkins.io/plugin/ws-cleanup/hudson/plugins/ws_cleanup/WsCleanup.html)
  > - [hudson.plugins.ws_cleanup.Pattern](https://javadoc.jenkins.io/plugin/ws-cleanup/hudson/plugins/ws_cleanup/Pattern.html)
  > - [hudson.plugins.ws_cleanup.Pattern.PatternType](https://javadoc.jenkins.io/plugin/ws-cleanup/hudson/plugins/ws_cleanup/Pattern.PatternType.html)
  > - [FilePath](https://javadoc.jenkins.io/hudson/FilePath.html)
  > - [Launcher](https://javadoc.jenkins-ci.org/hudson/Launcher.html)
  > - [TaskListener](https://javadoc.jenkins-ci.org/hudson/model/TaskListener.html)
  >
  > get `FilePath`
  > - [Using FilePath to access workspace on slave in Jenkins pipeline](https://stackoverflow.com/a/42018578/2940319)

  ```groovy
  import hudson.plugins.ws_cleanup.WsCleanup
  import hudson.plugins.ws_cleanup.Pattern
  import hudson.plugins.ws_cleanup.Pattern.PatternType

  List p = [ 'a.txt', 'b.txt' ]

  WsCleanup wsc = new WsCleanup()
  wsc.setDeleteDirs(true)
  wsc.setDisableDeferredWipeout(true)
  wsc.setNotFailBuild(true)
  wsc.setPatterns(
    p.each {
      new Pattern( it, PatternType.INCLUDE )
    }
  )
  wsc.perform( currentBuild.rawBuild, <FilePath>, <Launcher>, <TaskListener> ) // unfinished
  ```
