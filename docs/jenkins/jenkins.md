<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [basic](#basic)
  - [Java requirements](#java-requirements)
  - [CPS](#cps)
  - [Viewing Jenkins Jobs' Configuration as XML](#viewing-jenkins-jobs-configuration-as-xml)
  - [using style in Jenkins](#using-style-in-jenkins)
- [crumb issuer](#crumb-issuer)
  - [get crumb](#get-crumb)
  - [visit API via crumb](#visit-api-via-crumb)
  - [restart Jenkins instance](#restart-jenkins-instance)
- [run Jenkins](#run-jenkins)
  - [in docker](#in-docker)
  - [in kubernetes](#in-kubernetes)
  - [via helm](#via-helm)
  - [troubleshooting](#troubleshooting)
- [build Jenkins docker image](#build-jenkins-docker-image)
- [run Jenkins API out of Jenkins](#run-jenkins-api-out-of-jenkins)
  - [jenkins-core](#jenkins-core)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [CloudBeesTV](https://www.youtube.com/@CloudBeesTV)
> - [Jenkins Tutorials](https://www.youtube.com/playlist?list=PLvBBnHmZuNQJeznYL2F-MpZYBUeLIXYEe)
> - [Jenkins Plugin Developer Series](https://www.youtube.com/playlist?list=PLvBBnHmZuNQIb4p2t69dgMQyGbzb8qr4T)
> - [Jenkins X](https://www.youtube.com/playlist?list=PLvBBnHmZuNQJxNWu6X-5pqpAxRCQEWRGn)
> - [CloudBees CI](https://docs.cloudbees.com/docs/cloudbees-ci/latest/)
{% endhint %}

## basic

### [Java requirements](https://www.jenkins.io/doc/administration/requirements/java/)

> [!NOTE]
> Jenkins requires Java 11 or 17 since Jenkins 2.357 and LTS 2.361.1. [Read more about this in the announcement blog post](https://www.jenkins.io/blog/2022/06/28/require-java-11/)
> - [Jenkins requires Java 11 or newer](https://www.jenkins.io/blog/2022/06/28/require-java-11/)
>
> proxy
> - [Setting JVM Options for Application Servers](https://community.jaspersoft.com/documentation/jasperreports-server-community-install-guide/v56/setting-jvm-options-application)
> - [ava HotSpot VM Command-Line Options](https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/clopts001.html)

### CPS

{% hint style='tip' %}
> references:
> - [Jenkins Pipelines Generator](https://jenkinspipelinegenerator.octopus.com/#/)
> - [Configuring Content Security Policy](https://www.jenkins.io/doc/book/security/configuring-content-security-policy/)
> - [Rendering User Content](https://www.jenkins.io/doc/book/security/user-content/)
> - [How to Serve Resources from Jenkins](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/how-to-serve-resources-from-jenkins)
> - [Content Security Policy (CSP) for Web Report](https://kb.froglogic.com/squish/integrations/jenkins/content-security-policy-csp-web-report/)
> - [Unable to embed Jenkins page into an iframe. How to fix it?](http://help.collab.net/index.jsp?topic=/teamforge820/faq/embedjenkinsintoiframe.html)
> - [Continuous Integration series](https://octopus.com/blog/tag/CI%20Series)
>   - [Multi-environment deployments with Jenkins and Octopus](https://octopus.com/blog/multi-environment-deployments-jenkins)
>   - [Deploying to Amazon EKS with Docker and Jenkins](https://octopus.com/blog/jenkins-eks-ecr-deployment)
>   - [Building a Docker image in Jenkinsfile and publishing to ECR](https://octopus.com/blog/jenkins-docker-ecr)
>   - [Deploying to Amazon EKS with Docker and Jenkins](https://octopus.com/blog/jenkins-eks-ecr-deployment)
>   - [Jenkins security tips](https://octopus.com/blog/jenkins-security-tips)
>   - [How to install a Jenkins instance with Helm](https://octopus.com/blog/jenkins-helm-install-guide)
>   - [How to install Jenkins on Docker](https://octopus.com/blog/jenkins-docker-install-guide)
>   - [Using dynamic build agents to automate scaling in Jenkins](https://octopus.com/blog/jenkins-dynamic-build-agents)
>
> Jenkins & Python
> - [Setting Jenkins CI for python application](https://mdyzma.github.io/2017/10/14/python-app-and-jenkins/)
> - [Jenkins and Python](https://www.jenkins.io/solutions/python/)
>
> others
> - [Where to download hudson library?](https://stackoverflow.com/questions/42225586/where-to-download-hudson-library)
> - [Hooking into the Jenkins (Hudson) API, Part 1](https://www.javacodegeeks.com/2012/08/hooking-into-jenkins-hudson-api-part-1.html)
> - [Hooking into the Jenkins (Hudson) API, Part 2](https://www.javacodegeeks.com/2012/08/hooking-into-jenkins-hudson-api-part-2.html)
> - [How to import the class hudson outside jenkins?](https://coderanch.com/t/733088/languages/import-class-hudson-jenkins)
> - [org.jenkins-ci.main » jenkins-core](https://mvnrepository.com/artifact/org.jenkins-ci.main/jenkins-core)
>
> war packages
> - [Jenkins Custom WAR Packager](https://hub.docker.com/r/jenkins/custom-war-packager)
{% endhint %}


The default rule set results in the following:
- No JavaScript allowed at all
- No plugins (object/embed) allowed
- No inline CSS, or CSS from other sites allowed
- No images from other sites allowed
- No frames allowed
- No web fonts allowed
- No XHR/AJAX allowed


### [Viewing Jenkins Jobs' Configuration as XML](https://www.jvt.me/posts/2019/11/29/jenkins-config-xml/)
1. install [Job Configuration History](https://plugins.jenkins.io/jobConfigHistory/)
2. open in browser:
  ```bash
  job url   : http: //localhost:8080/job/<job-name>/
  conig url : http: //localhost:8080/job/<job-name>/config.xml
  ```

### using style in Jenkins

{% hint style='tip' %}
> references:
> - [* imarslo: css alert](../tools/css.html#alert)
> - [The Curious Case of the Slow Jenkins Job](https://marcesher.com/2017/06/27/the-curious-case-of-the-slow-jenkins-job/)
{% endhint %}

- [bootstrap alert](../tools/css.html#bootstrap-alert)
  ![bootstrap 5.x alert css](../screenshot/jenkins/description-bootstrap-5.x-alert-css.png)

- [callout](../tools/css.html#callout)
  ![callout css](../screenshot/jenkins/description-callout-css.png)

- success
  ```html
  <div style="position:relative; padding:1rem 1rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.375rem; padding-right:3rem; color:#0f5132; background-color:#d1e7dd; border-color:#badbcc">
    <h4 style="font-size: 1.5rem; color: inherit; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Success Alert !</h4>
    This is a success alert with <a href="#" style="font-weight:700; color:#0c4128">an example link</a>. Give it a click if you like.
  </div>
  ```

- warning
  ```html
  <div style="position:relative; padding:1rem 1rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.375rem; padding-right:3rem; color:#664d03; background-color:#fff3cd; border-color:#ffecb5">
    <h4 style="font-size: 1.5rem; color: #523e02; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Warning Alert !</h4>
    This is a warning alert with <a href="#" style="font-weight:700; color:#523e02">an example link</a>. Give it a click if you like.
  </div>
  ```

- info
  ```html
  <div style="position:relative; padding:1rem 1rem; margin-bottom:1rem; border:1px solid transparent; border-radius:.375rem; padding-right:3rem; color:#055160; background-color:#cff4fc; border-color:#b6effb">
    <h4 style="font-size: 1.5rem; color:inherit; margin-top:0;margin-bottom:.5rem;font-weight:500;line-height:1.2">Info Alert !</h4>
    This is a info alert with <a href="#" style="font-weight:700; color:#04414d">an example link</a>. Give it a click if you like.
  </div>
  ```

## crumb issuer

{% hint style='tip' %}
> more info:
> - [CSRF Protection Explained](https://support.cloudbees.com/hc/en-us/articles/219257077-CSRF-Protection-Explained)
> - [Improved CSRF protection](https://jenkins.io/redirect/crumb-cannot-be-used-for-script)
> - [CSRF Protection](https://www.jenkins.io/doc/book/using/remote-access-api/#RemoteaccessAPI-CSRFProtection)
> - [Remote Access API](https://www.jenkins.io/doc/book/using/remote-access-api/)
> - [Jenkins REST API example using crumb](https://gist.github.com/dasgoll/455522f09cb963872f64e23bb58804b2)
> - [About the Jenkins infrastructure project](https://www.jenkins.io/projects/infrastructure/#jenkins)
> - [jenkins on jenkins](https://github.com/jenkins-infra/documentation/blob/main/ci.adoc#jenkins-on-jenkins)
> - [ci.jenkins.io](https://ci.jenkins.io/)
>   - [azure.ci.jenkins.io.yaml](https://github.com/jenkins-infra/jenkins-infra/blob/production/hieradata/clients/azure.ci.jenkins.io.yaml)
>   - [trusted-ci.yaml](https://github.com/jenkins-infra/jenkins-infra/blob/production/hieradata/clients/trusted-ci.yaml)
{% endhint %}


### get crumb

{% hint style='tip' %}
> [`jq` for multiple values](https://github.com/stedolan/jq/issues/785#issuecomment-101475408) and [another answer](https://github.com/stedolan/jq/issues/785#issuecomment-101842421)
{% endhint %}

- via groovy script
  ```groovy
  import hudson.security.csrf.DefaultCrumbIssuer

  DefaultCrumbIssuer issuer = jenkins.model.Jenkins.instance.crumbIssuer
  jenkinsCrumb = "${issuer.crumbRequestField}:${issuer.crumb}"
  ```
  - result
    ```groovy
    println jenkinsCrumb
    Jenkins-Crumb:7248f4a5***********
    ```

- via curl
  ```bash
  $ domain='jenkins.marslo.com'
  $ COOKIEJAR="$(mktemp)"
  $ curl -s \
         --cookie-jar "${COOKIEJAR} \
         https://${domain}/crumbIssuer/api/json |
         jq -r '[.crumbRequestField, .crumb] | "\(.[0]):\(.[1])"'
  Jenkins-Crumb:8b87b6ed98ef923******
  ```
  - or [imarslo: json cheatsheet](../cheatsheet/character/json.html#join)
    ```bash
    $ domain='jenkins.marslo.com'
    $ COOKIEJAR="$(mktemp)"
    $ curl -sSLg \
           --cookie-jar "${COOKIEJAR} \
           https://${domain}/crumbIssuer/api/json |
           jq -r '.crumbRequestField + ":" + .crumb'
    ```

  - [or](https://github.com/stedolan/jq/issues/785#issuecomment-574836419)
    ```bash
    $ COOKIEJAR="$(mktemp)"
    $ curl -s \
           --cookie-jar "${COOKIEJAR} \
           http://jenkins.marslo.com/crumbIssuer/api/json |
           jq -r '[.crumbRequestField, .crumb] | join(":")'
    ```

  - [or via xml](https://www.bbsmax.com/A/x9J2bBxgJ6/)
    ```bash
    $ COOKIEJAR="$(mktemp)"
    $ curl -sSLg \
           --cookie-jar "${COOKIEJAR} \
           "http://${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)"
    Jenkins-Crumb:8b87b6ed98ef923******
    ```

- via web page
  ![jenkins crumb](../screenshot/jenkins/jenkins-crumb.png)

- [via wget](https://support.cloudbees.com/hc/en-us/articles/219257077-CSRF-Protection-Explained?mobile_site=false#usingwget)
  - after jenkins [`2.176.2`](https://www.jenkins.io/security/advisory/2019-07-17/#SECURITY-626)
    ```bash
    # via xml api
    $ COOKIEJAR="$(mktemp)"
    $ wget --user=admin \
           --password=admin \
           --auth-no-challenge \
           --save-cookies "${COOKIEJAR}" \
           --keep-session-cookies \
           -q \
           --output-document \
           - \
           "https://localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")"

    # via json api
    $ COOKIEJAR="$(mktemp)"
    $ wget --user=admin \
           --password=admin \
           --auth-no-challenge \
           --save-cookies "${COOKIEJAR}" \
           --keep-session-cookies \
           -q \
           --output-document \
           - \
           'https://jenkins.marslo.com/crumbIssuer/api/json' |
           jq -r '[.crumbRequestField, .crumb] | join(":")'
    ```

  - before jenkins [`2.176.2`](https://www.jenkins.io/security/advisory/2019-07-17/#SECURITY-626)
    ```bash
    # via xml
    $ wget --user=admin \
           --password=admin \
           --auth-no-challenge \
           -q \
           --output-document \
           - \
           'http://localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'

    # via json
    $ wget --user=admin \
           --password=admin \
           --auth-no-challenge \
           -q \
           --output-document \
           - \
           'https://jenkins.marslo.com/crumbIssuer/api/json' |
           jq -r '[.crumbRequestField, .crumb] | join(":")'
    ```

### visit API via crumb

{% hint style='tip' %}
**@Current after [`2.176.2`](https://www.jenkins.io/security/advisory/2019-07-17/#SECURITY-626)**
```bash
COOKIEJAR="$(mktemp)"
CRUMB=$(curl -u "admin:admin" \
             --cookie-jar "${COOKIEJAR}" \
             'https://jenkins.marslo.com/crumbIssuer/api/json' |
             jq -r '[.crumbRequestField, .crumb] | join(":")'
      )
```

@Dprecated before jenkins `2.176.2`
```bash
url='http://jenkins.marslo.com'

CRUMB="$(curl -sSLg ${url}/crumbIssuer/api/json |
         jq -r .crumb \
       )"
CRUMB="Jenkins-Crumb:${CRUMB}"

# or
CRUMB="$(curl -s ${url}/crumbIssuer/api/json |
         jq -r '.crumbRequestField + ":" + .crumb' \
       )"

```
{% endhint %}

```bash
$ COOKIEJAR="$(mktemp)"
$ CRUMB=$(curl -u "admin:admin" \
             --cookie-jar "${COOKIEJAR}" \
             'https://jenkins.marslo.com/crumbIssuer/api/json' |
             jq -r '[.crumbRequestField, .crumb] | join(":")'
       )
$ curl -H "${CRUMB}" \
          -d 'cities=Lanzhou' \
          http://jenkins.marslo.com/job/marslo/job/sandbox/buildWithParameters
```
- or
  ```bash
  $ domain='jenkins.marslo.com'
  $ url="https://${domain}"
  $ COOKIEJAR="$(mktemp)"
  $ curl -H "$(curl -s \
                    --cookie-jar "${COOKIEJAR}" \
                    ${url}/crumbIssuer/api/json |
                    jq -r '.crumbRequestField + ":" + .crumb' \
              )" \
            -d 'cities=Lanzhou' \
            ${url}/job/marslo/job/sandbox/buildWithParameters
  ```

- [or](https://www.jenkins.io/doc/book/using/remote-access-api/#RemoteaccessAPI-Submittingjobs)
  ```bash
  $ curl -H "Jenkins-Crumb:${CRUMB}" \
            --data 'cities=Leshan,Chengdu' \
            --data 'provinces=Sichuan' \
            http://jenkins.marslo.com/job/marslo/job/sandbox/buildWithParameters
  ```

- or
  ```bash
  $ domain='jenkins.marslo.com'
  $ url="https://${domain}"
  $ curl -H "$(curl -s ${url}/crumbIssuer/api/json | jq -r '.crumbRequestField + ":" + .crumb')" \
            --data 'cities=Leshan,Chengdu' \
            --data 'provinces=Sichuan' \
            ${url}/job/marslo/job/sandbox/buildWithParameters
  ```

#### [build a job using the REST API and cURL](https://support.cloudbees.com/hc/en-us/articles/218889337-How-to-build-a-job-using-the-REST-API-and-cURL-)
```bash
$ curl -X POST http://developer:developer@localhost:8080/job/test/build
# build with parameters
$ curl -X POST \
          http://developer:developer@localhost:8080/job/test/build \
          --data-urlencode json='{"parameter": [{"name":"paramA", "value":"123"}]}'
```

### [restart Jenkins instance](https://support.cloudbees.com/hc/en-us/articles/216118748-How-to-Start-Stop-or-Restart-your-Instance-)

{% hint style='tip' %}
**@Current after [`2.176.2`](https://www.jenkins.io/security/advisory/2019-07-17/#SECURITY-626)**
```bash
COOKIEJAR="$(mktemp)"
CRUMB=$(curl -u "admin:admin" \
             --cookie-jar "${COOKIEJAR}" \
             'https://jenkins.marslo.com/crumbIssuer/api/json' |
             jq -r '[.crumbRequestField, .crumb] | join(":")'
      )
```

@Dprecated before jenkins `2.176.2`
```bash
CRUMB="$(curl -sSLg http://jenkins.marslo.com/crumbIssuer/api/json |
         jq -r .crumb \
      )"
CRUMB="Jenkins-Crumb:${CRUMB}"
# or
CRUMB="$(curl -s ${url}/crumbIssuer/api/json |
         jq -r '.crumbRequestField + ":" + .crumb' \
      )"
```
{% endhint %}

```bash
$ curl -X POST \
       -H "${CRUMB}" \
       http://jenkins.marslo.com/safeRestart
```
- or
  ```bash
  $ domain='jenkins.marslo.com'
  $ url="https://${domain}"
  $ COOKIEJAR="$(mktemp)"
  $ curl -X POST \
         -H "$(curl -s \
                    --cookie-jar "${COOKIEJAR}" \
                    ${url}/crumbIssuer/api/json |
                    jq -r '.crumbRequestField + ":" + .crumb' \
            )" \
         ${url}/safeRestart
  ```

## run Jenkins

{% hint style='tip' %}
> refernce:
> - [How to install Jenkins on Docker](https://octopus.com/blog/jenkins-docker-install-guide)
> - [Jenkins Features Controlled with System Properties](https://www.jenkins.io/doc/book/managing/system-properties/)
> - [-Dhudson.security.ArtifactsPermission=true](https://github.com/jenkinsci/docker/issues/202#issuecomment-244321911)
> - [remoting configuration](https://github.com/jenkinsci/remoting/blob/master/docs/configuration.md)
> - [IMPORTANT JENKINS COMMAND](https://rajeevtechblog.wordpress.com/2018/09/28/important-jenkins-command/)
> - [unable to deactivate CSRF via JCasC](https://github.com/jenkinsci/configuration-as-code-plugin/issues/1184)
{% endhint %}

> [!TIP|label: latest jdk11 JAVA_OPT:]
> ```bash
> -Duser.timezone='America/Los_Angeles'
> -Dhudson.model.DirectoryBrowserSupport.CSP=""
> -Djenkins.slaves.NioChannelSelector.disabled=true
> -Djenkins.slaves.JnlpSlaveAgentProtocol3.enabled=false
> -Djava.awt.headless=true
> -Djenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST=true
> -Dhudson.model.ParametersAction.keepUndefinedParameters=true
> -Dcom.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors=true
> -Djenkins.install.runSetupWizard=true
> -Dpermissive-script-security.enabled=true
> -DsessionTimeout=1440
> -DsessionEviction=43200
> -Dgroovy.grape.report.downloads=true
> -Divy.message.logger.level=4
> -Dhudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps=false
> -Dfile.encoding=UTF-8
> -Dsun.jnu.encoding=utf-8
> -Djenkins.model.Jenkins.logStartupPerformance=true
> -Dhudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID=true
> -Xms192g
> -Xmx192g
> -XX:+AlwaysPreTouch
> -XX:+HeapDumpOnOutOfMemoryError
> -XX:+UseG1GC
> -XX:+UseStringDeduplication
> -XX:+UseCompressedClassPointers
> -XX:+UseCompressedOops
> -XX:+ParallelRefProcEnabled
> -XX:+UnlockDiagnosticVMOptions
> -XX:+UnlockExperimentalVMOptions
> -XX:G1NewSizePercent=20
> -XX:+PrintGC
> -XX:+PrintGCDetails
> -XX:+LogVMOutput
> -XX:InitialRAMPercentage=50.0
> -XX:MaxRAMPercentage=50.0
> -XX:HeapDumpPath=/var/jenkins_home/logs
> -XX:ErrorFile=/var/jenkins_home/logs/hs_err_%p.log
> -XX:LogFile=/var/jenkins_home/logs/jvm.log
> -Xlog:gc*=info,gc+heap=debug,gc+ref*=debug,gc+ergo*=trace,gc+age*=trace:file=/var/jenkins_home/logs/gc-%t.log:utctime,pid,level,tags:filecount=2,filesize=100M
> ```

### in docker
```bash
$ docker run \
         --name jenkins \
         --rm \
         --detach   \
         --network jenkins \
         --env DOCKER_HOST=tcp://docker:2376   \
         --env DOCKER_CERT_PATH=/certs/client \
         --env DOCKER_TLS_VERIFY=1   \
         --publish 8080:8080 \
         --publish 50000:50000   \
         --volume jenkins-data:/var/jenkins_home   \
         --volume jenkins-docker-certs:/certs/client:ro   \
         jenkins/jenkins:latest
```

- docker run with `JAVA_OPTS`

  > [!TIP]
  > more on [Properties in Jenkins Core for `JAVA_OPTS`](config/config.html#properties-in-jenkins-core-for-javaopts)
  > - [encoding](https://stackoverflow.com/a/60419856/2940319)
  > - [How locale setting can break unicode/UTF-8 in Java/Tomcat](https://www.jvmhost.com/articles/locale-breaks-unicode-utf-8-java-tomcat/)

  ```bash
  $ docker run \
           --name jenkins \
           --detach   \
           --rm \
           --network jenkins \
           --env DOCKER_HOST=tcp://docker:2376   \
           --env DOCKER_CERT_PATH=/certs/client \
           --env DOCKER_TLS_VERIFY=1   \
           --publish 8080:8080 \
           --publish 50000:50000   \
           --env JENKINS_ADMIN_ID=admin \
           --env JENKINS_ADMIN_PW=admin \
           --env JAVA_OPTS=" \
                  -XX:+UseG1GC \
                  -Xms8G  \
                  -Xmx16G \
                  -Dfile.encoding=UTF-8 \
                  -Dsun.jnu.encoding=utf-8 \
                  -DsessionTimeout=1440 \
                  -DsessionEviction=43200 \
                  -Djava.awt.headless=true \
                  -Djenkins.ui.refresh=true \
                  -Divy.message.logger.level=4 \
                  -Dhudson.Main.development=true \
                  -Duser.timezone='Asia/Chongqing' \
                  -Dgroovy.grape.report.downloads=true \
                  -Djenkins.install.runSetupWizard=true \
                  -Dpermissive-script-security.enabled=true \
                  -Dhudson.footerURL=https://jenkins.marslo.com \
                  -Djenkins.slaves.NioChannelSelector.disabled=true \
                  -Djenkins.slaves.JnlpSlaveAgentProtocol3.enabled=false \
                  -Dhudson.model.ParametersAction.keepUndefinedParameters=true \
                  -Djenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST=true \
                  -Dhudson.security.ArtifactsPermission=true \
                  -Dhudson.security.LDAPSecurityRealm.groupSearch=true \
                  -Dhudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID=true \
                  -Dcom.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors=true \
                  -Dhudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps=false \
                  -Dhudson.model.DirectoryBrowserSupport.CSP=\"sandbox allow-same-origin allow-scripts; default-src 'self'; script-src * 'unsafe-eval'; img-src *; style-src * 'unsafe-inline'; font-src *;\" \
                " \
           --env JNLP_PROTOCOL_OPTS="-Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=false" \
           --volume /opt/JENKINS_HOME:/var/jenkins_home \
           --volume /var/run/docker.sock:/var/run/docker.sock \
           jenkins/jenkins:latest
  ```

#### backup the docker volume
```bash
$ docker run --rm \
             -v jenkins_home:/var/jenkins_home \
             -v $(pwd):/backup \
             ubuntu \
             tar cvf /backup/backup.tar /var/jenkins_home
```

#### running docker images as services
```bash
$ cat /etc/systemd/system/docker-jenkins.service

[Unit]
Description=Jenkins

[Service]
SyslogIdentifier=docker-jenkins
ExecStartPre=-/usr/bin/docker create -m 0b -p 8080:8080 -p 50000:50000 --restart=always --name jenkins jenkins/jenkins:lts-jdk11
ExecStart=/usr/bin/docker start -a jenkins
ExecStop=-/usr/bin/docker stop --time=0 jenkins

[Install]
WantedBy=multi-user.target

$ sudo systemctl daemon-reload
$ sudo systemctl enable docker-jenkins
$ sudo systemctl start docker-jenkins

# check log
$ sudo journalctl -u docker-jenkins -f
```

### in kubernetes

{% hint style='tip' %}
> reference:
> - [official yaml](https://github.com/jenkinsci/kubernetes-plugin/blob/master/src/main/kubernetes/jenkins.yml)
> - [official sa yaml](https://github.com/jenkinsci/kubernetes-plugin/blob/master/src/main/kubernetes/service-account.yml)
{% endhint %}

```bash
$ cat << EOF | kubectl apply -f -
# namespace
---
kind: Namespace
apiVersion: v1
metadata:
  name: devops
  labels:
    name: devops

# quota
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: quota
  namespace: devops
spec:
  hard:
    requests.cpu: "48"
    requests.memory: 48Gi
    limits.cpu: "48"
    limits.memory: 48Gi

# sa
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: jenkins
  name: jenkins-admin
  namespace: devops
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: jenkins-admin
  labels:
    k8s-app: jenkins
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: jenkins-admin
  namespace: devops

# pv & pvc
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: jenkins-pv
spec:
  capacity:
    storage: 200Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 1.2.3.4
    path: "/jenkins_vol/jenkins/DEVOPS_JENKINS"
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: jenkins-pvc
  namespace: devops
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 100Gi
  storageClassName: ""
  volumeName: jenkins-pv

# deploy
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins
  namespace: devops
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/hostname
                operator: In
                values:
                - aws-hostname-01
                - aws-hostname-02
      containers:
        - name: jenkins
          image: jenkins/jenkins:latest
          imagePullPolicy: IfNotPresent
          env:
            - name: JAVA_OPTS
              value: -Xms2048m
                     -Xmx10240m
                     -XX:PermSize=2048m
                     -XX:MaxPermSize=10240m
                     -DsessionTimeout=1440
                     -DsessionEviction=43200
                     -Djava.awt.headless=true
                     -Divy.message.logger.level=4
                     -Dfile.encoding=UTF-8
                     -Dsun.jnu.encoding=utf-8
                     -Duser.timezone='Asia/Chongqing'
                     -Djenkins.install.runSetupWizard=true
                     -Dpermissive-script-security.enabled=true
                     -Djenkins.slaves.NioChannelSelector.disabled=true
                     -Djenkins.slaves.JnlpSlaveAgentProtocol3.enabled=false
                     -Djenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST=true
                     -Dhudson.model.ParametersAction.keepUndefinedParameters=true
                     -Dcom.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors=true
                     -Dhudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps=false
                     -Dhudson.model.DirectoryBrowserSupport.CSP="sandbox allow-same-origin allow-scripts; default-src 'self'; script-src * 'unsafe-eval'; img-src *; style-src * 'unsafe-inline'; font-src *;"
            - name: JNLP_PROTOCOL_OPTS
              value: -Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=false
          ports:
            - name: http-port
              containerPort: 8080
            - name: jnlp-port
              containerPort: 50000
            - name: cli-port
              containerPort: 38338
          volumeMounts:
            - name: jenkins-home
              mountPath: /var/jenkins_home
          resources:
            requests:
              memory: '8Gi'
              cpu: '8'
            limits:
              memory: '16Gi'
              cpu: '16'
      volumes:
        - name: jenkins-home
          persistentVolumeClaim:
            claimName: jenkins-pvc
      serviceAccount: "jenkins-admin"

# svc
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins
  namespace: devops
spec:
  template:
    metadata:
      labels:
        name: jenkins
spec:
  type: ClusterIP
  ports:
    - name: jenkins
      port: 8080
      targetPort: 8080
  selector:
    app: jenkins
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-discovery
  namespace: devops
spec:
  template:
    metadata:
      labels:
        name: jenkins-discovery
spec:
  type: NodePort
  ports:
    - name: jenkins-agent
      port: 50000
      targetPort: 50000
    - name: cli-agent
      port: 38338
      targetPort: 38338
  selector:
    app: jenkins

# ing (for traefik ingress)
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: jenkins
  namespace: devops
  annotations:
    kubernetes.io/ingress.class: traefik
    ingress.kubernetes.io/whitelist-x-forwarded-for: "false"
    traefik.frontend.redirect.entryPoint: https
    ingress.kubernetes.io/ssl-redirect: "true"
  labels:
    app: jenkins
spec:
  rules:
  - host: jenkins.mysite.com
    http:
      paths:
      - backend:
          serviceName: jenkins
          servicePort: 8080
  tls:
  - hosts:
    - jenkins.mysite.com
    secretName: mysite-tls
EOF
```

- for nginx ingress
  ```bash
  ---
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    name: jenkins
    namespace: devops
    annotations:
      kubernetes.io/ingress.class: "nginx"
      nginx.ingress.kubernetes.io/secure-backends: "true"
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
      kubernetes.io/ingress.allow-http: "false"
  spec:
    tls:
    - hosts:
      - jenkins.mysite.com
      secretName: mysite-certs
    rules:
    - host: jenkins.mysite.com
      http:
        paths:
        - path:
          backend:
            serviceName: jenkins
            servicePort: 8080
  ```

### via helm

> [!TIP]
> - [How to install a Jenkins instance with Helm](https://octopus.com/blog/jenkins-helm-install-guide)
> - [OctopusSamples/jenkins-complete-image](https://github.com/OctopusSamples/jenkins-complete-image)

```bash
$ helm repo add jenkins https://charts.jenkins.io
$ helm repo update

$ helm upgrade --install myjenkins jenkins/jenkins

$ kubectl exec --namespace default \
               -it svc/myjenkins \
               -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
```

#### forward port
```bash
$ kubectl --namespace default port-forward svc/myjenkins 8080:8080
```

#### show Load Balancer
```bash
$ helm show values jenkins/jenkins
...
controller:
  serviceType: LoadBalancer
...
```

#### upgrade
```bash
$ helm upgrade --install -f values.yaml myjenkins jenkins/jenkins
```

#### get info
```bash
$ kubectl get svc --namespace default myjenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}"
a84aa6226d6e5496882cfafdd6564a35-901117307.us-west-1.elb.amazonaws.com

$ kubectl get pods
NAME                                     READY   STATUS              RESTARTS   AGE
java-9-k0hmj-vcvdz-wknh4                 0/1     ContainerCreating   0          1s
myjenkins-0                              2/2     Running             0          49m
```

#### customizing

##### installing additional plugins
```yaml
...
controller:
    additionalPlugins:
    - octopusdeploy:3.1.6
...
```

##### customizing jenkins docker image
```yaml
...
controller:
  image: "docker.io/mcasperson/myjenkins"
  tag: "latest"
  installPlugins: false
...
```

##### adding jenkins agents
```yaml
...
agent:
  podName: default
  customJenkinsLabels: default
  resources:
    limits:
      cpu: "1"
      memory: "2048Mi"
...
```

- defines a second pod template
  ```yaml
  ...
  agent:
    podName: default
    customJenkinsLabels: default
    resources:
      limits:
        cpu: "1"
        memory: "2048Mi"
  additionalAgents:
    maven:
      podName: maven
      customJenkinsLabels: maven
      image: jenkins/jnlp-agent-maven
      tag: latest
  ...
  ```
  - jenkinsfile
    ```groovy
    pipeline {
      agent {
          kubernetes {
              inheritFrom 'maven'
          }
      }
      // ...
    }
    ```

#### backup jenkins home
```bash
$ kubectl exec -c jenkins myjenkins-0 -- tar czf /tmp/backup.tar.gz /var/jenkins_home
$ kubectl cp -c jenkins myjenkins-0:/tmp/backup.tar.gz ./backup.tar.gz
```

### troubleshooting

> [!NOTE|label:references:]
> - [CloudBees Jenkins JVM troubleshooting](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#recommended-options)
> - [Prepare Jenkins for Support](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/best-practices/prepare-jenkins-for-support)
> - [How to Troubleshoot and Address Jenkins Startup Performances](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/troubleshooting-guides/jenkins-startup-performances)
> - [Required Data: Jenkins Hang Issue On Linux](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/required-data/required-data-hang-issue-on-linux-cjp)
> - [collectPerformanceData Script](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#running-collectPerformanceData)
>   - [collectPerformanceData.sh](https://s3.amazonaws.com/cloudbees-jenkins-scripts/e206a5-linux/collectPerformanceData.sh)
> - [Understanding Thread Dumps](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#_understanding_thread_dumps)
>   - [fastthread.io](https://fastthread.io/)
> - [gceasy.io](https://gceasy.io/)
> - [What causes high CPU usage and how can I reduce it](https://pc.net/helpcenter/answers/reduce_high_cpu_usage)
>
> - tools:
>   - `iostat`
>   - [`nfsiostat`](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#_nfsiostat)
>   - [`nfsstat`](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#_nfsstat)
>   - [`vmstat`Understanding Thread DumpUnderstanding Thread Dumpss](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#_vmstat)
>   - [`top`](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#_top)
>     - [`top -H`](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#_top_h)
>   - [`netstat`](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#_netstat)
>   - [jstack](https://docs.cloudbees.com/docs/cloudbees-ci/latest/jvm-troubleshooting/#_jstack)
>   - [`stap`](https://man7.org/linux/man-pages/man1/stap.1.html)




## build Jenkins docker image

> [!TIP]
> - [jenkins-complete-image/Dockerfile](https://github.com/OctopusSamples/jenkins-complete-image/blob/main/Dockerfile)

```docker
FROM jenkins/jenkins:lts-jdk11
USER root
RUN apt update && \
    apt install -y --no-install-recommends gnupg curl ca-certificates apt-transport-https && \
    curl -sSfL https://apt.octopus.com/public.key | apt-key add - && \
    sh -c "echo deb https://apt.octopus.com/ stable main > /etc/apt/sources.list.d/octopus.com.list" && \
    apt update && apt install -y octopuscli
RUN jenkins-plugin-cli --plugins octopusdeploy:3.1.6 kubernetes:1.29.2 workflow-aggregator:2.6 git:4.7.1 configuration-as-code:1.52
USER jenkins
```

## run Jenkins API out of Jenkins

{% hint style='tip' %}
> references:
> - [* Jenkins API](https://www.lixin.help/2022/05/07/Jenkins-Api.html)
> - [* Jenkins API - how to trigger a Jenbkins job programmatically](https://www.lenar.io/jenkins-api-trigger-job/)
> - [* Jenkins REST Plugin](https://www.jenkins.io/projects/gsoc/2020/project-ideas/jenkins-rest-plugin/)
>   - [jenkinsci/java-client-api](https://github.com/jenkinsci/java-client-api)
>   - [cdancy/jenkins-rest](https://github.com/cdancy/jenkins-rest)
> - [Dependency management with Grape](http://docs.groovy-lang.org/latest/html/documentation/grape.html)
> - [Hooking into the Jenkins (Hudson) API, Part 1](https://www.javacodegeeks.com/2012/08/hooking-into-jenkins-hudson-api-part-1.html)
> - [Hooking into the Jenkins (Hudson) API, Part 2](https://www.javacodegeeks.com/2012/08/hooking-into-jenkins-hudson-api-part-2.html)
>   - [kellyrob99/Jenkins-api-tour](https://github.com/kellyrob99/Jenkins-api-tour/)
> - [Where to download hudson library?](https://stackoverflow.com/questions/42225586/where-to-download-hudson-library)
> - [XmlPullParserException thrown when trying to run groovy script from within a Jenkins job](https://stackoverflow.com/questions/60546574/xmlpullparserexception-thrown-when-trying-to-run-groovy-script-from-within-a-jen)
> - [How do I Import a Jenkins plugins in Groovyscript?](https://stackoverflow.com/questions/25733960/how-do-i-import-a-jenkins-plugins-in-groovyscript)
> - [How to import the jenkins-api in Groovy?](https://stackoverflow.com/questions/55016767/how-to-import-the-jenkins-api-in-groovy)
> - [What are the Java arguments for proxy authorization?](https://access.redhat.com/solutions/1278523)
> - [Dependencies and Class Loading](https://www.jenkins.io/doc/developer/plugin-development/dependencies-and-class-loading/)
> <br>
> - javadoc
>   - [Package hudson.util](https://javadoc.jenkins.io/hudson/util/package-summary.html)
>   - [Package hudson.model](https://javadoc.jenkins-ci.org/hudson/model/package-summary.html)
> <br>
> - [mvnrepository.com](https://mvnrepository.com/)
>   - [org.eclipse.hudson.main » hudson-core](https://mvnrepository.com/artifact/org.eclipse.hudson.main/hudson-core)
>   - [org.jenkins-ci.main » jenkins-core](https://mvnrepository.com/artifact/org.jenkins-ci.main/jenkins-core)
>   - Pipeline: Job : [org.jenkins-ci.plugins.workflow » workflow-job](https://mvnrepository.com/artifact/org.jenkins-ci.plugins.workflow/workflow-job?repo=jenkins-incrementals)
>   - Pipeline: Groovy : [org.jenkins-ci.plugins.workflow » workflow-cps](https://mvnrepository.com/artifact/org.jenkins-ci.plugins.workflow/workflow-cps)
>   - Pipeline: API : [org.jenkins-ci.plugins.workflow » workflow-api](https://mvnrepository.com/artifact/org.jenkins-ci.plugins.workflow/workflow-api)
>   - Pipeline: Nodes and Processes : [org.jenkins-ci.plugins.workflow » workflow-durable-task-step](https://mvnrepository.com/artifact/org.jenkins-ci.plugins.workflow/workflow-durable-task-step?repo=jenkins-releases)
>   - Pipeline: Parent : [org.jenkins-ci.plugins.workflow » workflow-pom](https://mvnrepository.com/artifact/org.jenkins-ci.plugins.workflow/workflow-pom)
>   - RESTEasy JAX RS Implementation : [org.jboss.resteasy » resteasy-jaxrs](https://mvnrepository.com/artifact/org.jboss.resteasy/resteasy-jaxrs)
>   - RESTEasy Jackson 2 Provider : [org.jboss.resteasy » resteasy-jackson2-provider](https://mvnrepository.com/artifact/org.jboss.resteasy/resteasy-jackson2-provider)
>   - [javax/ws/rs](https://herd.ceylon-lang.org/maven/1/javax/ws/rs/2.0.1)
>     - JAX RS API : [javax.ws.rs » javax.ws.rs](https://mvnrepository.com/artifact/javax.ws.rs/javax.ws.rs?repo=springio-plugins-release)
> - [com/clarolab](https://repo1.maven.org/maven2/com/clarolab/)
> - [maven central](https://search.maven.org/)
> - [maven.glassfish.org](https://maven.glassfish.org/content/groups/public/)
> - [repo.jenkins-ci.org](https://repo.jenkins-ci.org/public/)
>
> - source code
>   - [jenkins/core/src/main/java/jenkins/model/Jenkins.java](https://github.com/jenkinsci/jenkins/blob/master/core/src/main/java/jenkins/model/Jenkins.java)
>
> - more
>   - [JAX-RS](https://access.redhat.com/documentation/ko-kr/red_hat_jboss_enterprise_application_platform/7.3/html/developing_web_services_applications/developing_jax_rs_web_services)
{% endhint %}

```groovy
@GrabResolver(name='jenkins', root='https://repo.jenkins-ci.org/public/')
@Grapes([
  @Grab(group='org.jenkins-ci.main', module='jenkins-core', version='2.167')
])

import hudson.model.*
```

- [or](https://stackoverflow.com/a/55018829/2940319)
  ```groovy
  @GrabResolver(name='jenkins', root='https://repo.jenkins-ci.org/public/')
  @Grab(group='org.jenkins-ci.main', module='jenkins-core', version='2.377')
  ```

### jenkins-core
```groovy
@GrabResolver(name='jenkins', root='https://repo.jenkins-ci.org/releases')
@Grab(group='org.jenkins-ci.main', module='jenkins-core', version='2.377')

import hudson.Util

println Util.XS_DATETIME_FORMATTER.format( new Date() )
```

- result
  ```groovy
  2022-11-23T13:39:34Z
  ```

#### `org.jenkinsci.plugins.workflow`
```groovy
// Groovy Version: 3.0.13 JVM: 11.0.15.1
@GrabResolver(name='jenkins', root='https://repo.jenkins-ci.org/releases')
@Grab(group='org.jenkins-ci.main', module='jenkins-core', version='2.377')
@Grab(group='org.jenkins-ci.plugins.workflow', module='workflow-job', version='1254.v3f64639b_11dd')
@Grab(group='org.jenkins-ci.plugins.workflow', module='workflow-basic-steps', version='991.v43d80fea_ff66', scope='test')
@Grab(group='org.jenkins-ci.plugins.workflow', module='workflow-api', version='1192.v2d0deb_19d212')

import jenkins.model.Jenkins
import hudson.model.Job
import hudson.Util
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.flow.BlockableResume

String rootUrl = 'https://my.jenkins.com'

Map<String, WorkflowJob> jobs = jenkins.getJobs()
println jobs

// output
// Caught: groovy.lang.MissingPropertyException: No such property: jenkins for class: jenkins-job
```

#### [`com.cdancy.jenkins.rest.JenkinsClient`](https://github.com/cdancy/jenkins-rest)

```groovy
@GrabResolver(name='jenkins', root='https://repo.jenkins-ci.org/releases')
@Grab(group='org.jenkins-ci.main', module='jenkins-core', version='2.377')
@Grab(group='org.jenkins-ci.plugins.workflow', module='workflow-api', version='1200.v8005c684b_a_c6')
@Grab(group='org.jenkins-ci.plugins.workflow', module='workflow-job', version='1254.v3f64639b_11dd')
@Grab(group='org.jenkins-ci.plugins.workflow', module='workflow-step-api', version='639.v6eca_cd8c04a_a_')
@Grab(group='javax.ws', module='rs', version='2.0.1')
@Grab(group='io.github.cdancy', module='jenkins-rest', version='1.0.2')

import jenkins.model.Jenkins
import hudson.Util
import hudson.model.Job
import org.jenkinsci.plugins.workflow.job.WorkflowJob

import com.cdancy.jenkins.rest.JenkinsClient

String jenkinsUrl = 'https://my.jenkins.com'
String userName   = 'admin'
String password   = 'admin'

JenkinsClient client = JenkinsClient.builder()
                                    .endPoint( jenkinsUrl )
                                    .credentials( "${userName}:${password}" )
                                    .build();
println client.getClass()
println client.api().systemApi().systemInfo().getClass()
println client.api().getClass()

// Groovy Version: 3.0.13 JVM: 11.0.15.1
// output
// class com.cdancy.jenkins.rest.JenkinsClient
// class com.cdancy.jenkins.rest.domain.system.AutoValue_SystemInfo
// class com.sun.proxy.$Proxy68
```
