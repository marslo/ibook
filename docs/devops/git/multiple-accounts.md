<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [with ssh](#with-ssh)
  - [gitconfig](#gitconfig)
  - [ssh config](#ssh-config)
- [with https](#with-https)
  - [gitconfig](#gitconfig-1)
  - [setup .git-credentials](#setup-git-credentials)
- [git hook and alias](#git-hook-and-alias)
  - [git hook](#git-hook)
  - [git alias](#git-alias)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


> [!TIP|label: Multiple Accounts]
>
> | TYPE            | ACCOUNTS | EMAIL               | SSH KEY                   | GITHUB REPOS RANGE         |
> |-----------------|----------|---------------------|---------------------------|----------------------------|
> | work            | John Doe | `john@work.com`     | `~/.ssh/work_ed25519`     | `git@github.com:work/*`    |
> | service account | jenkins  | `jenkins@work.com`  | `~/.ssh/jenkins_ed25519`  | `git@github.com:company/*` |
> | personal        | John Doe | `john@personal.com` | `~/.ssh/personal_ed25519` | `git@github.com:john/*`    |
>
> - `~/.gitconfig.d/accounts/<account>` is used to distinguish **accounts** and **emails**
> - `~/.gitconfig.d/.gitconfig` is used to distinguish the **git remote URLs** by `includeIf hasconfig:remote.*.url`
> - `~/.ssh/config.d/github` is used to distinguish the ssh key by host-alias


> [!NOTE]
> - to check git the git clone debug log via:
>> ```bash
>> GIT_TRACE=true GIT_CURL_VERBOSE=true GIT_TRACE_PACK_ACCESS=true GIT_TRACE_SETUP=true GIT_TRACE_SHALLOW=true \
>> git clone <repo-url>
>> ```
> - check more details in [* iMarslo - troubleshooting](./troubleshooting.md#git-debug-options)

## with ssh

### gitconfig

{% codegroup rememberTabs=true, defaultTabName="Snippet" %}
```work
# ~/.gitconfig.d/accounts/work
[user]
    name  = John Doe
    email = john@work.com
```

```jenkins
# ~/.gitconfig.d/accounts/jenkins
[user]
    name  = jenkins
    email = jenkins@work.com
```

```personal
# ~/.gitconfig.d/accounts/personal
[user]
    name  = John Doe
    email = john@personal.com
```
{% endcodegroup %}

{% codegroup rememberTabs=true, defaultTabName="~/.gitconfig.d/.gitconfig" %}
```
## -- work -- ##
[url "git@github-work.com:work/"]
  insteadOf         = git@github.com:work/
[includeIf "hasconfig:remote.*.url:*github.com?work/**"]
  path              = ~/.gitconfig.d/accounts/work

## -- service account -- ##
[url "git@github-jenkins.com:company/"]
  insteadOf         = git@github.com:company/
[includeIf "hasconfig:remote.*.url:*github.com?company/**"]
  path              = ~/.gitconfig.d/accounts/jenkins

## -- work -- ##
[url "git@github-personal.com:john/"]
  insteadOf         = git@github.com:john/
[includeIf "hasconfig:remote.*.url:*github.com?john/**"]
  path              = ~/.gitconfig.d/accounts/personal
```
{% endcodegroup %}

{% codegroup rememberTabs=true, defaultTabName="~/.gitconfig" %}
```
# OPTION - force using ssh for github
[url "git@github.com:"]
  insteadOf         = https://github.com/

[include]
  path              = ~/.gitconfig.d/.gitconfig
```
{% endcodegroup %}

### ssh config

- `~/.ssh/config.d/github`

  > [!TIP]
  > the HOST name alias should matches to the URL in gitconfig

  {% codegroup rememberTabs=true, defaultTabName="~/.ssh/config.d/github" %}
  ```
  HOST github-work.com
       HostName       github.com
       User           git
       IdentityFile   ~/.ssh/work_ed25519
       IdentitiesOnly yes

  HOST github-jenkins.com
       HostName       github.com
       User           git
       IdentityFile   ~/.ssh/jenkins_ed25519
       IdentitiesOnly yes

  HOST github-personal.com
       HostName       github.com
       User           git
       IdentityFile   ~/.ssh/personal_ed25519
       IdentitiesOnly yes
  ```
  {% endcodegroup %}

- `~/.ssh/config`

  > [!TIP]
  > - put the include in the beginning of the `~/.ssh/config` file

  {% codegroup rememberTabs=true, defaultTabName="~/.ssh/config" %}
  ```
  Include config.d/github

  # the rest of your ssh config #
  ```
  {% endcodegroup %}

## with https

> [!NOTE]
> - prepare PAT for 3 accounts in [Personal Access Tokens (classic)](https://github.com/settings/tokens) or [Fine-grained personal access tokens](https://github.com/settings/personal-access-tokens)

| TOKEN TYPE           | GIT OPERATIONS<br>(`clone/push`) | GIT LFS UPLOAD/DOWNLOAD                       | GITHUB ACTIONS (WORKFLOW) | `semantic-release` | GITHUB API (REST/GRAPHQL) | PRIVATE SUBMODULES | GITHUB CLI (`GH`)         | NOTES                                                                   |
|----------------------|----------------------------------|-----------------------------------------------|---------------------------|--------------------|---------------------------|--------------------|---------------------------|-------------------------------------------------------------------------|
| **Fine-grained PAT** | ✓                                | ✗<br>**Fails** (LFS lock verification denied) | ✓                         | ✓                  | ✓                         | ✗                  | ⚠️<br>Partially supported | Secure and scoped, but limited in CLI/automation contexts like Git LFS  |
| **Classic PAT**      | ✓                                | ✓                                             | ✓                         | ✓                  | ✓                         | ✓                  | ✓                         | Recommended for CLI tools, LFS, CI/CD, automation, and broad API access |

### gitconfig

{% codegroup rememberTabs=true, defaultTabName="~/.gitconfig.d/.gitconfig" %}
```
[credential "https://github.com/work"]
  username          = john@work.com
[credential "https://github.com/company"]
  username          = jenkins@work.com
[credential "https://github.com/john"]
  username          = john@personal.com
```
{% endcodegroup %}

{% codegroup rememberTabs=true, defaultTabName="~/.gitconfig" %}
```
# OPTION - force using https for github
[url "https://github.com/"]
  insteadOf         = git@github.com:

[include]
  path              = ~/.gitconfig.d/.gitconfig

[credential]
  helper            = store --file ~/.gitconfig.d/.git-credentials
```
{% endcodegroup %}

### setup .git-credentials
```bash
$ echo -e "protocol=https\nhost=github.com\nusername=john@work.com\npassword=${PAT_WORK}\n" |
      git credential-store --file ~/.gitconfig.d/.git-credentials store
$ echo -e "protocol=https\nhost=github.com\nusername=jenkins@work.com\npassword=${PAT_JENKINS}\n" |
      git credential-store --file ~/.gitconfig.d/.git-credentials store
$ echo -e "protocol=https\nhost=github.com\nusername=john@personal.com\npassword=${PAT_PERSONAL}\n" |
      git credential-store --file ~/.gitconfig.d/.git-credentials store
```

```bash
# to verify/check the credentials

# to check in macOS Keychain
$ printf "protocol=https\nhost=github.com\nusername=john@work.com\n" | git credential-osxkeychain get

# to check in git-credentials file
$ printf "protocol=https\nhost=github.com\nusername=john@work.com\n" | git credential-store --file ~/.gitconfig.d/.git-credentials get
```

## git hook and alias

> [!NOTE]
> - setup the `~/.git-template` directory as the template directory for git

```bash
$ mkdir -p ~/.git-templates/hooks
$ git config --global init.templatedir '~/.git-templates'

$ touch ~/.git-templates/hooks/post-checkout ~/.git-templates/set-git-user.sh
$ chmod +x ~/.git-templates/hooks/post-checkout ~/.git-templates/set-git-user.sh
```

> [!TIP]
> `~/.git-templates/set-git-user.sh` will be using for both `post-checkout` hook and git alias

```bash
#!/usr/bin/env bash
#=============================================================================
#     FileName : ~/.git-template/set-git-user.sh
#       Author : marslo.jiao@gmail.com
#      Created : 2025-06-30 21:54:24
#   LastChange : 2025-07-01 00:16:22
#=============================================================================

set -euo pipefail

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  echo "fatal: not a git repository (or any of the parent directories): .git" >&2
  exit 128
}

# shellcheck disable=SC2155
declare -r REMOTE_URL=$( git remote get-url origin 2>/dev/null || git config --get remote.origin.url 2>/dev/null )
[[ -z "${REMOTE_URL}" ]] && { echo "fatal: no remote repository configured for 'origin'" >&2; exit 0; }

declare username=''
declare email=''

case "${REMOTE_URL}" in
  *github.com?work/*    | *git@github-work.com:*     )
    username='John Doe'; email='john@work.com'     ;;
  *github.com?company/* | *git@github-jenkins.com:*  )
    username='jenkins' ; email='jenkins@work.com'  ;;
  *github.com?john/*    | *git@github-personal.com:* )
    username='John Doe'; email='john@personal.com' ;;
esac

# shellcheck disable=SC2015
[[ -n "${username}" && -n "${email}" ]] && {
  git config user.name  "${username}"
  git config user.email "${email}"
  printf "\033[0;2;3;37m>> git user set to: \033[0;3;33m%s \033[0;2;3;37m<\033[0;3;36m%s\033[0;2;3;37m>\033[0m\n" "${username}" "${email}"
} || {
  printf "\033[0;2;3;37m>> git user not set, using default \033[0;3;33m%s \033[0;2;3;37m<\033[0;3;36m%s\033[0;2;3;37m>\033[0m\n" "$(git config user.name)" "$(git config user.email)"
}

# vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh:
```

### git hook

> [!TIP]
> - the `post-checkout` hook will be triggered after a `git checkout` command. it will set the git user name and email based on the remote URL **automatically**
> - verify by:
>> ```bash
>> # clone a repo
>> $ git clone git@github.com:work/repo.git
>>
>> # verify
>> $ git config --local user.name
>> $ git config --local user.email
>> ```

```bash
#!/usr/bin/env bash
# ~/.git-templates/hooks/post-checkout

if [[ "$1" = "0000000000000000000000000000000000000000" || "$3" = '1' ]]; then
  ~/.git-templates/set-git-user.sh
fi

# vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh:
```

### git alias

```bash
$ git config --global alias.set-user '!~/.git-templates/set-git-user.sh'

# verify
$ cd /path/to/your/repo
$ git set-user
```

<!---
vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=markdown:foldmethod=indent:
-->
