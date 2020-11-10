<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Script Console](#script-console)
  - [usage](#usage)
  - [examples](#examples)
- [jobs](#jobs)
  - [list all Abstract Project](#list-all-abstract-project)
  - [list all jobs and folders](#list-all-jobs-and-folders)
  - [get name and classes](#get-name-and-classes)
  - [find all disabled projects/jobs](#find-all-disabled-projectsjobs)
  - [get particular job status](#get-particular-job-status)
  - [get build status](#get-build-status)
  - [get all failure builds in last 24 hours](#get-all-failure-builds-in-last-24-hours)
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
  - [abort a job](#abort-a-job)
  - [abort running builds if new one is running](#abort-running-builds-if-new-one-is-running)
  - [cancel queue builds(https://xanderx.com/post/cancel-all-queued-jenkins-jobs/)](#cancel-queue-buildshttpsxanderxcompostcancel-all-queued-jenkins-jobs)
  - [stop all queue and running jobs](#stop-all-queue-and-running-jobs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


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
      "script=$(< ./somescript.groovy)" https://jenkins/scriptText
    ```
  - via python
    ```bash
    with open('somescript.groovy', 'r') as fd:
        data = fd.read()
    r = requests.post('https://jenkins/scriptText', auth=('username', 'api-token'), data={'script': data})
    ```

### examples
- [CloudBees jenkins-scripts repository](https://github.com/cloudbees/jenkins-scripts)
- [Jenkins CI jenkins-scripts repository](https://github.com/jenkinsci/jenkins-scripts)
- [Sam Gleske’s jenkins-script-console-scripts repository](https://github.com/samrocketman/jenkins-script-console-scripts)
- [Sam Gleske’s jenkins-bootstrap-shared repository](https://github.com/samrocketman/jenkins-bootstrap-shared)
- [Some scripts at JBoss.org](http://community.jboss.org/wiki/HudsonHowToDebug)

## [jobs](https://support.cloudbees.com/hc/en-us/articles/226941767-Groovy-to-list-all-jobs)
### list all Abstract Project
  > Abstract Project: freestyle, maven, etc...

  ```groovy
  Jenkins.instance.getAllItems(AbstractProject.class).each {
    println it.fullName;
  }
```

### list all jobs and folders
```groovy
Jenkins.instance.getAllItems(AbstractItem.class).each {
  println(it.fullName)
};
== result:
marslo/marslo
marslo/fs
```

### get name and classes
```groovy
Jenkins.instance.getAllItems(Job.class).each {
  println it.name + " - " + it.class
}

== result
marslo - class org.jenkinsci.plugins.workflow.job.WorkflowJob
fs - class hudson.model.FreeStyleProject
```

### find all disabled projects/jobs
```groovy
jenkins.model.Jenkins.instance.getAllItems(jenkins.model.ParameterizedJobMixIn.ParameterizedJob.class).findAll{ it -> it.disabled }.each {
  println it.fullName;
}
```

### get particular job status
```groovy
def job = Jenkins.instance.getItemByFullName('/<group-name>/<job-name>')
println """
  Last success : ${job.getLastSuccessfulBuild()}
    All builds : ${job.getBuilds().collect{ it.getNumber()}}
    Last build : ${job.getLastBuild()}
   Is building : ${job.isBuilding()}
"""
```

### get build status
```groovy
String jobPattern = '<group-name>/<job-name>'
Map<String, Map<String, String>> results = [:]
int sum = 0

Jenkins.instance.getAllItems( Job.class ).each { project ->
  if ( project.fullName.contains(jobPattern) ) {
    results."$project.fullName" = [ SUCCESS:0, UNSTABLE:0, FAILURE:0, ABORTED:0 ]
    def build = project.getLastBuild()
    while ( build ) {
      //println "$project.name;$build.id;$build.result"
      results."${project.fullName}"."${build.result}" = results."${project.fullName}"."${build.result}" + 1
      build=build.getPreviousBuild()
    }
  }
}
results.each{ name, map ->
  sum = map.values().sum()
  println "${name}: ${sum} : "
  map.each{ r, c ->
    println "    ${r}: ${c}: \tpercentage: " + (sum ? "${c * 100 / sum}%" : '0%')
  }
}
"DONE"
```

### [get all failure builds in last 24 hours](https://stackoverflow.com/a/60375862/2940319)
```groovy
import hudson.model.Job
import hudson.model.Result
import hudson.model.Run
import java.util.Calendar
import jenkins.model.Jenkins

//24 hours in a day, 3600 seconds in 1 hour, 1000 milliseconds in 1 second
  long time_in_millis = 24*3600*1000
Calendar rightNow = Calendar.getInstance()

  Jenkins.instance.getAllItems(Job.class).findAll { Job job ->
    !job.isBuilding()
  }.collect { Job job ->
    //find all matching items and return a list but if null then return an empty list
    job.builds.findAll { Run run ->
      job.lastBuild.result == Result.FAILURE && ((rightNow.getTimeInMillis() - run.getStartTimeInMillis()) <= time_in_millis)
    } ?: []
  }.sum().each{ job ->
    println "${job}"
  }
```

### [list job which running for more than 24 hours](https://raw.githubusercontent.com/cloudbees/jenkins-scripts/master/builds-running-more-than-24h.groovy)
```bash
/*
   We had to write this script several times. Time to have it stored, it is a very simple approach but will serve as starting point for more refined approaches.
 */
Jenkins.instance.getAllItems(Job).each(){ job -> job.isBuildable()
  if (job.isBuilding()){
    def myBuild= job.getLastBuild()
      def runningSince= groovy.time.TimeCategory.minus( new Date(), myBuild.getTime() )
      if (runningSince.hours >= 24){
        println job.name +"---- ${runningSince.hours} hours:${runningSince.minutes} minutes"
      }
  }
}
return null
```

### [shelve jobs](https://support.cloudbees.com/hc/en-us/articles/236353928-Groovy-Scripts-To-Shelve-Jobs)
```groovy
//You have to install the Shelve Project Plugin on your Jenkins Master
//The maximum value for daysBack is 365, going beyond 365 will break the script.

import org.jvnet.hudson.plugins.shelveproject.ShelveProjectTask

def daysBack=365;
Jenkins.instance.getAllItems(AbstractProject.class).each{ it->
  def lastBuild=it.getLastBuild()
    if(lastBuild != null){
      def back = Calendar.getInstance()
        back.set(Calendar.DAY_OF_YEAR,back.get(Calendar.DAY_OF_YEAR)-daysBack)
        if (lastBuild.getTime().compareTo(back.getTime()) < 0) {
          println it.name + " was built over " + daysBack + " days ago: " + lastBuild.getTime()
            if (it instanceof AbstractProject){
              def spt=  new ShelveProjectTask(it)
                Hudson.getInstance().getQueue().schedule(spt , 0 );
            }else{
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
Jenkins.instance.pluginManager.plugins.each{ plugin ->
  println ("${plugin.getDisplayName()} (${plugin.getShortName()}): ${plugin.getVersion()}")
}
```

### [List plugin and dependencies](https://stackoverflow.com/a/56864983/2940319)
```groovy
println "Jenkins Instance : " + Jenkins.getInstance().getComputer('').getHostName() + " - " + Jenkins.getInstance().getRootUrl()
println "Installed Plugins: "
println "=================="
Jenkins.instance.pluginManager.plugins.sort(false) { a, b -> a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()}.each { plugin ->
  println "${plugin.getShortName()}:${plugin.getVersion()} | ${plugin.getDisplayName()} "
}

println ""
println "Plugins Dependency tree (...: dependencies; +++: dependants) :"
println "======================="
Jenkins.instance.pluginManager.plugins.sort(false) { a, b -> a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()}.each { plugin ->
  println "${plugin.getShortName()}:${plugin.getVersion()} | ${plugin.getDisplayName()} "
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

    List scriptList = ['method hudson.model.Job getLastSuccessfulBuild', 'method hudson.model.Node getNodeName']

    scriptList.each {
      approveSignature(it)
    }
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
### [abort a job](https://stackoverflow.com/a/26306081/2940319)
```bash
  Jenkins.instance.getItemByFullName("JobName")
.getBuildByNumber(JobNumber)
  .finish(
          hudson.model.Result.ABORTED,
          new java.io.IOException("Aborting build")
         );
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

      while (previousBuild != null) {
        if (previousBuild.isInProgress()) {
          def executor = previousBuild.getExecutor()
            if (executor != null) {
              echo ">> Aborting older build #${previousBuild.number}"
                executor.interrupt(Result.ABORTED, new UserInterruption(
                                                                        "Aborted by newer build #${currentBuild.number}"
                                                                       ))
            }
        }

        previousBuild = previousBuild.getPreviousBuildInProgress()
      }
  }
  ```

- or: [cancel builds same job](https://raw.githubusercontent.com/cloudbees/jenkins scripts/master/cancel builds same job.groovy)
  ```bash
  /*
     Author: Isaac S Cohen
     This script works with workflow to cancel other running builds for the same job
     Use case: many build may go to QA, but only the build that is accepted is needed,
     the other builds in the workflow should be aborted
   */

    def jobname = env.JOB_NAME
  def buildnum = env.BUILD_NUMBER.toInteger()

  def job = Jenkins.instance.getItemByFullName(jobname)
    for (build in job.builds) {
      if (!build.isBuilding()) { continue; }
      if (buildnum == build.getNumber().toInteger()) { continue; println "equals" }
      build.doStop();
    }
  ```
- or: [Properly Stop Only Running Pipelines](https://raw.githubusercontent.com/cloudbees/jenkins-scripts/master/ProperlyStopOnlyRunningPipelines.groovy)

### cancel queue builds(https://xanderx.com/post/cancel-all-queued-jenkins-jobs/)
```groovy
Jenkins.instance.queue.clear()
```

### [stop all queue and running jobs](https://stackoverflow.com/a/47631794/2940319)
```groovy
import java.util.ArrayList
import hudson.model.*;
import jenkins.model.Jenkins

// Remove everything which is currently queued
def q = Jenkins.instance.queue
for (queued in Jenkins.instance.queue.items) {
  q.cancel(queued.task)
}

// stop all the currently running jobs
for (job in Jenkins.instance.items) {
  stopJobs(job)
}

def stopJobs(job) {
  if (job in com.cloudbees.hudson.plugins.folder.Folder) {
    for (child in job.items) {
      stopJobs(child)
    }
  } else if (job in org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject) {
    for (child in job.items) {
      stopJobs(child)
    }
  } else if (job in org.jenkinsci.plugins.workflow.job.WorkflowJob) {

    if (job.isBuilding()) {
      for (build in job.builds) {
      build.doKill()
      }
    }
  }
}
```
