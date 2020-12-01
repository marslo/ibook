<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [command-line auto completion](#command-line-auto-completion)
  - [Linux](#linux)
  - [osx](#osx)
- [others](#others)
- [complete_alias](#complete_alias)
- [get tags from docker hub](#get-tags-from-docker-hub)
  - [simple script for get tags](#simple-script-for-get-tags)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## command-line auto completion
> reference:
> - [Enable Docker command-line auto completion in bash on Centos/Ubuntu](https://ismailyenigul.medium.com/enable-docker-command-line-auto-completion-in-bash-on-centos-ubuntu-5f1ac999a8a6)
> - [completion/bash/docker](https://github.com/docker/docker-ce/blob/master/components/cli/contrib/completion/bash/docker)
> - [Perform tab-completion for aliases in Bash](https://brbsix.github.io/2015/11/23/perform-tab-completion-for-aliases-in-bash/)

### Linux
```bash
$ dpkg -L docker-ce-cli |grep completion
/usr/share/bash-completion
/usr/share/bash-completion/completions
/usr/share/bash-completion/completions/docker
/usr/share/fish/vendor_completions.d
/usr/share/fish/vendor_completions.d/docker.fish
/usr/share/zsh/vendor-completions
/usr/share/zsh/vendor-completions/_docker
```
- rpm
  ```bash
  $ rpm -ql docker-ce | grep completion
  /usr/share/bash-completion/completions/docker
  /usr/share/fish/vendor_completions.d/docker.fish
  /usr/share/zsh/vendor-completions/_docker
  ```

#### setup in bashrc
```bash
source /usr/share/bash-completion/completions/docker
alias d='docker'
alias dp='docker ps'

while read -r _i; do
  complete -F _docker "${_i}"
done < <(alias | grep docker | sed '/^alias /!d;s/^alias //;s/=.*$//')
```

- more info
  ```bash
  $ source /usr/share/bash-completion/completions/docker
  $ type _docker | head
  _docker is a function
  _docker ()
  {
      local previous_extglob_setting=$(shopt -p extglob);
      shopt -s extglob;
  ```

### [osx](https://gist.github.com/rkuzsma/4f8c1354a9ea67fb3ca915b50e131d1c)
```bash
$ la '/Applications/Docker.app/Contents/Resources/etc'
total 332K
-rwxr-xr-x 1 marslo admin 124K Nov  9 21:50 docker.zsh-completion
-rwxr-xr-x 1 marslo admin  51K Nov  9 21:50 docker.fish-completion
-rwxr-xr-x 1 marslo admin 114K Nov  9 21:50 docker.bash-completion
-rw-r--r-- 1 marslo admin  18K Nov  9 21:50 docker-compose.zsh-completion
-rw-r--r-- 1 marslo admin 1.7K Nov  9 21:50 docker-compose.fish-completion
-rwxr-xr-x 1 marslo admin  13K Nov  9 21:50 docker-compose.bash-completion

$ ln -sf '/Applications/Docker.app/Contents/Resources/etc/docker.bash-completion' $(brew --prefix)/etc/bash_completion.d/docker
$ ln -sf '/Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion' $(brew --prefix)/etc/bash_completion.d/docker-compose
```

- setup in bashrc

  {% raw %}
  ```bash
  dockerComp="$(brew --prefix)/etc/bash_completion.d/docker"
  dockerComposeComp="$(brew --prefix)/etc/bash_completion.d/docker-compose"
  [ -f "${dockerComp}" ] && source "${dockerComp}"
  [ -f "${dockerComposeComp}" ] && source "${dockerComposeComp}"

  alias d='docker'
  alias dp='docker ps'
  alias dls='docker ps -l -q'
  alias dps='docker ps -l -a'
  alias di='docker images'
  alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"

  while read -r _i; do
    complete -F _docker "${_i}"
  done < <(alias | grep docker | sed '/^alias /!d;s/^alias //;s/=.*$//')
  ```
  {% endraw %}

## [others](https://stackoverflow.com/a/15859036/2940319)
- `_completion_loader`
  ```bash
  _completion_loader()
  {
    . "/etc/bash_completion.d/$1.sh" >/dev/null 2>&1 && return 124
  }
  complete -D -F _completion_loader
  ```

## [complete_alias](https://github.com/cykerway/complete-alias)
```bash
# for Linux
$ sudo curl -sSLg https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias \
            -o /etc/bash_completion.d/complete_alias

# for osx
$ sudo curl -sSLg https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias \
            -o $(brew --prefix)/etc/bash_completion.d/complete_alias
```

- setup in bash
  ```bash
  source /etc/bash_completion.d/complete_alias
  #
  source $(brew --prefix)/etc/bash_completion.d/complete_alias

  while read -r _i; do
    complete -F _complete_alias "${_i}"
  done < <(alias | grep -E 'docker|kubectl' | sed '/^alias /!d;s/^alias //;s/=.*$//')
  ```

## get tags from docker hub
```bash
$ curl -sS 'https://hub.docker.com/v2/repositories/jenkins/jenkins/tags' \
      | jq --raw-output .results[].name

jdk8-openj9-windowsservercore-1809
jdk11-hotspot-windowsservercore-1809
jdk11-openj9-windowsservercore-1809
windowsservercore-1809
jdk8-hotspot-windowsservercore-1809
2.249.3-lts-centos7
lts-centos7
centos7
2.249.3-lts-centos
lts-centos
```

- [get more](https://forums.docker.com/t/fetching-docker-image-tags-with-created-time-and-digest/85357)
  ```bash
  $ curl -sS 'https://hub.docker.com/v2/repositories/jenkins/jenkins/tags?page_size=100&ordering=last_updated' \
        | jq --raw-output .results[].name
        | sort
  ```
  - or
    ```bash
    $ curl -sS https://hub.docker.com/v2/repositories/jenkins/jenkins/tags?page=2 \
           | jq '."results"[]["name"]' \
           | sort
    ```

### simple script for get tags
```bash
#!/bin/sh
#
# Simple script that will display docker repository tags.
#
# Usage:
#   $ docker-show-repo-tags.sh ubuntu centos

for _r in $* ; do
  curl -s -S "https://registry.hub.docker.com/v2/repositories/library/$_r/tags/" | \
    sed -e 's/,/,\n/g' -e 's/\[/\[\n/g' | \
    grep '"name"' | \
    awk -F\" '{print $4;}' | \
    sort -fu | \
    sed -e "s/^/${_r}:/"
done
```
