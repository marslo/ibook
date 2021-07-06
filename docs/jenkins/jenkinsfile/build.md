<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [build & current build](#build--current-build)
  - [check previous build status](#check-previous-build-status)
  - [Stop the current build](#stop-the-current-build)
  - [get current build info](#get-current-build-info)
  - [trigger downstream builds](#trigger-downstream-builds)
  - [get changelogs](#get-changelogs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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
#### [stop current](https://devops.stackexchange.com/a/9545/3503)
```groovy
// stop and show status to UNSTABLE
if ( 'UNSTABLE' == currentBuild.result ) {
  currentBuild.getRawBuild().getExecutor().interrupt(Result.UNSTABLE)
}
```

[or](https://stackoverflow.com/a/59062652/2940319)
```groovy
import hudson.model.Result
import hudson.model.Run
import jenkins.model.CauseOfInterruption

println ">> Aborting older build #${previousBuild.number}"
def cause = { "interrupted by build #${currentBuild.getId()}" as String } as CauseOfInterruption
executor.interrupt(Result.ABORTED, cause)
```
- abort previous running build
  ```groovy
  import hudson.model.Result
  import hudson.model.Run
  import jenkins.model.CauseOfInterruption

  def abortPreviousBuilds() {
    Run previousBuild = currentBuild.getPreviousBuildInProgress()

    while (previousBuild != null) {
      if (previousBuild.isInProgress()) {
        def executor = previousBuild.getExecutor()
        if (executor != null) {
          println ">> Aborting older build #${previousBuild.number}"
          def cause = { "interrupted by build #${currentBuild.getId()}" as String } as CauseOfInterruption
          executor.interrupt(Result.ABORTED, cause)
        }
      }
      previousBuild = previousBuild.getPreviousBuildInProgress()
    }
  }
  ```
- [or Stopping Jenkins job in case newer one is started](https://stackoverflow.com/a/44326188/2940319)
  ```groovy
  import hudson.model.Result
  import jenkins.model.CauseOfInterruption

  //iterate through current project runs
  build.getProject()._getRuns().each{id,run->
    def exec = run.getExecutor()
    //if the run is not a current build and it has executor (running) then stop it
    if( run!=build && exec!=null ){
      //prepare the cause of interruption
      def cause = new CauseOfInterruption(){
        public String getShortDescription(){
          return "interrupted by build #${build.getId()}"
        }
      }
      exec.interrupt(Result.ABORTED, cause)
    }
  }

  //just for test do something long...
  Thread.sleep(10000)
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

### get current build info
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

### trigger downstream builds
```groovy
timestamps { ansiColor('xterm') {
  node('master') {
    stage('trigger downstream') {
      buildRes = build job: '/marslo/downstream',
                       propagate: false,
                       parameters: [
                         string( name: 'stringParams', value: 'string'      ) ,
                         string( name: 'choiceParams', value: 'validChoice' ) ,
                         booleanParam( name: 'booleanParams', value: false  ) ,
                       ]
      String log = """
              result : ${buildRes.result}
                 url : ${buildRes.absoluteUrl}
        build number : ${buildRes.number.toString()}
      """
      println log

    } // stage : trigger downstream
  } // node : master
}} // ansiColor | timestamps
```

#### trigger downstream with active choice parameters
> [/marslo/sandbox](properties.html#mixed-parameters)

```groovy
timestamps { ansiColor('xterm') {
  podTemplate(cloud: 'DevOps Kubernetes') { node(POD_LABEL) {
    List<ParameterValue> newParams = [
      [$class: 'StringParameterValue' , name: 'lastName'  , value: 'Jiao'    ] ,
      [$class: 'StringParameterValue' , name: 'firstName' , value: 'Marslo'  ] ,
      [$class: 'StringParameterValue' , name: 'provinces' , value: 'Gansu'   ] ,
      [$class: 'StringParameterValue' , name: 'cities'    , value: 'Lanzhou,Dingxi' ] ,
      [$class: 'BooleanParameterValue', name: 'notify', value: false]
    ]
    def res = build ( job: '/marslo/sandbox' ,
                      propagate  : false ,
                      wait       : true  ,
                      parameters: newParams
                    )
    println """
            result : ${res.result}
               url : ${res.absoluteUrl}
      build number : ${res.number.toString()}
    """
  }} // node | podTemplate
}} // ansiColor | timestamp
```

![build downstream jobs](../../screenshot/jenkins/trigger-downstream.png)

### [get changelogs](https://support.cloudbees.com/hc/en-us/articles/217630098-How-to-access-Changelogs-in-a-Pipeline-Job-)
```groovy
def changeLogSets = currentBuild.changeSets
for (int i = 0; i < changeLogSets.size(); i++) {
  def entries = changeLogSets[i].items
  for (int j = 0; j < entries.length; j++) {
    def entry = entries[j]
    echo "${entry.commitId} by ${entry.author} on ${new Date(entry.timestamp)}: ${entry.msg}"
    def files = new ArrayList(entry.affectedFiles)
    for (int k = 0; k < files.size(); k++) {
      def file = files[k]
      echo "  ${file.editType.name} ${file.path}"
    }
  }
}
```
- [Pipeline Supporting APIs Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Pipeline+Supporting+APIs+Plugin) older than `2.2`
  ```groovy
  def changeLogSets = currentBuild.rawBuild.changeSets
  for (int i = 0; i < changeLogSets.size(); i++) {
    def entries = changeLogSets[i].items
    for (int j = 0; j < entries.length; j++) {
      def entry = entries[j]
      echo "${entry.commitId} by ${entry.author} on ${new Date(entry.timestamp)}: ${entry.msg}"
      def files = new ArrayList(entry.affectedFiles)
      for (int k = 0; k < files.size(); k++) {
        def file = files[k]
        echo "  ${file.editType.name} ${file.path}"
      }
    }
  }
  ```
