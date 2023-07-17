<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [upgrading jenkins](#upgrading-jenkins)
- [java configuration](#java-configuration)
- [threadDump](#threaddump)
- [agent](#agent)
- [Mailing format](#mailing-format)
- [Properties in Jenkins Core for `JAVA_OPTS`](#properties-in-jenkins-core-for-java_opts)
- [System Properties](#system-properties)
- [Configuring HTTP](#configuring-http)
- [tips](#tips)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [Jenkins Features Controlled with System Properties](https://www.jenkins.io/doc/book/managing/system-properties/)
> - [* How to Setup Jenkins Build Agents on Kubernetes Pods](https://devopscube.com/jenkins-build-agents-kubernetes/)
> - [Quick and Simple — How to Setup Jenkins Distributed (Master-Slave) Build on Kubernetes](https://medium.com/swlh/quick-and-simple-how-to-setup-jenkins-distributed-master-slave-build-on-kubernetes-37f3d76aae7d)
>
> - to get groovy version:
>   ```groovy
>   println GroovySystem.version
>   ```
> - [official yml](https://www.jenkins.io/doc/book/installing/kubernetes/)
>   - [jenkins-sa.yaml](https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml)
>   - [jenkins-volume.yaml](https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-volume.yaml)
>   - [jenkins-deployment.yaml](https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-deployment.yaml)
>   - [jenkins-service.yaml](https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-service.yaml)
{% endhint %}


### [upgrading jenkins](https://www.jenkins.io/blog/2018/03/15/jep-200-lts/#upgrading-jenkins)
#### [jenkins 2.357 requires Java 11](https://www.jenkins.io/blog/2022/06/28/require-java-11/)

{% hint style='tip' %}
> Beginning with Jenkins 2.357 (released on June 28, 2022) and the forthcoming September LTS release, Jenkins requires Java 11.
> Additionally, beginning with Jenkins 2.355 (released on June 14, 2022) and Jenkins 2.346.1 LTS (released on June 22, 2022), Jenkins supports Java 17.
> Plugins have already been prepared in JENKINS-68446. Use the Plugin Manager to upgrade all plugins before and after upgrading to Jenkins 2.357.
>
> refrences:
> - [Upgrading Jenkins Java version from 8 to 11](https://www.jenkins.io/doc/administration/requirements/upgrade-java-guidelines/)
>   - [JVM version on agents](https://www.jenkins.io/doc/administration/requirements/upgrade-java-guidelines/#jvm-version-on-agents)
> - [Java requirements](https://www.jenkins.io/doc/administration/requirements/java/)
> - [Downloading and running Jenkins in Docker](https://www.jenkins.io/doc/book/installing/docker/#downloading-and-running-jenkins-in-docker)
> - [** Prepare Jenkins for Support](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/best-practices/prepare-jenkins-for-support)
>   - [JVM Recommended Arguments](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/best-practices/prepare-jenkins-for-support#_jvm_recommended_arguments)
> - [Upgrading to Java 11 or 17](https://www.jenkins.io/blog/2022/06/28/require-java-11/#upgrading-to-java-11-or-17)
> - [Setting JVM Options for Application Servers](https://community.jaspersoft.com/documentation/jasperreports-server-community-install-guide/v56/setting-jvm-options-application)
>   ```
>   -Xms1024m
>   -Xmx2048m
>   -XX:PermSize=32m
>   -XX:MaxPermSize=512m
>   -Xss2m
>   ```
> - [Java Documentations](https://community.jaspersoft.com/documentation/jasperreports-server-community-install-guide/installing/Post_Installation_Steps.htm)
{% endhint %}

- get Java version from Jenkins master
  ```groovy
  println " >> jenkins.rootUrl: ${Jenkins.instance.rootUrl} "
  println " >> jenkins.version: ${Jenkins.instance.version} "
  System.getProperties().findAll { k, v ->
    k.toLowerCase().contains( 'java' )
  }.each { k, v ->
    println " >>> ${k} ~> ${v} "
  }

  "DONE"
  ```

  - result
  ```
     >> jenkins.rootUrl: https://my-dev.jenkins.com/
     >> jenkins.version: 2.360
     >>> java.specification.version ~> 11
     >>> java.runtime.version ~> 11.0.15+10
     >>> java.class.path ~> /usr/share/jenkins/jenkins.war
     >>> java.vm.vendor ~> Eclipse Adoptium
     >>> javamelody.maven-repositories ~> /var/jenkins_home/.m2/repository,http://repo1.maven.org/maven2,http://repo.jenkins-ci.org/public
     >>> java.runtime.name ~> OpenJDK Runtime Environment
     >>> javamelody.gzip-compression-disabled ~> true
     >>> java.vendor.url ~> https://adoptium.net/
     >>> javamelody.About Monitoring ~> https://plugins.jenkins.io/monitoring/
     >>> java.vm.specification.version ~> 11
     >>> java.vm.name ~> OpenJDK 64-Bit Server VM
     >>> java.vendor.version ~> Temurin-11.0.15+10
     >>> javamelody.http-transform-pattern ~> /\d+/|(?<=/static/|/adjuncts/|/bound/)[\w\-]+|(?<=/ws/|/user/|/testReport/|/javadoc/|/site/|/violations/file/|/cobertura/).+|(?<=/job/).+(?=/descriptorByName/)
     >>> sun.java.launcher ~> SUN_STANDARD
     >>> sun.java.command ~> /usr/share/jenkins/jenkins.war
     >>> java.vendor.url.bug ~> https://github.com/adoptium/adoptium-support/issues
     >>> javamelody.system-actions-enabled ~> true
     >>> java.io.tmpdir ~> /tmp
     >>> javamelody.storage-directory ~> //var/jenkins_home/monitoring
     >>> java.version ~> 11.0.15
     >>> javamelody.custom-reports ~> Jenkins Info,About Monitoring
     >>> java.specification.vendor ~> Oracle Corporation
     >>> java.vm.specification.name ~> Java Virtual Machine Specification
     >>> java.awt.printerjob ~> sun.print.PSPrinterJob
     >>> java.version.date ~> 2022-04-19
     >>> java.home ~> /opt/java/openjdk
     >>> java.vm.compressedOopsMode ~> Zero based
     >>> java.library.path ~> /usr/java/packages/lib:/usr/lib64:/lib64:/lib:/usr/lib
     >>> java.specification.name ~> Java Platform API Specification
     >>> java.vm.specification.vendor ~> Oracle Corporation
     >>> java.vm.info ~> mixed mode
     >>> java.vendor ~> Eclipse Adoptium
     >>> java.vm.version ~> 11.0.15+10
     >>> java.awt.graphicsenv ~> sun.awt.X11GraphicsEnvironment
     >>> java.awt.headless ~> true
     >>> javamelody.csrf-protection-enabled ~> true
     >>> java.class.version ~> 55.0
     >>> javamelody.Jenkins Info ~> /systemInfo
     >>> javamelody.no-database ~> true
    Result: DONE
  ```

- get Java version from Jenkins agent

  ```groovy
  println " >> jenkins.rootUrl: ${Jenkins.instance.rootUrl}"
  println " >> jenkins.version: ${Jenkins.instance.version}"

  Jenkins.instance.nodes.each { agent ->
    println " >> agent: ${agent.displayName}"
    agent.computer.getSystemProperties().findAll{ k, v ->
      k.toLowerCase().contains( 'java' )
    }.each { k, v ->
      println " ~~> ${k} -> ${v}"
    }
  }
  ```
  - result
    ```
    >> jenkins.rootUrl: https://my-dev.jenkins.com/
    >> jenkins.version: 2.360
    >> agent: yaml-15-x946w-s48xb-jqkn0
    ~~> java.awt.graphicsenv -> sun.awt.X11GraphicsEnvironment
    ~~> java.awt.printerjob -> sun.print.PSPrinterJob
    ~~> java.class.path -> /usr/share/jenkins/slave.jar
    ~~> java.class.version -> 55.0
    ~~> java.home -> /usr/lib/jvm/java-11-openjdk-amd64
    ~~> java.io.tmpdir -> /tmp
    ~~> java.library.path -> /usr/java/packages/lib:/usr/lib/x86_64-linux-gnu/jni:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/usr/lib/jni:/lib:/usr/lib
    ~~> java.runtime.name -> OpenJDK Runtime Environment
    ~~> java.runtime.version -> 11.0.15+10-Ubuntu-0ubuntu0.18.04.1
    ~~> java.specification.name -> Java Platform API Specification
    ~~> java.specification.vendor -> Oracle Corporation
    ~~> java.specification.version -> 11
    ~~> java.vendor -> Private Build
    ~~> java.vendor.url -> Unknown
    ~~> java.vendor.url.bug -> Unknown
    ~~> java.version -> 11.0.15
    ~~> java.version.date -> 2022-04-19
    ~~> java.vm.compressedOopsMode -> Zero based
    ~~> java.vm.info -> mixed mode, sharing
    ~~> java.vm.name -> OpenJDK 64-Bit Server VM
    ~~> java.vm.specification.name -> Java Virtual Machine Specification
    ~~> java.vm.specification.vendor -> Oracle Corporation
    ~~> java.vm.specification.version -> 11
    ~~> java.vm.vendor -> Private Build
    ~~> java.vm.version -> 11.0.15+10-Ubuntu-0ubuntu0.18.04.1
    ~~> javamelody.no-database -> true
    ~~> sun.java.command -> hudson.remoting.jnlp.Main -headless -tunnel 1.2.3.4:12345 -url https://my-dev.jenkins.com/ -workDir /home/devops ae62043877285d6ba763f254ce041f64674ce2c4768d9872621af0ea65c07b2d yaml-15-x946w-s48xb-jqkn0
    ~~> sun.java.launcher -> SUN_STANDARD
    Result: [KubernetesSlave name: yaml-15-x946w-s48xb-jqkn0]
    ```

- or via `RemotingDiagnostics`
  ```groovy
  import hudson.util.RemotingDiagnostics
  import jenkins.model.Jenkins

  println " >> jenkins.rootUrl: ${Jenkins.instance.rootUrl}"
  println " >> jenkins.version: ${Jenkins.instance.version}"

  String result
  String javaVersion = """
    def stdout = new StringBuffer()
    def stderr = new StringBuffer()
    "java -version".execute().waitForProcessOutput( stdout, stderr )
    println stderr
  """

  Jenkins.instance.nodes.each { agent ->
    println ">> agent: ${agent.displayName}"
    result = RemotingDiagnostics.executeGroovy( javaVersion.trim(), agent.channel )
                    .tokenize( '\n' )
                    .collect{ "\t${it}" }
                    .join( '\n' )
  }
  println ">>> java version: \n${result}"
  ```
  - result
    ```
    >> jenkins.rootUrl: https://my-dev.jenkins.com/
    >> jenkins.version: 2.360
    >> agent: yaml-15-x946w-s48xb-jqkn0
    >>> java version:
      openjdk version "11.0.15" 2022-04-19
      OpenJDK Runtime Environment (build 11.0.15+10-Ubuntu-0ubuntu0.18.04.1)
      OpenJDK 64-Bit Server VM (build 11.0.15+10-Ubuntu-0ubuntu0.18.04.1, mixed mode, sharing)
    ```

### java configuration

> [!TIP|label:official recommended]
> - [** A. Java Configuration](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/best-practices/prepare-jenkins-for-support)
> - [** Memory problem: 'unable to create new native thread'](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/memory-problem-unable-to-create-new-native-thread)
> - [* Too many open files](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/too-many-open-files)
> - [* Supported Java 8 arguments](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#java8-arguments)
> - [* Supported Java 11 arguments](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#java11-arguments)
> - [** Java Heap settings Best Practice](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/best-practices/jvm-memory-settings-best-practice)
>   - [Minimum and maximum heap sizes](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#_minimum_and_maximum_heap_sizes)
> - [Enterprise JVM Administration and Jenkins Performance](https://www.cloudbees.com/blog/enterprise-jvm-administration-and-jenkins-performance)
> - [CloudBees Jenkins JVM troubleshooting](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#_heap_size)
> - [How to Troubleshoot and Address Jenkins Startup Performances](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/troubleshooting-guides/jenkins-startup-performances)
> - [How to generate a thread dump?](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/how-to-generate-a-thread-dump)
> - [Jenkins : Obtaining a thread dump](https://wiki.jenkins.io/display/JENKINS/Obtaining+a+thread+dump)
> - [Required Data: Jenkins Hang Issue On Linux](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/required-data/required-data-hang-issue-on-linux-cjp)
> - [Upgrading to Jenkins 2.176.2 : Improved CSRF protection](https://www.jenkins.io/doc/upgrade-guide/2.176/#upgrading-to-jenkins-lts-2-176-2)
> - [JENKINS-71273: Gerrit Trigger fails to connect Gerrit 2.14 - com.jcraft.jsch.JSchException: verify: false](https://issues.jenkins.io/browse/JENKINS-71273)
>   ```bash
>   -Djsch.client_pubkey="ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,rsa-sha2-512,rsa-sha2-256,ssh-rsa"
>   -Djsch.server_host_key="ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,rsa-sha2-512,rsa-sha2-256,ssh-rsa"
>   ```

- java 11

  > [!NOTE]
  > - Omitting `-XX:+UnlockDiagnosticVMOptions` or `-XX:+UnlockExperimentalVMOptions` might cause your instance to fail to startup.
  > - To increase GC logs to a longer period of time, we suggest
  >   - increasing the value of the arguments `-Xlog` option `filecount=2` and/or `filesize=100M`
  >   - and as ultimate option use `file=${LOGDIR}/gc-%t.log` instead of `file=${LOGDIR}/gc.log`.
  >   - With the parameter `%t`, the JVM create a new set of GC files each time that the instance is restarted.
  >     It is well known that when the GC log folder gets big enough in terms of size, the support bundle might produce performance issues in the instance given that it needs to compress all of them.

  ```bash
  -XX:+AlwaysPreTouch
  -XX:+HeapDumpOnOutOfMemoryError
  -XX:HeapDumpPath=${LOGDIR}
  -XX:+UseG1GC
  -XX:+UseStringDeduplication
  -XX:+ParallelRefProcEnabled
  -XX:+DisableExplicitGC
  -XX:+UnlockDiagnosticVMOptions
  -XX:+UnlockExperimentalVMOptions
  -Xlog:gc*=info,gc+heap=debug,gc+ref*=debug,gc+ergo*=trace,gc+age*=trace:file=${LOGDIR}/gc.log:utctime,pid,level,tags:filecount=2,filesize=100M
  -XX:ErrorFile=${LOGDIR}/hs_err_%p.log
  -XX:+LogVMOutput
  -XX:LogFile=${LOGDIR}/jvm.log
  # Heap setting for CloudBees CI on modern cloud platforms:
  #   -XX:InitialRAMPercentage=50.0 -XX:MaxRAMPercentage=50.0
  # Heap setting for CloudBees CI on traditional platforms:
  #   Heap Size `-Xmx` and `-Xms` should be set to the same value, and determined by following the above section "JVM Heap Size"
  ```

- java 8

  > [!NOTE]
  > - To increase GC logs to a longer period of time, we suggest
  >   - increasing the value of the arguments `-XX:GCLogFileSize` and `-XX:NumberOfGCLogFiles`
  >   - and as ultimate option use `-Xloggc:${LOGDIR}/gc-%t.log` instead of `-Xloggc:${LOGDIR}/gc.log`.
  >   - With the parameter `%t`, the JVM create a new set of GC files each time that the instance is restarted.
  >     It is well known that when the GC log folder gets big enough in terms of size, the support bundle might produce performance issues in the instance given that it needs to compress all of them.

  ```bash
  -Dhudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID=true
  -Djenkins.model.Jenkins.logStartupPerformance=true
  -Xms192G
  -Xmx192G
  -XX:+AlwaysPreTouch
  -XX:+HeapDumpOnOutOfMemoryError
  -XX:HeapDumpPath=/var/jenkins_home/logs
  -XX:+UseG1GC
  -XX:+UseStringDeduplication
  -XX:+ParallelRefProcEnabled
  -XX:+DisableExplicitGC
  -XX:+UnlockDiagnosticVMOptions
  -XX:+UnlockExperimentalVMOptions
  -verbose:gc
  -XX:+PrintGC
  -XX:+PrintGCDetails
  -XX:ErrorFile=/var/jenkins_home/logs/hs_err_%p.log
  -XX:+LogVMOutput
  -XX:LogFile=/var/jenkins_home/logs/jvm.log
  -XX:InitialRAMPercentage=50.0
  -XX:MaxRAMPercentage=50.0
  -Xlog:gc*=info,gc+heap=debug,gc+ref*=debug,gc+ergo*=trace,gc+age*=trace:file=/var/jenkins_home/logs/gc-%t.log:utctime,pid,level,tags:filecount=2,filesize=100M
  ```

  - [more info](https://github.com/docker-library/openjdk/issues/350#issuecomment-525066155)
    ```bash
    $ docker run --rm openjdk:8-jre java -XX:MaxRAMPercentage=75 -help 2>&1 | head
    Improperly specified VM option 'MaxRAMPercentage=75'
    Error: Could not create the Java Virtual Machine.
    Error: A fatal exception has occurred. Program will exit.
    $ docker run --rm openjdk:8-jre java -XX:MaxRAMPercentage=75.0 -help 2>&1 | head
    Usage: java [-options] class [args...]
               (to execute a class)
       or  java [-options] -jar jarfile [args...]
               (to execute a jar file)
    where options include:
        -d32    use a 32-bit data model if available
        -d64    use a 64-bit data model if available
        -server   to select the "server" VM
                      The default VM is server,
                      because you are running on a server-class machine.
    ```

  <!--sec data-title="doc for JAVA_OPT" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  -XX:+AlwaysPreTouch
  -XX:+HeapDumpOnOutOfMemoryError
  -XX:HeapDumpPath=${LOGDIR}
  -XX:+UseG1GC
  -XX:+UseStringDeduplication
  -XX:+ParallelRefProcEnabled
  -XX:+DisableExplicitGC
  -XX:+UnlockDiagnosticVMOptions
  -XX:+UnlockExperimentalVMOptions
  -verbose:gc
  -Xloggc:${LOGDIR}/gc.log
  -XX:NumberOfGCLogFiles=2
  -XX:+UseGCLogFileRotation
  -XX:GCLogFileSize=100m
  -XX:+PrintGC
  -XX:+PrintGCDateStamps
  -XX:+PrintGCDetails
  -XX:+PrintHeapAtGC
  -XX:+PrintGCCause
  -XX:+PrintTenuringDistribution
  -XX:+PrintReferenceGC
  -XX:+PrintAdaptiveSizePolicy
  -XX:ErrorFile=${LOGDIR}/hs_err_%p.log
  -XX:+LogVMOutput
  -XX:LogFile=${LOGDIR}/jvm.log
  # Heap setting for CloudBees CI on modern cloud platforms:
  #   -XX:InitialRAMPercentage=50.0 -XX:MaxRAMPercentage=50.0
  # Heap setting for CloudBees CI on traditional platforms:
  #   Heap Size `-Xmx` and `-Xms` should be set to the same value, and determined by following the above section "JVM Heap Size"
  ```
  <!--endsec-->

### threadDump

> [!NOTE]
> - visit via GUI: https://<hostname>.domain.com/threadDump
> - [Using Thread Dumps](https://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/geninfo/diagnos/using_threaddumps.html)
> - [How to generate a thread dump?](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/how-to-generate-a-thread-dump)
> - [Jenkins : Obtaining a thread dump](https://wiki.jenkins.io/display/JENKINS/Obtaining+a+thread+dump)

### agent

{% hint style='tip' %}
> [ssh agent](https://github.com/jenkinsci/docker-ssh-agent) dockerfile
> - [JVM 11 for windows](https://github.com/jenkinsci/docker-ssh-agent/tree/master/11/windows)
>   - [windowsservercore-ltsc2019](https://github.com/jenkinsci/docker-ssh-agent/blob/master/11/windows/nanoserver-ltsc2019/Dockerfile)
>   - [nanoserver-ltsc2019](https://github.com/jenkinsci/docker-ssh-agent/blob/master/11/windows/windowsservercore-ltsc2019/Dockerfile)
> - [alpine](https://github.com/jenkinsci/docker-ssh-agent/blob/master/11/alpine/Dockerfile)
> - [bullseye](https://github.com/jenkinsci/docker-ssh-agent/blob/master/11/bullseye/Dockerfile)
{% endhint %}

```bash
$ sudo update-alternatives --remove java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
```


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


### tips

- [Add Users to Jenkins with "Allow users to sign up" Disabled](https://stackoverflow.com/a/12365640/2940319)
  ```bash
  $JENKINS_URL/securityRealm/addUser
  ```

- sa.yml

  > [!NOTE|label:references:]
  > - [How To Setup Jenkins On Kubernetes Cluster – Beginners Guide](https://devopscube.com/setup-jenkins-on-kubernetes-cluster/)
  > - [How to Setup Jenkins Build Agents on Kubernetes Pods](https://devopscube.com/jenkins-build-agents-kubernetes/)

  - sample 1
    ```yaml
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: jenkins-admin
    rules:
      - apiGroups: [""]
        resources: ["*"]
        verbs: ["*"]

    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: jenkins-admin
      namespace: devops-tools

    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: jenkins-admin
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: jenkins-admin
    subjects:
    - kind: ServiceAccount
      name: jenkins-admin
      namespace: devops-tools
    ```

  - sample 2
    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: jenkins-admin
      namespace: devops-tools
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: jenkins
      namespace: devops-tools
      labels:
        "app.kubernetes.io/name": 'jenkins'
    rules:
    - apiGroups: [""]
      resources: ["pods"]
      verbs: ["create","delete","get","list","patch","update","watch"]
    - apiGroups: [""]
      resources: ["pods/exec"]
      verbs: ["create","delete","get","list","patch","update","watch"]
    - apiGroups: [""]
      resources: ["pods/log"]
      verbs: ["get","list","watch"]
    - apiGroups: [""]
      resources: ["secrets"]
      verbs: ["get"]
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: jenkins-role-binding
      namespace: devops-tools
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: jenkins
    subjects:
    - kind: ServiceAccount
      name: jenkins-admin
      namespace: devops-tools
    ```
