<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Script Console](#script-console)
  - [usage](#usage)
  - [basic usage](#basic-usage)
- [jobs](#jobs)
  - [get build status](#get-build-status)
  - [get all failure builds in last 24 hours](#get-all-failure-builds-in-last-24-hours)
  - [list all build history within 24 hours](#list-all-build-history-within-24-hours)
  - [list job which running for more than 24 hours](#list-job-which-running-for-more-than-24-hours)
  - [shelve jobs](#shelve-jobs)
- [List plugins](#list-plugins)
  - [via api](#via-api)
  - [simple list](#simple-list)
  - [List plugin and dependencies](#list-plugin-and-dependencies)
- [scriptApproval](#scriptapproval)
  - [backup & restore all scriptApproval items](#backup--restore-all-scriptapproval-items)
  - [automatic approval all pending](#automatic-approval-all-pending)
  - [disable the scriptApproval](#disable-the-scriptapproval)
- [abort](#abort)
  - [abort a build](#abort-a-build)
  - [abort running builds if new one is running](#abort-running-builds-if-new-one-is-running)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [samrocketman/jenkins-script-console-scripts](https://github.com/samrocketman/jenkins-script-console-scripts)
> - [jenkinsci/jenkins-scripts](https://github.com/jenkinsci/jenkins-scripts)
> - [cloudbees/jenkins-scripts](https://github.com/cloudbees/jenkins-scripts)
> - [mubbashir/Jenkins+Script+Console.md](https://gist.github.com/mubbashir/484903fda934aeea9f30)
> - [Sam Gleske’s jenkins-script-console-scripts repository](https://github.com/samrocketman/jenkins-script-console-scripts)
> - [Sam Gleske’s jenkins-bootstrap-shared repository](https://github.com/samrocketman/jenkins-bootstrap-shared)
> - [Some scripts at JBoss.org](http://community.jboss.org/wiki/HudsonHowToDebug)
{% endhint %}


## [Script Console](https://www.jenkins.io/doc/book/managing/script-console/)
### usage
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
    $ curl --user 'username:api-token' --data-urlencode \
      "script=$(< ./somescript.groovy)" https://jenkins/scriptText
    ```
  - via python
    ```bash
    with open('somescript.groovy', 'r') as fd:
        data = fd.read()
    r = requests.post('https://jenkins/scriptText', auth=('username', 'api-token'), data={'script': data})
    ```

### basic usage
- setup timestampe (temporary)
  ```groovy
  System.setProperty('org.apache.commons.jelly.tags.fmt.timeZone', 'America/Los_Angeles')
  ```

## [jobs](https://support.cloudbees.com/hc/en-us/articles/226941767-Groovy-to-list-all-jobs)
> get more: [jobs & builds](./build.md)

### [get build status](https://stackoverflow.com/a/28039134/2940319)
```groovy
final String JOB_PATTERN = '<group>[/<name>]'
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
  println "\n${name} : ${sum} : "
  status.each{ r, c ->
    println "\t${r}: ${c}: \t\tpercentage: " + (sum ? "${c * 100 / sum}%" : '0%')
  }
}
"DONE"
```

### [get all failure builds in last 24 hours](https://stackoverflow.com/a/60375862/2940319)
```groovy
import hudson.model.Job
import hudson.model.Result
import hudson.model.Run
import java.util.Calendar
import jenkins.model.Jenkins

final Calendar RIGHT_NOW = Calendar.getInstance()
final long BENCH_MARK    = 1*24*60*60*1000
final String JOB_PATTERN = '<group>[/<name>]'

Jenkins.instance.getAllItems(Job.class).findAll { Job job ->
  job.fullName.contains(JOB_PATTERN)
}.collect { Job job ->
  job.builds.findAll { Run run ->
    run.result == Result.FAILURE &&
    (RIGHT_NOW.getTimeInMillis() - run.getStartTimeInMillis()) <= BENCH_MARK
  }
}.sum().join('\n')
```

### [list all build history within 24 hours](https://gist.github.com/batmat/91faa3201ad2ae88e3d8)
```groovy
String JOB_PATTERN      = '<group>/<job>'
final long CURRENT_TIME = System.currentTimeMillis()
final int BENCH_MARK    = 1*24*60*60*1000                    // days * hours * minutes * seconds * microseconds (1000)

Jenkins.instance.getAllItems(Job.class).findAll { Job job ->
  job.fullName.contains(JOB_PATTERN)
}.collect { Job job ->
  def history = job.getBuilds().byTimestamp( CURRENT_TIME - BENCH_MARK, CURRENT_TIME )
  if ( history ) {
    println """
      ${job.fullName} : ${history.size()} :
      history         : ${history}
    """
  }
}
"DONE"
```

### [list job which running for more than 24 hours](https://raw.githubusercontent.com/cloudbees/jenkins-scripts/master/builds-running-more-than-24h.groovy)
```bash
/*
 * We had to write this script several times. Time to have it stored, it is a very simple approach but will serve as starting point for more refined approaches.
 */
Jenkins.instance.getAllItems(Job).each() { job ->
  if ( job.isBuilding() ) {
    def myBuild = job.getLastBuild()
    def runningSince= groovy.time.TimeCategory.minus( new Date(), myBuild.getTime() )
    if ( runningSince.hours >= 24 ) {
      println job.name + "---- ${runningSince.hours} hours:${runningSince.minutes} minutes"
    }
  }
}
return null
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

## List plugins
### [via api](./api.md#list-plugins)
### [simple list](https://stackoverflow.com/a/35292719/2940319)
```groovy
Jenkins.instance.pluginManager.plugins.each { plugin ->
  println ( "${plugin.getDisplayName()} (${plugin.getShortName()}): ${plugin.getVersion()}" )
}
```

### [List plugin and dependencies](https://stackoverflow.com/a/56864983/2940319)
```groovy
println "Jenkins Instance : " + Jenkins.getInstance().getComputer('').getHostName() + " - " + Jenkins.getInstance().getRootUrl()
println "Installed Plugins: "
println "=================="
Jenkins.instance.pluginManager.plugins.sort(false) { a, b -> a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()}.each { plugin ->
    println "${plugin.getShortName()}: ${plugin.getVersion()} | ${plugin.getDisplayName()}"
}

println ""
println "Plugins Dependency tree (...: dependencies; +++: dependants) :"
println "======================="
Jenkins.instance.pluginManager.plugins.sort(false) { a, b -> a.getShortName().toLowerCase() <=> b.getShortName().toLowerCase()}.each { plugin ->
  println "${plugin.getShortName()}: ${plugin.getVersion()} | ${plugin.getDisplayName()} "
  println "+++ ${plugin.getDependants()}"
  println "... ${plugin.getDependencies()}"
  println ''
}
```

## scriptApproval
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
  println prettyPrint( toJson(alreadyApproved) )
  ```

- restore
  ```bash
  def scriptApproval = org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval.get()

  String[] signs = [
    "method org.jenkinsci.plugins.workflow.steps.FlowInterruptedException getCauses",
    "method org.jenkinsci.plugins.workflow.support.steps.input.Rejection getUser"
  ]

  for( String sign : signs ) {
    scriptApproval.approveSignature(sign)
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

  scriptApproval = ScriptApproval.get()
  alreadyApproved = new HashSet<>(Arrays.asList(scriptApproval.getApprovedSignatures()))
  void approveSignature(String signature) {
    if (!alreadyApproved.contains(signature)) {
      scriptApproval.approveSignature(signature)
    }
  }

  List scriptList = [
    'method hudson.model.Job getLastSuccessfulBuild',
    'method hudson.model.Node getNodeName'
  ]

  scriptList.each { approveSignature(it) }
  scriptApproval.save()
  ```

### automatic approval all pending
- [list pending scriptApproval](https://stackoverflow.com/a/55940005/2940319)
  ```groovy
  import org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval

  ScriptApproval scriptApproval = ScriptApproval.get()
  scriptApproval.pendingScripts.each {
    scriptApproval.approveScript(it.hash)
  }
  ```

- [Job DSL support for ScriptApproval](https://issues.jenkins-ci.org/browse/JENKINS-31201?focusedCommentId=285330&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-285330)
  ```groovy
  import jenkins.model.Jenkins

  def scriptApproval = Jenkins.instance.getExtensionList('org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval')[0]
  def hashesToApprove = scriptApproval.pendingScripts.findAll{ it.script.startsWith(approvalPrefix) }.collect{ it.getHash() }
  hashesToApprove.each {
    scriptApproval.approveScript(it)
  }
  ```

### [disable the scriptApproval](https://stackoverflow.com/a/49372857/2940319)
> file: `$JENKINS_HOME/init.groovy.d/disable-script-security.groovy`

```groovy
import javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration
import jenkins.model.GlobalConfiguration

// disable Job DSL script approval
GlobalConfiguration.all().get(GlobalJobDslSecurityConfiguration.class).useScriptSecurity=false
GlobalConfiguration.all().get(GlobalJobDslSecurityConfiguration.class).save()
```

## abort
### [abort a build](https://stackoverflow.com/a/26306081/2940319)
```groovy
Jenkins.instance.getItemByFullName("JobName")
       .getBuildByNumber(JobNumber)
       .finish(
               hudson.model.Result.ABORTED,
               new java.io.IOException("Aborting build")
       )
```

### [abort running builds if new one is running](https://stackoverflow.com/a/44326216/2940319)
> reference:
> - [Controlling the Flow with Stage, Lock, and Milestone](https://www.jenkins.io/blog/2016/10/16/stage-lock-milestone/)
> - [I have a stuck Pipeline and I can not stop it](https://support.cloudbees.com/hc/en-us/articles/360000913392-I-have-a-stuck-Pipeline-and-I-can-not-stop-it)
> - [Aborting a build](https://www.jenkins.io/doc/book/using/aborting-a-build/)
> - [Cancel queued builds and aborting executing builds using Groovy for Jenkins](https://stackoverflow.com/questions/12305244/cancel-queued-builds-and-aborting-executing-builds-using-groovy-for-jenkins)

```groovy
import hudson.model.Result
import jenkins.model.CauseOfInterruption

//iterate through current project runs
build.getProject()._getRuns().iterator().each{ run ->
  def exec = run.getExecutor()
    //if the run is not a current build and it has executor (running) then stop it
    if( run!=build && exec!=null ){
      //prepare the cause of interruption
      def cause = { "interrupted by build #${build.getId()}" as String } as CauseOfInterruption
        exec.interrupt(Result.ABORTED, cause)
    }
}
```
- [or](https://stackoverflow.com/a/49901413/2940319)
  ```groovy
  import hudson.model.Result
  import hudson.model.Run
  import jenkins.model.CauseOfInterruption.UserInterruption

  def abortPreviousBuilds() {
    Run previousBuild = currentBuild.rawBuild.getPreviousBuildInProgress()

    while ( previousBuild != null ) {
      if ( previousBuild.isInProgress() ) {
        def executor = previousBuild.getExecutor()
          if ( executor != null ) {
            echo ">> Aborting older build #${previousBuild.number}"
              executor.interrupt( Result.ABORTED,
                                  new UserInterruption(
                                    "Aborted by newer build #${currentBuild.number}"
                                ))
          }
      }
      previousBuild = previousBuild.getPreviousBuildInProgress()
    }
  }
  ```

- or: [cancel builds same job](https://raw.githubusercontent.com/cloudbees/jenkins scripts/master/cancel builds same job.groovy)
  ```groovy
  /*
   Author: Isaac S Cohen
   This script works with workflow to cancel other running builds for the same job
   Use case: many build may go to QA, but only the build that is accepted is needed,
   the other builds in the workflow should be aborted
  */

  def jobname = env.JOB_NAME
  def buildnum = env.BUILD_NUMBER.toInteger()

  def job = Jenkins.instance.getItemByFullName( jobname )
  for ( build in job.builds ) {
    if ( !build.isBuilding() ) { continue; }
    if ( buildnum == build.getNumber().toInteger() ) { continue; println "equals" }
    build.doStop();
  }
  ```
- or: [Properly Stop Only Running Pipelines](https://raw.githubusercontent.com/cloudbees/jenkins-scripts/master/ProperlyStopOnlyRunningPipelines.groovy)

## [Managing Nodes](https://www.jenkins.io/doc/book/managing/nodes/)
> references:
> - [Display Information About Nodes](https://wiki.jenkins.io/display/JENKINS/Display+Information+About+Nodes)

### [Monitor and Restart Offline Agents](https://www.jenkins.io/doc/book/managing/nodes/)

```groovy
import hudson.node_monitors.*
import hudson.slaves.*
import java.util.concurrent.*

jenkins = Jenkins.instance

import javax.mail.internet.*;
import javax.mail.*
import javax.activation.*


def sendMail (agent, cause) {

  message = agent + " agent is down. Check http://JENKINS_HOSTNAME:JENKINS_PORT/computer/" + agent + "\nBecause " + cause
  subject = agent + " agent is offline"
  toAddress = "JENKINS_ADMIN@YOUR_DOMAIN"
  fromAddress = "JENKINS@YOUR_DOMAIN"
  host = "SMTP_SERVER"
  port = "SMTP_PORT"

  Properties mprops = new Properties();
  mprops.setProperty("mail.transport.protocol","smtp");
  mprops.setProperty("mail.host",host);
  mprops.setProperty("mail.smtp.port",port);

  Session lSession = Session.getDefaultInstance(mprops,null);
  MimeMessage msg = new MimeMessage(lSession);


  //tokenize out the recipients in case they came in as a list
  StringTokenizer tok = new StringTokenizer(toAddress,";");
  ArrayList emailTos = new ArrayList();
  while(tok.hasMoreElements()) {
    emailTos.add(new InternetAddress(tok.nextElement().toString()));
  }
  InternetAddress[] to = new InternetAddress[emailTos.size()];
  to = (InternetAddress[]) emailTos.toArray(to);
  msg.setRecipients(MimeMessage.RecipientType.TO,to);
  InternetAddress fromAddr = new InternetAddress(fromAddress);
  msg.setFrom(fromAddr);
  msg.setFrom(new InternetAddress(fromAddress));
  msg.setSubject(subject);
  msg.setText(message)

  Transport transporter = lSession.getTransport("smtp");
  transporter.connect();
  transporter.send(msg);
}


def getEnviron(computer) {
  def env
  def thread = Thread.start("Getting env from ${computer.name}", { env = computer.environment })
  thread.join(2000)
  if (thread.isAlive()) thread.interrupt()
  env
}

def agentAccessible(computer) {
  getEnviron(computer)?.get('PATH') != null
}

def numberOfflineNodes = 0
def numberNodes = 0
for (agent in jenkins.getNodes()) {
  def computer = agent.computer
  numberNodes ++
  println ""
  println "Checking computer ${computer.name}:"
  def isOK = (agentAccessible(computer) && !computer.offline)
  if (isOK) {
    println "\t\tOK, got PATH back from agent ${computer.name}."
    println('\tcomputer.isOffline: ' + computer.isOffline());
    println('\tcomputer.isTemporarilyOffline: ' + computer.isTemporarilyOffline());
    println('\tcomputer.getOfflineCause: ' + computer.getOfflineCause());
    println('\tcomputer.offline: ' + computer.offline);
  } else {
    numberOfflineNodes ++
    println "  ERROR: can't get PATH from agent ${computer.name}."
    println('\tcomputer.isOffline: ' + computer.isOffline());
    println('\tcomputer.isTemporarilyOffline: ' + computer.isTemporarilyOffline());
    println('\tcomputer.getOfflineCause: ' + computer.getOfflineCause());
    println('\tcomputer.offline: ' + computer.offline);
    sendMail(computer.name, computer.getOfflineCause().toString())
    if (computer.isTemporarilyOffline()) {
      if (!computer.getOfflineCause().toString().contains("Disconnected by")) {
        computer.setTemporarilyOffline(false, agent.getComputer().getOfflineCause())
      }
    } else {
        computer.connect(true)
    }
  }
 }
println ("Number of Offline Nodes: " + numberOfflineNodes)
println ("Number of Nodes: " + numberNodes)
```
