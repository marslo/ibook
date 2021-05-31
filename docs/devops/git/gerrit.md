<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [.gitconfig](#gitconfig)
- [refs/meta/config](#refsmetaconfig)
  - [get project.config](#get-projectconfig)
  - [publish to remote](#publish-to-remote)
  - [update meta/config if remotes update](#update-metaconfig-if-remotes-update)
  - [reset to remotes](#reset-to-remotes)
  - [useful refs](#useful-refs)
  - [restriction for branches (`feature1`, `feature2` and `master`) for only allow code review merge, forbidden code push](#restriction-for-branches-feature1-feature2-and-master-for-only-allow-code-review-merge-forbidden-code-push)
  - [rules.pl](#rulespl)
- [api](#api)
  - [basic usage](#basic-usage)
  - [change](#change)
  - [who approval the CR+2](#who-approval-the-cr2)
  - [get all vote CR-2](#get-all-vote-cr-2)
  - [who approval the V+1](#who-approval-the-v1)
  - [reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## .gitconfig
```bash
$ git config --global gitreview.username <UserName>
$ git config --global gitreview.remote origin
```

## [refs/meta/config](https://gerrit-review.googlesource.com/Documentation/config-project-config.html#_the_refs_meta_config_namespace)
### get project.config
- clone the repo
  ```bash
  $ git clone <repo url>
  # or update the local repo to HEAD
  $ git pull [--rebase]
  ```

- checkout `meta/config`
  ```bash
  $ git fetch origin refs/meta/config:refs/remotes/origin/meta/config
  $ git checkout meta/config
  ```
  or

  ```bash
  $ git fetch ssh://localhost:29418/project refs/meta/config
  $ git checkout FETCH_HEAD
  ```

### publish to remote
```bash
$ git add --all .
$ git commit -m "<add your comments here>"
```
- submit directly
  ```bash
  $ git push origin meta/config:meta/config
  ```
  or
  ```bash
  $ git push origin HEAD:refs/meta/config
  ```

- submit review
  ```bash
  $ git push origin HEAD:refs/for/refs/meta/config
  ```
  or
  ```bash
  $ git push origin meta/config:refs/for/refs/meta/config
  ```

### update meta/config if remotes update
```bash
$ git fetch origin --force refs/meta/config:refs/remotes/origin/meta/config

$ git pull origin refs/meta/config
# or
$ git merge meta/config
```

### reset to remotes
```bash
$ git fetch origin --force refs/meta/config:refs/remotes/origin/meta/config
$ git reset --hard remotes/origin/meta/config
```

### useful refs

#### sandbox:
```bash
refs/heads/sandbox/${username}/*
```

#### its-jira:
- for project specific
  ```bash
  [commentlink "its-jira"]
    match = ^[ \\t]*PROJECT-([0-9]{1,5}):
    link = https://<jira-domain>:<jira-port>/browse/PROJECT-$1
  ```

- for common setup
  ```bash
  [plugin "its-jira"]
    association = OPTIONAL
    branch = ^refs/heads/.*
    branch = ^refs/heads/stable-.*
    commentOnChangeAbandoned = false
    commentOnChangeCreated = true
    commentOnChangeMerged = true
    commentOnChangeRestored = false
    commentOnCommentAdded = false
    commentOnFirstLinkedPatchSetCreated = true
    commentOnPatchSetCreated = false
    commentOnRefUpdatedGitWeb = true
    enabled = enforced
  [commentlink "its-jira"]
    match = ^[ \\t]*([A-Za-z]*-[0-9]{1,5}):
    link = https://<jira-domain>:<jira-port>/browse/$1
  [commentlink "changeid"]
    match = (I[0-9a-f]{8,40})
    link = "#/q/$1"
  ```

#### verified label
```bash
[label "Verified"]
    function = MaxWithBlock
    defaultValue = 0
    copyAllScoresIfNoCodeChange = true
    value = -1 Fails
    value =  0 No score
    value = +1 Verified
```

#### change-id
```bash
[receive]
  requireChangeId = true
  createNewChangeForAllNotInTarget = false
  maxObjectSizeLimit = 6m
  maxBatchChanges = 1
[commentlink "changeid"]
  match = (I[0-9a-f]{8,40})
  link = "#/q/$1"
```

#### freeze `master` branch
- `project.config`
  ```bash
  [access "refs/for/refs/heads/master"]
    push = block group user/Marslo Jiao (marslo)
    push = block group Registered Users
    submit = block group Registered Users
    submit = block group group user/Marslo Jiao (marslo)
    addPatchSet = block group user/Marslo Jiao (marslo)
    addPatchSet = block group Registered Users
    pushMerge = block group user/Marslo Jiao (marslo)
    pushMerge = block group Registered Users
  ```

- `groups`
  ```bash
  ...
  global:Project-Owners      Project Owners
  global:Registered-Users    Registered Users
  ...
  user:marslo                user/Marslo Jiao(marslo)
  ...
  ```

#### freeze multiple branches (`stable` & `release`) for the specific account
- `project.config`
  ```bash
  [access "^refs/for/refs/heads/(stable|release)$"]
    push = block group Registered Users
    submit = block group Registered Users
    addPatchSet = block group Registered Users
    pushMerge = block group Registered Users
  [access "^refs/heads/(stable|release)$"]
    read = group user/Marslo Jiao (marslo)
    push = +force group user/Marslo Jiao (marslo)
    pushMerge = group user/Marslo Jiao (marslo)
  ```

- `groups`
  ```bash
  ...
  global:Project-Owners      Project Owners
  global:Registered-Users    Registered Users
  ...
  user:marslo                user/Marslo Jiao(marslo)
  ...
  ```

### restriction for branches (`feature1`, `feature2` and `master`) for only allow code review merge, forbidden code push
- `project.config`
  ```bash
  [access "refs/*"]
    read = group Project Owners
    read = group user/Marslo Jiao (marslo)
  [access "refs/for/*"]
    addPatchSet = group Project Owners
    addPatchSet = group user/Marslo Jiao (marslo)
    push = group Project Owners
    push = group user/Marslo Jiao (marslo)
    pushMerge = group Project Owners
    pushMerge = group user/Marslo Jiao (marslo)
  [access "^refs/heads/(feature1|feature2|master)$"]
    push = block group Registered Users
    pushMerge = block group Registered Users
    submit = group Change Owner
  ```

- `groups`
  ```bash
  ...
  global:Project-Owners      Project Owners
  global:Registered-Users    Registered Users
  ...
  user:marslo                user/Marslo Jiao(marslo)
  ...
  ```

#### example of `project.config`
- [project.config](https://gerrit.googlesource.com/gerrit/+/refs/meta/config/project.config)
  ```bash
  [project]
    description = Gerrit Code Review
  [access "refs/*"]
    owner = group google/gerritcodereview-maintainers@googlegroups.com
  [access "refs/heads/*"]
    label-Code-Review = -2..+2 group google/gerritcodereview-maintainers@googlegroups.com
    label-Code-Review = -2..+2 group polygerrit-maintainers
    label-Verified = -1..+1 group Change Owner
    label-Verified = -1..+1 group gerrit-verifiers
    label-Code-Style = -1..+1 group gerrit-verifiers
    label-Verified-Notedb = -1..+1 group gerrit-verifiers
    label-Library-Compliance = -1..+1 group gerrit-lib
    label-Library-Compliance = -1..+0 group google/gerritcodereview-maintainers@googlegroups.com
    submit = group Change Owner
    submit = group google/gerritcodereview-maintainers@googlegroups.com
    create = group google/gerritcodereview-maintainers@googlegroups.com
    abandon = group gerrit-verifiers
    editTopicName = +force group google/gerritcodereview-maintainers@googlegroups.com
    removeReviewer = group google/gerritcodereview-maintainers@googlegroups.com
    publishDrafts = group google/gerritcodereview-maintainers@googlegroups.com
  [access "refs/tags/*"]
    create = group gerrit-release-creators
    create = group google/gerritcodereview-maintainers@googlegroups.com
    createTag = group gerrit-release-creators
    createTag = group google/gerritcodereview-maintainers@googlegroups.com
    createSignedTag = group gerrit-release-creators
    createSignedTag = group google/gerritcodereview-maintainers@googlegroups.com
  [access]
    inheritFrom = Public-Projects
  [receive]
    rejectImplicitMerges = true
  [reviewer]
    enableByEmail = true
  [label "Verified"]
    function = MaxNoBlock
    copyAllScoresIfNoCodeChange = true
    value = -1 Fails
    value = 0 No score
    value = +1 Verified
    defaultValue = 0
  [label "Code-Style"]
    function = MaxWithBlock
    copyAllScoresIfNoCodeChange = true
    value = -1 Wrong Style or Formatting
    value = 0 No score
    value = +1 Style Verified
    defaultValue = 0
  [label "Library-Compliance"]
    function = MaxWithBlock
    copyAllScoresIfNoCodeChange = true
    copyAllScoresOnTrivialRebase = true
    value = -1 Do not submit
    value = 0 No score
    value = +1 Approved
    defaultValue = 0
  [access "refs/for/refs/meta/dashboards/*"]
    push = group google/gerritcodereview-maintainers@googlegroups.com
  [access "refs/meta/dashboards/*"]
    label-Code-Review = -2..+2 group google/gerritcodereview-maintainers@googlegroups.com
    label-Code-Review = -1..+1 group Registered Users
    label-Verified = -1..+1 group gerrit-verifiers
    label-Verified = -1..+1 group google/gerritcodereview-maintainers@googlegroups.com
    submit = group google/gerritcodereview-maintainers@googlegroups.com
    forgeAuthor = group google/gerritcodereview-maintainers@googlegroups.com
    label-Code-Style = -1..+1 group google/gerritcodereview-maintainers@googlegroups.com
  [access "refs/for/refs/meta/config"]
    push = group gerrit-verifiers
  [notify "polygerrit-reviews"]
    email = polygerrit-reviews@google.com
    type = all_comments
    type = submitted_changes
    header = cc
    filter = file:polygerrit-ui
  [access "refs/heads/infra/config"]
    push = group gerrit-tricium-admins
  ```

### [rules.pl](https://gerrit-review.googlesource.com/Documentation/prolog-cookbook.html)
#### [submit by a non author](https://gerrit-review.googlesource.com/Documentation/prolog-cookbook.html#NonAuthorCodeReview)
```
submit_rule(S) :-
    gerrit:default_submit(X),
    X =.. [submit | Ls],
    add_non_author_approval(Ls, R),
    S =.. [submit | R].

add_non_author_approval(S1, S2) :-
    gerrit:commit_author(A),
    gerrit:commit_label(label('Code-Review', 2), R),
    R \= A, !,
    S2 = [label('Non-Author-Code-Review', ok(R)) | S1].
add_non_author_approval(S1, [label('Non-Author-Code-Review', need(_)) | S1]).
```
![non author cr](../../screenshot/gerrit/none-author-CR.png)

#### [ticket check](https://gerrit-review.googlesource.com/Documentation/prolog-cookbook.html#_example_7_make_change_submittable_if_commit_message_starts_with_fix)
> check also: [Prolog Gerrit - validate label if commit message contains a specific string](https://stackoverflow.com/q/27295382/2940319)

- optional validation
  ```
  submit_rule(S) :-
      gerrit:default_submit(X),
      X =.. [submit | Ls],
      require_ticket_check_for_ticket(Ls, Nls),
      S =.. [submit | Nls].

  require_ticket_check_for_ticket(S1, S2) :-
      gerrit:commit_message_matches('^issue-[\\d]+\\s?:\\s?[\\w\\W]+'),
      !,
      S2 = [label('Ticket-Checked', need(_)) | S1].

  require_ticket_check_for_ticket(S1, S2) :-
      !, S2 = S1.
  ```

![optional-check](../../screenshot/gerrit/optional_ticket_check-1.png)

- optional validation with auto vote
  ```
  submit_rule(S) :-
      gerrit:default_submit(X),
      X =.. [submit | Ls],
      require_ticket_check_for_ticket(Ls, Nls),
      S =.. [submit | Nls].

  require_ticket_check_for_ticket(S1, S2) :-
      gerrit:commit_message_matches('\\[issue-[\\d]{2}\\]\\s?:\\s?[\\w\\W]+'),
      !,
      S2 = [label('Ticket-Checked', ok(user(824))) | S1].

  require_ticket_check_for_ticket(S1, S2) :-
      !, S2 = S1.
  ```

![optional-check-autovote](../../screenshot/gerrit/mandatory_ticket_check-autovote-1.png)

![optional-check-autovote](../../screenshot/gerrit/mandatory_ticket_check-autovote-2.png)

- mandatory validation
  ```
  submit_rule(S) :-
    gerrit:default_submit(X), % get the current submit structure
    X=.. [submit | Ls],
    require_ticket_check_for_ticket(Ls, Nls),
    S=.. [submit | Nls].

  require_ticket_check_for_ticket(S1, S2) :-
     gerrit:commit_message_matches('\\[issue-[\\d]{2}\\][\\s\\S]+'),
     !,
     S2 = [label('Ticket-Checked', ok(user(790))) | S1]. % Add the label and automatically approval by user-id: 790

  require_ticket_check_for_ticket(S1, [label('Ticket-Checked', need(_)) | S1]).
  ```

![mandatory check](../../screenshot/gerrit/mandatory_ticket_check-autovote-1.png)

![mandatory check](../../screenshot/gerrit/mandatory_ticket_check-autovote-2.png)

## api
{% hint 'info' %}
> reference:
> - [Gerrit Code Review - REST API Developers' Notes](https://gerrit-review.googlesource.com/Documentation/dev-rest-api.html)
> - [Gerrit Code Review - REST API](https://gerrit-review.googlesource.com/Documentation/rest-api.html)
{% endhint %}

### [basic usage](https://gerrit-review.googlesource.com/Documentation/dev-rest-api.html#_basic_testing)
- regular options
  ```bash
                                    a might means [a]pi
                                      ⇡
  $ curl -X PUT    http://domain.name/a/path/to/api/
  $ curl -X POST   http://domain.name/a/path/to/api/
  $ curl -X DELETE http://domain.name/a/path/to/api/
  ```
- sending data
  - json
    ```bash
    $ curl -X PUT \
           -d@testdata.txt \
           --header "Content-Type: application/json" \
           http://domain.name/a/path/to/api/
    ```
  - txt
    ```bash
    $ curl -X PUT \
           --data-binary @testdata.txt \
           --header "Content-Type: text/plain" \
           http://domain.name/a/path/to/api/
    ```
- verifying header content
  ```bash
  $ curl -v -n -X DELETE http://domain.name/a/path/to/api/
  ```

### [change](https://gerrit-review.googlesource.com/Documentation/rest-api-changes.html)
- get change via change-id
  ```bash
  $ curl -X GET 'https://domina.name/a/changes/<change-id>'
  ```
- get change via commit-id
  ```groovy
  $ changeid=$(git show <commit-id> --no-patch --format="%s%n%n%b" | sed -nre 's!Change-Id: (.*$)!\1!p')
  $ curl -X GET "https://domina.name/a/changes/${changeid}"
  ```
  or
  ```bash
  $ project=$(echo 'path/to/project' | sed 's:/:%2F:g')
  $ branch='dev'
  $ changeid=$(git show <commit-id> --no-patch --format="%s%n%n%b" | sed -nre 's!Change-Id: (.*$)!\1!p')
  $ curl -X GET "https://domina.name/a/changes/${project}~${branch}~${changeid}"
  ```

### who approval the CR+2
```bash
$ curl -s -X GET https://domain.name/a/changes/${changeid}/detail |
       tail -n +2 |
       jq -r '.labels."Code-Review".approved.name'
```

### get all vote CR-2
{% hint style='tip' %}
- example output for `.labels.<tag>.all[]`
```json
{
  "value": -2,
  "date": "2021-05-31 07:57:14.000000000",
  "permitted_voting_range": {
    "min": -2,
    "max": 2
  },
  "_account_id": 790,
  "name": "Marslo Jiao",
  "email": "marslo.jiao@gmail.com",
  "username": "marslo"
}
{
  "value": 0,
  "permitted_voting_range": {
    "min": -2,
    "max": 2
  },
  "_account_id": 124,
  "name": "John Doe",
  "email": "john@gmail.com",
  "username": "john"
}
```
{% endhint %}

> reference:
> - [Select objects based on value of variable in object using jq](https://stackoverflow.com/a/64212172/2940319)
> - [jq select or statement](https://stackoverflow.com/a/53451410/2940319)
> - [How to select items in JQ based on value in array](https://stackoverflow.com/a/44867184/2940319)

```bash
$ curl -s -X GET https://domain.name/a/changes/${changeid}/detail |
       tail -n +2 |
       jq -r '.labels."Code-Review".all[] | select ( .value == -2 ) | .username'
                                          ⠆ ⠇⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠇ ⠆
                                          ⠆           ⇣             ⠆
                                          ⠆  select ".value"== -2   ⠆
                                          ⠆                         ⠆
                                          ⇣                         ⇣
                                         pipe                     pipe


# or
$ curl -s -X GET https://domain.name/a/changes/${changeid}/detail |
       tail -n +2 |
      jq -r '( .labels."Code-Review".all[] | select ( .value == -2 ) ).username'
             ⠆                                                       ⠆
             ⇣                                                       ⇣
         expression                                              expression

# or
$ curl -s -X GET https://domain.name/a/changes/${changeid}/detail |
       tail -n +2 |
      jq -r '[ .labels."Code-Review".all[] | select ( .value == -2 ) ][].username'
             ⠆                                                       ⠆
             ⇣                                                       ⇣
         expression                                              expression

# or
$ curl -s -X GET https://domain.name/a/changes/${changeid}/detail |
       tail -n +2 |
      jq -r '.labels."Code-Review".all[] | select ( .value == -2 )' |
      jq -r .username                                               ⠆
                                                                    ⇣
                                                                   pipe
```


### who approval the V+1
```bash
$ curl -s -X GET https://domain.name/a/changes/${changeid}/detail |
       tail -n +2 |
       jq -r .labels.Verified.approved.username
```

### reference
- [project owner guide](https://www.gerritcodereview.com/intro-project-owner.html)
- [Gerrit Code Review - Uploading Changes](https://www.gerritcodereview.com/user-upload.html)
- [gerrit/gerrit/refs/meta/config](https://gerrit.googlesource.com/gerrit/+/refs/meta/config)
- [gerrit 权限控制](https://blog.csdn.net/chenjh213/article/details/50571190)
- [its-jira plugin md](https://gerrit.googlesource.com/plugins/its-jira/+/refs/heads/stable-3.0/src/main/resources/Documentation/config.md)
- [Rule base configuration](https://review.opendev.org/plugins/its-storyboard/Documentation/config-rulebase-common.html)
