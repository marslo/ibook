<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [setup cli](#setup-cli)
  - [get port](#get-port)
  - [ssh](#ssh)
  - [jenkins-cli.jar](#jenkins-clijar)
- [execute groovy script via cli](#execute-groovy-script-via-cli)
  - [`ERROR: This command is requesting the -remoting mode which is no longer supported`](#error-this-command-is-requesting-the--remoting-mode-which-is-no-longer-supported)
  - [solution](#solution)
- [execute groovysh](#execute-groovysh)
  - [execute the script via https](#execute-the-script-via-https)
- [man cli](#man-cli)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [Jenkins World 2017: Mastering the Jenkins Script Console](https://www.youtube.com/watch?v=qaUPESDcsGg)
> - [Jenkins Area Meetup - Hacking on Jenkins Internals - Jenkins Script Console](https://www.youtube.com/watch?v=T1x2kCGRY1w)
> - [Write Groovy scripts for Jenkins with code completion](https://www.mdoninger.de/2011/11/07/write-groovy-scripts-for-jenkins-with-code-completion.html)
> - [Example Groovy scripts](https://www.jenkins.io/doc/book/managing/script-console/#example-groovy-scripts)
> - [Jenkins Startup logs show builds migrated by the RunIdMigrator](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/jenkins-startup-logs-show-runidmigrator-logs)
> - [How to create a job using the REST API and cURL?](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/how-to-create-a-job-using-the-rest-api-and-curl)
> - [Creating node with the REST API](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/creating-node-with-the-rest-api)
{% endhint %}


## setup cli
```bash
export JENKINS_DOMAIN=<my.jenkins.com>
```

### get port
```bash
$ curl -Lv https://${JENKINS_DOMAIN}/login 2>&1 | grep -i 'x-ssh-endpoint'
< x-ssh-endpoint: my.jenkins.com:31232

$ k -n ci get svc jenkins-discovery -o yaml
apiVersion: v1
kind: Service
metadata:
  ...
spec:
  ports:
  - name: jenkins-agent
    nodePort: 3xxxx
    port: 50000
    protocol: TCP
    targetPort: jnlp-port
  - name: cli-agent
    nodePort: 32123
    port: 31232
    protocol: TCP
    targetPort: cli-port
  selector:
    app: jenkins
...
```

![jenkins-cli-port](../../screenshot/jenkins/jenkins-cli-1.png)


### [ssh](https://www.jenkins.io/doc/book/managing/cli/)
* Jenkins config

![jenkins-cli-ssh](../../screenshot/jenkins/jenkins-cli-2.png)

* `~/.ssh/config`
```bash
$ cat ~/.ssh/config
Host  my.jenkins.com
      User                marslo
      IdentityFile        ~/.ssh/marslo
      Port                32123
```

* using cli
```bash
$ ssh -q ${JENKINS_DOMAIN} help
  add-job-to-view
    Adds jobs to view.
  apply-configuration
    Apply YAML configuration to instance
  build
    Builds a job, and optionally waits until its completion.
  cancel-quiet-down
    Cancel the effect of the "quiet-down" command.
  channel-process
    Launch a new JVM on a slave and connect it with the master with remoting
  ...
```

- or
  ```bash
  $ ssh -l <user> -i <ssh-private-key> -p <port> ${JENKINS_DOMAIN} <command>

  # example
  $ ssh -l marslo -i ~/.ssh/marslo -p 32123 ${JENKINS_DOMAIN} help
  ```

### [jenkins-cli.jar](https://www.jenkins.io/doc/book/managing/cli/#using-the-cli-client)

* get client (`jenkins-cli.jar`)
  ```bash
  $ curl -fsSL -O [-u<username>:<password>] https://${JENKINS_DOMAIN}/jnlpJars/jenkins-cli.jar

  # or
  $ curl -fsSL -O --netrc-file ~/.marslo/.netrc' https://${JENKINS_DOMAIN}/jnlpJars/jenkins-cli.jar
  $ cat ~/.marslo/.netrc
  machine <JENKINS_DOMAIN>
  login myaccount
  password mypassword
  ```

* use cli
  ```bash
  $ java -jar jenkins-cli.jar -auth <username>:<password> -s https://${JENKINS_DOMAIN} <command>

  # example
  $ java -jar jenkins-cli.jar -auth marslo:<MY-CLI-TOKEN> -s https://${JENKINS_DOMAIN} help
    add-job-to-view
      Adds jobs to view.
    apply-configuration
      Apply YAML configuration to instance
    build
      Builds a job, and optionally waits until its completion.
    cancel-quiet-down
      Cancel the effect of the "quiet-down" command.
    ...
  ```

#### handle `-auth`
* using directly in command line
  ```bash
  $ java -jar jenkins-cli.jar -auth marslo:<MY-CLI-TOKEN> -s https://${JENKINS_DOMAIN}
  ```

* using file
  ```bash
  $ echo 'marslo:<MY-CLI-TOKEN> ~/.marslo/.jenkins-cli'
  $ java -jar jenkins-cli.jar -auth @/Users/marslo/.marslo/.jenkins-cli -s https://${JENKINS_DOMAIN}
  ```

* using environment
  ```bash
  $ export JENKINS_USER_ID=marslo
  $ export JENKINS_API_TOKEN=<MY-CLI-TOKEN>
  $ java -jar jenkins-cli.jar -s https://${JENKINS_DOMAIN}
  ```

## [execute groovy script via cli](https://xanderx.com/post/run-jenkins-script-console-scripts-from-command-line-without-remoting/)
### `ERROR: This command is requesting the -remoting mode which is no longer supported`
```bash
$ ssh -q <jenkins.domain.name> groovy <script.groovy>
```

### solution
```bash
$ ssh -q <jenkins.domain.name> groovy = < /path/to/script.groovy
```
- i.e.:
  ```bash
  $ cat a.groovy
  println System.getProperties().sort().findAll{ it.key.contains('java') }.collect{ "${it.key} ~> ${it.value}" }.join('\n')

  $ ssh ssdfw-devops-jenkins.marvell.com groovy =< ./a.groovy | head -4
  java.awt.graphicsenv ~> sun.awt.X11GraphicsEnvironment
  java.awt.headless ~> true
  java.awt.printerjob ~> sun.print.PSPrinterJob
  java.class.path ~> /usr/share/jenkins/jenkins.war
  ...
  ```

## execute groovysh
```groovy
$ ssh <jenkins.domina.name> groovysh
groovy:000> println System.getProperties().sort().collect{ "${it.key} ~> ${it.value}" }.join('\n')
awt.toolkit ~> sun.awt.X11.XToolkit
com.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors ~> true
executable-war ~> /usr/share/jenkins/jenkins.war
file.encoding ~> UTF-8
file.separator ~> /
```

### execute the script via https

> [!TIP|label:references:]
> - [Script Console](https://www.jenkins.io/doc/book/managing/script-console/)
> - [imarslo : script console](./script.html#script-console)
>
> A Jenkins Admin can execute groovy scripts remotely by sending an HTTP POST request to /script/ url or /scriptText/.

- format
  ```bash
  $ curl -d "script=<your_script_here>" https://jenkins/script

  # or to get output as a plain text result (no HTML)
  $ curl -d "script=<your_script_here>" https://jenkins/scriptText
  ```
- example : [curl submitting groovy file via bash](https://www.jenkins.io/doc/book/managing/script-console/#remote-access)
  ```bash
  $ curl --data-urlencode "script=$(< ./somescript.groovy)" https://jenkins/scriptText

  # or
  $ curl --user 'username:api-token' --data-urlencode \
         "script=$(< ./somescript.groovy)" https://jenkins/scriptText
  ```

- example : Python submitting groovy file providing username and api token
  ```python
  with open('somescript.groovy', 'r') as fd:
      data = fd.read()
  r = requests.post('https://jenkins/scriptText', auth=('username', 'api-token'), data={'script': data})
  ```

## man cli

|                  CMD                 | DESCRIPTION                                                                                                                                                                                             |
|:------------------------------------:|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|           `add-job-to-view`          | Adds jobs to view.                                                                                                                                                                                      |
|         `apply-configuration`        | Apply YAML configuration to instance                                                                                                                                                                    |
|                `build`               | Builds a job, and optionally waits until its completion.                                                                                                                                                |
|          `cancel-quiet-down`         | Cancel the effect of the "quiet-down" command.                                                                                                                                                          |
|         `check-configuration`        | Check YAML configuration to instance                                                                                                                                                                    |
|             `clear-queue`            | Clears the build queue.                                                                                                                                                                                 |
|            `connect-node`            | Reconnect to a node(s)                                                                                                                                                                                  |
|               `console`              | Retrieves console output of a build.                                                                                                                                                                    |
|              `copy-job`              | Copies a job.                                                                                                                                                                                           |
|      `create-credentials-by-xml`     | Create Credential by XML                                                                                                                                                                                |
|  `create-credentials-domain-by-xml`  | Create Credentials Domain by XML                                                                                                                                                                        |
|             `create-job`             | Creates a new job by reading stdin as a configuration XML file.                                                                                                                                         |
|             `create-node`            | Creates a new node by reading stdin as a XML configuration.                                                                                                                                             |
|             `create-view`            | Creates a new view by reading stdin as a XML configuration.                                                                                                                                             |
|         `declarative-linter`         | Validate a Jenkinsfile containing a Declarative Pipeline                                                                                                                                                |
|            `delete-builds`           | Deletes build record(s).                                                                                                                                                                                |
|         `delete-credentials`         | Delete a Credential                                                                                                                                                                                     |
|      `delete-credentials-domain`     | Delete a Credentials Domain                                                                                                                                                                             |
|             `delete-job`             | Deletes job(s).                                                                                                                                                                                         |
|             `delete-node`            | Deletes node(s)                                                                                                                                                                                         |
|             `delete-view`            | Deletes view(s).                                                                                                                                                                                        |
|             `disable-job`            | Disables a job.                                                                                                                                                                                         |
|           `disable-plugin`           | Disable one or more installed plugins.                                                                                                                                                                  |
|           `disconnect-node`          | Disconnects from a node.                                                                                                                                                                                |
|             `enable-job`             | Enables a job.                                                                                                                                                                                          |
|            `enable-plugin`           | Enables one or more installed plugins transitively.                                                                                                                                                     |
|        `export-configuration`        | Export jenkins configuration as YAML                                                                                                                                                                    |
|       `get-credentials-as-xml`       | Get a Credentials as XML (secrets redacted)                                                                                                                                                             |
|    `get-credentials-domain-as-xml`   | Get a Credentials Domain as XML                                                                                                                                                                         |
|             `get-gradle`             | List available gradle installations                                                                                                                                                                     |
|               `get-job`              | Dumps the job definition XML to stdout.                                                                                                                                                                 |
|              `get-node`              | Dumps the node definition XML to stdout.                                                                                                                                                                |
|              `get-view`              | Dumps the view definition XML to stdout.                                                                                                                                                                |
|               `groovy`               | Executes the specified Groovy script.                                                                                                                                                                   |
|              `groovysh`              | Runs an interactive groovy shell.                                                                                                                                                                       |
|                `help`                | Lists all the available commands or a detailed description of single command.                                                                                                                           |
|      `import-credentials-as-xml`     | Import credentials as XML. The output of "list-credentials-as-xml" can be used as input here as is, the only needed change is to set the actual Secrets which are redacted in the output.               |
|           `install-plugin`           | Installs a plugin either from a file, an URL, or from update center.                                                                                                                                    |
|             `keep-build`             | Mark the build to keep the build forever.                                                                                                                                                               |
|            `list-changes`            | Dumps the changelog for the specified build(s).                                                                                                                                                         |
|          `list-credentials`          | Lists the Credentials in a specific Store                                                                                                                                                               |
|       `list-credentials-as-xml`      | Export credentials as XML. The output of this command can be used as input for "import-credentials-as-xml" as is, the only needed change is to set the actual Secrets which are redacted in the output. |
| `list-credentials-context-resolvers` | List Credentials Context Resolvers                                                                                                                                                                      |
|     `list-credentials-providers`     | List Credentials Providers                                                                                                                                                                              |
|              `list-jobs`             | Lists all jobs in a specific view or item group.                                                                                                                                                        |
|            `list-plugins`            | Outputs a list of installed plugins.                                                                                                                                                                    |
|                `mail`                | Reads stdin and sends that out as an e-mail.                                                                                                                                                            |
|            `offline-node`            | Stop using a node for performing builds temporarily, until the next "online-node" command.                                                                                                              |
|             `online-node`            | Resume using a node for performing builds, to cancel out the earlier "offline-node" command.                                                                                                            |
|             `quiet-down`             | Quiet down Jenkins, in preparation for a restart. Don’t start any builds.                                                                                                                               |
|        `reload-configuration`        | Discard all the loaded data in memory and reload everything from file system. Useful when you modified config files directly on disk.                                                                   |
|     `reload-jcasc-configuration`     | Reload JCasC YAML configuration                                                                                                                                                                         |
|             `reload-job`             | Reload job(s)                                                                                                                                                                                           |
|        `remove-job-from-view`        | Removes jobs from view.                                                                                                                                                                                 |
|           `replay-pipeline`          | Replay a Pipeline build with edited script taken from standard input                                                                                                                                    |
|               `restart`              | Restart Jenkins.                                                                                                                                                                                        |
|         `restart-from-stage`         | Restart a completed Declarative Pipeline build from a given stage.                                                                                                                                      |
|            `safe-restart`            | Safely restart Jenkins.                                                                                                                                                                                 |
|            `safe-shutdown`           | Puts Jenkins into the quiet mode, wait for existing builds to be completed, and then shut down Jenkins.                                                                                                 |
|             `session-id`             | Outputs the session ID, which changes every time Jenkins restarts.                                                                                                                                      |
|        `set-build-description`       | Sets the description of a build.                                                                                                                                                                        |
|       `set-build-display-name`       | Sets the displayName of a build.                                                                                                                                                                        |
|      `set-external-build-result`     | Set external monitor job result.                                                                                                                                                                        |
|              `shutdown`              | Immediately shuts down Jenkins server.                                                                                                                                                                  |
|             `stop-builds`            | Stop all running builds for job(s)                                                                                                                                                                      |
|      `update-credentials-by-xml`     | Update Credentials by XML                                                                                                                                                                               |
|  `update-credentials-domain-by-xml`  | Update Credentials Domain by XML                                                                                                                                                                        |
|             `update-job`             | Updates the job definition XML from stdin. The opposite of the get-job command.                                                                                                                         |
|             `update-node`            | Updates the node definition XML from stdin. The opposite of the get-node command.                                                                                                                       |
|             `update-view`            | Updates the view definition XML from stdin. The opposite of the get-view command.                                                                                                                       |
|               `version`              | Outputs the current version.                                                                                                                                                                            |
|          `wait-node-offline`         | Wait for a node to become offline.                                                                                                                                                                      |
|          `wait-node-online`          | Wait for a node to become online.                                                                                                                                                                       |
|              `who-am-i`              | Reports your credential and permissions.                                                                                                                                                                |













































































