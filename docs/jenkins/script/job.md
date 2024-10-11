<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [list items](#list-items)
  - [get name and classes](#get-name-and-classes)
  - [list all jobs and folders](#list-all-jobs-and-folders)
  - [list all WorkflowJob](#list-all-workflowjob)
  - [list all AbstractProject](#list-all-abstractproject)
  - [list all folders](#list-all-folders)
  - [list all disabled projects/jobs](#list-all-disabled-projectsjobs)
  - [list inactive jobs](#list-inactive-jobs)
  - [list cron jobs](#list-cron-jobs)
- [get pipeline definitions](#get-pipeline-definitions)
  - [get pipeline scm definition](#get-pipeline-scm-definition)
  - [get pipeline scriptPath](#get-pipeline-scriptpath)
  - [get typical scm](#get-typical-scm)
  - [get pipeline scm branch](#get-pipeline-scm-branch)
  - [get all SCMs](#get-all-scms)
  - [get pipeline bare script](#get-pipeline-bare-script)
  - [get particular job status](#get-particular-job-status)
  - [get logRotator](#get-logrotator)
  - [show logRotator via pattern](#show-logrotator-via-pattern)
  - [set logrotator](#set-logrotator)
- [update pipeline definition](#update-pipeline-definition)
  - [update SCM definition](#update-scm-definition)
  - [disable all particular projects jobs](#disable-all-particular-projects-jobs)
  - [undo disable jobs in particular projects](#undo-disable-jobs-in-particular-projects)

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
jenkins.model.Jenkins.instance.getAllItems( Job.class ).each {
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
jenkins.model.Jenkins.instance.getAllItems( AbstractItem.class ).each {
  println(it.fullName)
}
```
- result:
  ```
  marslo/marslo
  marslo/fs
  ```

### list all WorkflowJob
```groovy
import org.jenkinsci.plugins.workflow.job.WorkflowJob

jenkins.model.Jenkins.instance.getAllItems( WorkflowJob.class ).each {
   println it.fullName
}
```

### [list all AbstractProject](https://github.com/samrocketman/jenkins-script-console-scripts/blob/main/find-all-freestyle-jobs-using-shell-command.groovy)

{% hint style='tip' %}
> Abstract Project: freestyle, maven, etc...
{% endhint %}

```groovy
jenkins.model.Jenkins.instance.getAllItems( AbstractProject.class ).each {
  println it.fullName
}
```

### list all folders
```groovy
import com.cloudbees.hudson.plugins.folder.Folder

jenkins.model.Jenkins.instance.getAllItems( Folder.class ).each {
  println it.fullName + ' ~> ' + it.getClass()
}
```

### list all disabled projects/jobs
```groovy
jenkins.model.Jenkins.instance
       .getAllItems( Job.class )
       .findAll { it.disabled }
       .collect { it.fullName }
```

- or
  ```groovy
  jenkins.model.Jenkins.instance
         .getAllItems(jenkins.model.ParameterizedJobMixIn.ParameterizedJob.class)
         .findAll{ it.disabled }
         .each { println it.fullName }
  ```

- or
  ```groovy
  jenkins.model.Jenkins.instance
         .getAllItems(jenkins.model.ParameterizedJobMixIn.ParameterizedJob.class)
         .findAll{ it.disabled }
         .collect { it.fullName }
  ```


### list inactive jobs

> [!NOTE]
> List jobs haven't been built in 6 months

```groovy
final long CURRENT_TIME  = System.currentTimeMillis()
final long BENCH_MARK    = 6*30*24*60*60

jenkins.model.Jenkins.instance.getAllItems( Job.class ).collect { project ->
  project.getLastBuild()
}.findAll { build ->
  build && ( CURRENT_TIME - build.startTimeInMillis ) / 1000 > BENCH_MARK
}
```

### [list cron jobs](https://support.cloudbees.com/hc/en-us/articles/360032285111-Find-Jenkins-projects-that-build-periodically)

> [!NOTE|label:references:]
> - [jenkins-script-console-scripts/find-all-cron-schedules-by-frequency.groovy](https://github.com/samrocketman/jenkins-script-console-scripts/blob/main/find-all-cron-schedules-by-frequency.groovy)

#### list all cron jobs
```groovy
import hudson.triggers.TimerTrigger

jenkins.model.Jenkins j      = jenkins.model.Jenkins.instance
hudson.model.Descriptor cron = j.getDescriptor( TimerTrigger )

println j.getAllItems(Job).findAll { Job job ->
  job?.triggers?.get(cron)
}.collectEntries { Job job ->
    [ (job.fullName):  job.triggers.get(cron).spec ]
}.collect {
  "${it.key.padRight(30)}: ${it.value}"
}.join('\n')
```

#### disable timer trigger in freestyle only
```groovy
import hudson.model.*
import hudson.triggers.*

TriggerDescriptor TIMER_TRIGGER_DESCRIPTOR = Hudson.instance.getDescriptorOrDie( TimerTrigger.class )
jenkins.model.Jenkins.instance.getAllItems(Job).findAll { item ->
  item.getTriggers().get( TIMER_TRIGGER_DESCRIPTOR )
}.each { item ->
  if ( item instanceof hudson.model.FreeStyleProject ) {
    item.removeTrigger(TIMER_TRIGGER_DESCRIPTOR)
    println(item.fullName + " Build periodically disabled");
  } else {
    println(item.fullName + " Build periodically remains enabled; not as Freestyle project");
  }
}

"DONE"
```

- or
  ```groovy
  import hudson.model.*
  import hudson.triggers.*

  TriggerDescriptor TIMER_TRIGGER_DESCRIPTOR = Hudson.instance.getDescriptorOrDie( TimerTrigger.class )

  for( item in jenkins.model.Jenkins.instance.getAllItems(Job) ) {
    def timertrigger = item.getTriggers().get( TIMER_TRIGGER_DESCRIPTOR )
    if ( timertrigger ) {
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
  jenkins.model.Jenkins.instance.getAllItems(Job).each {
    def jobBuilds=it.getBuilds()

    // Check the last build only
    jobBuilds[0].each { build ->
      def runningSince  = groovy.time.TimeCategory.minus( new Date(), build.getTime() )
      def currentStatus = build.buildStatusSummary.message
      def cause = build.getCauses()[0] //we keep the cause

      //triggered by a user
      def user = cause instanceof Cause.UserIdCause? cause.getUserId():null;

      if( !user ) {
        println "[AUTOMATION] ${build}"
      } else {
        println "[${user}] ${build}"
      }
    }
  }
  return
  ```

## get pipeline definitions

> [!TIP|label:references:]
> - [How to get the pipeline configuration field 'Script Path' when executing the Jenkinsfile?](https://stackoverflow.com/a/50022871/2940319)
> - [Groovy script to get Jenkins pipeline's script path](https://stackoverflow.com/a/70728550/2940319)
> - [WorkflowDefinitionContext.groovy](https://github.com/jenkinsci/job-dsl-plugin/blob/master/job-dsl-core/src/main/groovy/javaposse/jobdsl/dsl/helpers/workflow/WorkflowDefinitionContext.groovy)
> - [BuildConfigToJobMapper.java](https://github.com/openshift/jenkins-sync-plugin/blob/master/src/main/java/io/fabric8/jenkins/openshiftsync/BuildConfigToJobMapper.java)


### get pipeline scm definition

> [!TIP]
> - [Class SCM](https://javadoc.jenkins.io/hudson/scm/SCM.html)
> - [Class hudson.plugins.git.GitSCM](https://javadoc.jenkins.io/plugin/git/hudson/plugins/git/GitSCM.html)
> - [Class org.eclipse.jgit.transport.RemoteConfig](https://archive.eclipse.org/jgit/docs/jgit-2.0.0.201206130900-r/apidocs/org/eclipse/jgit/transport/RemoteConfig.html)
> - [Class hudson.plugins.git.UserRemoteConfig](https://javadoc.jenkins.io/plugin/git/hudson/plugins/git/UserRemoteConfig.html)
> - [org.jenkinsci.plugins.workflow.job.WorkflowJob getTypicalSCM()](https://javadoc.jenkins.io/plugin/workflow-job/org/jenkinsci/plugins/workflow/job/WorkflowJob.html#getTypicalSCM())

```groovy
import org.jenkinsci.plugins.workflow.job.WorkflowJob

jenkins.model.Jenkins.instance.getAllItems( WorkflowJob.class ).findAll{
  it.definition instanceof org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
}.each {
  println it.fullName.toString().padRight(30) +
          ( it.definition?.scm?.branches?.join() ?: '' ).padRight(20) +
          ( it?.definition?.scriptPath ?: '' ).padRight(30) +
          it.definition?.scm?.userRemoteConfigs.collect { it.credentialsId }.join().padRight(30) +
          it.definition?.scm?.repositories?.collect{ it.getURIs() }?.flatten()?.join()
}

"DONE"

-- result --
marslo/sandbox/sandbox        */main              jenkinsfile/sandbox           GIT_SSH_CREDENTIAL            git://github.com:marslo/pipelines
marslo/sandbox/dump           */dev               jenkinsfile/dump              GIT_SSH_CREDENTIAL            git://github.com:marslo/pipelines
...
```

### get pipeline scriptPath

> [!TIP]
> - [Class CpsScmFlowDefinition](https://javadoc.jenkins.io/plugin/workflow-cps/org/jenkinsci/plugins/workflow/cps/CpsScmFlowDefinition.html)

```groovy
import org.jenkinsci.plugins.workflow.job.WorkflowJob

jenkins.model.Jenkins.instance.getAllItems(WorkflowJob.class).findAll{
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

### get typical scm

> [!NOTE]
> - [groovy to list Jenkins jobs with GIT URL used in jobs](https://stackoverflow.com/a/53225808/2940319)

```groovy
jenkins.model.Jenkins.instance.getAllItems( hudson.model.Job.class ).findAll {
  it.hasProperty( 'typicalSCM' ) &&
  it.typicalSCM instanceof hudson.plugins.git.GitSCM
}.each { job ->
  println job.fullName.padRight(40) + ' : ' +
          ( job.typicalSCM.branches?.join() ?: '' ).padRight(40) +
          job.typicalSCM.userRemoteConfigs?.collect { it.credentialsId }.join().padRight(30) +
          job.typicalSCM.repositories?.collect{ it.getURIs() }?.flatten()?.join()
}

"DONE"
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

### get all SCMs

> [!NOTE]
> - get all SCM definitions via `getSCMs`, including
>   - Libraries
>   - last builds, including all stages calls `GitSCM`
> - [`getSCMs`](https://github.com/jenkinsci/workflow-job-plugin/blob/master/src/main/java/org/jenkinsci/plugins/workflow/job/WorkflowJob.java#L180)
>   - `getLastSuccessfulBuild` ?: `getLastCompletedBuild` ?: `definedSCMs`

```groovy
jenkins.model.Jenkins.instance.getAllItems( Job.class ).findAll {
  it.SCMs &&
  it.SCMs.any { scm -> scm instanceof hudson.plugins.git.GitSCM }
}.each { job ->
  println job.fullName.padRight(50) + ':'
  job.SCMs.branches.eachWithIndex { scm, idx ->
    println '\t - ' + job.SCMs.branches[idx].join().padRight(45) +
                      job.SCMs.userRemoteConfigs[idx].credentialsId.join().padRight(30) +
                      job.SCMs.repositories[idx].collect { it.getURIs() }.flatten().join()
  }
}

"DONE"
```

- or without lastBuild
  ```groovy
  jenkins.model.Jenkins.instance.getAllItems( Job.class ).findAll {
    it.hasProperty( 'typicalSCM' ) &&
    it.typicalSCM instanceof hudson.plugins.git.GitSCM
  }.each { job ->
    println job.fullName.padRight(40) + ' : ' +
            ( job.typicalSCM.branches?.join() ?: '' ).padRight(40) +
            job.typicalSCM.userRemoteConfigs?.collect { it.credentialsId }.join().padRight(30) +
            job.typicalSCM.repositories?.collect{ it.getURIs() }?.flatten()?.join()
  }

  "DONE"

  -- result --
  marslo/whitebox/whitebox                          : main             ED25519_SSH_CREDENTIAL     git://github.com:marslo/pipelines
  marslo/sandbox/dump                               : sandbox/dump     ED25519_SSH_CREDENTIAL     git://github.com:marslo/pipelines
  ```

- or
  ```groovy
  jenkins.model.Jenkins.instance.getAllItems( Job.class ).findAll {
    it.hasProperty( 'typicalSCM' ) &&
    it.typicalSCM instanceof hudson.plugins.git.GitSCM
  }.each { job ->
    println job.fullName.padRight(50) + ':' +
            '\n\t - ' + job.typicalSCM.branches.join() +
            '\n\t - ' + job.typicalSCM.userRemoteConfigs.collect { it.credentialsId }.join() +
            '\n\t - ' + job.typicalSCM.repositories?.collect{ it.getURIs() }?.flatten()?.join()
  }

  "DONE"

  -- result --
  marslo/whitebox/whitebox                          :
     - main
     - ED25519_SSH_CREDENTIAL
     - git://github.com:marslo/pipelines
  marslo/sandbox/dump                               :
     - sandbox/dump
     - ED25519_SSH_CREDENTIAL
     - git://github.com:marslo/pipelines
  ```

#### check pipeline isn't get from particular branch

> [!TIP]
> - [hudson.plugins.git.BranchSpec](https://javadoc.jenkins.io/plugin/git/hudson/plugins/git/BranchSpec.html)

```groovy
import org.jenkinsci.plugins.workflow.job.WorkflowJob

String branch = 'develop'

jenkins.model.Jenkins.instance.getAllItems(WorkflowJob.class).findAll{
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

jenkins.model.Jenkins.instance.getAllItems(WorkflowJob.class).findAll{
  it.definition instanceof org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition
}.each {
  println it.fullName.toString().padRight(30) + ' ~> ' + it?.definition?.getScript()
}

"DONE"
```

### get particular job status
```groovy
def job = jenkins.model.Jenkins.instance.getItemByFullName('<group>/<name>')
println """
  Last success : ${job.getLastSuccessfulBuild()}
    All builds : ${job.getBuilds().collect{ it.getNumber() }}
    Last build : ${job.getLastBuild()}
   Is building : ${job.isBuilding()}
"""
```

#### list properties

> [!NOTE]
> [Java Code Examples for jenkins.model.Jenkins#getItemByFullName()](https://www.programcreek.com/java-api-examples/?class=jenkins.model.Jenkins&method=getItemByFullName)

```groovy
def job = jenkins.model.Jenkins.instance.getItemByFullName('<group>/<name>')
println """
       job.getClass() : ${job.getClass()}
    job.isBuildable() : ${job.isBuildable()}
  job.getFirstBuild() : ${job.getFirstBuild()}
         job.getACL() : ${job.getACL()}
  "======================="
      job.getBuilds() : ${job.getBuilds()}
"""
```

### get logRotator

{% hint style='tip' %}
> references:
> - [Class LogRotator](https://javadoc.jenkins.io/hudson/tasks/LogRotator.html)
> - [Jenkins : Manually run log rotation on all jobs](https://wiki.jenkins.io/display/JENKINS/Manually-run-log-rotation-on-all-jobs.html)
> - [jenkins/core/src/main/java/hudson/tasks/LogRotator.java](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/java/hudson/tasks/LogRotator.java)
{% endhint %}

```groovy
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import hudson.tasks.LogRotator

String JOB_PATTERN = 'pattern'

jenkins.model.Jenkins.instance.getAllItems(WorkflowJob.class).findAll{
  it.fullName.startsWith( JOB_PATTERN ) && it.buildDiscarder
}.each { job ->
  LogRotator discarder = job.buildDiscarder
  println job.fullName.toString().padRight(30) + ' : ' +
          "builds=(${discarder.daysToKeep} days, ${discarder.numToKeep} total) " +
          "artifacts=(${discarder.artifactDaysToKeep} days, ${discarder.artifactNumToKeep} total)"
}

"DONE"
```

### show logRotator via pattern
```groovy
List<String> projects = [ 'project' ]

jenkins.model.Jenkins.instance.getAllItems(Job.class).findAll {
  projects.any { p -> it.fullName.startsWith(p) }
}.each {
  println """
    >> ${it.fullName} :

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

### set logrotator

> [!NOTE|label:references:]
> - scripts:
>   - [logrotator-config.groovy](https://github.com/cloudbees/jenkins-scripts/blob/master/logrotator-config.groovy)

## update pipeline definition

> [!NOTE]
> - [How to update job config files using the REST API and cURL?](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-controllers/how-to-update-job-config-files-using-the-rest-api-and-curl)
> - scripts:
>   - [updateJobParameterDefinition.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/updateJobParameterDefinition.groovy)

### update SCM definition

> [!NOTE]
> - [How to change a Git URL in all Jenkins jobs](https://stackoverflow.com/a/27646182/2940319)
> - [GitSCM credentials programmatically with Groovy](https://stackoverflow.com/q/69465371/2940319)
> - [How to change the Git URL in all Jenkins jobs](https://stackoverflow.com/a/73056378/2940319)

#### without output
```groovy
#!/usr/bin/env groovy

import hudson.plugins.git.GitSCM
import hudson.plugins.git.UserRemoteConfig
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
import com.cloudbees.plugins.credentials.common.StandardCredentials
import com.cloudbees.plugins.credentials.CredentialsProvider

String newCredId = 'ED25519_SSH_CREDENTIAL'

if ( CredentialsProvider.lookupCredentials( StandardCredentials.class, jenkins.model.Jenkins.instance)
                        .any { newCredId == it.id }
) {

  jenkins.model.Jenkins.instance.getAllItems( WorkflowJob.class ).findAll {
    it.definition instanceof org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition &&
    ! it.definition?.scm?.userRemoteConfigs.collect { it.credentialsId }.contains( newCredId )
  }.each { job ->

    GitSCM orgScm          = job.definition?.scm
    Boolean orgLightweight = job.definition?.lightweight

    List<UserRemoteConfig> newUserRemoteConfigs = orgScm.userRemoteConfigs.collect {
      newUrl = 'ssh://' + it.url.split('ssh://').last().split('@').last()
      new UserRemoteConfig( newUrl, it.name, it.refspec, newCredId )
    }
    GitSCM newScm = new GitSCM( newUserRemoteConfigs, orgScm.branches, orgScm.doGenerateSubmoduleConfigurations,
                                orgScm.submoduleCfg, orgScm.browser, orgScm.gitTool, orgScm.extensions
                              )
    CpsScmFlowDefinition flowDefinition = new CpsScmFlowDefinition( newScm, job.definition.scriptPath )

    job.definition = flowDefinition
    job.definition.lightweight = orgLightweight
    job.save()

    println ">> " + job.fullName + " DONE !"
  }

} else {
  println "${newCredId} CANNOT be found !!"
}

"DONE"

// vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=Groovy
```

#### with output
```groovy
#!/usr/bin/env groovy

import hudson.plugins.git.GitSCM
import hudson.plugins.git.UserRemoteConfig
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
import com.cloudbees.plugins.credentials.common.StandardCredentials
import com.cloudbees.plugins.credentials.CredentialsProvider

String newCredId = 'ED25519_SSH_CREDENTIAL'
String orgCredId = ''
String newUrl    = ''
String orgUrl    = ''

if ( CredentialsProvider.lookupCredentials( StandardCredentials.class, jenkins.model.Jenkins.instance)
                        .any { newCredId == it.id }
) {

  jenkins.model.Jenkins.instance.getAllItems( WorkflowJob.class ).findAll {
    it.definition instanceof org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition &&
    ! it.definition?.scm?.userRemoteConfigs.collect { it.credentialsId }.contains( newCredId )
  }.each { job ->

    GitSCM orgScm          = job.definition?.scm
    Boolean orgLightweight = job.definition?.lightweight

    List<UserRemoteConfig> newUserRemoteConfigs = orgScm.userRemoteConfigs.collect {
      orgUrl    = it.url
      newUrl    = 'ssh://' + it.url.split('ssh://').last().split('@').last()
      orgCredId = it.credentialsId
      new UserRemoteConfig( newUrl, it.name, it.refspec, newCredId )
    }
    GitSCM newScm = new GitSCM( newUserRemoteConfigs, orgScm.branches, orgScm.doGenerateSubmoduleConfigurations,
                                orgScm.submoduleCfg, orgScm.browser, orgScm.gitTool, orgScm.extensions
                              )
    CpsScmFlowDefinition flowDefinition = new CpsScmFlowDefinition( newScm, job.definition.scriptPath )

    job.definition = flowDefinition
    job.definition.lightweight = orgLightweight
    job.save()
    println ">> " + job.fullName + " DONE :" +
            "\n\t - orgScm: ${(orgCredId ?: '').padRight(30)}: ${orgUrl}" +
            "\n\t - newScm: ${(newCredId ?: '').padRight(30)}: ${newUrl}"
  }

} else {
  println "${newCredId} CANNOT be found !!"
}

"DONE"

// vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=Groovy
```

### disable all particular projects jobs
```groovy
List<String> projects = [ 'project-1', 'project-2', 'project-n' ]

jenkins.model.Jenkins.instance.getAllItems(Job.class).findAll {
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

jenkins.model.Jenkins.instance.getAllItems(Job.class).findAll {
  it.disabled && projects.any{ p -> it.fullName.startsWith(p) }
}.each {
  println "~~> ${it.fullName}"
  it.disabled = false
  it.save()
}
```
