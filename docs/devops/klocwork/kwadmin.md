<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [list projects and properties](#list-projects-and-properties)
- [project](#project)
  - [create project](#create-project)
  - [delete project](#delete-project)
  - [duplicate project](#duplicate-project)
  - [rename project](#rename-project)
- [project properties](#project-properties)
  - [get project properties](#get-project-properties)
  - [set project properties](#set-project-properties)
- [project configuration files](#project-configuration-files)
  - [list configuration files](#list-configuration-files)
  - [list configuration types](#list-configuration-types)
  - [import configuration files](#import-configuration-files)
  - [delete configuration files](#delete-configuration-files)
- [build](#build)
  - [list builds](#list-builds)
  - [delete build](#delete-build)
  - [rename build](#rename-build)
  - [keep <numbers> builds by default](#keep-numbers-builds-by-default)
- [Project properties displayed by kwadmin](#project-properties-displayed-by-kwadmin)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> reference:
> - command line references:
>   - [kwadmin](https://help.klocwork.com/current/en-us/reference/kwadmin.htm)
>   - [Kwagent](https://help.klocwork.com/current/en-us/reference/kwagent.htm)
>   - [Kwauth](https://help.klocwork.com/current/en-us/reference/kwauth.htm)
>   - [Kwcheck](https://help.klocwork.com/current/en-us/reference/kwcheck.htm)
>   - [Kwciagent](https://help.klocwork.com/current/en-us/reference/kwciagent.htm)
>   - [Kwinject](https://help.klocwork.com/current/en-us/reference/kwinject.htm)
>   - [Kwwrap](https://help.klocwork.com/current/en-us/reference/kwwrap.htm)
> - [kwadmin](https://bullwhip.physio-control.com/documentation/help/reference/kwadmin.htm)
> - [Reference for integration project and build properties](https://docs.roguewave.com/en/klocwork/current/referenceforintegrationprojectandbuildproperties)
> - [Build properties displayed by kwadmin](https://bullwhip.physio-control.com/documentation/help/concepts/buildpropertiesdisplayedbykwadmin.htm)
> - [Admin Tools](https://developer.klocwork.com/products/insight)
> - [Improving database performance](https://bullwhip.physio-control.com/documentation/help/concepts/improvingdatabaseperformance.htm)
> - [Backing up Klocwork data](https://bullwhip.physio-control.com/documentation/help/concepts/backingupklocworkdata.htm)
> - [Build properties displayed by kwadmin](https://bullwhip.physio-control.com/documentation/help/concepts/buildpropertiesdisplayedbykwadmin.htm)

{% endhint %}

## list projects and properties
```bash
$ kwadmin list-projects
```

## project
### create project
```bash
$ kwadmin create-project <project_name> [--encoding utf-8]
```

### delete project
```bash
$ kwadmin delete-project <project_name>
```

### duplicate project
```bash
$ kwadmin duplicate-project <original_name> <new_name>
```

### rename project
```bash
$ kwadmin rename-project <project_name> <new_project_name>
```

## project properties
### get project properties
```bash
$ kwadmin get-project-properties <project_name>
```

### set project properties
```bash
$ kwadmin set-project-property <project_name> <property> <value>
```

- change [`Issue grouping`](https://help.klocwork.com/current/en-us/concepts/issuegrouping.htm)

  > previous url : [issue grouping](https://docs.roguewave.com/en/klocwork/current/issuegrouping)

  ```bash
  $ kwadmin set-project-property <sample> grouping_on_default false
  ```

## project configuration files
> [Configuration files that you can import into integration projects](https://bullwhip.physio-control.com/documentation/help/concepts/managingconfigurationfilesforintegrationprojects.htm#Configurationfilesthatyoucanimportintointegrationprojects)

### list configuration files
```bash
$ kwadmin list-config-files <project_name>
```
- example
  ```bash
  $ kwadmin list-config-files sample_project
  analysis_profile.pconf (Problems Configuration)
  metrics_default.mconf (Metrics Thresholds)
  kw_override.h (Override File)
  ```

### list configuration types
```bash
$ kwadmin list-config-types
Build Specification Template (.tpl)
User Defined Attributes (.atr)
Source Ownership (.sow)
User Metrics (.ume)
Size of Types (.szt)
User Defined Relationships (.rel)
Taxonomy Configuration (.tconf)
Metrics Thresholds (.mconf)
Override File (.h)
Problems Configuration (.pconf)
Java Function Behavior Knowledge Base (.jkb)
Function Behavior Knowledge Base (.kb)
```

### import configuration files
```bash
$ kwadmin import-config <project_name> <file>
```

### delete configuration files
```bash
$ kwadmin delete-config <project_name> <file>
```

## build
### list builds
```bash
$ kwadmin list-builds <project_name>
```

### delete build
```bash
$ kwadmin delete-build <project_name> <build_name>
```

### rename build
```bash
$ kwadmin rename-build <project_name> <build_name> <new_build_name>
```

### keep <numbers> builds by default
```bash
$ kwadmin set-project-property <project_name> auto_delete_threshold <nubmers>
```


## [Project properties displayed by kwadmin](https://docs.roguewave.com/en/klocwork/current/referenceforintegrationprojectandbuildproperties)

|                 Property                | Description                                                                                                                                                                                                                                                                   |
|:---------------------------------------:|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|         `auto_delete_threshold`         | specifies the number of builds to save when the auto delete feature is enabled                                                                                                                                                                                                |
|           `bug_tracker_schema`          | Used to replace {0} with id, and convert id to a hyperlink                                                                                                                                                                                                                    |
|              `copy_tables`              | specifies whether Klocwork tables will be copied to projects_root by kwadmin load                                                                                                                                                                                             |
|              `description`              | project description                                                                                                                                                                                                                                                           |
|          `grouping_on_default`          | changes the way the system displays server issues. By default, desktop issues are shown with grouping off while server issues are shown with grouping on. If you want server issues for a project to persistently show issues with grouping off, change the setting to false. |
|                `language`               | programming language of the source files in the project                                                                                                                                                                                                                       |
|                 `locale`                | overrides the locale for the project set during project creation. Should only be set before running an integration build analysis with kwbuildproject, so that the language of issue messages and traceback will be consistent in all builds                                  |
|            `source_encoding`            | language encoding of project source files. See kwadmin create-project.                                                                                                                                                                                                        |
