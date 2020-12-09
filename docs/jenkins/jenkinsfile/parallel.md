<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [parallel](#parallel)
  - [static](#static)
  - [dynamic](#dynamic)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## parallel
### static
```groovy
timestamps { ansiColor('xterm') {
  parallel([
    'k1 \u00BB v1': {
      stage( 'build k1' ) {
        node("master") {
          println "KEY= k1, VALUE=v1"
          sleep 3
        } // node
      }
    },
    'k2 \u00BB v2': {
      stage( 'build k2' ) {
        node("master") {
          println "KEY= k2, VALUE=v2"
          sleep 3
        } // node
      }
    },
    'k3 \u00BB v3': {
      stage( 'build k3' ) {
        node("master") {
          println "KEY= k3, VALUE=v3"
          sleep 3
        } // node
      }
    }
  ])
  println 'done'
}} // ansiColor | timestamps
```

### dynamic
```groovy
timestamps { ansiColor('xterm') {
  Map worker = [:]
  Map<String, String> data = [
    "k1": "v1",
    "k2": "v2",
    "k3": "v3",
  ]
  data.each { k ,v ->
    worker["${k} \u00BB ${v}"] = {
      stage("build ${k}") {
        node("master") {
          println """
            ---------------
            "KEY=${k} VALUE=${v}"
            ---------------
          """
          sleep 3
        } // node : master
      } // stage
    } // work
  }
  parallel worker
  println "done !"
}} // ansiColor | timestamps
```

