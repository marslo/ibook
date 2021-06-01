<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get info](#get-info)
  - [get all](#get-all)
  - [Get resource by label](#get-resource-by-label)
  - [if label validated](#if-label-validated)
  - [Get free number of label](#get-free-number-of-label)
  - [Get all resource](#get-all-resource)
- [add or remove](#add-or-remove)
- [management](#management)
  - [remove by label (or name)](#remove-by-label-or-name)
  - [create new item](#create-new-item)
  - [change label by certain condition](#change-label-by-certain-condition)
- [reserve & unlock](#reserve--unlock)
  - [by cli](#by-cli)
  - [by api](#by-api)
  - [examples](#examples)
- [functions](#functions)
  - [`isLabelExists`](#islabelexists)
  - [`isResourceExists`](#isresourceexists)
  - [get label by name](#get-label-by-name)
  - [set Label](#set-label)
  - [with Closure](#with-closure)
  - [get resource status](#get-resource-status)
  - [`removeLabelByName`](#removelabelbyname)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='info' %}
> reference:
> - [javadoc](https://javadoc.jenkins.io/plugin/lockable-resources/org/jenkins/plugins/lockableresources/LockableResource.html)
> - [configure-lockable-resources.groovy](https://gist.github.com/ansig/d7edafe38fbfc13c5b3cd15351849804)
> - [collect-resources-data-for-graphite.groovy](https://gist.github.com/ansig/c9f2ac8e291d5dcb854d49f691f6c7e8)
> - [LockableResourcesHelper.groovy](https://gist.github.com/glance-/aaa3c037757895798d4e1be5134bb843)
> - [lockable_resources_from_json.groovy](https://gist.github.com/evidex/520d7a096929bdda1779a51e380819be)
> - [list_lockable_resources.groovy](https://gist.github.com/evidex/925fbc47a871141070b81e7dbbcf713f)
> - [JenkinsJobDslCleanupLockableResources.groovy](https://gist.github.com/marcusphi/3380f83964249b1250a6d5230be741e5)
> - [JenkinsScriptedPipelineCleanupLockableResources.groovy](https://gist.github.com/marcusphi/d5a5d5769b69627a5169dc440d52a223)
> - [jenkins-remove-lockable-resources.groovy](https://gist.github.com/hrickmachado/86683781f700ea2b5a5012ad1d22b54)
{% endhint %}


## get info

### get all
#### all items information
```groovy
import org.jenkins.plugins.lockableresources.LockableResourcesManager

LockableResourcesManager manager = new org.jenkins.plugins.lockableresources.LockableResourcesManager()
// or LockableResourcesManager manager = org.jenkins.plugins.lockableresources.LockableResourcesManager.get()

manager.getResources().each{ r ->
  println """
    ${r.name}: ${r.getClass()}
              locked? : ${r.locked} : ${r.isLocked()}
            reserved? : ${r.reserved} : ${r.isReserved()}
                label : ${r.labels} : ${r.getLabels()}
          description : ${r.description} : ${r.getDescription()}
                queue : ${r.queueItemProject ?: ''}
          reserved by : ${r.reservedBy ?: ''}
                build : ${r.build ?: ''}
       queuingStarted : ${r.queuingStarted ?: ''}
       queuedContexts : ${r.queuedContexts ?: ''}

"""
}
```

#### labels
```groovy
import org.jenkins.plugins.lockableresources.LockableResourcesManager

stage('all label') {
  println '~~> all labels:'
  println new LockableResourcesManager().getAllLabels()
}
```

#### resources
```groovy
import org.jenkins.plugins.lockableresources.LockableResourcesManager
println new LockableResourcesManager().getResources()
```
- or
  ```groovy
  println org.jenkins.plugins.lockableresources.LockableResourcesManager.get().getResources()
  ```

### Get resource by label
```groovy
import org.jenkins.plugins.lockableresources.LockableResourcesManager

stage('get label') {
  String l = 'my-label'
  println "~~> resources for ${l}:"
  println new LockableResourcesManager().getResourcesWithLabel( l, null )
}
```
- or
  ```groovy
  import org.jenkins.plugins.lockableresources.LockableResourcesManager
  println new LockableResourcesManager().getResourcesWithLabel( l, [:] )
  ```

### if label validated
```groovy
import org.jenkins.plugins.lockableresources.LockableResourcesManager

stage('does label validated') {
  String l = 'my-label'
  println '~~> is ${l} valid:'
  println new LockableResourcesManager().isValidLabel(l)
}
```

### Get free number of label
```groovy
import org.jenkins.plugins.lockableresources.LockableResourcesManager

stage('number of free') {
  String l = 'my-label'
  println new LockableResourcesManager().getFreeResourceAmount(l)
}
```


### [Get all resource](https://issues.jenkins-ci.org/browse/JENKINS-46235?focusedCommentId=345401&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-345401)
```groovy
stage('get all resoruces') {
  def all_lockable_resources = GlobalConfiguration.all().get(org.jenkins.plugins.lockableresources.LockableResourcesManager.class).resources

  println "~~> free resource for ${l}"
  println all_lockable_resources
  // remove
  all_lockable_resources.removeAll { it.name.contains('somestr')}
}
```

## add or remove
## management
### [remove by label (or name)](https://issues.jenkins-ci.org/browse/JENKINS-38906?focusedCommentId=353245&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-353245)

```groovy
stage('remove') {
    def manager = org.jenkins.plugins.lockableresources.LockableResourcesManager.get()
    def resources = manager.getResources().findAll {
        // println it.locked ? "${it} locked" : "${it.labels}"
        ( !it.locked ) && (
            it.name.equals('marslo') ||
            it.labels.contains('marslo') ||
            it.name.startsWith('marslo')
        )
    }
    currentBuild.description = "${resources.size()} locks"
    resources.each {
        println "Removing ${it.name} ~~> ${it.labels}"
        manager.getResources().remove(it)
    }
    manager.save()
}
```

- [remove all](https://issues.jenkins.io/browse/JENKINS-38906?focusedCommentId=358692&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-358692)
  ```groovy
  String lockName = 'lock name'
  def manager = org.jenkins.plugins.lockableresources.LockableResourcesManager.get()
  manager.getResources().removeAll { r -> lockNames.contains(r.name) && !r.locked && !r.reserved }
  manager.save()
  ```

### create new item
```groovy
stage('create') {
    def manager = org.jenkins.plugins.lockableresources.LockableResourcesManager.get()
    def myr = manager.createResourceWithLabel('marslo', 'marslo-label')
}
```


### change label by certain condition
{% hint style='tip' %}
**Objective** :
<p>
add the keyword `marslo_` as prefix of labels whose label isn't belongs to `keyword` list.

** prevent repeat to add ** :
  - `List keyword = [ 'project1', 'project2', 'keyword', 'marslo_' ]`
  - or
  - `r.setLabels( 'marslo_' + r.labels.split('marslo_').last() )`
{% endhint %}

```groovy
import org.jenkins.plugins.lockableresources.*

LockableResourcesManager manager = org.jenkins.plugins.lockableresources.LockableResourcesManager.get()
List keyword = [ 'project1', 'project2', 'keyword' ]

manager.getResources().findAll { r ->
  r.labels && ! keyword.any{ r.labels.toLowerCase().startsWith(it) }
}.collect { r ->
  r.setLabels( 'marslo_' + r.labels.split('marslo_').last() )
}
```
- show result
  ```groovy
  println manager.resources.findAll { r ->
    r.labels && ! keyword.any{ r.labels.toLowerCase().startsWith(it) }
  } collect {
    [ (r.name), r.labels ]
  }
  ```

## reserve & unlock
### by cli
```bash
$ resource='marslo'
$ curl -XGET -uadmin:passwd https://my.jenkins.com/lockable-resources/reserve?resource=${resource}
$ curl -XGET -uadmin:passwd https://my.jenkins.com/lockable-resources/unreserve?resource=${resource}
```

### by api
```groovy
stage('reserve & unlock') {
    def manager = org.jenkins.plugins.lockableresources.LockableResourcesManager.get()
    println manager.fromName('marslo')?.isReserved()

    println '~~> lock marslo:'
    manager.reserve([ manager.fromName('marslo') ], 'Marslo Jiao')
    println manager.fromName('marslo')?.isReserved()

    println '~~> unlock marslo:'
    manager.reset([ manager.fromName('marslo') ])
    println manager.fromName('marslo')?.isReserved()
}
```

### [examples](https://config9.com/apps/jenkins/jenkins-lockable-resource-lock-without-unlocking/)
```groovy
print "START\n"
def all_lockable_resources = org.jenkins.plugins.lockableresources.LockableResourcesManager.get().resources
all_lockable_resources.each { r->
  if ( r.isLocked() || r.isReserved() ) {
    println "Lock " + r + " is locked or reserved by " + r.getBuild() + " BECARSE " + r.getLockCause()

    b = r.getBuild()

    if ( b ) {
      if ( b.isBuilding() )             println ( "build:" + b + " is building" )
      if ( b.getResult().equals(null) ) println ( "build:" + b + " result is not in yet" )

      if ( ! b.isBuilding() && ! b.getResult().equals(null) ) {
        println "build:" + b + " is not building and result is " + b.getResult() + " yet the lock " + r + " is locked."

        println "ACTION RELEASE LOCK " + r
        println "getLockCause:"   + r.getLockCause()
        println "getDescription:" + r.getDescription()
        println "getReservedBy:"  + r.getReservedBy()
        println "isReserved:"     + r.isReserved()
        println "isLocked:"       + r.isLocked()
        println "isQueued:"       + r.isQueued()

        //release the lock
        r.reset()

        println "getLockCause:"   + r.getLockCause()
        println "getDescription:" + r.getDescription()
        println "getReservedBy:"  + r.getReservedBy()
        println "isReserved:"     + r.isReserved()
        println "isLocked:"       + r.isLocked()
        println "isQueued:"       + r.isQueued()
      }

    }
  }
}
```

## functions
### `isLabelExists`
```groovy
def isLabelExists( String label ) {
  org.jenkins.plugins
     .lockableresources
     .LockableResourcesManager
     .get()
     .getResources()
     .findAll{ it.labels == label } != []
}
```
- or
  ```groovy
  withManager{ manager ->
    manager
      .resources
      .findAll{ it.labels == label } != []
  }
  ```

### `isResourceExists`
```groovy
def isResourceExists( String name ) {
  org.jenkins.plugins
     .lockableresources
     .LockableResourcesManager
     .get()
     .fromName(name) != null
}
```
  - or
    ```groovy
    def isResourceExists( String name ) {
      withManager{ manager -> manager.fromName(name) != null }
    }
    ```

- or using `findAll` for multiple find
  ```groovy
  def isResourceExists( String name ) {
    org.jenkins.plugins
       .lockableresources
       .LockableResourcesManager
       .get()
       .getResources()
       .findAll{ it.name == name } != []
  }
  ```
  - or
    ```groovy
    withManager{ manager ->
      manager.getResources()
             .findAll{ it.name == name } != []
    }
    ```

### get label by name
- using [`fromName(String)`](https://javadoc.jenkins.io/plugin/lockable-resources/org/jenkins/plugins/lockableresources/LockableResourcesManager.html#fromName-java.lang.String-)
  ```groovy
  def getLabelByName( String name ) {
    org.jenkins.plugins
       .lockableresources
       .LockableResourcesManager
       .get()
       .getResources()
       .fromName( name )
       .getLabes()
  }
  ```
  - or
    ```groovy
    def getLabelByName( String name ) {
      withManager{ manager -> manager.fromName( name )?.labels ?: '' }
    }
    ```

- using `findAll` multiple
  ```groovy
  def getLabelByName( String name ) {
    org.jenkins.plugins
       .lockableresources
       .LockableResourcesManager
       .get()
       .getResources()
       .findAll{ it.name == name }
       .collect{ it.labels }
       .join(' ')
  }
  ```
  - or
    ```groovy
    withManager{ manager ->
      manager.getResources()
             .findAll{ it.name == name }
             .collect{ it.labels }
             .join(' ')
    }
    ```

### set Label
```groovy
def setLabel( String name, String label, String trigger = '', Boolean force = false, String description = '' ) {
  LockableResourcesManager manager = LockableResourcesManager.get()
  description   = ( description ? "${description} | " : '' ) +
                  "created automatically by @${trigger ?: 'jenkins'} via Jenkins job ${env.BUILD_URL}"
  if ( isResourceExists(name) && !force ) {
    println( "ERROR: resource ${name} has already tied to label: ${manager.fromName(name)?.labels}. Exit..." )
  } else {
    // manager.createResourceWithLabel( name, label )     // will ignore label re-add if resource exists
    if ( ! isResourceExists(name) ) manager.createResource( name )
    manager.fromName(name).setLabels( label )
    manager.fromName(name).setDescription( description )
    manager.fromName(name).setEphemeral( false )
    manager.save()
    if ( ! isResourceExists(name) ) println( "ERROR: resource ${name} failed to be added in resource pool. Exit..." )
  }
}
```

### with Closure
```groovy
import org.jenkins.plugins.lockableresources.LockableResourcesManager

def withManager( Closure body ) {
  LockableResourcesManager manager = org.jenkins.plugins
                                                .lockableresources
                                                .LockableResourcesManager
                                                .get()
  body( manager )
}
```

### get resource status
```groovy
def getResourceLabelStatus( String name ) {
  Map status = [:]
  withManager { manager ->
    if ( isResourceExists(name) ) {
      LockableResource r   = manager.fromName(name)
      status.'locked'      = r.isLocked()
      status.'reserved'    = r.isReserved()
      status.'lockedBy'    = r.getBuild()      ?: ''
      status.'reservedBy'  = r.getReservedBy() ?: ''
      status.'lockedCause' = r.getLockCause()  ?: ''
    }
  }
  return status
}
```

### `removeLabelByName`
```groovy
/**
 * remove the label from resource pool if the label isn't reserved or locked
 *
 * @param name       the agent name
 * @param force      whether force remove the label or not
 *
 * @see              <a href="https://javadoc.jenkins.io/plugin/lockable-resources/org/jenkins/plugins/lockableresources/LockableResourcesManager.html">org.jenkins.plugins.lockableresources.LockableResourcesManager</a>
 * @see              <a href="https://javadoc.jenkins.io/plugin/lockable-resources/org/jenkins/plugins/lockableresources/LockableResource.html">org.jenkins.plugins.lockableresources.LockableResource</a>
 * @see              {@link #withManager(Closure)}
**/
def removeLabelByName( String name, Boolean force = false ) {
  withManager { manager ->

    if ( isResourceExists(name) ) {
      if ( force ) manager.fromName(name).reset()
      Map resource = getResourceLabelStatus( name )
      if ( ! resource.getOrDefault('locked', true) && ! resource.getOrDefault('reserved', true) ) {
        if ( manager.resources.remove( manager.fromName(name) ) && !isResourceExists(name) ) {
          println ( "INFO: resource ${name} has been successfully removed." )
        } else {
          println ( "WARN: resource ${name} failed to be removed. still tied to label: ${getLabelByName(name)}" )
        }
      } else {
        println ( "WARN: resource ${name} ( label: ${getLabelByName(name)} ) cannot be removed due to " +
                  ( resource.locked   ? "locked by ${resource.lockedBy}"     : '' ) +
                  ( resource.reserved ? "reserved by ${resource.reservedBy}" : '' )
      }
    } else {
      println( "WARN: resource ${name} doesn't exist in resrouce pool. Skip..." )
      println( "Available resources are: ${manager.resources}" )
    }

  } // withManager
}
```
