<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [CLI setup](#cli-setup)
  - [completion](#completion)
- [Environment Variables](#environment-variables)
  - [jf options](#jf-options)
  - [rt environment variables](#rt-environment-variables)
- [CLI](#cli)
  - [configuration](#configuration)
  - [ping](#ping)
  - [deploy](#deploy)
  - [download](#download)
  - [copy](#copy)
  - [move](#move)
  - [remove](#remove)
  - [search](#search)
  - [manage properties](#manage-properties)
- [usage](#usage)
  - [discarding old builds from artifactory](#discarding-old-builds-from-artifactory)
  - [search with aql](#search-with-aql)
  - [delete docker images](#delete-docker-images)
  - [deploy docker image via cli](#deploy-docker-image-via-cli)
- [npm](#npm)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## CLI setup

> [!NOTE|label:reference:]
> - [* JFrog CLI v2](https://jfrog.com/help/r/jfrog-cli/jfrog-cli-v2)
> - [* Artifactory CLI](https://jfrog.com/help/r/jfrog-cli/jfrog-cli?tocId=BuJVcwbkUARNwOvFl9CuRg)
> - [* Get Cli](https://jfrog.com/getcli/)
> - [JFrog CLI](https://jfrog.com/help/r/jfrog-applications-and-cli-documentation/jfrog-cli)
> - [INSTALL JFROG CLI](https://jfrog.com/getcli/)
> - [Download and Install](https://jfrog.com/help/r/jfrog-applications-and-cli-documentation/download-and-install-the-jfrog-cli)
> - [jfrog/jfrog-cli](https://github.com/jfrog/jfrog-cli)
>   - [jfrog-cli/build/deb_rpm/v2-jf/build-scripts/pack.sh](https://github.com/jfrog/jfrog-cli/blob/dev/build/deb_rpm/v2-jf/build-scripts/pack.sh)
>   - [jfrog-cli/build/deb_rpm/v2-jf/build-scripts/deb-install.sh](https://github.com/jfrog/jfrog-cli/blob/dev/build/deb_rpm/v2-jf/build-scripts/deb-install.sh)
>   - [jfrog-cli/build/deb_rpm/v2-jf/build-scripts/rpm-install.sh](https://github.com/jfrog/jfrog-cli/blob/dev/build/deb_rpm/v2-jf/build-scripts/rpm-install.sh)
>   - [jfrog-cli/build/deb_rpm/v2-jf/build-scripts/rpm-sign.sh](https://github.com/jfrog/jfrog-cli/blob/dev/build/deb_rpm/v2-jf/build-scripts/rpm-sign.sh)

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

  # old version
  $ brew install jfrog-cli-go
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

  > [!NOTE|label:references:]
  > - [#1741 Installing CLI without apt-key](https://github.com/jfrog/jfrog-cli/issues/1741#issuecomment-1469754099)

  ```bash
  # via curl
  $ curl -fL https://install-cli.jfrog.io | sh

  # via apt
  #                                                                                               dos2unix
  #                                                                                                   v
  $ curl -fsSL https://releases.jfrog.io/artifactory/jfrog-gpg-public/jfrog_public_gpg.key | tr -d '\015' | sudo tee /usr/share/keyrings/jfrog.asc >/dev/null
  $ echo "deb [signed-by=/usr/share/keyrings/jfrog.asc] https://releases.jfrog.io/artifactory/jfrog-debs xenial contrib" > /etc/apt/source.list.d/jfrog.list >/dev/null
  $ sudo apt update -y
  $ sudo apt install jfrog-cli-v2-jf -y
  ```

  <!--sec data-title="deprecated for ubuntu 22.04" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  # deprecated for ubuntu 22.04
  $ wget -qO - https://releases.jfrog.io/artifactory/jfrog-gpg-public/jfrog_public_gpg.key | sudo apt-key add -
  $ echo "deb https://releases.jfrog.io/artifactory/jfrog-debs xenial contrib" | sudo tee -a /etc/apt/sources.list
  $ sudo apt update
  $ sudo apt install -y jfrog-cli-v2-jf
  ```
  <!--endsec-->

- docker
  ```bash
  # slim
  $ docker run releases-docker.jfrog.io/jfrog/jfrog-cli-v2-jf jf -v

  # full
  $ docker run releases-docker.jfrog.io/jfrog/jfrog-cli-full-v2-jf jf -v

  # old version
  $ docker run docker.bintray.io/jfrog/jfrog-cli-go:latest jfrog <COMMAND>
  ```

- npm
  ```bash
  $ npm install -g jfrog-cli-v2-jf && jf intro

  # old version
  $ npm i -g jfrog-cli-go
  ```

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

### jf options

> [!NOTE|label:references:]
> - [JFrog CLI Environment Variables](https://docs.jfrog-applications.jfrog.io/jfrog-applications/jfrog-cli/usage)

```bash
$ jf options
```

| VARIABLE NAME                          | DEFAULT               | SUPPORTED                        |
|----------------------------------------|-----------------------|----------------------------------|
| `CI`                                   | `false`               | -                                |
| `JFROG_CLI_ANALYZER_MANAGER_VERSION`   | latest stable version | -                                |
| `JFROG_CLI_AVOID_NEW_VERSION_WARNING`  | `false`               | -                                |
| `JFROG_CLI_COMMAND_SUMMARY_OUTPUT_DIR` | -                     | -                                |
| `JFROG_CLI_ENCRYPTION_KEY`             | -                     | -                                |
| `JFROG_CLI_FAIL_NO_OP`                 | `false`               | -                                |
| `JFROG_CLI_GITHUB_TOKEN`               | -                     | -                                |
| `JFROG_CLI_HIDE_SURVEY`                | `false`               | -                                |
| `JFROG_CLI_HOME_DIR`                   | `~/.jfrog`            | -                                |
| `JFROG_CLI_LOG_LEVEL`                  | `INFO`                | `DEBUG`, `INFO`, `WARN`, `ERROR` |
| `JFROG_CLI_LOG_TIMESTAMP`              | `TIME`                | `TIME`, `DATE_AND_TIME`, `OFF`   |
| `JFROG_CLI_PLUGINS_REPO`               | `jfrog-cli-plugins`   | -                                |
| `JFROG_CLI_PLUGINS_SERVER`             | -                     | -                                |
| `JFROG_CLI_TEMP_DIR`                   | -                     | -                                |


### rt environment variables

| VARIABLE NAME                           | DEFAULT                                          |
|-----------------------------------------|--------------------------------------------------|
| `JFROG_CLI_MIN_CHECKSUM_DEPLOY_SIZE_KB` | `10`                                             |
| `JFROG_CLI_RELEASES_REPO`               | -                                                |
| `JFROG_CLI_DEPENDENCIES_DIR`            | `$JFROG_CLI_HOME_DIR/dependencies`               |
| `JFROG_CLI_REPORT_USAGE`                | `true`                                           |
| `JFROG_CLI_SERVER_ID`                   | -                                                |
| `JFROG_CLI_BUILD_NAME`                  | -                                                |
| `JFROG_CLI_BUILD_NUMBER`                | -                                                |
| `JFROG_CLI_BUILD_PROJECT`               | -                                                |
| `JFROG_CLI_BUILD_URL`                   | -                                                |
| `JFROG_CLI_ENV_EXCLUDE`                 | `*password*;*psw*;*secret*;*key*;*token*;*auth*` |
| `JFROG_CLI_TRANSITIVE_DOWNLOAD`         | `false`                                          |
| `JFROG_CLI_UPLOAD_EMPTY_ARCHIVE`        | `false`                                          |

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
  $ jf c add --server-id rt-api-key \
             --artifactory-url=https://artifactory.sample.com/artifactory \
             --user=marslo \
             --password=A***********************************************************************x \
             --insecure-tls \
             --interactive=false
  ```

  <!--sec data-title="deprecated" data-id="section2" data-show=true data-collapse=true ces-->
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
  $ jf c add --server-id sample
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

#### set default
```bash
$ jf rt use <SERVER_ID>
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

### deploy

> [!NOTE|label:references:]
> - [Placeholders](https://jfrog.com/help/r/jfrog-applications-and-cli-documentation/using-placeholders)
> - [Uploading Files](https://jfrog.com/help/r/jfrog-applications-and-cli-documentation/generic-files)
> - [iMarslo: deploy bundle artifact](./api.md#deploy-bundle-artifact)

```bash
$ jf rt u \
     --recursive=true \
     --threads=8 \
     --retries=3 \
     --exclusions="*backup*;*sandbox*" \
     <LOCAL_PATH>/(*) <REPO>/<TARGET_PATH>/{1} \

$ jf rt u file.zip repo-name/folder/

# same as `-H "X-Explode-Archive: true"` in API
$ jf rt file.tar repo-name/folder/ --explode
```

### download

> [!NOTE|label:references:]
> - [Downloading Files](https://jfrog.com/help/r/jfrog-applications-and-cli-documentation/generic-files)

```bash
# i.e.:
$ jf rt dl repo-name/cool-froggy.zip --flat

# download entire folder
$ jf rt dl repo-name/all-my-frogs/ all-my-frogs/

# download only `*.zip` files
$ jf rt dl "repo-name/*.zip" all-my-frogs/

# download the latest created file
$ jf rt dl  "repo-name/all-my-frogs/" --sort-by=created --sort-order=desc --limit=1
```

### copy

> [!NOTE|label:references:]
> - [Copying Files](https://jfrog.com/help/r/jfrog-applications-and-cli-documentation/generic-files)

```bash
$ jf rt cp source-frog-repo/rabbit/ target-frog-repo/rabbit/

# copy with properties
$ jf rt cp "source-frog-repo/rabbit/*.zip" target-frog-repo/rabbit/ --props=Version=1.0
```

### move

> [!NOTE|label:references:]
> - [Moving Files](https://jfrog.com/help/r/jfrog-applications-and-cli-documentation/generic-files)

```bash
$ jf rt mv source-frog-repo/rabbit/ target-frog-repo/rabbit/

# moving with flat structure
$ jf rt mv "source-frog-repo/rabbit/*" target-frog-repo/rabbit/ --flat
```

### remove

> [!NOTE|label:references:]
> - [Deleting Files](https://jfrog.com/help/r/jfrog-applications-and-cli-documentation/generic-files)

```bash
$ jf rt del frog-repo/rabbit/

# delete zip only
$ jf rt del "frog-repo/rabbit/*.zip"
```

### search

> [!NOTE|label:references:]
> - [Searching Files](https://jfrog.com/help/r/jfrog-applications-and-cli-documentation/generic-files)

```bash
# to list all files
$ jf rt s frog-repo/rabbit/

# searching with fields
$ jf rt s example-repo-local --include="actual_md5;modified_by;updated;depth"
```

### manage properties

> [!NOTE|label:references:]
> - [Setting Properties on Files](https://docs.jfrog-applications.jfrog.io/jfrog-applications/jfrog-cli/binaries-management-with-jfrog-artifactory/generic-files#setting-properties-on-files)
> - [Deleting Properties from Files](https://docs.jfrog-applications.jfrog.io/jfrog-applications/jfrog-cli/binaries-management-with-jfrog-artifactory/generic-files#deleting-properties-from-files)

## usage
### discarding old builds from artifactory
- clean build info and artifacts 30 days before

  ```bash
  $ jf use <sample>
  $ jfrog rt bdi --max-days=30 --delete-artifacts=true "my-job-build"
  ```

  <!--sec data-title="deprecated" data-id="section3" data-show=true data-collapse=true ces-->
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
        "repo": "repo-name",
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

### delete docker images
```bash
#              registry name  image name    tag
#              +-----------+ +-----------+ +---+
$ jf rt delete docker-local/devops/ubuntu/4.0.0**
  docker-local/devops/ubuntu/4.0.0-py310-jammy-dind-v95-94d13a3db/
  docker-local/devops/ubuntu/4.0.0-py310-jammy-dind/
  docker-local/devops/ubuntu/4.0.0-py310-jammy/
Are you sure you want to delete the above paths? (y/n) [n]? y
{
  "status": "success",
  "totals": {
    "success": 3,
    "failure": 0
  }
}

# or remote all v4.0.0* tags via
$ jf rt delete docker-local/devops/*/4.0.0**
  docker-local/devops/clang/4.0.0-py310-jammy-dind-v95-94d13a3db/
  docker-local/devops/clang/4.0.0-py310-jammy-dind/
  docker-local/devops/clang/4.0.0-py310-jammy-v95-94d13a3db/
  docker-local/devops/clang/4.0.0-py310-jammy/
  docker-local/devops/doxygen/4.0.0-py310-jammy-dind-v95-94d13a3db/
  docker-local/devops/doxygen/4.0.0-py310-jammy-dind/
  docker-local/devops/doxygen/4.0.0-py310-jammy-v95-94d13a3db/
  docker-local/devops/doxygen/4.0.0-py310-jammy/
  docker-local/devops/jnlp/4.0.0-py310-jammy-dind-v95-94d13a3db/
  docker-local/devops/jnlp/4.0.0-py310-jammy-dind/
  docker-local/devops/jnlp/4.0.0-py310-jammy-v95-94d13a3db/
  docker-local/devops/jnlp/4.0.0-py310-jammy/
Are you sure you want to delete the above paths? (y/n) [n]?
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

## npm

> [!NOTE|label:references:]
> - [Step 2: Use the CLI in your project](https://jfrog.com/help/r/artifactory-how-to-use-an-access-token-environment-variable-with-the-jfrog-cli/step-2-use-the-cli-in-your-project)
> - [Setting npm repositories](https://docs.jfrog-applications.jfrog.io/jfrog-applications/jfrog-cli/cli-for-jfrog-artifactory/package-managers-integration#setting-npm-repositories)
> - [Use the npm Command Line](https://jfrog.com/help/r/jfrog-artifactory-documentation/use-the-npm-command-line)
> - [npm Packages with JFrog CLI](https://jfrog.com/blog/npm-flies-with-jfrog-cli/)

```bash
$ cd path/to/project
$ jf npm-config --repo-deploy <LOCAL-REPO> --repo-resolve <REMOTE-REPO>

# i.e.:
$ jf npm-config --repo-deploy npmjs-local --repo-resolve npmjs-remote

# result
$ cat .jfrog/projects/npm.yaml
   1   version: 1
   2   type: npm
   3   resolver:
   4       repo: poc-npmjs-remote
   5       serverId: stg
   6   deployer:
   7       repo: poc-npmjs-local
   8       serverId: stg
```

- using jf for npm

  > [!NOTE|label:references:]
  > ```bash
  > $ jf npm --help
  >
  > Name:
  >   jf npm - Run npm command.
  >
  > Usage:
  >   jf npm <npm arguments> [command options]
  >
  > Arguments:
  >   ci                        Run npm ci.
  >   publish, p                Packs and deploys the npm package to the designated npm repository.
  >   install, i, install, add  Run npm install.
  >   help, h
  > ```

  ```bash
  $ jf npm install
  ```
