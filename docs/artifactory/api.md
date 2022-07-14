<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [variable](#variable)
- [repo](#repo)
  - [check repo exists](#check-repo-exists)
  - [get all repos](#get-all-repos)
  - [get all local repos](#get-all-local-repos)
  - [get repo size](#get-repo-size)
- [Build Info](#build-info)
  - [List all timestamps in ${buildName}](#list-all-timestamps-in-buildname)
  - [List specific build-info](#list-specific-build-info)
  - [filter `"buildInfo.env.JOB_NAME"` in all builds](#filter-buildinfoenvjob_name-in-all-builds)
- [cleanup](#cleanup)
  - [delete all in `my-repo` 4 weeks ago](#delete-all-in-my-repo-4-weeks-ago)
  - [trash can](#trash-can)
  - [builds rotation via `api/build/retention`](#builds-rotation-via-apibuildretention)
- [promote](#promote)
  - [property](#property)
  - [search](#search)
- [deploy](#deploy)
  - [deploy single artifacts](#deploy-single-artifacts)
  - [deploy bundle artifact](#deploy-bundle-artifact)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## variable
```bash
$ rtUrl='https://my.artifactory.com/artifactory'
$ repoName='my-repo'
$ buildName='my - repo'
$ buildNumber=12345
$ curlOpt="-s -g --netrc-file ~/.marslo/.netrc"
```

## repo
### check repo exists
```bash
$ /usr/bin/curl ${curlOpt} \
                -X GET "${rtUrl}/api/repositories" |
                jq .[].key |
                grep "${repo}"
```

### get all repos
{% hint style='tip' %}
> [`api/repositories`](https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-GetRepositories)

{% endhint %}

```bash
$ curl -sSg \
       -X GET \
       https://my.artifactory.com/artifactory/api/repositories |
       jq -r '.[] | .type + " ~> " + .key'
LOCAL ~> local-repo
REMOTE ~> remote-repo
VIRTUAL ~> virtual-repo
...
```

### get all local repos
```bash
$ curl -sSg \
       -X GET \
       https://my.artifactory.com/artifactory/api/repositories |
       jq -r '.[] | select(.type == "LOCAL") | .key'
```

- get all virtual repos
  ```bash
  $ curl -sSg \
         -X GET \
         https://my.artifactory.com/artifactory/api/repositories |
         jq -r '.[] | select(.type == "VIRTUAL") | .key'
  ```

  - get all virtual repos, and repo name starts with '<project>'
    ```bash
    $ curl -sSg \
          -X GET https://my.artifactory.com/artifactory/api/repositories |
          jq -r '.[] | select((.type == "VIRTUAL") and select(.key | startswith("<project>"))) | .key'
    ```
  - get defaultDeployRepo for all virutal repos who named starts with '<project>'
    ```bash
    $ for i in $(curl -sSg \
                      -XGET https://my.artifactory.com/artifactory/api/repositories |
                      jq -r '.[] | select((.type == "VIRTUAL") and select(.key | startswith("<project>"))) | .key'
      ); do
        echo "${i} : "
        curl -sSg \
             --netrc-file /home/marslo/.marslo/.netrc \
             -XGET https://my.artifactory.com/artifactory/api/repositories/${i} |
          jq .defaultDeploymentRepo
        echo ' '
      done
    ```

- get all remote repos
  ```bash
  $ curl -sSg \
         -X GET \
         https://my.artifactory.com/artifactory/api/repositories |
         jq -r '.[] | select(.type == "REMOTE") | .key'
  ```

### get repo size
{% hint style='tip' %}
> [`api/storageinfo`](https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-GetStorageSummaryInfo)

{% endhint %}

- get storage summary
  {% hint style='tip' %}
  including:
  - `binariesSummary`
  - `fileStoreSummary`
  - `repositoriesSummaryList`
  {% endhint %}

  ```bash
  ```

## Build Info
### List all timestamps in ${buildName}

```bash
$ curl -s \
       --netrc-file ~/.marslo/.netrc \
       -X GET ${rtUrl}/api/build/${buildsNumbers} \
       | jq .buildsNumbers[].started
```

### List specific build-info
```bash
$ curl -s \
       --netrc-file ~/.marslo/.netrc \
       -X GET ${rtUrl}/api/build/${buildNazme}/${buildNumber}
```

- get start timestampe
  ```bash
  $ curl -s \
         --netrc-file ~/.marslo/.netrc \
         -X GET ${rtUrl}/api/build/${buildNazme}/${buildNumber} \
         | jq .buildInfo.started
  "2020-09-30T02:38:32.264-0700"
  ```

### filter `"buildInfo.env.JOB_NAME"` in all builds
```bash
$ BUILD_NAME='my - job'
$ RT_URL='https://my.artifactory.com/artifactory'
$ for i in $(curl -sg -X GET "${RT_URL}/api/build/${BUILD_NAME}" | jq -r '.[][]?.uri' ); do
    echo "~~~> ${i}"
    curl -sg -X GET "${RT_URL}/api/build/${BUILD_NAME}${i}" | jq --raw-output '.buildInfo.properties."buildInfo.env.JOB_NAME"'
    echo ''
  done
```
or
```bash
#!/usr/bin/env bash

BUILD_NAME='my - build'
CURL_OPT="-sg --netrc-file $HOME/.marslo/.netrc"
RT_URL='https://my.artifactory.com/artifactory'
for bid in $(curl ${CURL_OPT} -X GET "${RT_URL}/api/build/${BUILD_NAME}" | jq -r '.[][]?.uri'); do
  curl ${CURL_OPT}  -X GET "${RT_URL}/api/build/${BUILD_NAME}${bid}" \
       | jq -r '.buildInfo.properties | select(."buildInfo.env.JOB_NAME" | contains("marslo"))' \
       | jq -r  '[."buildInfo.env.JOB_NAME" , ."buildInfo.env.BUILD_URL"]'
done
```

- filter `"buildInfo.env.JOB_NAME"` by keyword
  ```bash
  $ BUILD_ID='/297'
  $ curl -sg -X GET "${RT_URL}/api/build/${BUILD_NAME}${BUILD_ID}" \
         | jq -r '.buildInfo.properties | select(."buildInfo.env.JOB_NAME" | contains("marslo"))' \
         | jq -r '."buildInfo.env.JOB_NAME"'
  marslo/rc
  ```

- filter both `"buildInfo.env.BUILD_URL"` and `"buildInfo.env.JOB_NAME"` if `JOB_NAME` contains keyword
  ```bash
  $ curl -sg -X GET "${RT_URL}/api/build/${BUILD_NAME}${BUILD_ID}" \
         | jq -r '.buildInfo.properties | select(."buildInfo.env.JOB_NAME" | contains("marslo"))' \
         | jq -r '[."buildInfo.env.JOB_NAME" , ."buildInfo.env.BUILD_URL"]'
  [
    "marslo/rc",
    "https://my.jenkins.com/job/marslo/job/rc/297/"
  ]
  ```

## cleanup

### delete all in `my-repo` 4 weeks ago
- `find.aql`
  ```bash
  $ cat find.aql
  items.find({
    "repo": "my-repo",
    "type" : "folder" ,
    "depth" : "1",
    "created" : {
      "$before" : "4w"
    }
  })
  ```

- delete artifacts and buildinfo
  ```bash
  rtURL='https://my.artifactory.com/artifactory'
  cibuild='my-jenkins-build'
  repo='my-repo'
  curlOpt= '-s -g --netrc-file ~/.marslo/.netrc'

  for _i in $(curl ${curlOpt} \
                   -X POST ${rtURL}/api/search/aql \
                   -T find.aql |
              jq --raw-output .results[].name \
  ); do
    curl ${curlOpt} -X DELETE "${rtURL}/${repo}/${_i}"
    curl ${curlOpt} -X DELETE "${rtURL}/api/build/${cibuild}?buildNumbers=${_i}&artifacts=1"

    curl ${curlOpt} -X DELETE "${rtUrl}/api/trash/clean/${repo}/${_i}"
    curl ${curlOpt} -X DELETE "${rtUrl}/api/trash/clean/artifactory-build-info"
  done
  ```

### trash can
#### empty trash can
```bash
$ curl -s \
       -g \
       --netrc-file ~/.marslo/.netrc' \
       -X POST \
       "${rtUrl}/api/trash/empty"
```

#### list items in trash can
```bash
$ curl -s \
       -g \
       --netrc-file ~/.marslo/.netrc' \
       -X GET \
       "${rtURL}/api/storage/auto-trashcan" | jq .children[].uri
```

### [builds rotation via `api/build/retention`](https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-ControlBuildRetention)

```bash
$ date -d 'now - 2 months' +%s%3N
1597232120161
$ date -d @$(echo '1597232120161' | rev | cut -c4- | rev)
Wed Aug 12 19:35:20 CST 2020

$ cat rotation.json
{
  "deleteBuildArtifacts" : true ,
  "count" : 3 ,
  "minimumBuildDate" : 1597232120161 ,
  "buildNumbersNotToBeDiscarded" : []
}
$ curl -s \
       -g \
       -X POST \
       -d @rotation.json \
       -H "Content-Type: application/json" \
       --netrc-file ~/.marslo/.netrc' \
       "https://my.artifactory.com/artifactory/api/build/retention/build%20-%20name?async=false"
```

## promote
> reference:
> - [How do I promote a build using the REST-API?](https://jfrog.com/knowledge-base/how-do-i-promote-a-build-using-the-rest-api/)
> - [build promotion](https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-BuildPromotion)

```bash
$ cat promot.json
{
  "status": "released",
  "ciUser": "ci-user",
  "dryRun" : false,
  "targetRepo" : "my-repo-release",
  "copy": true,
  "artifacts" : true,
  "dependencies" : true,
  "scopes" : [ "compile", "runtime" ],
  "properties": {
    "release-name": ["marslo-test"]
  }
}

$ curl -s \
       -g \
       -i \
       -k \
       -H "Content-type:application/json" \
       -d @promot.json \
       -X POST \
       '${rtURL}/api/build/promote/${buildName}/<buildID>'
```

### property
#### [add property](https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-SetItemProperties)
```bash
$ path='libs-release-local/pkg'
$ properties=$('os=win,linux|qa=done' | sed 's:|:%7C:')
$ curl -s \
       -g \
       -I \
       --netrc-file ~/.marslo/.netrc \
       -X PUT \
       '${rtURL}/storage/${repoName}-local/${path}?properties=${properties}&recursive=1'
```

- get result
  ```bash
  $ curl -sgI \
         --netrc-file ~/.marslo/.netrc \
         -X PUT \
         '${rtURL}/storage/${repoName}-local/${path}?properties=${properties}&recursive=1' \
         | sed -rn 's:^HTTP/2\s?([0-9]+)\s?:\1:gp'
  204

  # or
  400

  # or
  404
  ```

### search
#### via [pattern search](https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-PatternSearch)
```bash
$ pattern='*/pkg/*/*.jar'
$ curl -s \
       -g \
       -k \
       --netrc-file ~/.marslo/.netrc \
       -X GET \
       "${rtURL}/search/pattern?pattern=${repoName}-local:${pattern}"
```

#### via [aql search](aql.md)
```bash
$ curl -s \
       -k \
       -X POST \
       -H 'Content-Type:text/plain' \
       'https://artifactory.domain.com/artifactory/api/search/aql' \
       -d 'builds.find({
               "name": "my - build - dev",
               "created": {"$before": "3days"}
           }).sort({"$desc": ["created"]}).limit(1)
       '
```

## deploy
### [deploy single artifacts](https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-Example-DeployinganArtifact)
```bash
$ curl -gsSL \
       --netrc-file ~/.marslo/.netrc \
       -XPUT \
       "https://artifactory.domain.com/artifactory/<repo-name>/<path/to/file.txt>" \
       -T <artifacts>.txt
```

### [deploy bundle artifact](https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-DeployArtifactsfromArchive)
```bash
$ curl -g \
       -s \
       -SL \
       -H "X-Explode-Archive-Atomic: true" \
       -X PUT \
       "https://artifactory.domain.com/artifactory/<repo-name>/<path>/" \
       -T <artifacts>.[zip\|tar.gz\|tgz]
```
