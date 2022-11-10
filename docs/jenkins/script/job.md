<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [jobs](#jobs)
  - [get name and classes](#get-name-and-classes)
  - [list all jobs and folders](#list-all-jobs-and-folders)
  - [list all abstract Project](#list-all-abstract-project)
  - [disable and enable jobs](#disable-and-enable-jobs)
    - [disable all particular projects jobs](#disable-all-particular-projects-jobs)
    - [undo disable jobs in particular projects](#undo-disable-jobs-in-particular-projects)
    - [find all disabled projects/jobs](#find-all-disabled-projectsjobs)
  - [get single job properties](#get-single-job-properties)
  - [get particular job status](#get-particular-job-status)
  - [Find Jenkins projects that build periodically](#find-jenkins-projects-that-build-periodically)
  - [list job which running for more than 24 hours](#list-job-which-running-for-more-than-24-hours)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> javadoc
> - [org.jenkinsci.plugins.workflow.job.WorkflowJob](https://javadoc.jenkins.io/plugin/workflow-job/org/jenkinsci/plugins/workflow/job/WorkflowJob.html)
> - [hudson.model.AbstractProject<P,R>](https://javadoc.jenkins-ci.org/hudson/model/AbstractProject.html)
> source code:
> - [AbstractBuild.java](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/java/hudson/model/AbstractBuild.java)
> sample code:
> - [Jenkins : Failed Jobs](https://wiki.jenkins.io/display/JENKINS/Failed-Jobs.html)
{% endhint %}


# [jobs](https://support.cloudbees.com/hc/en-us/articles/226941767-Groovy-to-list-all-jobs)

## get name and classes
```groovy
Jenkins.instance.getAllItems(Job.class).each {
  println it.name + " -> " + it.fullName + ' ~> ' + it.class
}
```
- result
  ```
  marslo - class org.jenkinsci.plugins.workflow.job.WorkflowJob
  fs - class hudson.model.FreeStyleProject
  ```

## list all jobs and folders
```groovy
Jenkins.instance.getAllItems(AbstractItem.class).each {
  println(it.fullName)
}
```
- result:
  ```
  marslo/marslo
  marslo/fs
  ```

## [list all abstract Project](https://github.com/samrocketman/jenkins-script-console-scripts/blob/main/find-all-freestyle-jobs-using-shell-command.groovy)

{% hint style='tip' %}
> Abstract Project: freestyle, maven, etc...
{% endhint %}

```groovy
Jenkins.instance.getAllItems( AbstractProject.class ).each {
  println it.fullName
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