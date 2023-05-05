<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [shared libs](#shared-libs)
  - [vars](#vars)
  - [src](#src)
- [asynchronous resource disposer](#asynchronous-resource-disposer)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->





## shared libs

> reference:
> - [Jenkins Shared Libraries Workshop](https://www.slideshare.net/roidelapluie/jenkins-shared-libraries-workshop)
> - [Extending with Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/)

### vars
- capture
  ```groovy
  def capture( String str, String pattern, int groupIndex, int index ) {
    ( str =~ pattern ).findAll()?.getAt(groupIndex)?.getAt(index) ?: null
  }

  ```
  - example : find out the current Container ID if the process running in a container
    ```groovy
    // cpuset: '/kubepods/burstable/pod59899be8-d4db-11eb-9a49-ac1f6b59c992/b60bf42d334be0eff64f325bad5b0ca4750119fbf8a7e80afa4e559040208ab3''
    String cpuset = sh (
      returnStdout : true ,
            script : "set +x; cat /proc/self/cpuset"
    ).trim()
    String dockerPattern = '^/docker/(\\w{64})$'
    String k8sPattern    = '^/kubepods/([^/]+/){2}(\\w{64})$'

    return capture( cpuset, k8sPattern ) ?: capture( cpuset, dockerPattern )
    ```

### src
#### using Jenkins plugins in groovy scripts

#### [using jenkins-core in groovy script via Grab](https://stackoverflow.com/a/38967175/2940319)

> [!NOTE|references:]
> - [GrabResolver](http://docs.groovy-lang.org/latest/html/api/groovy/lang/GrabResolver.html)
> - [Dependency management with Grape](http://docs.groovy-lang.org/latest/html/documentation/grape.html)
> - [kellyrob99/setupNewServer.groovy](https://gist.github.com/kellyrob99/1907283)

```groovy
@GrabResolver(name='jenkins', root='http://repo.jenkins-ci.org/public/')
@Grab(group='org.jenkins-ci.main', module='jenkins-core', version='2.9')
import jenkins.model.Jenkins
```

## [asynchronous resource disposer](https://plugins.jenkins.io/resource-disposer)
```groovy
import org.jenkinsci.plugins.resourcedisposer.AsyncResourceDisposer

AsyncResourceDisposer disposer = AsyncResourceDisposer.get()
  println """
    getDisplayName : ${disposer.getDisplayName()}
       isActivated : ${disposer.isActivated()}
  """

disposer.getBacklog().each {
  println """
            getId : ${it.getId()}
    getRegistered : ${it.getRegistered()}
             node : ${it.getDisposable().node}
             path : ${it.getDisposable().path}
     getLastState : ${it.getLastState().getDisplayName()}
  """
}

// disposer.getBacklog().each { disposer.dispose( it.getDisposable() ) }
```
- result
  ```groovy
      getDisplayName : Asynchronous resource disposer
         isActivated : true

              getId : 889006714
      getRegistered : Mon Apr 18 19:19:30 PDT 2022
               node : worknode_021
               path : /home/devops/workspace/marslo/testing_ws-cleanup_1650334769689
       getLastState : Unable to delete '/home/devops/workspace/marslo/testing_ws-cleanup_1650334769689'. Tried 3 times (of a maximum of 3) waiting 0.1 sec between attempts. (Discarded 33 additional exceptions)

              getId : 167234646
      getRegistered : Sun Apr 17 13:07:47 PDT 2022
               node : worknode_013
               path : /home/devops/workspace/marslo/testing_ws-cleanup_1650226067115
       getLastState : Unable to delete '/home/devops/workspace/marslo/testing_ws-cleanup_1650226067115'. Tried 3 times (of a maximum of 3) waiting 0.1 sec between attempts. (Discarded 32 additional exceptions)
       ...
  ```

