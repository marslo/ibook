<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [list items](#list-items)
  - [get name and classes](#get-name-and-classes)
  - [list all jobs and folders](#list-all-jobs-and-folders)
  - [list all pipeline jobs](#list-all-pipeline-jobs)
  - [list all abstract Project](#list-all-abstract-project)
  - [list all folders](#list-all-folders)
  - [list deactive jobs](#list-deactive-jobs)
- [disable and enable jobs](#disable-and-enable-jobs)
  - [disable all particular projects jobs](#disable-all-particular-projects-jobs)
  - [undo disable jobs in particular projects](#undo-disable-jobs-in-particular-projects)
  - [find all disabled projects/jobs](#find-all-disabled-projectsjobs)
- [get pipeline definitions](#get-pipeline-definitions)
  - [get pipeline scriptPath](#get-pipeline-scriptpath)
  - [get pipeline scm branch](#get-pipeline-scm-branch)
  - [get pipeline scm definition](#get-pipeline-scm-definition)
  - [get pipeline bare script](#get-pipeline-bare-script)
- [get logRotator](#get-logrotator)
- [get single job properties](#get-single-job-properties)
- [get particular job status](#get-particular-job-status)
- [Find Jenkins projects that build periodically](#find-jenkins-projects-that-build-periodically)
- [list job which running for more than 24 hours](#list-job-which-running-for-more-than-24-hours)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [groovy to list all jobs](https://support.cloudbees.com/hc/en-us/articles/226941767-Groovy-to-list-all-jobs)
>
> javadoc
> - [org.jenkinsci.plugins.workflow.job.WorkflowJob](https://javadoc.jenkins.io/plugin/workflow-job/org/jenkinsci/plugins/workflow/job/WorkflowJob.html)
> - [hudson.model.AbstractProject<P,R>](https://javadoc.jenkins-ci.org/hudson/model/AbstractProject.html)
> - [com.cloudbees.hudson.plugins.folder.Folder](https://javadoc.jenkins.io/plugin/cloudbees-folder/com/cloudbees/hudson/plugins/folder/Folder.html)
>
> source code:
> - [AbstractBuild.java](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/java/hudson/model/AbstractBuild.java)
>
> sample code:
> - [Jenkins : Failed Jobs](https://wiki.jenkins.io/display/JENKINS/Failed-Jobs.html)
{% endhint %}


## list items
### get name and classes
```groovy
Jenkins.instance.getAllItems( Job.class ).each {
  println it.name + " -> " + it.fullName + ' ~> ' + it.class
}
```
- result
  ```
  marslo - class org.jenkinsci.plugins.workflow.job.WorkflowJob
  fs - class hudson.model.FreeStyleProject
  ```

### list all jobs and folders
```groovy
Jenkins.instance.getAllItems( AbstractItem.class ).each {
  println(it.fullName)
}
```
- result:
  ```
  marslo/marslo
  marslo/fs
  ```

### list all pipeline jobs
```groovy
import org.jenkinsci.plugins.workflow.job.WorkflowJob

Jenkins.instance.getAllItems( WorkflowJob.class ).each {
   println it.fullName
}
```

### [list all abstract Project](https://github.com/samrocketman/jenkins-script-console-scripts/blob/main/find-all-freestyle-jobs-using-shell-command.groovy)

{% hint style='tip' %}
> Abstract Project: freestyle, maven, etc...
{% endhint %}

```groovy
Jenkins.instance.getAllItems( AbstractProject.class ).each {
  println it.fullName
}
```

### list all folders
```groovy
import com.cloudbees.hudson.plugins.folder.Folder

Jenkins.instance.getAllItems( Folder.class ).each {
  println it.fullName + ' ~> ' + it.getClass()
}
```

### list deactive jobs

> [!NOTE]
> List jobs haven't been built in 6 months

```groovy
final long CURRENT_TIME  = System.currentTimeMillis()
final long BENCH_MARK    = 6*30*24*60*60

Jenkins.instance.getAllItems( Job.class ).collect { project ->
  project.getLastBuild()
}.findAll { build ->
  build && ( CURRENT_TIME - build.startTimeInMillis ) / 1000 > BENCH_MARK
}
```

## disable and enable jobs
### disable all particular projects jobs
```groovy
List<String> projects = [ 'project-1', 'project-2', 'project-n' ]

Jenkins.instance.getAllItems(Job.class).findAll {
  projects.any { p -> it.fullName.startsWith(p) }
}.each {
  println "~~> ${it.fullName}"
  it.disabled = true
  it.save()
}
```

### undo disable jobs in particular projects
```groovy
List<String> projects = [ 'project-1', 'project-2', 'project-n' ]

Jenkins.instance.getAllItems(Job.class).findAll {
  it.disabled && projects.any{ p -> it.fullName.startsWith(p) }
}.each {
  println "~~> ${it.fullName}"
  it.disabled = false
  it.save()
}
```

### find all disabled projects/jobs
```groovy
Jenkins.instance
       .getAllItems( Job.class )
       .findAll { it.disabled }
       .collect { it.fullName }
```

- or
  ```groovy
  jenkins.model
         .Jenkins
         .instance
         .getAllItems(jenkins.model.ParameterizedJobMixIn.ParameterizedJob.class)
         .findAll{ it.disabled }
         .each {
           println it.fullName;
         }
  ```

- or
  ```groovy
  jenkins.model
         .Jenkins
         .instance
         .getAllItems(jenkins.model.ParameterizedJobMixIn.ParameterizedJob.class)
         .findAll{ it.disabled }
         .collect { it.fullName }
  ```

## get pipeline definitions
> [!TIP]
> - [How to get the pipeline configuration field 'Script Path' when executing the Jenkinsfile?](https://stackoverflow.com/a/50022871/2940319)
> - [Groovy script to get Jenkins pipeline's script path](https://stackoverflow.com/a/70728550/2940319)
> - [WorkflowDefinitionContext.groovy](https://github.com/jenkinsci/job-dsl-plugin/blob/master/job-dsl-core/src/main/groovy/javaposse/jobdsl/dsl/helpers/workflow/WorkflowDefinitionContext.groovy)
> - [BuildConfigToJobMapper.java](https://github.com/openshift/jenkins-sync-plugin/blob/master/src/main/java/io/fabric8/jenkins/openshiftsync/BuildConfigToJobMapper.java)

### get pipeline scriptPath

> [!TIP]
> - [Class CpsScmFlowDefinition](https://javadoc.jenkins.io/plugin/workflow-cps/org/jenkinsci/plugins/workflow/cps/CpsScmFlowDefinition.html)

```groovy
import org.jenkinsci.plugins.workflow.job.WorkflowJob

Jenkins.instance.getAllItems(WorkflowJob.class).findAll{
  it.definition instanceof org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
}.each {
  println it.fullName.toString().padRight(30) + ' ~> ' + it?.definition?.getScriptPath()
}

"DONE"

-- result --
marslo/sandbox/sandbox         ~> jenkins/jenkinsfile/sandbox.Jenkinsfile
marlso/sandbox/dump            ~> jenkins/jenkinsfile/dump.Jenkinsfile
...
```

### get pipeline scm branch
```groovy
import org.jenkinsci.plugins.workflow.job.WorkflowJob

String branch = 'develop'

jenkins.model.Jenkins.instance.getAllItems(WorkflowJob.class).findAll{
  it.definition instanceof org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
}.findAll {
  ! ( it.definition?.scm instanceof hudson.scm.NullSCM ) &&
  ! it.definition?.scm?.branches?.any{ it.getName().contains(branch) }
}.each {
  println it.fullName.toString().padRight(50) + ' : ' +
          it.definition?.scm?.branches?.collect{ it.getName() }?.join(', ')
}

"DONE"

-- result --
$ ssh jenkins.domain.com groovy =< scmBranchPath.groovy
marslo/sandbox/sandbox                             : refs/heads/sandbox/marslo
marslo/sandbox/dump                                : refs/heads/utility
```

### get pipeline scm definition

> [!TIP]
> - [Class SCM](https://javadoc.jenkins.io/hudson/scm/SCM.html)
> - [Class hudson.plugins.git.GitSCM](https://javadoc.jenkins.io/plugin/git/hudson/plugins/git/GitSCM.html)
> - [Class org.eclipse.jgit.transport.RemoteConfig](https://archive.eclipse.org/jgit/docs/jgit-2.0.0.201206130900-r/apidocs/org/eclipse/jgit/transport/RemoteConfig.html)

```groovy
import org.jenkinsci.plugins.workflow.job.WorkflowJob

Jenkins.instance.getAllItems(WorkflowJob.class).findAll{
  it.definition instanceof org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
}.each {
  println it.fullName.toString().padRight(30) +
          (it.definition?.scm?.branches?.join() ?: '').padRight(30) +
          it.definition?.scm?.repositories?.collect{ it.getURIs() }?.flatten()?.join()
}

"DONE"

-- result --
marslo/sandbox/sandbox        */main                        git://github.com:marslo/pipelines
marslo/sandbox/dump           */dev                         git://github.com:marslo/pipelines
...
```

#### check pipeline not get from particular branche

> [!TIP]
> - [hudson.plugins.git.BranchSpec](https://javadoc.jenkins.io/plugin/git/hudson/plugins/git/BranchSpec.html)

```groovy
import org.jenkinsci.plugins.workflow.job.WorkflowJob

String branch = 'develop'

Jenkins.instance.getAllItems(WorkflowJob.class).findAll{
  it.definition instanceof org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition &&
  ! ( it.definition.scm instanceof hudson.scm.NullSCM )
}.findAll {
  ! it.definition?.scm?.branches?.any{ it.getName().contains(branch) }
}.each {
  println it.fullName.toString().padRight(50) + ' : ' +
          it.definition?.scm?.branches?.collect{ it.getName() }?.join(', ')
}

"DONE"
```

### get pipeline bare script

> [!TIP]
> - [Class CpsFlowDefinition](https://javadoc.jenkins.io/plugin/workflow-cps/org/jenkinsci/plugins/workflow/cps/CpsFlowDefinition.html)

```bash
import org.jenkinsci.plugins.workflow.job.WorkflowJob

Jenkins.instance.getAllItems(WorkflowJob.class).findAll{
  it.definition instanceof org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition
}.each {
  println it.fullName.toString().padRight(30) + ' ~> ' + it?.definition?.getScript()
}

"DONE"
```

## get logRotator
```groovy
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import hudson.tasks.LogRotator

String JOB_PATTERN = 'pattern'

Jenkins.instance.getAllItems(WorkflowJob.class).findAll{
  it.fullName.startsWith( JOB_PATTERN ) && it.buildDiscarder
}.each { job ->
  LogRotator discarder = job.buildDiscarder
  println job.fullName.toString().padRight(30) + ' : ' +
          "builds=(${discarder.daysToKeep} days, ${discarder.numToKeep} total) " +
          "artifacts=(${discarder.artifactDaysToKeep} days, ${discarder.artifactNumToKeep} total)"
}

"DONE"
```

## get single job properties
> [Java Code Examples for jenkins.model.Jenkins#getItemByFullName()](https://www.programcreek.com/java-api-examples/?class=jenkins.model.Jenkins&method=getItemByFullName)

```groovy
def job = Jenkins.instance.getItemByFullName('<group>/<name>')
println """
       job.getClass() : ${job.getClass()}
    job.isBuildable() : ${job.isBuildable()}
  job.getFirstBuild() : ${job.getFirstBuild()}
         job.getACL() : ${job.getACL()}
  "======================="
      job.getBuilds() : ${job.getBuilds()}
"""
```

## get particular job status
```groovy
def job = Jenkins.instance.getItemByFullName('<group>/<name>')
println """
  Last success : ${job.getLastSuccessfulBuild()}
    All builds : ${job.getBuilds().collect{ it.getNumber() }}
    Last build : ${job.getLastBuild()}
   Is building : ${job.isBuilding()}
"""
```

## [Find Jenkins projects that build periodically](https://support.cloudbees.com/hc/en-us/articles/360032285111-Find-Jenkins-projects-that-build-periodically)

- example 1:
  ```groovy
  import hudson.model.*
  import hudson.triggers.*
  TriggerDescriptor TIMER_TRIGGER_DESCRIPTOR = Hudson.instance.getDescriptorOrDie(TimerTrigger.class)

  for(item in Jenkins.instance.getAllItems(Job))
  {
    def timertrigger = item.getTriggers().get(TIMER_TRIGGER_DESCRIPTOR)
    if (timertrigger) {
      if (item.class.canonicalName == "hudson.model.FreeStyleProject") {
        item.removeTrigger(TIMER_TRIGGER_DESCRIPTOR)
        println(item.name + " Build periodically disabled");
      }
      else {
        println(item.name + " Build periodically remains enabled; not as Freestyle project");
      }
    }
  }
  ```

- example 2:
  ```groovy
  Jenkins.instance.getAllItems(Job).each{
    def jobBuilds=it.getBuilds()

        // Check the last build only
        jobBuilds[0].each { build ->
          def runningSince = groovy.time.TimeCategory.minus( new Date(), build.getTime() )
          def currentStatus = build.buildStatusSummary.message
          def cause = build.getCauses()[0] //we keep the cause

        //triggered by a user
        def user = cause instanceof Cause.UserIdCause? cause.getUserId():null;

        if( !user ) {
          println "[AUTOMATION] ${build}"
        }
        else
        {
          println "[${user}] ${build}"
        }
      }
  }
  return
  ```

## [list job which running for more than 24 hours](https://raw.githubusercontent.com/cloudbees/jenkins-scripts/master/builds-running-more-than-24h.groovy)

> [!TIP]
> only for `lastBuild`.

```bash
/*
   We had to write this script several times. Time to have it stored, it is a very simple approach but will serve as starting point for more refined approaches.
 */
Jenkins.instance.getAllItems( Job )
                .findAll{ job -> job.isBuildable() }
                .each { job ->
                  def myBuild= job.getLastBuild()
                  def runningSince = groovy.time.TimeCategory.minus( new Date(), myBuild.getTime() )
                  if ( runningSince.hours >= 24 ){
                    println job.name +"---- ${runningSince.hours} hours:${runningSince.minutes} minutes"
                  }
                }
return null
```
