<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [variable](#variable)
- [repo](#repo)
  - [check repo exists](#check-repo-exists)
- [Build Info](#build-info)
  - [List all timestamps in ${buildName}](#list-all-timestamps-in-buildname)
  - [List specific build-info](#list-specific-build-info)
- [delete all in `my-repo` 4 weeks ago](#delete-all-in-my-repo-4-weeks-ago)
- [trash can](#trash-can)
  - [empty trash can](#empty-trash-can)
  - [list items in trash can](#list-items-in-trash-can)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## variable
```bash
$ rtUrl='https://my.artifactory.com/artifactory'
$ buildName='my - repo'
$ buildNumber=12345
$ curlOpt="-s -g --netrc-file ~/.marslo/.netrc"
```

## repo

### check repo exists
```bash
$ /usr/bin/curl ${curlOpt} \
                -X GET "${rtUrl}/api/repositories" \
                | jq .[].key \
                | grep "${repo}"
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


## delete all in `my-repo` 4 weeks ago
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
  curlOpt= "-s -g --netrc-file ~/.marslo/.netrc"

  for _i in $(curl ${curlOpt} -X POST ${curlOpt} ${rtURL}/api/search/aql -T find.aql | jq --raw-output .results[].name); do
    curl ${curlOpt} -X DELETE "${rtURL}/${repo}/${_i}"
    curl ${curlOpt} -X DELETE "${rtURL}/api/build/${cibuild}?buildNumbers=${_i}&artifacts=1"

    curl ${curlOpt} -X DELETE "${rtUrl}/api/trash/clean/${repo}/${_i}"
    curl ${curlOpt} -X DELETE "${rtUrl}/api/trash/clean/artifactory-build-info"
  done
  ```

## trash can
### empty trash can
```bash
$ curl ${curlOpt} -X POST "${rtUrl}/api/trash/empty"
```

### list items in trash can
```bash
$ curl ${curlOpt} -X GET "${rtURL}/api/storage/auto-trashcan" | jq .children[].uri
```
