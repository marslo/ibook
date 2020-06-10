## build
### [build a job using the REST API and cURL](https://support.cloudbees.com/hc/en-us/articles/218889337-How-to-build-a-job-using-the-REST-API-and-cURL-)
```bash
$ curl -X POST http://developer:developer@localhost:8080/job/test/build

# build with parameters
$ curl -X POST http://developer:developer@localhost:8080/job/test/build --data-urlencode json='{"parameter": [{"name":"paramA", "value":"123"}]}'
```
