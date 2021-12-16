<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Mailing format](#mailing-format)
- [Properties in Jenkins Core for `JAVA_OPTS`](#properties-in-jenkins-core-for-java_opts)
- [System Properties](#system-properties)
- [Configuring HTTP](#configuring-http)
- [Upgrading Jenkins](#upgrading-jenkins)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Mailing format
- Show the logs after building
  - Format:
    ```
    ${BUILD_LOG, maxLines, escapeHtml}
    maxLines: 250
    ```
  - For example:
    ```
    ${BUILD_LOG, maxLines=8000, escapeHtml=true}
    ```

### [Properties in Jenkins Core for `JAVA_OPTS`](https://www.jenkins.io/doc/book/managing/system-properties/#properties-in-jenkins-core)


#### disable the 
```xml
<useSecurity>true</useSecurity>
<authorizationStrategy class="hudson.security.AuthorizationStrategy$Unsecured"/>
<securityRealm class="hudson.security.SecurityRealm$None"/>
```

#### [Disabling CSRF Protection](https://www.jenkins.io/doc/book/security/csrf-protection/)
> reference:
> - [CSRF Protection](https://www.jenkins.io/doc/book/security/csrf-protection/)

```bash
-Dhudson.security.csrf.GlobalCrumbIssuerConfiguration.DISABLE_CSRF_PROTECTION=true
```

#### [CSRF protection tokens did not expire](https://www.jenkins.io/security/advisory/2019-07-17/#SECURITY-626)
> [SECURITY-626](https://www.jenkins.io/doc/upgrade-guide/2.176/#upgrading-to-jenkins-lts-2-176-3) :
> <p></p>
> Scripts that obtain a crumb using the `/crumbIssuer/api` URL will now fail to perform actions protected from CSRF unless the scripts retain the web session ID in subsequent requests.

```bash
-Dhudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID=true
```

#### [enable crumb proxy compatibility](https://issues.jenkins.io/browse/JENKINS-50767)
```bash
-Djenkins.model.Jenkins.crumbIssuerProxyCompatibility=true
```

#### [change workspace name](https://www.jenkins.io/doc/book/managing/system-properties/#jenkins-model-jenkins-workspacedirname)
```bash
# default
-Djenkins.model.Jenkins.workspaceDirName='workspace'
```

#### [workspace path](https://www.jenkins.io/doc/book/managing/system-properties/#jenkins-model-jenkins-workspacesdir)
```bash
# default
-Djenkins.model.Jenkins.workspacesDir="${JENKINS_HOME}/workspace/${ITEM_FULL_NAME}"
```

#### [a cache for UserDetails should be valid](https://issues.jenkins.io/browse/JENKINS-35493)
```bash
# default 2 mins
-Djenkins.security.UserDetailsCache.EXPIRE_AFTER_WRITE_SEC=120
```

#### [copyArtifacts v1.29 : JENKINS-14999 : Support for QueueItemAuthenticator](https://github.com/jenkinsci/copyartifact-plugin/pull/26/files)
```bash
-Dhudson.security.ArtifactsPermission=true
```

#### [Unauthorized view fragment access](https://www.jenkins.io/security/advisory/2019-07-17/#SECURITY-534)
```bash
# to disable the feature
-Djenkins.security.stapler.StaplerDispatchValidator.disabled=false
```

### [System Properties](https://www.jenkins.io/doc/book/managing/system-properties/)
> - [java.lang.System](https://docs.oracle.com/javase/8/docs/api/java/lang/System.html?is-external=true#getProperty-java.lang.String-)
> - [java.util.Properties](https://docs.oracle.com/javase/8/docs/api/java/util/Properties.html)
> - [jenkins.util.SystemProperties](https://javadoc.jenkins.io/jenkins/util/SystemProperties.html)
> - [Controlling features of Hudson using system properties](https://wiki.eclipse.org/Using_Hudson/Features_controlled_by_system_properties)

#### set property
```groovy
System.setProperty('org.apache.commons.jelly.tags.fmt.timeZone', 'Asia/Shanghai')
System.setProperty('user.timezone', 'Asia/Shanghai')
```
- setup `user.timezone` in Jenkins
  ```groovy
  println( System.getProperty('user.timezone') );
  System.setProperty('user.timezone', 'Asia/Shanghai');
  println( System.getProperty('user.timezone') )
  ```

- enable crumb proxy compatibility
  ```groovy
  System.setProperty('jenkins.model.Jenkins.crumbIssuerProxyCompatibility', 'true')
  System.getProperty('jenkins.model.Jenkins.crumbIssuerProxyCompatibility')
  ```

- setup CSRF protection tokens did not expire for [SECURITY-626](https://www.jenkins.io/doc/upgrade-guide/2.176/#upgrading-to-jenkins-lts-2-176-3)
  ```groovy
  System.setProperty('hudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID', 'true')
  System.getProperty('hudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID')
  ```

#### get property
- get all properties
  ```groovy
  System.getProperties()
  ```

- or
  ```groovy
  System.getProperties().each { k, v ->
    println " >>> ${k} ~> ${v} "
  }
  ```

{% hint style='tip' %}
**get system environment** :
- `System.getenv()`
  ```groovy
  System.getenv().each { k, v ->
    println " >>> ${k} ~> ${v} "
  }
  ```
<p></p>
i.e.:
```groovy
System.getenv().JAVA_OPTS
```
{% endhint %}

### [Configuring HTTP](https://www.jenkins.io/doc/book/installing/initial-settings/#configuring-http)

#### [remote configuration](https://github.com/jenkinsci/remoting/blob/master/docs/configuration.md)
> information:
> - `${PROTOCOL_FULLY_QUALIFIED_NAME}.disabled`: <br>where `PROTOCOL_FULLY_QUALIFIED_NAME` equals `PROTOCOL_HANDLER_CLASSNAME` without the Handler suffix.
> <p></p>
> - description
>   - `hudson.remoting.FlightRecorderInputStream.BUFFER_SIZE` :<br> Size (in bytes) of the flight recorder ring buffer used for debugging remoting issues
>   - `hudson.remoting.Launcher.pingIntervalSec` :<br> Seconds between ping checks to monitor health of agent nodes; 0 to disable ping                                                                                                                 |
>   - `hudson.remoting.Launcher.pingTimeoutSec` :<br> If ping of agent node takes longer than this, consider it dead; 0 to disable ping                                                                                                               |
>   - `hudson.remoting.RemoteClassLoader.force` :<br> Class name String. Forces loading of the specified class name on incoming requests. Works around issues like JENKINS-19445                                                                      |
>   - `hudson.remoting.Engine.socketTimeout` :<br> Socket read timeout in milliseconds. If timeout happens and the failOnSocketTimeoutInReader property is true, the channel will be interrupted.                                                  |
>   - `hudson.remoting.SynchronousCommandTransport.failOnSocketTimeoutInReader` :<br> Boolean flag. Enables the original aggressive behavior, when the channel reader gets interrupted by any SocketTimeoutException                                                                  |
>   - `hudson.remoting.ExportTable.unexportLogSize` :<br> Defines number of entries to be stored in the unexport history, which is being analyzed during the invalid object ID analysis.                                                                  |
>   - `${PROTOCOL_FULLY_QUALIFIED_NAME}.disabled` :<br> Boolean flag, which allows disabling particular protocols in remoting.<br> Property example:<br> org.jenkinsci.remoting.engine.JnlpProtocol3.disabled                                               |
>   - `org.jenkinsci.remoting.nio.NioChannelHub.disabled` :<br> Boolean flag to disable NIO-based socket connection handling, and switch back to classic IO. Used to isolate the problem.                                                                       |
>   - `org.jenkinsci.remoting.engine.JnlpAgentEndpointResolver.protocolNamesToTry` :<br> If specified, only the protocols from the list will be tried during the connection. The option provides protocol names, but the order of the check is defined internally and cannot be changed. |


| System property                                                              | Default value            | Since  | Jenkins version(s) | Related issues             |
|:-----------------------------------------------------------------------------|--------------------------|--------|--------------------|----------------------------|
| `hudson.remoting.FlightRecorderInputStream.BUFFER_SIZE`                      | 1048576                  | 2.41   | 1.563              | JENKINS-22734              |
| `hudson.remoting.Launcher.pingIntervalSec`                                   | 0 since 2.60, 600 before | 2.0    | 1.367              | JENKINS-35190              |
| `hudson.remoting.Launcher.pingTimeoutSec`                                    | 240                      | 2.0    | 1.367              | N/A                        |
| `hudson.remoting.RemoteClassLoader.force`                                    | null                     | 2.58   | 2.4                | JENKINS-19445 (workaround) |
| `hudson.remoting.Engine.socketTimeout`                                       | 30 minutes               | 2.58   | 2.4                | JENKINS-34808              |
| `hudson.remoting.SynchronousCommandTransport.failOnSocketTimeoutInReader`    | false                    | 2.60   | TODO               | JENKINS-22722              |
| `hudson.remoting.ExportTable.unexportLogSize`                                | 1024                     | 2.40   | ?                  | JENKINS-20707              |
| `${PROTOCOL_FULLY_QUALIFIED_NAME}.disabled`                                  | false                    | 2.59   | 2.4                | JENKINS-34819              |
| `org.jenkinsci.remoting.nio.NioChannelHub.disabled`                          | false                    | 2.62.3 | TODO               | JENKINS-39290              |
| `org.jenkinsci.remoting.engine.JnlpAgentEndpointResolver.protocolNamesToTry` | false                    | TODO   | TODO               | JENKINS-41730              |


### [Upgrading Jenkins](https://www.jenkins.io/blog/2018/03/15/jep-200-lts/#upgrading-jenkins)
