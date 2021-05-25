<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get information](#get-information)
  - [get ip address of node](#get-ip-address-of-node)
  - [get agent environment variable](#get-agent-environment-variable)
  - [get a list of all Jenkins nodes assigned with label](#get-a-list-of-all-jenkins-nodes-assigned-with-label)
- [Managing Nodes](#managing-nodes)
  - [Monitor and Restart Offline Agents](#monitor-and-restart-offline-agents)
  - [Create a Permanent Agent from Groovy Console](#create-a-permanent-agent-from-groovy-console)
  - [update agent label](#update-agent-label)
  - [jenkins-scripts/scriptler/disableSlaveNodeStartsWith.groovy](#jenkins-scriptsscriptlerdisableslavenodestartswithgroovy)
  - [disable agent](#disable-agent)
  - [disconnect agent](#disconnect-agent)
  - [offline agent](#offline-agent)
  - [delete agent](#delete-agent)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## get information
> API:
> - [hudson.model.Computer](https://javadoc.jenkins-ci.org/hudson/model/Computer.html)
> - [hudson.model.Node](https://javadoc.jenkins-ci.org/hudson/model/Node.html)
> - [hudson.model.Slave](https://javadoc.jenkins.io/hudson/model/Slave.html)
> - [hudson.slaves.DumbSlave](https://javadoc.jenkins.io/hudson/slaves/DumbSlave.html)
>
> references:
> - [Display Information About Nodes](https://wiki.jenkins.io/display/JENKINS/Display+Information+About+Nodes)
> - [jenkins-scripts/scriptler/showAgentJavaVersion.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/showAgentJavaVersion.groovy)
> - [jenkins-scripts/scriptler/checkNodesLauncherVersion.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/checkNodesLauncherVersion.groovy)
> - [Skip Jenkins Pipeline Steps If Node Is Offline](https://stackoverflow.com/a/43065873/2940319)
>
> sample scripts:
> - [jenkins-scripts/scriptler/findOfflineSlaves.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/findOfflineSlaves.groovy)
> - [jenkins-scripts/scriptler/showAgentJavaVersion.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/showAgentJavaVersion.groovy)
> - [jenkins-scripts/scriptler/checkNodesLauncherVersion.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/checkNodesLauncherVersion.groovy)

{% hint 'info' %}
> - `hudson.model.Computer` -> `hudson.model.Node` via [`computer.setNode()`](https://javadoc.jenkins-ci.org/hudson/model/Computer.html#setNode-hudson.model.Node-)
> - `hudson.model.Node` -> `hudson.model.Computer` via [`node.toComputer()`](https://javadoc.jenkins-ci.org/hudson/model/Node.html#toComputer--)
{% endhint %}

#### example for `Computer` Object
- get description
  ```groovy
  Jenkins.instance.getNode('<agent-name>').toComputer().description
  ```

- get all info
  ```groovy
  String agentName = 'marslo-test'
  Jenkins.instance.computers.findAll { computer ->
    agentName == computer.name
  }.each { computer ->
    String moreinfo = computer.online
                        ? "properties : ${computer.getSystemProperties().collect { k, v -> "$k=$v" }.join('\n\t\t\t>>> ')}"
                        : "      logs : ${computer.getLog()}"
    println """
      ~~> ${computer.displayName} :
                      class : ${computer.getClass()}
                      class : ${computer.class.superclass?.simpleName}
                    online? : ${computer.online}
                description : ${computer.description}
                connectTime : ${computer.connectTime}
         offlineCauseReason : ${computer.offlineCauseReason}
                   executor : ${computer.numExecutors}
                 ${moreinfo}
    """
  }
  ```
  - result
   ```groovy
        ~~> marslo-test :
                        class : class hudson.slaves.SlaveComputer
                        class : Computer
                      online? : false
                  description : marslo test agent offline
                  connectTime : 1620478291102
           offlineCauseReason : This agent is offline because Jenkins failed to launch the agent process on it.
                     executor : 1
                         logs : SSHLauncher{host='1.2.3.4', port=22, credentialsId='DevOpsSSHCredential', jvmOptions='', javaPath='', prefixStartSlaveCmd='', suffixStartSlaveCmd='', launchTimeoutSeconds=30, maxNumRetries=5, retryWaitTime=30, sshHostKeyVerificationStrategy=hudson.plugins.sshslaves.verifiers.NonVerifyingKeyVerificationStrategy, tcpNoDelay=true, trackCredentials=true}
    [05/08/21 05:51:31] [SSH] Opening SSH connection to 1.2.3.4:22.
    connect timed out
    SSH Connection failed with IOException: "connect timed out", retrying in 30 seconds. There are 5 more retries left.
    connect timed out
        ...
   ```

#### example for `Node` Object
```groovy
import hudson.slaves.*
DumbSlave agent = jenkins.model.Jenkins.instance.getNode( 'marslo-test' )
println """
     display name : ${agent.getDisplayName()}
        node name : ${agent.getNodeName()}
      description : ${agent.getNodeDescription()}
         executor : ${agent.getNumExecutors()}
     label string : ${agent.getLabelString()}
        node mode : ${agent.getMode()}
  hold off launch : ${agent.isHoldOffLaunchUntilSave()}
"""
```
- result
  ```
     display name : marslo-test
        node name : marslo-test
      description : marslo test agent offline
         executor : 1
     label string :
        node mode : NORMAL
  hold off launch : true
  ```

{% hint style='tip' %}
> setup `hold off launch` via: `agent.holdOffLaunchUntilSave = true`
{% endhint %}

- `node` -> `computer`
  ```groovy
  String agent = 'marslo-test'
  Jenkins.instance.getNode(agent).toComputer().isOnline()
  ```
  or
  ```groovy
  hudson.model.Hudson.instance.getNode(agent).toComputer().isOnline()
  ```
  or get log
  ```groovy
  println jenkins.model.Jenkins.instance.getNode( 'marslo-test' ).toComputer().getLog()

  // result
  SSHLauncher{host='1.2.3.4', port=22, credentialsId='DevOpsSSHCredential', jvmOptions='', javaPath='', prefixStartSlaveCmd='', suffixStartSlaveCmd='', launchTimeoutSeconds=30, maxNumRetries=5, retryWaitTime=30, sshHostKeyVerificationStrategy=hudson.plugins.sshslaves.verifiers.NonVerifyingKeyVerificationStrategy, tcpNoDelay=true, trackCredentials=true}
  [05/24/21 03:59:16] [SSH] Opening SSH connection to 1.2.3.4:22.
  connect timed out
  SSH Connection failed with IOException: "connect timed out", retrying in 30 seconds. There are 5 more retries left.
  ```

### [get ip address of node](https://stackoverflow.com/a/39752509/2940319)
```groovy
import hudson.model.Computer.ListPossibleNames
println jenkins.model
               .Jenkins.instance
               .getNode( '<agent_name>' ).computer
               .getChannel().call(new ListPossibleNames())
```

or
```groovy
println jenkins.model
               .Jenkins.instance
               .getNode( '<agent_name>' ).computer
               .getHostName()
```

[or](https://stackoverflow.com/a/14930330/2940319)
```groovy
println InetAddress.localHost.hostAddress
```

### [get agent environment variable](https://stackoverflow.com/a/28076291/2940319)
```groovy
for (slave in jenkins.model.Jenkins.instance.slaves) {
  println(slave.name + ": ")
  def props = slave.nodeProperties.getAll(hudson.slaves.EnvironmentVariablesNodeProperty.class)
  for (prop in props) {
    for (envvar in prop.envVars) {
      println envvar.key + " -> " + envvar.value
    }
  }
}
```

### [get a list of all Jenkins nodes assigned with label](https://stackoverflow.com/a/64106569/2940319)
```groovy
def nodes = jenkins.model.Jenkins.get().computers
                   .findAll{ it.node.labelString.contains(label) }
                   .collect{ it.node.selfLabel.name }
```

- [or](https://stackoverflow.com/a/49625621/2940319)
  ```groovy
  @NonCPS
  def hostNames(label) {
    def nodes = []
    jenkins.model.Jenkins.get.computers.each { c ->
      if (c.node.labelString.contains(label)) {
        nodes.add(c.node.selfLabel.name)
      }
    }
    return nodes
  }
  ```
- [or](https://stackoverflow.com/a/53429175/2940319)
  ```groovy
  Jenkins.instance.getLabel('my-label').getNodes().collect{ it.getNodeName() }
  ```

## [Managing Nodes](https://www.jenkins.io/doc/book/managing/nodes/)
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

### [Create a Permanent Agent from Groovy Console](https://support.cloudbees.com/hc/en-us/articles/218154667-Create-a-Permanent-Agent-from-Groovy-Console?mobile_site=false)
{% hint style='tip' %}
> api:
> - [hudson.plugins.sshslaves.SSHLauncher](https://javadoc.jenkins.io/plugin/ssh-slaves/hudson/plugins/sshslaves/SSHLauncher.html)
> - [hudson.plugins.sshslaves.verifiers.SshHostKeyVerificationStrategy](https://javadoc.jenkins.io/plugin/ssh-slaves/hudson/plugins/sshslaves/verifiers/SshHostKeyVerificationStrategy.html)
> - [hudson.slaves.DumbSlave](https://javadoc.jenkins-ci.org/hudson/slaves/DumbSlave.html)
> - [hudson.slaves.ComputerLauncher](https://javadoc.jenkins-ci.org/hudson/slaves/ComputerLauncher.html)
>
{% endhint %}

> references:
> - [jenkins-scripts/createAgentsScript.groovy](https://github.com/cloudbees/jenkins-scripts/blob/master/createAgentsScript.groovy)
> - [GroovyJenkins/src/main/groovy/AddNodeToJenkins.groovy](https://github.com/MovingBlocks/GroovyJenkins/blob/master/src/main/groovy/AddNodeToJenkins.groovy)

{% hint style='tip' %}
> useful libs:
> - `import jenkins.model.*`
> - `import hudson.slaves.*`
> - `import hudson.slaves.NodePropertyDescriptor`
> - `import hudson.plugins.sshslaves.*`
> - `import hudson.plugins.sshslaves.verifiers.*`
> - `import hudson.model.*`
> - `import hudson.model.Node`
> - `import hudson.model.Queue`
> - `import hudson.model.queue.CauseOfBlockage`
> - `import hudson.slaves.EnvironmentVariablesNodeProperty.Entry`
> - `import java.util.ArrayList`
> - `import com.synopsys.arc.jenkinsci.plugins.jobrestrictions.nodes.JobRestrictionProperty`
> - `import com.synopsys.arc.jenkinsci.plugins.jobrestrictions.Messages`
> - `import com.synopsys.arc.jenkinsci.plugins.jobrestrictions.restrictions.JobRestriction`
> - `import com.synopsys.arc.jenkinsci.plugins.jobrestrictions.restrictions.JobRestrictionBlockageCause`
> - `import hudson.Extension`
> - `import hudson.slaves.NodeProperty`
> - `import org.kohsuke.stapler.DataBoundConstructor`
>
> - SSH host verification strategy:
>
> ```groovy
> // Known hosts file Verification Strategy
> new KnownHostsFileKeyVerificationStrategy()
> // Manually provided key Verification Strategy
> new ManuallyProvidedKeyVerificationStrategy("<your-key-here>")
> // Manually trusted key Verification Strategy
> new ManuallyTrustedKeyVerificationStrategy(false /*requires initial manual trust*/)
> // Non verifying Verification Strategy
> new NonVerifyingKeyVerificationStrategy()
> ```
{% endhint %}

```groovy
import hudson.model.*
import jenkins.model.*
import hudson.slaves.*
import hudson.slaves.EnvironmentVariablesNodeProperty.Entry
import hudson.plugins.sshslaves.verifiers.*

// Pick one of the strategies from the comments below this line
// SshHostKeyVerificationStrategy hostKeyVerificationStrategy = new KnownHostsFileKeyVerificationStrategy()
    //= new KnownHostsFileKeyVerificationStrategy() // Known hosts file Verification Strategy
    //= new ManuallyProvidedKeyVerificationStrategy("<your-key-here>") // Manually provided key Verification Strategy
    //= new ManuallyTrustedKeyVerificationStrategy(false /*requires initial manual trust*/) // Manually trusted key Verification Strategy
    //= new NonVerifyingKeyVerificationStrategy() // Non verifying Verification Strategy

// Define a "Launch method": "Launch agents via SSH"
ComputerLauncher launcher = new hudson.plugins.sshslaves.SSHLauncher(
        "1.2.3.4",                                 // Host
        22,                                        // Port
        "MyCredentials",                           // Credentials
        (String)null,                              // JVM Options
        (String)null,                              // JavaPath
        (String)null,                              // Prefix Start Agent Command
        (String)null,                              // Suffix Start Agent Command
        (Integer)null,                             // Connection Timeout in Seconds
        (Integer)null,                             // Maximum Number of Retries
        (Integer)null,                             // The number of seconds to wait between retries
        new NonVerifyingKeyVerificationStrategy()  // Host Key Verification Strategy
)

// Define a "Permanent Agent"
Slave agent = new DumbSlave(
        "marslo-test",
        "/home/devops",
        launcher)
agent.nodeDescription = "marslo test agent"
agent.numExecutors = 1
agent.labelString = ""
agent.mode = Node.Mode.NORMAL
agent.retentionStrategy = new RetentionStrategy.Always()

List<Entry> env = new ArrayList<Entry>();
env.add(new Entry("key1","value1"))
env.add(new Entry("key2","value2"))
EnvironmentVariablesNodeProperty envPro = new EnvironmentVariablesNodeProperty(env);

agent.getNodeProperties().add(envPro)

// Create a "Permanent Agent"
Jenkins.instance.addNode(agent)

return "Node has been created successfully."
```

- [or](https://groups.google.com/g/jenkinsci-users/c/JmVNQm47l8g)
  ```groovy
  import hudson.model.*
  import jenkins.model.*
  import hudson.slaves.*
  import hudson.plugins.sshslaves.verifiers.*
  import hudson.slaves.EnvironmentVariablesNodeProperty.Entry

  String name        = 'marslo-test'
  String description = 'marslo test agent'
  String rootDir     = '/home/marslo'
  String nodeLabel   = ''
  String ip          = '1.2.3.4'
  String credential  = 'MyCredential'
  Map envVars        = [
    'key1' : 'value1',
    'key2' : 'value2'
  ]
  SshHostKeyVerificationStrategy hostKeyVerificationStrategy = new NonVerifyingKeyVerificationStrategy()

  List<Entry> env = new ArrayList<Entry>();
  envVars.each { k, v -> env.add(new Entry(k, v)) }
  EnvironmentVariablesNodeProperty envPro = new EnvironmentVariablesNodeProperty(env);

  Slave agent = new DumbSlave(
    name,
    description,
    rootDir,
    "1",
    Node.Mode.NORMAL,
    nodeLabel,
    new hudson.plugins.sshslaves.SSHLauncher(
      ip,                          // Host
      22,                          // Port
      credential,                  // Credentials
      (String)null,                // JVM Options
      (String)null,                // JavaPath
      (String)null,                // Prefix Start Agent Command
      (String)null,                // Suffix Start Agent Command
      (Integer)null,               // Connection Timeout in Seconds
      (Integer)null,               // Maximum Number of Retries
      (Integer)null,               // The number of seconds to wait between retries
      hostKeyVerificationStrategy  // Host Key Verification Strategy
    ) ,
    new RetentionStrategy.Always(),
    new LinkedList()
  )

  agent.getNodeProperties().add(envPro)
  Jenkins.instance.addNode(agent)
  ```

### update agent label
> references:
> - [Groovy script for modifying Jenkins nodes labels](https://stackoverflow.com/questions/62148298/groovy-script-for-modifying-jenkins-nodes-labels)

- get label
  ```groovy
  def getLabel( String label ){
    for ( node in jenkins.model.Jenkins.instance.nodes ) {
      if ( node.getNodeName().toString().equals(label) ) {
        return node.getLabelString()
      }
    }
  }
  ```
  or
  ```groovy
  def getLabel( String label ){
    jenkins.model.Jenkins.instance.nodes.find { it.getNodeName().toString().equals(label) }.getLabelString()
  }
  ```

- update label
  ```groovy
  def updateLabel( String agent, String label ) {
    def node = jenkins.model.Jenkins.instance.getNode( agent )
    if ( node ) {
      node.setLabelString(label)
      node.save()
    }
  }
  ```

### [jenkins-scripts/scriptler/disableSlaveNodeStartsWith.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/disableSlaveNodeStartsWith.groovy)

### disable agent
> references:
> - [cloudbees/jenkins-scripts/disableAgents.groovy](https://github.com/cloudbees/jenkins-scripts/blob/master/disableAgents.groovy)

### disconnect agent
{% hint style='tip' %}
> reconnect:
> - `agent.computer.connect( true  )`
> - `jenkins.model.Jenkins.instance.getNode( name ).computer.connect( true )`
>
> reference:
> - [awslabs/ec2-spot-jenkins-plugin](https://github.com/awslabs/ec2-spot-jenkins-plugin/blob/master/src/test/java/com/amazon/jenkins/ec2fleet/AutoResubmitIntegrationTest.java#L101) | [or](https://www.programcreek.com/java-api-examples/?api=hudson.slaves.OfflineCause)
{% endhint %}

```groovy
import hudson.slaves.*

String name = 'marslo-test'
String cause = "disconnet the agent automatically via ${env.BUILD_URL}"

DumbSlave agent = jenkins.model.Jenkins.instance.getNode( name )

if ( agent
     &&
     ! ['AbstractCloudComputer', 'AbstractCloudSlave'].contains(agent.computer?.class.superclass?.simpleName)
     &&
     ! (agent.computer instanceof jenkins.model.Jenkins.MasterComputer)
   ) {
    Boolean online = agent.computer.isOnline()
    Boolean busy = agent.computer.countBusy() != 0
    if( online && !busy ) {
      agent.computer.disconnect( new OfflineCause.ChannelTermination(new UnsupportedOperationException(cause)) )
    }
}
```


### offline agent
{% hint style='tip' %}
> offline agent is normally for workspace cleanup
>
> reference:
> - [codecentric/jenkins-scripts](https://github.com/codecentric/jenkins-scripts/blob/master/src/main/groovy/CleanupSlaveWorkspaces.groovy)
> - [Display Information About Nodes](https://wiki.jenkins.io/display/jenkins/display+information+about+nodes)
>
> bring node online
> `computer.setTemporarilyOffline( false, null )`
{% endhint %}

```groovy
import hudson.slaves.*

String name = 'marslo-test'
String cause = "temporary offline for the agent workspace cleanup"

DumbSlave agent = jenkins.model.Jenkins.instance.getNode( name )

if ( agent
     &&
     ! ['AbstractCloudComputer', 'AbstractCloudSlave'].contains(agent.computer?.class.superclass?.simpleName)
     &&
     ! (agent.computer instanceof jenkins.model.Jenkins.MasterComputer)
   ) {
    Boolean online = agent.computer.isOnline()
    Boolean busy = agent.computer.countBusy() != 0

    if( online && !busy ) {
      agent.computer.setTemporarilyOffline( true,
                                            new hudson.slaves.OfflineCause.ByCLI("disk cleanup on slave")
                                          )
    }
}
```

### delete agent
> references:
> - [cloudbees/jenkins-scripts/deleteAgents.groovy](https://github.com/cloudbees/jenkins-scripts/blob/master/deleteAgents.groovy)
