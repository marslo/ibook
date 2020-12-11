<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [build & current build](#build--current-build)
  - [check previous build status](#check-previous-build-status)
  - [Stop the current build](#stop-the-current-build)
  - [get current build info](#get-current-build-info)
  - [trigger downstream builds](#trigger-downstream-builds)

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
