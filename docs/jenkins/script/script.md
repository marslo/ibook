<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [script console](#script-console)
  - [usage](#usage)
  - [basic usage](#basic-usage)
  - [execute shell script in console](#execute-shell-script-in-console)
- [jobs](#jobs)
  - [get build status](#get-build-status)
  - [get all builds status during certain start-end time](#get-all-builds-status-during-certain-start-end-time)
  - [list job which running for more than 24 hours](#list-job-which-running-for-more-than-24-hours)
  - [shelve jobs](#shelve-jobs)
- [list plugins](#list-plugins)
  - [via api : imarslo : list plugins](#via-api--imarslo--list-plugins)
  - [simple list](#simple-list)
  - [List plugin and dependencies](#list-plugin-and-dependencies)
- [scriptApproval](#scriptapproval)
  - [backup & restore all scriptApproval items](#backup--restore-all-scriptapproval-items)
  - [automatic approval all pending](#automatic-approval-all-pending)
  - [disable the scriptApproval](#disable-the-scriptapproval)
- [abort](#abort)
  - [abort a build](#abort-a-build)
  - [abort running builds if new one is running](#abort-running-builds-if-new-one-is-running)
- [logRotator](#logrotator)
  - [show logRotator](#show-logrotator)
- [shared libs](#shared-libs)
  - [vars](#vars)
  - [src](#src)
- [Asynchronous resource disposer](#asynchronous-resource-disposer)
- [others](#others)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [Script Console](https://www.jenkins.io/doc/book/managing/script-console/)
> - [Jenkins Features Controlled with System Properties](https://www.jenkins.io/doc/book/managing/system-properties/)
> - [samrocketman/jenkins-script-console-scripts](https://github.com/samrocketman/jenkins-script-console-scripts)
> - [* jenkinsci/jenkins-scripts](https://github.com/jenkinsci/jenkins-scripts)
> - [* cloudbees/jenkins-scripts](https://github.com/cloudbees/jenkins-scripts)
> - [mubbashir/Jenkins+Script+Console.md](https://gist.github.com/mubbashir/484903fda934aeea9f30)
> - [Sam Gleske’s jenkins-script-console-scripts repository](https://github.com/samrocketman/jenkins-script-console-scripts)
> - [Sam Gleske’s jenkins-bootstrap-shared repository](https://github.com/samrocketman/jenkins-bootstrap-shared)
> - [Some scripts at JBoss.org](http://community.jboss.org/wiki/HudsonHowToDebug)
> - [mikejoh/jenkins-and-groovy-snippets.md](https://gist.github.com/mikejoh/9a721d1e6de7574059dcb8f851692be9)
> - [Jenkins : Jenkins Script Console](https://wiki.jenkins.io/display/JENKINS/Jenkins-Script-Console.html)
> - [Jenkins : Use Jenkins](https://wiki.jenkins.io/display/JENKINS/Use-Jenkins.html)
{% endhint %}

> [!TIP]
> to list methods on a class instance:
> ```groovy
> thing.metaClass.methods*.name.sort().unique()
> ```
> to determine a class from an instance:
> ```groovy
> thing.class
> // or
> thing.getClass()
> ```

## [script console](https://www.jenkins.io/doc/book/managing/script-console/)
### usage
- remote access
  ```bash
  $ curl -d "script=<your_script_here>" https://jenkins/script

  # or to get output as a plain text result (no HTML)
  $ curl -d "script=<your_script_here>" https://jenkins/scriptText
  ```

- curl submitting groovy file
  ```bash
  $ curl --data-urlencode "script=$(< ./somescript.groovy)" https://jenkins/scriptText
  ```
  - via api token
    ```bash
    $ curl --user 'username:api-token' --data-urlencode \
           "script=$(< ./somescript.groovy)" \
           https://jenkins/scriptText
    ```
  - via python
    ```bash
    with open('somescript.groovy', 'r') as fd:
      data = fd.read()
    r = requests.post('https://jenkins/scriptText', auth=('username', 'api-token'), data={'script': data})
    ```

### basic usage
- setup timestampe (temporary)
  ```groovy
  System.setProperty('org.apache.commons.jelly.tags.fmt.timeZone', 'America/Los_Angeles')
  ```

### execute shell script in console

> [!TIP]
> reference:
> [i.e.](https://www.jenkins.io/doc/book/managing/script-console/#run-scripts-from-controller-script-console-on-agents)

```groovy
println ("uname -a".execute().text)

// or
println ("printenv".execute().in.text)
```
- result
  ```
  Linux devops-jenkins-685cf57df9-znfs8 4.19.12-1.el7.elrepo.x86_64 #1 SMP Fri Dec 21 11:06:36 EST 2018 x86_64 GNU/Linux
  ```

#### modify log level

{% hint style='tip' %}
> references:
> - [How to change the default or package log levels](https://support.cloudbees.com/hc/en-us/articles/115003914391-How-to-change-the-default-or-package-log-levels)
> - [Configure Loggers for Jenkins](https://support.cloudbees.com/hc/en-us/articles/115002626172-Configure-Loggers-for-Jenkins)
> - [Disable HttpClient logging](https://stackoverflow.com/a/61128260/2940319)
> - [Viewing logs](https://www.jenkins.io/doc/book/system-administration/viewing-logs/)
{% endhint %}

```groovy
System.setProperty("org.apache.commons.logging.Log", "org.apache.commons.logging.impl.SimpleLog");
System.setProperty("org.apache.commons.logging.simplelog.showdatetime", "true");
System.setProperty("org.apache.commons.logging.simplelog.log.httpclient.wire.header", "error");
System.setProperty("org.apache.commons.logging.simplelog.log.org.apache.http", "error");
System.setProperty("log4j.logger.org.apache.http", "error");
System.setProperty("log4j.logger.org.apache.http.wire", "error");
System.setProperty("org.apache.commons.logging.simplelog.log.org.apache.commons.httpclient", "error");
```
- check log level
  ```groovy
  println System.getProperty("org.apache.commons.logging.Log");
  println System.getProperty("org.apache.commons.logging.simplelog.showdatetime");
  println System.getProperty("org.apache.commons.logging.simplelog.log.httpclient.wire.header");
  println System.getProperty("org.apache.commons.logging.simplelog.log.org.apache.http");
  println System.getProperty("log4j.logger.org.apache.http");
  println System.getProperty("log4j.logger.org.apache.http.wire");
  println System.getProperty("org.apache.commons.logging.simplelog.log.org.apache.commons.httpclient");
  ```

## [jobs](https://support.cloudbees.com/hc/en-us/articles/226941767-Groovy-to-list-all-jobs)

> [!TIP]
> get more: [imarslo :jobs & builds](./build.html)

### get build status
- [get all builds result percentage](./build.html#get-all-builds-result-percentage)
- [get builds result percentage within 24 hours](./build.html#get-builds-result-percentage-within-24-hours)
- [get builds result and percentage within certain start-end time](./build.html#get-builds-result-and-percentage-within-certain-start-end-time)

### get all builds status during certain start-end time
- [list all builds within 24 hours](./build.html#list-all-builds-within-24-hours)
- [get last 24 hours failure builds](./build.html#get-last-24-hours-failure-builds)
- [get last 24 hours failure builds via Map structure](./build.html#get-last-24-hours-failure-builds-via-map-structure)
- [get builds result during certain start-end time](./build.html#get-builds-result-during-certain-start-end-time)
- [get builds result and percentage within certain start-end time](./build.html#get-builds-result-and-percentage-within-certain-start-end-time)

### [list job which running for more than 24 hours](https://raw.githubusercontent.com/cloudbees/jenkins-scripts/master/builds-running-more-than-24h.groovy)
- [list job which running for more than 24 hours](./build.html#list-all-builds-within-24-hours)

### [shelve jobs](https://support.cloudbees.com/hc/en-us/articles/236353928-Groovy-Scripts-To-Shelve-Jobs)
```groovy
//You have to install the Shelve Project Plugin on your Jenkins Master
//The maximum value for daysBack is 365, going beyond 365 will break the script.

import org.jvnet.hudson.plugins.shelveproject.ShelveProjectTask

def daysBack=365;
Jenkins.instance.getAllItems(AbstractProject.class).each { it ->
  def lastBuild = it.getLastBuild()
  if( lastBuild != null ) {
    def back = Calendar.getInstance()
      back.set( Calendar.DAY_OF_YEAR,back.get(Calendar.DAY_OF_YEAR) - daysBack )
      if ( lastBuild.getTime().compareTo(back.getTime()) < 0 ) {
        println it.name + " was built over " + daysBack + " days ago: " + lastBuild.getTime()
          if ( it instanceof AbstractProject ){
            def spt=  new ShelveProjectTask(it)
            Hudson.getInstance().getQueue().schedule(spt , 0 );
          } else {
            println it.name + " was not shelved----------- "
          }
      }
  }
}
```

## list plugins
### via api : [imarslo : list plugins](./api.html#list-plugins)
### [simple list](https://stackoverflow.com/a/35292719/2940319)
```groovy
Jenkins.instance
       .pluginManager
       .plugins
       .each { plugin ->
         println ( "${plugin.getDisplayName()} (${plugin.getShortName()}): ${plugin.getVersion()}" )
       }
```

### [List plugin and dependencies](https://stackoverflow.com/a/56864983/2940319)
```groovy
def plugins = Jenkins.instance
                     .pluginManager
                     .plugins
                     .sort(false) { a, b ->
                       a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()
                     }

println "Jenkins Instance : ${Jenkins.instance.getComputer('').hostName} + ${Jenkins.instance.rootUrl}\n" +
        "Installed Plugins:\n" +
        "=================="
plugins.each { plugin ->
  println "  ${plugin.getShortName()} : ${plugin.getVersion()} | ${plugin.getDisplayName()}"
}

println "\nPlugins Dependency tree (...: dependencies; +++: dependants) :\n" +
        "======================="
plugins.each { plugin ->
  println """
    ${plugin.getShortName()} : ${plugin.getVersion()} | ${plugin.getDisplayName()}
    +++ ${plugin.getDependants()}
    ... ${plugin.getDependencies()}

  """
}
```

- or
  ```groovy
  def jenkins = Jenkins.instance

  println """
    Jenkins Instance : ${jenkins.getComputer('').hostName} + ${jenkins.rootUrl}
    Installed Plugins:
    ==================
  """
  jenkins.pluginManager
         .plugins
         .sort(false) { a, b ->
           a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()
         }.each { plugin ->
           println "${plugin.getShortName()}: ${plugin.getVersion()} | ${plugin.getDisplayName()}"
         }

  println """
    Plugins Dependency tree (...: dependencies; +++: dependants) :
    =======================
  """
  jenkins.pluginManager
         .plugins
         .sort(false) { a, b ->
           a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()
         }.each { plugin ->
           println """
             ${plugin.getShortName()} : ${plugin.getVersion()} | ${plugin.getDisplayName()}
             +++ ${plugin.getDependants()}
             ... ${plugin.getDependencies()}

           """
         }
  ```

## scriptApproval


{% hint style='tip' %}
> references:
> - [Class ScriptApproval](https://javadoc.jenkins.io/plugin/script-security/org/jenkinsci/plugins/scriptsecurity/scripts/ScriptApproval.html)
{% endhint %}

### backup & restore all scriptApproval items
- backup
  ```groovy
  import java.lang.reflect.*
  import jenkins.model.Jenkins
  import jenkins.model.*
  import org.jenkinsci.plugins.scriptsecurity.scripts.*
  import org.jenkinsci.plugins.scriptsecurity.sandbox.whitelists.*
  import static groovy.json.JsonOutput.*

  scriptApproval = ScriptApproval.get()
  alreadyApproved = new HashSet<>(Arrays.asList(scriptApproval.getApprovedSignatures()))
  println prettyPrint( toJson(alreadyApproved) )
  ```

- restore
  ```bash
  def scriptApproval = org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval.get()

  String[] signs = [
    "method org.jenkinsci.plugins.workflow.steps.FlowInterruptedException getCauses",
    "method org.jenkinsci.plugins.workflow.support.steps.input.Rejection getUser"
  ]

  for( String sign : signs ) {
    scriptApproval.approveSignature(sign)
  }

  scriptApproval.save()
  ```

- [example](https://stackoverflow.com/a/55714171/2940319)
  ```groovy
  import java.lang.reflect.*;
  import jenkins.model.Jenkins;
  import jenkins.model.*;
  import org.jenkinsci.plugins.scriptsecurity.scripts.*;
  import org.jenkinsci.plugins.scriptsecurity.sandbox.whitelists.*;
  import static groovy.json.JsonOutput.*

  scriptApproval = ScriptApproval.get()
  alreadyApproved = new HashSet<>(Arrays.asList(scriptApproval.getApprovedSignatures()))
  void approveSignature(String signature) {
    if (!alreadyApproved.contains(signature)) {
      scriptApproval.approveSignature(signature)
    }
  }

  List scriptList = [
    'method hudson.model.Job getLastSuccessfulBuild',
    'method hudson.model.Node getNodeName'
  ]

  scriptList.each { approveSignature(it) }
  scriptApproval.save()
  ```

### automatic approval all pending
- [list pending scriptApproval](https://stackoverflow.com/a/55940005/2940319)
  ```groovy
  import org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval

  ScriptApproval scriptApproval = ScriptApproval.get()
  scriptApproval.pendingScripts.each { scriptApproval.approveScript( it.hash ) }
  ```

- [job dsl support for scriptapproval](https://issues.jenkins-ci.org/browse/JENKINS-31201?focusedCommentId=285330&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-285330)
  ```groovy
  import jenkins.model.Jenkins

  def scriptApproval = Jenkins.instance
                              .getExtensionList('org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval')[0]
  def hashesToApprove = scriptApproval.pendingScripts
                                      .findAll{ it.script.startsWith(approvalPrefix) }
                                      .collect{ it.getHash() }
  hashesToApprove.each { scriptApproval.approveScript( it ) }
  ```

### [disable the scriptApproval](https://stackoverflow.com/a/49372857/2940319)

> [!TIP]
> @Deprcated
> - file: `$JENKINS_HOME/init.groovy.d/disable-script-security.groovy`

```groovy
import javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration
import jenkins.model.GlobalConfiguration

// disable Job DSL script approval
GlobalConfiguration.all().get(GlobalJobDslSecurityConfiguration.class).useScriptSecurity=false
GlobalConfiguration.all().get(GlobalJobDslSecurityConfiguration.class).save()
```

## abort
### [abort a build](https://stackoverflow.com/a/26306081/2940319)
```groovy
Jenkins.instance.getItemByFullName("JobName")
       .getBuildByNumber(JobNumber)
       .finish (
         hudson.model.Result.ABORTED,
         new java.io.IOException("Aborting build")
       )
```

### [abort running builds if new one is running](https://stackoverflow.com/a/44326216/2940319)
> reference:
> - [Controlling the Flow with Stage, Lock, and Milestone](https://www.jenkins.io/blog/2016/10/16/stage-lock-milestone/)
> - [I have a stuck Pipeline and I can not stop it](https://support.cloudbees.com/hc/en-us/articles/360000913392-I-have-a-stuck-Pipeline-and-I-can-not-stop-it)
> - [Aborting a build](https://www.jenkins.io/doc/book/using/aborting-a-build/)
> - [Cancel queued builds and aborting executing builds using Groovy for Jenkins](https://stackoverflow.com/questions/12305244/cancel-queued-builds-and-aborting-executing-builds-using-groovy-for-jenkins)

```groovy
import hudson.model.Result
import jenkins.model.CauseOfInterruption

//iterate through current project runs
build.getProject()._getRuns().iterator().each { run ->
  def exec = run.getExecutor()
    //if the run is not a current build and it has executor (running) then stop it
    if( run != build && exec != null ) {
      //prepare the cause of interruption
      def cause = { "interrupted by build #${build.getId()}" as String } as CauseOfInterruption
      exec.interrupt(Result.ABORTED, cause)
    }
}
```
- [or](https://stackoverflow.com/a/49901413/2940319)
  ```groovy
  import hudson.model.Result
  import hudson.model.Run
  import jenkins.model.CauseOfInterruption.UserInterruption

  def abortPreviousBuilds() {
    Run previousBuild = currentBuild.rawBuild.getPreviousBuildInProgress()

    while ( previousBuild != null ) {
      if ( previousBuild.isInProgress() ) {
        def executor = previousBuild.getExecutor()
          if ( executor != null ) {
            echo ">> Aborting older build #${previousBuild.number}"
              executor.interrupt( Result.ABORTED,
                                  new UserInterruption(
                                    "Aborted by newer build #${currentBuild.number}"
                                ))
          }
      }
      previousBuild = previousBuild.getPreviousBuildInProgress()
    }
  }
  ```

- or: [cancel builds same job](https://raw.githubusercontent.com/cloudbees/jenkins scripts/master/cancel builds same job.groovy)
  ```groovy
  /*
   Author: Isaac S Cohen
   This script works with workflow to cancel other running builds for the same job
   Use case: many build may go to QA, but only the build that is accepted is needed,
   the other builds in the workflow should be aborted
  */

  def jobname = env.JOB_NAME
  def buildnum = env.BUILD_NUMBER.toInteger()

  def job = Jenkins.instance.getItemByFullName( jobname )
  for ( build in job.builds ) {
    if ( !build.isBuilding() ) { continue; }
    if ( buildnum == build.getNumber().toInteger() ) { continue; println "equals" }
    build.doStop()
  }
  ```
- or: [Properly Stop Only Running Pipelines](https://raw.githubusercontent.com/cloudbees/jenkins-scripts/master/ProperlyStopOnlyRunningPipelines.groovy)


## logRotator

{% hint style='tip' %}
> references:
> - [Class LogRotator](https://javadoc.jenkins.io/hudson/tasks/LogRotator.html)
> - [Jenkins : Manually run log rotation on all jobs](https://wiki.jenkins.io/display/JENKINS/Manually-run-log-rotation-on-all-jobs.html)
> - [jenkins/core/src/main/java/hudson/tasks/LogRotator.java](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/java/hudson/tasks/LogRotator.java)
{% endhint %}

### show logRotator
```groovy
List<String> projects = [ 'project' ]

Jenkins.instance.getAllItems(Job.class).findAll {
  projects.any { p -> it.fullName.startsWith(p) }
}.each {
  println """
    ~~> ${it.fullName} :

            artifactDaysToKeep : ${it.logRotator?.artifactDaysToKeep    ?: '' }
         artifactDaysToKeepStr : ${it.logRotator?.artifactDaysToKeepStr ?: '' }
             artifactNumToKeep : ${it.logRotator?.artifactNumToKeep     ?: '' }
          artifactNumToKeepStr : ${it.logRotator?.artifactNumToKeepStr  ?: '' }
                    daysToKeep : ${it.logRotator?.daysToKeep            ?: '' }
                 daysToKeepStr : ${it.logRotator?.daysToKeepStr         ?: '' }
                     numToKeep : ${it.logRotator?.numToKeep             ?: '' }
                  numToKeepStr : ${it.logRotator?.numToKeepStr          ?: '' }

    --------------------------------------------------------------------------------

       getArtifactDaysToKeep() : ${it.logRotator?.getArtifactDaysToKeep()    ?: '' }
    getArtifactDaysToKeepStr() : ${it.logRotator?.getArtifactDaysToKeepStr() ?: '' }
        getArtifactNumToKeep() : ${it.logRotator?.getArtifactNumToKeep()     ?: '' }
     getArtifactNumToKeepStr() : ${it.logRotator?.getArtifactNumToKeepStr()  ?: '' }
               getDaysToKeep() : ${it.logRotator?.getDaysToKeep()            ?: '' }
            getDaysToKeepStr() : ${it.logRotator?.getDaysToKeepStr()         ?: '' }
                getNumToKeep() : ${it.logRotator?.getNumToKeep()             ?: '' }
             getNumToKeepStr() : ${it.logRotator?.getNumToKeepStr()          ?: '' }

  """
}
```

## shared libs
{% hint style='tip' %}
> reference:
> - [Jenkins Shared Libraries Workshop](https://www.slideshare.net/roidelapluie/jenkins-shared-libraries-workshop)
> - [Extending with Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/)
{% endhint %}

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
> - [GrabResolver](http://docs.groovy-lang.org/latest/html/api/groovy/lang/GrabResolver.html)
> - [Dependency management with Grape](http://docs.groovy-lang.org/latest/html/documentation/grape.html)
> - [kellyrob99/setupNewServer.groovy](https://gist.github.com/kellyrob99/1907283)

```
@GrabResolver(name='jenkins', root='http://repo.jenkins-ci.org/public/')
@Grab(group='org.jenkins-ci.main', module='jenkins-core', version='2.9')
import jenkins.model.Jenkins
```

## [Asynchronous resource disposer](https://plugins.jenkins.io/resource-disposer)
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

## [others](https://wiki.jenkins.io/display/JENKINS/Jenkins-Script-Console.html)
- [Jenkins : Monitor and Restart Offline Slaves](https://wiki.jenkins.io/display/JENKINS/Monitor-and-Restart-Offline-Slaves.html)
- [Jenkins : Monitoring Scripts](https://wiki.jenkins.io/display/JENKINS/Monitoring-Scripts.html)
- [Jenkins : Printing a list of credentials and their IDs](https://wiki.jenkins.io/display/JENKINS/Printing-a-list-of-credentials-and-their-IDs.html)
- [Jenkins : Wipe workspaces for a set of jobs on all nodes](https://wiki.jenkins.io/display/JENKINS/Wipe-workspaces-for-a-set-of-jobs-on-all-nodes.html)
- [Jenkins : Invalidate Jenkins HTTP sessions](https://wiki.jenkins.io/display/JENKINS/Invalidate-Jenkins-HTTP-sessions.html)
- [Jenkins : Grant Cancel Permission for user and group that have Build permission](https://wiki.jenkins.io/display/JENKINS/Grant-Cancel-Permission-for-user-and-group-that-have-Build-permission.html)
