<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Trigger](#trigger)
  - [Poll SCM](#poll-scm)
  - [`parameterizedCron`](#parameterizedcron)
  - [Triggered by](#triggered-by)
- [Environment Variables](#environment-variables)
  - [Get current customized environment](#get-current-customized-environment)
  - [Get downstream build environment](#get-downstream-build-environment)
  - [Get previous build environment](#get-previous-build-environment)
- [build & current build](#build--current-build)
  - [check previous build status](#check-previous-build-status)
  - [Stop the current build](#stop-the-current-build)
  - [Get current build info()](#get-current-build-info)
- [Jenkins API](#jenkins-api)
  - [update node name](#update-node-name)
  - [Raw build](#raw-build)
  - [manager.build.result.isBetterThan](#managerbuildresultisbetterthan)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Trigger

### Poll SCM
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
  parameters([ choice(choices: ['', 'a', 'b', 'c'], description: '', name: 'var') ]),
  pipelineTriggers([
    parameterizedCron( '''
      H/3 * * * * % var=a
      H/6 * * * * % var=b
    ''' )
  ])
])
```

### Triggered by

- [gitlab](https://stackoverflow.com/a/55366682/2940319)
```groovy
currentBuild.rawBuild.getCause(com.dabsquared.gitlabjenkins.cause.GitLabWebHookCause).getData()
// or
commit = currentBuild.rawBuild.getCause(com.dabsquared.gitlabjenkins.cause.GitLabWebHookCause).getData().getLastCommit()
```


## Environment Variables
### Get current customized environment
```groovy
  println currentBuild.getBuildVariables()?.MY_ENV
```
### Get downstream build environment
```groovy
  def res = build job: 'downstream-job', propagate: false
  println res.getBuildVariables()?.MY_ENV
```
### Get previous build environment
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
### Get current build info()
#### get `BUILD_NUMBER`
```groovy
Jenkins.instance.getItemByFullName(env.JOB_NAME).getLastBuild().getNumber().toInteger()
```

#### [reference: How to get Jenkins build job details?](https://medium.com/faun/how-to-get-jenkins-build-job-details-b8c918087030)

## Jenkins API
### update node name
- Get label
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

- Set Label
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

### Raw build
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
