<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [jira](#jira)
  - [myself](#myself)
  - [check fields](#check-fields)
  - [check attachment](#check-attachment)
  - [list all projects](#list-all-projects)
  - [search issue by JQL](#search-issue-by-jql)
  - [[get email address](Get Email Addresses For Users)](#get-email-addressget-email-addresses-for-users)
  - [api token](#api-token)
  - [generate OAuth consumer](#generate-oauth-consumer)
  - [icons and priority](#icons-and-priority)
- [confluence](#confluence)
  - [myself](#myself-1)
  - [get info](#get-info)
  - [publish to confluence](#publish-to-confluence)
  - [plugins](#plugins)
- [ACLI](#acli)
  - [running with docker images](#running-with-docker-images)
  - [create .acli.keystore](#create-aclikeystore)
  - [acli.properties](#acliproperties)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:reference:]
> - [* Confluence REST API examples](https://developer.atlassian.com/server/confluence/confluence-rest-api-examples/)
> - [* Jira REST API examples](https://developer.atlassian.com/server/jira/platform/jira-rest-api-examples/)
> - [Confluence Server REST API](https://developer.atlassian.com/server/confluence/confluence-server-rest-api/)
> - [./software/jira/docs/api/REST](https://docs.atlassian.com/software/jira/docs/api/REST/)
> - [JIRA Server platform REST API reference](https://docs.atlassian.com/software/jira/docs/api/REST/7.6.1/)
> - [Jenkins JIRA Pipeline Steps](https://jenkinsci.github.io/jira-steps-plugin/getting-started/)
>   - [Configuration](https://jenkinsci.github.io/jira-steps-plugin/getting-started/config/)
>     - [Authentication](https://jenkinsci.github.io/jira-steps-plugin/getting-started/config/authentication/)
>     - [Common Config](https://jenkinsci.github.io/jira-steps-plugin/getting-started/config/common/)
>     - [Jenkins Script](https://jenkinsci.github.io/jira-steps-plugin/getting-started/config/script/)
>     - [Configuration As Code Plugin](https://jenkinsci.github.io/jira-steps-plugin/getting-started/config/casc/)
>   - [Issue Steps](https://jenkinsci.github.io/jira-steps-plugin/steps/issue/)
>     - [jiraGetFields](https://jenkinsci.github.io/jira-steps-plugin/steps/issue/jira_get_fields/)
>     - [jiraGetIssue](https://jenkinsci.github.io/jira-steps-plugin/steps/issue/jira_get_issue/)
>     - [jiraEditIssue](https://jenkinsci.github.io/jira-steps-plugin/steps/issue/jira_edit_issue/)
>   - [Component Steps](https://jenkinsci.github.io/jira-steps-plugin/steps/component/)
>     - [jiraGetComponent](https://jenkinsci.github.io/jira-steps-plugin/steps/component/jira_get_component/)
>     - [jiraEditComponent](https://jenkinsci.github.io/jira-steps-plugin/steps/component/jira_edit_component/)
>     - [jiraGetComponentIssueCount](https://jenkinsci.github.io/jira-steps-plugin/steps/component/jira_get_component_issue_count/)
>   - [Comment Steps](https://jenkinsci.github.io/jira-steps-plugin/steps/comment/)
>     - [jiraGetComment](https://jenkinsci.github.io/jira-steps-plugin/steps/comment/jira_get_comment/)
>     - [jiraGetComments](https://jenkinsci.github.io/jira-steps-plugin/steps/comment/jira_get_comments/)
>     - [jiraAddComment](https://jenkinsci.github.io/jira-steps-plugin/steps/comment/jira_add_comment/)
>     - [jiraEditComment](https://jenkinsci.github.io/jira-steps-plugin/steps/comment/jira_edit_comment/)

## jira
{% hint style='tip' %}
```bash
$ jiraName='jira.sample.com'
$ jiraID='STORY-1'
```
{% endhint %}

> [!NOTE]
> - [Special headers](https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/#special-request-headers)
>   - `X-Atlassian-Token`
>   - `X-Force-Accept-Language`
>   - `X-AAccountId`

### myself

> [!NOTE|label:references:]
> - [Myself api v3](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-myself/#api-group-myself)
> - [Myself api v2](https://developer.atlassian.com/cloud/jira/platform/rest/v2/api-group-myself/#api-group-myself)
> - [Zapier & API Tokens](https://wiki.resolution.de/doc/api-token-authentication/latest/user-guide/knowledge-base?)
> - [Add user preference keys to documentation for mypreferences endpoint in JIRA API](https://jira.atlassian.com/browse/JRASERVER-60067)

```bash
$ curl -s https://jira.sample.com/rest/api/2/myself
# or via `user?username=<id>`
$ curl -s https://jira.sample.com/rest/api/2/user?username=marslo
```

- get info
  ```bash
  # get timezone
  $ curl -s https://jira.sample.com/rest/api/2/mypreferences?key=jira.user.timezone
  Asia/Shanghai

  # get locale
  $ curl --request GET \
         --url 'https://jira.sample.com/rest/api/2/mypreferences/locale' \
         --header 'Accept: application/json'
  ```

- set info
  ```bash
  # set timezone
  $ curl --request PUT \
         --url 'https://jira.sample.com/rest/api/2/mypreferences?key={key}' \
         --header 'Accept: application/json' \
         --header 'Content-Type: application/json' \
         --data '"<string>"'

  # set local
  $ curl --request PUT \
         --url 'https://jira.sample.com/rest/api/2/mypreferences/locale' \
         --user 'email@example.com:<api_token>' \
         --header 'Accept: application/json' \
         --header 'Content-Type: application/json' \
         --data '{ "locale": "en_US" }'
  ```

### check fields
```bash
$ curl -s \
       -k \
       -X GET https://${jiraName}/rest/api/2/issue/${jiraID} |
       jq --raw-output
```
### check attachment
- check attachment ID
  ```bash
  $ curl -s \
         -k \
         -X GET https://${jiraName}/rest/api/2/issue/${jiraID}?fields=attachment |
         jq --raw-output .fields.attachment[].id
  ```

- get attachments download url
  ```bash
  $ curl -s \
         -k \
         -X GET https://${jiraName}/rest/api/2/issue/${jiraID}?fields=attachment |
         jq --raw-output .fields.attachment[].content
  ```

  - download all attachments in Jira
    >    -I replace-str
    >           Replace occurrences of replace-str in the initial-arguments with names read from standard in-
    >           put.  Also, unquoted blanks do not terminate input items; instead the separator is  the  new-
    >           line character.  Implies -x and -L 1.

    ```bash
    $ curl -s \
           -k \
           -X GET https://${jiraName}/rest/api/2/issue/${jiraID}?fields=attachment |
           jq --raw-output .fields.attachment[].content |
           xargs -I '{}' curl -sgOJL '{}'
    ```

### list all projects
```bash
$ curl -fsSL -XGET https://jira.sample.com/rest/api/2/project |
  jq -r '.[] | [.key, .name] | join(" | ")' |
  column -s '|' -t
```

### search issue by JQL

> [!TIP]
> - [Search for issues using JQL (GET)](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/#api-rest-api-3-search-get)
> - [JQL: What is advanced search in Jira Cloud?](https://support.atlassian.com/jira-software-cloud/docs/what-is-advanced-search-in-jira-cloud/)
> - [How to get all issues by project key and issue type using REST api](https://community.developer.atlassian.com/t/how-to-get-all-issues-by-project-key-and-issue-type-using-rest-api/16074)
> - JQL pattern rule:
>   1. remove all space
>   2. `%3D` instead of `=`
>     - `project=abc` -> `project%3Dabc`
>   3. `%20CONDITION%20` instead of `CONDITION`
>     - `AND` -> `%20AND%20`
>     - `OR` -> `%20OR%20`
> - [* JQL operators](https://support.atlassian.com/jira-software-cloud/docs/jql-operators/)
> - [REST API - 'order by' param is ignored](https://community.atlassian.com/t5/Jira-Software-questions/REST-API-order-by-param-is-ignored/qaq-p/1696769#M483680)
> - [What is advanced search in Jira Cloud?](https://support.atlassian.com/jira-software-cloud/docs/what-is-advanced-search-in-jira-cloud/)

- format JQL

  > [!TIP]
  > - [* iMarslo: using jql to get URLEncodign](../cheatsheet/character/json.html#get-urlencode)

  ```bash
  $ jql='project = abc AND issuetype = release order by updated desc'
  $ jql=$(printf %s "${jql}" | jq -sRr @uri)
  ```

  <!--sec data-title="legacy version" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  $ jql="$(sed 's/ //g;s/AND/ AND /g;s/OR/ OR /g;s/IN/ IN /g;s/IS/ IS /g' <<< "${jql}")"
  $ jql="$(printf %s "${jql}" | jq -sRr @uri)"

  # i.e.:
  $ jql='project = abc AND issuetype = release'

  $ jql="$(sed 's/ //g;s/AND/ AND /g;s/OR/ OR /g;s/IN/ IN /g;s/IS/ IS /g' <<< "${jql}")"
  $ echo $jql
  project=abc AND issuetype=release

  $ jql="$(printf %s "${jql}" | jq -sRr @uri)"
  $ echo $jql
  project%3Dabc%20AND%20issuetype%3Drelease
  ```
  <!--endsec-->

- api

  > [!NOTE]
  > - [* iMarslo : bin/jira](https://github.com/marslo/dotfiles/blob/main/.marslo/bin/jira)
  > - [query parameters](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/#api-rest-api-3-search-get):
  >   - `maxResults`: `integer`
  >   - `startAt`: `integer`
  >   - `validateQuery`: `string`
  >   - `fields`: `array<string>`
  >   - `expand`: `string`
  >   - `properties`: `array<string>`
  >   - `fieldsByKeys`: `boolean`
  >   - sample: `search?jql=${jql}&maxResults=100&startAt=0`

  ```bash
  $ curl --silent \
         --insecure \
         --globoff \
         --netrc-file ~/.netrc \
         -XGET \
         "https://jira.sample.com/rest/api/2/search?jql=${jql}" |
    jq -r ${jqOpt}

  # i.e.:
  $ curlOpt='--silent --insecure --globoff --netrc-file ~/.netrc'
  $ url='https://jira.sample.com/rest/api/2'
  $ queryParams="startAt=0&maxResults=10"

  $ jql='project = ABC AND issuetype = Release ORDER BY updated ASC'          # copy from Jira website
  $ jql="$(printf %s "${jql}" | jq -sRr @uri)"

  $ curl "${curlOpt}" "${url}/search?jql=${jql}&${queryParams}" |
         jq -r '.issues[]' |
         jq -r '. | [.key, .fields.summary, .fields.status.name, .fields.issuetype.name, .fields.updated, .fields.created] | join("|")' |
         while IFS='|' read -r _key _summary _status _issuetype _updated _created; do
           echo "- [${_key}] - ${_summary}"
           echo "  -  status    : ${_status}"
           echo "  -  issuetype : ${_issuetype}"
           echo "  -  created   : ${_created}"
           echo "  -  updated   : ${_updated}"
         done
  ```

  <!--sec data-title="legacy version" data-id="section1" data-show=true data-collapse=true ces-->
  ```bash
  $ curl --silent \
         --insecure \
         --globoff \
         --netrc-file ~/.netrc \
         -XGET \
         "https://jira.sample.com/rest/api/2/search?jql=${jql}" |
    jq -r ${jqOpt}

  # i.e.:
  $ curlOpt='--silent --insecure --globoff --netrc-file ~/.netrc'
  $ url='https://jira.sample.com/rest/api/2'
  $ queryParams="startAt=0&maxResults=10"
  $ jql='project = abc AND issuetype = release'          # copy from Jira website

  $ jql="$(sed 's/ //g;s/AND/ AND /g;s/OR/ OR /g;s/IN/ IN /g;s/IS/ IS /g' <<< "${jql}")"
  $ jql="$(printf %s "${jql}" | jq -sRr @uri)"

  $ curl "${curlOpt}" "${url}/search?jql=${jql}&${queryParams}" |
         jq -r '.issues[]' |
         jq -r '. | [.key, .fields.summary, .fields.status.name, .fields.issuetype.name, .fields.updated, .fields.created] | join("|")' |
         while IFS='|' read -r _key _summary _status _issuetype _updated _created; do
           echo "- [${_key}] - ${_summary}"
           echo "  -  status    : ${_status}"
           echo "  -  issuetype : ${_issuetype}"
           echo "  -  created   : ${_created}"
           echo "  -  updated   : ${_updated}"
         done
  ```
  <!--endsec-->

### [get email address](Get Email Addresses For Users)

```bash
$ curl GET https://jira.sample.com/rest/api/2/user?key=JIRAUSER10100 |
  jq -r
```

### api token

> [!NOTE|label:references:]
> - [API Token Authentication Documentation](https://wiki.resolution.de/doc/api-token-authentication/latest)
> - [API Token Authentication Documentation - Rest API](https://wiki.resolution.de/doc/api-token-authentication/latest/admin-guide/rest-api)

- [list all tokens](https://wiki.resolution.de/doc/api-token-authentication/latest/admin-guide/rest-api#id-.RESTAPIv2.5.x-Listalltokens)

  > [!NOTE]
  > - to list all tokens for single user:
  >   ```bash
  >   $ curl -v -XGET \
  >          https://jira-or-confluence.sample.com/rest/de.resolution.apitokenauth/latest/user/token/ |
  >     jq -r
  >   ```
  > - to list tokens for all users:
  >   ```bash
  >   $ curl -v \
  >          -X GET \
  >          https://jira-or-confluence.sample.com/rest/de.resolution.apitokenauth/latest/user/tokensByFilter |
  >     jq -r
  >   ```

  ```bash
  $ curl -s -D- \
         -XGET \
         -H "Content-Type: application/json"  \
         https://jira.sample.com/rest/de.resolution.apitokenauth/latest/user/token |
    sed '/^\s*$/,$!d;//d' |
    jq -r
  ```

  - get id, created, last access, and valid timestamp
    ```bash
    function epoch2timestamp() {
      [[ 0 != $1 ]] && echo $(date -d @$(( $1/1000 )) +%FT%T.%3N%Z) || echo "0";
    }

    $ while read -r _id _created _lastAccess _validUntil; do
        echo "${_id} $(epoch2timestamp ${_created}) $(epoch2timestamp ${_lastAccess}) $(epoch2timestamp ${_validUntil})";
      done < <( curl -s -D- \
                     -XGET \
                     -H "Content-Type: application/json" \
                     https://jira.sample.com/rest/de.resolution.apitokenauth/latest/user/token |
                sed '/^\s*$/,$!d;//d' |
                jq -r '.content[] | [ .id, .created, .lastAccessed, .validUntil ] | join( "\t" )'
              ) |
      column -t
    537  2024-01-31T21:32:51.000PST  2024-03-26T23:30:30.000PDT  2024-07-31T21:32:51.000PDT
    579  2024-03-26T23:19:16.000PDT  0                           2024-09-26T23:19:16.000PDT

    # with header
    $ ( echo "ID CREATED LASTACCESS VALIDUNTIL";
        while read -r _id _created _lastAccess _validUntil; do
          echo "${_id} $(epoch2timestamp ${_created}) $(epoch2timestamp ${_lastAccess}) $(epoch2timestamp ${_validUntil})";
        done < <( curl -s -D- \
                       -XGET \
                       -H "Content-Type: application/json" \
                       https://jira.sample.com/rest/de.resolution.apitokenauth/latest/user/token |
                  sed '/^\s*$/,$!d;//d' |
                  jq -r '.content[] | [ .id, .created, .lastAccessed, .validUntil ] | join( "\t" )'
                )
      ) | column -t
    ID   CREATED                     LASTACCESS                  VALIDUNTIL
    537  2024-01-31T21:32:51.000PST  2024-03-26T23:33:33.000PDT  2024-07-31T21:32:51.000PDT
    579  2024-03-26T23:19:16.000PDT  0                           2024-09-26T23:19:16.000PDT
    ```

    - or
      ```bash
      $ curl -s -D- \
             -XGET \
             -H "Content-Type: application/json" \
             https://jira.sample.com/rest/de.resolution.apitokenauth/latest/user/token |
        sed '/^\s*$/,$!d;//d' |
        jq -r '.content[] | [ .created, .lastAccessed, .validUntil ] | join("\n")' |
        xargs -r -I{} bash -c "et=\"{}\"; date -d @\$(( \${et}/1000 )) +%c"
      Mon 18 Dec 2023 10:25:58 AM PST
      Tue 26 Mar 2024 10:21:30 PM PDT
      Tue 18 Jun 2024 10:25:58 AM PDT

      # or
      $ while read -r _d; do
          date -d @$(( ${_d}/1000 )) +%c;
        done < <( curl -s -D- \
                       -XGET \
                       -H "Content-Type: application/json" \
                       https://jira.sample.com/rest/de.resolution.apitokenauth/latest/user/token |
                  sed '/^\s*$/,$!d;//d' |
                  jq -r '.content[] | [ .created, .lastAccessed, .validUntil ] | join("\n")'
                )
      Mon 18 Dec 2023 10:25:58 AM PST
      Tue 26 Mar 2024 10:14:58 PM PDT
      Tue 18 Jun 2024 10:25:58 AM PDT
      ```

- [create token](https://wiki.resolution.de/doc/api-token-authentication/latest/admin-guide/rest-api#id-.RESTAPIv2.5.x-Createanewtoken)

  > [!TIP]
  > - expiration keywords
  >   - `tokenValidityTimeInMonths`
  >   - `tokenExpirationDateTime`
  >   - `tokenExpirationDateTimeMillis`

  ```bash
  $ curl -v -d '{"tokenDescription":"<token-description>"}' \
         -X POST \
         --header "Content-Type: application/json" \
         https://jira-or-confluence.sample.com/rest/de.resolution.apitokenauth/latest/user/token
  ```

  - create new token with expiration time

    > [!NOTE|label:references:]
    > - with `tokenValidityTimeInMonths`
    >   ```bash
    >   $ curl -v \
    >          -d '{"tokenDescription":"<token-description>", "tokenValidityTimeInMonths" : 1}' \
    >          -X POST \
    >          --header "Content-Type: application/json" \
    >          https://jira-or-confluence.sample.com/rest/de.resolution.apitokenauth/latest/user/token
    >   ```
    > - with `tokenExpirationDateTime`
    >   ```bash
    >   $ curl -v \
    >          -d '{"tokenDescription":"Custom expiration", "tokenExpirationDateTime" : "2020-10-19T10:29:00.000+02:00"}' \
    >          -X POST \
    >          --header "Content-Type: application/json" \
    >          https://jira-or-confluence.sample.com/rest/de.resolution.apitokenauth/latest/user/token
    >   ```

    ```bash
    $ curl -s \
           -d '{"tokenDescription":"marslo-token-api-test", "tokenValidityTimeInMonths" : 6}' \
           -X POST \
           --header "Content-Type: application/json" \
           https://jira.sample.com/rest/de.resolution.apitokenauth/latest/user/token |
     jq -r .plainTextToken
    NdxEToKfDsjUE7tct1ePP6erE1xdDsEAa64BOT
    ```

  - [create token for another users](https://wiki.resolution.de/doc/api-token-authentication/latest/admin-guide/rest-api#id-.RESTAPIv2.5.x-CreateTokensforotherUsers)
    ```bash
    $ curl -v \
           -d '{"tokenDescription":"token for another user", "tokenForUserKey":"JIRAUSER10105"}' \
           POST \
           --header "Content-Type: application/json" \
           https://jira-or-confluence.sample.com/rest/de.resolution.apitokenauth/latest/user/token

    # or with token validity time
    $ curl -v \
           -d '{"tokenDescription":"token for another user", "tokenForUserKey":"JIRAUSER10105","tokenValidityTimeInMonths":12}' \
           POST \
           --header "Content-Type: application/json" \
           https://jira-or-confluence.sample.com/rest/de.resolution.apitokenauth/latest/user/token
    ```

- [update token description](https://wiki.resolution.de/doc/api-token-authentication/latest/admin-guide/rest-api#id-.RESTAPIv2.5.x-Updateatokendescription)
  ```bash
  $ curl -v \
         -d '{"tokenDescription":"Updated token description"}' \
         -X PATCH \
         --header "Content-Type: application/json" \
         https://jira-or-confluence.sample.com/rest/de.resolution.apitokenauth/latest/user/token/<token-id>
  ```

- [delete token](https://wiki.resolution.de/doc/api-token-authentication/latest/admin-guide/rest-api#id-.RESTAPIv2.5.x-Deleteatoken)

  > [!NOTE|label:references:]
  > ```bash
  > $ curl -v \
  >        -X DELETE \
  >        https://jira-or-confluence.sample.com/rest/de.resolution.apitokenauth/latest/user/token/<token-id>
  > ```

  ```bash
  # list before token deleted
  $ ( echo "ID CREATED LASTACCESS VALIDUNTIL";
      while read -r _id _created _lastAccess _validUntil; do
        echo "${_id} $(epoch2timestamp ${_created}) $(epoch2timestamp ${_lastAccess}) $(epoch2timestamp ${_validUntil})";
      done < <( curl -s -D- \
                     -XGET \
                     -H "Content-Type: application/json" \
                     https://jira.sample.com/rest/de.resolution.apitokenauth/latest/user/token |
                sed '/^\s*$/,$!d;//d' |
                jq -r '.content[] | [ .id, .created, .lastAccessed, .validUntil ] | join( "\t" )'
              )
    ) | column -t
  ID   CREATED                     LASTACCESS                  VALIDUNTIL
  537  2024-01-31T21:32:51.000PST  2024-03-26T23:40:02.000PDT  2024-07-31T21:32:51.000PDT
  579  2024-03-26T23:19:16.000PDT  0                           2024-09-26T23:19:16.000PDT
  580  2024-03-26T23:36:02.000PDT  0                           2024-09-26T23:36:02.000PDT
  581  2024-03-26T23:36:11.000PDT  0                           2024-09-26T23:36:11.000PDT

  # delete
  $ curl -s -D- \
         -X DELETE \
         https://jira.sample.com/rest/de.resolution.apitokenauth/latest/user/token/581
  HTTP/2 200
  date: Wed, 27 Mar 2024 06:41:06 GMT
  content-type: application/json;charset=UTF-8
  x-arequestid: 1421x248002x2
  x-anodeid: jiraprod5
  referrer-policy: strict-origin-when-cross-origin
  x-xss-protection: 1; mode=block
  x-content-type-options: nosniff
  x-frame-options: SAMEORIGIN
  content-security-policy: sandbox
  strict-transport-security: max-age=31536000
  set-cookie: JSESSIONID=731380C1F17B2F9A59E211B0442AAFFB; Path=/; Secure; HttpOnly
  x-seraph-loginreason: OK
  set-cookie: atlassian.xsrf.token=A8KN-1NAU-M55V-EQSR_1811ae8601112c05430589e686032924599718c9_lin; Path=/; Secure; SameSite=None
  x-asessionid: k5q153
  x-ausername: marslo
  cache-control: no-cache, no-store, no-transform

  true

  # curl without header
  $ curl -s \
         -X DELETE \
         https://jira.sample.com/rest/de.resolution.apitokenauth/latest/user/token/580
  true

  # verify
  $ ( echo "ID CREATED LASTACCESS VALIDUNTIL";
      while read -r _id _created _lastAccess _validUntil; do
        echo "${_id} $(epoch2timestamp ${_created}) $(epoch2timestamp ${_lastAccess}) $(epoch2timestamp ${_validUntil})";
      done < <( curl -s -D- \
                     -XGET \
                     -H "Content-Type: application/json" \
                     https://jira.sample.com/rest/de.resolution.apitokenauth/latest/user/token |
                sed '/^\s*$/,$!d;//d' |
                jq -r '.content[] | [ .id, .created, .lastAccessed, .validUntil ] | join( "\t" )'
              )
    ) | column -t
  ID   CREATED                     LASTACCESS                  VALIDUNTIL
  537  2024-01-31T21:32:51.000PST  2024-03-26T23:44:32.000PDT  2024-07-31T21:32:51.000PDT
  579  2024-03-26T23:19:16.000PDT  0                           2024-09-26T23:19:16.000PDT
  ```

  - [delete all tokens for a user](https://wiki.resolution.de/doc/api-token-authentication/latest/admin-guide/rest-api#id-.RESTAPIv2.5.x-Deletealltokensforauser)
    ```bash
    $ curl GET \
           https://jira.sample.com/rest/api/2/user?username=some.username |
       jq -r
    ```

- [filter](https://wiki.resolution.de/doc/api-token-authentication/latest/admin-guide/rest-api#id-.RESTAPIv2.5.x-Filterparameters)

| PARAMETER            | VALUE                | COMMENT                                                                                                                                                                           |
|----------------------|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `userFilter`         | valid user key       | read above how to get a user key for a name or by email address;<br> if you want to filter for more than one user, repeat that parameter for as many users you want to filter for |
| `descriptionFilter`  | search term          | string to search for in all token descriptions                                                                                                                                    |
| `notValidAfter`      | epoch Unix timestamp | tokens not valid anymore after that date/ time in milliseconds                                                                                                                    |
| `tokenScope`         | integer              | 0 = no scope (all pre 1.5.0 tokens), 1 = read-only, 2 = read/ write                                                                                                               |
| `fromCreated`        | epoch Unix timestamp | -                                                                                                                                                                                 |
| `untilCreated`       | epoch Unix timestamp | -                                                                                                                                                                                 |
| `fromLastUsed`       | epoch Unix timestamp | -                                                                                                                                                                                 |
| `untilLastUsed`      | epoch Unix timestamp | -                                                                                                                                                                                 |
| `fromExpiresDuring`  | epoch Unix timestamp | -                                                                                                                                                                                 |
| `untilExpiresDuring` | epoch Unix timestamp | -                                                                                                                                                                                 |

  - [list token expired after certain time](https://wiki.resolution.de/doc/api-token-authentication/latest/admin-guide/rest-api#id-.RESTAPIv2.5.x-Retrievealltokensnotvalidafteracertaintime)
    ```bash
    $ curl "https://jira-or-confluence.sample.com/rest/de.resolution.apitokenauth/latest/user/tokensByFilter?notValidAfter=1688918956972" |
      jq -r

    # with limit and page
    $ curl "https://jira-or-confluence.sample.com/rest/de.resolution.apitokenauth/latest/user/tokensByFilter?page=0&limit=1&notValidAfter=1688918956972" |
      jq -r
    ```

### [generate OAuth consumer](https://developer.atlassian.com/cloud/jira/platform/jira-rest-api-oauth-authentication/)

> [!NOTE|label:references:]
> - [OAuth 1.0a for REST APIs (Deprecated)](https://developer.atlassian.com/cloud/jira/platform/jira-rest-api-oauth-authentication/)
> - [atlassian-oauth-examples](https://bitbucket.org/atlassianlabs/atlassian-oauth-examples/src/master/)


```bash
$ openssl genrsa -out jira_privatekey.pem 1024
$ openssl req -newkey rsa:1024 -x509 -key jira_privatekey.pem -out jira_publickey.cer -days 365
$ openssl pkcs8 -topk8 -nocrypt -in jira_privatekey.pem -out jira_privatekey.pcks8
$ openssl x509 -pubkey -noout -in jira_publickey.cer  > jira_publickey.pem
```

### icons and priority
#### priority

> [!NOTE|label:references:]
> - [how do I view ALL icons for priority](https://community.atlassian.com/t5/Jira-questions/how-do-I-view-ALL-icons-for-priority/qaq-p/802188)
> - [AlexanderBartash/JIRA-Priority-Icons](https://github.com/AlexanderBartash/JIRA-Priority-Icons)
> - [DevOps Use case: Jira Jenkins Integration](https://medium.com/@shrut_terminator/devops-usecase-jira-jenkins-integration-4051413446a9)

```bash
$ for _i in "blocker.png" "blocker.svg" "critical.png" "critical.svg" "high.png" "high.svg" "highest.png" "highest.svg" "low.png" "low.svg" "lowest.png" "lowest.svg" "major.png" "major.svg" "medium.png" "medium.svg" "minor.png" "minor.svg" "trivial.png" "trivial.svg"; do
    echo "--> ${_i}"
    curl -O https://jira-trigger-plugin.atlassian.net/images/icons/priorities/${_i}
  done
```

## confluence
```bash
$ confluenceName='confluence.domain.com'
$ pageID='143765713'
```
> get page id:
> ![confluence page id](../screenshot/confluence-pageid.png)

### [myself](https://wiki.resolution.de/doc/api-token-authentication/latest/user-guide/using-tokens-examples#id-.UsingTokensExamplesv1.7.0-Confluence)
```bash
$ curl -s https://${confluenceName}/rest/api/user/current | jq -r
```

### get info
```bash
$ curl -s -X GET https://${confluenceName}/rest/api/content/${pageID} | jq --raw-output
```

- get space
  ```bash
  $ curl -s -X GET https://${confluenceName}/rest/api/content/${pageID} | jq .space.key
  ```

- get title
  ```bash
  $ curl -s -X GET https://${confluenceName}/rest/api/content/${pageID} | jq .title
  ```

- get page history
  ```bash
  $ curl -s -X GET https://${confluenceName}/rest/api/content/${pageID} | jq .version.number
  ```

  - get next version
    ```bash
    currentVer=$(curl -s -X GET https://${confluenceName}/rest/api/content/${pageID} | jq .version.number)
    newVer=$((currentVer+1))
    ```

### publish to confluence

> [!NOTE|label:references:]
> - [sample script](https://raw.githubusercontent.com/marslo/mytools/master/itool/confluencePublisher.sh)

```bash
$ url="https://${confluenceName}/rest/api/content/${pageID}"
$ page=$(curl -s ${url})
$ space=$(echo "${page}" | jq .space.key)
$ title=$(echo "${page}" | jq .title)
$ currentVer=$(echo "${page}" | jq .version.number)
$ newVer=$((currentVer+1))

$ cat > a.json << EOF
{
  "id": "${pageID}",
  "type": "page",
  "title": ${title},
  "space": {"key": ${space}},
  "body": {
    "storage": {
      "value": "<h1>Hi confluence</h1>",
      "representation": "storage"
    }
  },
  "version": {"number":${newVer}}
}
EOF

$ curl -s \
       -i \
       -X PUT \
       -H 'Content-Type: application/json' \
       --data "$(cat a.json)" \
       https://${confluenceName}/rest/api/content/${pageID}
```
- result
  ![publish via api](../screenshot/publish-to-confluence.png)


### plugins
#### [Multiexcerpt](https://marketplace.atlassian.com/apps/169/multiexcerpt?tab=overview&hosting=cloud)

- create excerpt
  ![create multiexcerpt](../screenshot/tools/jira/jira-plugin-Multiexcerpt-create.png)

- include excerpt
  ![include excerpt](../screenshot/tools/jira/jira-plugin-Multiexcerpt-include-setting.png)

- result
  ![include excerpt](../screenshot/tools/jira/jira-plugin-Multiexcerpt-include-result.png)

## ACLI

> [!NOTE|label:references:]
> - [acli: Appfire CLI](https://appfire.atlassian.net/wiki/spaces/ACLI/pages/60559862/Get+Started)
>   - [acli download](https://appfire.atlassian.net/wiki/spaces/ACLI/pages/60560924/CLI+Client+Installation+and+Use)
>     - [windows amd64: ACLI-11.3.0-amd64-installer.exe](https://appfire.atlassian.net/wiki/download/attachments/60562669/ACLI-11.3.0-amd64-installer.exe?api=v2)
>     - [linux amd64: ACLI-11.3.0-amd64-installer.run](https://appfire.atlassian.net/wiki/download/attachments/60562669/ACLI-11.3.0-amd64-installer.run?api=v2)
>     - [macos amd64: ACLI-11.3.0-amd64-installer.dmg](https://appfire.atlassian.net/wiki/download/attachments/60562669/ACLI-11.3.0-amd64-installer.dmg?api=v2)
>     - [macos arm64: ACLI-11.3.0-arm64-installer.dmg](https://appfire.atlassian.net/wiki/download/attachments/60562669/ACLI-11.3.0-arm64-installer.dmg?api=v2)\
>     - [docker image](https://appfire.atlassian.net/wiki/spaces/ACLI/pages/60559294/Docker+Images+for+ACLI)
>   - [Action Examples](https://appfire.atlassian.net/wiki/spaces/ACLI/pages/60562181/Action+Examples)
>     - [Action Examples - acli help using](https://appfire.atlassian.net/wiki/spaces/ACLI/pages/60563920/Action+Examples+-+acli+help+using)

### running with docker images
```bash
$ $ docker run -ti bobswiftapps/acli:latest acli -a getClientInfo
# or
$ docker run -ti bobswiftapps/acli:latest /bin/bash
bash-4.4# acli -a getClientInfo

# with env
$ cat .env
examplegear=jira -s https://examplegear.atlassian.net -u anonymous
examplegear_confluence=confluence -s https://examplegear.atlassian.net/wiki -u anonymous
$ docker run --env-file=.env -ti bobswiftapps/acli:latest /bin/bash
bash-5.0# acli $examplegear -a getServerInfo
# or
docker run -e examplegear='jira -s https://examplegear.atlassian.net -u anonymous' -ti bobswiftapps/acli:latest /bin/bash
bash-4.4# acli ${examplegear} -a getServerInfo

# with acli.properties
$ docker run -v ${PWD}/acli.properties:/opt/acli/acli.properties \
         -ti bobswiftapps/acli:latest
# or prior to version 11.0.0, use:
$ docker run -v ${PWD}/acli.properties:/opt/atlassian-cli/acli.properties \
         -ti bobswiftapps/acli:latest
# or with `ACLI_CONFIG` env
$ docker run -v ${PWD}/acli.properties:/tmp/acli.properties \
         -e ACLI_CONFIG=/tmp/acli.properties \
         -ti bobswiftapps/acli:latest \
         acli -a getServerInfo --outputFormat 2
```

### [create .acli.keystore](https://appfire.atlassian.net/wiki/spaces/SUPPORT/pages/349962465/How+to+use+Secure+Properties)
```bash
$ acli system setSecureProperty --name my.secret --secret -
Enter secure value: <secret value prompt>
Secure properties file does not yet exist. Creating...
Enter new secure properties password: <new password prompt>
Confirm secure properties password: <new password prompt>
Secure properties file created.
Value for key 'foo' set in secure properties file.
```

### [acli.properties](https://appfire.atlassian.net/wiki/spaces/SUPPORT/pages/349962465/How+to+use+Secure+Properties#Referencing-secrets-in-acli.properties)
