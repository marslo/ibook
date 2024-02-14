<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [basic usage](#basic-usage)
  - [specify additional repositories](#specify-additional-repositories)
  - [maven classifiers](#maven-classifiers)
  - [excluding transitive dependencies](#excluding-transitive-dependencies)
  - [jdbc drivers](#jdbc-drivers)
  - [using grape from the groovy shell](#using-grape-from-the-groovy-shell)
- [settings](#settings)
  - [proxy settings](#proxy-settings)
  - [logging](#logging)
- [jenkins-core](#jenkins-core)
  - [setup manually](#setup-manually)
  - [use `jenkins-core`](#use-jenkins-core)
  - [Q&A](#qa)
- [CLI](#cli)
  - [list](#list)
  - [resolve](#resolve)
  - [install](#install)
  - [uninstall](#uninstall)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='info' %}
> references:
> - [Dependency management with Grape](https://docs.groovy-lang.org/latest/html/documentation/grape.html)
> - [GROOVY-7833](https://issues.apache.org/jira/browse/GROOVY-7833)
> - [releases/org/jenkins-ci/main/jenkins-core](https://repo.jenkins-ci.org/artifactory/releases/org/jenkins-ci/main/jenkins-core/)
> - [Groovy Grape Turns Sour – java.lang.RuntimeException: Error grabbing Grapes — [download failed:](https://alok-mishra.com/2015/10/01/593/)
{% endhint %}

## basic usage
```groovy
@Grab(group='org.springframework', module='spring-orm', version='5.2.8.RELEASE')
import org.springframework.jdbc.core.JdbcTemplate
```

- or
  ```groovy
  @Grab('org.springframework:spring-orm:5.2.8.RELEASE')
  import org.springframework.jdbc.core.JdbcTemplate
  ```

### specify additional repositories
```groovy
@GrabResolver(name='restlet', root='http://maven.restlet.org/')
@Grab(group='org.restlet', module='org.restlet', version='1.1.6')
```

### maven classifiers
```groovy
@Grab(group='net.sf.json-lib', module='json-lib', version='2.2.3', classifier='jdk15')
```

### excluding transitive dependencies
```groovy
@Grab('net.sourceforge.htmlunit:htmlunit:2.8')
@GrabExclude('xml-apis:xml-apis')
```

### jdbc drivers
```groovy
@GrabConfig(systemClassLoader=true)
@Grab(group='mysql', module='mysql-connector-java', version='5.1.6')
```

### using grape from the groovy shell
```groovy
groovy.grape.Grape.grab(group:'org.springframework', module:'spring', version:'2.5.6')
```

## settings

### proxy settings

> [!TIP]
> reference:
> - [Java Networking and Proxies](https://docs.oracle.com/javase/8/docs/technotes/guides/net/proxies.html)
> - [Networking Properties](https://docs.oracle.com/javase/7/docs/api/java/net/doc-files/net-properties.html)
> - [The JAVA_TOOL_OPTIONS Environment Variable](https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/envvars002.html)
> - [Bypassing non proxy hosts in JAVA_OPTS](https://stackoverflow.com/a/31062162/2940319)
> - [Configure HTTP/HTTPS Proxy Settings Java](https://memorynotfound.com/configure-http-proxy-settings-java/)
> - [Setting JVM Options for Application Servers](https://community.jaspersoft.com/documentation/jasperreports-server-community-install-guide/v56/setting-jvm-options-application)
> - [java HotSpot VM Command-Line Options](https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/clopts001.html)
> - [The java Command](https://docs.oracle.com/en/java/javase/13/docs/specs/man/java.html)
>
> - [`nonProxy`](https://stackoverflow.com/a/120802/2940319)
>   ```
>   -Dhttp.nonProxyHosts="localhost|127.0.0.1|10.*.*.*|*.example.com|etc"
>   ```
> - [`useSystemProxy`](https://stackoverflow.com/a/27919196/2940319)
>   ```bash
>   $ java -Djava.net.useSystemProxies=true
>
>   # or https://stackoverflow.com/a/32511851/2940319
>   export JAVA_TOOL_OPTIONS+=" -Djava.net.useSystemProxies=true"
>
>   # or
>   System.setProperty("java.net.useSystemProxies", "true");
>   ```
> - [socket proxy](https://stackoverflow.com/a/47583369/2940319)
>   ```
>   $ java -DsocksProxyHost=127.0.0.1 -DsocksProxyPort=8080 org.example.Main
>   ```

```bash
$ groovy -Dhttp.proxyHost=yourproxy -Dhttp.proxyPort=8080 yourscript.groovy

# or
JAVA_OPTS = -Dhttp.proxyHost=yourproxy -Dhttp.proxyPort=8080
```

### logging

- show download process
  ```bash
  $ groovy -Dgroovy.grape.report.downloads=true sample.groovy
  Resolving dependency: org.springframework#spring-orm;5.2.8.RELEASE {default=[default]}
  Preparing to download artifact org.springframework#spring-orm;5.2.8.RELEASE!spring-orm.jar
  Preparing to download artifact org.springframework#spring-beans;5.2.8.RELEASE!spring-beans.jar
  Preparing to download artifact org.springframework#spring-core;5.2.8.RELEASE!spring-core.jar
  Preparing to download artifact org.springframework#spring-jdbc;5.2.8.RELEASE!spring-jdbc.jar
  Preparing to download artifact org.springframework#spring-tx;5.2.8.RELEASE!spring-tx.jar
  Preparing to download artifact org.springframework#spring-jcl;5.2.8.RELEASE!spring-jcl.jar
  Downloaded 3006 Kbytes in 893ms:
    [SUCCESSFUL ] org.springframework#spring-orm;5.2.8.RELEASE!spring-orm.jar (202ms)
    [SUCCESSFUL ] org.springframework#spring-beans;5.2.8.RELEASE!spring-beans.jar (154ms)
    [SUCCESSFUL ] org.springframework#spring-core;5.2.8.RELEASE!spring-core.jar (175ms)
    [SUCCESSFUL ] org.springframework#spring-jcl;5.2.8.RELEASE!spring-jcl.jar (112ms)
    [SUCCESSFUL ] org.springframework#spring-jdbc;5.2.8.RELEASE!spring-jdbc.jar (132ms)
    [SUCCESSFUL ] org.springframework#spring-tx;5.2.8.RELEASE!spring-tx.jar (111ms)
  ```

- log with even more verbosity
  ```bash
  $ groovy -Divy.message.logger.level=4 sample.groovy
  ```


## jenkins-core

> [!TIP]
> references:
> - [org.jenkins-ci.main/jenkins-core](https://repo.jenkins-ci.org/artifactory/releases/org/jenkins-ci/main/jenkins-core/)
> - [jenkinsci/java-client-api](https://github.com/jenkinsci/java-client-api)

### setup manually

- setup `JAVA_OPTS` ( if necessary )
  ```bash
  echo "JAVA_OPTS+='-Dhttp.proxyHost=my.proxy.com -Dhttp.proxyPort=80'" >> ~/.bashrc
  source ~/.bashrc

  # result
  $ echo $JAVA_OPTS
  -Dhttp.proxyHost=my.proxy.com -Dhttp.proxyPort=80
  ```
- download `pom` and `jar` to `~/.m2`
  ```bash
  $ version='2.377'
  $ path="~/.m2/repository/org/jenkins-ci/main/jenkins-core/${version}"
  $ url="https://repo.jenkins-ci.org/artifactory/releases/org/jenkins-ci/main/jenkins-core/${version}"
  $ mkdir -p "${path}" && cd $_
  $ curl -fsSL -o "${path}"/jenkins-core-${version}.pom "${url}"/jenkins-core-${version}.pom
  $ curl -fsSL -o "${path}"/jenkins-core-${version}.jar "${url}"/jenkins-core-${version}.jar
  ```

- download dependencies
  ```bash
  $ cat jenkins-core.groovy
  @GrabResolver(name='jenkins', root='https://repo.jenkins-ci.org/releases')
  @Grab(group='org.jenkins-ci.main', module='jenkins-core', version='2.377')
  import jenkins.model.Jenkins

  $ groovy [-Divy.message.logger.level=4] -Dgroovy.grape.report.downloads=true jenkins-core.groovy
  ```

### use `jenkins-core`
```groovy
@GrabResolver(name='jenkins', root='https://repo.jenkins-ci.org/releases')
@Grab(group='org.jenkins-ci.main', module='jenkins-core', version='2.377')

import hudson.Util
println Util.XS_DATETIME_FORMATTER.format( new Date() )

// => 2022-11-23T13:39:34Z
```

### Q&A

- `org.connectbot.jbcrypt#jbcrypt;1.0.0`
  - errors
    ```bash
    :: USE VERBOSE OR DEBUG MESSAGE LEVEL FOR MORE DETAILS
    org.codehaus.groovy.control.MultipleCompilationErrorsException: startup failed:
    General error during conversion: Error grabbing Grapes -- [unresolved dependency: org.connectbot.jbcrypt#jbcrypt;1.0.0: java.text.ParseException: project must be the root tag]
    ```
  - solution

    > [!TIP]
    > solution:
    > - using [`org/connectbot/jbcrypt/1.0.2`](https://repo.jenkins-ci.org/artifactory/public/org/connectbot/jbcrypt/1.0.2/) instead of [`org/connectbot/jbcrypt/jbcrypt/1.0.0`](https://repo.jenkins-ci.org/artifactory/public/org/connectbot/jbcrypt/jbcrypt/1.0.0/)

    ```bash
    $ grep -n jbcrypt ~/.groovy/grapes/org.jenkins-ci.main/jenkins-core/ivy-2.377.xml
    89:    <dependency org="org.connectbot.jbcrypt" name="jbcrypt" rev="1.0.0" force="true" conf="compile->compile(*),master(*);runtime->runtime(*)"/>

    |
    v

    89:    <dependency org="org.connectbot" name="jbcrypt" rev="1.0.2" force="true" conf="compile->compile(*),master(*);runtime->runtime(*)"/>
    ```

## CLI

> [!NOTE]
> - [How to specify javax.xml.accessExternalSchema for the JAXB2 Maven plugin](https://stackoverflow.com/a/27823893/2940319)
> - [Error grabbing Grapes ... unresolved dependency ... not found](https://stackoverflow.com/a/25205578/2940319)
> - [~/.groovy/grapeConfig.xml](https://stackoverflow.com/a/15791969/2940319)
> - [Customize Ivy settings](https://docs.groovy-lang.org/latest/html/documentation/grape.html#Grape-CustomizeIvysettings)
>   - [groovy/src/resources/groovy/grape/defaultGrapeConfig.xml](https://github.com/apache/groovy/blob/master/src/resources/groovy/grape/defaultGrapeConfig.xml)
> - [Java and Xerces: can't find property XMLConstants.ACCESS_EXTERNAL_DTD](https://stackoverflow.com/a/62261587/2940319)
> - [Using the Properties](https://docs.oracle.com/javase/tutorial/jaxp/properties/usingProps.html)
> - [org.xml.sax.SAXNotRecognizedException: Property 'http://javax.xml.XMLConstants/property/accessExternalDTD' is not recognized](https://stackoverflow.com/a/71855477/2940319)

```bash
$ sudo apt install groovy

$ which -a grape
/usr/bin/grape
/bin/grape
$ realpath /usr/bin/grape
/usr/share/groovy/bin/grape
$ realpath /bin/grape
/usr/share/groovy/bin/grape
$ dpkg -S /usr/share/groovy/bin/grape
groovy: /usr/share/groovy/bin/grape
```

### list
```bash
$ grape list
[0.009s][warning][gc] -XX:+PrintGC is deprecated. Will use -Xlog:gc instead.
[0.009s][warning][gc] -XX:+PrintGCDetails is deprecated. Will use -Xlog:gc* instead.
[0.039s][info   ][gc,heap] Heap region size: 8M
[1.057s][info   ][gc     ] Using G1
[1.057s][info   ][gc,heap,coops] Heap address: 0x0000001000800000, size: 31744 MB, Compressed Oops mode: Non-zero disjoint base: 0x0000001000000000, Oop shift amount: 3
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.codehaus.groovy.reflection.CachedClass (file:/usr/share/groovy/lib/groovy-2.4.21.jar) to method java.lang.Object.finalize()
WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.reflection.CachedClass
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release

setting 'ivy.default.settings.dir' to 'jar:file:/usr/share/groovy/lib/ivy.jar!/org/apache/ivy/core/settings'
setting 'ivy.basedir' to '/var/jenkins_home/.'
setting 'ivy.default.conf.dir' to 'jar:file:/usr/share/groovy/lib/ivy.jar!/org/apache/ivy/core/settings'
setting 'awt.toolkit' to 'sun.awt.X11.XToolkit'
setting 'java.specification.version' to '11'
setting 'sun.cpu.isalist' to ''
setting 'sun.jnu.encoding' to 'UTF-8'
setting 'sun.arch.data.model' to '64'
setting 'java.vendor.url' to 'https://adoptium.net/'
setting 'ivy.message.logger.level' to '4'
setting 'sun.boot.library.path' to '/opt/java/openjdk/lib'
setting 'sun.java.command' to 'org.codehaus.groovy.tools.GroovyStarter --main org.codehaus.groovy.tools.GrapeMain --conf /usr/share/groovy/conf/groovy-starter.conf --classpath . list'
setting 'jdk.debug' to 'release'
setting 'jenkins.model.Jenkins.logStartupPerformance' to 'true'
setting 'java.specification.vendor' to 'Oracle Corporation'
setting 'java.version.date' to '2023-10-17'
setting 'java.home' to '/opt/java/openjdk'
setting 'file.separator' to '/'
setting 'java.vm.compressedOopsMode' to 'Non-zero disjoint base'
setting 'line.separator' to '
'
setting 'java.specification.name' to 'Java Platform API Specification'
setting 'java.vm.specification.vendor' to 'Oracle Corporation'
setting 'groovy.grape.report.downloads' to 'true'
setting 'sun.management.compiler' to 'HotSpot 64-Bit Tiered Compilers'
setting 'java.runtime.version' to '11.0.21+9'
setting 'user.name' to 'jenkins'
setting 'file.encoding' to 'UTF-8'
setting 'java.vendor.version' to 'Temurin-11.0.21+9'
setting 'java.io.tmpdir' to '/tmp'
setting 'java.version' to '11.0.21'
setting 'java.vm.specification.name' to 'Java Virtual Machine Specification'
setting 'java.awt.printerjob' to 'sun.print.PSPrinterJob'
setting 'sun.os.patch.level' to 'unknown'
setting 'java.library.path' to '/usr/java/packages/lib:/usr/lib64:/lib64:/lib:/usr/lib'
setting 'java.vendor' to 'Eclipse Adoptium'
setting 'java.specification.maintenance.version' to '2'
setting 'jenkins.install.runSetupWizard' to 'true'
setting 'sun.io.unicode.encoding' to 'UnicodeLittle'
setting 'java.class.path' to '/usr/share/groovy/lib/groovy-2.4.21.jar'
setting 'java.vm.vendor' to 'Eclipse Adoptium'
setting 'script.name' to '/usr/bin/grape'
setting 'user.timezone' to 'America/Los_Angeles'
setting 'jenkins.slaves.NioChannelSelector.disabled' to 'true'
setting 'os.name' to 'Linux'
setting 'java.vm.specification.version' to '11'
setting 'program.name' to 'grape'
setting 'sun.java.launcher' to 'SUN_STANDARD'
setting 'sun.cpu.endian' to 'little'
setting 'user.home' to '/var/jenkins_home'
setting 'tools.jar' to '/opt/java/openjdk/lib/tools.jar'
setting 'user.language' to 'en'
setting 'jsch.client_pubkey' to 'ssh-rsa,ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,rsa-sha2-512,rsa-sha2-256'
setting 'jsch.server_host_key' to 'ssh-rsa,ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,rsa-sha2-512,rsa-sha2-256'
setting 'com.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors' to 'true'
setting 'java.awt.graphicsenv' to 'sun.awt.X11GraphicsEnvironment'
setting 'java.awt.headless' to 'true'
setting 'sessionTimeout' to '1440'
setting 'sessionEviction' to '43200'
setting 'groovy.starter.conf' to '/usr/share/groovy/conf/groovy-starter.conf'
setting 'hudson.model.ParametersAction.keepUndefinedParameters' to 'true'
setting 'path.separator' to ':'
setting 'hudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps' to 'false'
setting 'os.version' to '4.19.12-1.el7.elrepo.x86_64'
setting 'java.runtime.name' to 'OpenJDK Runtime Environment'
setting 'jenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST' to 'true'
setting 'jenkins.slaves.JnlpSlaveAgentProtocol3.enabled' to 'false'
setting 'java.vm.name' to 'OpenJDK 64-Bit Server VM'
setting 'java.vendor.url.bug' to 'https://github.com/adoptium/adoptium-support/issues'
setting 'permissive-script-security.enabled' to 'true'
setting 'user.dir' to '/var/jenkins_home'
setting 'hudson.model.DirectoryBrowserSupport.CSP' to ''
setting 'groovy.home' to '/usr/share/groovy'
setting 'os.arch' to 'amd64'
setting 'hudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID' to 'true'
setting 'java.vm.info' to 'mixed mode'
setting 'java.vm.version' to '11.0.21+9'
setting 'java.class.version' to '55.0'
:: loading settings :: url = jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml
setting 'ivy.settings.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml'
setting 'ivy.conf.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml'
setting 'ivy.settings.dir' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.settings.dir.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.conf.dir' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.default.ivy.user.dir' to '/var/jenkins_home/.ivy2'
setting 'ivy.home' to '/var/jenkins_home/.ivy2'
no default ivy user dir defined: set to /var/jenkins_home/.ivy2
setting 'ivy.retrieve.pattern' to '${ivy.lib.dir}/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.configurations' to '*'
setting 'ivy.project.dir' to '${basedir}'
setting 'ivy.resolve.default.type.filter' to '*'
setting 'ivy.deliver.ivy.pattern' to '${ivy.distrib.dir}/[type]s/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.default.always.check.exact.revision' to 'false'
setting 'ivy.status' to 'integration'
setting 'ivy.report.output.pattern' to '[organisation]-[module]-[conf].[ext]'
setting 'ivy.log.modules.in.use' to 'false'
setting 'ivy.publish.src.artifacts.pattern' to '${ivy.distrib.dir}/[type]s/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.checksums' to 'sha1,md5'
setting 'ivy.resolver.default.check.modified' to 'false'
setting 'ivy.dep.file' to 'ivy.xml'
setting 'ivy.settings.file' to 'ivysettings.xml'
setting 'ivy.build.artifacts.dir' to '${ivy.project.dir}/build/artifacts'
setting 'ivy.lib.dir' to '${ivy.project.dir}/lib'
setting 'ivy.cache.ttl.default' to '10s'
setting 'ivy.buildlist.ivyfilepath' to 'ivy.xml'
setting 'ivy.distrib.dir' to '${ivy.project.dir}/distrib'
setting 'ivy.cache.dir' to '/var/jenkins_home/.ivy2/cache'
no default cache defined: set to /var/jenkins_home/.ivy2/cache
downloadGrapes: no namespace defined: using system
downloadGrapes: no latest strategy defined: using default
jcenter: no namespace defined: using system
jcenter: no latest strategy defined: using default
cachedGrapes: no namespace defined: using system
cachedGrapes: no latest strategy defined: using default
localm2: no namespace defined: using system
localm2: no latest strategy defined: using default
ibiblio: no namespace defined: using system
ibiblio: no latest strategy defined: using default
'ivy.default.ivy.user.dir' already set: discarding '/var/jenkins_home/.ivy2'
settings loaded (107ms)
  default cache: /var/jenkins_home/.ivy2/cache
  default resolver: downloadGrapes
  default latest strategy: latest-revision
  default conflict manager: latest-revision
  circular dependency strategy: warn
  validate: true
  check up2date: true
  -- 5 resolvers:
  downloadGrapes [chain] [cachedGrapes, localm2, jcenter, ibiblio]
    return first: true
    dual: false
    -> cachedGrapes
    -> localm2
    -> jcenter
    -> ibiblio
  jcenter [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      https://jcenter.bintray.com/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      https://jcenter.bintray.com/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: jcenter
    root: https://jcenter.bintray.com/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  cachedGrapes [file]
    cache: null
    m2compatible: false
    ivy patterns:
      /var/jenkins_home/.groovy/grapes/[organisation]/[module]/ivy-[revision].xml
    artifact patterns:
      /var/jenkins_home/.groovy/grapes/[organisation]/[module]/[type]s/[artifact]-[revision](-[classifier]).[ext]
    repository: cachedGrapes
  localm2 [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      file:/var/jenkins_home/.m2/repository/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      file:/var/jenkins_home/.m2/repository/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: localm2
    root: file:/var/jenkins_home/.m2/repository/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  ibiblio [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      https://repo1.maven.org/maven2/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      https://repo1.maven.org/maven2/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: ibiblio
    root: https://repo1.maven.org/maven2/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  module settings:
    NONE
'ivy.cache.dir' already set: discarding '/var/jenkins_home/.groovy/grapes'
setting 'ivy.default.configuration.m2compatible' to 'true'
commons-beanutils commons-beanutils  [1.8.0]
commons-codec commons-codec  [1.6, 1.2]
commons-collections commons-collections  [3.2.1]
commons-lang commons-lang  [2.4, 2.5]
commons-logging commons-logging  [1.1.1, 1.0.4]
net.sf.ezmorph ezmorph  [1.0.6]
net.sf.json-lib json-lib  [2.3, 2.4]
net.sourceforge.nekohtml nekohtml  [1.9.16]
org.apache.commons commons-parent  [11, 22, 5, 9, 12]
org.apache.httpcomponents httpclient  [4.2.1, 4.2.5]
org.apache.httpcomponents httpcomponents-client  [4.2.1, 4.2.5]
org.apache.httpcomponents httpcomponents-core  [4.2.1, 4.2.4]
org.apache.httpcomponents httpcore  [4.2.1, 4.2.4]
org.apache.httpcomponents project  [6]
org.apache.httpcomponents httpmime  [4.2.5]
org.apache apache  [3, 4, 9]
org.codehaus.groovy.modules.http-builder http-builder  [0.7.1]
xerces xercesImpl  [2.9.1]
xml-resolver xml-resolver  [1.2]
org.ajoberstar.grgit grgit-core  [3.1.1, 5.2.1, 4.0.2]
org.eclipse.jgit org.eclipse.jgit  [5.3.0.201903130848-r, 5.7.0.202003110725-r]
org.eclipse.jgit org.eclipse.jgit-parent  [5.3.0.201903130848-r, 5.7.0.202003110725-r]
com.jcraft jsch  [0.1.54, 0.1.55]
com.jcraft jzlib  [1.1.1]
org.sonatype.oss oss-parent  [6, 5, 7]
com.googlecode.javaewah JavaEWAH  [1.1.6, 1.1.7]
org.slf4j slf4j-api  [1.7.2]
org.slf4j slf4j-parent  [1.7.2]
org.bouncycastle bcpg-jdk15on  [1.60, 1.64]
org.bouncycastle bcprov-jdk15on  [1.60, 1.64]
org.bouncycastle bcpkix-jdk15on  [1.60, 1.64]
net.rcarz jira-client  [0.5]
joda-time joda-time  [2.3]
junit junit  [4.8.2]
org.mockito mockito-all  [1.9.0]
commons-httpclient commons-httpclient  [3.1]
org.yaml snakeyaml  [1.17]

37 Grape modules cached
62 Grape module versions cached
[1.809s][info   ][gc,heap,exit ] Heap
[1.809s][info   ][gc,heap,exit ]  garbage-first heap   total 16777216K, used 73728K [0x0000001000800000, 0x00000017c0800000)
[1.809s][info   ][gc,heap,exit ]   region size 8192K, 10 young (81920K), 0 survivors (0K)
[1.809s][info   ][gc,heap,exit ]  Metaspace       used 19414K, capacity 19908K, committed 19968K, reserved 1067008K
[1.809s][info   ][gc,heap,exit ]   class space    used 1884K, capacity 2039K, committed 2048K, reserved 1048576K
```

### resolve
```bash
$ grape resolve org.ajoberstar.grgit grgit-core 4.0.2
[0.007s][warning][gc] -XX:+PrintGC is deprecated. Will use -Xlog:gc instead.
[0.007s][warning][gc] -XX:+PrintGCDetails is deprecated. Will use -Xlog:gc* instead.
[0.032s][info   ][gc,heap] Heap region size: 8M
[1.131s][info   ][gc     ] Using G1
[1.131s][info   ][gc,heap,coops] Heap address: 0x0000001000800000, size: 31744 MB, Compressed Oops mode: Non-zero disjoint base: 0x0000001000000000, Oop shift amount: 3
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.codehaus.groovy.reflection.CachedClass (file:/usr/share/groovy/lib/groovy-2.4.21.jar) to method java.lang.Object.finalize()
WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.reflection.CachedClass
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
setting 'ivy.default.settings.dir' to 'jar:file:/usr/share/groovy/lib/ivy.jar!/org/apache/ivy/core/settings'
setting 'ivy.basedir' to '/var/jenkins_home/.'
setting 'ivy.default.conf.dir' to 'jar:file:/usr/share/groovy/lib/ivy.jar!/org/apache/ivy/core/settings'
setting 'awt.toolkit' to 'sun.awt.X11.XToolkit'
setting 'java.specification.version' to '11'
setting 'sun.cpu.isalist' to ''
setting 'sun.jnu.encoding' to 'UTF-8'
setting 'sun.arch.data.model' to '64'
setting 'java.vendor.url' to 'https://adoptium.net/'
setting 'ivy.message.logger.level' to '4'
setting 'sun.boot.library.path' to '/opt/java/openjdk/lib'
setting 'sun.java.command' to 'org.codehaus.groovy.tools.GroovyStarter --main org.codehaus.groovy.tools.GrapeMain --conf /usr/share/groovy/conf/groovy-starter.conf --classpath . resolve org.ajoberstar.grgit grgit-core 4.0.2'
setting 'jdk.debug' to 'release'
setting 'jenkins.model.Jenkins.logStartupPerformance' to 'true'
setting 'java.specification.vendor' to 'Oracle Corporation'
setting 'java.version.date' to '2023-10-17'
setting 'java.home' to '/opt/java/openjdk'
setting 'file.separator' to '/'
setting 'java.vm.compressedOopsMode' to 'Non-zero disjoint base'
setting 'line.separator' to '
'
setting 'java.specification.name' to 'Java Platform API Specification'
setting 'java.vm.specification.vendor' to 'Oracle Corporation'
setting 'groovy.grape.report.downloads' to 'true'
setting 'sun.management.compiler' to 'HotSpot 64-Bit Tiered Compilers'
setting 'java.runtime.version' to '11.0.21+9'
setting 'user.name' to 'jenkins'
setting 'file.encoding' to 'UTF-8'
setting 'java.vendor.version' to 'Temurin-11.0.21+9'
setting 'java.io.tmpdir' to '/tmp'
setting 'java.version' to '11.0.21'
setting 'java.vm.specification.name' to 'Java Virtual Machine Specification'
setting 'java.awt.printerjob' to 'sun.print.PSPrinterJob'
setting 'sun.os.patch.level' to 'unknown'
setting 'java.library.path' to '/usr/java/packages/lib:/usr/lib64:/lib64:/lib:/usr/lib'
setting 'java.vendor' to 'Eclipse Adoptium'
setting 'java.specification.maintenance.version' to '2'
setting 'jenkins.install.runSetupWizard' to 'true'
setting 'sun.io.unicode.encoding' to 'UnicodeLittle'
setting 'java.class.path' to '/usr/share/groovy/lib/groovy-2.4.21.jar'
setting 'java.vm.vendor' to 'Eclipse Adoptium'
setting 'script.name' to '/usr/bin/grape'
setting 'user.timezone' to 'America/Los_Angeles'
setting 'jenkins.slaves.NioChannelSelector.disabled' to 'true'
setting 'os.name' to 'Linux'
setting 'java.vm.specification.version' to '11'
setting 'program.name' to 'grape'
setting 'sun.java.launcher' to 'SUN_STANDARD'
setting 'sun.cpu.endian' to 'little'
setting 'user.home' to '/var/jenkins_home'
setting 'tools.jar' to '/opt/java/openjdk/lib/tools.jar'
setting 'user.language' to 'en'
setting 'jsch.client_pubkey' to 'ssh-rsa,ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,rsa-sha2-512,rsa-sha2-256'
setting 'jsch.server_host_key' to 'ssh-rsa,ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,rsa-sha2-512,rsa-sha2-256'
setting 'com.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors' to 'true'
setting 'java.awt.graphicsenv' to 'sun.awt.X11GraphicsEnvironment'
setting 'java.awt.headless' to 'true'
setting 'sessionTimeout' to '1440'
setting 'sessionEviction' to '43200'
setting 'groovy.starter.conf' to '/usr/share/groovy/conf/groovy-starter.conf'
setting 'hudson.model.ParametersAction.keepUndefinedParameters' to 'true'
setting 'path.separator' to ':'
setting 'hudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps' to 'false'
setting 'os.version' to '4.19.12-1.el7.elrepo.x86_64'
setting 'java.runtime.name' to 'OpenJDK Runtime Environment'
setting 'jenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST' to 'true'
setting 'jenkins.slaves.JnlpSlaveAgentProtocol3.enabled' to 'false'
setting 'java.vm.name' to 'OpenJDK 64-Bit Server VM'
setting 'java.vendor.url.bug' to 'https://github.com/adoptium/adoptium-support/issues'
setting 'permissive-script-security.enabled' to 'true'
setting 'user.dir' to '/var/jenkins_home'
setting 'hudson.model.DirectoryBrowserSupport.CSP' to ''
setting 'groovy.home' to '/usr/share/groovy'
setting 'os.arch' to 'amd64'
setting 'hudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID' to 'true'
setting 'java.vm.info' to 'mixed mode'
setting 'java.vm.version' to '11.0.21+9'
setting 'java.class.version' to '55.0'
:: loading settings :: url = jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml
setting 'ivy.settings.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml'
setting 'ivy.conf.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml'
setting 'ivy.settings.dir' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.settings.dir.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.conf.dir' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.default.ivy.user.dir' to '/var/jenkins_home/.ivy2'
setting 'ivy.home' to '/var/jenkins_home/.ivy2'
no default ivy user dir defined: set to /var/jenkins_home/.ivy2
setting 'ivy.retrieve.pattern' to '${ivy.lib.dir}/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.configurations' to '*'
setting 'ivy.project.dir' to '${basedir}'
setting 'ivy.resolve.default.type.filter' to '*'
setting 'ivy.deliver.ivy.pattern' to '${ivy.distrib.dir}/[type]s/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.default.always.check.exact.revision' to 'false'
setting 'ivy.status' to 'integration'
setting 'ivy.report.output.pattern' to '[organisation]-[module]-[conf].[ext]'
setting 'ivy.log.modules.in.use' to 'false'
setting 'ivy.publish.src.artifacts.pattern' to '${ivy.distrib.dir}/[type]s/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.checksums' to 'sha1,md5'
setting 'ivy.resolver.default.check.modified' to 'false'
setting 'ivy.dep.file' to 'ivy.xml'
setting 'ivy.settings.file' to 'ivysettings.xml'
setting 'ivy.build.artifacts.dir' to '${ivy.project.dir}/build/artifacts'
setting 'ivy.lib.dir' to '${ivy.project.dir}/lib'
setting 'ivy.cache.ttl.default' to '10s'
setting 'ivy.buildlist.ivyfilepath' to 'ivy.xml'
setting 'ivy.distrib.dir' to '${ivy.project.dir}/distrib'
setting 'ivy.cache.dir' to '/var/jenkins_home/.ivy2/cache'
no default cache defined: set to /var/jenkins_home/.ivy2/cache
downloadGrapes: no namespace defined: using system
downloadGrapes: no latest strategy defined: using default
jcenter: no namespace defined: using system
jcenter: no latest strategy defined: using default
cachedGrapes: no namespace defined: using system
cachedGrapes: no latest strategy defined: using default
localm2: no namespace defined: using system
localm2: no latest strategy defined: using default
ibiblio: no namespace defined: using system
ibiblio: no latest strategy defined: using default
'ivy.default.ivy.user.dir' already set: discarding '/var/jenkins_home/.ivy2'
settings loaded (97ms)
  default cache: /var/jenkins_home/.ivy2/cache
  default resolver: downloadGrapes
  default latest strategy: latest-revision
  default conflict manager: latest-revision
  circular dependency strategy: warn
  validate: true
  check up2date: true
  -- 5 resolvers:
  downloadGrapes [chain] [cachedGrapes, localm2, jcenter, ibiblio]
    return first: true
    dual: false
    -> cachedGrapes
    -> localm2
    -> jcenter
    -> ibiblio
  jcenter [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      https://jcenter.bintray.com/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      https://jcenter.bintray.com/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: jcenter
    root: https://jcenter.bintray.com/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  cachedGrapes [file]
    cache: null
    m2compatible: false
    ivy patterns:
      /var/jenkins_home/.groovy/grapes/[organisation]/[module]/ivy-[revision].xml
    artifact patterns:
      /var/jenkins_home/.groovy/grapes/[organisation]/[module]/[type]s/[artifact]-[revision](-[classifier]).[ext]
    repository: cachedGrapes
  localm2 [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      file:/var/jenkins_home/.m2/repository/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      file:/var/jenkins_home/.m2/repository/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: localm2
    root: file:/var/jenkins_home/.m2/repository/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  ibiblio [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      https://repo1.maven.org/maven2/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      https://repo1.maven.org/maven2/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: ibiblio
    root: https://repo1.maven.org/maven2/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  module settings:
    NONE
'ivy.cache.dir' already set: discarding '/var/jenkins_home/.groovy/grapes'
setting 'ivy.default.configuration.m2compatible' to 'true'
Resolving dependency: org.ajoberstar.grgit#grgit-core;4.0.2 {default=[default]}
[1.843s][info   ][gc,start     ] GC(0) Pause Young (Concurrent Start) (Metadata GC Threshold)
[1.847s][info   ][gc,task      ] GC(0) Using 48 workers of 48 for evacuation
[1.879s][info   ][gc,phases    ] GC(0)   Pre Evacuate Collection Set: 0.1ms
[1.879s][info   ][gc,phases    ] GC(0)   Evacuate Collection Set: 27.2ms
[1.879s][info   ][gc,phases    ] GC(0)   Post Evacuate Collection Set: 2.6ms
[1.879s][info   ][gc,phases    ] GC(0)   Other: 5.8ms
[1.879s][info   ][gc,heap      ] GC(0) Eden regions: 9->0(100)
[1.879s][info   ][gc,heap      ] GC(0) Survivor regions: 0->2(13)
[1.879s][info   ][gc,heap      ] GC(0) Old regions: 0->0
[1.879s][info   ][gc,heap      ] GC(0) Humongous regions: 0->0
[1.879s][info   ][gc,metaspace ] GC(0) Metaspace: 20574K(21248K)->20574K(21248K) NonClass: 18522K(18944K)->18522K(18944K) Class: 2051K(2304K)->2051K(2304K)
[1.879s][info   ][gc           ] GC(0) Pause Young (Concurrent Start) (Metadata GC Threshold) 72M->9M(16384M) 35.949ms
[1.879s][info   ][gc,cpu       ] GC(0) User=0.51s Sys=0.00s Real=0.04s
[1.879s][info   ][gc           ] GC(1) Concurrent Cycle
[1.879s][info   ][gc,marking   ] GC(1) Concurrent Clear Claimed Marks
[1.879s][info   ][gc,marking   ] GC(1) Concurrent Clear Claimed Marks 0.032ms
[1.879s][info   ][gc,marking   ] GC(1) Concurrent Scan Root Regions
[1.883s][info   ][gc,marking   ] GC(1) Concurrent Scan Root Regions 3.767ms
[1.883s][info   ][gc,marking   ] GC(1) Concurrent Mark (1.883s)
[1.883s][info   ][gc,marking   ] GC(1) Concurrent Mark From Roots
[1.884s][info   ][gc,task      ] GC(1) Using 12 workers of 12 for marking
[1.889s][info   ][gc,marking   ] GC(1) Concurrent Mark From Roots 6.180ms
[1.889s][info   ][gc,marking   ] GC(1) Concurrent Preclean
[1.890s][info   ][gc,marking   ] GC(1) Concurrent Preclean 1.003ms
[1.890s][info   ][gc,marking   ] GC(1) Concurrent Mark (1.883s, 1.890s) 7.256ms
[1.891s][info   ][gc,start     ] GC(1) Pause Remark
[1.899s][info   ][gc,stringtable] GC(1) Cleaned string and symbol table, strings: 10578 processed, 0 removed, symbols: 67215 processed, 226 removed
[1.900s][info   ][gc            ] GC(1) Pause Remark 13M->13M(16384M) 9.494ms
[1.900s][info   ][gc,cpu        ] GC(1) User=0.29s Sys=0.00s Real=0.01s
[1.900s][info   ][gc,marking    ] GC(1) Concurrent Rebuild Remembered Sets
[1.900s][info   ][gc,marking    ] GC(1) Concurrent Rebuild Remembered Sets 0.268ms
[1.901s][info   ][gc,start      ] GC(1) Pause Cleanup
[1.902s][info   ][gc            ] GC(1) Pause Cleanup 13M->13M(16384M) 0.843ms
[1.902s][info   ][gc,cpu        ] GC(1) User=0.00s Sys=0.01s Real=0.00s
[1.902s][info   ][gc,marking    ] GC(1) Concurrent Cleanup for Next Mark
[1.907s][info   ][gc,marking    ] GC(1) Concurrent Cleanup for Next Mark 5.771ms
[1.907s][info   ][gc            ] GC(1) Concurrent Cycle 28.302ms
Preparing to download artifact org.ajoberstar.grgit#grgit-core;4.0.2!grgit-core.jar
Preparing to download artifact org.eclipse.jgit#org.eclipse.jgit;5.7.0.202003110725-r!org.eclipse.jgit.jar
Preparing to download artifact com.jcraft#jsch;0.1.55!jsch.jar
Preparing to download artifact com.jcraft#jzlib;1.1.1!jzlib.jar
Preparing to download artifact com.googlecode.javaewah#JavaEWAH;1.1.7!JavaEWAH.jar(bundle)
Preparing to download artifact org.slf4j#slf4j-api;1.7.2!slf4j-api.jar
Preparing to download artifact org.bouncycastle#bcpg-jdk15on;1.64!bcpg-jdk15on.jar
Preparing to download artifact org.bouncycastle#bcprov-jdk15on;1.64!bcprov-jdk15on.jar
Preparing to download artifact org.bouncycastle#bcpkix-jdk15on;1.64!bcpkix-jdk15on.jar
Downloaded 250 Kbytes in 398ms:
  [SUCCESSFUL ] org.ajoberstar.grgit#grgit-core;4.0.2!grgit-core.jar (371ms)
  [NOT REQUIRED] org.eclipse.jgit#org.eclipse.jgit;5.7.0.202003110725-r!org.eclipse.jgit.jar
  [NOT REQUIRED] com.jcraft#jsch;0.1.55!jsch.jar
  [NOT REQUIRED] com.jcraft#jzlib;1.1.1!jzlib.jar
  [NOT REQUIRED] com.googlecode.javaewah#JavaEWAH;1.1.7!JavaEWAH.jar(bundle)
  [NOT REQUIRED] org.slf4j#slf4j-api;1.7.2!slf4j-api.jar
  [NOT REQUIRED] org.bouncycastle#bcpg-jdk15on;1.64!bcpg-jdk15on.jar
  [NOT REQUIRED] org.bouncycastle#bcprov-jdk15on;1.64!bcprov-jdk15on.jar
  [NOT REQUIRED] org.bouncycastle#bcpkix-jdk15on;1.64!bcpkix-jdk15on.jar
/var/jenkins_home/.groovy/grapes/org.ajoberstar.grgit/grgit-core/jars/grgit-core-4.0.2.jar
/var/jenkins_home/.groovy/grapes/org.eclipse.jgit/org.eclipse.jgit/jars/org.eclipse.jgit-5.7.0.202003110725-r.jar
/var/jenkins_home/.groovy/grapes/com.jcraft/jsch/jars/jsch-0.1.55.jar
/var/jenkins_home/.groovy/grapes/com.jcraft/jzlib/jars/jzlib-1.1.1.jar
/var/jenkins_home/.groovy/grapes/com.googlecode.javaewah/JavaEWAH/bundles/JavaEWAH-1.1.7.jar
/var/jenkins_home/.groovy/grapes/org.slf4j/slf4j-api/jars/slf4j-api-1.7.2.jar
/var/jenkins_home/.groovy/grapes/org.bouncycastle/bcpg-jdk15on/jars/bcpg-jdk15on-1.64.jar
/var/jenkins_home/.groovy/grapes/org.bouncycastle/bcprov-jdk15on/jars/bcprov-jdk15on-1.64.jar
/var/jenkins_home/.groovy/grapes/org.bouncycastle/bcpkix-jdk15on/jars/bcpkix-jdk15on-1.64.jar

[3.165s][info   ][gc,heap,exit  ] Heap
[3.165s][info   ][gc,heap,exit  ]  garbage-first heap   total 16777216K, used 58941K [0x0000001000800000, 0x00000017c0800000)
[3.165s][info   ][gc,heap,exit  ]   region size 8192K, 9 young (73728K), 2 survivors (16384K)
[3.165s][info   ][gc,heap,exit  ]  Metaspace       used 28323K, capacity 28943K, committed 29184K, reserved 1075200K
[3.165s][info   ][gc,heap,exit  ]   class space    used 2829K, capacity 3068K, committed 3072K, reserved 1048576K
```

```bash
$ grape resolve -q
[0.006s][warning][gc] -XX:+PrintGC is deprecated. Will use -Xlog:gc instead.
[0.006s][warning][gc] -XX:+PrintGCDetails is deprecated. Will use -Xlog:gc* instead.
[0.019s][info   ][gc,heap] Heap region size: 8M
[1.010s][info   ][gc     ] Using G1
[1.010s][info   ][gc,heap,coops] Heap address: 0x0000001000800000, size: 31744 MB, Compressed Oops mode: Non-zero disjoint base: 0x0000001000000000, Oop shift amount: 3
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.codehaus.groovy.reflection.CachedClass (file:/usr/share/groovy/lib/groovy-2.4.21.jar) to method java.lang.Object.finalize()
WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.reflection.CachedClass
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
setting 'ivy.default.settings.dir' to 'jar:file:/usr/share/groovy/lib/ivy.jar!/org/apache/ivy/core/settings'
setting 'ivy.basedir' to '/var/jenkins_home/.'
setting 'ivy.default.conf.dir' to 'jar:file:/usr/share/groovy/lib/ivy.jar!/org/apache/ivy/core/settings'
setting 'awt.toolkit' to 'sun.awt.X11.XToolkit'
setting 'java.specification.version' to '11'
setting 'sun.cpu.isalist' to ''
setting 'sun.jnu.encoding' to 'UTF-8'
setting 'sun.arch.data.model' to '64'
setting 'java.vendor.url' to 'https://adoptium.net/'
setting 'ivy.message.logger.level' to '4'
setting 'sun.boot.library.path' to '/opt/java/openjdk/lib'
setting 'sun.java.command' to 'org.codehaus.groovy.tools.GroovyStarter --main org.codehaus.groovy.tools.GrapeMain --conf /usr/share/groovy/conf/groovy-starter.conf --classpath . resolve -q'
setting 'jdk.debug' to 'release'
setting 'jenkins.model.Jenkins.logStartupPerformance' to 'true'
setting 'java.specification.vendor' to 'Oracle Corporation'
setting 'java.version.date' to '2023-10-17'
setting 'java.home' to '/opt/java/openjdk'
setting 'file.separator' to '/'
setting 'java.vm.compressedOopsMode' to 'Non-zero disjoint base'
setting 'line.separator' to '
'
setting 'java.specification.name' to 'Java Platform API Specification'
setting 'java.vm.specification.vendor' to 'Oracle Corporation'
setting 'groovy.grape.report.downloads' to 'true'
setting 'sun.management.compiler' to 'HotSpot 64-Bit Tiered Compilers'
setting 'java.runtime.version' to '11.0.21+9'
setting 'user.name' to 'jenkins'
setting 'file.encoding' to 'UTF-8'
setting 'java.vendor.version' to 'Temurin-11.0.21+9'
setting 'java.io.tmpdir' to '/tmp'
setting 'java.version' to '11.0.21'
setting 'java.vm.specification.name' to 'Java Virtual Machine Specification'
setting 'java.awt.printerjob' to 'sun.print.PSPrinterJob'
setting 'sun.os.patch.level' to 'unknown'
setting 'java.library.path' to '/usr/java/packages/lib:/usr/lib64:/lib64:/lib:/usr/lib'
setting 'java.vendor' to 'Eclipse Adoptium'
setting 'java.specification.maintenance.version' to '2'
setting 'jenkins.install.runSetupWizard' to 'true'
setting 'sun.io.unicode.encoding' to 'UnicodeLittle'
setting 'java.class.path' to '/usr/share/groovy/lib/groovy-2.4.21.jar'
setting 'java.vm.vendor' to 'Eclipse Adoptium'
setting 'script.name' to '/usr/bin/grape'
setting 'user.timezone' to 'America/Los_Angeles'
setting 'jenkins.slaves.NioChannelSelector.disabled' to 'true'
setting 'os.name' to 'Linux'
setting 'java.vm.specification.version' to '11'
setting 'program.name' to 'grape'
setting 'sun.java.launcher' to 'SUN_STANDARD'
setting 'sun.cpu.endian' to 'little'
setting 'user.home' to '/var/jenkins_home'
setting 'tools.jar' to '/opt/java/openjdk/lib/tools.jar'
setting 'user.language' to 'en'
setting 'jsch.client_pubkey' to 'ssh-rsa,ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,rsa-sha2-512,rsa-sha2-256'
setting 'jsch.server_host_key' to 'ssh-rsa,ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,rsa-sha2-512,rsa-sha2-256'
setting 'com.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors' to 'true'
setting 'java.awt.graphicsenv' to 'sun.awt.X11GraphicsEnvironment'
setting 'java.awt.headless' to 'true'
setting 'sessionTimeout' to '1440'
setting 'sessionEviction' to '43200'
setting 'groovy.starter.conf' to '/usr/share/groovy/conf/groovy-starter.conf'
setting 'hudson.model.ParametersAction.keepUndefinedParameters' to 'true'
setting 'path.separator' to ':'
setting 'hudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps' to 'false'
setting 'os.version' to '4.19.12-1.el7.elrepo.x86_64'
setting 'java.runtime.name' to 'OpenJDK Runtime Environment'
setting 'jenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST' to 'true'
setting 'jenkins.slaves.JnlpSlaveAgentProtocol3.enabled' to 'false'
setting 'java.vm.name' to 'OpenJDK 64-Bit Server VM'
setting 'java.vendor.url.bug' to 'https://github.com/adoptium/adoptium-support/issues'
setting 'permissive-script-security.enabled' to 'true'
setting 'user.dir' to '/var/jenkins_home'
setting 'hudson.model.DirectoryBrowserSupport.CSP' to ''
setting 'groovy.home' to '/usr/share/groovy'
setting 'os.arch' to 'amd64'
setting 'hudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID' to 'true'
setting 'java.vm.info' to 'mixed mode'
setting 'java.vm.version' to '11.0.21+9'
setting 'java.class.version' to '55.0'
:: loading settings :: url = jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml
setting 'ivy.settings.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml'
setting 'ivy.conf.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml'
setting 'ivy.settings.dir' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.settings.dir.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.conf.dir' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.default.ivy.user.dir' to '/var/jenkins_home/.ivy2'
setting 'ivy.home' to '/var/jenkins_home/.ivy2'
no default ivy user dir defined: set to /var/jenkins_home/.ivy2
setting 'ivy.retrieve.pattern' to '${ivy.lib.dir}/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.configurations' to '*'
setting 'ivy.project.dir' to '${basedir}'
setting 'ivy.resolve.default.type.filter' to '*'
setting 'ivy.deliver.ivy.pattern' to '${ivy.distrib.dir}/[type]s/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.default.always.check.exact.revision' to 'false'
setting 'ivy.status' to 'integration'
setting 'ivy.report.output.pattern' to '[organisation]-[module]-[conf].[ext]'
setting 'ivy.log.modules.in.use' to 'false'
setting 'ivy.publish.src.artifacts.pattern' to '${ivy.distrib.dir}/[type]s/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.checksums' to 'sha1,md5'
setting 'ivy.resolver.default.check.modified' to 'false'
setting 'ivy.dep.file' to 'ivy.xml'
setting 'ivy.settings.file' to 'ivysettings.xml'
setting 'ivy.build.artifacts.dir' to '${ivy.project.dir}/build/artifacts'
setting 'ivy.lib.dir' to '${ivy.project.dir}/lib'
setting 'ivy.cache.ttl.default' to '10s'
setting 'ivy.buildlist.ivyfilepath' to 'ivy.xml'
setting 'ivy.distrib.dir' to '${ivy.project.dir}/distrib'
setting 'ivy.cache.dir' to '/var/jenkins_home/.ivy2/cache'
no default cache defined: set to /var/jenkins_home/.ivy2/cache
downloadGrapes: no namespace defined: using system
downloadGrapes: no latest strategy defined: using default
jcenter: no namespace defined: using system
jcenter: no latest strategy defined: using default
cachedGrapes: no namespace defined: using system
cachedGrapes: no latest strategy defined: using default
localm2: no namespace defined: using system
localm2: no latest strategy defined: using default
ibiblio: no namespace defined: using system
ibiblio: no latest strategy defined: using default
'ivy.default.ivy.user.dir' already set: discarding '/var/jenkins_home/.ivy2'
settings loaded (97ms)
  default cache: /var/jenkins_home/.ivy2/cache
  default resolver: downloadGrapes
  default latest strategy: latest-revision
  default conflict manager: latest-revision
  circular dependency strategy: warn
  validate: true
  check up2date: true
  -- 5 resolvers:
  downloadGrapes [chain] [cachedGrapes, localm2, jcenter, ibiblio]
    return first: true
    dual: false
    -> cachedGrapes
    -> localm2
    -> jcenter
    -> ibiblio
  jcenter [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      https://jcenter.bintray.com/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      https://jcenter.bintray.com/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: jcenter
    root: https://jcenter.bintray.com/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  cachedGrapes [file]
    cache: null
    m2compatible: false
    ivy patterns:
      /var/jenkins_home/.groovy/grapes/[organisation]/[module]/ivy-[revision].xml
    artifact patterns:
      /var/jenkins_home/.groovy/grapes/[organisation]/[module]/[type]s/[artifact]-[revision](-[classifier]).[ext]
    repository: cachedGrapes
  localm2 [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      file:/var/jenkins_home/.m2/repository/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      file:/var/jenkins_home/.m2/repository/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: localm2
    root: file:/var/jenkins_home/.m2/repository/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  ibiblio [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      https://repo1.maven.org/maven2/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      https://repo1.maven.org/maven2/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: ibiblio
    root: https://repo1.maven.org/maven2/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  module settings:
    NONE
'ivy.cache.dir' already set: discarding '/var/jenkins_home/.groovy/grapes'
setting 'ivy.default.configuration.m2compatible' to 'true'
There needs to be a multiple of three arguments: (group module version)+
[1.611s][info   ][gc,heap,exit ] Heap
[1.611s][info   ][gc,heap,exit ]  garbage-first heap   total 16777216K, used 65536K [0x0000001000800000, 0x00000017c0800000)
[1.611s][info   ][gc,heap,exit ]   region size 8192K, 9 young (73728K), 0 survivors (0K)
[1.611s][info   ][gc,heap,exit ]  Metaspace       used 19191K, capacity 19658K, committed 19712K, reserved 1067008K
[1.611s][info   ][gc,heap,exit ]   class space    used 1856K, capacity 2021K, committed 2048K, reserved 1048576K
jenkins@devops-jenkins-7b9c76d564-s75tj:~$ la /var/jenkins_home/.ivy2
bash: la: command not found
jenkins@devops-jenkins-7b9c76d564-s75tj:~$ ls -altrh /var/jenkins_home/.ivy2
ls: cannot access '/var/jenkins_home/.ivy2': No such file or directory
jenkins@devops-jenkins-7b9c76d564-s75tj:~$
```

### install

> [!NOTE]
> - [Using new Groovy Grape capability results in "unable to resolve class" error](https://stackoverflow.com/a/1628995/2940319)

```bash
$ grape install org.ajoberstar.grgit 4.0.2 grgit-core
[0.005s][warning][gc] -XX:+PrintGC is deprecated. Will use -Xlog:gc instead.
[0.005s][warning][gc] -XX:+PrintGCDetails is deprecated. Will use -Xlog:gc* instead.
[0.017s][info   ][gc,heap] Heap region size: 8M
[1.015s][info   ][gc     ] Using G1
[1.015s][info   ][gc,heap,coops] Heap address: 0x0000001000800000, size: 31744 MB, Compressed Oops mode: Non-zero disjoint base: 0x0000001000000000, Oop shift amount: 3
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.codehaus.groovy.reflection.CachedClass (file:/usr/share/groovy/lib/groovy-2.4.21.jar) to method java.lang.Object.finalize()
WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.reflection.CachedClass
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
setting 'ivy.default.settings.dir' to 'jar:file:/usr/share/groovy/lib/ivy.jar!/org/apache/ivy/core/settings'
setting 'ivy.basedir' to '/var/jenkins_home/.'
setting 'ivy.default.conf.dir' to 'jar:file:/usr/share/groovy/lib/ivy.jar!/org/apache/ivy/core/settings'
setting 'awt.toolkit' to 'sun.awt.X11.XToolkit'
setting 'java.specification.version' to '11'
setting 'sun.cpu.isalist' to ''
setting 'sun.jnu.encoding' to 'UTF-8'
setting 'sun.arch.data.model' to '64'
setting 'java.vendor.url' to 'https://adoptium.net/'
setting 'ivy.message.logger.level' to '4'
setting 'sun.boot.library.path' to '/opt/java/openjdk/lib'
setting 'sun.java.command' to 'org.codehaus.groovy.tools.GroovyStarter --main org.codehaus.groovy.tools.GrapeMain --conf /usr/share/groovy/conf/groovy-starter.conf --classpath . install org.ajoberstar.grgit 4.0.2 grgit-core'
setting 'jdk.debug' to 'release'
setting 'jenkins.model.Jenkins.logStartupPerformance' to 'true'
setting 'java.specification.vendor' to 'Oracle Corporation'
setting 'java.version.date' to '2023-10-17'
setting 'java.home' to '/opt/java/openjdk'
setting 'file.separator' to '/'
setting 'java.vm.compressedOopsMode' to 'Non-zero disjoint base'
setting 'line.separator' to '
'
setting 'java.specification.name' to 'Java Platform API Specification'
setting 'java.vm.specification.vendor' to 'Oracle Corporation'
setting 'groovy.grape.report.downloads' to 'true'
setting 'sun.management.compiler' to 'HotSpot 64-Bit Tiered Compilers'
setting 'java.runtime.version' to '11.0.21+9'
setting 'user.name' to 'jenkins'
setting 'file.encoding' to 'UTF-8'
setting 'java.vendor.version' to 'Temurin-11.0.21+9'
setting 'java.io.tmpdir' to '/tmp'
setting 'java.version' to '11.0.21'
setting 'java.vm.specification.name' to 'Java Virtual Machine Specification'
setting 'java.awt.printerjob' to 'sun.print.PSPrinterJob'
setting 'sun.os.patch.level' to 'unknown'
setting 'java.library.path' to '/usr/java/packages/lib:/usr/lib64:/lib64:/lib:/usr/lib'
setting 'java.vendor' to 'Eclipse Adoptium'
setting 'java.specification.maintenance.version' to '2'
setting 'jenkins.install.runSetupWizard' to 'true'
setting 'sun.io.unicode.encoding' to 'UnicodeLittle'
setting 'java.class.path' to '/usr/share/groovy/lib/groovy-2.4.21.jar'
setting 'java.vm.vendor' to 'Eclipse Adoptium'
setting 'script.name' to '/usr/bin/grape'
setting 'user.timezone' to 'America/Los_Angeles'
setting 'jenkins.slaves.NioChannelSelector.disabled' to 'true'
setting 'os.name' to 'Linux'
setting 'java.vm.specification.version' to '11'
setting 'program.name' to 'grape'
setting 'sun.java.launcher' to 'SUN_STANDARD'
setting 'sun.cpu.endian' to 'little'
setting 'user.home' to '/var/jenkins_home'
setting 'tools.jar' to '/opt/java/openjdk/lib/tools.jar'
setting 'user.language' to 'en'
setting 'jsch.client_pubkey' to 'ssh-rsa,ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,rsa-sha2-512,rsa-sha2-256'
setting 'jsch.server_host_key' to 'ssh-rsa,ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,rsa-sha2-512,rsa-sha2-256'
setting 'com.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors' to 'true'
setting 'java.awt.graphicsenv' to 'sun.awt.X11GraphicsEnvironment'
setting 'java.awt.headless' to 'true'
setting 'sessionTimeout' to '1440'
setting 'sessionEviction' to '43200'
setting 'groovy.starter.conf' to '/usr/share/groovy/conf/groovy-starter.conf'
setting 'hudson.model.ParametersAction.keepUndefinedParameters' to 'true'
setting 'path.separator' to ':'
setting 'hudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps' to 'false'
setting 'os.version' to '4.19.12-1.el7.elrepo.x86_64'
setting 'java.runtime.name' to 'OpenJDK Runtime Environment'
setting 'jenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST' to 'true'
setting 'jenkins.slaves.JnlpSlaveAgentProtocol3.enabled' to 'false'
setting 'java.vm.name' to 'OpenJDK 64-Bit Server VM'
setting 'java.vendor.url.bug' to 'https://github.com/adoptium/adoptium-support/issues'
setting 'permissive-script-security.enabled' to 'true'
setting 'user.dir' to '/var/jenkins_home'
setting 'hudson.model.DirectoryBrowserSupport.CSP' to ''
setting 'groovy.home' to '/usr/share/groovy'
setting 'os.arch' to 'amd64'
setting 'hudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID' to 'true'
setting 'java.vm.info' to 'mixed mode'
setting 'java.vm.version' to '11.0.21+9'
setting 'java.class.version' to '55.0'
:: loading settings :: url = jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml
setting 'ivy.settings.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml'
setting 'ivy.conf.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml'
setting 'ivy.settings.dir' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.settings.dir.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.conf.dir' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.default.ivy.user.dir' to '/var/jenkins_home/.ivy2'
setting 'ivy.home' to '/var/jenkins_home/.ivy2'
no default ivy user dir defined: set to /var/jenkins_home/.ivy2
setting 'ivy.retrieve.pattern' to '${ivy.lib.dir}/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.configurations' to '*'
setting 'ivy.project.dir' to '${basedir}'
setting 'ivy.resolve.default.type.filter' to '*'
setting 'ivy.deliver.ivy.pattern' to '${ivy.distrib.dir}/[type]s/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.default.always.check.exact.revision' to 'false'
setting 'ivy.status' to 'integration'
setting 'ivy.report.output.pattern' to '[organisation]-[module]-[conf].[ext]'
setting 'ivy.log.modules.in.use' to 'false'
setting 'ivy.publish.src.artifacts.pattern' to '${ivy.distrib.dir}/[type]s/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.checksums' to 'sha1,md5'
setting 'ivy.resolver.default.check.modified' to 'false'
setting 'ivy.dep.file' to 'ivy.xml'
setting 'ivy.settings.file' to 'ivysettings.xml'
setting 'ivy.build.artifacts.dir' to '${ivy.project.dir}/build/artifacts'
setting 'ivy.lib.dir' to '${ivy.project.dir}/lib'
setting 'ivy.cache.ttl.default' to '10s'
setting 'ivy.buildlist.ivyfilepath' to 'ivy.xml'
setting 'ivy.distrib.dir' to '${ivy.project.dir}/distrib'
setting 'ivy.cache.dir' to '/var/jenkins_home/.ivy2/cache'
no default cache defined: set to /var/jenkins_home/.ivy2/cache
downloadGrapes: no namespace defined: using system
downloadGrapes: no latest strategy defined: using default
jcenter: no namespace defined: using system
jcenter: no latest strategy defined: using default
cachedGrapes: no namespace defined: using system
cachedGrapes: no latest strategy defined: using default
localm2: no namespace defined: using system
localm2: no latest strategy defined: using default
ibiblio: no namespace defined: using system
ibiblio: no latest strategy defined: using default
'ivy.default.ivy.user.dir' already set: discarding '/var/jenkins_home/.ivy2'
settings loaded (97ms)
  default cache: /var/jenkins_home/.ivy2/cache
  default resolver: downloadGrapes
  default latest strategy: latest-revision
  default conflict manager: latest-revision
  circular dependency strategy: warn
  validate: true
  check up2date: true
  -- 5 resolvers:
  downloadGrapes [chain] [cachedGrapes, localm2, jcenter, ibiblio]
    return first: true
    dual: false
    -> cachedGrapes
    -> localm2
    -> jcenter
    -> ibiblio
  jcenter [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      https://jcenter.bintray.com/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      https://jcenter.bintray.com/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: jcenter
    root: https://jcenter.bintray.com/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  cachedGrapes [file]
    cache: null
    m2compatible: false
    ivy patterns:
      /var/jenkins_home/.groovy/grapes/[organisation]/[module]/ivy-[revision].xml
    artifact patterns:
      /var/jenkins_home/.groovy/grapes/[organisation]/[module]/[type]s/[artifact]-[revision](-[classifier]).[ext]
    repository: cachedGrapes
  localm2 [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      file:/var/jenkins_home/.m2/repository/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      file:/var/jenkins_home/.m2/repository/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: localm2
    root: file:/var/jenkins_home/.m2/repository/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  ibiblio [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      https://repo1.maven.org/maven2/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      https://repo1.maven.org/maven2/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: ibiblio
    root: https://repo1.maven.org/maven2/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  module settings:
    NONE
'ivy.cache.dir' already set: discarding '/var/jenkins_home/.groovy/grapes'
setting 'ivy.default.configuration.m2compatible' to 'true'
:: loading settings :: url = jar:file:/usr/share/groovy/lib/ivy.jar!/org/apache/ivy/core/settings/ivysettings.xml
Resolving dependency: org.ajoberstar.grgit#4.0.2;grgit-core {default=[default]}
:: resolving dependencies :: caller#all-caller;working06
  confs: [default]
[1.714s][info   ][gc,start     ] GC(0) Pause Young (Concurrent Start) (Metadata GC Threshold)
[1.743s][info   ][gc,task      ] GC(0) Using 48 workers of 48 for evacuation
[1.767s][info   ][gc,phases    ] GC(0)   Pre Evacuate Collection Set: 0.1ms
[1.767s][info   ][gc,phases    ] GC(0)   Evacuate Collection Set: 20.7ms
[1.767s][info   ][gc,phases    ] GC(0)   Post Evacuate Collection Set: 2.1ms
[1.768s][info   ][gc,phases    ] GC(0)   Other: 30.7ms
[1.768s][info   ][gc,heap      ] GC(0) Eden regions: 9->0(100)
[1.768s][info   ][gc,heap      ] GC(0) Survivor regions: 0->2(13)
[1.768s][info   ][gc,heap      ] GC(0) Old regions: 0->0
[1.768s][info   ][gc,heap      ] GC(0) Humongous regions: 0->0
[1.768s][info   ][gc,metaspace ] GC(0) Metaspace: 20591K(21248K)->20591K(21248K) NonClass: 18537K(18944K)->18537K(18944K) Class: 2053K(2304K)->2053K(2304K)
[1.768s][info   ][gc           ] GC(0) Pause Young (Concurrent Start) (Metadata GC Threshold) 68M->9M(16384M) 53.888ms
[1.768s][info   ][gc,cpu       ] GC(0) User=0.38s Sys=0.01s Real=0.06s
[1.768s][info   ][gc           ] GC(1) Concurrent Cycle
[1.768s][info   ][gc,marking   ] GC(1) Concurrent Clear Claimed Marks
[1.768s][info   ][gc,marking   ] GC(1) Concurrent Clear Claimed Marks 0.034ms
[1.768s][info   ][gc,marking   ] GC(1) Concurrent Scan Root Regions
[1.776s][info   ][gc,marking   ] GC(1) Concurrent Scan Root Regions 8.520ms
[1.777s][info   ][gc,marking   ] GC(1) Concurrent Mark (1.777s)
[1.777s][info   ][gc,marking   ] GC(1) Concurrent Mark From Roots
[1.778s][info   ][gc,task      ] GC(1) Using 12 workers of 12 for marking
[1.780s][info   ][gc,marking   ] GC(1) Concurrent Mark From Roots 3.827ms
[1.780s][info   ][gc,marking   ] GC(1) Concurrent Preclean
[1.781s][info   ][gc,marking   ] GC(1) Concurrent Preclean 0.985ms
[1.781s][info   ][gc,marking   ] GC(1) Concurrent Mark (1.777s, 1.781s) 4.870ms
[1.782s][info   ][gc,start     ] GC(1) Pause Remark
[1.789s][info   ][gc,stringtable] GC(1) Cleaned string and symbol table, strings: 10701 processed, 0 removed, symbols: 67811 processed, 224 removed
[1.790s][info   ][gc            ] GC(1) Pause Remark 13M->13M(16384M) 7.944ms
[1.790s][info   ][gc,cpu        ] GC(1) User=0.21s Sys=0.00s Real=0.01s
[1.790s][info   ][gc,marking    ] GC(1) Concurrent Rebuild Remembered Sets
[1.790s][info   ][gc,marking    ] GC(1) Concurrent Rebuild Remembered Sets 0.271ms
[1.790s][info   ][gc,start      ] GC(1) Pause Cleanup
[1.791s][info   ][gc            ] GC(1) Pause Cleanup 13M->13M(16384M) 0.649ms
[1.791s][info   ][gc,cpu        ] GC(1) User=0.01s Sys=0.00s Real=0.00s
[1.791s][info   ][gc,marking    ] GC(1) Concurrent Cleanup for Next Mark
[1.803s][info   ][gc,marking    ] GC(1) Concurrent Cleanup for Next Mark 11.804ms
[1.803s][info   ][gc            ] GC(1) Concurrent Cycle 35.017ms

:: problems summary ::
:::: WARNINGS
    module not found: org.ajoberstar.grgit#4.0.2;grgit-core

  ==== cachedGrapes: tried

    /var/jenkins_home/.groovy/grapes/org.ajoberstar.grgit/4.0.2/ivy-grgit-core.xml

    -- artifact org.ajoberstar.grgit#4.0.2;grgit-core!4.0.2.jar:

    /var/jenkins_home/.groovy/grapes/org.ajoberstar.grgit/4.0.2/jars/4.0.2-grgit-core.jar

  ==== localm2: tried

    file:/var/jenkins_home/.m2/repository/org/ajoberstar/grgit/4.0.2/grgit-core/4.0.2-grgit-core.pom

    -- artifact org.ajoberstar.grgit#4.0.2;grgit-core!4.0.2.jar:

    file:/var/jenkins_home/.m2/repository/org/ajoberstar/grgit/4.0.2/grgit-core/4.0.2-grgit-core.jar

  ==== jcenter: tried

    https://jcenter.bintray.com/org/ajoberstar/grgit/4.0.2/grgit-core/4.0.2-grgit-core.pom

    -- artifact org.ajoberstar.grgit#4.0.2;grgit-core!4.0.2.jar:

    https://jcenter.bintray.com/org/ajoberstar/grgit/4.0.2/grgit-core/4.0.2-grgit-core.jar

  ==== ibiblio: tried

    https://repo1.maven.org/maven2/org/ajoberstar/grgit/4.0.2/grgit-core/4.0.2-grgit-core.pom

    -- artifact org.ajoberstar.grgit#4.0.2;grgit-core!4.0.2.jar:

    https://repo1.maven.org/maven2/org/ajoberstar/grgit/4.0.2/grgit-core/4.0.2-grgit-core.jar


:: USE VERBOSE OR DEBUG MESSAGE LEVEL FOR MORE DETAILS
[4.623s][info   ][gc,heap,exit  ] Heap
[4.623s][info   ][gc,heap,exit  ]  garbage-first heap   total 16777216K, used 42609K [0x0000001000800000, 0x00000017c0800000)
[4.623s][info   ][gc,heap,exit  ]   region size 8192K, 7 young (57344K), 2 survivors (16384K)
[4.623s][info   ][gc,heap,exit  ]  Metaspace       used 27090K, capacity 27726K, committed 27904K, reserved 1075200K
[4.623s][info   ][gc,heap,exit  ]   class space    used 2744K, capacity 2963K, committed 3072K, reserved 1048576K
```

### uninstall
```bash
$ grape uninstall org.ajoberstar.grgit grgit-core 4.0.2
[0.006s][warning][gc] -XX:+PrintGC is deprecated. Will use -Xlog:gc instead.
[0.006s][warning][gc] -XX:+PrintGCDetails is deprecated. Will use -Xlog:gc* instead.
[0.032s][info   ][gc,heap] Heap region size: 8M
[1.470s][info   ][gc     ] Using G1
[1.470s][info   ][gc,heap,coops] Heap address: 0x0000001000800000, size: 31744 MB, Compressed Oops mode: Non-zero disjoint base: 0x0000001000000000, Oop shift amount: 3
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.codehaus.groovy.reflection.CachedClass (file:/usr/share/groovy/lib/groovy-2.4.21.jar) to method java.lang.Object.finalize()
WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.reflection.CachedClass
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
setting 'ivy.default.settings.dir' to 'jar:file:/usr/share/groovy/lib/ivy.jar!/org/apache/ivy/core/settings'
setting 'ivy.basedir' to '/var/jenkins_home/.'
setting 'ivy.default.conf.dir' to 'jar:file:/usr/share/groovy/lib/ivy.jar!/org/apache/ivy/core/settings'
setting 'awt.toolkit' to 'sun.awt.X11.XToolkit'
setting 'java.specification.version' to '11'
setting 'sun.cpu.isalist' to ''
setting 'sun.jnu.encoding' to 'UTF-8'
setting 'sun.arch.data.model' to '64'
setting 'java.vendor.url' to 'https://adoptium.net/'
setting 'ivy.message.logger.level' to '4'
setting 'sun.boot.library.path' to '/opt/java/openjdk/lib'
setting 'sun.java.command' to 'org.codehaus.groovy.tools.GroovyStarter --main org.codehaus.groovy.tools.GrapeMain --conf /usr/share/groovy/conf/groovy-starter.conf --classpath . uninstall org.ajoberstar.grgit grgit-core 4.0.2'
setting 'jdk.debug' to 'release'
setting 'jenkins.model.Jenkins.logStartupPerformance' to 'true'
setting 'java.specification.vendor' to 'Oracle Corporation'
setting 'java.version.date' to '2023-10-17'
setting 'java.home' to '/opt/java/openjdk'
setting 'file.separator' to '/'
setting 'java.vm.compressedOopsMode' to 'Non-zero disjoint base'
setting 'line.separator' to '
'
setting 'java.specification.name' to 'Java Platform API Specification'
setting 'java.vm.specification.vendor' to 'Oracle Corporation'
setting 'groovy.grape.report.downloads' to 'true'
setting 'sun.management.compiler' to 'HotSpot 64-Bit Tiered Compilers'
setting 'java.runtime.version' to '11.0.21+9'
setting 'user.name' to 'jenkins'
setting 'file.encoding' to 'UTF-8'
setting 'java.vendor.version' to 'Temurin-11.0.21+9'
setting 'java.io.tmpdir' to '/tmp'
setting 'java.version' to '11.0.21'
setting 'java.vm.specification.name' to 'Java Virtual Machine Specification'
setting 'java.awt.printerjob' to 'sun.print.PSPrinterJob'
setting 'sun.os.patch.level' to 'unknown'
setting 'java.library.path' to '/usr/java/packages/lib:/usr/lib64:/lib64:/lib:/usr/lib'
setting 'java.vendor' to 'Eclipse Adoptium'
setting 'java.specification.maintenance.version' to '2'
setting 'jenkins.install.runSetupWizard' to 'true'
setting 'sun.io.unicode.encoding' to 'UnicodeLittle'
setting 'java.class.path' to '/usr/share/groovy/lib/groovy-2.4.21.jar'
setting 'java.vm.vendor' to 'Eclipse Adoptium'
setting 'script.name' to '/usr/bin/grape'
setting 'user.timezone' to 'America/Los_Angeles'
setting 'jenkins.slaves.NioChannelSelector.disabled' to 'true'
setting 'os.name' to 'Linux'
setting 'java.vm.specification.version' to '11'
setting 'program.name' to 'grape'
setting 'sun.java.launcher' to 'SUN_STANDARD'
setting 'sun.cpu.endian' to 'little'
setting 'user.home' to '/var/jenkins_home'
setting 'tools.jar' to '/opt/java/openjdk/lib/tools.jar'
setting 'user.language' to 'en'
setting 'jsch.client_pubkey' to 'ssh-rsa,ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,rsa-sha2-512,rsa-sha2-256'
setting 'jsch.server_host_key' to 'ssh-rsa,ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,rsa-sha2-512,rsa-sha2-256'
setting 'com.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors' to 'true'
setting 'java.awt.graphicsenv' to 'sun.awt.X11GraphicsEnvironment'
setting 'java.awt.headless' to 'true'
setting 'sessionTimeout' to '1440'
setting 'sessionEviction' to '43200'
setting 'groovy.starter.conf' to '/usr/share/groovy/conf/groovy-starter.conf'
setting 'hudson.model.ParametersAction.keepUndefinedParameters' to 'true'
setting 'path.separator' to ':'
setting 'hudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps' to 'false'
setting 'os.version' to '4.19.12-1.el7.elrepo.x86_64'
setting 'java.runtime.name' to 'OpenJDK Runtime Environment'
setting 'jenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST' to 'true'
setting 'jenkins.slaves.JnlpSlaveAgentProtocol3.enabled' to 'false'
setting 'java.vm.name' to 'OpenJDK 64-Bit Server VM'
setting 'java.vendor.url.bug' to 'https://github.com/adoptium/adoptium-support/issues'
setting 'permissive-script-security.enabled' to 'true'
setting 'user.dir' to '/var/jenkins_home'
setting 'hudson.model.DirectoryBrowserSupport.CSP' to ''
setting 'groovy.home' to '/usr/share/groovy'
setting 'os.arch' to 'amd64'
setting 'hudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID' to 'true'
setting 'java.vm.info' to 'mixed mode'
setting 'java.vm.version' to '11.0.21+9'
setting 'java.class.version' to '55.0'
:: loading settings :: url = jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml
setting 'ivy.settings.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml'
setting 'ivy.conf.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape/defaultGrapeConfig.xml'
setting 'ivy.settings.dir' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.settings.dir.url' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.conf.dir' to 'jar:file:/usr/share/groovy/lib/groovy-2.4.21.jar!/groovy/grape'
setting 'ivy.default.ivy.user.dir' to '/var/jenkins_home/.ivy2'
setting 'ivy.home' to '/var/jenkins_home/.ivy2'
no default ivy user dir defined: set to /var/jenkins_home/.ivy2
setting 'ivy.retrieve.pattern' to '${ivy.lib.dir}/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.configurations' to '*'
setting 'ivy.project.dir' to '${basedir}'
setting 'ivy.resolve.default.type.filter' to '*'
setting 'ivy.deliver.ivy.pattern' to '${ivy.distrib.dir}/[type]s/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.default.always.check.exact.revision' to 'false'
setting 'ivy.status' to 'integration'
setting 'ivy.report.output.pattern' to '[organisation]-[module]-[conf].[ext]'
setting 'ivy.log.modules.in.use' to 'false'
setting 'ivy.publish.src.artifacts.pattern' to '${ivy.distrib.dir}/[type]s/[artifact]-[revision](-[classifier]).[ext]'
setting 'ivy.checksums' to 'sha1,md5'
setting 'ivy.resolver.default.check.modified' to 'false'
setting 'ivy.dep.file' to 'ivy.xml'
setting 'ivy.settings.file' to 'ivysettings.xml'
setting 'ivy.build.artifacts.dir' to '${ivy.project.dir}/build/artifacts'
setting 'ivy.lib.dir' to '${ivy.project.dir}/lib'
setting 'ivy.cache.ttl.default' to '10s'
setting 'ivy.buildlist.ivyfilepath' to 'ivy.xml'
setting 'ivy.distrib.dir' to '${ivy.project.dir}/distrib'
setting 'ivy.cache.dir' to '/var/jenkins_home/.ivy2/cache'
no default cache defined: set to /var/jenkins_home/.ivy2/cache
downloadGrapes: no namespace defined: using system
downloadGrapes: no latest strategy defined: using default
jcenter: no namespace defined: using system
jcenter: no latest strategy defined: using default
cachedGrapes: no namespace defined: using system
cachedGrapes: no latest strategy defined: using default
localm2: no namespace defined: using system
localm2: no latest strategy defined: using default
ibiblio: no namespace defined: using system
ibiblio: no latest strategy defined: using default
'ivy.default.ivy.user.dir' already set: discarding '/var/jenkins_home/.ivy2'
settings loaded (109ms)
  default cache: /var/jenkins_home/.ivy2/cache
  default resolver: downloadGrapes
  default latest strategy: latest-revision
  default conflict manager: latest-revision
  circular dependency strategy: warn
  validate: true
  check up2date: true
  -- 5 resolvers:
  downloadGrapes [chain] [cachedGrapes, localm2, jcenter, ibiblio]
    return first: true
    dual: false
    -> cachedGrapes
    -> localm2
    -> jcenter
    -> ibiblio
  jcenter [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      https://jcenter.bintray.com/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      https://jcenter.bintray.com/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: jcenter
    root: https://jcenter.bintray.com/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  cachedGrapes [file]
    cache: null
    m2compatible: false
    ivy patterns:
      /var/jenkins_home/.groovy/grapes/[organisation]/[module]/ivy-[revision].xml
    artifact patterns:
      /var/jenkins_home/.groovy/grapes/[organisation]/[module]/[type]s/[artifact]-[revision](-[classifier]).[ext]
    repository: cachedGrapes
  localm2 [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
      file:/var/jenkins_home/.m2/repository/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      file:/var/jenkins_home/.m2/repository/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: localm2
    root: file:/var/jenkins_home/.m2/repository/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  ibiblio [ibiblio]
    cache: null
    m2compatible: true
    ivy patterns:
".groovy/grapes/org.ajoberstar.grgit/grgit-core/ivy-4.0.2.xml" [New]
      https://repo1.maven.org/maven2/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    artifact patterns:
      https://repo1.maven.org/maven2/[organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    repository: ibiblio
    root: https://repo1.maven.org/maven2/
    pattern: [organisation]/[module]/[revision]/[artifact]-[revision](-[classifier]).[ext]
    usepoms: true
    useMavenMetadata: true
  module settings:
    NONE
'ivy.cache.dir' already set: discarding '/var/jenkins_home/.groovy/grapes'
setting 'ivy.default.configuration.m2compatible' to 'true'
Deleting grgit-core-4.0.2.jar
[2.232s][info   ][gc,heap,exit ] Heap
[2.232s][info   ][gc,heap,exit ]  garbage-first heap   total 16777216K, used 65536K [0x0000001000800000, 0x00000017c0800000)
[2.232s][info   ][gc,heap,exit ]   region size 8192K, 9 young (73728K), 0 survivors (0K)
[2.232s][info   ][gc,heap,exit ]  Metaspace       used 19909K, capacity 20431K, committed 20608K, reserved 1067008K
[2.232s][info   ][gc,heap,exit ]   class space    used 1961K, capacity 2152K, committed 2176K, reserved 1048576K
```
