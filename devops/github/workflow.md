
## variables

| VARIABLE               | WHAT IT IS                | SCOPE                       | HOW TO READ                                          |
|------------------------|---------------------------|-----------------------------|------------------------------------------------------|
| `$GITHUB_ENV`          | Environment-variable file | Later steps (same job)      | `$KEY` / {% raw %}`${{ env.KEY }}`{% endraw %}       |
| `$GITHUB_OUTPUT`       | Step-output file          | Later steps (needs step id) | {% raw %}`${{ steps.<id>.outputs.KEY }}`{% endraw %} |
| `$GITHUB_STEP_SUMMARY` | Markdown summary file     | Shown on the run page       | (not read — display only)                            |
| `$GITHUB_PATH`         | Appends to PATH           | Later steps                 | Run the command directly                             |

## annotation

> [!NOTE]
>
> | BEHAVIOR                         | DETAIL                                                                    |
> |----------------------------------|---------------------------------------------------------------------------|
> | multiline message                | escape newlines as `%0A` (e.g. `line1%0Aline2`)                           |
> | special chars in message         | escape `%`→`%25`, `\r`→`%0D`, `\n`→`%0A`                                  |
> | special chars in property values | also escape `:`→`%3A`, `,`→`%2C`                                          |
> | without file                     | annotation appears at the top of the run summary only                     |
> | with file/line                   | also appears inline on the code in the PR "Files changed" tab             |
> | `::error::` + `exit 1`           | the annotation alone does not fail the job; you still need a non-zero exi |

| COMMAND       | ANNOTATION TYPE    | WHERE IT SHOWS                                    | BASIC SYNTAX                |
|---------------|--------------------|---------------------------------------------------|-----------------------------|
| `::notice::`  | Notice (blue ⓘ)    | Top of run summary + inline on code (if file set) | `echo "::notice::message"`  |
| `::warning::` | Warning (yellow ⚠) | Top of run summary + inline on code               | `echo "::warning::message"` |
| `::error::`   | Error (red ✗)      | Top of run summary + inline on code               | `echo "::error::message"`   |

optional parameters

| PARAMETER   | MEANING                          | EXAMPLE           |
|-------------|----------------------------------|-------------------|
| `title`     | Annotation heading               | `title=Release`   |
| `file`      | File to attach the annotation to | `file=src/app.js` |
| `line`      | Start line in the file           | `line=10`         |
| `endLine`   | End line in the file             | `endLine=15`      |
| `col`       | Start column                     | `col=1`           |
| `endColumn` | End column                       | `endColumn=20`    |

```bash
# simple message
echo "::notice::Deployment finished"

# with a title
echo "::notice title=Release::Released v3.2.0 on main"

# attached to a specific file/line (renders inline in the "files changed" diff)
echo "::warning file=scripts/sample.sh,line=42,col=5::Unquoted variable"

# error with title + file range
echo "::error title=Lint,file=app.js,line=10,endLine=15::Syntax error"
```

## Token and Secret Management

### by default

{% raw %}
```yaml
- name: something ...
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
{% endraw %}

### using a personal access token (PAT)

1. repo → **settings** → **Secrets and variables** → **Actions** → **New repository secret**
2. using in workflow (example):
  {% raw %}
  ```yaml
  - name: deploy binaries to GitHub Release
    uses: softprops/action-gh-release@v2
    with:
      files: |
        dist/mtui-darwin-arm64
        dist/mtui-linux-amd64
        dist/mtui-windows-amd64.exe
    env:
      GITHUB_TOKEN: ${{ secrets.GH_PAT }}
  ```
  {% endraw %}
