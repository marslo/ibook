<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [.gitconfig](#gitconfig)
  - [default groups](#default-groups)
- [refs/meta/config](#refsmetaconfig)
  - [get project.config](#get-projectconfig)
  - [publish to remote](#publish-to-remote)
  - [update meta/config if remotes update](#update-metaconfig-if-remotes-update)
  - [reset to remotes](#reset-to-remotes)
  - [useful refs](#useful-refs)
  - [only allow code review merge, forbidden code push](#only-allow-code-review-merge-forbidden-code-push)
  - [Code-Review 1+1=2](#code-review-112)
  - [optional label vote](#optional-label-vote)
  - [sections](#sections)
  - [Submit Requirements](#submit-requirements)
  - [plugin](#plugin)
- [rules.pl](#rulespl)
  - [submit by a non author](#submit-by-a-non-author)
  - [Labels and Submit Requirements](#labels-and-submit-requirements)
  - [ticket check](#ticket-check)
- [tips](#tips)
  - [generate changeId](#generate-changeid)
  - [Auto-submit reviews](#auto-submit-reviews)
  - [Translating Gerrit Change-Ids using the CLI](#translating-gerrit-change-ids-using-the-cli)
  - [Signed-off-by Lines](#signed-off-by-lines)
- [integrate in Jenkins](#integrate-in-jenkins)
- [css for code block](#css-for-code-block)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [Gerrit Code Review - Access Controls](https://gerrit.cloudera.org/Documentation/access-control.html)
>   - [Special and magic references](https://gerrit.cloudera.org/Documentation/access-control.html#references)
>     - [Magic references](https://gerrit.cloudera.org/Documentation/access-control.html#references_magic)
>   - [Access Categories](https://gerrit.cloudera.org/Documentation/access-control.html#access_categories)


## .gitconfig
```bash
$ git config --global gitreview.username <UserName>
$ git config --global gitreview.remote origin
```

### default groups

> [!TIP]
> - [Gerrit Code Review - Access Controls](https://git.eclipse.org/r/Documentation/access-control.html#non-interactive_users)

- System Groups
  - [Anonymous Users](https://gerrit.cloudera.org/Documentation/access-control.html#anonymous_users)
  - [Change Owner](https://gerrit.cloudera.org/Documentation/access-control.html#change_owner)
  - [Project Owners](https://gerrit.cloudera.org/Documentation/access-control.html#project_owners)
  - [Registered Users](https://gerrit.cloudera.org/Documentation/access-control.html#registered_users)

- [Predefined Groups](https://gerrit.cloudera.org/Documentation/access-control.html#_predefined_groups)
  - [Administrators](https://gerrit.cloudera.org/Documentation/access-control.html#administrators)
  - [Non-Interactive Users](https://gerrit.cloudera.org/Documentation/access-control.html#non-interactive_users)
  - ~Service Users~

#### special references

* `refs/changes/*`
* `refs/meta/config`
* `refs/meta/dashboards/*`
* [`refs/notes/review`](https://gerrit.googlesource.com/plugins/reviewnotes/+/refs/heads/master/src/main/resources/Documentation/refs-notes-review.md)

#### magic references

* `refs/for/<branch ref>`

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

  > [!NOTE|label:references:]
  > - [smirn0v/gist:b8e6c4bedebed23a0328](https://gist.github.com/smirn0v/b8e6c4bedebed23a0328)

  ```bash
  $ git push origin HEAD:refs/for/refs/meta/config
  ```
  - or
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

#### freeze `main` branch

> [!TIP]
> One quirk is that the shortest possible pattern expansion must be a valid ref name<br>
> thus `^refs/heads/.*/name` will fail because `refs/heads//name` is not a valid reference<br>
> but `^refs/heads/.+/name` will work.


About the `refs/for` namespace
> [!TIP]
> references:<br>
> - [what is the use refs/for/refs/* in gerrit?](https://stackoverflow.com/a/54551260/2940319)
> <br>
> `refs/for/*` syntax is just a short name for `refs/for/refs/*`:

- `project.config`
  ```bash
  [access "refs/for/refs/heads/main"]
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

  - or using `exclusiveGroupPermissions`
    ```
    [access "^refs/heads/backup/(main|dev|staging|stable)/.+$"]
           exclusiveGroupPermissions = create delete push pushMerge
           create = group Project Owners
           create = block group Registered Users
           delete = block group Registered Users
           push = block group Registered Users
           pushMerge = block group Registered Users
    [access "^refs/for/refs/heads/backup/(main|dev|staging|stable)/.+$"]
           exclusiveGroupPermissions = addPatchSet create push pushMerge submit
           addPatchSet = block group Registered Users
           create = block group Registered Users
           push = block group Registered Users
           pushMerge = block group Registered Users
           submit = block group Registered Users
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

### only allow code review merge, forbidden code push

> [!TIP|label:references:]
> - restriction for branches (`feature1`, `feature2` and `main`)

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
  [access "^refs/heads/(feature1|feature2|main)$"]
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

- [example](https://gerrit.googlesource.com/gerrit/+/refs/meta/config/project.config)

  <!--sec data-title="`project.config` example" data-id="section0" data-show=true data-collapse=true ces-->

  > [!TIP|label:references:]
  > - [project.config](https://gerrit.googlesource.com/gerrit/+/refs/meta/config/project.config)

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
  <!--endsec-->

### Code-Review 1+1=2

> [!NOTE|label:references:]
> - [How to config 1+1=2 Code-Review with Submit Requirements?](https://groups.google.com/g/repo-discuss/c/-AuPt50vR70/m/CaZXQH3uAwAJ)

```bash
[label "Code-Review"]
  function = NoOp
  copyMinScore = true
  value = -2 This shall not be merged
  value = -1 I would prefer this is not merged as is
  value = 0 No score
  value = +1 Looks good to me, but someone else must approve
  value = +2 Looks good to me, approved
  defaultValue = 0
[submit-requirement "Code-Review"]
  submittableIf = (label:Code-Review=+1,count>=2 OR label:Code-Review=MAX) AND -label:Code-Review=MIN
```

### optional label vote

> [!NOTE|label:references:]
> - [Customized Labels](https://gerrit-review.googlesource.com/Documentation/config-labels.html#label_custom)
> - [`label.Label-Name.function (deprecated)`](https://gerrit-review.googlesource.com/Documentation/config-labels.html#label_function)
>   - `MaxWithBlock` ( default )
>   - `AnyWithBlock`
>   - `MaxNoBlock`
>   - `NoOp` / `NoBlock`
>   - `PatchSetLock`

```bash
[label "Klocwork"]
  function = NoOp
  value = -1 Fails
  value = 0 No score
  value = +1 Success
  defaultValue = 0
  copyAllScoresIfNoCodeChange = true
```

### sections

> [!NOTE|label:references:]
> - [project.config sections](https://gerrit-review.googlesource.com/Documentation/config-project-config.html#file-project_config)
> - [Gerrit Code Review - Configuration - `etc/gerrit.config`](https://gerrit-review.googlesource.com/Documentation/config-gerrit.html)

#### [`commentlink`](https://gerrit-review.googlesource.com/Documentation/config-gerrit.html#commentlink)
```bash
[commentlink "changeid"]
  match = (I[0-9a-f]{8,40})
  link = "/q/$1"

[commentlink "bugzilla"]
  match = "(^|\\s)(bug\\s+#?)(\\d+)($|\\s)"
  link = http://bugs.example.com/show_bug.cgi?id=$3
  prefix = $1
  suffix = $4
  text = $2$3

[commentlink "its-jira"]
  match = ^[ \\t]*([A-Za-z]*-[0-9]{1,5}):
  link = https://jira.domain.com/browse/$1
```

#### [`receive`](https://gerrit-review.googlesource.com/Documentation/config-project-config.html#receive-section)
```bash
[receive]
  requireChangeId = true
  createNewChangeForAllNotInTarget = false
  rejectImplicitMerges = false
  requireSignedOffBy = true
  maxObjectSizeLimit = 6m
  maxBatchChanges = 1
```

#### [`change`](https://gerrit-review.googlesource.com/Documentation/config-project-config.html#change-section)
```bash
[change]
  privateByDefault = false
  workInProgressByDefault = false
```

### [Submit Requirements](https://gerrit-review.googlesource.com/Documentation/config-submit-requirements.html#exempt-branch-example)

> [!NOTE|label:references:]
> - [#51263 - Core library review Gerrit condition should consider CL creator.](https://github.com/dart-lang/sdk/issues/51263#issuecomment-1423847018)

- [exempt a branch example](https://gerrit-review.googlesource.com/Documentation/config-submit-requirements.html#exempt-branch-example)
  ```bash
  [submit-requirement "Code-Style"]
    description = Code is properly styled and formatted
    applicableIf = -branch:refs/meta/config
    submittableIf = label:Code-Style=+1 AND -label:Code-Style=-1
    canOverrideInChildProjects = true
  ```

  - or setup in `label: LABEL`
    ```
    [label "Verified"]
      branch = refs/heads/release/*

    # same as
    [submit-requirement "Verified"]
      submittableIf = label:Verified=MAX AND -label:Verified=MIN
      applicableIf = branch:^refs/heads/release/.*
    ```

- complex rule

  > [!NOTE|label:references:]
  > - [Gerrit 3.7-Submit Rules How to apply multiple branches.](https://groups.google.com/g/repo-discuss/c/a2DsDVeYyBY)

  ```
   [submit-requirement "Core-Library-Review"]
      description = "SDK core library changes need to be approved for each platform or have a 'CoreLibraryReviewExempt: <reason>' footer. See also: https://github.com/dart-lang/sdk/wiki/Gerrit-Submit-Requirements#core-library-review"
      applicableIf = NOT ownerin:bots AND NOT is:pure-revert AND path:\"^sdk/lib/[^_].*\\.dart$\"
      submittableIf = hasfooter:CoreLibraryReviewExempt OR ((label:Code-Review=+1,group=mdb/dart-core-library-change-approvers-api OR ownerin:mdb/dart-core-library-change-approvers-api) AND (label:Code-Review=+1,group=mdb/dart-core-library-change-approvers-vm OR ownerin:mdb/dart-core-library-change-approvers-vm) AND (label:Code-Review=+1,group=mdb/dart-core-library-change-approvers-wasm OR ownerin:mdb/dart-core-library-change-approvers-wasm) AND (label:Code-Review=+1,group=mdb/dart-core-library-change-approvers-web OR ownerin:mdb/dart-core-library-change-approvers-web))
      canOverrideInChildProjects = false
  ```

- [commit message format](https://groups.google.com/g/golang-checkins/c/4ZWyQdcB1Og)
  ```
  applicableIf = message:\"^.*(D|d)(O|o) (N|n)(O|o)(T|t) (R|r)(E|e)(V|v)(I|i)(E|e)(W|w).*\"
  ```

- [branch regex](https://groups.google.com/g/golang-checkins/c/H_xlE2ar0_4/m/o6FJMleXAQAJ)
  ```
  applicableIf = branch:\"^refs/heads/release-branch.+\"
  ```

### plugin
```bash
[plugin "its-jira"]
  association = OPTIONAL
  branch = ^refs/heads/.*
  commentOnChangeAbandoned = false
  commentOnChangeCreated = true
  commentOnChangeMerged = true
  commentOnChangeRestored = false
  commentOnCommentAdded = true
  commentOnFirstLinkedPatchSetCreated = true
  commentOnPatchSetCreated = false
  commentOnRefUpdatedGitWeb = true
  enabled = enforced
```

## [rules.pl](https://gerrit-review.googlesource.com/Documentation/prolog-cookbook.html)

> [!NOTE|label:references:]
> - [Prolog Submit Rules Cookbook](https://gerrit.cloudera.org/Documentation/prolog-cookbook.html#SubmitRule)

### [submit by a non author](https://gerrit-review.googlesource.com/Documentation/prolog-cookbook.html#NonAuthorCodeReview)

> [!TIP|label:references:]
> - [Exclude author from gerrit review](https://stackoverflow.com/a/47887713/2940319)
> - [`submittableIf = ..,user=non_uploader`](https://gerrit-review.googlesource.com/Documentation/config-submit-requirements.html#code-review-example)

- by `rules.pl`
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

- by `project.config`
  ```
  [access "refs/*"]
    label-Code-Review = block -2..+2 group Change Owner
    exclusiveGroupPermissions = label-Code-Review
  ```

- by `submit-requirement`
  ```
  [submit-requirement "Code-Review"]
    description = A maximum vote from a non-uploader is required for the \
                  'Code-Review' label. A minimum vote is blocking.
    submittableIf = label:Code-Review=MAX,user=non_uploader AND -label:Code-Review=MIN
    canOverrideInChildProjects = true
  ```

### [Labels and Submit Requirements](https://gerrit-review.googlesource.com/Documentation/config-submit-requirements.html#labels)
```bash
[label "Code-Review"]
  function = NoBlock
  value = -2 This shall not be submitted
  value = -1 I would prefer this is not merged as is
  value = 0 No score
  value = +1 Looks good to me, but someone else must approve
  value = +2 Looks good to me, approved
  defaultValue = 0
[submit-requirement "Code-Review"]
  description = At least one maximum vote for label 'Code-Review' is required
  submittableIf = label:Code-Review=MAX,user=non_uploader AND -label:Code-Review=MIN
  canOverrideInChildProjects = true
```

### [ticket check](https://gerrit-review.googlesource.com/Documentation/prolog-cookbook.html#_example_7_make_change_submittable_if_commit_message_starts_with_fix)

> [!TIP]
> check also:
> - [Prolog Gerrit - validate label if commit message contains a specific string](https://stackoverflow.com/q/27295382/2940319)

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

## tips

### [generate changeId](https://github.com/dart-lang/sdk/issues/51263#issuecomment-1424153906)
```bash
$ echo Change-Id: I$({ git var GIT_COMMITTER_IDENT ; echo "$refhash" ; git show HEAD; } | git hash-object --stdin)
Change-Id: I86a371ebf8d29fd1634ed9191d594ce22b1f0953
```

### [Auto-submit reviews](https://stackoverflow.com/a/17782124/2940319)
```groovy
if(manager.build.result.isBetterThan(hudson.model.Result.UNSTABLE)) {
    def cmd = 'ssh -p 29418 HOST gerrit review --verified +1 --code-review +2 --submit --project $GERRIT_PROJECT $GIT_COMMIT'
    cmd = manager.build.environment.expand(cmd)
    manager.listener.logger.println("Merge review: '$cmd'")
    def p = "$cmd".execute()
    manager.listener.logger.println(p.in.text)
    manager.addShortText("M")
}
```

### [Translating Gerrit Change-Ids using the CLI](https://www.coreboot.org/Git#Commit_messages)
```bash
$ # setup (only needed once)
$ git config --global alias.gerrit-id '!f() { git log |egrep "^(commit | *Change-Id:)" |grep -B1 $1 |head -1 |sed "s,^commit ,,"; }; f'
$ # use:
$ git gerrit-id Ifeb277
a3ea1e45902b64b45e141ebae2f59b94e745d187
```

### [Signed-off-by Lines](https://gerrit-review.googlesource.com/Documentation/user-signedoffby.html)

> [!NOTE|label:references:]
> - [Reported-by:, Tested-by: and Reviewed-by:](https://gerrit-review.googlesource.com/Documentation/user-signedoffby.html#Reviewed-by)
>   - `Reported-by:`
>   - `Tested-by:`
>   - `Reviewed-by:`
> - [The refs/notes/review namespace](https://gerrit.googlesource.com/plugins/reviewnotes/+/refs/heads/master/src/main/resources/Documentation/refs-notes-review.md)
> - [Git: Gerrit Code Review](https://gist.github.com/afbjorklund/b120164312c7353de549)
> - [refs/notes/review](https://gerrit-review.googlesource.com/Documentation/access-control.html#references_special)
>   - Autogenerated copy of review notes for all changes in the git. Each log entry on the refs/notes/review branch also references the patch set on which the review is made. This functionality is provided by the review-notes plugin.

## integrate in Jenkins

> [!NOTE|label:references:]
> - [Gerrit Trigger](https://plugins.jenkins.io/gerrit-trigger/)
> - [How does the Gerrit- trigger plugin in Jenkins works?](https://stackoverflow.com/a/16206203/2940319)

- `stream-events`

  ```bash
  # permission requires
  $ ssh -i id_rsa jenkins@gerrit.domain.com -p 29418 gerrit stream-events
  stream events not permitted

  # verify
  $ ssh -i id_rsa jenkins@gerrit.domain.com -p 29418 gerrit stream-events | jq -r .type
  ref-updated
  comment-added
  ```

- build current patches only

  > [!NOTE]
  > Warning: The current implementation takes into account that 'Build Current Patches Only' with 'Abort new patch sets' and 'Abort patch sets with same topic' are enabled (see help for more).

  ![gerrit trigger](../../screenshot/jenkins/gerrit-trigger.png)

- generate ssh-key

  ```bash
  $ keyname='devops@jenkins'
  $ ssh-keygen -m PEM -t rsa -f ~/.ssh/${keyname} -C "${keyname}" -P '' -q
  ```

## css for code block
```css
.gr-formatted-text-0 gr-linked-text.pre.gr-formatted-text,
gr-linked-text[class*="pre"], gr-linked-text[class*="pre"] #output {
  font-family: "Comic Mono", "Monaco", "Menlo", "Andale Mono", "Ubuntu Mono", "monofur" !important;
  font-size: 16px !important;
}
.gr-formatted-text-0 gr-linked-text.pre.gr-formatted-text,
gr-linked-text[class*="pre"] {
  color: #c8c8c8 !important;
  background: #272727 !important;
  border-radius: .75em !important;
  box-shadow: 0 4px 8px 0 rgb(0 0 0 / 20%), 0 6px 20px 0 rgb(0 0 0 / 19%);
  overflow: auto;
  display: block;
  padding: 12px 12px 1px 12px;
  margin: 0px;
}
```

- gruvbox
  - background : `#272727`
  - front-color: `#e8dbb6`

  ![gruvbox code block](../../screenshot/gerrit/gerrit-code-block-gruvbox.png)

- ubunut
  - background : `#3a122e`
  - front-color: `#eee`

  ![ubuntu code block](../../screenshot/gerrit/gerrit-code-block-ubuntu.png)

- solarized
  - background : `#0d2a34`
  - front-color: `#869395`

  ![solarized code block](../../screenshot/gerrit/gerrit-code-block-solarized.png)
