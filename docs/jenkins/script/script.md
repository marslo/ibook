<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [script console](#script-console)
  - [usage](#usage)
  - [setup system (temporary)](#setup-system-temporary)
  - [extend built-in node executor](#extend-built-in-node-executor)
  - [execute shell script in console](#execute-shell-script-in-console)
  - [read & write files](#read--write-files)
- [jenkins system](#jenkins-system)
- [jobs & builds](#jobs--builds)
  - [list build status with percentage](#list-build-status-with-percentage)
  - [get all builds status during certain start-end time](#get-all-builds-status-during-certain-start-end-time)
  - [list builds which running for more than 24 hours](#list-builds-which-running-for-more-than-24-hours)
  - [get workspace](#get-workspace)
  - [shelve jobs](#shelve-jobs)
- [plugins](#plugins)
  - [via api : imarslo: list plugins](#via-api--imarslo-list-plugins)
  - [simple list](#simple-list)
  - [with delegate to Servlet container security realm](#with-delegate-to-servlet-container-security-realm)
  - [list plugin and dependencies](#list-plugin-and-dependencies)
- [scriptApproval](#scriptapproval)
  - [backup & restore all scriptApproval items](#backup--restore-all-scriptapproval-items)
  - [automatic approval all pending](#automatic-approval-all-pending)
  - [disable the scriptApproval](#disable-the-scriptapproval)
- [logRotator](#logrotator)
  - [show logRotator](#show-logrotator)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [Script Console](https://www.jenkins.io/doc/book/managing/script-console/)
> - [Jenkins Features Controlled with System Properties](https://www.jenkins.io/doc/book/managing/system-properties/)
> - [samrocketman/jenkins-script-console-scripts](https://github.com/samrocketman/jenkins-script-console-scripts)
>   - [monitor and slack](https://github.com/samrocketman/jenkins-script-console-scripts/blob/main/monitor-agent-queue.groovy)
> - [* jenkinsci/jenkins-scripts](https://github.com/jenkinsci/jenkins-scripts)
> - [* cloudbees/jenkins-scripts](https://github.com/cloudbees/jenkins-scripts)
> - [mubbashir/Jenkins+Script+Console.md](https://gist.github.com/mubbashir/484903fda934aeea9f30)
> - [Sam Gleske’s jenkins-script-console-scripts repository](https://github.com/samrocketman/jenkins-script-console-scripts)
> - [Sam Gleske’s jenkins-bootstrap-shared repository](https://github.com/samrocketman/jenkins-bootstrap-shared)
> - [Some scripts at JBoss.org](http://community.jboss.org/wiki/HudsonHowToDebug)
> - [mikejoh/jenkins-and-groovy-snippets.md](https://gist.github.com/mikejoh/9a721d1e6de7574059dcb8f851692be9)
> - [Jenkins : Jenkins Script Console](https://wiki.jenkins.io/display/JENKINS/Jenkins-Script-Console.html)
> - [Jenkins : Use Jenkins](https://wiki.jenkins.io/display/JENKINS/Use-Jenkins.html)
> - [Java API Usage Example](https://programtalk.com/java-api-usage-examples/?api=jenkins)
>   - [jenkins.model.Jenkins](https://programtalk.com/java-api-usage-examples/jenkins.model.Jenkins/)
>   - [jenkins.model.BuildDiscarder](https://programtalk.com/java-api-usage-examples/jenkins.model.BuildDiscarder/)
>   - [org.jenkinsci.plugins.workflow.steps](https://javadoc.jenkins.io/plugin/workflow-basic-steps/org/jenkinsci/plugins/workflow/steps/package-summary.html)
> - [I have a stuck Pipeline and I can not stop it](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/troubleshooting-guides/i-have-a-stuck-pipeline-and-i-can-not-stop-it)
> - [others](https://wiki.jenkins.io/display/JENKINS/Jenkins-Script-Console.html)
>  - [Jenkins : Monitor and Restart Offline Slaves](https://wiki.jenkins.io/display/JENKINS/Monitor-and-Restart-Offline-Slaves.html)
>  - [Jenkins : Monitoring Scripts](https://wiki.jenkins.io/display/JENKINS/Monitoring-Scripts.html)
>  - [Jenkins : Printing a list of credentials and their IDs](https://wiki.jenkins.io/display/JENKINS/Printing-a-list-of-credentials-and-their-IDs.html)
>  - [Jenkins : Wipe workspaces for a set of jobs on all nodes](https://wiki.jenkins.io/display/JENKINS/Wipe-workspaces-for-a-set-of-jobs-on-all-nodes.html)
>  - [Jenkins : Invalidate Jenkins HTTP sessions](https://wiki.jenkins.io/display/JENKINS/Invalidate-Jenkins-HTTP-sessions.html)
>  - [Jenkins : Grant Cancel Permission for user and group that have Build permission](https://wiki.jenkins.io/display/JENKINS/Grant-Cancel-Permission-for-user-and-group-that-have-Build-permission.html)
{% endhint %}

> [!TIP]
> to list methods on a class instance:
> ```groovy
> thing.metaClass.methods*.name.sort().unique()
> ```
> to determine a class from an instance:
> ```groovy
> thing.class
> // or
> thing.getClass()
> ```

## [script console](https://www.jenkins.io/doc/book/managing/script-console/)
### usage

> [!TIP]
> - [CSRF Protection Explained](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/csrf-protection-explained)
>   - if you authenticate your API calls with a username and a user API token then a crumb is not required from Jenkins 2.96
>
> - [to get CSRF crumb via curl](./authorization.html#get-crumb-via-cmd)
>   ```bash
>   $ SERVER="https://localhost:8080"
>   $ COOKIEJAR="$(mktemp)"
>   $ CRUMB=$(curl -u "admin:admin" -s --cookie-jar "$COOKIEJAR" "$SERVER/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
>   # to run script via curl
>   $ curl -d "script=System.getProperties()" \
>          -u "admin:admin" \
>          --cookie "$COOKIEJAR" \
>          -H "$CRUMB" \
>          https://${SERVER}/scriptText
>   ```
> - [or](./api.html#execute-groovy-script-with-an-api-call)
>   ```bash
>   $ SERVER="https://localhost:8080"
>   $ COOKIEJAR="$(mktemp)"
>   $ CRUMB=$(curl -u "admin:admin" \
>                  --cookie-jar "${COOKIEJAR}" \
>                  'https://${SERVER}/crumbIssuer/api/json' |
>                  jq -r '[.crumbRequestField, .crumb] | join(":")'
>            )
>   # verify
>   $ echo $CRUMB
>   Jenkins-Crumb:c11dc*******************************************************e463
>   $ curl -d "script=System.getProperties()" \
>          -u "admin:admin" \
>          -s \
>          --cookie "$COOKIEJAR" \
>          -H "$CRUMB" \
>          https://${SERVER}/scriptText
>   $ curl --data-urlencode "script=$(< ./script.groovy)" \
>          -s \
>          --netrc-file ~/.netrc \
>          --cookie "${COOKIEJAR}" \
>          -H "${CRUMB}" \
>          https://${SERVER}/scriptText
>   ```

- remote access
  ```bash
  $ curl -d "script=<your_script_here>" https://jenkins/script

  # or to get output as a plain text result (no HTML)
  $ curl -d "script=<your_script_here>" https://jenkins/scriptText
  ```

- curl submitting groovy file
  ```bash
  $ curl --data-urlencode "script=$(< ./somescript.groovy)" https://jenkins/scriptText
  ```
  - via api token
    ```bash
    $ curl --user 'username:api-token' \
           --data-urlencode \
           "script=$(< ./somescript.groovy)" \
           https://jenkins/scriptText
    ```
  - via python
    ```bash
    with open('somescript.groovy', 'r') as fd:
      data = fd.read()
    r = requests.post('https://jenkins/scriptText', auth=('username', 'api-token'), data={'script': data})
    ```

### setup system (temporary)

> [!TIP|label:references:]
> - [Jenkins Features Controlled with System Properties](https://www.jenkins.io/doc/book/managing/system-properties/)
> - [Configuring Content Security Policy](https://www.jenkins.io/doc/book/security/configuring-content-security-policy/)

- timestampe
  ```groovy
  System.setProperty('org.apache.commons.jelly.tags.fmt.timeZone', 'America/Los_Angeles')
  ```

- [shell step aborts](https://issues.jenkins.io/browse/JENKINS-48300)
  ```groovy
  System.setProperty("org.jenkinsci.plugins.durabletask.BourneShellScript.HEARTBEAT_CHECK_INTERVAL", 36000)
  ```

- to clear property
  ```groovy
  System.clearProperty("hudson.model.DirectoryBrowserSupport.CSP")
  ```

- to get property
  ```groovy
  System.setProperty("hudson.model.DirectoryBrowserSupport.CSP", "")
  ```

- to get all properties
  ```groovy
  System.getProperties()

  // or
  System.getProperties().sort().collectEntries{[ (it.key), (it.value) ]}
  System.getProperties().sort().each { println "${it.key} ~> ${it.value}" }
  System.getProperties().sort().collect{ "${it.key} ~> ${it.value}" }.join('\n')
  ```

### extend built-in node executor
```groovy
import jenkins.model.*
Jenkins.instance.setNumExecutors(5)
```

### execute shell script in console

> [!TIP|label:references:]
> - [Run scripts from controller Script Console on agents](https://www.jenkins.io/doc/book/managing/script-console/#run-scripts-from-controller-script-console-on-agents)

```groovy
println ("uname -a".execute().text)

// or
println ("printenv".execute().in.text)
```

- result
  ```
  Linux devops-jenkins-685cf57df9-znfs8 4.19.12-1.el7.elrepo.x86_64 #1 SMP Fri Dec 21 11:06:36 EST 2018 x86_64 GNU/Linux
  ```

- or
  ```groovy
  import hudson.util.RemotingDiagnostics
  import jenkins.model.Jenkins

  String agentName = 'your agent name'
  //groovy script you want executed on an agent
  groovy_script = '''
  println System.getenv("PATH")
  println "uname -a".execute().text
  '''.trim()

  String result
  Jenkins.instance.slaves.find { agent ->
      agent.name == agentName
  }.with { agent ->
      result = RemotingDiagnostics.executeGroovy(groovy_script, agent.channel)
  }
  println result
  ```

### read & write files
```groovy
// write
new File('/tmp/file.txt').withWriter('UTF-8') { writer ->
  try {
    writer << 'hello world\n'
  } finally {
    writer.close()
  }
}

// read
new File('/tmp/file.txt').text
```

- write file in agent
  ```groovy
  import hudson.FilePath
  import hudson.remoting.Channel
  import jenkins.model.Jenkins

  String agentName = 'some-agent'
  String filePath = '/tmp/file.txt'

  Channel agentChannel = Jenkins.instance.slaves.find { agent ->
    agent.name == agentName
  }.channel

  new FilePath(agentChannel, filePath).write().with { os ->
    try {
      os << 'hello world\n'
    } finally {
      os.close()
    }
  }
  ```

- read file from an agent
  ```groovy
  import hudson.FilePath
  import hudson.remoting.Channel
  import jenkins.model.Jenkins

  import java.io.BufferedReader
  import java.io.InputStreamReader
  import java.nio.charset.StandardCharsets
  import java.util.stream.Collectors

  String agentName = 'some-agent'
  String filePath = '/tmp/file.txt'

  Channel agentChannel = Jenkins.instance.slaves.find { it.name == agentName }.channel

  String fileContents = ''
  new FilePath(agentChannel, filePath).read().with { is ->
    try {
      fileContents = new BufferedReader(
                       new InputStreamReader(is, StandardCharsets.UTF_8))
                          .lines()
                          .collect(Collectors.joining("\n")
                     )
    } finally {
      is.close()
    }
  } // with

  // print contents of the file from the agent
  println '==='
  println(fileContents)
  println '==='
  ```

#### modify log level

{% hint style='tip' %}
> references:
> - [How to change the default or package log levels](https://support.cloudbees.com/hc/en-us/articles/115003914391-How-to-change-the-default-or-package-log-levels)
> - [Configure Loggers for Jenkins](https://support.cloudbees.com/hc/en-us/articles/115002626172-Configure-Loggers-for-Jenkins)
> - [Disable HttpClient logging](https://stackoverflow.com/a/61128260/2940319)
> - [Viewing logs](https://www.jenkins.io/doc/book/system-administration/viewing-logs/)
{% endhint %}

```groovy
System.setProperty("org.apache.commons.logging.Log", "org.apache.commons.logging.impl.SimpleLog");
System.setProperty("org.apache.commons.logging.simplelog.showdatetime", "true");
System.setProperty("org.apache.commons.logging.simplelog.log.httpclient.wire.header", "error");
System.setProperty("org.apache.commons.logging.simplelog.log.org.apache.http", "error");
System.setProperty("log4j.logger.org.apache.http", "error");
System.setProperty("log4j.logger.org.apache.http.wire", "error");
System.setProperty("org.apache.commons.logging.simplelog.log.org.apache.commons.httpclient", "error");
```
- check log level
  ```groovy
  println System.getProperty("org.apache.commons.logging.Log");
  println System.getProperty("org.apache.commons.logging.simplelog.showdatetime");
  println System.getProperty("org.apache.commons.logging.simplelog.log.httpclient.wire.header");
  println System.getProperty("org.apache.commons.logging.simplelog.log.org.apache.http");
  println System.getProperty("log4j.logger.org.apache.http");
  println System.getProperty("log4j.logger.org.apache.http.wire");
  println System.getProperty("org.apache.commons.logging.simplelog.log.org.apache.commons.httpclient");
  ```

## jenkins system

{% hint style='tip' %}
> references:
> - [AnalogJ/you-dont-know-jenkins-init](https://github.com/AnalogJ/you-dont-know-jenkins-init)
> - [3003.plugin-pipeline-library.groovy](https://github.com/AnalogJ/you-dont-know-jenkins-init/blob/master/3003.plugin-pipeline-library.groovy)
> - [Using Hudson/Features controlled by system properties](https://wiki.eclipse.org/Using_Hudson/Features_controlled_by_system_properties)
{% endhint %}

```groovy
import jenkins.model.*;
import org.jenkinsci.main.modules.sshd.*;

def instance = Jenkins.instance
instance.setDisableRememberMe( false )
instance.setNumExecutors( 2 )
instance.setSystemMessage( '<h2>welcome to the Jenkins Master</h2>' )
instance.setRawBuildsDir()
instance.save()

def sshd = SSHD.get()
sshd.setPort( 12345 )
sshd.save()
```

## jobs & builds

> [!TIP|label:get more:]
> - [* imarslo : jobs](./job.html)
> - [* imarslo : builds](./build.html)

### list build status with percentage
- [get all builds result percentage](./build.html#get-all-builds-result-percentage)
- [get builds result percentage within 24 hours](./build.html#get-builds-result-percentage-within-24-hours)
- [get builds result and percentage within certain start-end time](./build.html#get-builds-result-and-percentage-within-certain-start-end-time)

### get all builds status during certain start-end time
- [list all builds within 24 hours](./build.html#list-all-builds-within-24-hours)
- [get last 24 hours failure builds](./build.html#get-last-24-hours-failure-builds)
- [get last 24 hours failure builds via Map structure](./build.html#get-last-24-hours-failure-builds-via-map-structure)
- [get builds result during certain start-end time](./build.html#get-builds-result-during-certain-start-end-time)
- [get builds result and percentage within certain start-end time](./build.html#get-builds-result-and-percentage-within-certain-start-end-time)

### [list builds which running for more than 24 hours](https://raw.githubusercontent.com/cloudbees/jenkins-scripts/master/builds-running-more-than-24h.groovy)
- [list job which running for more than 24 hours](./build.html#list-all-builds-within-24-hours)
- [get last 24 hours failure builds](./build.html#get-last-24-hours-failure-builds)
- [get last 24 hours failure builds via Map structure](./build.html#get-last-24-hours-failure-builds-via-map-structure)
- [get builds result percentage within 24 hours](./build.html#get-builds-result-percentage-within-24-hours)
- [get builds result during certain start-end time](./build.html#get-builds-result-during-certain-start-end-time)
- [get builds result and percentage within certain start-end time](./build.html#get-builds-result-and-percentage-within-certain-start-end-time)

### [get workspace](https://github.com/jenkinsci/job-dsl-plugin/blob/master/docs/User-Power-Moves.md#list-the-files-in-a-jenkins-jobs-workspace)
```groovy
hudson.FilePath workspace = hudson.model.Executor.currentExecutor().getCurrentWorkspace()
```

- [get absolute path](https://github.com/jenkinsci/job-dsl-plugin/wiki/Job-DSL-Commands#script-location)
  ```groovy
  println("script directory: ${new File(__FILE__).parent.absolutePath}")
  ```

### [shelve jobs](https://support.cloudbees.com/hc/en-us/articles/236353928-Groovy-Scripts-To-Shelve-Jobs)
```groovy
//You have to install the Shelve Project Plugin on your Jenkins Master
//The maximum value for daysBack is 365, going beyond 365 will break the script.

import org.jvnet.hudson.plugins.shelveproject.ShelveProjectTask

def daysBack=365;
Jenkins.instance.getAllItems(AbstractProject.class).each { it ->
  def lastBuild = it.getLastBuild()
  if( lastBuild != null ) {
    def back = Calendar.getInstance()
      back.set( Calendar.DAY_OF_YEAR,back.get(Calendar.DAY_OF_YEAR) - daysBack )
      if ( lastBuild.getTime().compareTo(back.getTime()) < 0 ) {
        println it.name + " was built over " + daysBack + " days ago: " + lastBuild.getTime()
          if ( it instanceof AbstractProject ){
            def spt=  new ShelveProjectTask(it)
            Hudson.getInstance().getQueue().schedule(spt , 0 );
          } else {
            println it.name + " was not shelved----------- "
          }
      }
  }
}
```

## plugins
### via api : [imarslo: list plugins](../api.html#list-plugins)
### [simple list](https://stackoverflow.com/a/35292719/2940319)
```groovy
Jenkins.instance
       .pluginManager
       .plugins
       .each { plugin ->
         println ( "${plugin.getDisplayName()} (${plugin.getShortName()}): ${plugin.getVersion()}" )
       }
```

### [with delegate to Servlet container security realm](https://www.jenkins.io/doc/book/security/access-control/permissions/)
```groovy
ExtensionList.lookup( UnprotectedRootAction ).each {
  println String.format( "URL: '%s/' provided by '%s' in '%s'",
                         it.urlName,
                         Jenkins.get().pluginManager.whichPlugin(it.class)?.shortName?:"Jenkins Core",
                         it.class.name
          )
}
```

### list plugin and dependencies

```groovy
println Jenkins.instance.pluginManager.plugins
               .sort(false) { a, b ->
                                a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()
                            }
               .collect { plugin ->
                            "~~> ${plugin.shortName} : ${plugin.version} : ${plugin.displayName}" +
                            ( plugin.dependants   ? "\n\t+++ ${plugin.dependants.join('\n\t+++ ')}"   : '' )  +
                            ( plugin.dependencies ? "\n\t... ${plugin.dependencies.join('\n\t... ')}" : '' )
                        }
               .join('\n')
```

- get specific plugin dependencies
  ```groovy
  List<String> keywords = [ 'jsch' ]

  println Jenkins.instance.pluginManager.plugins
                 .findAll { plugin -> keywords.any { it == plugin.shortName } }
                 .sort(false) { a, b ->
                                  a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()
                              }
                 .collect { plugin ->
                              "~~> ${plugin.shortName} : ${plugin.version} : ${plugin.displayName}" +
                              ( plugin.dependants   ? "\n\t+++ ${plugin.dependants.join('\n\t+++ ')}"   : '' )  +
                              ( plugin.dependencies ? "\n\t... ${plugin.dependencies.join('\n\t... ')}" : '' )
                          }
                 .join('\n')
  ```

- get dependency tree
  ```groovy
  import hudson.PluginWrapper

  def getDependencyTree( String keyword, Integer benchmark = 2, Integer index = 0 ) {
    String prefix        = index ? '\t' + "|\t"*(index-1) + "|... " : ''
    PluginWrapper plugin = jenkins.model.Jenkins.instance.pluginManager.plugins.find { keyword == it.shortName }
    List dependencies    = plugin.collect { it.dependencies }.flatten() ?: []

    println prefix + "${plugin.shortName} ( ${plugin.version} )"

    if ( dependencies && benchmark != index ) {
      dependencies.collect{ it.shortName }.each { getDependencyTree (it, benchmark, index+1) }
    }
  }

  getDependencyTree( 'jsch', 100 )

  "DONE"
  ```

  - result
    ```groovy
    jsch ( 0.2.8-65.v052c39de79b_2 )
        |... ssh-credentials ( 305.v8f4381501156 )
        |   |... credentials ( 1254.vb_96f366e7b_a_d )
        |   |   |... structs ( 324.va_f5d6774f3a_d )
        |   |   |   |... javax-activation-api ( 1.2.0-6 )
        |   |   |   |... javax-mail-api ( 1.6.2-9 )
        |   |   |   |   |... javax-activation-api ( 1.2.0-6 )
        |   |   |   |... instance-identity ( 173.va_37c494ec4e5 )
        |   |   |   |   |... bouncycastle-api ( 2.28 )
        |   |   |... configuration-as-code ( 1647.ve39ca_b_829b_42 )
        |   |   |   |... caffeine-api ( 3.1.6-115.vb_8b_b_328e59d8 )
        |   |   |   |... commons-text-api ( 1.10.0-36.vc008c8fcda_7b_ )
        |   |   |   |   |... commons-lang3-api ( 3.12.0-36.vd97de6465d5b_ )
        |   |   |   |   |   |... javax-activation-api ( 1.2.0-6 )
        |   |   |   |   |   |... javax-mail-api ( 1.6.2-9 )
        |   |   |   |   |   |   |... javax-activation-api ( 1.2.0-6 )
        |   |   |   |   |   |... instance-identity ( 173.va_37c494ec4e5 )
        |   |   |   |   |   |   |... bouncycastle-api ( 2.28 )
        |   |   |   |... snakeyaml-api ( 1.33-95.va_b_a_e3e47b_fa_4 )
        |   |... trilead-api ( 2.84.v72119de229b_7 )
        |   |... instance-identity ( 173.va_37c494ec4e5 )
        |   |   |... bouncycastle-api ( 2.28 )
        |... trilead-api ( 2.84.v72119de229b_7 )
        |... javax-activation-api ( 1.2.0-6 )
        |... javax-mail-api ( 1.6.2-9 )
        |   |... javax-activation-api ( 1.2.0-6 )
        |... instance-identity ( 173.va_37c494ec4e5 )
        |   |... bouncycastle-api ( 2.28 )
    ```

- [others](https://stackoverflow.com/a/56864983/2940319)
  ```groovy
  def plugins = Jenkins.instance
                       .pluginManager
                       .plugins
                       .sort(false) { a, b ->
                         a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()
                       }

  println "jenkins instance : ${Jenkins.instance.getComputer('').hostName} + ${Jenkins.instance.rootUrl}\n" +
          "installed plugins:\n" +
          "=================="
  plugins.each { plugin ->
    println "  ${plugin.getShortName()} : ${plugin.getVersion()} | ${plugin.getDisplayName()}"
  }

  println "\nplugins dependency tree (...: dependencies; +++: dependants) :\n" +
          "======================="
  plugins.each { plugin ->
    println """
      ${plugin.getShortName()} : ${plugin.getVersion()} | ${plugin.getDisplayName()}
      +++ ${plugin.getDependants()}
      ... ${plugin.getDependencies()}

    """
  }
  ```

- or
  ```groovy
  def jenkins = Jenkins.instance

  println """
    Jenkins Instance : ${jenkins.getComputer('').hostName} + ${jenkins.rootUrl}
    Installed Plugins:
    ==================
  """
  jenkins.pluginManager
         .plugins
         .sort(false) { a, b ->
           a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()
         }.each { plugin ->
           println "${plugin.getShortName()}: ${plugin.getVersion()} | ${plugin.getDisplayName()}"
         }

  println """
    Plugins Dependency tree (...: dependencies; +++: dependants) :
    =======================
  """
  jenkins.pluginManager
         .plugins
         .sort(false) { a, b ->
           a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()
         }.each { plugin ->
           println """
             ${plugin.getShortName()} : ${plugin.getVersion()} | ${plugin.getDisplayName()}
             +++ ${plugin.getDependants()}
             ... ${plugin.getDependencies()}

           """
         }
  ```

## scriptApproval

{% hint style='tip' %}
> references:
> - [Class ScriptApproval](https://javadoc.jenkins.io/plugin/script-security/org/jenkinsci/plugins/scriptsecurity/scripts/ScriptApproval.html)
> - [ScriptApproval.java](https://github.com/jenkinsci/script-security-plugin/blob/master/src/main/java/org/jenkinsci/plugins/scriptsecurity/scripts/ScriptApproval.java)
> - [SecureGroovyScript.java](https://github.com/jenkinsci/script-security-plugin/blob/master/src/main/java/org/jenkinsci/plugins/scriptsecurity/sandbox/groovy/SecureGroovyScript.java)
> - [jenkins.model.CauseOfInterruption](https://programtalk.com/java-api-usage-examples/jenkins.model.CauseOfInterruption/)
{% endhint %}

### backup & restore all scriptApproval items
- backup
  ```groovy
  import java.lang.reflect.*
  import jenkins.model.Jenkins
  import jenkins.model.*
  import org.jenkinsci.plugins.scriptsecurity.scripts.*
  import org.jenkinsci.plugins.scriptsecurity.sandbox.whitelists.*
  import static groovy.json.JsonOutput.*

  scriptApproval = ScriptApproval.get()
  alreadyApproved = new HashSet<>(Arrays.asList(scriptApproval.getApprovedSignatures()))
  println prettyPrint( toJson(alreadyApproved.sort()) )
  ```

- restore
  ```bash
  def scriptApproval = org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval.get()

  String[] signs = [
    'method org.jenkinsci.plugins.workflow.steps.FlowInterruptedException getCauses' ,
    'method org.jenkinsci.plugins.workflow.support.steps.input.Rejection getUser'
  ]

  for( String sign : signs ) {
    scriptApproval.approveSignature( sign )
  }

  scriptApproval.save()
  ```

- [example](https://stackoverflow.com/a/55714171/2940319)
  ```groovy
  import java.lang.reflect.*;
  import jenkins.model.Jenkins;
  import jenkins.model.*;
  import org.jenkinsci.plugins.scriptsecurity.scripts.*;
  import org.jenkinsci.plugins.scriptsecurity.sandbox.whitelists.*;
  import static groovy.json.JsonOutput.*

  ScriptApproval scriptApproval = ScriptApproval.get()
  HashSet<String> alreadyApproved = new HashSet<>(Arrays.asList(scriptApproval.getApprovedSignatures()))

  Closure approveSignature = { String signature ->
    if ( ! alreadyApproved?.contains(signature) ) scriptApproval.approveSignature( signature )
  }

  [
    'field org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval$PendingSignature dangerous'         ,
    'field org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval$PendingSignature signature'         ,
    'method org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval$PendingThing getContext'           ,
    'method org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval approveSignature java.lang.String' ,
    'method org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval getPendingScripts'                 ,
    'method org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval getPendingSignatures'              ,
    'staticMethod org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval get'                         ,
    'staticMethod org.codehaus.groovy.runtime.DefaultGroovyMethods flatten java.util.Set'                  ,
    'method org.jenkinsci.plugins.workflow.support.steps.build.RunWrapper getRawBuild'
  ].each { println "~~> ${it}"; approveSignature(it) }

  scriptApproval.save()
  ```

- Jenkinsfile
  ```groovy
  #!/usr/bin/env groovy

  import org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval

  timestamps { ansiColor('xterm') {

    def requester = currentBuild.rawBuild.getCause(UserIdCause.class)?.getUserId() ?: 'jenkins'
    final List<String> description = []

    try {

      ScriptApproval scriptApproval = ScriptApproval.get()
      final LinkedHashSet<String> pendingScripts   = new HashSet<>(Arrays.asList( scriptApproval.getPendingScripts() )).flatten()
      final LinkedHashSet<String> pendingSignature = new HashSet<>(Arrays.asList( scriptApproval.getPendingSignatures() )).flatten()

      if ( ! pendingScripts && ! pendingSignature ) {
        currentBuild.description = 'NOT_BUILT: nothing can be approved'
        currentBuild.rawBuild.executor.interrupt( Result.NOT_BUILT )
      }

      if ( pendingScripts ) {
        println 'scripts pending approval ...'
        pendingScripts.collect().each { ps ->
          String log = "${ps.context.user}@${ps.context.psem.fullName} : ${ps.hash} ( ${ps.language.class.simpleName} )"
          description << log
          println "~~> ${log}. scripts: \n ${ps.script}"
          scriptApproval.approveScript( ps.hash )
        }
        scriptApproval.save()
      } // pendingScripts

      if ( pendingSignature ) {
        println 'signatures pending approval ...'
        pendingSignature.collect().each { ps ->
          String signature = ps.signature
          if ( ! ps.dangerous ) {
            description << signature
            println "~~> '${signature}'"
            scriptApproval.approveSignature( signature )
          } else {
            println "~~> '${signature}' is too dangerous to be approval automatically. contact with Jenkins administrator."
          }
          scriptApproval.save()
        }
      }

    } catch(e) {
      def sw = new StringWriter()
      e.printStackTrace( new PrintWriter(sw) )
      echo sw.toString()
      throw e
    } finally {
      if ( description ) {
        currentBuild.description = "@${requesterId} " +
                                   "${buildResults.isSuccess(currentBuild.currentResult) ? 'successful' : 'failed to'} " +
                                   "approved : '${description.join('; ')}'"
      }
    } // try/catch/finally

  }} // ansiColor | timestamps

  // vim: ft=Jenkinsfile ts=2 sts=2 sw=2 et
  ```

  - automatic approval
    ```groovy
    // libs.groovy
    def autoAccept( Closure body ) {
      try {
        body()
      } catch ( org.jenkinsci.plugins.scriptsecurity.sandbox.RejectedAccessException e ) {
        String msg = "NOT_BUILT : interrupted by approval scripts or signature"
        def cause = { msg as String } as CauseOfInterruption
        currentBuild.rawBuild.executor.interrupt( Result.NOT_BUILT, cause )
        currentBuild.description = msg
        build wait: false, job: '/marslo/scriptApproval'
      }
    }

    // jenkinsfile
    libs.autoAccept() {
      ...content...
    }
    ```

### automatic approval all pending
- [list pending scriptApproval](https://stackoverflow.com/a/55940005/2940319)
  ```groovy
  import org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval

  ScriptApproval scriptApproval = ScriptApproval.get()
  scriptApproval.pendingScripts.each { scriptApproval.approveScript( it.hash ) }
  ```

- [job dsl support for scriptapproval](https://issues.jenkins-ci.org/browse/JENKINS-31201?focusedCommentId=285330&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-285330)
  ```groovy
  import jenkins.model.Jenkins

  def scriptApproval = Jenkins.instance
                              .getExtensionList('org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval')[0]
  def hashesToApprove = scriptApproval.pendingScripts
                                      .findAll{ it.script.startsWith(approvalPrefix) }
                                      .collect{ it.getHash() }
  hashesToApprove.each { scriptApproval.approveScript(it) }
  ```

### [disable the scriptApproval](https://stackoverflow.com/a/49372857/2940319)

> [!NOTE|label:@deprecated]
> - file: `$JENKINS_HOME/init.groovy.d/disable-script-security.groovy`

```groovy
import javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration
import jenkins.model.GlobalConfiguration

// disable Job DSL script approval
GlobalConfiguration.all().get(GlobalJobDslSecurityConfiguration.class).useScriptSecurity=false
GlobalConfiguration.all().get(GlobalJobDslSecurityConfiguration.class).save()
```

## logRotator

{% hint style='tip' %}
> references:
> - [Class LogRotator](https://javadoc.jenkins.io/hudson/tasks/LogRotator.html)
> - [Jenkins : Manually run log rotation on all jobs](https://wiki.jenkins.io/display/JENKINS/Manually-run-log-rotation-on-all-jobs.html)
> - [jenkins/core/src/main/java/hudson/tasks/LogRotator.java](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/java/hudson/tasks/LogRotator.java)
{% endhint %}

### show logRotator
```groovy
List<String> projects = [ 'project' ]

Jenkins.instance.getAllItems(Job.class).findAll {
  projects.any { p -> it.fullName.startsWith(p) }
}.each {
  println """
    ~~> ${it.fullName} :

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
