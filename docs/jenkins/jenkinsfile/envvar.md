<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [environment variables](#environment-variables)
  - [get current customized environment](#get-current-customized-environment)
  - [get downstream build environment](#get-downstream-build-environment)
  - [get previous build environment](#get-previous-build-environment)
- [global environment](#global-environment)
  - [`System.getenv()`](#systemgetenv)
  - [`sh 'env'` or `sh 'printenv'`](#sh-env-or-sh-printenv)
  - [`env.getEnvironment()` or `currentBuild.getRawBuild().getEnvironment()`](#envgetenvironment-or-currentbuildgetrawbuildgetenvironment)
  - [get builds environment](#get-builds-environment)
- [setup environment](#setup-environment)
  - [using Groovy script](#using-groovy-script)
  - [Creating Local Environment Variables](#creating-local-environment-variables)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> references:
> - [Jenkins Pipeline Environment Variables - The Definitive Guide](https://e.printstacktrace.blog/jenkins-pipeline-environment-variables-the-definitive-guide/)
> - [Using environment variables in Jenkins pipelines - with examples](https://tomd.xyz/jenkins-env-vars/)
> - [Jenkins Pipeline - set and use environment variables](https://code-maven.com/jenkins-pipeline-environment-variables)

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

## global environment
### `System.getenv()`
{% hint style='tip' %}
To get the Jenkins Global environment variables
{% endhint %}

```groovy
System.getenv().collect { k, v -> "$k=$v" }.join('\n>>> ')
```
- result
  ```
  PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  >>> PWD=/
  >>> LANGUAGE=en_US:en
  >>> LC_ALL=en_US.UTF-8
  >>> SHLVL=0
  >>> JAVA_HOME=/opt/java/openjdk
  >>> JENKINS_VERSION=2.284
  >>> JAVA_VERSION=jdk8u282-b08
  >>> JENKINS_UC=https://updates.jenkins.io
  >>> JAVA_OPTS=-Xms48G -Xmx144G -Duser.timezone='America/Los_Angeles' -XX:+UseG1GC -Dhudson.model.DirectoryBrowserSupport.CSP="sandbox allow-same-origin allow-scripts; default-src 'self'; script-src * 'unsafe-eval'; img-src *; style-src * 'unsafe-inline'; font-src *;" -Djenkins.slaves.NioChannelSelector.disabled=true -Djenkins.slaves.JnlpSlaveAgentProtocol3.enabled=false -Djava.awt.headless=true -Djenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST=true -Dhudson.model.ParametersAction.keepUndefinedParameters=true -Dcom.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors=true -Djenkins.install.runSetupWizard=true -Dpermissive-script-security.enabled=true -DsessionTimeout=1440 -DsessionEviction=43200 -Dgroovy.grape.report.downloads=true -Divy.message.logger.level=4 -Dhudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps=false
  ...
  ```

### `sh 'env'` or `sh 'printenv'`

{% hint style='tip' %}
running script in agent, so the result is the agent system environment variables + job itself variables (i.e: params and ${env.JENKINS_xxx})
{% endhint %}

```groovy
sh 'env'

// or
sh 'printenv | sort'
```
- result
  ```
  AGENT_WORKDIR=/home/devops/agent
  BUILD_DISPLAY_NAME=#1332
  BUILD_ID=1332
  BUILD_NUMBER=1332
  BUILD_TAG=jenkins-marslo-sandbox-1332
  BUILD_TIMESTAMP=2021-05-07 00:02:22 PDT
  JENKINS_HOME=/var/jenkins_home
  JOB_BASE_NAME=sandbox
  MY_TEST=works                   // particular environment setup in agent itself (linux)
  PATH=/it/my/test:/test/again:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  SHLVL=1
  TERM=xterm
  ...
  ```

### `env.getEnvironment()` or `currentBuild.getRawBuild().getEnvironment()`

{% hint style='tip' %}
pure Jenkins job's environment variables (and parameters)
{% endhint %}

```groovy
println currentBuild.getRawBuild().getEnvironment()

// or
println prettyPrint( toJson(env.getEnvironment()) )
```

- result
  ```
  {BUILD_DISPLAY_NAME=#1332, BUILD_ID=1332, BUILD_NUMBER=1332, BUILD_TAG=jenkins-marslo-sandbox-1332, BUILD_TIMESTAMP=2021-05-07 00:02:22 PDT, CLASSPATH=, HUDSON_HOME=/var/jenkins_home, JENKINS_HOME=/var/jenkins_home, ...}

  // or

  {
    "BUILD_DISPLAY_NAME": "#1335",
    "BUILD_ID": "1335",
    "BUILD_NUMBER": "1335",
    "BUILD_TAG": "jenkins-marslo-sandbox-1335",
    "BUILD_TIMESTAMP": "2021-05-07 00:26:40 PDT",
    "CLASSPATH": "",
    "HUDSON_HOME": "/var/jenkins_home",
    "JOB_NAME": "marslo/sandbox",
    ...
  }
  ```

### [get builds environment](https://stackoverflow.com/a/56472651/2940319)
> references:
> - [Access to build environment variables from a groovy script in a Jenkins build step (Windows)](https://stackoverflow.com/a/26428580/2940319)

```groovy
import hudson.model.*

def build = Thread.currentThread().executable
def myVar = build.getBuildVariables().get('myVar')
```

[or](https://stackoverflow.com/q/47098330/2940319)
```groovy
import hudson.slaves.EnvironmentVariablesNodeProperty
import hudson.EnvVars
import hudson.model.BuildableItem
import hudson.model.Job
import jenkins.model.*;


jenkins = Jenkins.instance;
EnvironmentVariablesNodeProperty prop = jenkins.getGlobalNodeProperties().get(EnvironmentVariablesNodeProperty.class)
EnvVars env = prop.getEnvVars()

println env['MY_VAR']
```

## setup environment
### [using Groovy script](https://www.lambdatest.com/blog/set-jenkins-pipeline-environment-variables-list/)
```groovy
import hudson.EnvVars;
import hudson.slaves.EnvironmentVariablesNodeProperty;
import hudson.slaves.NodeProperty;
import hudson.slaves.NodePropertyDescriptor;
import hudson.util.DescribableList;
import jenkins.model.Jenkins;
public createGlobalEnvironmentVariables(String key, String value){

  Jenkins instance = Jenkins.getInstance();

  DescribableList<NodeProperty<?>, NodePropertyDescriptor> globalNodeProperties = instance.getGlobalNodeProperties();
  List<EnvironmentVariablesNodeProperty> envVarsNodePropertyList = globalNodeProperties.getAll(EnvironmentVariablesNodeProperty.class);

  EnvironmentVariablesNodeProperty newEnvVarsNodeProperty = null;
  EnvVars envVars = null;

  if ( envVarsNodePropertyList == null || envVarsNodePropertyList.size() == 0 ) {
    newEnvVarsNodeProperty = new hudson.slaves.EnvironmentVariablesNodeProperty();
    globalNodeProperties.add(newEnvVarsNodeProperty);
    envVars = newEnvVarsNodeProperty.getEnvVars();
  } else {
    envVars = envVarsNodePropertyList.get(0).getEnvVars();
  }
  envVars.put(key, value)
  instance.save()

}
createGlobalEnvironmentVariables('Var1','Dummy')
```

### [Creating Local Environment Variables](https://www.lambdatest.com/blog/set-jenkins-pipeline-environment-variables-list/)
- declarative pipeline
  ```groovy
  pipeline {
    agent any
    environment {
      DISABLE_AUTH = 'true'                               //can be used in whole pipeline
    }
    stages {
      stage(“Build”) {
        steps {
          echo env.DISABLE_AUTH
        }
      }
    }
  }
  ```
- scripted pipeline
  ```groovy
  node{
    stage('Build') {
      withEnv(["DISABLE_AUTH=true"]) {
        echo env.DISABLE_AUTH
      }
    }
  }
```

### [update Jenkins envvars in Jenkisnfile](https://stackoverflow.com/a/54945018)
```groovy
import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*
import hudson.slaves.*

def updateEnvVar() {
  script {
    instance = Jenkins.getInstance()
    globalNodeProperties = instance.getGlobalNodeProperties()
    envVarsNodePropertyList = globalNodeProperties.getAll(hudson.slaves.EnvironmentVariablesNodeProperty.class)

    newEnvVarsNodeProperty = null
    envVars = null

    if ( envVarsNodePropertyList == null || envVarsNodePropertyList.size() == 0 ) {
      newEnvVarsNodeProperty = new hudson.slaves.EnvironmentVariablesNodeProperty();
      globalNodeProperties.add(newEnvVarsNodeProperty);
      envVars = newEnvVarsNodeProperty.getEnvVars();
      envVars.put(NEW_VAR, "toto");
    } else {
      for (property in envVarsNodePropertyList) {
        envVars = property.getEnvVars();
        envVars.put("EXISTING_VAR","tata");
      }
    }

    instance.save()
  }
}
```
