<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [parallel](#parallel)
  - [static](#static)
  - [dynamic](#dynamic)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
reference:
- [Jobs In Parallel](https://www.jenkins.io/doc/pipeline/examples/#jobs-in-parallel)
- [Parallel From List](https://www.jenkins.io/doc/pipeline/examples/#parallel-from-list)
- [Parallel Multiple Nodes](https://www.jenkins.io/doc/pipeline/examples/#parallel-multiple-nodes)
- [Trigger Job On All Nodes](https://www.jenkins.io/doc/pipeline/examples/#trigger-job-on-all-nodes)
{% endhint %}

## parallel
### static
```groovy
timestamps { ansiColor('xterm') {
  parallel([
    'k1 \u00BB v1': {
      stage( 'build k1' ) {
        node( 'controller' ) {
          println "KEY= k1, VALUE=v1"
          sleep 3
        } // node
      }
    },
    'k2 \u00BB v2': {
      stage( 'build k2' ) {
        node( 'controller' ) {
          println "KEY= k2, VALUE=v2"
          sleep 3
        } // node
      }
    },
    'k3 \u00BB v3': {
      stage( 'build k3' ) {
        node('controller') {
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
    worker[ "${k} \u00BB ${v}" ] = {
      stage( "build ${k}" ) {
        node( 'controller' ) {
          println """
            ---------------
            "KEY=${k} VALUE=${v}"
            ---------------
          """
          sleep 3
        } // node : controller
      } // stage
    } // work
  }
  parallel worker
  println "done !"
}} // ansiColor | timestamps
```

