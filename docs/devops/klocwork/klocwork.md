<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

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
- [import your projects and server settings](#import-your-projects-and-server-settings)
- [report](#report)
  - [creating a report](#creating-a-report)
- [CI](#ci)
  - [Jenkinsfile](#jenkinsfile)
- [ssl](#ssl)
  - [renew LDAP cert](#renew-ldap-cert)
  - [using a secure klocwork server connection](#using-a-secure-klocwork-server-connection)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [* Klocwork Documentation](https://help.klocwork.com/current/en-us/concepts/home.htm)
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
> - checkers
>   - [C and C++ checker reference](https://help.klocwork.com/current/en-us/concepts/candccheckerreference.htm)
>     - [UNUSED.FUNC.GEN](https://help.klocwork.com/current/en-us/reference/unused.func.gen.htm)
>     - [UNUSED.FUNC.WARN](https://help.klocwork.com/current/en-us/reference/unused.func.warn.htm)
>   - [CERT community C and C++ checker reference](https://help.klocwork.com/current/en-us/concepts/certcommunitycandccheckerreference.htm)
> - [How can I know which parts in the code are never used?](https://stackoverflow.com/a/4814564/2940319)
>   - `-Wunused`
>   - `-Wunreachable-code`
> - [How do I locate Uncalled Functions?](https://softwareengineering.stackexchange.com/q/157774/56124)
>   - [Cppcheck](https://cppcheck.sourceforge.io/)
>     ```bash
>     $ cppcheck --enable=unusedFunction .
>     Checking foo.c...
>     1/2 files checked 0% done
>     Checking main.c...
>     2/2 files checked 0% done
>     [foo.c:1]: (style) The function 'foo' is never used.
>     ```
> - [Dead code detection in legacy C/C++ project](https://stackoverflow.com/questions/229069/dead-code-detection-in-legacy-c-c-project)
{% endhint %}

## environment
> reference:
> - [Install and Configure Klocwork cmd client](https://scmabhishek.wordpress.com/2016/07/04/install-and-configure-klocwork-cmd-client/)
> - [User manual | Installation and Upgrade](https://manualzz.com/doc/44373012/installation-and-upgrade?__cf_chl_jschl_tk__=b7f12f6befde4217b2830af5cb69055d40841a0c-1619442763-0-AXJ6A-8dLrK6mjM4v5IvfVIbgptM2fMku23COnaWX2AXiowy0H1aVcEuRXfkHCy52vr0N6RqKejPmriTUTLIsGPCo9AldMujCF8gJflvp-uX-CiweHa5c3fP1KNvKgeOvVzhe-wBWDfbrJ0MyEvEks8cEHXjRj6cRnlP5ibFYByNE7jX3KXtH5tRZVr386HX0bcPCx5nyu_FgY-xEFCpuMmnEaP0Rhr_zeoQn85YrY61j7lGJAgnzdqgz1rC4ktkZ1i7ijdYgUTFNAFG_1_vQ4ox8Wj7hdab890-Tw-NtdrGoMoEq-4CeMxDEzlLYmFNNX1kM0EVJIv50J2v2H7GIdUNd_rV7y_wyhllUPbRe1COFvk1Ey7eAgsfJyKAW-Il6Z8NRlSaO-RdRcnZ6wpk2L2s6uuAzcNNWQM-8DiljKhGu9OT-FjeGtEXyBUxZPjY2LWF1k_fX2tb4S0GJGO7T09QPnlbAZa9VBFueEVeVSdzDocBByzn-BwknWpMr-dIJA)
> - [Klocwork Desktop for C/C++ project setup overview](https://docs.roguewave.com/en/klocwork/current/klocworkdesktopforccprojectsetupoverview)
> - video: [Build integration for C/C++ projects](https://developer.klocwork.com/resources/videos/build-integration-cc-projects)
> - video: [Klocwork Demo](https://www.perforce.com/success/klocwork-demo)
> - [Useful resources](https://developer.klocwork.com/resources/videos/build-integration-cc-projects)
> - [Creating the Python script](https://help.klocwork.com/current/en-us/concepts/creatingthepythonscript.htm)
> - [bwinhwang/PyKW](https://github.com/bwinhwang/PyKW)

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
    $ kwbuildproject --url "http://klocwork.domain.com/NotepadPlusPlus" --tables-directory "~/npp/npp_tables" "~/npp/npp.out"
    ```

- load the database
  ```bash
  $ kwadmin --url "<kw_url:kw_port>" \
            load "<project_name>" \
            "<table_path>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url "http://klocwork.domain.com" load "NotepadPlusPlus" "~/npp/npp_tables"
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
    $ kwbuildproject --url "http://klocwork.domain.com/NotepadPlusPlus" --tables-directory "~/npp/npp_tables" --force "~/npp/npp.out"
    ```

- load the result
  ```bash
  $ kwadmin --url "<kw_url:kw_port>" \
            load "<project_name>" \
            "<table_path>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url http://klocwork.domain.com/ load NotepadPlusPlus "~/npp/npp_tables"
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
    $ kwbuildproject --url "http://klocwork.domain.com/NotepadPlusPlus" --tables-directory "~/npp/npp_tables" --incremental "~/npp/npp_tables"
    ```

- load the result
  ```bash
  $ kwadmin --url "<kw_url:kw_port>" \
            load "<project_name>" \
            "<table_path>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url "http://klocwork.domain.com" load NotepadPlusPlus "~/npp/npp_tables"
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
    $ kwadmin --url http://klocwork.domain.com create-project NotepadPlusPlus
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
    $ kwbuildproject --url "http://klocwork.domain.com/NotepadPlusPlus" \
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
    $ kwadmin --url "http://klocwork.domain.com/NotepadPlusPlus" \
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

> [!NOTE|label:references:]
> - [Command Reference](https://help.klocwork.com/current/en-us/concepts/commandreference.htm)
> - [Support Portal](https://portal.perforce.com/s/topic/0TO5Y00000ByxvlWAB/klocwork)
>   - [Klocwork Downloads: 2023.3](https://portal.perforce.com/s/article/Klocwork-Downloads-2023-3)
>     - [kwbuildtools.23.3.0.57.linux64.zip](https://dslwuu69twiif.cloudfront.net/klocwork/23.3.0.57/kwbuildtools.23.3.0.57.linux64.zip)
>     - [kwbuildtools.23.3.0.57.win64.zip](https://dslwuu69twiif.cloudfront.net/klocwork/23.3.0.57/kwbuildtools.23.3.0.57.win64.zip)
>   - [Klocwork Downloads: 2023.2](https://portal.perforce.com/s/article/Klocwork-Downloads-2023-2)
>     - [kwbuildtools.23.2.0.66.linux64.zip](https://dslwuu69twiif.cloudfront.net/klocwork/23.2.0.66/kwbuildtools.23.2.0.66.linux64.zip)
>     - [kwbuildtools.23.2.0.66.win64.zip](https://dslwuu69twiif.cloudfront.net/klocwork/23.2.0.66/kwbuildtools.23.2.0.66.win64.zip)

```bash
$ export KLOCWORK_LTOKEN=/home/marslo/.klocwork/ltoken
$ kwauth --url https://klocwork.domain.com:443
Login: marslo
Password: ****
$ cat /home/marslo/.klocwork/ltoen
klocwork.domain.com;443;marslo;abcdefg1234567**************************************************
```

## import your projects and server settings

> [!NOTE|label:references:]
> - [Import your projects and server settings](https://help.klocwork.com/current/en-us/concepts/importyourprojectsandserversettings.htm)
> - [Import your projects and server settings](https://help.klocwork.com/current/en-us/concepts/examples2.htm)
> - [Import your existing projects into a new projects root](https://help.klocwork.com/current/en-us/concepts/importyourexistingprojectsintoanewprojectsroot.htm)
> - [Using the search API](https://help.klocwork.com/current/en-us/concepts/usingthesearchapi.htm)
> - [kwadmin import-config](https://help.klocwork.com/current/en-us/reference/kwadmin.htm)
> - [Kwxsync](https://help.klocwork.com/current/en-us/reference/kwxsync.htm)

- api
  ```bash
  # import project
  $ curl --data "action=import_project&user=myself&project=my_project&sourceURL=http://oldserver:8080&sourceAdmin=user&sourcePassword=pwd" http://local.klocwork.com:8080/review/api

  # import server configuration
  $ curl --data "action=import_server_configuration&user=myself&sourceURL=http://oldserver:8080&sourceAdmin=user&sourcePassword=pwd" http://local.klocwork.com:8080/review/api
  ```

- cli
  ```bash
  # import
  $ kwadmin import-config <project_name> <file>
  # i.e.:
  $ kwadmin import-config workspace C:\Klocwork\OurMetrics.mconf

  # export
  $ kwadmin export-config [options] <project-name> <server-file> <local-file>
  # i.e.:
  $ kwadmin export-config Toolbus ExportedOurMetrics.mconf C:\Klocwork\OurMetrics.mconf
  ```

  ```bash
  # kwxsync import single project
  $ kwxsync [<options>] <project_name_1>|<project_URL_1> <project_name_2>|<project_URL_2> [...]

  # i.e.:
  $ kwxsync --url https://klocwork.domain.com:443 -f -c project project-backup
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

## ssl
### renew LDAP cert

> [!NOTE|label:references:]
> - keytool and java : `/opt/Klocwork/Server/_jvm/bin`
> - [Security Best Practices + Klocwork](https://www.perforce.com/blog/kw/security-best-practices#best)
> - [Simple bind failed error when trying to connect to Active Directory](https://analyst.phyzdev.net/documentation/help/concepts/simplebindfailederrorwhentryingtoconnecttoactivedirectory.htm)
> - [Klocwork 部署的安全最佳实践](https://xie.infoq.cn/article/421efc31cd471a3ab2e3991fb)
> - [[SOLVED]-LDAPS : SIMPLE BIND FAILED-JAVA](https://www.appsloveworld.com/java/100/402/ldaps-simple-bind-failed)
>   ```bash
>   - -djdk.tls.client.protocols=tlsv1
>   + -djdk.tls.client.protocols=tlsv1,tlsv1.1,tlsv1.2,tlsv1.3
>   ```
> - [2020.4.1](https://ssdfw-klocwork.marvell.com/documentation/help/)
>   - [Error occurred during SSL handshake](https://analyst.phyzdev.net/documentation/help/concepts/p4errorduringsslhandshake.htm)
>   - [Using a secure Klocwork Server connection](https://analyst.phyzdev.net/documentation/help/concepts/usingasecureklocworkserverconnection.htm)
>   - [Troubleshooting](https://analyst.phyzdev.net/documentation/help/concepts/troubleshootingcr.htm)
>   - [Setting up LDAP access control](https://analyst.phyzdev.net/documentation/help/concepts/settingupldapaccesscontrol.htm)

```bash
$ keytool -import -alias ldaproot  -file rootca.cer -keystore cacerts
$ keytool -import -alias ldapInter -file inter.cer  -keystore cacerts
$ keytool -import -alias ldap      -file ldap.cer   -keystore cacerts
```

### using a secure klocwork server connection

> [!TIP]
> for klocwork 2020.4 Build 20.4.0.81

- Create a self-signed keystore file
  ```bash
  # from <server_install>, run the following command:
  # The keystore is saved into the Tomcat config directory at <projects_root>/tomcat/conf.
  $ _jvm/bin/keytool -genkeypair -alias tomcat \
                     -keyalg RSA \
                     -keystore <projects_root>/tomcat/conf/.keystore \
                     -dname "cn=<KlocworkServer_hostname>, ou=<your_organizational_unit>,o=<your_organization>" \
                     -keypass changeit \
                     -storepass changeit

  # i.e.:
  $ _jvm/bin/keytool -genkeypair -alias tomcat \
                     -keyalg RSA \
                     -keystore <projects_root>/tomcat/conf/.keystore \
                     -dname "cn=testserver.klocwork.com, ou=Development, o=Klocwork" \
                     -keypass changeit \
                     -storepass changeit
  ```

- Configure the Klocwork Server to use SSL (manually)
  ```bash

  $ grep klocwork.protocol <projects_root>/config/admin.conf
  - klocwork.protocol=http
  + klocwork.protocol=https

  $ grep Connector <projects_root>/tomcat/conf/server.template
  -  <Connector port="$PORT" protocol="org.apache.coyote.http11.Http11NioProtocol" maxThreads="64" minSpareThreads="20" redirectPort="8443" acceptCount="200" connectionTimeout="20000" URIEncoding="UTF-8" compression="on" compressionMinSize="2048" noCompressionUserAgents="gozilla,traviata" compressableMimeType="text/html,text/xml,text/javascript" maxPostSize="-1" />
  +  <Connector port="$PORT" maxthreads="4-" minSpareThreads="20" maxSpareThreads="40" enableLooksups="false" redirectPort="8443" acceptCount="50" debug="0" connectionTimeout="20000" compression="on" compressionMinSize="2048" noCompressionUserAgents=".*MSIE.*,gozilla,traviata" compressableMimeType="text/html,text/xml" maxPostSize="0" />
  ```

- restart klocwork service

  > [!TIP|label:see also:]
  > - [iMarslo: start/restart service](kwservice.html#startrestart-service)

  ```bash
  $ kwservice --projects-root <projects_root> stop
  $ kwservice --projects-root <projects_root> start

  # or
  $ kwservice --projects-root <projects_root> restart klocwork
  ```

- verify
  ```bash
  $ kwadmin --ssl --host klocwork.example.com -port 443 list-projects
  # same as
  $ kwadmin --url https://klocwork.example.com:443 list-projects
  ```

- disabling the ssl connection

  > [!NOTE]
  > - Simple bind failed error when trying to connect to Active Directory
  >   ```bash
  >   simple bind failed: ad.hostname.com:636
  >   ```

  1. import the ldap server public certificate directly into the klocwork keystore

   ```bash
   # location
   <path_to_JVM_install>\_jvm\lib\security\cacerts
   ```

  2. [ask your LDAP administrator to set this extension of your LDAP server certificate to non-critical](http://blogs.technet.com/b/askds/archive/2008/09/16/third-party-application-fails-using-ldap-over-ssl.aspx)

  > [!NOTE|label:references:]
  > - [Third Party Application Fails Using LDAP over SSL](https://techcommunity.microsoft.com/t5/ask-the-directory-services-team/third-party-application-fails-using-ldap-over-ssl/ba-p/395650)
  > - [Troubleshoot LDAP over SSL connection problems](https://learn.microsoft.com/en-us/troubleshoot/windows-server/identity/ldap-over-ssl-connection-issues)
  > - [Enable LDAP over SSL (LDAPS) for Microsoft Active Directory servers](https://gist.github.com/magnetikonline/0ccdabfec58eb1929c997d22e7341e45)
  > - [Enable LDAP over SSL with a third-party certification authority](https://learn.microsoft.com/en-US/troubleshoot/windows-server/identity/enable-ldap-over-ssl-3rd-certification-authority)
  > - [How to Enable LDAP over TLS on a SonicWall without a Certificate Authority (CA)](https://content.spiceworksstatic.com/service.community/p/post_attachments/0000176808/597a8c40/attached_file/Enable_LDAP_over_TLS_on_a_SonicWall_without_a_CA.pdf)
  > - [LDAP over SSL configuration in Active Directory](https://community.spiceworks.com/topic/2279275-ldap-over-ssl-configuration-in-active-directory)
  > - [Windows Server – Enable LDAPS](https://www.petenetlive.com/KB/Article/0000962)
