<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Pipeline Utility Steps](#pipeline-utility-steps)
  - [findFiles](#findfiles)
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
  - [description](#description)
- [parallel](#parallel)
  - [static](#static)
  - [dynamic](#dynamic)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> reference:
> - [Pipeline Examples](https://www.jenkins.io/doc/pipeline/examples/)
> - [Jenkins Pipeline Syantx](https://kb.novaordis.com/index.php/Jenkins_Pipeline_Syntax)
> - [Pipeline Steps Reference](https://www.jenkins.io/doc/pipeline/steps/)

## [Pipeline Utility Steps](https://www.jenkins.io/doc/pipeline/steps/pipeline-utility-steps/)
### findFiles
- jenkinsfile
  ```groovy
  sh "touch a.txt"
  def files = findFiles (glob: "**/*.txt")
  println """
    name: ${files[0].name}
    path: ${files[0].path}
    directory: ${files[0].directory}
    length: ${files[0].length}
    lastModified: ${files[0].lastModified}
  """
  ```
- result
  ```groovy
  [Pipeline] sh (hide)
  + touch a.txt
  [Pipeline] findFiles
  [Pipeline] echo

        name: a.txt
        path: a.txt
        directory: false
        length: 0
        lastModified: 1605525397000
  ```

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

- get build cause
  ```groovy
  def build = currentBuild.rawBuild
  println build.getCauses().collect { it.getClass().getCanonicalName().tokenize('.').last() }

  println """
    cause: ${build.getCauses().toString()}
    cause.getClass(): ${build.getCauses().getClass()} : ${build.getCauses().getClass().getCanonicalName()}
    build.getCause(hudson.model.Cause.UserIdCause.class): ${build.getCause(hudson.model.Cause.UserIdCause.class)}
  """
  ```
- get user id if triggered by manually
  ```groovy
  def build = currentBuild.rawBuild
  if ( build.getCause(hudson.model.Cause.UserIdCause.class) ) {
    println """
      username: ${build.getCause(hudson.model.Cause.UserIdCause.class).getUserName()}
      id: ${build.getCause(hudson.model.Cause.UserIdCause.class).getUserId()}
      mail: ${build.getCause(hudson.model.Cause.UserIdCause.class).getUserId()}@domain.com
    """
  }
  ```

  - or
    ```groovy
    import hudson.model.Cause.UserIdCause

    if ( build.getCause(UserIdCause.class) ) {
      println """
        username: ${build.getCause(UserIdCause.class).getUserName()}
        id: ${build.getCause(UserIdCause.class).getUserId()}
        mail: ${build.getCause(UserIdCause.class).getUserId()}@domain.com
      """
    }
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

#### get build id of lastSuccessfulBuild
- get via api
  ```groovy
  sh """
    curl -sSLg 'https://<jenkins.domain.com>/job/<job-name>/api/json' -o 'output.json'
  """
  def data = readJSON file: 'output.json'
  println data.lastSuccessfulBuild.number
  ```

- get via `Jenkins.instance.getItemByFullName(env.JOB_NAME)`
  ```groovy
  println Jenkins.instance.getItemByFullName(env.JOB_NAME).lastSuccessfulBuild.number
  ```
  - get last build id
    ```groovy
    println Jenkins.instance.getItemByFullName(env.JOB_NAME).getLastBuild().getNumber().toInteger()
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

### description
```groovy
currentBuild.description = 'this is whitebox'
```

## parallel
### static
```groovy
timestamps { ansiColor('xterm') {
  parallel([
    'k1 \u00BB v1': {
      stage( 'build k1' ) {
        node("master") {
          println "KEY= k1, VALUE=v1"
          sleep 3
        } // node
      }
    },
    'k2 \u00BB v2': {
      stage( 'build k2' ) {
        node("master") {
          println "KEY= k2, VALUE=v2"
          sleep 3
        } // node
      }
    },
    'k3 \u00BB v3': {
      stage( 'build k3' ) {
        node("master") {
          println "KEY= k3, VALUE=v3"
          sleep 3
        } // node
      }
    }
  ])
  println 'done'
}} // ansiColor | timestamps
```

### dynamic
```groovy
timestamps { ansiColor('xterm') {
  Map worker = [:]
  Map<String, String> data = [
    "k1": "v1",
    "k2": "v2",
    "k3": "v3",
  ]
  data.each { k ,v ->
    worker["${k} \u00BB ${v}"] = {
      stage("build ${k}") {
        node("master") {
          println """
            ---------------
            "KEY=${k} VALUE=${v}"
            ---------------
          """
          sleep 3
        } // node : master
      } // stage
    } // work
  }
  parallel worker
  println "done !"
}} // ansiColor | timestamps
```
