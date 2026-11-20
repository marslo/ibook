<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [setup](#setup)
  - [install pre-commit](#install-pre-commit)
  - [init hook in repo](#init-hook-in-repo)
  - [automatic upgrade to latest version](#automatic-upgrade-to-latest-version)
  - [migrate-config](#migrate-config)
  - [check yaml validation](#check-yaml-validation)
  - [clean and uninstall](#clean-and-uninstall)
- [run](#run)
  - [run with manual stage](#run-with-manual-stage)
- [hooks](#hooks)
  - [copyright manager](#copyright-manager)
  - [checker and fixer](#checker-and-fixer)
  - [convert tab to spaces](#convert-tab-to-spaces)
  - [check-json5](#check-json5)
  - [ruff-pre-commit](#ruff-pre-commit)
  - [typos](#typos)
  - [gitleaks](#gitleaks)
  - [shellcheck](#shellcheck)
  - [conventional-commit-msg](#conventional-commit-msg)
  - [git-identify](#git-identify)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## setup

### install pre-commit
```bash
$ python -m pip install --user pipx && pipx ensurepath
$ pipx install pre-commit

# or
$ brew install --HEAD pre-commit
```

### init hook in repo
```bash
$ pre-commit install

# or
$ pre-commit install --install-hook
pre-commit installed at .git/hooks/pre-commit
```

> [!TIP|labels:with different stages:]
> - references:
>   - [default_install_hook_types](https://pre-commit.com/#top_level-default_install_hook_types) : a list of --hook-types which will be used by default when running `pre-commit install`
>   - [default_stages](https://pre-commit.com/#top_level-default_stages) : a configuration-wide default for the `stages` property of hooks. This will only override individual hooks that do not set `stages`
> - **priority** : `--hook-type` (CLI flag) takes precedence over `default_install_hook_types` (top-level yml config)
>   - The `--hook-type` CLI flag overrides `default_install_hook_types`: when `--hook-type` is given, pre-commit installs exactly those hook types and ignores `default_install_hook_types` entirely
> - `.pre-commit-config.yaml`
>   ```yaml
>   ---
>
>   default_install_hook_types: [pre-commit, commit-msg]
>   default_stages: [pre-commit]
>
>   repos:
>     - repo: https://github.com/crate-ci/typos
>       rev: v1.49.0
>       hooks:
>         - id: typos
>           name: Typos
>           args: ['--write-changes', '--force-exclude']
>         # scan the commit message itself; no --write-changes -> only fail, never rewrite the message
>         - id: typos
>           name: Typos (commit message)
>           alias: typos-commit-msg
>           stages: [commit-msg]
>           args: ['--force-exclude']
>   ```

```bash
$ pre-commit install
pre-commit installed at .git/hooks/pre-commit
pre-commit installed at .git/hooks/commit-msg

# install manually without top level settings
$ pre-commit install --hook-type commit-msg --hook-type pre-commit
```

### automatic upgrade to latest version
```bash
$ pre-commit autoupdate
[https://github.com/pre-commit/pre-commit-hooks] already up to date!
[https://github.com/psf/black] already up to date!

# or
$ pre-commit autoupdate --repo https://github.com/pre-commit/pre-commit-hooks
[https://github.com/pre-commit/pre-commit-hooks] updating v4.6.0 -> v6.0.0
```

### migrate-config

```bash
$ pre-commit migrate-config
```

### check yaml validation

```bash
# validate .pre-commit-config.yaml
$ pre-commit validate-config

# validate .pre-commit-hooks.yaml
$ pre-commit validate-manifest
```

### clean and uninstall

> [!NOTE]
> - default `PRE_COMMIT_HOME` is `~/.cache/pre-commit`

```bash
# clean pre-commit outdated cache
$ pre-commit gc

# clean pre-commit cache and environment ( $PRE_COMMIT_HOME )
$ pre-commit clean

# uninstall pre-commit hook from git repo
$ pre-commit uninstall
```

## run

```bash
# -- all files --
$ pre-commit run --all-files
# or
$ pre-commit run --all-files --show-diff-on-failure --color always

# -- all files with specific hook --
$ pre-commit run <HOOK_ID> --all-files
# i.e.: trailing-whitespace
$ pre-commit run trailing-whitespace --all-files

# -- from ref -> to ref --
$ pre-commit run --show-diff-on-failure --color=always --from-ref "${START_REF}" --to-ref "${END_REF}"

# to check all files under folder recursively
$ pre-commit run --files $(git ls-files folder/path/) -v
$ pre-commit run <HOOK_ID> --files $(git ls-files folder/path/) -v
```


> [!TIP|label:references:]
> - `--hook-stage commit-msg` must be used with `--commit-msg-filename` to specify the commit message file

```bash
# run with commit-msg hook
$ tmp=$(mktemp) && git log -1 --format=%B > "${tmp}"
$ pre-commit run --hook-stage commit-msg --commit-msg-filename "${tmp}"

# run `typos-commit-msg` runner in commit-msg hook stage
$ pre-commit run typos-commit-msg --hook-stage commit-msg --commit-msg-filename "${tmp}"
```

### run with manual stage
```bash
$ cat .pre-commit-config.yaml
...
hooks:
  - id: end-of-file-fixer
    stages: [manual]

$ pre-commit run --hook-stage <stage_name> --all-files
# e.g.:
$ pre-commit run --hook-stage manual --all-files
```

## hooks

> [!NOTE|labels:reference:]
> - [Supported hooks](https://pre-commit.com/hooks.html)
> - sample config
>> ```bash
>> $ pre-commit sample-config
>> # See https://pre-commit.com for more information
>> # See https://pre-commit.com/hooks.html for more hooks
>> repos:
>> -   repo: https://github.com/pre-commit/pre-commit-hooks
>>     rev: v3.2.0
>>     hooks:
>>     -   id: trailing-whitespace
>>     -   id: end-of-file-fixer
>>     -   id: check-yaml
>>     -   id: check-added-large-files
>> ```

### copyright manager

> [!NOTE|labels:reference:]
> - [* iMarslo: cr-manager](https://github.com/marslo/cr-manager)

```yaml
# yamllint disable rule:indentation
---
repos:
  - repo: https://github.com/marslo/cr-manager
    rev: v4.0.0
    hooks:
      - id: update-copyright
        args: ["--update"]
```

### checker and fixer
```yaml
# yamllint disable rule:indentation
---
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v6.0.0
    hooks:
      - id: trailing-whitespace
        name: Trim Trailing Whitespace
      - id: end-of-file-fixer
        name: End Of File Fixer
      - id: check-yaml
        name: Check YAML
        args: ["--unsafe"]
      - id: check-json
        name: Check JSON
      - id: check-merge-conflict
        name: Check Merge Conflict
      - id: check-case-conflict
        name: Check Case Conflict
      - id: mixed-line-ending
        name: Mixed Line Ending
        args: ["--fix=lf"]
```

#### mixed-line-ending

| `--fix` OPTIONS | COMMENTS                         |
|-----------------|----------------------------------|
| `auto`          | auto-detect line-ending          |
| `no`            | no change line-ending            |
| `cr`            | force use `\r`(legacy Mac)       |
| `crlf`          | force use `\r\n`(Windows)        |
| `lf`            | force use `\n`(Unix/Linux/macOS) |

### convert tab to spaces

- `expand` + `sponge`
  ```yaml
  # yamllint disable rule:indentation
  ---
  repos:
    - repo: local
      hooks:
        - id: tab-to-space
          name: Convert Tabs to 2 Spaces
          entry: bash -c 'expand -t 2 "$@" | sponge "$@"' --
          language: system
          types: [text]
          exclude: \.(py|groovy|jenkinsfile/.*)$

        - id: tab-to-4-spaces
          name: Convert Tabs to 4 Spaces
          entry: bash -c 'expand -t 4 "$@" | sponge "$@"' --
          language: system
          files: \.py$

        - id: tab-to-2-spaces
          name: Convert Tabs to 2 Spaces
          entry: bash -c 'expand -t 2 "$@" | sponge "$@"' --
          language: system
          files: (\.groovy$|jenkinsfile/.*)
  ```

- python solution

  <!--sec data-title="tab_converter.py" data-id="section0" data-show=true data-collapse=true ces-->
  ```python
  import argparse
  import fileinput

  def convert_tabs(file_path, spaces):
      with fileinput.FileInput(file_path, inplace=True) as file:
          for line in file:
              print(line.expandtabs(spaces), end='')

  if __name__ == '__main__':
      parser = argparse.ArgumentParser()
      parser.add_argument('--spaces', type=int, required=True)
      parser.add_argument('files', nargs='*')
      args = parser.parse_args()

      for file in args.files:
          convert_tabs(file, args.spaces)
  ```
  <!--endsec-->

  ```yaml
  repos:
    - repo: local
      hooks:
        - id: tab-to-space
          name: Convert Tabs to 2 Spaces [ DEFAULT ]
          entry: python tab_converter.py --spaces 2
          language: system
          types: [text]
          exclude: \.(py|groovy)$
          pass_filenames: true

        - id: tab-to-4-spaces
          name: Convert Tabs to 4 Spaces
          entry: python tab_converter.py --spaces 4
          language: system
          files: \.py$
          pass_filenames: true

        - id: tab-to-2-spaces
          name: Convert Tabs to 2 Spaces
          entry: python tab_converter.py --spaces 2
          language: system
          files: (\.groovy$|jenkinsfile/.*)
          pass_filenames: true
  ```

### check-json5

```yaml
# yamllint disable rule:indentation
---

default_install_hook_types: [pre-commit]
default_stages: [pre-commit]

repos:
  - repo: https://gitlab.com/bmares/check-json5
    rev: v1.0.1
    hooks:
      - id: check-json5
        name: Check JSONC
        files: (?x)(
            .*rc.*\.json|
            .*config.*\.json|
            .*[Ss]ettings.*\.json|
            .*keybindings\.json|
            .*\.code-workspace|
            \.vscode/.*\.json
          )$
```

### ruff-pre-commit

```yaml
# yamllint disable rule:indentation
---

default_install_hook_types: [pre-commit]
default_stages: [pre-commit]

repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.17.5
    hooks:
      - id: ruff-check
        name: Ruff Linter
        args: [--fix]
```

### typos

> [!NOTE|labels:reference:]
> - [docs/pre-commit.md](https://github.com/crate-ci/typos/blob/master/docs/pre-commit.md)

```yaml
# yamllint disable rule:indentation
---

default_install_hook_types: [pre-commit, commit-msg]
default_stages: [pre-commit]

repos:
  - repo: https://github.com/crate-ci/typos
    rev: v1.52.2
    hooks:
      - id: typos
        name: Typos
        args: ['--force-exclude']
      - id: typos
        name: Typos (commit msg)
        alias: typos-commit-msg
        stages: [commit-msg]
        # commit-msg is checked via a temp file outside the repo, where typos cannot auto-discover .typos.toml; point it at the config explicitly.
        args: ['--no-check-filenames', '--force-exclude', '--config', '.typos.toml']
```

### gitleaks

> [!NOTE|labels:reference:]
> - secret detection on staged changes ( PR / repo scans run in gitleaks-pr.yml / gitleaks-repo.yml )
> - ignores global / system git config: custom `log.date` / diff settings make gitleaks scan nothing

```yaml
# yamllint disable rule:indentation
---

default_install_hook_types: [pre-commit]
default_stages: [pre-commit]

repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.30.1
    hooks:
      - id: gitleaks
        name: Gitleaks (staged secrets)
        entry: env GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 gitleaks git --pre-commit --redact --staged --verbose
        stages: [pre-commit]
```

### shellcheck

```yaml
# yamllint disable rule:indentation
---

default_install_hook_types: [pre-commit]
default_stages: [pre-commit]

repos:
  - repo: local
    hooks:
      - id: shellcheck
        name: ShellCheck (bundled)
        language: python
        additional_dependencies: [shellcheck-py]
        entry: shellcheck
        types: [shell]
        args: ["--severity=warning"]
        files: '\.sh$'
```

### conventional-commit-msg

```yaml
# yamllint disable rule:indentation
---

default_install_hook_types: [pre-commit, commit-msg]
default_stages: [pre-commit]

repos:
  - repo: local
    hooks:
      # conventional commit subject; same regex as the GitHub ruleset "Restrict commit metadata" + local fixup!/squash!/amend!
      - id: conventional-commit-msg
        name: 'Conventional Commit (commit msg)'
        language: pygrep
        stages: [commit-msg]
        entry: '\A((feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([A-Za-z0-9._/-]+(, ?[A-Za-z0-9._/-]+)*\))?!?: \S.*|Merge .+|Revert ".+"|(fixup|squash|amend)! .+)'
        args: [--multiline, --negate]
```

### git-identify

```yaml
# yamllint disable rule:indentation
---

default_install_hook_types: [pre-commit]
default_stages: [pre-commit]

repos:
  - repo: local
    hooks:
      # allow commits only from the listed email domains ( catches a stray personal `user.email` in .git/config )
      - id: check-git-identity
        name: 'Git identity (allowed domains)'
        language: script
        entry: scripts/git-identity.sh
        args: [domain.com]
        pass_filenames: false
        always_run: true
        stages: [pre-commit]
```

```bash
#!/usr/bin/env bash

# scripts/git-identity.sh
# allow a commit only when the author and committer emails are on an allowed domain ( pre-commit hook )
#   usage : check-git-identity.sh [ <domain>... ]      # default: domain.com; exact domain match, case-insensitive
#   e.g.  : check-git-identity.sh domain.com           # user@domain.com ✓  user@gmail.com ✗  user@domain.com.cn ✗
#   skips : CI runs ( `CI` set ), where the runner has no user identity
#   note  : reads the identity git will use ( `git var` → env + config ); a one-off `git commit --author=…` is not seen

set -euo pipefail

declare -a ALLOWED=( "${@}" )
(( ${#ALLOWED[@]} )) || ALLOWED=( 'domain.com' )
declare -ra ALLOWED

test -n "${CI:-}" && exit 0

# true if <email> ends with `@<domain>` for one of ALLOWED ( case-insensitive )
function isAllowed() {
  local email="${1,,}" domain
  for domain in "${ALLOWED[@]}"; do
    test "${email}" != "${email%@"${domain,,}"}" && return 0
  done
  return 1
}

declare rc=0 kind ident email
for kind in AUTHOR COMMITTER; do
  ident="$( git var "GIT_${kind}_IDENT" )"
  email="${ident#*<}"; email="${email%%>*}"
  if ! isAllowed "${email}"; then
    echo "error: ${kind,,} email '${email}' is not allowed in this repo ( allowed: ${ALLOWED[*]/#/@} )" >&2
    rc=1
  fi
done

if test 0 -ne "${rc}"; then
  echo 'hint: identity comes from:' >&2
  git config --show-origin --get-regexp '^user\.(name|email)$' >&2 || true
  env | command grep -E '^GIT_(AUTHOR|COMMITTER)_(NAME|EMAIL)=' >&2 || true
  echo 'hint: drop a local override with: git config --local --unset user.email; git config --local --unset user.name' >&2
fi
exit "${rc}"
```
