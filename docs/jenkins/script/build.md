<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [jobs](#jobs)
  - [get name and classes](#get-name-and-classes)
  - [list all jobs and folders](#list-all-jobs-and-folders)
  - [list all Abstract Project](#list-all-abstract-project)
  - [find all disabled projects/jobs](#find-all-disabled-projectsjobs)
  - [get single job](#get-single-job)
  - [get particular job status](#get-particular-job-status)
- [build](#build)
  - [setup next build number of particular job](#setup-next-build-number-of-particular-job)
  - [abort a build](#abort-a-build)
  - [get build status](#get-build-status)
  - [list job which running for more than 24 hours](#list-job-which-running-for-more-than-24-hours)
  - [list all build history within 24 hours](#list-all-build-history-within-24-hours)
  - [get build time](#get-build-time)
  - [get particular jobs status within 24 hours](#get-particular-jobs-status-within-24-hours)
  - [get all last builds failure in last 24 hours](#get-all-last-builds-failure-in-last-24-hours)
  - [cancel queue builds](#cancel-queue-builds)
  - [stop all queue and running jobs](#stop-all-queue-and-running-jobs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> javadoc
> - [org.jenkinsci.plugins.workflow.job.WorkflowJob](https://javadoc.jenkins.io/plugin/workflow-job/org/jenkinsci/plugins/workflow/job/WorkflowJob.html)
> - [org.jenkinsci.plugins.workflow.job.WorkflowRun](https://javadoc.jenkins.io/plugin/workflow-job/org/jenkinsci/plugins/workflow/job/WorkflowRun.html)
> - [hudson.model.AbstractProject<P,R>](https://javadoc.jenkins-ci.org/hudson/model/AbstractProject.html)
{% endhint %}

## [jobs](https://support.cloudbees.com/hc/en-us/articles/226941767-Groovy-to-list-all-jobs)

### get name and classes
```groovy
Jenkins.instance.getAllItems(Job.class).each {
  println it.name + " -> " + it.fullName + ' ~> ' + it.class
}

== result
marslo - class org.jenkinsci.plugins.workflow.job.WorkflowJob
fs - class hudson.model.FreeStyleProject
```

### list all jobs and folders
```groovy
Jenkins.instance.getAllItems(AbstractItem.class).each {
  println(it.fullName)
}

== result:
marslo/marslo
marslo/fs
```

### [list all Abstract Project](https://github.com/samrocketman/jenkins-script-console-scripts/blob/main/find-all-freestyle-jobs-using-shell-command.groovy)
> Abstract Project: freestyle, maven, etc...

```groovy
Jenkins.instance.getAllItems(AbstractProject.class).each {
  println it.fullName
}
```

### find all disabled projects/jobs
```groovy
jenkins.model.Jenkins.instance.getAllItems(jenkins.model.ParameterizedJobMixIn.ParameterizedJob.class).findAll{ it ->
  it.disabled
}.each {
  println it.fullName;
}
```

- or
  ```groovy
  jenkins.model.Jenkins.instance.getAllItems(jenkins.model.ParameterizedJobMixIn.ParameterizedJob.class).findAll{ it ->
    it.disabled
  }.collect { it.fullName }
  ```

### get single job
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

### get particular job status
```groovy
def job = Jenkins.instance.getItemByFullName('<group>/<name>')
println """
  Last success : ${job.getLastSuccessfulBuild()}
    All builds : ${job.getBuilds().collect{ it.getNumber()}}
    Last build : ${job.getLastBuild()}
   Is building : ${job.isBuilding()}
"""
```

## build
### setup next build number of particular job
```groovy
Jenkins.instance.getItemByFullName("/path/to/job").updateNextBuildNumber(n)
```

### [abort a build](https://stackoverflow.com/a/26306081/2940319)
```groovy
Jenkins.instance.getItemByFullName("JobName")
       .getBuildByNumber(JobNumber)
       .finish(
               hudson.model.Result.ABORTED,
               new java.io.IOException("Aborting build")
       )
```

- or [cancel builds in same job](https://raw.githubusercontent.com/cloudbees/jenkins scripts/master/cancel builds same job.groovy)
  ```groovy
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

### [get build status](https://stackoverflow.com/a/28039134/2940319)
```groovy
final String JOB_PATTERN = '<group>/<name>'
Map<String, Map<String, String>> results = [:]
int sum = 0

Jenkins.instance.getAllItems( Job.class ).each { project ->
  if ( project.fullName.contains(JOB_PATTERN) ) {
    results."${project.fullName}" = [ SUCCESS:0, UNSTABLE:0, FAILURE:0, ABORTED:0, INPROGRESS:0 ]
    def build = project.getLastBuild()
    while ( build ) {
      // if job is building, then results."${project.fullName}"."${build.result}" will be null
      if ( build.isBuilding() ) {
        results."${project.fullName}".INPROGRESS = results."${project.fullName}".INPROGRESS + 1
      } else {
        // println "$project.name;$build.id;$build.result"
        results."${project.fullName}"."${build.result}" = results."${project.fullName}"."${build.result}" + 1
      }
      build = build.getPreviousBuild()
    }
  }
}
results.each{ name, status ->
  sum = status.values().sum()
  println "${name}: ${sum} : "
  status.each{ r, c ->
    println "\t${r}: ${c}: \t\tpercentage: " + (sum ? "${c * 100 / sum}%" : '0%')
  }
}
"DONE"
```

![build status](../../screenshot/jenkins/job-successful-failure-percentage.png)


### [list job which running for more than 24 hours](https://raw.githubusercontent.com/cloudbees/jenkins-scripts/master/builds-running-more-than-24h.groovy)
```bash
/*
   We had to write this script several times. Time to have it stored, it is a very simple approach but will serve as starting point for more refined approaches.
 */
Jenkins.instance.getAllItems(Job).each(){ job -> job.isBuildable()
  if (job.isBuilding()){
    def myBuild= job.getLastBuild()
      def runningSince = groovy.time.TimeCategory.minus( new Date(), myBuild.getTime() )
      if (runningSince.hours >= 24){
        println job.name +"---- ${runningSince.hours} hours:${runningSince.minutes} minutes"
      }
  }
}
return null
```

### [list all build history within 24 hours](https://gist.github.com/batmat/91faa3201ad2ae88e3d8)
```groovy
String JOB_PATTERN      = '<group>/<job>'
final long CURRENT_TIME = System.currentTimeMillis()
final int BENCH_MARK    = 1*24*60*60*1000                    // days * hours * minutes * seconds * microseconds (1000)

Jenkins.instance.getAllItems(Job.class).findAll { Job job ->
  job.fullName.contains(JOB_PATTERN)
}.collect { Job job ->
  def history = job.getBuilds().byTimestamp( CURRENT_TIME - BENCH_MARK, CURRENT_TIME )
  println """
    ${job.fullName}: ${history.size()}:
    history: ${history}
  """
}
"DONE"
```

### get build time
> reference
> - [Getting current timestamp in inline pipeline script using pipeline plugin of hudson](https://stackoverflow.com/a/55242657/2940319)

```groovy
import java.time.LocalDateTime
import java.time.LocalDate
import java.util.Calendar

final String JOB_PATTERN      = '<group>/<name>'
final LocalDateTime DATE_TIME = LocalDateTime.now()
final LocalDate DATE_TAG      = java.time.LocalDate.now()
final long CURRENT_TIME       = System.currentTimeMillis()
final long RIGHT_NOW          = Calendar.getInstance().getTimeInMillis()

println """
  ~~> current time :
       DATE_TIME : ${DATE_TIME}
        DATE_TAG : ${DATE_TAG}
    CURRENT_TIME : ${CURRENT_TIME}
       RIGHT_NOW : ${RIGHT_NOW}
"""

Jenkins.instance.getAllItems( Job.class ).each { job ->
  if ( job.fullName.contains(JOB_PATTERN) ) {
    def build = job.getLastBuild()
    println """
      ~~> ${job.getFullName()} : ${build.getId()} :
              build.getTimestampString() : ${build.getTimestampString()}
             build.getTimestampString2() : ${build.getTimestampString2()}
                         build.getTime() : ${build.getTime()}
                 build.startTimeInMillis : ${build.startTimeInMillis}
      build.startTimeInMillis.getClass() : ${build.startTimeInMillis.getClass()}
                                duration : ${groovy.time.TimeCategory.minus( new Date(), build.getTime() )}
  """
  }
}
"DONE"
```
![get build start time](../../screenshot/jenkins/job-get-build-time.png)


### get particular jobs status within 24 hours
```groovy
final String JOB_PATTERN = '<group>/<name>'
final long CURRENT_TIME  = System.currentTimeMillis()
final int BENCH_MARK     = 24*60*60*1000

Map<String, Map<String, String>> results = [:]
int sum = 0

Jenkins.instance.getAllItems( Job.class ).each { project ->
  if ( project.fullName.contains(JOB_PATTERN) ) {
    results."${project.fullName}" = [ SUCCESS:0, UNSTABLE:0, FAILURE:0, ABORTED:0 ]
    def build = project.getLastBuild()
    while ( build && (CURRENT_TIME - build.startTimeInMillis) <= BENCH_MARK ) {
      results."${project.fullName}"."${build.result}" = results."${project.fullName}"."${build.result}" + 1
      build = build.getPreviousBuild()
    }
  }
}

results.each{ name, status ->
  sum = status.values().sum()
  println "~~> ${name}: ${sum} : "
  status.each{ r, c ->
    println "\t${r}: ${c}: \tpercentage: " + (sum ? "${c * 100 / sum}%" : '0%')
  }
}
```

- or
  ```groovy
  final String JOB_PATTERN = '<group>'
  final long CURRENT_TIME  = System.currentTimeMillis()
  final int BENCH_MARK     = 1*24*60*60*1000

  Map<String, Map<String, String>> results = [:]
  int sum = 0

  Jenkins.instance.getAllItems( Job.class ).each { project ->
    if ( project.fullName.contains(JOB_PATTERN) && project.getBuilds().byTimestamp(CURRENT_TIME - BENCH_MARK, CURRENT_TIME).size() > 0 ) {
      results."${project.fullName}" = [ SUCCESS:0, UNSTABLE:0, FAILURE:0, ABORTED:0, INPROGRESS:0 ]
      def build = project.getLastBuild()

      while ( build && (CURRENT_TIME - build.startTimeInMillis) <= BENCH_MARK ) {
        if ( build.isBuilding() ) {
          results."${project.fullName}".INPROGRESS = results."${project.fullName}".INPROGRESS + 1
        } else {
          results."${project.fullName}"."${build.result}" = results."${project.fullName}"."${build.result}" + 1
        } // if job is building, then results."${project.fullName}"."${build.result}" will be null
        build = build.getPreviousBuild()
      } // traverse in the whole traverse builds

    } // if there's builds within 24 hours
  }

  results.each{ name, status ->
    sum = status.values().sum()
    println "~~> ${name}: ${sum} : "
    status.each{ r, c ->
      println "\t${r}: ${c}: \t\tpercentage: " + (sum ? "${c * 100 / sum}%" : '0%')
    }
    println ""
  }
  "DONE"
  ```

  ![build status for jobs within 24 hours](../../screenshot/jenkins/jobs-status-within-24hours.png)

### [get all last builds failure in last 24 hours](https://stackoverflow.com/a/60375862/2940319)
```groovy
import hudson.model.Job
import hudson.model.Result
import hudson.model.Run
import java.util.Calendar
import jenkins.model.Jenkins

// 24 hours in a day, 3600 seconds in 1 hour, 1000 milliseconds in 1 second
Calendar rightNow = Calendar.getInstance()
final long TIME_IN_MILLIS = 24*60*60*1000

Jenkins.instance.getAllItems(Job.class).findAll { Job job ->
  !job.isBuilding()
}.collect { Job job ->
  //find all matching items and return a list but if null then return an empty list
  job.builds.findAll { Run run ->
    job.lastBuild.result == Result.FAILURE &&
    (rightNow.getTimeInMillis() - run.getStartTimeInMillis()) <= TIME_IN_MILLIS
  } ?: []
}.sum().each{ job ->
  println "${job}"
}
```

### [cancel queue builds](https://xanderx.com/post/cancel-all-queued-jenkins-jobs/)
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
