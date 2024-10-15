<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [DSL](#dsl)
  - [How do I access Pipeline DSLs from inside a Groovy class?](#how-do-i-access-pipeline-dsls-from-inside-a-groovy-class)
- [jobs](#jobs)
  - [Create a Permanent Agent from Groovy Console](#create-a-permanent-agent-from-groovy-console)
- [agents](#agents)
  - [Monitor and Restart Offline Agents](#monitor-and-restart-offline-agents)
- [others](#others)
  - [run shell scripts in a cluster-operation](#run-shell-scripts-in-a-cluster-operation)
  - [get all running thread](#get-all-running-thread)
  - [Automate configuring via Jenkins Script Console](#automate-configuring-via-jenkins-script-console)
  - [Jenkins search results missing /ci/ URL component](#jenkins-search-results-missing-ci-url-component)
  - [jenkins server info](#jenkins-server-info)
  - [How to access Junit test counts in Jenkins Pipeline project](#how-to-access-junit-test-counts-in-jenkins-pipeline-project)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


> references:
> - [Jenkins Features Controlled with System Properties ](https://www.jenkins.io/doc/book/managing/system-properties/)

## DSL
### [How do I access Pipeline DSLs from inside a Groovy class?](https://support.cloudbees.com/hc/en-us/articles/217736618-How-do-I-access-Pipeline-DSLs-from-inside-a-Groovy-class-)
```groovy
class C implements Serializable {
 def stuff(steps) {
   steps.node {
     steps.sh 'echo hello'
   }
 }
}
def c = new C()
c.stuff(steps)
```
- or
  ```groovy
  class C implements Serializable {
    def stuff(script) {
      script.node {
        script.echo "running in ${script.env.JENKINS_URL}"
      }
    }
  }
  def c = new C()
  c.stuff(this)
  ```

## jobs
### [Create a Permanent Agent from Groovy Console](https://support.cloudbees.com/hc/en-us/articles/218154667-Create-a-Permanent-Agent-from-Groovy-Console)
```groovy
import hudson.model.*
import jenkins.model.*
import hudson.slaves.*
import hudson.slaves.EnvironmentVariablesNodeProperty.Entry

/**
 * INSERT "Launch Method" SNIPPET HERE
**/
// define a "Permanent Agent"
Slave agent = new DumbSlave (
                              "agent-node",
                              "/home/jenkins",
                              launcher
                            )
agent.nodeDescription   = "Agent node description"
agent.numExecutors      = 1
agent.labelString       = "agent-node-label"
agent.mode              = Node.Mode.NORMAL
agent.retentionStrategy = new RetentionStrategy.Always()

List<Entry> env = new ArrayList<Entry>()
env.add( new Entry('key1','value1') )
env.add( new Entry('key2','value2') )
EnvironmentVariablesNodeProperty envPro = new EnvironmentVariablesNodeProperty(env)

agent.getNodeProperties().add( envPro )

// create a "Permanent Agent"
jenkins.model.Jenkins.instance.addNode( agent )

return "Node has been created successfully."
```
- or:[CloudBees SSH Build Agents plugin 2.0 and newer](https://support.cloudbees.com/hc/en-us/articles/218154667-Create-a-Permanent-Agent-from-Groovy-Console#cloudbeessshbuildagentsplugin20andnewer)
  ```groovy
  import com.cloudbees.jenkins.plugins.sshslaves.verification.*
  import com.cloudbees.jenkins.plugins.sshslaves.SSHConnectionDetails

  // Pick one of the strategies from the comments below this line
  ServerKeyVerificationStrategy serverKeyVerificationStrategy = new TrustInitialConnectionVerificationStrategy(false)
  // = new TrustInitialConnectionVerificationStrategy(false /* "Require manual verification of initial connection" */) // "Manually trusted key verification Strategy"
  // = new ManuallyConnectionVerificationStrategy("<your-key-here>")            // "Manually provided key verification Strategy"
  // = new KnownHostsConnectionVerificationStrategy()                           // "~/.ssh/known_hosts file Verification Strategy"
  // = new BlindTrustConnectionVerificationStrategy()                           // "Non-verifying Verification Strategy"

  // define a "Launch method": "Launch agents via SSH"
  ComputerLauncher launcher = new com.cloudbees.jenkins.plugins.sshslaves.SSHLauncher(
          "host",                                                               // Host
          new SSHConnectionDetails(
                  "credentialsId",                                              // Credentials ID
                  22,                                                           // port
                  (String)null,                                                 // JavaPath
                  (String)null,                                                 // JVM Options
                  (String)null,                                                 // Prefix Start Agent Command
                  (String)null,                                                 // Suffix Start Agent Command
                  (boolean)false,                                               // Log environment on initial connect
                  (ServerKeyVerificationStrategy) serverKeyVerificationStrategy // Host Key Verification Strategy
          )
  )
  ```

## agents
### [Monitor and Restart Offline Agents](https://www.jenkins.io/doc/book/managing/nodes/#monitor-and-restart-offline-agents)
```groovy
import hudson.node_monitors.*
import hudson.slaves.*
import java.util.concurrent.*

jenkins = jenkins.model.Jenkins.instance

import javax.mail.internet.*
import javax.mail.*
import javax.activation.*

def sendMail ( agent, cause ) {
  message     = agent + " agent is down. Check http://JENKINS_HOSTNAME:JENKINS_PORT/computer/" + agent + "\nBecause " + cause
  subject     = agent + " agent is offline"
  toAddress   = "JENKINS_ADMIN@YOUR_DOMAIN"
  fromAddress = "JENKINS@YOUR_DOMAIN"
  host        = "SMTP_SERVER"
  port        = "SMTP_PORT"

  Properties mprops = new Properties()
  mprops.setProperty( "mail.transport.protocol", "smtp" )
  mprops.setProperty( "mail.host", host                 )
  mprops.setProperty( "mail.smtp.port", port            )

  Session lSession = Session.getDefaultInstance(mprops,null)
  MimeMessage msg  = new MimeMessage( lSession )

  //tokenize out the recipients in case they came in as a list
  StringTokenizer tok = new StringTokenizer(toAddress,";")
  ArrayList emailTos  = new ArrayList()
  while( tok.hasMoreElements() ) {
    emailTos.add( new InternetAddress(tok.nextElement().toString()) )
  }
  InternetAddress[] to = new InternetAddress[emailTos.size()]
  to = (InternetAddress[]) emailTos.toArray(to)
  msg.setRecipients(MimeMessage.RecipientType.TO,to)
  InternetAddress fromAddr = new InternetAddress(fromAddress)
  msg.setFrom( fromAddr )
  msg.setFrom( new InternetAddress(fromAddress) )
  msg.setSubject( subject )
  msg.setText( message )

  Transport transporter = lSession.getTransport("smtp")
  transporter.connect()
  transporter.send( msg )
}

def getEnviron( computer ) {
  def env
  def thread = Thread.start( "Getting env from ${computer.name}", { env = computer.environment } )
  thread.join(2000)
  if ( thread.isAlive() ) thread.interrupt()
  env
}

def agentAccessible( computer ) {
  getEnviron(computer)?.get('PATH') != null
}

def numberOfflineNodes = 0
def numberNodes        = 0
for ( agent in jenkins.getNodes() ) {
  def computer = agent.computer
  numberNodes ++
  println "\nChecking computer ${computer.name}:"
  def isOK = ( agentAccessible(computer) && !computer.offline )
  if ( isOK ) {
    println "\t\tOK, got PATH back from slave ${computer.name}."
    println( '\tcomputer.isOffline: '            + slave.getComputer().isOffline()            )
    println( '\tcomputer.isTemporarilyOffline: ' + slave.getComputer().isTemporarilyOffline() )
    println( '\tcomputer.getOfflineCause: '      + slave.getComputer().getOfflineCause()      )
    println( '\tcomputer.offline: '              + computer.offline                           )
  } else {
    numberOfflineNodes ++
    println "  ERROR: can't get PATH from agent ${computer.name}."
    println( '\tcomputer.isOffline: '            + agent.getComputer().isOffline()            )
    println( '\tcomputer.isTemporarilyOffline: ' + agent.getComputer().isTemporarilyOffline() )
    println( '\tcomputer.getOfflineCause: '      + agent.getComputer().getOfflineCause()      )
    println( '\tcomputer.offline: '              + computer.offline                           )
    sendMail( computer.name, agent.getComputer().getOfflineCause().toString() )
    if ( agent.getComputer().isTemporarilyOffline() ) {
      if ( ! agent.getComputer().getOfflineCause().toString().contains("Disconnected by") ) {
        computer.setTemporarilyOffline( false, agent.getComputer().getOfflineCause() )
      }
    } else {
      computer.connect( true )
    }
  }
}
println ( "Number of Offline Nodes: " + numberOfflineNodes )
println ( "Number of Nodes: "         + numberNodes        )
```

## others

> [!NOTE|label:references:]
> - scripts:
>   - [jira-publisher.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/jira-publisher.groovy)

### [run shell scripts in a cluster-operation](https://support.cloudbees.com/hc/en-us/articles/360020737392-How-to-run-shell-scripts-in-a-cluster-operation)
```groovy
def exec(cmd) {
  println cmd
  def process = new ProcessBuilder([ "sh", "-c", cmd])
                      .directory(new File("/tmp"))
                      .redirectErrorStream(true)
                      .start()
  process.outputStream.close()
  process.inputStream.eachLine { println it }
  process.waitFor()
  return process.exitValue()
}

[
  "echo hello world",
  "ls -al"
].each { exec(it) }
```

### get all running thread
```groovy
Thread.getAllStackTraces().keySet().each() {
  println it.getName()
}
```

- [kill running thread](https://stackoverflow.com/a/26306081/2940319)

  > [!TIP]
  > or using `t.stop()` instead of `t.interrupt()`

  ```groovy
  Thread.getAllStackTraces().keySet().each() { t ->
    if ( t.getName()=="YOUR THREAD NAME" ) { t.interrupt(); }
  }
  ```

### [Automate configuring via Jenkins Script Console](https://jenkinsci.github.io/jira-steps-plugin/getting-started/config/script/)
```groovy
import net.sf.json.JSONArray
import net.sf.json.JSONObject
import org.thoughtslive.jenkins.plugins.jira.JiraStepsConfig
import org.thoughtslive.jenkins.plugins.jira.Site

//global user-defined configuration
JSONArray sitesConf = [
  [
    name        : 'another'            ,
    url         : 'http://example.com' ,
    timeout     : 10000                ,
    readTimeout : 10000                ,
    loginType   : 'BASIC'              ,
    userName    : 'foo'                ,
    password    : 'some pass'
  ],
  [
    name        : 'moar jira'          ,
    url         : 'http://example.com' ,
    timeout     : 10000                ,
    readTimeout : 10000                ,
    loginType   : 'OAUTH'              ,
    consumerKey : 'my consumer key'    ,
    privateKey  : 'my private key'     ,
    secret      : 'super secret'       ,
    token       : 'my token'
  ]
] as JSONArray

// get global Jenkins configuration
JiraStepsConfig.ConfigDescriptorImpl config = jenkins.model.Jenkins.instance.getExtensionList(JiraStepsConfig.ConfigDescriptorImpl.class)[0]

ArrayList<Site> sites = new ArrayList<Site>()

// configure new sites from the above JSONArray
sitesConf.each { s ->
  String loginType = s.optString('loginType', '').toUpperCase()
  if( loginType in ['BASIC', 'OAUTH'] ) {
    Site site = new Site(s.optString('name',''), new URL(s.optString('url', '')), s.optString('loginType', ''), s.optInt('timeout', 10000))

    if( loginType == 'BASIC' ) {
      site.setUserName( s.optString('userName', '') )
      site.setPassword( s.optString('password', '') )
      site.setReadTimeout( s.optInt('readTimeout', 10000) )
    } else { //loginType is OAUTH
      site.setConsumerKey( s.optString('consumerKey', '') )
      site.setPrivateKey( s.optString('privateKey', '') )
      site.setSecret( s.optString('secret', '') )
      site.setToken( s.optString('token', '') )
      site.setReadTimeout( s.optInt('readTimeout', 10000) )
    }

    sites.add(site)
  }
}

//set our defined sites
config.setSites(sites.toArray(new Site[0]))

//persist configuration to disk as XML
config.save()
```

- or [via Configuration as Code plugin](https://jenkinsci.github.io/jira-steps-plugin/getting-started/config/casc/)
  ```yaml
  unclassified:
    jiraStepsConfig:
      sites:
      - name: 'another'
        url: 'http://example.com'
        timeout: 10000
        readTimeout: 10000
        loginType: 'BASIC'
        userName: 'foo'
        password: 'some pass'
      - name: 'moar jira'
        url: 'http://example.com'
        timeout: 10000
        readTimeout: 10000
        loginType: 'OAUTH'
        consumerKey: 'my consumer key'
        privateKey: 'my private key'
        secret: 'super secret'
        token: 'my token'
  ```

- [install plugin](https://gist.github.com/whittlec/6112643)
  ```groovy
  [
    "ant",
    "artifactdeployer",
    "build-failure-analyzer",
    "build-name-setter",
    "build-pipeline-plugin",
    "build-timeout",
    "claim",
    "clone-workspace-scm",
    "cobertura",
    "collapsing-console-sections",
    "conditional-buildstep",
    "configurationslicing",
    "copy-to-slave",
    "credentials",
    "cvs",
    "disk-usage",
    "ec2",
    "email-ext",
    "external-monitor-job",
    "git",
    "git-client",
    "global-build-stats",
    "gravatar",
    "groovy-postbuild",
    "javadoc",
    "jobConfigHistory",
    "ldap",
    "mailer",
    "mask-passwords",
    "maven-plugin",
    "openid",
    "pam-auth",
    "parameterized-trigger",
    "run-condition",
    "shelve-project-plugin",
    "ssh-credentials",
    "ssh-slaves",
    "subversion",
    "svn-release-mgr",
    "token-macro",
    "translation",
    "view-job-filters",
    "ws-cleanup"
  ].each { plugin ->
    e = Hudson.instance.updateCenter.getPlugin(plugin).deploy().get().getError()
    if ( e != null )
      println e.message
  }
  ```
  - [or](https://stackoverflow.com/a/59057166/2940319)
    ```bash
    import jenkins.model.*
    import java.util.logging.Logger

    def logger      = Logger.getLogger("")
    def installed   = false
    def initialized = false

    def pluginParameter = "gitlab-plugin hipchat swarm"
    def plugins = pluginParameter.split()
    logger.info( "" + plugins )
    def instance = jenkins.model.Jenkins.instance
    def pm       = instance.getPluginManager()
    def uc       = instance.getUpdateCenter()
    uc.updateAllSites()

    plugins.each {
      logger.info( "Checking " + it )
      if ( !pm.getPlugin(it) ) {
        logger.info( "Looking UpdateCenter for " + it )
        if ( !initialized ) {
          uc.updateAllSites()
          initialized = true
        }
        def plugin = uc.getPlugin(it)
        if ( plugin ) {
          logger.info( "Installing " + it )
          plugin.deploy()
          installed = true
        }
      }
    }

    if ( installed ) {
      logger.info( "Plugins installed, initializing a restart!" )
      instance.save()
      instance.doSafeRestart()
    }
    ```

### [Jenkins search results missing /ci/ URL component](https://phabricator.wikimedia.org/T294424#8028735)
```groovy
new File(System.getProperty("user.home"),'.nestedViewsSearch').createNewFile()
```

### [jenkins server info](https://www.jenkins.io/participate/report-issue/#what-information-to-provide-for-environment-and-description)
```groovy
println( "Groovy: ${GroovySystem.version}" )
println( "Jenkins: ${jenkins.model.Jenkins.instance.getVersion()}" )
println( "OS: ${System.getProperty('os.name')} - ${System.getProperty('os.version')}" )
println( "Java: ${System.getProperty('java.version')} - ${System.getProperty('java.vm.vendor')} (${System.getProperty('java.vm.name')})" )
```

### [How to access Junit test counts in Jenkins Pipeline project](https://stackoverflow.com/a/39958212/2940319)

> [!NOTE|label:references:]
> - [Using pipeline & groovy, How can I extract test results from Jenkins for my current build?](https://stackoverflow.com/a/39644201/2940319)

```groovy
import hudson.tasks.test.AbstractTestResultAction

@NonCPS
def testStatuses() {
  def testStatus = ""
  AbstractTestResultAction testResultAction = currentBuild.rawBuild.getAction(AbstractTestResultAction.class)
  if ( testResultAction != null ) {
    def total   = testResultAction.totalCount
    def failed  = testResultAction.failCount
    def skipped = testResultAction.skipCount
    def passed  = total - failed - skipped
    testStatus  = "Test Status:\n  Passed: ${passed}, Failed: ${failed} ${testResultAction.failureDiffString}, Skipped: ${skipped}"

    if ( failed == 0 ) {
      currentBuild.result = 'SUCCESS'
    }
  }
  return testStatus
}
```
