

## setup

### install
```bash
$ python -m pip install --user pipx
$ pipx ensurepath
$ pipx install pre-commit

# or
$ brew install --HEAD pre-commit
```

## run
```bash
# -- all files --
$ pre-commit run --all-files

# -- all files with specific hook --
$ pre-commit run <hook_id> --all-files
# i.e.:
$ pre-commit run trailing-whitespace --all-files
```

## hooks

### copyright manager

> [!NOTE|labels:reference:]
> - [* iMarslo: cr-manager](https://github.com/marslo/cr-manager)

```yaml
# yamllint disable rule:indentation
---
repos:
  - repo: https://github.com/marslo/cr-manager
    rev: v0.0.4
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
    rev: v5.0.0
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

### typos
```yaml
# yamllint disable rule:indentation
---
repos:
  - repo: https://github.com/crate-ci/typos
    rev: v1.31.1
    hooks:
        - id: typos
          name: Typos
          description: Finds and corrects spelling mistakes among source code.
          exclude: \.git
```
