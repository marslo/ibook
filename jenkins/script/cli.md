<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [setup cli](#setup-cli)
  - [get port](#get-port)
  - [ssh](#ssh)
  - [jenkins-cli.jar](#jenkins-clijar)
- [Execute groovy script via cli](#execute-groovy-script-via-cli)
  - [`ERROR: This command is requesting the -remoting mode which is no longer supported`](#error-this-command-is-requesting-the--remoting-mode-which-is-no-longer-supported)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## setup cli
```bash
export JENKINS_URL=<my.jenkins.com>
```

### get port
```bash
$ curl -Lv https://${JENKINS_URL}/login 2>&1 | grep -i 'x-ssh-endpoint'
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
$ ssh -q ${JENKINS_URL} help
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

  OR

    ```bash
    $ ssh -l <user> -i <ssh-private-key> -p <port> ${JENKINS_URL} <command>

    # example
    $ ssh -l marslo -i ~/.ssh/marslo -p 32123 ${JENKINS_URL} help
    ```


### [jenkins-cli.jar](https://www.jenkins.io/doc/book/managing/cli/#using-the-cli-client)

* get client (`jenkins-cli.jar`)

```bash
$ curl -fsSL -O [-u<username>:<password>] https://${JENKINS_URL}/jnlpJars/jenkins-cli.jar
```

* use cli

```bash
$ java -jar jenkins-cli.jar -auth <username>:<password> -s https://${JENKINS_URL} <command>

# example
$ java -jar jenkins-cli.jar -auth marslo:<MY-CLI-TOKEN> -s https://${JENKINS_URL} help
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
$ java -jar jenkins-cli.jar -auth marslo:<MY-CLI-TOKEN> -s https://${JENKINS_URL}
```

* using file

```bash
$ echo 'marslo:<MY-CLI-TOKEN> ~/.marslo/.jenkins-cli'
$ java -jar jenkins-cli.jar -auth @/Users/marslo/.marslo/.jenkins-cli -s https://${JENKINS_URL}
```

* using environment

```bash
$ export JENKINS_USER_ID=marslo
$ export JENKINS_API_TOKEN=<MY-CLI-TOKEN>
$ java -jar jenkins-cli.jar -s https://${JENKINS_URL}
```

## [Execute groovy script via cli](https://xanderx.com/post/run-jenkins-script-console-scripts-from-command-line-without-remoting/)
### `ERROR: This command is requesting the -remoting mode which is no longer supported`
```bash
$ ssh -q <jenkins.domain.name> groovy <script.groovy>
```

### Solution
```bash
$ ssh -q <jenkins.domain.name> groovy = < <script.groovy>
```
- i.e.:
  ```bash
  $ ssh -q my.jenkins.com groovy < = plugin.groovy
  ```
