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

- disable actions workflow
  ```bash
  # disable
  $ gh api -X PUT "repos/${ORG}/${REPO}/actions/permissions" -F enabled=false

  # check status
  $ gh api "repos/${ORG}/${REPO}/actions/permissions" --jq '.enabled'
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
$ gh api repos/{owner}/${REPO}/commits/${sha}

# i.e.:
$ gh api repos/${OWNER}/${REPO}/commits/${sha} \
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
