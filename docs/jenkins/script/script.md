<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Script Console](#script-console)
  - [usage](#usage)
  - [basic usage](#basic-usage)
  - [execute shell script in console](#execute-shell-script-in-console)
- [jobs](#jobs)
  - [get build status](#get-build-status)
  - [get all builds status during certain start-end time](#get-all-builds-status-during-certain-start-end-time)
  - [list job which running for more than 24 hours](#list-job-which-running-for-more-than-24-hours)
  - [shelve jobs](#shelve-jobs)
- [List plugins](#list-plugins)
  - [via api](#via-api)
  - [simple list](#simple-list)
  - [List plugin and dependencies](#list-plugin-and-dependencies)
- [scriptApproval](#scriptapproval)
  - [backup & restore all scriptApproval items](#backup--restore-all-scriptapproval-items)
  - [automatic approval all pending](#automatic-approval-all-pending)
  - [disable the scriptApproval](#disable-the-scriptapproval)
- [abort](#abort)
  - [abort a build](#abort-a-build)
  - [abort running builds if new one is running](#abort-running-builds-if-new-one-is-running)
- [shared libes](#shared-libes)
  - [vars](#vars)
  - [src](#src)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [Script Console](https://www.jenkins.io/doc/book/managing/script-console/)
> - [Jenkins Features Controlled with System Properties](https://www.jenkins.io/doc/book/managing/system-properties/)
> - [samrocketman/jenkins-script-console-scripts](https://github.com/samrocketman/jenkins-script-console-scripts)
> - [jenkinsci/jenkins-scripts](https://github.com/jenkinsci/jenkins-scripts)
> - [cloudbees/jenkins-scripts](https://github.com/cloudbees/jenkins-scripts)
> - [mubbashir/Jenkins+Script+Console.md](https://gist.github.com/mubbashir/484903fda934aeea9f30)
> - [Sam Gleske’s jenkins-script-console-scripts repository](https://github.com/samrocketman/jenkins-script-console-scripts)
> - [Sam Gleske’s jenkins-bootstrap-shared repository](https://github.com/samrocketman/jenkins-bootstrap-shared)
> - [Some scripts at JBoss.org](http://community.jboss.org/wiki/HudsonHowToDebug)
> - [mikejoh/jenkins-and-groovy-snippets.md](https://gist.github.com/mikejoh/9a721d1e6de7574059dcb8f851692be9)
{% endhint %}


## [Script Console](https://www.jenkins.io/doc/book/managing/script-console/)
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

## [jobs](https://support.cloudbees.com/hc/en-us/articles/226941767-Groovy-to-list-all-jobs)
> get more: [jobs & builds](./build.md)

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

## List plugins
### [via api](./api.md#list-plugins)
### [simple list](https://stackoverflow.com/a/35292719/2940319)
```groovy
Jenkins.instance.pluginManager.plugins.each { plugin ->
  println ( "${plugin.getDisplayName()} (${plugin.getShortName()}): ${plugin.getVersion()}" )
}
```

### [List plugin and dependencies](https://stackoverflow.com/a/56864983/2940319)
```groovy
println "Jenkins Instance : " + Jenkins.getInstance().getComputer('').getHostName() + " - " + Jenkins.getInstance().getRootUrl()
println "Installed Plugins: "
println "=================="
Jenkins.instance.pluginManager.plugins.sort(false) { a, b -> a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()}.each { plugin ->
    println "${plugin.getShortName()}: ${plugin.getVersion()} | ${plugin.getDisplayName()}"
}

println ""
println "Plugins Dependency tree (...: dependencies; +++: dependants) :"
println "======================="
Jenkins.instance.pluginManager.plugins.sort(false) { a, b -> a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()}.each { plugin ->
  println "${plugin.getShortName()}: ${plugin.getVersion()} | ${plugin.getDisplayName()} "
  println "+++ ${plugin.getDependants()}"
  println "... ${plugin.getDependencies()}"
  println ''
}
```

## scriptApproval
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
  scriptApproval.pendingScripts.each {
    scriptApproval.approveScript(it.hash)
  }
  ```

- [Job DSL support for ScriptApproval](https://issues.jenkins-ci.org/browse/JENKINS-31201?focusedCommentId=285330&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-285330)
  ```groovy
  import jenkins.model.Jenkins

  def scriptApproval = Jenkins.instance.getExtensionList('org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval')[0]
  def hashesToApprove = scriptApproval.pendingScripts.findAll{ it.script.startsWith(approvalPrefix) }.collect{ it.getHash() }
  hashesToApprove.each {
    scriptApproval.approveScript(it)
  }
  ```

### [disable the scriptApproval](https://stackoverflow.com/a/49372857/2940319)
> file: `$JENKINS_HOME/init.groovy.d/disable-script-security.groovy`

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
       .finish(
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
build.getProject()._getRuns().iterator().each{ run ->
  def exec = run.getExecutor()
    //if the run is not a current build and it has executor (running) then stop it
    if( run!=build && exec!=null ){
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
    build.doStop();
  }
  ```
- or: [Properly Stop Only Running Pipelines](https://raw.githubusercontent.com/cloudbees/jenkins-scripts/master/ProperlyStopOnlyRunningPipelines.groovy)


## shared libes
{% hint style='tip' %}
> reference:
> - []()
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
      returnStdout: true,
      script: "set +x; cat /proc/self/cpuset"
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



assert (cpuset =~ pattern).find() == true  // == true
assert (cpuset =~ pattern).lookingAt() == true // == true
assert (cpuset =~ pattern).matches() == true //  = = false
