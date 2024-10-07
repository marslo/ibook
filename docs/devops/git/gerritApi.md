<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [basic usage](#basic-usage)
  - [regular options](#regular-options)
  - [sending data](#sending-data)
  - [verifying header content](#verifying-header-content)
- [change](#change)
- [who approval the CR+2](#who-approval-the-cr2)
- [get all vote CR-2](#get-all-vote-cr-2)
- [who approval the V+1](#who-approval-the-v1)
- [access list contains account](#access-list-contains-account)
- [all reviews at a certain time](#all-reviews-at-a-certain-time)
- [get review rate in certain time](#get-review-rate-in-certain-time)
- [list all projects](#list-all-projects)
- [list gerrit projects with certain account](#list-gerrit-projects-with-certain-account)
- [list project configure](#list-project-configure)
- [reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint 'info' %}
> reference:
> - [Gerrit Code Review - REST API Developers' Notes](https://gerrit-review.googlesource.com/Documentation/dev-rest-api.html)
> - [Gerrit Code Review - REST API](https://gerrit-review.googlesource.com/Documentation/rest-api.html)
> - [go gerrit - index](https://pkg.go.dev/github.com/andygrunwald/go-gerrit#pkg-index)
> - [Class com.google.gerrit.extensions.api.access.ProjectAccessInfo](https://javadoc.io/static/com.google.gerrit/gerrit-plugin-api/2.14.2/com/google/gerrit/extensions/api/access/ProjectAccessInfo.html)
{% endhint %}

## [basic usage](https://gerrit-review.googlesource.com/Documentation/dev-rest-api.html#_basic_testing)
### regular options
```bash
                                  a might means [a]pi
                                    ⇡
$ curl -X PUT    http://domain.name/a/path/to/api/
$ curl -X POST   http://domain.name/a/path/to/api/
$ curl -X DELETE http://domain.name/a/path/to/api/
```

### sending data
- json with file
  ```bash
  $ curl -X PUT \
         -d@testdata.json \
         --header "Content-Type: application/json" \
         http://domain.name/a/path/to/api/
  ```

- json with string
  ```bash
  $ curl -X POST \
         -H "Content-Type: application/json" https://domain.name/a/changes/<number>/move \
         -d '{ "destination_branch" : "target/branch/name" }'
  )]}'
  {
    "id": "marslo-project~target%2Fbranch%2Fname~Id90057ab632eb93be2fa9128a9d624664008cb4a",
    "project": "marslo-project",
    "branch": "target/branch/name",
    "hashtags": [],
    "change_id": "Id90057ab632eb93be2fa9128a9d624664008cb4a",
    "subject": "marslo: testing api move",
    "status": "NEW",
    "created": "2022-01-21 05:21:25.000000000",
    "updated": "2022-05-17 06:56:37.000000000",
    "submit_type": "FAST_FORWARD_ONLY",
    "mergeable": false,
    "insertions": 8,
    "deletions": 8,
    "unresolved_comment_count": 0,
    "has_review_started": true,
    "_number": 94490,
    "owner": {
      "_account_id": 790
    },
    "requirements": []
  }

  # or
  $ curl -X POST \
         -H "Content-Type: application/json" https://domain.name/a/changes/<number>/move \
         -d '{
              "destination_branch" : "target/branch/name"
             }' |
    tail -n +2 |
    jq -r .branch
  ```

- txt
  ```bash
  $ curl -X PUT \
         --data-binary @testdata.txt \
         --header "Content-Type: text/plain" \
         http://domain.name/a/path/to/api/
  ```

### verifying header content
  ```bash
  $ curl -v -n -X DELETE http://domain.name/a/path/to/api/
  ```

## [change](https://gerrit-review.googlesource.com/Documentation/rest-api-changes.html)
- get change via change-id
  ```bash
  $ curl -X GET 'https://domina.name/a/changes/<change-id>'
  ```

- get change via commit-id
  ```groovy
  $ changeid=$(git show <commit-id> --no-patch --format="%s%n%n%b" | sed -nre 's!Change-Id: (.*$)!\1!p')
  $ curl -X GET "https://domina.name/a/changes/${changeid}"

  # or
  $ project=$(echo 'path/to/project' | sed 's:/:%2F:g')
  $ branch='dev'
  $ changeid=$(git show <commit-id> --no-patch --format="%s%n%n%b" | sed -nre 's!Change-Id: (.*$)!\1!p')
  $ curl -X GET "https://domina.name/a/changes/${project}~${branch}~${changeid}"
  ```

## who approval the CR+2
```bash
$ curl -s -X GET https://domain.name/a/changes/${changeid}/detail |
       tail -n +2 |
       jq -r '.labels."Code-Review".approved.name'
```

## get all vote CR-2
{% hint style='tip' %}
> - example output for `.labels.<tag>.all[]`
>
>   ```json
>   {
>     "value": -2,
>     "date": "2021-05-31 07:57:14.000000000",
>     "permitted_voting_range": {
>       "min": -2,
>       "max": 2
>     },
>     "_account_id": 790,
>     "name": "Marslo Jiao",
>     "email": "marslo.jiao@gmail.com",
>     "username": "marslo"
>   }
>   {
>     "value": 0,
>     "permitted_voting_range": {
>       "min": -2,
>       "max": 2
>     },
>     "_account_id": 124,
>     "name": "John Doe",
>     "email": "john@gmail.com",
>     "username": "john"
>   }
>   ```
{% endhint %}

> reference:
> - [Select objects based on value of variable in object using jq](https://stackoverflow.com/a/64212172/2940319)
> - [jq select or statement](https://stackoverflow.com/a/53451410/2940319)
> - [How to select items in JQ based on value in array](https://stackoverflow.com/a/44867184/2940319)

```bash
$ curl -s -X GET https://domain.name/a/changes/${changeid}/detail |
       tail -n +2 |
       jq -r '.labels."Code-Review".all[] | select ( .value == -2 ) | .username'
#                                         : |⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂| :
#                                         :           ⇣             :
#                                         :  select ".value"== -2   :
#                                         :                         :
#                                         ⇣                         ⇣
#                                        pipe                     pipe

# or
$ curl -s -X GET https://domain.name/a/changes/${changeid}/detail |
       tail -n +2 |
      jq -r '( .labels."Code-Review".all[] | select ( .value == -2 ) ).username'
#            :                                                       :
#            ⇣                                                       ⇣
#        expression                                              expression

# or
$ curl -s -X GET https://domain.name/a/changes/${changeid}/detail |
       tail -n +2 |
      jq -r '[ .labels."Code-Review".all[] | select ( .value == -2 ) ][].username'
#            :                                                       :
#            ⇣                                                       ⇣
#        expression                                              expression

# or
$ curl -s -X GET https://domain.name/a/changes/${changeid}/detail |
       tail -n +2 |
       jq -r '.labels."Code-Review".all[] | select ( .value == -2 )' |
       jq -r .username                                            #  :
                                                                  #  ⇣
                                                                  # pipe
```

## who approval the V+1
```bash
$ curl -s -X GET https://domain.name/a/changes/${changeid}/detail |
       tail -n +2 |
       jq -r .labels.Verified.approved.username
```

## access list contains account

> [!NOTE]
> - [list projects](https://gerrit-review.googlesource.com/Documentation/rest-api-projects.html#list-projects)
> - [List Access Rights for Project](https://gerrit-review.googlesource.com/Documentation/rest-api-projects.html#get-access)

```bash
# i.e. : check all repos who contains account marslo@sample.com
$ while read -r _proj; do
    output=$( curl -fsSL https://gerrit.sample.com/a/projects/"${_proj}"/access |
              tail -n+2 |
              jq -r '.. | .rules? | select(. != null) | keys[] | ascii_downcase | select(contains("marslo@sample.com"))';
            )
    [[ -z "${output}" ]] || echo ">> https://gerrit.sample.com/admin/repos/$(sed 's:%2F:/:g' <<< "${_proj}")"
  done < <( curl -fsSL https://gerrit.sample.com/a/projects/?d |
                  tail -n+2 |
                  jq -r '.[].id' |
                  grep --color=never -E 'keyword-1|keyword-2'
          )
```

## all reviews at a certain time

> [!NOTE|label:references:]
> - [How to change the limit numbers of gerrit query](https://stackoverflow.com/a/66810126/2940319)
> - [Gerrit Code Review - Searching Changes](https://gerrit-review.googlesource.com/Documentation/user-search.html#_search_operators)

```bash
project='PROJECT'
branch='BRANCH'
start='2023-01-01'
end='2024-01-01'
curlOpt='--silent --insecure --globoff --netrc-file ~/.netrc'
query="project:${project}+branch:${branch}+after:${start}+before:${end}"
filter by status if necessary
query="${query}+is:closed+-is:abandoned"

echo ">> ${project} ~ ${branch}"
while IFS='|' read -r _change_id _id; do
  echo -e "\t- [${_id}] [_change_id]"
done < <( eval "curl ${curlOpt} 'https://gerrit.sample.com/a/changes/?q=${query}'" |
         tail -n +2 |
         jq -r '.[] | .change_id + "|" + .id'
 )
```

## get review rate in certain time
```bash
gerritUrl='https://gerrit.sample.com'
sum=0
rnum=0
onum=0
echo ">> ${project} ~ ${branch}"
while IFS='|' read -r _change_id _id; do
  sum=$(( sum+1 ))
  output=$( eval "curl ${curlOpt} '${gerritUrl}/a/changes/${_id}/detail' | tail -n+2" )
  reviewed=$( jq -r '.labels."Code-Review".all[] | select(.value != null) | select( .value | contains(2) ) | .username' <<< "${output}" )
  owned=$( jq -r '.owner.username' <<< "${output}" )
  if grep 'marslo' <<< "${reviewed}" >/dev/null; then rnum=$(( rnum+1 )); fi
  if grep 'marslo' <<< "${owned}"    >/dev/null; then onum=$(( onum+1 )); fi
done < <( eval "curl ${curlOpt} '${gerritUrl}/a/changes/?q=${query}'" |
                tail -n +2 |
                jq -r '.[] | .change_id + "|" + .id'
        )
echo "${sum} ${rnum} ${onum} $(( sum-onum ))" |
      awk '{ sum=$1; reviewed=$2; owned=$3; rsum=$4; rate=$2*100/$4 } END { printf("\t- gerrit review: %s/(%s-%s) ( %s% )\n", reviewed, sum, owned, rate) }'
```

## list all projects
```bash
$ curl -fsSL "${gerritUrl}"/a/projects/?d | tail -n+2 | jq -r '.[].id'
```

## list gerrit projects with certain account
```bash
$ account='marslo'
$ id=1
$ gerritUrl='https://gerrit.sample.com'

$ while read -r _proj; do
    output=$( curl -fsSL "${gerritUrl}"/a/projects/"${_proj}"/access |
              tail -n+2 |
              jq -r --arg ACCOUNT "${account}" '.. | ."rules"? | select(. != null) | keys[] | ascii_downcase | select(contains($ACCOUNT))';
            )
    [[ -n "${output}" ]] && echo "[${id}] >> "${gerritUrl}"/admin/repos/$(sed 's:%2F:/:g' <<< "${_proj}")" && ((id++));
  done < <( curl -fsSL "${gerritUrl}"/a/projects/?d | tail -n+2 | jq -r '.[].id' )
```

## list project configure
```bash
$ project='path/to/project'
$ curl -g -fsSL "https://${gerritUrl}/a/projects/$(printf %s "${project}" | jq -sRr @uri)/config" | tail -n+2 | jq -r
```

## reference

> [!NOTE|lbael:references:]
> - [project owner guide](https://www.gerritcodereview.com/intro-project-owner.html)
> - [Gerrit Code Review - Access Controls](https://gerrit-review.googlesource.com/Documentation/access-control.html#_project_access_control_lists)
> - [Gerrit Code Review - Uploading Changes](https://www.gerritcodereview.com/user-upload.html)
> - [The refs/for namespace](https://gerrit-review.googlesource.com/Documentation/concept-refs-for-namespace.html)
> - [gerrit/gerrit/refs/meta/config](https://gerrit.googlesource.com/gerrit/+/refs/meta/config)
> - [gerrit 权限控制](https://blog.csdn.net/chenjh213/article/details/50571190)
> - [its-jira plugin md](https://gerrit.googlesource.com/plugins/its-jira/+/refs/heads/stable-3.0/src/main/resources/Documentation/config.md)
> - [Rule base configuration](https://review.opendev.org/plugins/its-storyboard/Documentation/config-rulebase-common.html)
> - [Gerrit push not working. Remote rejected, prohibited by gerrit](https://stackoverflow.com/a/31297860/2940319)
> - [Gerrit Code Review - Project Configuration File Format](https://gerrit-review.googlesource.com/Documentation/config-project-config.html)
> - [Review UI](https://gerrit-review.googlesource.com/Documentation/user-review-ui.html)
