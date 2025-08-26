<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [user](#user)
  - [get username from token](#get-username-from-token)
- [metadata](#metadata)
- [repo](#repo)
- [pull request](#pull-request)
- [commits / branches](#commits--branches)
- [get actions runners](#get-actions-runners)
- [version](#version)
  - [release version](#release-version)
- [others](#others)
  - [emoji](#emoji)
  - [zen](#zen)
  - [octocat](#octocat)
  - [rate limit](#rate-limit)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP]
> - [GitHub REST API documentation](https://docs.github.com/en/rest?apiVersion=2022-11-28)

> [!NOTE|label:headers]
> - `-H "Accept: application/vnd.github.v3+json"`
> - `-H "Authorization: token YOUR_TOKEN"`
> - `-H "Content-Type: application/json"`
> - `-H "Time-Zone: Europe/Amsterdam"`
> - `-H "X-GitHub-Api-Version: 2022-11-28"`

## user
### get username from token
```bash
$ curl -s -H "Authorization: token ghp_v**********************************n" https://api.github.com/user | jq -r .login
username
```


## metadata
```bash
$ curl -sL https://api.github.com/meta | jq -r '.ssh_keys | .[]'
$ curl -sL https://api.github.com/meta | jq -r '.ssh_keys | .[]'  | sed -e 's/^/github.com /' >> ~/.ssh/know_hosts
```

## repo

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

## commits / branches

- get commits

  > [!TIP]
  > `GET /repos/{owner}/{repo}/commits`

  ```bash
  # i.e.:
  $ curl -fsSL https://api.github.com/repos/marslo/ibook/commits
  ```

- post commit status

  > [!TIP]
  > `POST repos/${owner}/${repo}/statuses/${sha}`

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

- get branches

  > [!TIP]
  > `GET /repos/{owner}/{repo}/branches`

  ```bash
  # i.e.:
  $ curl -fsSL https://api.github.com/repos/marslo/ibook/branches
  ```

- get details of a branch

  > [!TIP]
  > `GET /repos/{owner}/{repo}/branches/{branch}`

  ```bash
  # i.e.:
  $ curl -fsSL https://api.github.com/repos/marslo/ibook/branches/main
  ```

## get actions runners

- list workflow runs

  > [!TIP]
  > `GET /repos/{owner}/{repo}/actions/runs`

  ```bash
  # i.e.:
  $ curl -fsSL https://api.github.com/repos/marslo/ibook/actions/runs
  ```

- get workflow run logs

  > [!TIP]
  > `GET /repos/{owner}/{repo}/actions/runs/{run_id}/logs`

  ```bash
  # i.e.:
  $ curl -fsSL https://api.github.com/repos/marslo/ibook/actions/runs/1234567890/logs
  ```

- trigger workflow run

  > [!TIP]
  > `POST /repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches`

  ```bash
  # i.e.:
  $ curl -X POST -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ghp_v**********************************n" \
    https://api.github.com/repos/marslo/ibook/actions/workflows/ci.yml/dispatches \
    -d '{"ref":"main"}'
  ```

## version
### release version
```bash
$ curl --silent 'https://api.github.com/repos/<owner>/<repo>/releases/latest' | jq -r .tag_name

# i.e.:
$ curl --silent 'https://api.github.com/repos/sharkdp/bat/releases/latest' | jq -r .tag_name
```

## others
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
