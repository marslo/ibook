<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [get parameters from Jenkins script](#get-parameters-from-jenkins-script)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### get parameters from Jenkins script
```groovy
 def job = hudson.model.Hudson.instance.getItem('vega/tester')
 def paramsProp = job.getProperty(ParametersDefinitionProperty.class)
 def releaseTeamParameter = paramsProp.getParameterDefinitions().find { it.name == "tester" }
 return releaseTeamParameter.getChoices().toArray()
```

```groovy
// https://stackoverflow.com/a/32704455/2940319
import hudson.model.*

// get current thread / Executor and current build
def thr = Thread.currentThread()
def build = thr?.executable

// if you want the parameter by name ...
def hardcoded_param = "FOOBAR"
def resolver = build.buildVariableResolver
def hardcoded_param_value = resolver.resolve(hardcoded_param)

println "param ${hardcoded_param} value : ${hardcoded_param_value}"
```

```groovy
// https://stackoverflow.com/a/47095584/2940319
def build = this.getProperty('binding').getVariable('build')
def listener = this.getProperty('binding').getVariable('listener')
def env = build.getEnvironment(listener)
println env.MY_VARIABLE
```

```groovy
// https://github.com/pycontribs/jenkinsapi/issues/438
job = Jenkins.get_job("sandbox")
build = job.get_last_build()
parameters = build.get_actions()['parameters']
```

```groovy
// https://stackoverflow.com/a/10883330/2940319
build.getActions(hudson.model.ParametersAction)


// https://wiki.jenkins.io/display/JENKINS/Parameterized+System+Groovy+script
import hudson.model.*

// get current thread / Executor
def thr = Thread.currentThread()
// get current build
def build = thr?.executable


// get parameters
def parameters = build?.actions.find{ it instanceof ParametersAction }?.parameters
parameters.each {
   println "parameter ${it.name}:"
   println it.dump()
   println "-" * 80
}


// ... or if you want the parameter by name ...
def hardcoded_param = "FOOBAR"
def resolver = build.buildVariableResolver
def hardcoded_param_value = resolver.resolve(hardcoded_param)


println "param ${hardcoded_param} value : ${hardcoded_param_value}"
```

```groovy
// https://stackoverflow.com/a/19564602/2940319
// get parameters
def parameters = build?.actions.find{ it instanceof ParametersAction }?.parameters
parameters.each {
   println "parameter ${it.name}:"
   println it.dump()
}
```


```groovy
// https://stackoverflow.com/a/58803618/2940319

import hudson.model.Job
import hudson.model.ParametersAction
import hudson.model.Queue
import jenkins.model.Jenkins

println("================================================")
for (Job job : jenkins.model.Jenkins.instanceOrNull.getAllItems(Job.class)) {
    if (job.isInQueue()) {
        println("------------------------------------------------")
        println("InQueue " + job.name)

        Queue.Item queue = job.getQueueItem()
        if (queue != null) {
            println(queue.params)
        }
    }
    if (job.isBuilding()) {
        println("------------------------------------------------")
        println("Building " + job.name)

        def build = job.getBuilds().getLastBuild()
        def parameters = build?.getAllActions().find{ it instanceof ParametersAction }?.parameters
        parameters.each {
            def dump = it.dump()
            println "parameter ${it.name}: ${dump}"
        }
    }
}
println("================================================")
```


```groovy
// https://stackoverflow.com/a/54284838/2940319

import groovy.json.JsonSlurper

def root = "<url to job>"
def options = "/api/json?tree=builds[actions[parameters[name,value]],result,building,number,duration,estimatedDuration]"

def jsonSlurper = new JsonSlurper()
def text = new URL("${root}/${options}").text
def data = jsonSlurper.parseText(text)

data["builds"].each { buildsdata ->
    def result = buildsdata["result"]
    def num = buildsdata["number"]
    print("${root}/${num}/parameters  |")
    buildsdata["actions"].each { actions ->
        if (actions["_class"].equals("hudson.model.ParametersAction")) {
            actions["parameters"].sort({it.name}).each { param ->
                    print("${param.name}=${param.value}|")
            }
        }
    }
    println("")
}
```
