<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [build](#build)
  - [build a job using the REST API and cURL](#build-a-job-using-the-rest-api-and-curl)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## build
### [build a job using the REST API and cURL](https://support.cloudbees.com/hc/en-us/articles/218889337-How-to-build-a-job-using-the-REST-API-and-cURL-)
```bash
$ curl -X POST http://developer:developer@localhost:8080/job/test/build

# build with parameters
$ curl -X POST http://developer:developer@localhost:8080/job/test/build --data-urlencode json='{"parameter": [{"name":"paramA", "value":"123"}]}'
```
