<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [install](#install)
  - [auto completion](#auto-completion)
- [authentication](#authentication)
  - [authentication scopes](#authentication-scopes)
- [pr](#pr)
  - [create pr](#create-pr)
  - [comment on pr](#comment-on-pr)
  - [edit pr](#edit-pr)
  - [merge pr](#merge-pr)
- [issues](#issues)
  - [list issues](#list-issues)
  - [create issue](#create-issue)
  - [add comments](#add-comments)
- [api](#api)
  - [list repos and permissions](#list-repos-and-permissions)
  - [get HEAD of branch](#get-head-of-branch)
- [tips](#tips)
  - [open in web](#open-in-web)
  - [switch accounts](#switch-accounts)
  - [config setup](#config-setup)
  - [alias](#alias)
  - [list ssh-key](#list-ssh-key)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:reference:]
> - [gh](https://cli.github.com/manual/gh)

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

## pr

> [!TIP|label:reference:]
> - [gh pr](https://cli.github.com/manual/gh_pr)

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

### add comments
```bash
$ gh issue comment <ISSUE_NUMBER> --body "<the comment>"

# i.e.:
$ gh issue comment 2 --body 'comment from gh as well'
```

## api

> [!NOTE|label:reference:]
> - [gh api](https://cli.github.com/manual/gh_api)

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
