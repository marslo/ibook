<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [CLI setup](#cli-setup)
  - [completion](#completion)
- [Environment Variables](#environment-variables)
  - [jf options](#jf-options)
  - [CLI](#cli)
- [CLI](#cli-1)
  - [configuration](#configuration)
  - [ping](#ping)
  - [discarding old builds from artifactory](#discarding-old-builds-from-artifactory)
  - [search with aql](#search-with-aql)
  - [deploy docker image via cli](#deploy-docker-image-via-cli)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## CLI setup

> [!NOTE|label:reference:]
> - [* JFrog CLI v2](https://jfrog.com/help/r/jfrog-cli/jfrog-cli-v2)
> - [* Artifactory CLI](https://jfrog.com/help/r/jfrog-cli/jfrog-cli?tocId=BuJVcwbkUARNwOvFl9CuRg)
> - [* Get Cli](https://jfrog.com/getcli/)
> - [JFrog CLI](https://www.jfrog.com/confluence/display/CLI/JFrog+CLI)
> - [INSTALL JFROG CLI](https://jfrog.com/getcli/)
> - [jfrog/jfrog-cli](https://github.com/jfrog/jfrog-cli)

- windows
  ```powershell
  # Command Prompt
  > powershell "Start-Process -Wait -Verb RunAs powershell '-NoProfile iwr https://releases.jfrog.io/artifactory/jfrog-cli/v2-jf/2.41.1/jfrog-cli-windows-amd64/jf.exe -OutFile $env:USERPROFILE\jf.exe'"

  # verify
  > %USERPROFILE%\jf.exe --help
  NAME:
     jf - See https://github.com/jfrog/jfrog-cli for usage instructions.

  USAGE:
     jf [global options] command [command options] [arguments...]
  ...
  ```

- homebrew
  ```bash
  $ brew install jfrog-cli
  ```

- centos
  ```bash
  # via curl
  $ curl -fL https://install-cli.jfrog.io | sh

  # or
  $ sudo bash -c "cat > /etc/yum.repos.d/jfrog-cli.repo" << EOF
  [jfrog-cli]
  name=jfrog-cli
  baseurl=https://releases.jfrog.io/artifactory/jfrog-rpms
  enabled=1
  EOF
  $ sudo rpm --import https://releases.jfrog.io/artifactory/jfrog-gpg-public/jfrog_public_gpg.key
  $ sudo yum install -y jfrog-cli-v2-jf
  ```

- ubuntu
  ```bash
  # via curl
  $ curl -fL https://install-cli.jfrog.io | sh

  # or
  $ wget -qO - https://releases.jfrog.io/artifactory/jfrog-gpg-public/jfrog_public_gpg.key | sudo apt-key add -
  $ echo "deb https://releases.jfrog.io/artifactory/jfrog-debs xenial contrib" | sudo tee -a /etc/apt/sources.list
  $ sudo apt update
  $ sudo apt install -y jfrog-cli-v2-jf
  ```

- docker
  ```bash
  # slim
  $ docker run releases-docker.jfrog.io/jfrog/jfrog-cli-v2-jf jf -v

  # full
  $ docker run releases-docker.jfrog.io/jfrog/jfrog-cli-full-v2-jf jf -v
  ```


- npm
  ```bash
  $ npm install -g jfrog-cli-v2-jf && jf intro
  ```

<!--sec data-title="older version" data-id="section0" data-show=true data-collapse=true ces-->
- npm
  ```bash
  $ npm i -g jfrog-cli-go
  ```

- homebrew
  ```bash
  $ brew install jfrog-cli-go
  ```

- docker
  ```bash
  $ docker run docker.bintray.io/jfrog/jfrog-cli-go:latest jfrog <COMMAND>
  ```
<!--endsec-->


### completion
- bash
  ```bash
  $ jf completion bash --install
  ```

- zsh
  ```bash
  $ jf completion zsh --install
  ```

- Oh My Zsh
  ```bash
  plugins=(git mvn npm sdk jfrog)
  ```

- fish
  ```bash
  $ jf completion fish --install
  ```

## Environment Variables

### [jf options](https://jfrog.com/help/r/jfrog-cli/environment-variables?tocId=Wrf0qmhAPWtQ7XAWK8~zgw)

| VARIABLE NAME              | DEFAULT             | SUPPORTED                        |
| -------------------------- | ------------------- | -------------------------------- |
| `JFROG_CLI_LOG_LEVEL`      | `INFO`              | `DEBUG`, `INFO`, `WARN`, `ERROR` |
| `JFROG_CLI_LOG_TIMESTAMP`  | `TIME`              | `TIME`, `DATE_AND_TIME`, `OFF`   |
| `JFROG_CLI_HOME_DIR`       | `~/.jfrog`          | -                                |
| `JFROG_CLI_TEMP_DIR`       | -                   | -                                |
| `JFROG_CLI_PLUGINS_SERVER` | -                   | -                                |
| `JFROG_CLI_PLUGINS_REPO`   | `jfrog-cli-plugins` | -                                |
| `JFROG_CLI_RELEASES_REPO`  | -                   | -                                |
| `JFROG_CLI_SERVER_ID`      | -                   | -                                |
| `CI`                       | `false`             | -                                |


### CLI

| VARIABLE NAME                                | DEFAULT                             |
| -------------------------------------------- | ----------------------------------- |
| `JFROG_CLI_MIN_CHECKSUM_DEPLOY_SIZE_KB`      | `10`                                |
| `JFROG_CLI_RELEASES_REPO`                    | -                                   |
| `JFROG_CLI_DEPENDENCIES_DIR`                 | `$JFROG_CLI_HOME_DIR/dependencies`  |
| `JFROG_CLI_REPORT_USAGE`                     | `true`                              |
| `JFROG_CLI_SERVER_ID`                        | -                                   |
| `JFROG_CLI_BUILD_NAME`                       | -                                   |
| `JFROG_CLI_BUILD_NUMBER`                     | -                                   |
| `JFROG_CLI_BUILD_PROJECT`                    | -                                   |
| `JFROG_CLI_BUILD_URL`                        | -                                   |
| `JFROG_CLI_ENV_EXCLUDE`                      | `*password*;*secret*;*key*;*token*` |
| `JFROG_CLI_TRANSITIVE_DOWNLOAD_EXPERIMENTAL` | `false`                             |

## CLI
> reference:
> - [CLI for JFrog Artifactory](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory)

| ABBREVIATION | COMMANDS                     |
|:------------:|------------------------------|
|     `atc`    | `access-token-create`        |
|     `bad`    | `build-add-dependencies`     |
|     `bag`    | `build-add-git`              |
|     `ba`     | `build-append`               |
|     `bc`     | `build-clean`                |
|     `bce`    | `build-collect-env`          |
|     `bdi`    | `build-discard`              |
|     `bdc`    | `build-docker-create`        |
|     `bpr`    | `build-promote`              |
|     `bp`     | `build-publish`              |
|     `bs`     | `build-scan`                 |
|     `cp`     | `copy`                       |
|     `cl`     | `curl`                       |
|     `del`    | `delete`                     |
|    `delp`    | `delete-props`               |
|     `dpr`    | `docker-promote`             |
|     `dpl`    | `docker-pull`                |
|     `dp`     | `docker-push`                |
|    `donet`   | `dotnet`                     |
|   `dotnetc`  | `dotnet-config`              |
|     `dl`     | `download`                   |
|     `glc`    | `git-lfs-clean`              |
|     `go`     | `go`                         |
|       -      | `go-config`                  |
|     `gp`     | `go-publish`                 |
|       -      | `gradle`                     |
|   `gradlec`  | `gradle-config`              |
|     `gau`    | `group-add-users`            |
|     `gc`     | `group-create`               |
|    `gdel`    | `group-delete`               |
|      `h`     | `help`                       |
|     `mv`     | `move`                       |
|     `mvn`    | `mvn`                        |
|    `mvnc`    | `mvn-config`                 |
|    `npmci`   | `npm-ci`                     |
|    `npmc`    | `npm-config`                 |
|    `npmi`    | `npm-install`                |
|    `npmp`    | `npm-publish`                |
|    `nuget`   | `nuget`                      |
|   `nugetc`   | `nuget-config`               |
|     `ndt`    | `nuget-deps-tree`            |
|     `osb`    | `oc`                         |
|     `ptc`    | `permission-target-create`   |
|    `ptdel`   | `permission-target-delete`   |
|     `ptt`    | `permission-target-template` |
|     `ptu`    | `permission-target-update`   |
|      `p`     | `ping`                       |
|    `pipc`    | `pip-config`                 |
|    `pipi`    | `pip-install`                |
|     `ppl`    | `podman-pull`                |
|     `pp`     | `podman-push`                |
|    `rplc`    | `replication-create`         |
|   `rpldel`   | `replication-delete`         |
|    `rplt`    | `replication-template`       |
|     `rc`     | `repo-create`                |
|    `rdel`    | `repo-delete`                |
|     `rpt`    | `repo-template`              |
|     `ru`     | `repo-update`                |
|      `s`     | `search`                     |
|     `sp`     | `set-props`                  |
|       -      | `transfer-config`            |
|       -      | `transfer-config-merge`      |
|       -      | `transfer-files`             |
|       -      | `transfer-plugin-install`    |
|       -      | `transfer-settings`          |
|      `u`     | `upload`                     |
|       -      | `user-create`                |
|     `uc`     | `users-create`               |
|    `udel`    | `users-delete`               |
|    `yarn`    | `yarn`                       |
|    `yarnc`   | `yarn-config`                |


### configuration

- [via ssh](https://jfrog.com/help/r/jfrog-cli/authenticating-with-rsa-keys)
  ```bash
  $ jf c add --url=ssh://artifactory.example.com:1339 \
             --ssh-key-path=/Users/marslo/.ssh/id_rsa \
             sample

  $ jf c show sample
  Server ID:              sample
  JFrog Platform URL:     ssh://artifactory.example.com:1339/
  Artifactory URL:        ssh://artifactory.example.com:1339/
  SSH key file path:      /Users/marslo/.ssh/id_rsa
  Default:                true
  ```

- [via password/api key](https://docs.jfrog-applications.jfrog.io/jfrog-applications/jfrog-cli/cli-for-jfrog-artifactory#authenticating-with-username-and-password-api-key)
  ```bash
  $ jf c add --serverId rt-api-key \
             --artifactory-url=https://artifactory.sample.com/artifactory \
             --user=marslo \
             --password=A***********************************************************************x \
             --insecure-tls \
             --interactive=false
  ```

  <!--sec data-title="deprecated" data-id="section1" data-show=true data-collapse=true ces-->
  ```bash
  $ jfrog rt c sample --url=https://artifactory.example.com/artifactory --apikey=***********
  JFrog Distribution URL (Optional):
  For commands which don't use external tools or the JFrog Distribution service, JFrog CLI supports replacing the configured username and password/API key with automatically created access token that's refreshed hourly. Enable this setting? (y/n) [y]? n
  Is the Artifactory reverse proxy configured to accept a client certificate? (y/n) [n]? n

  $ jfrog rt c show
  Server ID:  sample
  Url:        https://artifactory.example.com/artifactory/
  API key:    ***************
  Default:    true
  ```

  - via username/password
    ```bash
    $ jfrog rt c sample --user=myaccount \
                        --url=https://artifactory.example.com/artifactory \
                        --password=mypassword
    JFrog Distribution URL (Optional):
    For commands which don't use external tools or the JFrog Distribution service, JFrog CLI supports replacing the configured username and password/API key with automatically created access token that's refreshed hourly. Enable this setting? (y/n) [y]? n
    Is the Artifactory reverse proxy configured to accept a client certificate? (y/n) [n]? n
    [Info] Encrypting password...
    ```
  <!--endsec-->

- [access token](https://docs.jfrog-applications.jfrog.io/jfrog-applications/jfrog-cli/cli-for-jfrog-artifactory#authenticating-with-an-access-token)
  ```bash
  $ jf c add --serverId sample
             --artifactory-url=https://artifactory.sample.com/artifactory \
             --user=marslo \
             --access-token=c**************************************************************Q \
             --interactive=false \
             --insecure-tls
  ```

- in docker
  ```bash
  $ docker run -it \
               --rm \
               -v $(PWD):/root docker.bintray.io/jfrog/jfrog-cli-go \
               jfrog rt c prod \
                        --url=https://artifactory.example.com/artifactory \
                        --user=myaccount \
                        --password=mypassword
  ```

### ping
- check configuration or remote server
  ```bash
  $ jf rt p
  OK

  # or
  $ jfrog rt p --server-id=sample
  OK
  ```

### discarding old builds from artifactory
- clean build info and artifacts 30 days before

  ```bash
  $ jf use <sample>
  $ jfrog rt bdi --max-days=30 --delete-artifacts=true "my-job-build"
  ```

  <!--sec data-title="deprecated" data-id="section2" data-show=true data-collapse=true ces-->
  ```bash
  $ jfrog rt use sample
  $ jfrog rt bdi --max-days=30 --delete-artifacts=true "my-job-build"
  ```
  <!--endsec-->

- using cli via docker
  ```bash
  $ docker run \
           -it \
           --rm \
           -v $(PWD):/root docker.bintray.io/jfrog/jfrog-cli-go \
                     jfrog rt bdi --max-days=45 --delete-artifacts 'ci - buildinfo - name'
  ```

### search with aql

> [!NOTE|label:references:]
> - [Jfrog artifactory delete folder of containing artifacts after remove them](https://stackoverflow.com/a/59273175/2940319)

```bash
$ cat spec.json
{
  "files": [{
    "aql": {
      "items.find": {
        "repo": "my-repo",
        "type":"folder",
        "depth" : "1",
        "created": { "$before": "15d" }
      }
    }
  }]
}

$ jfrog rt s --spec spec.json
```

- delete with aql search
  ```bash
  $ jfrog rt del --spec spec.json
  ```

### [deploy docker image via cli](https://philippart-s.github.io/blog/articles/dev/docker-artificatory-promote/)

> [!NOTE|label:references:]
> - [* iMarlso: deploy docker image via API](./api.html#deploy-docker-image-via-api)

```bash
$ jf rt docker-promote hello-world default-docker-local stef-docker-local \
                       --source-tag=1.0.0 \
                       --target-docker-image=hello-world \
                       --target-tag=prod
```
