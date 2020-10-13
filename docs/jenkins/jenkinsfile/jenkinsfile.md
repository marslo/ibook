<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [trigger](#trigger)
  - [poll SCM](#poll-scm)
  - [`parameterizedCron`](#parameterizedcron)
  - [triggered by](#triggered-by)
- [environment variables](#environment-variables)
  - [get current customized environment](#get-current-customized-environment)
  - [get downstream build environment](#get-downstream-build-environment)
  - [get previous build environment](#get-previous-build-environment)
- [build & current build](#build--current-build)
  - [check previous build status](#check-previous-build-status)
  - [Stop the current build](#stop-the-current-build)
  - [get current build info()](#get-current-build-info)
- [jenkins API](#jenkins-api)
  - [update node name](#update-node-name)
  - [raw build](#raw-build)
  - [manager.build.result.isBetterThan](#managerbuildresultisbetterthan)
- [customized build](#customized-build)
  - [display name](#display-name)
- [promot](#promot)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## trigger
### poll SCM
```groovy
properties([
  // every 6 hours
  pipelineTriggers([
      pollSCM( ignorePostCommitHooks: true, scmpoll_spec: 'H H/6 * * *' )
  ])
])
```

```groovy
properties([
  pipelineTriggers([
    [ $class: "SCMTrigger", scmpoll_spec: 'H/5 * * * *' ],
  ])
])
```

- declarative:
  ```groovy
  triggers {
      pollSCM ignorePostCommitHooks: true, scmpoll_spec: 'H H * * *'
  }
  ```

### [`parameterizedCron`](https://github.com/jenkinsci/parameterized-scheduler-plugin)
```groovy
properties([
  parameters([
    choice(choices: ['', 'a', 'b', 'c'], description: '', name: 'var1')
    choice(choices: ['', 'a', 'b', 'c'], description: '', name: 'var2')
  ]),
  pipelineTriggers([
    parameterizedCron( '''
      H/3 * * * * % var1=a; var2=b
      H/6 * * * * % var1=b; var2=a
    ''' )
  ])
])
```

### triggered by
> - [gitlab](https://stackoverflow.com/a/55366682/2940319)

- gitlab
  ```groovy
  currentBuild.rawBuild.getCause(com.dabsquared.gitlabjenkins.cause.GitLabWebHookCause).getData()
  // or
  commit = currentBuild.rawBuild.getCause(com.dabsquared.gitlabjenkins.cause.GitLabWebHookCause).getData().getLastCommit()
  ```


## environment variables
### get current customized environment
```groovy
  println currentBuild.getBuildVariables()?.MY_ENV
```

### get downstream build environment
```groovy
  def res = build job: 'downstream-job', propagate: false
  println res.getBuildVariables()?.MY_ENV
```

### get previous build environment
```groovy
  println currentBuild.getPreviousBuild().getBuildVariables()?.MY_ENV
```

## build & current build
### [check previous build status](https://support.cloudbees.com/hc/en-us/articles/230922188-Pipeline-How-can-I-check-previous-build-status-in-a-Pipeline-Script-)
> useful info:
> ```groovy
> method hudson.model.Run getPreviousBuild
> method hudson.model.Run getResult
> method org.jenkinsci.plugins.workflow.support.steps.build.RunWrapper getRawBuild
> ```

```groovy
if(!hudson.model.Result.SUCCESS.equals(currentBuild.rawBuild.getPreviousBuild()?.getResult())) {
  echo "last build failed"
}

```

### Stop the current build
#### stop current
```groovy
// stop and show status to UNSTABLE
if ( 'UNSTABLE' == currentBuild.result ) {
  currentBuild.getRawBuild().getExecutor().interrupt(Result.UNSTABLE)
}
```

#### [stop all](https://stackoverflow.com/a/26306081/2940319)
```groovy
Thread.getAllStackTraces().keySet().each() {
  t -> if (t.getName()=="YOUR THREAD NAME" ) { t.interrupt(); }          // or t.stop();
}

// and

Jenkins.instance.getItemByFullName("JobName")
                .getBuildByNumber(JobNumber)
                .finish(
                        hudson.model.Result.ABORTED,
                        new java.io.IOException("Aborting build")
                );
```

### get current build info()
> reference:
> - [How to get Jenkins build job details?](https://medium.com/faun/how-to-get-jenkins-build-job-details-b8c918087030)

#### get `BUILD_NUMBER`
```groovy
Jenkins.instance.getItemByFullName(env.JOB_NAME).getLastBuild().getNumber().toInteger()
```

## jenkins API
### update node name
- get label
  ```groovy
  @NonCPS
  def getLabel(){
    for (node in jenkins.model.Jenkins.instance.nodes) {
      if (node.getNodeName().toString().equals("${env.NODE_NAME}".toString())) {
        currentLabel = node.getLabelString()
        return currentLabel
      }
    }
  }
  ```

- set label
  ```groovy
  @NonCPS
  def updateLabel(nodeName, newLabel) {
    def node = jenkins.model.Jenkins.instance.getNode(nodeName)
    if (node) {
      node.setLabelString(newLabel)
      node.save()
    }
  }
  ```

- Jenkinsfile Example
  ```groovy
  String curLabel       = null
  String newLabel       = null
  String testNodeName   = null
  String curProject     = env.JOB_NAME
  String curBuildNumber = env.BUILD_NUMBER

  node("master") {
    try{
      stage("reserve node") {
        node("${params.tmNode}") {
          testNodeName = env.NODE_NAME
          curLabel  = getLabel()
          newLabel = "${curLabel}~running_${curProject}#${curBuildNumber}"
          echo "~~> lock ${testNodeName}. update lable: ${curLabel} ~> ${newLabel}"
          updateLabel(testNodeName, newLabel)
        } // node
      } // reserve stage
    } finally {
    if (newLabel) {
      stage("release node") {
        nodeLabels = "${newLabel}".split('~')
        orgLabel = nodeLabels[0]
        echo "~~> release ${testNodeName}. update lable ${newLabel} ~> ${orgLabel}"
        updateLabel(testNodeName, orgLabel)
      } // release stage
    } // if
  } // finally
  ```

### raw build
```groovy
Map buildResult = [:]

node("master") {
  buildResult = build job: '/marslo/artifactory-lib',
                      propagate: true,
                      wait: true
  buildResult.each { println it }

  println """
    ~~> "result" : ${buildResult.result}
    ~~> "getBuildVariables()" : ${buildResult.getBuildVariables()}
    ~~> "getBuildVariables().mytest" : ${buildResult.getBuildVariables().mytest}
    ~~> "getRawBuild().getEnvVars()" : ${buildResult.getRawBuild().getEnvVars()}
    ~~> "getRawBuild().getEnvironment()" : ${buildResult.getRawBuild.getEnvironment()}
    ~~> "rawBuild.environment.RUN_CHANGES_DISPLAY_URL" : ${buildResult.rawBuild.environment.RUN_CHANGES_DISPLAY_URL}
    ~~> "getBuildCauses()" : ${buildResult.getBuildCauses()}
    ~~> "getChangeSets()" : ${buildResult.getChangeSets()}
    ~~> "buildVariables["mytest"]" : ${buildResult.buildVariables["mytest"]}
    ~~> "buildResult.rawBuild": ${buildResult.rawBuild}
    ~~> "buildResult.rawBuild.log": ${buildResult.rawBuild.log}
  """
} // node
```

### [manager.build.result.isBetterThan](https://stackoverflow.com/a/26410694/2940319)
```groovy
if(manager.build.result.isBetterThan(hudson.model.Result.UNSTABLE)) {
  def cmd = 'ssh -p 29418 $host gerrit review --verified +1 --code --review +2 --submit $GERRIT_CHANGE_NUMBER,$GERRIT_PATCHSET_NUMBER'
  cmd = manager.build.environment.expand(cmd)
  manager.listener.logger.println("Merge review: '$cmd'")
  def p = "$cmd".execute()
  manager.listener.logger.println(p.in.text)
  manager.addShortText("M")
}
```

## customized build
### display name
```groovy
currentBuild.displayName = '#' + Integer.toString(currentBuild.number) + ' mytest'
```
![customized display name](../../screenshot/jenkins/showDisplayName.png)


## promot
> [Delete jenkins builds during Promote / promotion step](https://stackoverflow.com/a/18992627/2940319)

<!--sec data-title="promot" data-id="section0" data-show=true data-collapse=true ces-->
```groovy
/*** BEGIN META {
  "name" : "Bulk Delete Builds except the given build number",
  "comment" : "For a given job and a given build numnber, delete all builds of a given release version (M.m.interim) only and except the user provided one. Sometimes a Jenkins job use Build Name setter plugin and same job generates 2.75.0.1 and 2.76.0.43",
  "parameters" : [ 'jobName', 'releaseVersion', 'buildNumber' ],
  "core": "1.409",
  "authors" : [
     { name : "Arun Sangal - Maddys Version" }
  ]
} END META **/

import groovy.json.*
import jenkins.model.*;
import hudson.model.Fingerprint.RangeSet;
import hudson.model.Job;
import hudson.model.Fingerprint;

//these should be passed in as arguments to the script
if(!artifactoryURL) throw new Exception("artifactoryURL not provided")
if(!artifactoryUser) throw new Exception("artifactoryUser not provided")
if(!artifactoryPassword) throw new Exception("artifactoryPassword not provided")
def authString = "${artifactoryUser}:${artifactoryPassword}".getBytes().encodeBase64().toString()
def artifactorySettings = [artifactoryURL: artifactoryURL, authString: authString]

if(!jobName) throw new Exception("jobName not provided")
if(!buildNumber) throw new Exception("buildNumber not provided")

def lastBuildNumber = buildNumber.toInteger() - 1;
def nextBuildNumber = buildNumber.toInteger() + 1;

def jij = jenkins.model.Jenkins.instance.getItem(jobName);

def promotedBuildRange = new Fingerprint.RangeSet()
promotedBuildRange.add(buildNumber.toInteger())
def promoteBuildsList = jij.getBuilds(promotedBuildRange)
assert promoteBuildsList.size() == 1
def promotedBuild = promoteBuildsList[0]
// The release / version of a Jenkins job - i.e. in case you use "Build name" setter plugin in Jenkins for getting builds like 2.75.0.1, 2.75.0.2, .. , 2.75.0.15 etc.
// and over the time, change the release/version value (2.75.0) to a newer value i.e. 2.75.1 or 2.76.0 and start builds of this new release/version from #1 onwards.
def releaseVersion = promotedBuild.getDisplayName().split("\\.")[0..2].join(".")

println ""
println("- Jenkins Job_Name: ${jobName} -- Version: ${releaseVersion} -- Keep Build Number: ${buildNumber}");
println ""

/** delete the indicated build and its artifacts from artifactory */
def deleteBuildFromArtifactory(String jobName, int deleteBuildNumber, Map<String, String> artifactorySettings){
    println "     ## Deleting >>>>>>>>>: - ${jobName}:${deleteBuildNumber} from artifactory"
                                def artifactSearchUri = "api/build/${jobName}?buildNumbers=${deleteBuildNumber}&artifacts=1"
                                def conn = "${artifactorySettings['artifactoryURL']}/${artifactSearchUri}".toURL().openConnection()
                                conn.setRequestProperty("Authorization", "Basic " + artifactorySettings['authString']);
                                conn.setRequestMethod("DELETE")
    if( conn.responseCode != 200 ) {
        println "Failed to delete the build artifacts from artifactory for ${jobName}/${deleteBuildNumber}: ${conn.responseCode} - ${conn.responseMessage}"
    }
}

/** delete all builds in the indicated range that match the releaseVersion */
def deleteBuildsInRange(String buildRange, String releaseVersion, Job theJob, Map<String, String> artifactorySettings){
    def range = RangeSet.fromString(buildRange, true);
    theJob.getBuilds(range).each {
        if ( it.getDisplayName().find(/${releaseVersion}.*/)) {
            println "     ## Deleting >>>>>>>>>: " + it.getDisplayName();
            deleteBuildFromArtifactory(theJob.name, it.number, artifactorySettings)
            it.delete();
        }
    }
}

//delete all the matching builds before the promoted build number
deleteBuildsInRange("1-${lastBuildNumber}", releaseVersion, jij, artifactorySettings)

//delete all the matching builds after the promoted build number
deleteBuildsInRange("${nextBuildNumber}-${jij.nextBuildNumber}", releaseVersion, jij, artifactorySettings)

println ""
println("- Builds have been successfully deleted for the above mentioned release: ${releaseVersion}")
println ""
```
<!--endsec-->
