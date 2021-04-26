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

### [initial a klocwork analysis](https://docs.roguewave.com/en/klocwork/2020/runningyourfirstintegrationbuildanalysis1)
> [sample code](http://cdn-devnet.klocwork.com/cbt/10.0/C_CPP_integration_build_analysis/samples/newProject.txt)

- capture build settings
  ```bash
  $ kwinject --output "<.out path>" <original build command>
  ```
  - i.e.:
    ```bash
    $ kwinject --output "~/npp/npp.out" devenv "~/npp/PowerEditor/visual.net/notepadPlus.sln" /Rebuild
    ```

- run an analysis using the build spec
  ```bash
  $ kwbuildproject --url "<kw url>/<project name>" \
                   --tables-directory "<table path>" \
                   "<.out path>"
  ```
  - i.e.:
    ```bash
    $ kwbuildproject --url "http://my.kw.com/NotepadPlusPlus" --tables-directory "~/npp/npp_tables" "~/npp/npp.out"
    ```

- load the database
  ```bash
  $ kwadmin --url "<kw url>/<project name>" \
            load "<project name>" \
            "<table path>"
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
  $ kwbuildproject --url "<kw url>/<project name>" \
                   --tables-directory "<table path>" \
                   --force "<.out file>"
  ```
  - i.e.:
    ```bash
    $ kwbuildproject --url "http://my.kw.com/NotepadPlusPlus" --tables-directory "~/npp/npp_tables" --force "~/npp/npp.out"
    ```

- load the result
  ```bash
  $ kwadmin --url "<kw url>" \
            load "<project name>" \
            "<table path>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url http://my.kw.com/ load NotepadPlusPlus "~/npp/npp_tables"
    ```

### [incremental build analysis](https://docs.roguewave.com/en/klocwork/2020/runningyournextintegrationbuildanalysis1#Runningincrementalanalysis)
> [sample code](http://cdn-devnet.klocwork.com/cbt/10.0/C_CPP_integration_build_analysis/samples/incremental.txt)

- update the build settings
  ```bash
  $ kwinject --update "<.out path>" <original build command>
  ```
  - i.e.:
    ```bash
    $ kwinject --update "~/npp/npp.out" devenv "~/npp/PowerEditor/visual.net/notepadPlus.sln" /Build
    ```

- execute the incremental analysis
  ```bash
  $ kwbuildproject --url "<kw url>/<project name>" \
                   --tables-directory "<table path>" \
                   --incremental "<table path>"
  ```
  - i.e.:
    ```bash
    $ kwbuildproject --url "http://my.kw.com/NotepadPlusPlus" --tables-directory "~/npp/npp_tables" --incremental "~/npp/npp_tables"
    ```

- load the result
  ```bash
  $ kwadmin --url "<kw url>" \
            load "<project name>" \
            "<table path>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url "http://my.kw.com" load NotepadPlusPlus "~/npp/npp_tables"
    ```

### load result from both windows and linux
> [sample code](http://cdn-devnet.klocwork.com/cbt/10.0/C_CPP_integration_build_analysis/samples/Windows-Unix.txt)

- create an integration project on kw server via command line
  ```bash
  $ kwadmin --url "<kw url>" \
            create-project "<project name>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url http://my.kw.com create-project NotepadPlusPlus
    ```

- capture build settings on linux machine
  ```bash
  $ kwinject --output "<.out path>" <original build command>
  ```
  - i.e.:
    ```bash
    $ kwinject --output "~/npp/npp.out" make
    ```

- run an analysis using the build spec on linux
  ```bash
  $ kwbuildproject --url "<kw url>/<project name>" \
                   --tables-directory "<table path>" \
                   "<.out path>"
  ```
  - i.e.:
    ```bash
    $ kwbuildproject --url "http://my.kw.com/NotepadPlusPlus" --tables-directory "~/npp/npp_tables" "~/npp/npp.out"
    ```

- load the database on windows
  ```bash
  $ kwadmin --url "<kw url>/<project name>" \
            load "<project name>" \
            "<table path>"
  ```
  - i.e.:
    ```bash
    $ kwadmin --url "http://my.kw.com/NotepadPlusPlus" load NotepadPlusPlus "~/npp/npp_tables"
    ```

