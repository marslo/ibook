<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [user](#user)
  - [get username from token](#get-username-from-token)
- [metadata](#metadata)
- [repo](#repo)
- [pull request](#pull-request)
- [branches](#branches)
  - [get branches](#get-branches)
  - [get details of a branch](#get-details-of-a-branch)
- [revision and tags](#revision-and-tags)
  - [get commits](#get-commits)
  - [post commit status](#post-commit-status)
  - [get HEAD of branch](#get-head-of-branch)
  - [get revision info](#get-revision-info)
- [actions runners](#actions-runners)
- [releases](#releases)
  - [release version](#release-version)
- [branch protection](#branch-protection)
  - [get branch protection](#get-branch-protection)
  - [init branch protection](#init-branch-protection)
  - [update lock_branch status](#update-lock_branch-status)
- [rulesets](#rulesets)
  - [list all rulesets](#list-all-rulesets)
  - [update ruleset](#update-ruleset)
  - [rulsets update history](#rulsets-update-history)
- [rule suites](#rule-suites)
  - [list failure rule suites](#list-failure-rule-suites)
  - [check failure evaluations](#check-failure-evaluations)
- [have fun](#have-fun)
  - [emoji](#emoji)
  - [zen](#zen)
  - [octocat](#octocat)
  - [rate limit](#rate-limit)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP]
> - [GitHub REST API documentation](https://docs.github.com/en/rest?apiVersion=2022-11-28)

> [!NOTE|label:headers]
> - `-H "Accept: application/vnd.github.v3+json"`
> - `-H "Authorization: token <TOKEN>"`
> - `-H "Authorization: Bearer <TOKEN>"`
> - `-H "Content-Type: application/json"`
> - `-H "Time-Zone: Europe/Amsterdam"`
> - `-H "X-GitHub-Api-Version: 2022-11-28"`

## user
### get username from token
```bash
$ curl -s -H "Authorization: token <TOKEN>" https://api.github.com/user | jq -r .login
# or
$ curl -s -H "Authorization: Bearer <TOKEN>" https://api.github.com/user | jq -r .login
```

## metadata
```bash
$ curl -sL https://api.github.com/meta | jq -r '.ssh_keys | .[]'
$ curl -sL https://api.github.com/meta | jq -r '.ssh_keys | .[]'  | sed -e 's/^/github.com /' >> ~/.ssh/know_hosts
```

## repo

- list all repos and permissions

  > [!TIP]
  > - list all repos: `GET /user/repos`
  > - list repos in special <ORG>/<OWNER>: `GET /orgs/<ORG>/repos`

  ```bash
  $ curl -sS -g -H "Authorization: Bearer <TOKEN>" \
         -H "Accept: application/vnd.github+json"
         'https://api.github.com/user/repos?per_page=100&type=all' |
    jq -r '.[] | select(.permissions != null)
               | (
                   if   p.admin     then "ADMIN"
                   elif p.maintain  then "MAINTAIN"
                   elif p.push      then "WRITE"
                   elif p.triage    then "TRIAGE"
                   elif p.pull      then "READ"
                   else "NONE" end
                 )
                 + "\t" + .html_url' |
    sort
  ```

- get repo info

  > [!TIP]
  > `GET /repos/{owner}/{repo}`

  ```bash
  # i.e.:
  $ curl -fsSL https://api.github.com/repos/marslo/ibook
  ```

- get repo contributors

  > [!TIP]
  > `GET /repos/{owner}/{repo}/contributors`

  ```bash
  # i.e.:
  $ curl -fsSL https://api.github.com/repos/marslo/ibook/contributors
  ```

## pull request

- get pull request info

  > [!TIP]
  > `GET /repos/{owner}/{repo}/pulls/{pull_number}`

  ```bash
  # i.e.:
  $ curl -fsSL https://api.github.com/repos/marslo/ibook/pulls/1
  ```

- get comments of a pull request

  > [!TIP]
  > `GET /repos/{owner}/{repo}/issues/{issue_number}/comments`

  ```bash
  # i.e.:
  $ curl -fsSL https://api.github.com/repos/marslo/ibook/issues/1/comments
  ```

## branches

### get branches

> [!TIP]
> `GET /repos/{owner}/{repo}/branches`

```bash
# i.e.:
$ curl -fsSL https://api.github.com/repos/marslo/ibook/branches
```

### get details of a branch

> [!TIP]
> `GET /repos/{owner}/{repo}/branches/{branch}`

```bash
# i.e.:
$ curl -fsSL https://api.github.com/repos/marslo/ibook/branches/main
```

## revision and tags

### get commits

> [!TIP|label:API]
> `GET /repos/{owner}/{repo}/commits`

```bash
$ curl -fsSL https://api.github.com/repos/<OWNER>/<REPO>/commits

# i.e.:
$ curl -fsSL https://api.github.com/repos/marslo/ibook/commits
```

### post commit status

> [!TIP|label:API]
> `POST repos/${OWNER}/${REPO}/statuses/${sha}`

```bash
$ curl -X POST -H "Authorization: token ${GITHUB_TOKEN}" \
       -H "Accept: application/vnd.github+json" \
       https://api.github.com/repos/${OWNER}/${REPO}/statuses/${SHA} \
       -d '{
         "state": "success",
         "target_url": "https://ci.example.com/build/status/123",
         "description": "All tests passed",
         "context": "ci/build"
       }'
```

### get HEAD of branch

> [!TIP|label:API]
> `GET /repos/{owner}/{repo}/git/refs/heads/{branch}`

```bash
$ curl -fsSL https://api.github.com/repos/<OWNER>/<REPO>/git/refs/heads/<BRANCH>
# i.e.:
$ curl -fsSL https://api.github.com/repos/marslo/ibook/git/refs/heads/marslo --jq .object.sha

$ gh api "repos/<OWNER>/<REPO>/refs/heads/<BRANCH>"
# i.e.:
$ gh api "repos/marslo/ibook/git/refs/heads/marslo" --jq .object.sha
```

### get revision info

> [!TIP|label:API]
> `GET /repos/{owner}/{repo}/commits/{sha}`

```bash
$ gh api repos/{owner}/{repo}/commits/{sha}

# i.e.:
$ gh api repos/${OWNER}/${REPO}/commits/{sha} \
     --jq '[
            "revision: \(.sha)",
            "author: \(.commit.author.name) <\(.commit.author.email)> - \(.commit.author.date)",
            "committer: \(.commit.committer.name) <\(.commit.committer.email)> - \(.commit.committer.date)",
            {message: (.commit.message | split("\n")) }
           ]'
```

## actions runners

- list workflow runs

  > [!TIP|label:API]
  > `GET /repos/{owner}/{repo}/actions/runs`

  ```bash
  $ curl -fsSL https://api.github.com/repos/<OWNER>/<REPO>/actions/runs

  # i.e.:
  $ curl -fsSL https://api.github.com/repos/marslo/ibook/actions/runs
  ```

- get workflow run logs

  > [!TIP|label:API]
  > `GET /repos/{owner}/{repo}/actions/runs/{run_id}/logs`

  ```bash
  $ curl -fsSL https://api.github.com/repos/<OWNER>/<REPO>/actions/runs/<RUN_ID>/logs

  # i.e.:
  $ curl -fsSL https://api.github.com/repos/marslo/ibook/actions/runs/1234567890/logs
  ```

- trigger workflow run

  > [!TIP|label:API]
  > `POST /repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches`

  ```bash
  # i.e.:
  $ curl -X POST -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ghp_v**********************************n" \
    https://api.github.com/repos/marslo/ibook/actions/workflows/ci.yml/dispatches \
    -d '{"ref":"main"}'
  ```

## releases
### release version
```bash
$ curl --silent 'https://api.github.com/repos/<owner>/<repo>/releases/latest' | jq -r .tag_name

# i.e.:
$ curl --silent 'https://api.github.com/repos/sharkdp/bat/releases/latest' | jq -r .tag_name
```

## branch protection

> [!NOTE|label:references:]
> - [REST API endpoints for protected branches](https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28)

### get branch protection

> [!TIP|label:API]
> `GET /repos/{owner}/{repo}/branches/{branch}/protection`

```bash
$ gh api "repos/${OWNER}/${REPO}/branches/${BRANCH}/protection"
```

### init branch protection

```bash
$ lock=true
$ jq -n --argjson lock "${lock}" '{
    required_status_checks: null,
    required_pull_request_reviews: null,
    restrictions: null,
    enforce_admins: $lock,
    lock_branch: $lock
  }' |
  gh api -X PUT -H "Accept: application/vnd.github+json" \
     "repos/${OWNER}/${REPO}/branches/${BRANCH}/protection" --input -
```

### update lock_branch status

> [!TIP|label:jq tricy]
> ```bash
> $ jq -n '.var1=true | .var2=false'
> {
>   "var1": true,
>   "var2": false
> }
> ```

```bash
$ lock=true  # or false

# read current settings
$ base=$(gh api -H "Accept: application/vnd.github+json" "repos/${OWNER}/${REPO}/branches/${BRANCH}/protection")

# update lock_branch and enforce_admins only, and keep other settings unchanged ( dyanamically get keys and values )
$ jq -n \
     --argjson base "$base" \
     --argjson lock "$lock" '
     (
       $base
       | del( .url )
       | with_entries(
           if ( .value | type=="object" and has("enabled") )
           then { key: .key, value: (.value.enabled // false) }
           else .
           end
         )
     )
     | .lock_branch                   = $lock
     | .enforce_admins                = $lock
     | .required_status_checks        = $base.required_status_checks
     | .required_pull_request_reviews = $base.required_pull_request_reviews
     | .restrictions                  = $base.restrictions
  ' |
  gh api -X PUT -H "Accept: application/vnd.github+json" \
     "repos/${OWNER}/${REPO}/branches/${BRANCH}/protection" --input -
```

> [!TIP|label:jq tricy]
> $ jq -n '{var1:true, var2:false}'
> {
>   "var1": true,
>   "var2": false
> }

```bash
$ lock=true  # or false

# read current settings
$ base=$(gh api -H "Accept: application/vnd.github+json" "repos/${OWNER}/${REPO}/branches/${BRANCH}/protection")

# update lock_branch and enforce_admins only
$ jq -n \
     --argjson base "${base}" \
     --argjson lock "${lock}" \
  '{
    required_status_checks:           $base.required_status_checks,
    required_pull_request_reviews:    $base.required_pull_request_reviews,
    restrictions:                     $base.restrictions,

    enforce_admins:                   $lock,
    lock_branch:                      $lock,

    required_linear_history:          ( $base.required_linear_history.enabled // false ),
    allow_force_pushes:               ( $base.allow_force_pushes.enabled // false ),
    allow_deletions:                  ( $base.allow_deletions.enabled // false ),
    block_creations:                  ( $base.block_creations.enabled // false ),
    required_conversation_resolution: ( $base.required_conversation_resolution.enabled // false ),
    allow_fork_syncing:               ( $base.allow_fork_syncing.enabled // false )
  }' |
  gh api -X PUT \
     -H "Accept: application/vnd.github+json" \
     "repos/${OWNER}/${REPO}/branches/${BRANCH}/protection" --input -
```

## rulesets

### list all rulesets
```bash
$ gh api "repos/{owner}/{repo}/rulesets"

# or: list id and name
$ gh api "repos/{owner}/{repo}/rulesets" | jq -r '.[] | (.id|tostring) + ": " + .name'
7288536: BranchDeleteRule
7288533: BranchNamingRule
7288566: PRRuleSet
```

### update ruleset

> [!NOTE|label:references:]
> - this is to add new branch into exclude list of ruleset
> - API:
>   - [Get all repository rulesets](https://docs.github.com/en/rest/repos/rules?apiVersion=2022-11-28#get-all-repository-rulesets)
>   - [Update a repository ruleset](https://docs.github.com/en/rest/repos/rules?apiVersion=2022-11-28#update-a-repository-ruleset)

- get current rulesets

  > [!TIP|label:API]
  > `GET /repos/{owner}/{repo}/rulesets/{ruleset_id}`

  ```bash
  $ gh api \
      -H 'Accept: application/vnd.github+json' \
      -H 'X-GitHub-Api-Version: 2022-11-28' \
      "/repos/${OWNER}/${REPO}/rulesets/${RULESET_ID}" > ruleset.org.json
  ```

- create new ruleset json
  ```bash
  $ branch='refs/heads/devel'
  $ jq --arg ref "${BRANCH}" '{
      name, target, enforcement, bypass_actors, rules,
      conditions: {
        ref_name: {
          include: ( .conditions.ref_name.include // ["~ALL"] ),
          exclude: ( (.conditions.ref_name.exclude // []) + [$ref] | unique )
        }
      }
    }' "ruleset" > "ruleset.new.json"
  ```

- update ruleset

  > [!TIP|label:API]
  > `PUT /repos/{owner}/{repo}/rulesets/{ruleset_id}`

  ```bash
  $ gh api -X PUT \
      -H 'Accept: application/vnd.github+json' \
      -H 'X-GitHub-Api-Version: 2022-11-28' \
      "/repos/${OWNER}/${REPO}/rulesets/${RULSET_ID}" \
      --input "ruleset.new.json"
  ```

### rulsets update history

> [!NOTE|label:references:]
> - [Get repository ruleset history](https://docs.github.com/en/rest/repos/rules?apiVersion=2022-11-28#get-repository-ruleset-history)

## rule suites

> [!NOTE|label:references:]
> - [List repository rule suites](https://docs.github.com/en/rest/repos/rule-suites?apiVersion=2022-11-28#list-repository-rule-suites)
> - [Get a repository rule suite](https://docs.github.com/en/rest/repos/rule-suites?apiVersion=2022-11-28#get-a-repository-rule-suite)

### list failure rule suites

```bash
$ gh api -H 'X-GitHub-Api-Version: 2022-11-28' \
  "/repos/${OWNER}/${REPO}/rulesets/rule-suites?ref=refs/heads/${BRANCH}&time_period=week"

# or
$ gh api -H 'X-GitHub-Api-Version: 2022-11-28' \
  "/repos/${OWNER}/${REPO}/rulesets/rule-suites?ref=refs/heads/${BRANCH}&time_period=week" \
  --jq '.[] | {id, ref, pushed_at, actor_name, result}'
```

<!--sec data-title="sample result" data-id="section0" data-show=true data-collapse=true ces-->
```bash
{
  "actor_name": "username",
  "id": 1445681219,
  "pushed_at": "2025-09-17T16:23:14-07:00",
  "ref": "refs/heads/devel",
  "result": "pass"
}
{
  "actor_name": "username",
  "id": 1445649205,
  "pushed_at": "2025-09-17T16:10:30-07:00",
  "ref": "refs/heads/devel",
  "result": "fail"
}
{
  "actor_name": "username",
  "id": 1445570037,
  "pushed_at": "2025-09-17T15:44:01-07:00",
  "ref": "refs/heads/devel",
  "result": "fail"
}
```
<!--endsec-->

### check failure evaluations
```bash
$ gh api -H 'X-GitHub-Api-Version: 2022-11-28' "/repos/${OWNER}/${REPO}/rulesets/rule-suites/${RULE_SUITE_ID}"

# or list only failure evaluations
$ gh api -H 'X-GitHub-Api-Version: 2022-11-28' \
  "/repos/${OWNER}/${REPO}/rulesets/rule-suites/${RULE_SUITE_ID}" \
  --jq '.rule_evaluations[] | select(.result=="fail")'

# or
$ gh api -H 'X-GitHub-Api-Version: 2022-11-28' \
  "/repos/${OWNER}/${REPO}/rulesets/rule-suites/${RULE_SUITE_ID}" \
  --jq '{ref, result, failed_rules: (.rule_evaluations | map(select(.result=="fail")))}'
```

<!--sec data-title="failure evaluations result" data-id="section1" data-show=true data-collapse=true ces-->
```bash
{
  "details": "Cannot create ref due to creations being restricted.",
  "enforcement": "active",
  "result": "fail",
  "rule_source": {
    "id": 7288533,
    "name": "BranchNamingRule",
    "type": "ruleset"
  },
  "rule_type": "creation"
}
{
  "details": "2 of 2 required status checks are expected.",
  "enforcement": "active",
  "result": "fail",
  "rule_source": {
    "id": 7288566,
    "name": "PRRuleSet",
    "type": "ruleset"
  },
  "rule_type": "required_status_checks"
}
```
<!--endsec-->



## have fun
### emoji
```bash
$ curl -fsSL -XGET https://api.github.com/emojis
```

### zen
```bash
$ curl -fsSL -XGET https://api.github.com/zen
```

### octocat
```bash
$ curl -fsSL -XGET https://api.github.com/octocat
```

### rate limit
```bash
$ curl -fsSL -XGET https://api.github.com/rate_limit
```
