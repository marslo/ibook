

## api

### list repos and permissions

```bash
$ gh repo list <ORG> --limit 10000 --json nameWithOwner,viewerPermission

# list admin only
$ gh repo list <ORG> --limit 10000 --json nameWithOwner,viewerPermission \
     --jq '.[] | select(.viewerPermission=="ADMIN") | .nameWithOwner'

# list all info
$ gh repo list <ORG> --limit 10000 --json nameWithOwner,viewerPermission \
     --jq '.[] | .viewerPermission + "\t" + .nameWithOwner'

# list with perm order
$ gh repo list <ORG> --limit 10000 --json nameWithOwner,viewerPermission \
     --jq 'sort_by([
            -( .viewerPermission as $p | (["READ","TRIAGE","WRITE","MAINTAIN","ADMIN"] | index($p)) ),
            .nameWithOwner
           ])
           | .[]
           | "\(.viewerPermission)\t\(.nameWithOwner)"' |
  column -t
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
