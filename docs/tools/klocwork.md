<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [initial a klocwork analysis](#initial-a-klocwork-analysis)
- [full build analysis](#full-build-analysis)
- [incremental build analysis](#incremental-build-analysis)
- [load result from both windows and linux](#load-result-from-both-windows-and-linux)

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
{% endhint %}

## analysis
> [issue severity](http://docs.klocwork.com/Insight-10.0/Issue_severity)
  > 1 - Critical
  > 2 - Error
  > 3 - Warning
  > 4 - Review
  > 5 - Severity 5
  > 6 - Severity 6
  > 7 - Severity 7
  > 8 - Severity 8
  > 9 - Severity 9
  > 10 - Severity 10

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
>
> details:
> Klocwork Static Code Analysis Web API Reference
> To access Web API send a POST request to http://ssdfw-klocwork.marvell.com/review/api with the following parameters:
  > user*     Klocwork user name
  > ltoken    kwauth login token
  > action*   action name
>
> builds
> Retrieve the list of builds for a project.
> Example: curl --data "action=builds&user=myself&project=my_project" http://ssdfw-klocwork.marvell.com/review/api
  > project* project name

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
  $ curl --data "action=builds&user=<user_account>&ltoken=<ltoken>&project=<projct_name>" http://ssdfw-klocwork.marvell.com/review/api
  ```
  - i.e.:
    ```bash
    $ curl --data "action=builds&user=marslo&ltoken=abcd1234********************************************************&project=marslo-kw" https://ssdfw-klocwork.marvell.com:443/review/api
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
> api details:
>
> **search**
> Retrieve the list of detected issues.
> Example: `curl --data "action=search&user=myself&project=my_project&query=file:MyFile.c" http://my.kw.com/review/api`
> project* project name
> query    search query, such as narrowing by file (for example, 'file:MyFile.c')
> view     view name
> limit    search result limit
> summary  include summary record to output stream

```bash
$ ltoken='abcd1234*****'
$ username='marslo'
$ project='marslo-kw'
$ query='build:build_3 state:New'
$ url='https://my.kw.com:443'
$ curl --data "action=search&user=${username}&ltoken=${ltoken}&project=${project}&query=${query}" ${url}/review/api |
     jq --raw-output .
```
