<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [api](#api)
  - [list all projects](#list-all-projects)
  - [list builds info from project](#list-builds-info-from-project)
- [actions](#actions)
  - [server](#server)
  - [access](#access)
  - [project](#project)
  - [builds](#builds)
  - [issue](#issue)
  - [report](#report)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## [api](https://docs.roguewave.com/en/klocwork/current/formattingrequeststotheapi1)

> [!NOTE]
> api url: http(s)://sample.klocwork.com:443/review/api
> reference:
> - [Klocwork Web API cookbook](https://docs.roguewave.com/en/klocwork/current/klocworkwebapicookbook)
> - [Klocwork Code Review Web API cookbook](https://help.klocwork.com/current/en-us/concepts/klocworkcrwebapicookbook.htm)
> - [Klocwork Insight Web API cookbook](http://docs.klocwork.com/Insight-10.0/Klocwork_Insight_Web_API_cookbook)
> - [Access control API examples](https://docs.roguewave.com/en/klocwork/2020/examples_webacl)
> - [Issue and metric API examples](https://docs.roguewave.com/en/klocwork/2020/examples2)
> - [Authentication using the ltoken](https://help.klocwork.com/current/en-us/concepts/klocworkltoken.htm)
>   - `$ export KLOCWORK_LTOKEN=/path/to/ltoken`
>   - default path for kwauth:
>     - Windows: `%APPDATA%\.klocwork\ltoken`
>     - Unix: `~/.klocwork/ltoken`
>     - Mac: `~/.klocwork/ltoken`

Klocwork Static Code Analysis Web API Reference
> to access Web API send a POST request to http://sample.klocwork.com/review/api with the following parameters:
> - user*     Klocwork user name
> - ltoken    kwauth login token
> - action*   action name
>   - `builds`: retrieve the list of builds for a project.
>   - example: `curl --data "action=builds&user=myself&project=project_name" http://sample.klocwork.com/review/api`
>     - project* : project name
>     - username : username

### list all projects
```bash
$ username='account'
$ ltoken='abc123**********************************************************'
$ url='https://sample.klocwork.com:8080'
$ curl -skg \
       --data "action=projects&user=${username}&ltoken=${ltoken}" \
       "${url}/review/api" |
  jq -r .id
```

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
  $ curl --data "action=builds&user=<user_account>&ltoken=<ltoken>&project=<projct_name>" http://sample.klocwork.com/review/api
  ```
  - i.e.:
    ```bash
    $ curl --data "action=builds&user=marslo&ltoken=abcd1234****&project=marslo-kw" \
           https://sample.klocwork.com:443/review/api
    {"id":3,"name":"build_3","date":1619437882164,"keepit":false}
    {"id":2,"name":"build_2","date":1619436216567,"keepit":false}
    {"id":1,"name":"build_1","date":1619434698145,"keepit":false}
  ```

- [via `kwadmin`](https://docs.roguewave.com/en/klocwork/current/kwadmin)
  ```bash
  $ kwadmin --url https://sample.klocwork.com:443 list-builds marslo-kw
  build_1
  build_2
  build_3
  ```
  - list project config files
    ```bash
    $ kwadmin --url https://sample.klocwork.com:443 list-config-files marslo-kw
    analysis_profile.pconf (Problems Configuration)
    metrics_default.mconf (Metrics Thresholds)
    ```

#### [query only new issues](https://stackoverflow.com/a/28774031/2940319)
> [!NOTE:label:references:]
> - [Using the search API](https://bullwhip.physio-control.com/documentation/help/concepts/usingthesearchapi.htm)

**search**
> retrieve the list of detected issues.
> - example: `curl --data "action=search&user=myself&project=my_project&query=file:MyFile.c" http://sample.klocwork.com/review/api`
>   - project* : project name
>   - query    : search query, such as narrowing by file (for example, 'file:MyFile.c')
>   - view     : view name
>   - limit    : search result limit
>   - summary  : include summary record to output stream

{% hint style='tip' %}
> [Searching in Klocwork Static Code Analysis](https://bullwhip.physio-control.com/documentation/help/concepts/searchinginklocworksca.htm#concept955):
> [Searching in Klocwork Static Code Analysis](https://help.klocwork.com/current/en-us/concepts/searchinginklocworksca.htm)
>
> **NOTE**: You can only search by one build at a time. Other acceptable syntax:
> - build:'123' - searches for build which contains substring '123'
> - build:+123 - searches for build with name 123
> - build:+'123string' - searches for build with name equal to '123string'
{% endhint %}

```bash
$ ltoken='abcd1234*****'
$ username='marslo'
$ project='marslo-kw'
$ query='build:build_3 state:New'
$ url='https://sample.klocwork.com:443'
$ curl --data "action=search&user=${username}&ltoken=${ltoken}&project=${project}&query=${query}" \
       ${url}/review/api |
       jq --raw-output .
```

## actions

> [!NOTE|label:references:]
> - [Klocwork Web API](./klocwork_web_api.html)

### server
|            ACTIONS            | DATA                                                                                                                 |
|:-----------------------------:|----------------------------------------------------------------------------------------------------------------------|
| `import_server_configuration` | `action=import_server_configuration&user=myself&sourceURL=http://oldserver:8080&sourceAdmin=user&sourcePassword=pwd` |
|        `license_count`        | `action=license_count&user=myself&feature=kwadmin10`                                                                 |
|         `task_status`         | `action=task_status&user=myself`                                                                                     |
|           `version`           | `action=version&user=myself`                                                                                         |

### access
|          ACTIONS          | DATA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
|:-------------------------:|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|          `roles`          | `action=roles&user=myself&search=rolename`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|       `create_role`       | `action=create_role&user=myself&name=myrole&create_project=true&manage_roles=false&change_issue_status=true&allowed_status_transitions=Any,Analyze;Analyze,Fix`                                                                                                                                                                                                                                                                                                                                                                                                     |
|       `delete_role`       | `action=delete_role&user=myself&name=my_role`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|          `users`          | `action=users&user=myself&search=username&limit=1000`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
|       `create_user`       | `action=create_user&user=myself&name=user_name&password=thepassword`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
|       `delete_user`       | `action=delete_user&user=myself&name=user_name`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
|     `role_assignments`    | `action=role_assignments&user=myself&search=rolename`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
|  `update_role_assignment` | `action=update_role_assignment&user=myself&name=myrole&project=myproject&account=jdoe&group=false&remove=falseaction=update_role_assignment&user=myself&name=myrole&project=myproject&account=jdoe&group=false&remove=falseaction=update_role_assignment&user=myself&name=myrole&project=myproject&account=jdoe&group=false&remove=falseaction=update_role_assignment&user=myself&name=myrole&project=myproject&account=jdoe&group=false&remove=falseaction=update_role_assignment&user=myself&name=myrole&project=myproject&account=jdoe&group=false&remove=false` |
| `update_role_permissions` | `action=update_role_permissions&user=myself&name=myrole&create_project=true&manage_roles=false&change_issue_status=true&allowed_status_transitions=Any,Analyze;Analyze,Fix`                                                                                                                                                                                                                                                                                                                                                                                         |

### project
|         ACTIONS         | DATA                                                                                                                       |
|:-----------------------:|----------------------------------------------------------------------------------------------------------------------------|
|         `groups`        | `action=groups&user=myself&search=groupname&limit=1000`                                                                    |
|      `create_group`     | `action=create_group&user=myself&name=group_name&users=User1,User2`                                                        |
|      `delete_group`     | `action=delete_group&user=myself&name=group_name`                                                                          |
|      `update_group`     | `action=update_group&user=myself&name=group_name&users=User1,User2`                                                        |
|        `projects`       | `action=projects&user=myself`                                                                                              |
|     `import_project`    | `action=import_project&user=myself&project=my_project&sourceURL=http://oldserver:8080&sourceAdmin=user&sourcePassword=pwd` |
|     `delete_project`    | `action=delete_project&user=myself&name=my_project`                                                                        |
|     `update_project`    | `action=update_project&user=myself&name=myproject&new_name=my_project`                                                     |
|     `import_status`     | `action=import_status&user=myself`                                                                                         |
|        `modules`        | `action=modules&user=myself&project=my_project`                                                                            |
| `project_configuration` | `action=project_configuration&user=myself&project=my_project&build=build_name`                                             |
|       `taxonomies`      | `action=taxonomies&user=myself&project=my_project`                                                                         |

### builds
|        ACTIONS       | DATA                                                                                                                      |
|:--------------------:|---------------------------------------------------------------------------------------------------------------------------|
|       `builds`       | `action=builds&user=myself&project=my_project`                                                                            |
|    `defect_types`    | `action=defect_types&user=myself&project=my_project`                                                                      |
| `update_defect_type` | `action=update_defect_type&user=myself&project=my_project&code=ECC.EMPTY&enabled=false`                                   |
|    `delete_build`    | `action=delete_build&user=myself&project=my_project&name=build_1`                                                         |
|    `create_module`   | `action=create_module&user=myself&project=my_project&name=test&allow_all=true&paths="**/test/*"`                          |
|    `delete_module`   | `action=delete_module&user=myself&project=my_project&name=my_module`                                                      |
|    `update_module`   | `action=update_module&user=myself&project=my_project&name=test&new_name=aux&allow_all=true&paths="**/test/*,**/assert/*"` |
|    `update_build`    | `action=update_build&user=myself&name=build_1&new_name=build_03_11_2011`                                                  |

### issue
|     ACTIONS     | DATA                                                                                                                     |
|:---------------:|--------------------------------------------------------------------------------------------------------------------------|
| `issue_details` | `action=issue_details&user=myself&project=my_project&id=650`                                                             |
|     `search`    | `action=search&user=myself&project=my_project&query=file:MyFile.c`                                                       |
| `update_status` | `action=update_status&user=myself&project=my_project&ids=ids_list&status=new_status&comment=new_comment&owner=new_owner` |

### report
|    ACTIONS    | DATA                                                                                 |
|:-------------:|--------------------------------------------------------------------------------------|
|    `views`    | `action=views&user=myself&project=my_project`                                        |
| `create_view` | `action=create_view&user=myself&project=my_project&name=critical&query=severity:1-3` |
| `delete_view` | `action=delete_view&user=myself&project=my_project&name=my_view`                     |
| `update_view` | `action=update_view&user=myself&project=my_project&tags=c,security&name=my_view`     |
|   `fchurns`   | `action=fchurns&user=myself&component=Component`                                     |
|   `metrics`   | `action=metrics&user=myself&project=my_project&query=file:MyFile.c`                  |
|    `report`   | `action=report&user=myself&project=my_project&build=build_1&x=Category&y=Component`  |
