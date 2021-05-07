<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [environment](#environment)
  - [admin](#admin)
- [analysis](#analysis)
  - [initial a klocwork analysis](#initial-a-klocwork-analysis)
  - [full build analysis](#full-build-analysis)
  - [incremental build analysis](#incremental-build-analysis)
  - [load result from both windows and linux](#load-result-from-both-windows-and-linux)
  - [Using kwwrap plus kwinject to generate a build specification](#using-kwwrap-plus-kwinject-to-generate-a-build-specification)
- [authentication](#authentication)
  - [get ltoken](#get-ltoken)
- [api](#api)
  - [list builds info from project](#list-builds-info-from-project)
- [report](#report)
  - [creating a report](#creating-a-report)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [Klocwork Build integration for C Cplus plus projects EN](https://www.youtube.com/watch?v=2f4CfEU5CEI)
> - [Command Reference](https://docs.roguewave.com/en/klocwork/2020/commandreference)
> - [Troubleshooting an incomplete kwinject build specification](https://docs.roguewave.com/en/klocwork/2020/troubleshootinganincompletekwinjectbuildspecification)
> - [Providing a build specification template for your developers](https://docs.roguewave.com/en/klocwork/2020/providingabuildspecificationtemplateforyourdevelopers)
> - [Compiler options for kwbuildproject](https://docs.roguewave.com/en/klocwork/2020/compileroptionsforkwbuildproject#concept968)
> - [Klocwork Jenkins CI plugin](https://docs.roguewave.com/en/klocwork/current/jenkinsci)
> - [Continuous integration and Klocwork analysis](https://docs.roguewave.com/en/klocwork/current/continuousintegration)
> - [examples](https://docs.roguewave.com/en/klocwork/current/understandingtheworkflow)
> - [Klocwork - Knowledgebase](https://library.roguewave.com/display/SUPPORT/Klocwork+-+Knowledgebase)
> - [C/C++ integration build analysis - Cheat sheet](https://docs.roguewave.com/en/klocwork/current/ccintegrationbuildanalysischeatsheet)
> - [example about integrate with Jenkins](https://stackoverflow.com/questions/51731262/jenkins-declarative-pipeline-how-to-configure-the-klocwork-result-display-on-t)
> - [最佳实践：Klocwork增量/VerifyCI检查](http://www.360doc.com/content/17/0430/08/30774303_649740396.shtml)
{% endhint %}

## environment
> reference:
> - [Install and Configure Klocwork cmd client](https://scmabhishek.wordpress.com/2016/07/04/install-and-configure-klocwork-cmd-client/)
> - [User manual | Installation and Upgrade](https://manualzz.com/doc/44373012/installation-and-upgrade?__cf_chl_jschl_tk__=b7f12f6befde4217b2830af5cb69055d40841a0c-1619442763-0-AXJ6A-8dLrK6mjM4v5IvfVIbgptM2fMku23COnaWX2AXiowy0H1aVcEuRXfkHCy52vr0N6RqKejPmriTUTLIsGPCo9AldMujCF8gJflvp-uX-CiweHa5c3fP1KNvKgeOvVzhe-wBWDfbrJ0MyEvEks8cEHXjRj6cRnlP5ibFYByNE7jX3KXtH5tRZVr386HX0bcPCx5nyu_FgY-xEFCpuMmnEaP0Rhr_zeoQn85YrY61j7lGJAgnzdqgz1rC4ktkZ1i7ijdYgUTFNAFG_1_vQ4ox8Wj7hdab890-Tw-NtdrGoMoEq-4CeMxDEzlLYmFNNX1kM0EVJIv50J2v2H7GIdUNd_rV7y_wyhllUPbRe1COFvk1Ey7eAgsfJyKAW-Il6Z8NRlSaO-RdRcnZ6wpk2L2s6uuAzcNNWQM-8DiljKhGu9OT-FjeGtEXyBUxZPjY2LWF1k_fX2tb4S0GJGO7T09QPnlbAZa9VBFueEVeVSdzDocBByzn-BwknWpMr-dIJA)

### admin
> reference:
> - [Admin Tools](https://developer.klocwork.com/products/insight)
> - [Improving database performance](https://bullwhip.physio-control.com/documentation/help/concepts/improvingdatabaseperformance.htm)
> - [Backing up Klocwork data](https://bullwhip.physio-control.com/documentation/help/concepts/backingupklocworkdata.htm)

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
    $ kwbuildproject --url "http://my.kw.com/NotepadPlusPlus" --tables-directory "~/npp/npp_tables" "~/npp/npp.out"
    ```

- load the database on windows
  ```bash
  $ kwadmin --url "<kw_url:kw_port>" \
            load "<project_name>" \
            "<table_path>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url "http://my.kw.com/NotepadPlusPlus" load NotepadPlusPlus "~/npp/npp_tables"
    ```

### [Using kwwrap plus kwinject to generate a build specification](https://docs.roguewave.com/en/klocwork/current/usingkwwrappluskwinjecttogenerateabuildspecification)
> reference:
> - [Using a build trace to troubleshoot build specification problems](https://docs.roguewave.com/en/klocwork/current/usingabuildtracetotroubleshootbuildspecificationproblems#concept972)
> - [Can I concatenate the results of more than one kwinject.out file?](https://developer.klocwork.com/community/forums/klocwork-insight/general-discussion/can-i-concatenate-results-more-one-kwinjectout)
> - [Running a distributed analysis](https://bullwhip.physio-control.com/documentation/help/concepts/runningadistributedanalysis.htm)

{% hint style='tip' %}
> Note:
> For [distributed builds](https://docs.roguewave.com/en/klocwork/current/runningadistributedklocworkccanalysis), you must run the following procedure on all build machines and merge the resultant build trace files.
{% endhint %}

* inserting the kwwrap command line before your compiler and linker names
  ```c
  CC = gcc
  ```

  convert to

  ```c
  CC = kwwrap -o <path_to_kwwrap_trace_file> gcc
  ```
* execute the build command
* Convert the build trace into a build specification with [kwinject](https://docs.roguewave.com/en/klocwork/current/kwinject)
  ```bash
  $ kwinject --trace-in <path_to_kwwrap_trace_file> --output <path_to_kwinject_output_file>
  ```
  - i.e.:
    ```bash
    $ kwinject --trace-in C:/temp/kwwrap.trace --output C:Klocwork/temp/kwinject.out
    ```

#### [When editing the makefile is not an option](https://docs.roguewave.com/en/klocwork/current/usingkwwrappluskwinjecttogenerateabuildspecification#Wheneditingthemakefileisnotanoption)
- Using environment variables
- Creating wrapper scripts
- Use kwwrap with CMake

## authentication
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
    $ curl --data "action=builds&user=marslo&ltoken=abcd1234********************************************************&project=marslo-kw" https://my.kw.com:443/review/api
    {"id":3,"name":"build_3","date":1619437882164,"keepit":false}
    {"id":2,"name":"build_2","date":1619436216567,"keepit":false}
    {"id":1,"name":"build_1","date":1619434698145,"keepit":false}
  ```

- [via `kwadmin`](https://docs.roguewave.com/en/klocwork/current/kwadmin)
  ```bash
  $ kwadmin --url https://my.kw.com:443  list-builds marslo-kw
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
$ curl --data "action=search&user=${username}&ltoken=${ltoken}&project=${project}&query=${query}" ${url}/review/api |
     jq --raw-output .
```

## report
### [creating a report](https://docs.roguewave.com/en/klocwork/current/creatingareport)
