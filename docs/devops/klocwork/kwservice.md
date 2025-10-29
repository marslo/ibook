<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [setup server config](#setup-server-config)
- [start/restart service](#startrestart-service)
  - [start database](#start-database)
- [check license status](#check-license-status)
- [get properity](#get-properity)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [Security Best Practices + Klocwork](https://www.perforce.com/blog/kw/security-best-practices)
> - [Klocwork Insight 10.0 SR3 - Installation and Upgrade.pdf](http://cdn-devnet.klocwork.com/documents/members/Klocwork_Installation_and_Upgrade_EN_10_SR3.pdf)
{% endhint %}


## setup server config

> [!TIP]
> - <SERVICE_NAME> can be one of below, check via `$ kwservice list-services`:
>   - database
>   - license
>   - klocwork
> - <PROJECT_ROOT> is the projects_root where the servers are running. can be get via `$ /opt/Klocwork/Server/bin/kwservice check`

```bash
$ kwservice set-service-property klocwork host klocwork.domain.com
Using projects root: /projects/root

$ kwservice check
Using projects root: /projects/root
Local Host is: klocwork-server-7*********-****q [10.244.6.65]
Checking License Server  [running on klocwork-license:443]
Checking Database Server [running on localhost:3306] (projects root is /projects/root)
Checking Klocwork Server [running on klocwork.domain.com:8080]
```

## start/restart service

> [!TIP]
> references:
> - [Managing the Klocwork Servers](https://analyst.phyzdev.net/documentation/help/concepts/managingtheklocworkservers.htm)

- start
  ```bash
  $ kwservice --projects-root /projects/root start
  ```

- restart
  ```bash
  $ kwservice --projects-root /projects/root restart
  Using projects root: /projects/root
  Local Host is: klocwork-server-7*********-****4 [10.244.6.68]
  Re-starting License Server  [already running on klocwork-license:443]
  Re-starting Database Server [started on localhost:3306] (projects root is /projects/root)
  Re-starting Klocwork Server
  ```

- stop
  ```bash
  $ kwservice --projects-root /projects/root stop
  Using projects root: /projects/root
  Local Host is: devops-klocwork-7********b-s***b [10.244.6.81]
  Stopping License Server  [running on l******2:3***8]
  Stopping Database Server [stopped]
  Stopping Klocwork Server [stopped]
  ```

### start database

> [!NOTE|label:klocwork versions]
> `2024.2 Build 24.2.0.84`

```bash
$ /opt/Klocwork/Server/bin/kwservice --projects-root /projects/root stop database
$ /opt/Klocwork/Server/bin/kwservice --projects-root /projects/root start database
```

## check license status

> [!TIP]
> references:
> - [Licensing](https://analyst.phyzdev.net/documentation/help/concepts/licensing.htm)
> - [How licensing works](https://analyst.phyzdev.net/documentation/help/concepts/howlicensingworks.htm)
> - [Can't connect to License Server](https://analyst.phyzdev.net/documentation/help/concepts/cantconnecttolicenseserver.htm)
> - [Changing the vendor daemon port in your license file](https://analyst.phyzdev.net/documentation/help/concepts/changingthevendordaemonportinyourlicensefile.htm)
> - [Licensing with multiple projects_root directories](https://analyst.phyzdev.net/documentation/help/concepts/1licensingwithmultipleprojectsrootdirectories.htm)
> - [Setting up redundant license servers](https://analyst.phyzdev.net/documentation/help/concepts/settingupredundantlicenseservers.htm)
> - [How Structure101 licensing works](https://analyst.phyzdev.net/documentation/help/concepts/howkw101licensingworks.htm)

```bash
$ kwservice --projects-root /projects/root check license
Using projects root: /projects/root
Local Host is: klocwork-server-755dc7966b-ndb94 [10.244.6.68]
Checking License Server  [running on klocwork-license:443]
```

## get properity

> [!NOTE|label:check services]
> ```bash
> $ /opt/Klocwork/Server/bin/kwservice list-services
> License Server (license)
> Database Server (database)
> Klocwork Server (klocwork)
>
> $ /opt/Klocwork/Server/bin/kwservice check
> Using projects root: /projects/root
> Local Host is: devops-klocwork-0.devops-klocwork.namespace.svc.cluster.local [10.244.67.105]
> Checking License Server  [running on klocwork-license-server:33138]
> Checking Database Server [running on localhost:3306] (projects root is /projects/root)
> Checking Klocwork Server [running on localhost:8080] (projects root is /projects/root)
> ```

```bash
# database
$ /opt/Klocwork/Server/bin/kwservice get-service-properties database
#Database Server properties
host=localhost
port=3306
type=mysql
user=kw

# license
$ /opt/Klocwork/Server/bin/kwservice get-service-properties license
#License Server properties
host=klocwork-license-server
port=33138
provider=reprise

# klocwork
$ /opt/Klocwork/Server/bin/kwservice get-service-properties klocwork
#Klocwork Server properties
host=localhost
port=8080
protocol=http
```

!--sec data-title="process details" data-id="section0" data-show=true data-collapse=true ces-->
```bash
$ ps auxfww
USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
klocwork   5071  0.0  0.0   4748  4028 pts/2    Ss   22:54   0:00 /bin/bash
klocwork   6726  0.0  0.0   7072  1584 pts/2    R+   23:48   0:00  \_ ps auxfww
klocwork     80  0.0  0.0   4856  3856 pts/0    Ss+  07:11   0:00 /bin/bash
klocwork      1  0.0  0.0   4500  3000 ?        Ss   07:11   0:00 bash /opt/entrypoint.sh
klocwork     79  0.0  0.0   2828  1000 ?        S    07:11   0:04 tail -F /projects_root/logs/klocwork.log
klocwork   3313  1.3  0.5 10317852 661592 pts/0 Sl   07:42  13:26 /opt/Klocwork/Server/_jvm/bin/java -Djava.util.logging.config.file=/projects_root/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Dklocwork.false_positive_report_enabled=false -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -Dcom.sun.jndi.ldap.connect.pool.protocol=plain ssl -Dcom.sun.jndi.ldap.connect.pool.timeout=300000 -XX:InitialRAMPercentage=30.0 -XX:MaxRAMPercentage=30.0 -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -Dorg.apache.catalina.security.SecurityListener.UMASK=0027 --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.util.concurrent=ALL-UNNAMED --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED -Xmx2048M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/projects_root/logs -Djava.awt.headless=true -Dlax.nl.env.REP_HOME=/opt/Klocwork/Server -DREP_HOME=/opt/Klocwork/Server -Dlax.nl.env.KW_INST_DIR=/opt/Klocwork/Server -Dlax.nl.env.INSIGHT_PROJECTS_ROOT=/projects_root -DINSIGHT_PROJECTS_ROOT=/projects_root -Drmi.host=localhost -Drmi.port=8080 -classpath /opt/Klocwork/Server/3rdparty/tomcat/bin/bootstrap.jar:/opt/Klocwork/Server/3rdparty/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/projects_root/tomcat -Dcatalina.home=/opt/Klocwork/Server/3rdparty/tomcat -Djava.io.tmpdir=/projects_root/tmp org.apache.catalina.startup.Bootstrap start
klocwork   6042 12.5  0.3 21151036 455796 pts/0 Sl   23:39   1:06  \_ /opt/Klocwork/Server/_jvm/bin/java -Dlog4j1.compatibility=true -DREP_WRAPPER_NAME=kwloaddb -Dlax.nl.env.REP_HOME=/opt/Klocwork/Server -Dsun.nio.ch.disableSystemWideOverlappingFileLockCheck=true -Xmx16G -Djava.library.path=/opt/Klocwork/Server/lib64/ix86-pc-linux -classpath /opt/Klocwork/Server/class/dbload.jar com.klocwork.dbload.DatabaseLoadOnlyMain @/projects_root/tmp/options4247484300859495765.list
klocwork   5794  0.0  0.0   2900   976 ?        S    23:21   0:00 /bin/sh -c "/opt/Klocwork/Server/3rdparty/bin/mysqld" "--defaults-file=/opt/Klocwork/Server/config/kwmysql.ini" "--basedir" "/opt/Klocwork/Server/3rdparty" "-h" "/projects_root/data" "-P" "3306" "--socket" "/projects_root/locks/mysql_kw3306.sock" "--pid-file" "/projects_root/locks/mysql_kw3306.pid" "--secure-file-priv=/projects_root/tmp" >>"/projects_root/logs/database.log" 2>&1
klocwork   5795 38.9 11.6 21534044 15314964 ?   Sl   23:21  10:31  \_ /opt/Klocwork/Server/3rdparty/bin/mysqld --defaults-file=/opt/Klocwork/Server/config/kwmysql.ini --basedir /opt/Klocwork/Server/3rdparty -h /projects_root/data -P 3306 --socket /projects_root/locks/mysql_kw3306.sock --pid-file /projects_root/locks/mysql_kw3306.pid --secure-file-priv=/projects_root/tmp
```
<!--endsec-->
