<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [CLI setup](#cli-setup)
- [CLI for jFrog Artifactory](#cli-for-jfrog-artifactory)
  - [configuration](#configuration)
  - [ping](#ping)
  - [Discarding Old Builds from Artifactory](#discarding-old-builds-from-artifactory)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## CLI setup
> reference:
> - [JFrog CLI](https://www.jfrog.com/confluence/display/CLI/JFrog+CLI)
> - [INSTALL JFROG CLI](https://jfrog.com/getcli/)
> - [jfrog/jfrog-cli](https://github.com/jfrog/jfrog-cli)

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

## CLI for jFrog Artifactory
> reference:
> - [CLI for JFrog Artifactory](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory)

| commands            | abbreviation |
| :-:                 | :-:          |
| `config`            | `c`          |
| `ping`              | `p`          |
| `upload`            | `u`          |
| `download`          | `dl`         |
| `copy`              | `cp`         |
| `move`              | `mv`         |
| `delete`            | `del`        |
| `search`            | `s`          |
|                     |              |
| `set-props`         | `sp`         |
| `delete-props`      | `delp`       |
| `curl`              | `cl`         |
|                     |              |
| `build-collect-env` | `bce`        |
| `build-publish`     | `bp`         |
| `build-promote`     | `bpr`        |
| `build-clean`       | `bc`         |
| `build-scan`        | `bs`         |
| `build-discard`     | `bdi`        |
|                     |              |
| `repo-template`     | `rpt`        |
| `repo-create`       | `rc`         |
| `repo-update`       | `ru`         |
| `repo-delete`       | `rdel`       |


### configuration
- setup in local
  ```bash
  $ jfrog rt c myrt --url=https://my.artifactory.com/artifactory --apikey=***********
  JFrog Distribution URL (Optional):
  For commands which don't use external tools or the JFrog Distribution service, JFrog CLI supports replacing the configured username and password/API key with automatically created access token that's refreshed hourly. Enable this setting? (y/n) [y]? n
  Is the Artifactory reverse proxy configured to accept a client certificate? (y/n) [n]? n
  ```

  - or
    ```bash
    $ jfrog rt c myrt --url=https://my.artifactory.com/artifactory --user=myaccount --password=mypassword
    JFrog Distribution URL (Optional):
    For commands which don't use external tools or the JFrog Distribution service, JFrog CLI supports replacing the configured username and password/API key with automatically created access token that's refreshed hourly. Enable this setting? (y/n) [y]? n
    Is the Artifactory reverse proxy configured to accept a client certificate? (y/n) [n]? n
    [Info] Encrypting password...
    ```
- setup in docker
  ```bash
  $ docker run -it \
               --rm \
               -v $(PWD):/root docker.bintray.io/jfrog/jfrog-cli-go \
               jfrog rt c prod --url=https://my.artifactory.com/artifactory --user=myaccount --password=mypassword
  ```

- show configuration
  ```bash
  $ jfrog rt c show
  Server ID: myrt
  Url: https://my.artifactory.com/artifactory/
  API key: ***************
  Default:  true
  ```

### ping
- check configuration or remote server
  ```bash
  $ jfrog rt p --server-id=myrt
  OK
  ```

### Discarding Old Builds from Artifactory
- clean build info and artifacts 30 days before
  ```bash
  $ jfrog rt use myrt
  $ jfrog rt bdi --max-days=30 --delete-artifacts=true "my-job-build"
  ```

- using cli via docker
  ```bash
  $ docker run \
           -it \
           --rm \
           -v $(PWD):/root docker.bintray.io/jfrog/jfrog-cli-go \
                     jfrog rt bdi --max-days=45 --delete-artifacts 'ci - buildinfo - name'
  ```
