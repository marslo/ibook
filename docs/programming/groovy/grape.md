<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [basic usage](#basic-usage)
  - [specify additional repositories](#specify-additional-repositories)
  - [maven classifiers](#maven-classifiers)
  - [excluding transitive dependencies](#excluding-transitive-dependencies)
  - [jdbc drivers](#jdbc-drivers)
  - [using grape from the groovy shell](#using-grape-from-the-groovy-shell)
- [settings](#settings)
  - [proxy settings](#proxy-settings)
  - [logging](#logging)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='info' %}
> references:
> - [Dependency management with Grape](http://docs.groovy-lang.org/latest/html/documentation/grape.html)
> - [GROOVY-7833](https://issues.apache.org/jira/browse/GROOVY-7833)
> - [releases/org/jenkins-ci/main/jenkins-core](https://repo.jenkins-ci.org/artifactory/releases/org/jenkins-ci/main/jenkins-core/)
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
