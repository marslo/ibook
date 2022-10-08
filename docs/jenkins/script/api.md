<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [execute Groovy script with an API call](#execute-groovy-script-with-an-api-call)
- [stop build via api](#stop-build-via-api)
- [get builds information](#get-builds-information)
- [list plugins](#list-plugins)
  - [using api (`curl`)](#using-api-curl)
  - [using cli](#using-cli)
- [builds](#builds)
  - [get particular build parameters](#get-particular-build-parameters)
  - [get all parameters via Json format](#get-all-parameters-via-json-format)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> reference:
> - [Example for Jenkins API](https://www.programcreek.com/java-api-examples/?action=search&ClassName=jenkins&submit=Search)
> - [CSRF Protection Explained](https://support.cloudbees.com/hc/en-us/articles/219257077-CSRF-Protection-Explained?mobile_site=false)
> - [Remote access API](https://wiki.jenkins.io/display/JENKINS/Remote+access+API/)
> - [How to build a job using the REST API and cURL?](https://support.cloudbees.com/hc/en-us/articles/218889337-How-to-build-a-job-using-the-REST-API-and-cURL-?page=64)
> - [7 useful Jenkins Rest services](https://www.esentri.com/7-useful-jenkins-rest-services/)

{% hint style='tip' %}
> get crumb and sessoin :
> - [with sessoin (cookie)](../plugins/crumbIssuer.md#working-with-session-after-21762-since-security-626)
> ```bash
> $ COOKIEJAR="$(mktemp)"
> $ CRUMB=$(curl -u "admin:admin" \
>              --cookie-jar "${COOKIEJAR}" \
>              'https://jenkins.marslo.com/crumbIssuer/api/json' |
>              jq -r '[.crumbRequestField, .crumb] | join(":")'
>        )
> ```
> <p></p>
> example for run `safeRestart` api :
> ```bash
> $ COOKIEJAR="$(mktemp)"
> $ CRUMB=$(curl --cookie-jar "${COOKIEJAR}" \
>                "https://jenkins.marslo.com/crumbIssuer/api/json" |
>                jq -r '.crumbRequestField + ":" + .crumb'
>          )
> $ curl -v \
>        -X POST \
>        --cookie "${COOKIEJAR}" \
>        -H "${CRUMB}" \
>        -H "Content-Type: application/json" \
>        -H "Accept: application/json"
>        https://jenkins.marslo.com/safeRestart
> ```
{% endhint %}

## [execute Groovy script with an API call](https://support.cloudbees.com/hc/en-us/articles/217509228-Execute-Groovy-script-in-Jenkins-with-an-API-call)
```bash
$ curl -v \
       --user username:ApiToken \
       -d "script=$(cat /tmp/script.groovy)" \
       --cookie "${COOKIEJAR}" \
       -H "${CRUMB}" \
       http://JENKINS_URL/scriptText

# or
$ curl -v \
       --user username:ApiToken \
       -d "script=println 'this script works'" \
       --cookie "${COOKIEJAR}" \
       -H "${CRUMB}" \
       http://JENKINS_URL/scriptText
```

## [stop build via api](https://www.jenkins.io/doc/book/using/aborting-a-build/)

|        api       | comments                   |
|:----------------:|----------------------------|
| `BUILD_URL/stop` | abort a build              |
| `BUILD_URL/term` | forcibly terminate a build |
| `BUILD_URL/kill` | hard kill a pipeline       |

## get builds information

> [!TIP]
> reference:
> - [USING JENKINS / HUDSON REMOTE API TO CHECK JOBS STATUS](http://blog.dahanne.net/2014/04/02/using-jenkins-hudson-remote-api-to-check-jobs-status/)
> - [justlaputa/jenkins-api.md](https://gist.github.com/justlaputa/5634984)

- [via job api](https://stackoverflow.com/a/25650246/2940319)
  ```bash
  $ curl -sSLg \
         --cookie "${COOKIEJAR}" \
         -H "${CRUMB}" \
         http://jenkins:8080/job/my-job/api/json?tree=builds[id,number,duration,timestamp,builtOn]
  ```

- get particular fields for all builds

  > [!TIP]
  > api format: `api/json?tree=allBuilds[Bartifact,description,building,displayName,duration,estimatedDuration,fullDisplayName,id,number,queueId,result,timestamp,url]`

  ```bash
  $ curl -s \
         --globoff \
         --cookie "${COOKIEJAR}" \
         -H "${CRUMB}" \
         'https://<JENKINS_DOMAIN_NAME>/job/<jobname>/api/json?tree=allBuilds[artifact,description,building,displayName,duration,estimatedDuration,fullDisplayName,id,number,queueId,result,timestamp,url]' |
         jq --raw-output .
  ```

## list plugins
### [using api (`curl`)](https://stackoverflow.com/a/52836951/2940319)
```bash
$ curl -s \
       -u<username>:<password> \
       --cookie "${COOKIEJAR}" \
       -H "${CRUMB}" \
       https://<JENKINS_DOMAIN_NAME>/pluginManager/api/json?depth=1  |
       jq -r '.plugins[] | "\(.shortName):\(.version)"' |
       sort
```

- [or](https://stackoverflow.com/a/17241066/2940319)
  ```bash
  $ curl -s \
         --cookie "${COOKIEJAR}" \
         -H "${CRUMB}" \
         'https://<JENKINS_DOMAIN_NAME>/pluginManager/api/json?pretty=1&tree=plugins\[shortName,longName,version\]'
  {
    "_class": "hudson.LocalPluginManager",
    "plugins": [
      {
        "longName": "SSH Credentials Plugin",
        "shortName": "ssh-credentials",
        "version": "1.18.1"
      },
      {
        "longName": "Configuration as Code Plugin",
        "shortName": "configuration-as-code",
        "version": "1.47"
      },
      ...
  }
  ```

### [using cli](https://stackoverflow.com/a/44979051/2940319)
```bash
$ cat plugin.groovy
def plugins = jenkins.model.Jenkins.instance.getPluginManager().getPlugins()
plugins.each {println "${it.getShortName()}: ${it.getVersion()}"}
```

  - by `jar`
    ```bash
    $ curl -fsSL -O https://JENKINS_URL/jnlpJars/jenkins-cli.jar
    $ java -jar jenkins-cli.jar \
      [-auth <username>:<password>] \
      -s https://JENKINS_URL groovy = < plugin.groovy
    ```
    - or
      ```bash
      $ java -jar jenkins-cli.jar \
        [-auth <username>:<password>] \
        -s https://JENKINS_URL \
        list-plugins
      ```

- [by `ssh`](https://www.jenkins.io/doc/book/managing/cli/)
  ```bash
  $ ssh [-i <private-key>] [-l <user>] -p <port> JENKINS_URL groovy =< plugin.groovy
  ```

  - or
    ```bash
    $ ssh [-i <private-key>] [-l <user>] -p <port> JENKINS_URL list-plugins
    ```

  - or
    ```bash
    $ ssh [-i <private-key>] [-l <user>] -p <port> JENKINS_URL groovy < = <script.groovy>
    ```

## builds
### get particular build parameters
```bash
$ curl -s https://<JENKINS_DOMAIN_NAME>/job/<jobname>/<buildnum>/api/xml?xpath=/workflowRun/action/parameter[name="<param_name>"]/value
```
- remove xml tag
  ```bash
  $ curl -s 'https://<JENKINS_DOMAIN_NAME>/job/<jobname>/<buildnum>/api/xml?xpath=/workflowRun/action/parameter\[name="tester"\]/value' |
         sed -re 's:<[^>]+>([^<]+)<.*$:\1:'
  ```

- i.e.:
  ```bash
  $ curl -s --globoff 'https://<JENKINS_DOMAIN_NAME>/job/<jobname>/<buildnum>/api/xml?xpath=/*/action/parameter[name=%22id%22]'
  <parameter _class="hudson.model.StringParameterValue"><name>id</name><value>marslo</value></parameter>

  $ curl -s --globoff 'https://<JENKINS_DOMAIN_NAME>/job/<jobname>/<buildnum>/api/xml?xpath=/*/action/parameter[name=%22id%22]/value'
  <value>marslo</value>

  $ curl -s --globoff 'https://<JENKINS_DOMAIN_NAME>/job/<jobname>/<buildnum>/api/xml?xpath=/*/action/parameter[name=%22id%22]/value' |
         sed -re 's:<[^>]+>([^<]+)<.*$:\1:'
  marslo
  ```

### get all parameters via Json format

> [!TIP]
> api:
> `https://<JENKINS_DOMAIN_NAME>/job/<jobname>/<buildnum>/api/json?tree=actions[parameters[*]]`

```bash
$ curl -s --globoff 'https://<JENKINS_DOMAIN_NAME>/job/<jobname>/<buildnum>/api/json?tree=actions[parameters[*]]' | jq --raw-output '.actions[].parameters[]?'
{
  "_class": "hudson.model.StringParameterValue",
  "name": "id",
  "value": "marslo"
}
{
  "_class": "hudson.model.StringParameterValue",
  "name": "gender",
  "value": "female"
}
```

- [additional format](../../cheatsheet/character/json.md)
  ```bash
  $ curl -s --globoff 'https://<JENKINS_DOMAIN_NAME>/job/<jobname>/<buildnum>/api/json?tree=actions[parameters[*]]' | jq --raw-output '.actions[].parameters[]? | .name + "\t" + .value'
  id	marslo
  gender	female
  ```

> [!TIP]
> **jq tips**
> - [remove empty line from output](https://stackoverflow.com/a/44289083/2940319)
> i.e.:
>   - original `jq --raw-output .actions[].parameters`
>   - remove empty line: `jq --raw-output '[.actions[].parameters | select(length > 0) ]'`

```bash
$ curl -s --globoff 'https://<JENKINS_DOMAIN_NAME>/job/<jobname>/<buildnum>/api/json?tree=actions[parameters[*]]' | jq --raw-output '[.actions[].parameters | select(length > 0)]'
[
  [
    {
      "_class": "hudson.model.StringParameterValue",
      "name": "id",
      "value": "marslo"
    },
    {
      "_class": "hudson.model.StringParameterValue",
      "name": "gender",
      "value": "female"
    }
  ]
]
```
