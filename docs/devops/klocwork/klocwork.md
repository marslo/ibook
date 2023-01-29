<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [environment](#environment)
- [analysis](#analysis)
  - [initial a klocwork analysis](#initial-a-klocwork-analysis)
  - [full build analysis](#full-build-analysis)
  - [incremental build analysis](#incremental-build-analysis)
  - [load result from both windows and linux](#load-result-from-both-windows-and-linux)
  - [using kwwrap plus kwinject to generate a build specification](#using-kwwrap-plus-kwinject-to-generate-a-build-specification)
  - [when editing the makefile is not an option](#when-editing-the-makefile-is-not-an-option)
- [authentication](#authentication)
  - [get ltoken](#get-ltoken)
- [api](#api)
  - [list builds info from project](#list-builds-info-from-project)
- [report](#report)
  - [creating a report](#creating-a-report)
- [CI](#ci)
  - [Jenkinsfile](#jenkinsfile)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [Klocwork Build integration for C Cplus plus projects EN](https://www.youtube.com/watch?v=2f4CfEU5CEI)
> - [Command Reference](https://docs.roguewave.com/en/klocwork/2020/commandreference)
> - [Troubleshooting an incomplete kwinject build specification](https://docs.roguewave.com/en/klocwork/2020/troubleshootinganincompletekwinjectbuildspecification)
> - [Providing a build specification template for your developers](https://docs.roguewave.com/en/klocwork/2020/providingabuildspecificationtemplateforyourdevelopers)
> - [Compiler options for kwbuildproject](https://docs.roguewave.com/en/klocwork/2020/compileroptionsforkwbuildproject#concept968)
> - [Klocwork Jenkins CI plugin](https://docs.roguewave.com/en/klocwork/current/jenkinsci)
> - [Synchronizing status changes and comments across projects](https://docs.roguewave.com/en/klocwork/current/synchronizingstatuschangesandcommentsacrossprojects)
> - [Continuous integration and Klocwork analysis](https://docs.roguewave.com/en/klocwork/current/continuousintegration)
> - [examples](https://docs.roguewave.com/en/klocwork/current/understandingtheworkflow)
> - [Klocwork - Knowledgebase](https://library.roguewave.com/display/SUPPORT/Klocwork+-+Knowledgebase)
> - [Running the C and C++ integration build analysis](https://docs.roguewave.com/en/klocwork/current/runningthecandcintegrationbuildanalysis)
>   - [Running your first integration build analysis](https://docs.roguewave.com/en/klocwork/current/runningyourfirstintegrationbuildanalysis1)
>   - [Running your next integration build analysis](https://docs.roguewave.com/en/klocwork/current/runningyournextintegrationbuildanalysis1)
>   - [Creating a C/C++ build specification](https://docs.roguewave.com/en/klocwork/2020/creatingaccbuildspecification)
>   - [C/C++ integration build analysis - Cheat sheet](https://docs.roguewave.com/en/klocwork/current/ccintegrationbuildanalysischeatsheet)
> - [example about integrate with Jenkins](https://stackoverflow.com/questions/51731262/jenkins-declarative-pipeline-how-to-configure-the-klocwork-result-display-on-t)
> - [最佳实践：Klocwork增量/VerifyCI检查](http://www.360doc.com/content/17/0430/08/30774303_649740396.shtml)
> - [Running a distributed Klocwork C/C++ analysis](https://bullwhip.physio-control.com/documentation/help/concepts/runningadistributedklocworkccanalysis.htm)
> - [Security Best Practices + Klocwork](https://www.perforce.com/blog/kw/security-best-practices)
> - [Integrating Static Code Analysis and Defect Tracking.pdf](https://is.muni.cz/th/i4jzl/MT.pdf)
> - [klocwork 2020](https://docs.roguewave.com/en/klocwork/2020/)
>   - [Setting up Klocwork with Containers (Linux)](https://docs.roguewave.com/en/klocwork/2020/setupkwcontainers)
>   - [Limitations](https://docs.roguewave.com/en/klocwork/2021/kwlimitations)
{% endhint %}

## environment
> reference:
> - [Install and Configure Klocwork cmd client](https://scmabhishek.wordpress.com/2016/07/04/install-and-configure-klocwork-cmd-client/)
> - [User manual | Installation and Upgrade](https://manualzz.com/doc/44373012/installation-and-upgrade?__cf_chl_jschl_tk__=b7f12f6befde4217b2830af5cb69055d40841a0c-1619442763-0-AXJ6A-8dLrK6mjM4v5IvfVIbgptM2fMku23COnaWX2AXiowy0H1aVcEuRXfkHCy52vr0N6RqKejPmriTUTLIsGPCo9AldMujCF8gJflvp-uX-CiweHa5c3fP1KNvKgeOvVzhe-wBWDfbrJ0MyEvEks8cEHXjRj6cRnlP5ibFYByNE7jX3KXtH5tRZVr386HX0bcPCx5nyu_FgY-xEFCpuMmnEaP0Rhr_zeoQn85YrY61j7lGJAgnzdqgz1rC4ktkZ1i7ijdYgUTFNAFG_1_vQ4ox8Wj7hdab890-Tw-NtdrGoMoEq-4CeMxDEzlLYmFNNX1kM0EVJIv50J2v2H7GIdUNd_rV7y_wyhllUPbRe1COFvk1Ey7eAgsfJyKAW-Il6Z8NRlSaO-RdRcnZ6wpk2L2s6uuAzcNNWQM-8DiljKhGu9OT-FjeGtEXyBUxZPjY2LWF1k_fX2tb4S0GJGO7T09QPnlbAZa9VBFueEVeVSdzDocBByzn-BwknWpMr-dIJA)
> - [Klocwork Desktop for C/C++ project setup overview](https://docs.roguewave.com/en/klocwork/current/klocworkdesktopforccprojectsetupoverview)
> - video: [Build integration for C/C++ projects](https://developer.klocwork.com/resources/videos/build-integration-cc-projects)
> - video: [Klocwork Demo](https://www.perforce.com/success/klocwork-demo)
> - [Useful resources](https://developer.klocwork.com/resources/videos/build-integration-cc-projects)

## analysis
> [issue severity](http://docs.klocwork.com/Insight-10.0/Issue_severity)
> - 1 - Critical
> - 2 - Error
> - 3 - Warning
> - 4 - Review
> - 5 - Severity 5
> - 6 - Severity 6
> - 7 - Severity 7
> - 8 - Severity 8
> - 9 - Severity 9
> - 10 - Severity 10

### [initial a klocwork analysis](https://docs.roguewave.com/en/klocwork/2020/runningyourfirstintegrationbuildanalysis1)
> [sample code](http://cdn-devnet.klocwork.com/cbt/10.0/C_CPP_integration_build_analysis/samples/newProject.txt)

- capture build settings
  ```bash
  $ kwinject --output "<.out_path>" <original build command>
  ```
  - i.e.:
    ```bash
    $ kwinject --output "~/npp/npp.out" devenv "~/npp/PowerEditor/visual.net/notepadPlus.sln" /Rebuild
    ```

- run an analysis using the build spec
  ```bash
  $ kwbuildproject --url "<kw_url:kw_port>/<project_name>" \
                   --tables-directory "<table_path>" \
                   "<.out_path>"
  ```
  - i.e.:
    ```bash
    $ kwbuildproject --url "http://my.kw.com/NotepadPlusPlus" --tables-directory "~/npp/npp_tables" "~/npp/npp.out"
    ```

- load the database
  ```bash
  $ kwadmin --url "<kw_url:kw_port>" \
            load "<project_name>" \
            "<table_path>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url "http://my.kw.com" load "NotepadPlusPlus" "~/npp/npp_tables"
    ```

  - [debug for authentication issue](https://webcache.googleusercontent.com/search?q=cache:ZlMRAvROjswJ:https://developer.klocwork.com/community/forums/klocwork-general/admin-tools/non-interactive-authentication+&cd=1&hl=en&ct=clnk&gl=us)
    ```bash
    $ kwadmin --debug --url <Klocwork server url> list-projects
    ```
    - logout via
      ```bash
      $ kwauth --log-out
      ```


### [full build analysis](https://docs.roguewave.com/en/klocwork/2020/runningyournextintegrationbuildanalysis1#Runningafullbuildanalysis)
> [sample code](http://cdn-devnet.klocwork.com/cbt/10.0/C_CPP_integration_build_analysis/samples/fullBuildAnalysis.txt)

- re-create the build spec
  ```bash
  $ kwinject --output "~/kw.out" <regular command line>
  ```
  - i.e.
    ```bash
    $ kwinject --output "~/npp/npp.out" devenv "~/npp/PowerEditor/visual.net/notepadPlus.sln" /Rebuild
    ```

- force a full analysis
  ```bash
  $ kwbuildproject --url "<kw_url:kw_port>/<project_name>" \
                   --tables-directory "<table_path>" \
                   --force "<.out file>"
  ```
  - i.e.:
    ```bash
    $ kwbuildproject --url "http://my.kw.com/NotepadPlusPlus" --tables-directory "~/npp/npp_tables" --force "~/npp/npp.out"
    ```

- load the result
  ```bash
  $ kwadmin --url "<kw_url:kw_port>" \
            load "<project_name>" \
            "<table_path>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url http://my.kw.com/ load NotepadPlusPlus "~/npp/npp_tables"
    ```

### [incremental build analysis](https://docs.roguewave.com/en/klocwork/2020/runningyournextintegrationbuildanalysis1#Runningincrementalanalysis)
> [sample code](http://cdn-devnet.klocwork.com/cbt/10.0/C_CPP_integration_build_analysis/samples/incremental.txt)

- update the build settings
  ```bash
  $ kwinject --update "<.out_path>" <original build command>
  ```
  - i.e.:
    ```bash
    $ kwinject --update "~/npp/npp.out" devenv "~/npp/PowerEditor/visual.net/notepadPlus.sln" /Build
    ```

- execute the incremental analysis
  ```bash
  $ kwbuildproject --url "<kw_url:kw_port>/<project_name>" \
                   --tables-directory "<table_path>" \
                   --incremental "<table_path>"
  ```
  - i.e.:
    ```bash
    $ kwbuildproject --url "http://my.kw.com/NotepadPlusPlus" --tables-directory "~/npp/npp_tables" --incremental "~/npp/npp_tables"
    ```

- load the result
  ```bash
  $ kwadmin --url "<kw_url:kw_port>" \
            load "<project_name>" \
            "<table_path>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url "http://my.kw.com" load NotepadPlusPlus "~/npp/npp_tables"
    ```

### load result from both windows and linux
> [sample code](http://cdn-devnet.klocwork.com/cbt/10.0/C_CPP_integration_build_analysis/samples/Windows-Unix.txt)
> [kwbuildproject](https://bullwhip.physio-control.com/documentation/help/reference/kwbuildproject.htm)

- create an integration project on kw server via command line
  ```bash
  $ kwadmin --url "<kw_url:kw_port>" \
            create-project "<project_name>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url http://my.kw.com create-project NotepadPlusPlus
    ```

- capture build settings on linux machine
  ```bash
  $ kwinject --output "<.out_path>" <original build command>
  ```
  - i.e.:
    ```bash
    $ kwinject --output "~/npp/npp.out" make
    ```

- run an analysis using the build spec on linux
  ```bash
  $ kwbuildproject --url "<kw_url:kw_port>/<project_name>" \
                  [--project "<project_name>"]
                   --tables-directory "<table_path>" \
                   "<.out_path>"
  ```
  - i.e.:
    ```bash
    $ kwbuildproject --url "http://my.kw.com/NotepadPlusPlus" \
                     --tables-directory "~/npp/npp_tables" \
                     "~/npp/npp.out"
    ```
  - [load multiple specification](https://bullwhip.physio-control.com/documentation/help/reference/kwbuildproject.htm)
    ```bash
    $ kwbuildproject --tables-directory <dir> \
                     [--url http://<klocwork_server_host>:<klocwork_server_port>/<server_project>] \
                     [<other_options>] \
                     <build_specification_1> [<build_specification_2>...]
    ```

- load the database on windows
  ```bash
  $ kwadmin --url "<kw_url:kw_port>" \
            load "<project_name>" \
            "<table_path>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url "http://my.kw.com/NotepadPlusPlus" \
              load NotepadPlusPlus \
              "~/npp/npp_tables"
    ```

### [using kwwrap plus kwinject to generate a build specification](https://docs.roguewave.com/en/klocwork/current/usingkwwrappluskwinjecttogenerateabuildspecification)
> reference:
> - [Using a build trace to troubleshoot build specification problems](https://docs.roguewave.com/en/klocwork/current/usingabuildtracetotroubleshootbuildspecificationproblems#concept972)
> - [Can I concatenate the results of more than one kwinject.out file?](https://developer.klocwork.com/community/forums/klocwork-insight/general-discussion/can-i-concatenate-results-more-one-kwinjectout)
> - [Running a distributed analysis](https://bullwhip.physio-control.com/documentation/help/concepts/runningadistributedanalysis.htm)

{% hint style='tip' %}
> Note:
> For [distributed builds](https://docs.roguewave.com/en/klocwork/current/runningadistributedklocworkccanalysis), you must run the following procedure on all build machines and merge the resultant build trace files.
{% endhint %}

1. inserting the kwwrap command line before your compiler and linker names
  ```c
  CC = gcc
  ```
  convert to
  ```c
  CC = kwwrap -o <path_to_kwwrap_trace_file> gcc
  // or
  CC = kwwrap -o <path_to_kwwrap_trace_file> $(command -v gcc)
  ```

  or via [creating wrapper scripts](https://docs.roguewave.com/en/klocwork/2019/usingkwwrappluskwinjecttogenerateabuildspecification#Creatingwrapperscripts)

1. execute the original build command
1. Convert the build trace into a build specification with [kwinject](https://docs.roguewave.com/en/klocwork/current/kwinject)
  ```bash
  $ kwinject --trace-in <path_to_kwwrap_trace_file> \
             --output <path_to_kwinject_output_file>
  ```
  - i.e.:
    ```bash
    $ kwinject --trace-in C:/temp/kwwrap.trace \
               --output C:/Klocwork/temp/kwinject.out
    ```

### [when editing the makefile is not an option](https://docs.roguewave.com/en/klocwork/current/usingkwwrappluskwinjecttogenerateabuildspecification#Wheneditingthemakefileisnotanoption)
{% hint style='tip' %}
> i.e.: <path_to_kwwrap_trace_file> is `/temp/kwwrap.trace`
{% endhint %}

#### [using environment variables](https://docs.roguewave.com/en/klocwork/2019/usingkwwrappluskwinjecttogenerateabuildspecification#Usingenvironmentvariables)
1. create environment variables
  ```bash
  $ LDSHARED="kwwrap -o /temp/kwwrap.trace $(command -v gcc)"
  $ CC="kwwrap -o /temp/kwwrap.trace $(command -v gcc)"
  $ C++="kwwrap -o /temp/kwwrap.trace $(command -v g++)"
  $ CMAKE="kwwrap -o /temp/kwwrap.trace $(command -v cmake)"
  $ AR="kwwrap -o /temp/kwwrap.trace $(command -v ar) rc"
  $ export CC C++ CMAKE AR LDSHARED
  ```

1. build with original command
  ```bash
  $ cmake
  ```

1. use kwwrap with CMake and generate the trace
  ```bash
  $ kwinject --trace-in /temp/kwwrap.trace --output kwinject.out
  ```

#### [using wrapper scripts](https://docs.roguewave.com/en/klocwork/2019/usingkwwrappluskwinjecttogenerateabuildspecification#Creatingwrapperscripts)
1. creating wrapper scripts
  ```bash
  $ echo "kwwrap -r -o <path_to_kwwrap_trace_file> $(command -v gcc)" > $HOME/.hook/gcc
  $ echo "kwwrap -r -o <path_to_kwwrap_trace_file> $(command -v g++)" > $HOME/.hook/g++
  $ echo "kwwrap -r -o <path_to_kwwrap_trace_file> $(command -v cmake)" > $HOME/.hook/cmake
  $ chmod +x $HOME/.hook/*
  ```

1. setup environment variables
  ```bash
  $ export KWWRAP_HOOKS_DIR="$HOME/.hook"
  $ export PATH=${KWWRAP_HOOKS_DIR}:${PATH}
  ```

1. build with original command
  ```bash
  $ cmake # the original command
  ```

1. use kwwrap with CMake and generate the trace
  ```bash
  $ kwinject --trace-in /temp/kwwrap.trace --output kwinject.out
  ```

## authentication

> [!TIP]
> references:
> - [Authentication using the ltoken](https://analyst.phyzdev.net/documentation/help/concepts/klocworkltoken.htm)
> <br>
> Failing authentication if host name is not found<br>
> You can enable kwauth to fail authentication in the case where the server host name was not found in the certificate CN or Subject Alternative Name by setting the verifyCertificate option to true. Enabling this results in the following error message if the host name cannot be found: <br>
> ```
> Unable to authenticate using SSL with <url>
> ```
> To set this value to true, create a 'client_config.xml' file in your {client_tools_install_folder}\config\ folder (if it does not already exist). The file must contain the following:
> ```xml
> <?xml version="1.0" encoding="UTF-8"?>
>    <params>
>      <host resolveHost="false" verifyCertificate="true"/>
>    </params>
> ```
> Note that setting `resolveHost="false"` is not mandatory, but doing so can prevent the Klocwork Server from resolving the wrong FQDN as the Server will use whatever host you specify in a remote server URL.

{% hint style='tip' %}
> `ltoken` is used to authenticate users with tools such as kwbuildproject:
> - Windows:C:\Users\<user_name>\.klocwork\ltoken
> - Unix:~/.klocwork/ltoken
> - Mac:~/.klocwork/ltoken
> If there is no ltoken file in your .klocwork directory, run kwauth to generate the file.
{% endhint %}

### [get ltoken](https://docs.roguewave.com/en/klocwork/2020/klocworkltoken)
```bash
$ export KLOCWORK_LTOKEN=/home/marslo/.klocwork/ltoken
$ kwauth --url https://my.kw.com:443
Login: marslo
Password: ****
$ cat /home/marslo/.klocwork/ltoen
my.kw.com;443;marslo;abcdefg1234567**************************************************
```

## [api](https://docs.roguewave.com/en/klocwork/current/formattingrequeststotheapi1)
> api url: http(s)://my.kw.com:443/review/api
> reference:
> - [Klocwork Web API cookbook](https://docs.roguewave.com/en/klocwork/current/klocworkwebapicookbook)
> - [Klocwork Insight Web API cookbook](http://docs.klocwork.com/Insight-10.0/Klocwork_Insight_Web_API_cookbook)
> - [Access control API examples](https://docs.roguewave.com/en/klocwork/2020/examples_webacl)
> - [Issue and metric API examples](https://docs.roguewave.com/en/klocwork/2020/examples2)

Klocwork Static Code Analysis Web API Reference
> To access Web API send a POST request to http://my.kw.com/review/api with the following parameters:
  > user*     Klocwork user name
  > ltoken    kwauth login token
  > action*   action name
>
> builds
> Retrieve the list of builds for a project.
> - Example: `curl --data "action=builds&user=myself&project=my_project" http://my.kw.com/review/api`
>   - project* : project name

### list builds info from project
> **`ltoek`** is got from `${KLOCWORK_LTOKEN}` file
>
> reference:
> - [Klocwork Insight Web API cookbook](http://docs.klocwork.com/Insight-10.0/Klocwork_Insight_Web_API_cookbook)
> - [Issue states](https://docs.roguewave.com/en/klocwork/2020/issuestates)
> - [Issue statuses](https://docs.roguewave.com/en/klocwork/current/issuestatuses)
>
> [api additional header](https://docs.roguewave.com/en/klocwork/current/formattingrequeststotheapi1) : `-H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8"`

- [via api](https://stackoverflow.com/a/28774031/2940319)
  ```bash
  $ curl --data "action=builds&user=<user_account>&ltoken=<ltoken>&project=<projct_name>" http://my.kw.com/review/api
  ```
  - i.e.:
    ```bash
    $ curl --data "action=builds&user=marslo&ltoken=abcd1234****&project=marslo-kw" \
           https://my.kw.com:443/review/api
    {"id":3,"name":"build_3","date":1619437882164,"keepit":false}
    {"id":2,"name":"build_2","date":1619436216567,"keepit":false}
    {"id":1,"name":"build_1","date":1619434698145,"keepit":false}
  ```

- [via `kwadmin`](https://docs.roguewave.com/en/klocwork/current/kwadmin)
  ```bash
  $ kwadmin --url https://my.kw.com:443 list-builds marslo-kw
  build_1
  build_2
  build_3
  ```
  - list project config files
    ```bash
    $ kwadmin --url https://my.kw.com:443 list-config-files marslo-kw
    analysis_profile.pconf (Problems Configuration)
    metrics_default.mconf (Metrics Thresholds)
    ```

#### [query only new issues](https://stackoverflow.com/a/28774031/2940319)
> reference
> - [Using the search API](https://bullwhip.physio-control.com/documentation/help/concepts/usingthesearchapi.htm)

**search**
> Retrieve the list of detected issues.
> - Example: `curl --data "action=search&user=myself&project=my_project&query=file:MyFile.c" http://my.kw.com/review/api`
>   - project* : project name
>   - query    : search query, such as narrowing by file (for example, 'file:MyFile.c')
>   - view     : view name
>   - limit    : search result limit
>   - summary  : include summary record to output stream

{% hint style='tip' %}
> [Searching in Klocwork Static Code Analysis](https://bullwhip.physio-control.com/documentation/help/concepts/searchinginklocworksca.htm#concept955):
>
> Note: You can only search by one build at a time. Other acceptable syntax:
> - build:'123' - searches for build which contains substring '123'
> - build:+123 - searches for build with name 123
> - build:+'123string' - searches for build with name equal to '123string'
{% endhint %}

```bash
$ ltoken='abcd1234*****'
$ username='marslo'
$ project='marslo-kw'
$ query='build:build_3 state:New'
$ url='https://my.kw.com:443'
$ curl --data "action=search&user=${username}&ltoken=${ltoken}&project=${project}&query=${query}" \
       ${url}/review/api |
       jq --raw-output .
```

## report
### [creating a report](https://docs.roguewave.com/en/klocwork/current/creatingareport)

## CI
> reference:
> - [Klocwork Jenkins CI plugin](https://docs.roguewave.com/en/klocwork/2020/jenkinsci)
> - [Continuous integration and Klocwork analysis](https://docs.roguewave.com/en/klocwork/2020/continuousintegration)
> - Ebook: [klocwork ci/cd best practice.pdf](https://www.perforce.com/sites/default/files/pdfs/ebook-klocwork-ci-cd-best-practices%20%281%29.pdf)
> - Video: [Add Static Code Analysis to Your CI/CD Pipelines](https://www.perforce.com/webinars/kw/add-static-code-analysis-to-ci-cd-pipelines)

### [Jenkinsfile](https://docs.roguewave.com/en/klocwork/2020/jenkinsci)
```groovy
pipeline {
  agent any

  environment {
    KLOCWORK_URL = "http://localhost:8080"
    KLOCWORK_PROJECT = "zlib-pipeline"
    KLOCWORK_LICENSE_HOST = "flexlm-server"
    KLOCWORK_LICENSE_PORT = "27000"
    KLOCWORK_LTOKEN = ""
  }

  stages {
    stage('Get src from git') {
      steps {
        git 'https://github.com/madler/zlib.git'
      }
    } // stage : clone code

    stage('Klocwork Build') {
      steps {
        klocworkBuildSpecGeneration([
          additionalOpts: '',
          buildCommand: 'c:\\dev\\zlib-git.bat',
          ignoreErrors: true,
          output: 'kwinject.out',
          tool: 'kwinject'
        ])
      }
    } // stage : klocwork build

    stage('Klocwork Analysis') {
      steps {
        klocworkIntegrationStep1([
          additionalOpts: '',
          buildSpec: 'kwinject.out',
          disableKwdeploy: true,
          duplicateFrom: '',
          enabledCreateProject: true,
          ignoreCompileErrors: true,
          importConfig: '',
          incrementalAnalysis:       false,
          tablesDir: 'kwtables'
        ])
      }
    } // stage : klocwork analysis

    stage('Klocwork Db-load') {
      steps {
        klocworkIntegrationStep2 reportConfig: [
                                   displayChart: true,
                                   query: 'status:Analyze'
                                 ],
                                 serverConfig: [
                                   additionalOpts: '',
                                   buildName: '',
                                   tablesDir: 'kwtables'
                                 ]
      }
    } // stage : klocwork db-load

    stage('Build Failure Conditions') {
      steps {
        klocworkFailureCondition([
          enableCiFailureCondition: true,
          failureConditionCiConfigs: [[
            withDiffList: true,
            diffFileList: 'my_list.txt',
            enableHTMLReporting: true,
            name: 'one',
            reportFile: '',
            threshold: '1',]]
        ])
      }
    } // stage : build failure conditions
  } // stages
} // pipeline
```

- [full static code analysis](https://www.perforce.com/webinars/kw/add-static-code-analysis-to-ci-cd-pipelines)
  ```groovy
  stage("full static code analysis") {
    steps{
      echo "performance integration analysis"
      klocworkIntegrationStep1([
        buildSpec: "${KLOCWORK_BUILDSPEC}",
        tableDir: "${KLONWORK_TABLES}",
        incrementalAnalysis : true,
        ignoreCompileErrors: false,
        importConfig : "",
        additionalOpts: "--replace-path ${WORKSPACE}=workspace",
        disableKwdeploy: true
      ])
    }
  }
  ```
