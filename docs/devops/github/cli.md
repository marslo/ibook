<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [install](#install)
  - [auto completion](#auto-completion)
- [authentication](#authentication)
  - [authentication scopes](#authentication-scopes)
  - [list repos and permissions](#list-repos-and-permissions)
- [commits](#commits)
  - [list commit](#list-commit)
  - [get commit created time](#get-commit-created-time)
  - [get HEAD of branch](#get-head-of-branch)
- [tags](#tags)
  - [list tags](#list-tags)
  - [add lightweight tags](#add-lightweight-tags)
- [branch protection](#branch-protection)
  - [get branch protection](#get-branch-protection)
  - [init branch protection](#init-branch-protection)
  - [update lock_branch status](#update-lock_branch-status)
- [pr](#pr)
  - [json field mapping](#json-field-mapping)
  - [create pr](#create-pr)
  - [comment on pr](#comment-on-pr)
  - [edit pr](#edit-pr)
  - [merge pr](#merge-pr)
  - [list pr](#list-pr)
  - [get HEAD of PR](#get-head-of-pr)
- [issues](#issues)
  - [list issues](#list-issues)
  - [create issue](#create-issue)
  - [comments on issue](#comments-on-issue)
- [checkers](#checkers)
  - [list check-runs status](#list-check-runs-status)
  - [list check-runs history in PR](#list-check-runs-history-in-pr)
  - [view, cancel or rerun check-runs](#view-cancel-or-rerun-check-runs)
  - [force set checker status](#force-set-checker-status)
  - [get checkers version](#get-checkers-version)
- [rulesets](#rulesets)
  - [list all rulesets](#list-all-rulesets)
  - [list ruleset with keywrods](#list-ruleset-with-keywrods)
  - [update ruleset](#update-ruleset)
  - [rulsets update history](#rulsets-update-history)
- [rule suites](#rule-suites)
  - [list failure rule suites](#list-failure-rule-suites)
  - [check failure evaluations](#check-failure-evaluations)
- [tips](#tips)
  - [open in web](#open-in-web)
  - [switch accounts](#switch-accounts)
  - [config setup](#config-setup)
  - [alias](#alias)
  - [list ssh-key](#list-ssh-key)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:reference:]
> - [gh](https://cli.github.com/manual/gh)
> - [gh api](https://cli.github.com/manual/gh_api)

## install

```bash
# ubuntu/debian
$ (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
# -- or --
$ version=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest | jq -r .tag_name)
$ pkg=""gh_${version}_linux_$(pkg --print-architecture).deb""
$ curl -fsSL -O "https://github.com/cli/cli/releases/download/$(echo "${version}" | sed 's/[^0-9.]//g')/${pkg}"
$ sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq -o Dpkg::Use-Pty=0 "./${pkg}"

# yum
$ type -p yum-config-manager >/dev/null || sudo yum install yum-utils
$ sudo yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
$ sudo yum install gh

# dnf5
$ sudo dnf install dnf5-plugins
$ sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
$ sudo dnf install gh --repo gh-cli

# dnf4
$ sudo dnf install 'dnf-command(config-manager)'
$ sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
$ sudo dnf install gh --repo gh-cli
```

### auto completion

```bash
# bash
$ echo 'eval "$(gh completion --shell bash)"' >> ~/.bashrc

# zsh
$ echo 'eval "$(gh completion --shell zsh)"' >> ~/.zshrc

# fish
$ gh completion --shell fish > ~/.config/fish/completions/gh.fish

# powershell
> 'gh completion --shell powershell | Out-String | Invoke-Expression' | Out-File -Append -Encoding utf8 $PROFILE
```

## authentication

> [!TIP|label:clear environment variable]
> ```bash
> $ unset GITHUB_TOKEN GITHUB_USER
> ```

```bash
# gh login with web
$ gh auth login --hostname github.com --git-protocol ssh --web

# token
$ gh auth login -h github.com --with-token <<< "${GH_ACCESS_TOKEN}"

# PAT
$ gh auth login --hostname github.com --git-protocol ssh
? Upload your SSH public key to your GitHub account? Skip
? How would you like to authenticate GitHub CLI? Paste an authentication token
Tip: you can generate a Personal Access Token here https://github.com/settings/tokens
The minimum required scopes are 'repo', 'read:org'.
? Paste your authentication token: ****************************************
```

### authentication scopes

```bash
# scope: admin:public_key
$ gh auth refresh -h github.com -s admin:public_key

# scope: read:gpg_key
$ gh auth refresh -s read:gpg_key
```

```bash
# add authentication scopes
$ gh auth refresh --scopes <scope>
# i.e.:
$ gh auth refresh -h github.com -s admin:public_key
$ gh auth refresh -s read:gpg_key
```

```bash
# remove authentication scopes
$ gh auth refresh --remove-scopes <scope>
```

### list repos and permissions

```bash
$ gh repo list "${OWNER}" --limit 10000 --json nameWithOwner,viewerPermission

# list admin only
$ gh repo list "${OWNER}" --limit 10000 --json nameWithOwner,viewerPermission \
     --jq '.[] | select(.viewerPermission=="ADMIN") | .nameWithOwner'

# list all info
$ gh repo list "${OWNER}" --limit 10000 --json nameWithOwner,viewerPermission \
     --jq '.[] | .viewerPermission + "\t" + .nameWithOwner'

# list with perm order
$ gh repo list "${OWNER}" --limit 10000 --json nameWithOwner,viewerPermission \
     --jq 'sort_by([
            -( .viewerPermission as $p | (["READ","TRIAGE","WRITE","MAINTAIN","ADMIN"] | index($p)) ),
            .nameWithOwner
           ])
           | .[]
           | "\(.viewerPermission)\t\(.nameWithOwner)"' |
  column -t
```

## commits

### list commit
```bash
$ gh api repos/${OWNER}/${REPO}/commits/${REVISION}

# i.e.:
$ gh api repos/${OWNER}/${REPO}/commits/${REVISION} --jq '.commit.committer'

$ gh api repos/${OWNER}/${REPO}/commits/${REVISION} \
     --jq '[.sha, "\(.commit.author.name) <\(.commit.author.email)> - \(.commit.author.date)", (.commit.message | split("\n"))]'

$ gh api repos/${OWNER}/${REPO}/commits/${REVISION} \
     --jq '[
       "revision: \(.sha)",
       "author: \(.commit.author.name) <\(.commit.author.email)> - \(.commit.author.date)",
       "committer: \(.commit.committer.name) <\(.commit.committer.email)> - \(.commit.committer.date)",
       {message: (.commit.message | split("\n")) }
     ]'
```

### get commit created time
```bash
$ REVISION='xxx'
$ gh api repos/${OWNER}/${REPO}/events \
  --jq ".[] | select(.payload.head | startswith(\"${REVISION}\")?) | [ .actor.login, .created_at ]"

# or with `jq`
$ gh api repos/${OWNER}/${REPO}/events | \
     jq --arg rev "$REVISION" '.[] | select(.payload.head | startswith($rev)?) | [ .actor.login, .created_at ]'
```

### get HEAD of branch

> [!TIP]
> `GET /repos/{owner}/{repo}/git/refs/heads/{branch}`

```bash
# i.e.:
$ gh api "repos/{owner}/{repo}/git/refs/heads/{branch}"

# or
$ gh api "repos/marslo/ibook/git/refs/heads/marslo" | jq -r .object.sha
```

## tags

### list tags

> [!TIP]
> `GET /repos/{owner}/{repo}/git/refs/tags`

```bash
$ gh api "/repos/${OWNER}/${REPO}/git/refs/tags"

# or
$ gh api "/repos/${OWNER}/${REPO}/git/refs/tags" --jq '.[] | .object.sha + " - " + .ref'
```

### add lightweight tags

> [!TIP]
> `POST /repos/{owner}/{repo}/git/refs -f refs=refs/tags/{TAG_NAME} -f sha="<SHASUM>"`

```bash
# tag `refs/tags/<TAG_NAME>` on `${REVISION}`
$ gh api -X POST -H "Accept: application/vnd.github+json" "/repos/${OWNER}/${REPO}/git/refs" \
     -f ref="refs/tags/<TAG_NAME>" \
     -f sha="${REVISION}"
```

## branch protection

> [!NOTE|label:references:]
> - [REST API endpoints for protected branches](https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28)
> - [About protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)

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

# update lock_branch and enforce_admins only, and keep other settings unchanged ( dynamically get keys and values )
$ jq -n --argjson base "$base" --argjson lock "$lock" \
  '
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

## pr

> [!TIP|label:reference:]
> - [gh pr](https://cli.github.com/manual/gh_pr)

### json field mapping

> [!NOTE|label:references:]
> - `gh api` :
>> - template: `template='"#\(.number) - \(.title)\tAuthor: \(.user.login)\nCreated: \(.created_at)\nUpdated: \(.updated_at)\n\n\(.body)"'`
>> - example: `gh api 'repos/:owner/:repo/pulls' | jq -r ".[] | ${template}"` or `gh api repos/${OWNER}/${REPO}/pulls --jq ".[] | ${template}"`
> - `gh pr list --json` :
>> - template: `template=template='"#\(.number) - \(.title)\tAuthor: \(.author.login)\nCreated: \(.createdAt)\nUpdated: \(.updatedAt)\n\n\(.body)"'`
>> - example: `gh pr list -R ${OWNER}/${REPO} --json 'number,title,author,createdAt,updatedAt,body' --jq ".[] | ${template}"`

| `gh api`            | `gh pr list --json` |
|---------------------|---------------------|
| `number`            | `number`            |
| `title`             | `title`             |
| `body`              | `body`              |
| `state`             | `state`             |
| `user.login`        | `author.login`      |
| `created_at`        | `createdAt`         |
| `updated_at`        | `updatedAt`         |
| `closed_at`         | `closedAt`          |
| `merged_at`         | `mergedAt`          |
| `html_url`          | `url`               |
| `head.ref`          | `headRefName`       |
| `base.ref`          | `baseRefName`       |
| `draft`             | `isDraft`           |
| `labels[].name`     | `labels[].name`     |
| `assignees[].login` | `assignees[].login` |

### create pr
```bash
# .. modify files ..

# create branch and push
$ git commit -am '<COMMENTS HERE>'
$ git push origin HEAD:refs/heads/<NEW_BRANCH_NAME>

# create pr via cli
$ gh pr create \
     --base <MAIN_BRANCH> \              # the main branch ( target branch )
     --head <NEW_BRANCH_NAME> \          # the HEAD of pr
     --title "<the title>" \             # the title
     --body "<the body>"
```

### comment on pr

```bash
$ gh pr review <PR_NUMBER> --comment -b "<the comment>"

# i.e.:
$ gh pr review 4 --comment -b "interesting"
```

### edit pr

```bash
$ gh pr edit <PR_NUMBER> --add-label "<LABEL>"
$ gh pr edit <PR_NUMBER> --remove-label "<LABEL>"

# i.e.:
$ gh pr edit 5 --add-label 'sandbox'
```

### merge pr

> [!NOTE|label:options:]
> - merge methods:
>   - `merge`
>   - `squash`
>   - `rebase`
> - `--delete-branch` : delete the head branch after merge
> - `--admin` : merge as admin ( bypassing branch protection rules )

```bash
$ gh pr merge <PR_NUMBER> --<merge_method> --delete-branch

# i.e.:
$ gh pr merge 4 --squash --delete-branch
```

### list pr

> [!NOTE|label:options:]
> - `--state` : open, closed, merged, all
> - `--json` : specify the fields to output in json format
> - `--jq` : filter the json output with jq

```bash
# --limit : number of PR to fetch
$ gh pr list -R ${OWNER}/${REPO} --state merged --limit 30 \
             --json number,title,createdAt,mergedAt \
             --jq '.[] | "PR #\(.number) | createAt: \(.createdAt) | mergeAt \(.mergedAt)"'

# filter by date
$ gh pr list -R ${OWNER}/${REPO} --state merged \
     --json number,title,createdAt,mergedAt \
     --jq '.[] | select(.mergedAt | startswith("2026-02-17")) |
          [
            "PR : #\(.number)",
            "createAt: \(.createdAt)",
            "mergeAt: \(.mergedAt)"
          ] | join("\n")'
     ''

# with more info
$ gh pr list -R ${OWNER}/${REPO} --state merged \
     --json number,title,url,createdAt,mergedAt,author,mergedBy,autoMergeRequest \
     --jq '
          .[] | select( .mergedAt | startswith("2026-02-17") ) |
          [
            "PR        : #\(.number) - \(.title)",
            "URL       : \(.url)",
            "Author    : \(.author.login)",
            "MergedBy  : \(.mergedBy.login // "No Merged")",
            "CreateAt  : \(.createdAt) UTC, \(.createdAt | fromdateiso8601 | localtime | strftime("%Y-%m-%d %H:%M:%S")) PST",
            "MergeAt   : \(.mergedAt) UTC, \(.mergedAt | fromdateiso8601 | localtime | strftime("%Y-%m-%d %H:%M:%S")) PST",
            "AutoMerge : \(.autoMergeRequest.mergeMethod // "Manual")",
            "---"
          ] | join("\n")
     '
```

#### list PR info

```bash
$ gh api repos/${OWNER}/${REPO}/pulls/${PR_NUMBER} \
  --jq '{
    "author": .user.login,
    "mergeBy": ( if .merged_by then .merged_by.login else "No Merged" end ),
    "isAutoMerge": ( if .auto_merge != null then "Yes" else "No" end ),
    "mergeMethod": ( if .auto_merge != null then .auto_merge.merge_method else "manual" end )
  }'

# or
$ gh api repos/${OWNER}/${REPO}/pulls/${PR_NUMBER} \
  --jq '{
    "author": .user.login,
    "mergeBy": (.merged_by.login // "No Merged"),
    "isAutoMerge": (.auto_merge != null),
    "mergeMethod": (.auto_merge.merge_method // "Manual")
  }'
```

### get HEAD of PR

```bash
$ gh pr view ${PR_ID} --json headRefOid -q .headRefOid
```

## issues

> [!NOTE|label:reference:]
> - [gh issue](https://cli.github.com/manual/gh_issue)

### list issues
```bash
$ gh issue list

# view issue
$ gh issue view 1
```

### create issue

> [!NOTE|label:command:]
> - `gh issue create` : create issue via command line
> - `gh issue new` : create issue via command line

```bash
$ gh issue create --title "<the title>" --body "<the body>"
```

### comments on issue
```bash
$ gh issue comment <ISSUE_NUMBER> --body "<the comment>"

# i.e.:
$ gh issue comment 2 --body 'comment from gh as well'
```

## checkers

### list check-runs status

```bash
# list all checker status for PR
$ gh pr checks "${PR_ID}"

# list recent 20 `pre-commit` checker status
$ gh run list --workflow=pre-commit.yml --limit 20

# list `pre-commit` for a specific branch
$ gh run list --workflow=pre-commit.yml --branch "${BRANCH}"
```

### list check-runs history in PR

```bash
# list recent 10 check-runs for a specific branch
$ gh run list --branch "${BRANCH}" --limit 10 --json databaseId,name,status,workflowName

# list query check-runs for a specific PR
$ gh run list --branch "${BRANCH}" --status queued --json databaseId -q '.[].databaseId'
```

### view, cancel or rerun check-runs

```bash
# view
$ gh run view "${RUN_ID}" [--log]
# i.e.:
$ gh run view 33067779843

✓ refs/pull/169459/head CodeQL · 33067779843
Triggered via dynamic about 31 minutes ago

JOBS
✓ Analyze (javascript-typescript) in 1m1s (ID 98502075159)
✓ Analyze (python) in 1m47s (ID 98502075424)

For more information about a job, try: gh run view --job=<job-id>
View this run on GitHub: https://github.com/<OWNER>/<REPO>/actions/runs/33067779843

# cancel
$ gh run cancel "${RUN_ID}"
# force cancel
$ gh api --method POST repos/${OWNER}/${REPO}/actions/runs/${RUN_ID}/force-cancel
# force cancel all queued runs
$ gh run list --branch user/gbhatia/release-calendar-v2 --status queued --json databaseId -q '.[].databaseId' |
  while read id; do
    echo "force-cancelling ${id}"
    gh api --method POST "repos/${OWNER}/${REPO}/actions/runs/${id}/force-cancel"
  done

# rerun
$ gh run rerun "${RUN_ID}"

# jobs status in check-run
$ gh api "repos/${OWNER}/${REPO}/actions/runs/${RUN_ID}/jobs"
```

### force set checker status

```bash
# force set `pre-commit` status to `success` for a PR, in case the ghost run is stuck
$ gh api --method POST \
     "repos/${OWNER}/${REPO}/statuses/$(gh pr view "${PR_ID}" --json headRefOid -q .headRefOid)" \
     -f state=success -f context=pre-commit -f description='manual: stuck ghost run'

# or set via check-runs API - requires `checks:write` permission
$ gh api --method POST \
     "repos/${OWNER}/${REPO}/check-runs" \
     -f name=pre-commit \
     -f head_sha=${PR_HEAD_HASH} \
     -f status=completed \
     -f conclusion=success
```

### get checkers version

```yaml
# workflow/<name>.yml
jobs:
  sync:
    name: <NAME>
    runs-on: ubuntu-latest
    steps:
      - name: checkout source
        uses: actions/checkout@v6               # get version via following command
```

```bash
$ gh api repos/actions/checkout/releases/latest --jq '.tag_name' 2>/dev/null || echo "GH_API_FAILED"
v7.0.1

# uses: actions/setup-python@v<X>
$ gh api repos/actions/setup-python/releases/latest --jq '.tag_name' 2>/dev/null || echo "GH_API_FAILED"
v7.0.0

# uses: actions/setup-node@v<X>
$ gh api repos/actions/setup-node/releases/latest --jq '.tag_name' 2>/dev/null || echo "GH_API_FAILED"
v7.0.0
```

```bash
# check latest version
$ for a in actions/checkout actions/setup-python actions/setup-node actions/cache; do
    latest="$(gh api "repos/$a/releases/latest" --jq '.tag_name + "  (" + .published_at + ")"' 2>/dev/null)"
    printf '%-24s latest=%s\n' "$a" "${latest:-<none>}"
  done
actions/checkout         latest=v7.0.1  (2026-07-20T15:10:05Z)
actions/setup-python     latest=v7.0.0  (2026-07-20T03:15:01Z)
actions/setup-node       latest=v7.0.0  (2026-07-14T02:46:05Z)
actions/cache            latest=v6.1.0  (2026-06-26T19:17:06Z)

# -- check node using version --
# $1=repo  $2=ref
$ check() {
    local using
    using="$(gh api "repos/$1/contents/action.yml?ref=$2" --jq '.content' 2>/dev/null | base64 -d 2>/dev/null | command grep -E '^\s*using:' | head -1 | tr -d ' ')"
    printf '%-24s %-6s -> %s\n' "$1" "$2" "${using:-unknown}"
  }

# for current actions
$ check actions/checkout v6
actions/checkout         v6     -> using:node24
$ check actions/setup-python v6
actions/setup-python     v6     -> using:'node24'
$ check actions/setup-node v6
actions/setup-node       v6     -> using:'node24'
$ check actions/cache v5
actions/cache            v5     -> using:'node24'

# for latest actions
$ check actions/checkout v7
actions/checkout         v7     -> using:node24
$ check actions/setup-python v7
actions/setup-python     v7     -> using:'node24'
$ check actions/setup-node v7
actions/setup-node       v7     -> using:'node24'
$ check actions/cache v6
actions/cache            v6     -> using:'node24'
```



## rulesets

> [!NOTE|label:references:]
> - [About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)
> - [Creating rulesets for a repository](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository)
>   - [github/ruleset-recipes](https://github.com/github/ruleset-recipes)
> - [Troubleshooting rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/troubleshooting-rules)

### list all rulesets

> [!TIP|label:URL]
> the web URL of rulesets: https://github.com/<OWNER>/<REPO>/rules

```bash
$ gh api "repos/${OWNER}/${REPO}/rulesets"

# or: list id and name
$ gh api "repos/${OWNER}/${REPO}/rulesets" | jq -r '.[] | (.id|tostring) + ": " + .name'
7288536: BranchDeleteRule
7288533: BranchNamingRule
7288566: PRRuleSet
```

### list ruleset with keywrods

```bash
$ keyword='ci/verified'
$ for id in $(gh api "repos/${OWNER}/${REPO}/rulesets" --jq '.[].id'); do
>   gh api "repos/${OWNER}/${REPO}/rulesets/${id}" \
>     | jq -r --arg id "${id}" --arg keyword "${keyword}" '
>         if (tostring | contains($keyword)) then
>           ($id|tostring) + ": " + .name
>         else empty end
>       '
> done
11286108: ProtectedBranchesDevelRelease
11286106: ProtectedBranchesMain
11286110: PRReviewRule
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

## tips

### open in web
```bash
$ gh repo view --web
$ gh pr view --web
```

### switch accounts
```bash
# switch to another account
$ gh auth switch

# check current auth status
$ gh auth status
```

### config setup

| KEY                  | DESCRIPTION                                                                         | OPTIONS                   | DEFAULT VALUE  |
|----------------------|-------------------------------------------------------------------------------------|---------------------------|----------------|
| accessible_colors    | Use 4-bit color schemes for better accessibility                                    | enabled, disabled         | disabled       |
| accessible_prompter  | Use an accessibility-friendly prompter for input                                    | enabled, disabled         | disabled       |
| browser              | Web browser to open GitHub URLs                                                     | Browser command           | system default |
| color_labels         | Show labels using their RGB colors in terminals that support truecolor              | enabled, disabled         | disabled       |
| editor               | Text editor to use when authoring commit messages, PR descriptions, etc.            | Path or name of an editor | system default |
| git_protocol         | Protocol to use for Git operations (clone, push, etc.)                              | https, ssh                | https          |
| http_unix_socket     | Path to a Unix socket for making HTTP connections (used in enterprise environments) | Path to socket file       | (unset)        |
| pager                | Pager program to display long command outputs                                       | Name of pager             | system default |
| prefer_editor_prompt | Use the editor instead of inline prompts when asking for input                      | enabled, disabled         | disabled       |
| prompt               | Enable or disable interactive prompts in the terminal                               | enabled, disabled         | enabled        |
| spinner              | Show an animated spinner as a progress indicator                                    | enabled, disabled         | enabled        |

```bash
$ gh config set git_protocol ssh
# or
$ gh config set git_protocol https --host github.com

# setup editor
$ gh config set editor vim
$ gh config set editor nvim
$ gh config set editor "code --wait"

# list config
$ gh config list
git_protocol=ssh
editor=nvim
prompt=enabled
prefer_editor_prompt=disabled
pager=
http_unix_socket=
browser=
color_labels=disabled
accessible_colors=disabled
accessible_prompter=disabled
spinner=enabled
```

### alias

- create alias
  ```bash
  $ gh alias set bugs 'issue list --label="bugs"'
  ```

- list alias
  ```bash
  $ gh alias list
  as: auth switch
  bugs: issue list --label="bugs"
  co: pr checkout
  me: api user --jq ".login"
  merge-clean: '!gh pr merge "$1" --squash --delete-branch'
  myissues: issue list --author "@me" --state open
  open: repo view --web
  propen: pr view --web
  repopath: repo view --json nameWithOwner -q .nameWithOwner
  ```

### list ssh-key
```bash
$ gh ssh-key list
TITLE          ID         KEY                                          TYPE            ADDED
marslo@sample  125897633  ssh-ed25519 AAAAC3Nz...luNwnWMQR+wMad11Dpiw  authentication  about 2 months ago
```
