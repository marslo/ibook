<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [execute Groovy script with an API call](#execute-groovy-script-with-an-api-call)
- [stop build via api](#stop-build-via-api)
- [get builds information](#get-builds-information)
- [list plugins](#list-plugins)
  - [using api (`curl`)](#using-api-curl)
  - [using cli](#using-cli)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> reference:
> - [Example for Jenkins API](https://www.programcreek.com/java-api-examples/?action=search&ClassName=jenkins&submit=Search)

## [execute Groovy script with an API call](https://support.cloudbees.com/hc/en-us/articles/217509228-Execute-Groovy-script-in-Jenkins-with-an-API-call)
```bash
$ curl -d "script=$(cat /tmp/script.groovy)" -v --user username:ApiToken http://JENKINS_URL/scriptText

# or
$ curl -d "script=println 'this script works'" -v --user username:ApiToken http://JENKINS_URL/scriptText
```

## [stop build via api](https://www.jenkins.io/doc/book/using/aborting-a-build/)

|        api       | comments                   |
|:----------------:|----------------------------|
| `BUILD_URL/stop` | abort a build              |
| `BUILD_URL/term` | forcibly terminate a build |
| `BUILD_URL/kill` | hard kill a pipeline       |

## get builds information
- [via job api](https://stackoverflow.com/a/25650246/2940319)
```bash
$ curl -sSLg http://jenkins:8080/job/my-job/api/json?tree=builds[id,number,duration,timestamp,builtOn]
```

## list plugins
### [using api (`curl`)](https://stackoverflow.com/a/52836951/2940319)
```bash
$ curl -u<username>:<password> \
    -s https://<JENKINS_DOMAIN_NAME>/pluginManager/api/json?depth=1 \
    | jq -r '.plugins[] | "\(.shortName):\(.version)"' \
    | sort
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
