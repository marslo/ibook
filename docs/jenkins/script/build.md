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
  - [get build time](#get-build-time)
  - [cancel queue builds](#cancel-queue-builds)
  - [stop all queue and running jobs](#stop-all-queue-and-running-jobs)
  - [list job which running for more than 24 hours](#list-job-which-running-for-more-than-24-hours)
  - [list all build history within 24 hours](#list-all-build-history-within-24-hours)
  - [get build history times](#get-build-history-times)
  - [get build parameters](#get-build-parameters)
  - [get jobs status in certant timeslot](#get-jobs-status-in-certant-timeslot)
  - [get jobs status within 24 hours](#get-jobs-status-within-24-hours)
  - [get all builds failure in last 24 hours](#get-all-builds-failure-in-last-24-hours)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> javadoc
> - [org.jenkinsci.plugins.workflow.job.WorkflowJob](https://javadoc.jenkins.io/plugin/workflow-job/org/jenkinsci/plugins/workflow/job/WorkflowJob.html)
> - [org.jenkinsci.plugins.workflow.job.WorkflowRun](https://javadoc.jenkins.io/plugin/workflow-job/org/jenkinsci/plugins/workflow/job/WorkflowRun.html)
> - [hudson.model.AbstractProject<P,R>](https://javadoc.jenkins-ci.org/hudson/model/AbstractProject.html)
> - [How to get details of Successful Jenkins build in last x days](https://stackoverflow.com/a/58320445/2940319)
> - [`build.getAction(ParametersAction.class)`](https://stackoverflow.com/a/54924165/2940319)
> - [Variables defined in groovy script always resolve to null](https://stackoverflow.com/a/22411076/2940319)
> - [`build.buildVariableResolver.resolve`](https://stackoverflow.com/a/26545605/2940319)
> - [groovy.lang.MissingPropertyException: No such property: jenkins for class: groovy.lang.Binding](https://stackoverflow.com/q/47064135/2940319)
> - [Class BuildVariableResolver](https://javadoc.jenkins.io/plugin/plasticscm-plugin/index.html?com/codicesoftware/plugins/hudson/util/BuildVariableResolver.html)
> - [batmat/get-jenkins-build-time.groovy](https://gist.github.com/batmat/91faa3201ad2ae88e3d8)
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
> reference:
> - [List Jenkins job build detials for last one year along with the user who triggered the build](https://stackoverflow.com/a/64509896/2940319)

```groovy
String JOB_PATTERN      = '<group>[/<name>]'                  // keywords
final long CURRENT_TIME = System.currentTimeMillis()
final int BENCH_MARK    = 1*24*60*60*1000                     // days * hours * minutes * seconds * microseconds (1000)

Jenkins.instance.getAllItems(Job.class).findAll { Job job ->
  job.fullName.contains(JOB_PATTERN)
}.each { Job job ->
  def history = job.getBuilds().byTimestamp( CURRENT_TIME - BENCH_MARK, CURRENT_TIME )
  if ( history ) {
    println """
      ~~> ${job.fullName} : ${history.size()} :
          history         : ${history.join('\n\t\t\t    ')}
    """
  }
}
```

### [get build history times](https://stackoverflow.com/a/54947196/2940319)
```groovy
final String JOB_PATTERN = '<group>/<name>'                  // keywords

Jenkins.instance.getAllItems( Job.class ).findAll { Job job ->
  job.fullName.contains( JOB_PATTERN )
}.each { Job job ->
  def build = job.getLastBuild()
  println """
                 build.getTime() : ${build.getTime()}
         build.getTimeInMillis() : ${build.getTimeInMillis()}
            build.getTimestamp() : ${build.getTimestamp()}
    build.getStartTimeInMillis() : ${build.getStartTimeInMillis()}
      build.getTimestampString() : ${build.getTimestampString()}
     build.getTimestampString2() : ${build.getTimestampString2()}
  """
}
```
- result
  ```
                 build.getTime() : Thu Apr 29 04:08:08 PDT 2021
         build.getTimeInMillis() : 1619694488799
            build.getTimestamp() : java.util.GregorianCalendar[time=1619694488799,areFieldsSet=true,areAllFieldsSet=true,lenient=true,zone=sun.util.calendar.ZoneInfo[id="America/Los_Angeles",offset=-28800000,dstSavings=3600000,useDaylight=true,transitions=185,lastRule=java.util.SimpleTimeZone[id=America/Los_Angeles,offset=-28800000,dstSavings=3600000,useDaylight=true,startYear=0,startMode=3,startMonth=2,startDay=8,startDayOfWeek=1,startTime=7200000,startTimeMode=0,endMode=3,endMonth=10,endDay=1,endDayOfWeek=1,endTime=7200000,endTimeMode=0]],firstDayOfWeek=1,minimalDaysInFirstWeek=1,ERA=1,YEAR=2021,MONTH=3,WEEK_OF_YEAR=18,WEEK_OF_MONTH=5,DAY_OF_MONTH=29,DAY_OF_YEAR=119,DAY_OF_WEEK=5,DAY_OF_WEEK_IN_MONTH=5,AM_PM=0,HOUR=4,HOUR_OF_DAY=4,MINUTE=8,SECOND=8,MILLISECOND=799,ZONE_OFFSET=-28800000,DST_OFFSET=3600000]
    build.getStartTimeInMillis() : 1619694488807
      build.getTimestampString() : 2 min 1 sec
     build.getTimestampString2() : 2021-04-29T11:08:08Z
  ```

### [get build parameters](https://wiki.jenkins.io/display/JENKINS/Parameterized+System+Groovy+script)
> reference:
> - [`build?.actions.find{ it instanceof ParametersAction }`](https://stackoverflow.com/a/38130496/2940319)
> - [Jenkins & Groovy – accessing build parameters](https://rucialk.wordpress.com/2016/03/17/jenkins-groovy-accessing-build-parameters/)
> - [Parameterized System Groovy script](https://wiki.jenkins.io/display/JENKINS/Parameterized+System+Groovy+script)

```groovy
def job = Jenkins.getInstance().getItemByFullName( 'others-tests/sandbox' )
job.getBuilds().each { Run build ->
  String parameters = build?.actions.find{ it instanceof ParametersAction }?.parameters?.collectEntries {
    [ it.name, it.value ]
  }.collect { k, v -> "\t\t${k}\t: ${v}" }.join('\n')
  println "#${build.getId()}: ${parameters}"
}
```
- result
  ```
  #7: 		id	: marslo
  		gender	: female
  #6: 		id	: marslo
  		gender	: female
  #5: 		id	: marslo
  		gender	: female
  #4: 		id	: marslo
  		gender	: female
  #3: 		name	: marslo
  		gender	: female
  #2: 		name	: marslo
  		gender	: female
  #1:
  ```

- get particular value in each build
  ```groovy
  final String PARAM = 'id'
  Map params = [:]

  def job = Jenkins.getInstance().getItemByFullName( 'others-tests/sandbox' )
  job.getBuilds().each { Run build ->
    params."${build.getId()}" = build?.actions
                                      .find{ it instanceof ParametersAction }?.parameters?.collectEntries {
                                         [ it.name , it.value ]
                                      }
  }

  println params.collect { k , v ->
    "build #${k} ~~> ${v ? "${PARAM} : ${v.getOrDefault(PARAM, "No '${PARAM}' found")}" : 'No Params Found'}"
  }.join('\n')
  ```
  - result
    ```
    build #7 ~~> id : marslo
    build #6 ~~> id : marslo
    build #5 ~~> id : marslo
    build #4 ~~> id : marslo
    build #3 ~~> id : No 'id' found
    build #2 ~~> id : No 'id' found
    build #1 ~~> No Params Found
    ```

- get only `String` type parameters
  ```groovy
  Map params = build?.getAction( ParametersAction.class )
                     .parameters?.findAll{ it instanceof StringParameterValue }?.dump()

  // or
  Map params = build?.getAction( ParametersAction.class )
                     .parameters?.findAll{ it instanceof StringParameterValue }?.collectEntries {
                       [ it.name, it.value ]
                     }

  // or
  Map params = build?.actions
                     .find{ it instanceof ParametersAction }?.parameters?.findAll{ it instanceof StringParameterValue }?.dump()
  ```

### get jobs status in certant timeslot
> find only `String` type parameters:
> ```groovy
>   Map params = build?.getAction( ParametersAction.class )?.parameters?.findAll{ it instanceof StringParameterValue }?.dump()
> ```

```bash
import java.text.SimpleDateFormat
import java.util.Date
import static groovy.json.JsonOutput.*

final String JOB_PATTERN = '<group>[/<name>]'                        // keywords
final Map<String, String> PARAM = [ 'param_name' : 'param_value' ]
Map<String, Map<String, String>> results = [:]

SimpleDateFormat simpleDateFormat = new SimpleDateFormat( "yyyy-MM-dd HH:mm:ss" )
final String START_DATE = '2021-04-26 00:00:00'
final String END_DATE   = '2021-04-27 00:00:00'

long start = simpleDateFormat.parse( START_DATE ).getTime()
long end   = simpleDateFormat.parse( END_DATE ).getTime()

Jenkins.instance.getAllItems( Job.class ).findAll { Job job ->
  job.fullName.contains( JOB_PATTERN )
}.each { Job job ->
  results."${job.fullName}" = [:]
  job.getBuilds().byTimestamp( start, end ).each { Run build ->
    Map params = build?.getAction( ParametersAction.class )?.parameters?.findAll{ it instanceof StringParameterValue }?.collectEntries {
                   [ it.name, it.value ]
                 }
    results."${job.fullName}"."${build.getId()}" = [
            'time' : build.getTime().toString() ,
          'params' : params?.collect { k, v -> "${k} : ${v}"},
      'paramsExist': params?.entrySet()?.containsAll( PARAM.entrySet() )
    ]
    if ( build.isBuilding() ) {
      results."${job.fullName}"."${build.getId()}" << [ 'status' : 'INPROGRESS' ]
    } else {
      results."${job.fullName}"."${build.getId()}" << [ 'status' : build.getResult().toString() ]
    }
  }

  println prettyPrint( toJson(results) )
}

int count = 0
results.get( JOB_PATTERN ).each { k, v ->
  if ( v.paramsExist ) {
    count += 1
    println """
      #${k} : ${v.status} : ${v.time}
              ${v.params}
    """
  }
}

println "total number: ${count}"
"DONE"
```

- result:
  ![filter build history via params](../../screenshot/jenkins/jenkins-filter-job-history-via-params.png)

  ![filter build history via params details](../../screenshot/jenkins/jenkins-filter-job-history-via-params-2.png)


### [get jobs status within 24 hours](https://stackoverflow.com/a/28039134/2940319)
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
  println "\n~~> ${name}: ${sum} : "
  status.each{ r, c ->
    println "\t${r}: ${c}: \t\tpercentage: " + (sum ? "${c * 100 / sum}%" : '0%')
  }
}

"DONE"
```
![build status for jobs within 24 hours](../../screenshot/jenkins/jobs-status-within-24hours.png)

### [get all builds failure in last 24 hours](https://stackoverflow.com/a/60375862/2940319)
```groovy
import hudson.model.Job
import hudson.model.Result
import hudson.model.Run
import java.util.Calendar
import jenkins.model.Jenkins

final Calendar RIGHT_NOW = Calendar.getInstance()
final long BENCH_MARK    = 1*24*60*60*1000
final String JOB_PATTERN = '<group>'

Jenkins.instance.getAllItems(Job.class).findAll { Job job ->
  job.fullName.contains(JOB_PATTERN)
}.collect { Job job ->
  job.builds.findAll { Run run ->
    run.result == Result.FAILURE &&
    (RIGHT_NOW.getTimeInMillis() - run.getStartTimeInMillis()) <= BENCH_MARK
  }
}.sum()
```

return Map structure:
```groovy
import hudson.model.Job
import hudson.model.Result
import hudson.model.Run
import java.util.Calendar
import jenkins.model.Jenkins
import static groovy.json.JsonOutput.*

final Calendar rightNow  = Calendar.getInstance()
final long BENCH_MARK    = 1*24*60*60*1000
final String JOB_PATTERN = '<group>'

Map res = [:]

Jenkins.instance.getAllItems(Job.class).findAll { Job job ->
  job.fullName.contains(JOB_PATTERN)
}.each { Job job ->
  res.(job.fullName) = job.builds.findAll { Run run ->
    !run.isBuilding() &&
    run.result == Result.FAILURE &&
    (rightNow.getTimeInMillis() - run.getStartTimeInMillis()) <= BENCH_MARK
  }.collectEntries { Run run ->
    [ (run.id) : run.getAbsoluteUrl() ]
  }
}

println prettyPrint( toJson(res.findAll{ !it.value.isEmpty() }) )
```

- or
  ```groovy
  import hudson.model.Job
  import hudson.model.Result
  import hudson.model.Run
  import jenkins.model.Jenkins
  import static groovy.json.JsonOutput.*

  final long CURRENT_TIME  = java.util.Calendar.getInstance().getTimeInMillis()
  final long BENCH_MARK    = 1*24*60*60*1000
  final String JOB_PATTERN = '<group>'
  Map res = [:]

  Jenkins.instance.getAllItems(Job.class).findAll { Job job ->
    job.fullName.contains(JOB_PATTERN)
  }.each { Job job ->
    res.(job.fullName) = job.getBuilds().byTimestamp( CURRENT_TIME - BENCH_MARK, CURRENT_TIME ).findAll { Run run ->
      !run.isBuilding() &&
      run.result == Result.FAILURE
    }.collectEntries { Run run ->
      [ run.id, run.getAbsoluteUrl() ]
    }
  }

  println prettyPrint( toJson(res.findAll{ !it.value.isEmpty() }) )
  ```

- or
  ```groovy
  import hudson.model.Job
  import hudson.model.Result
  import hudson.model.Run
  import jenkins.model.Jenkins
  import static groovy.json.JsonOutput.*

  final long CURRENT_TIME  = java.util.Calendar.getInstance().getTimeInMillis()
  final long BENCH_MARK    = 1*24*60*60*1000
  final String JOB_PATTERN = '<group>'
  Map res = [:]

  Jenkins.instance.getAllItems(Job.class).findAll { Job job ->
    job.fullName.contains(JOB_PATTERN)
  }.each { Job job ->
    def history = job.getBuilds().byTimestamp( CURRENT_TIME - BENCH_MARK, CURRENT_TIME )
    if( history ) {
      res.(job.fullName) = history.findAll { Run run ->
        !run.isBuilding() &&
        run.result == Result.FAILURE
      }.collectEntries { Run run ->
        [ (run.id) : run.getAbsoluteUrl() ]
      }
    }
  }

  println prettyPrint( toJson(res.findAll{ !it.value.isEmpty() }) )
  ```
