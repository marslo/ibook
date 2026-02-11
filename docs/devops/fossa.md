

## install

> [!NOTE|label:references:]
> - [fossas/fossa-cli](https://github.com/fossas/fossa-cli)

```bash
# macOS or Linux 64
$ curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/fossas/fossa-cli/master/install-latest.sh | bash
```

```bash
# with binary
$ VERSION=$(curl --silent 'https://api.github.com/repos/fossas/fossa-cli/releases/latest' | jq -r .tag_name | sed -nE 's/[^0-9\.]*([0-9\.]+)$/\1/p')
$ FILENAME="fossa_${VERSION}_linux_$(uname -m).zip"
$ curl -fsSL -O "https://github.com/fossas/fossa-cli/releases/download/v${VERSION}/${FILENAME}"
$ sudo unzip -o "${FILENAME}" -d /usr/local/bin
```

## apply CLI token

1. go to **User Settings** -> **Integrations** -> **API** -> **Add New Token**
2. export new token

   ```bash
   $ echo "export FOSSA_API_KEY='a******************************f'" >> ~/.bashrc
   $ source ~/.bashrc
   ```
3. or using variable in command

   ```bash
   $ fossa analyze --fossa-api-key a******************************f
   ```

## CLI

> [!NOTE|label:references:]
> - [CLI Cheat Sheet](https://docs.fossa.com/docs/cli-cheat-sheet)

### scan source code

> [!NOTE|label:references:]
> - [fossa analyze](https://github.com/fossas/fossa-cli/blob/v3.15.5/docs/references/subcommands/analyze.md#fossa-analyze)

```bash
$ cd /path/to/your/source/code
$ fossa analyze

# with json output
$ fossa analyze --json

# or archive contents
$ fossa analyze --unpack-archives
```

### with snippet scan

> [!NOTE|label:references:]
> - [docs/references/subcommands/snippets/analyze.md](https://github.com/fossas/fossa-cli/blob/v3.8.17/docs/references/subcommands/snippets/analyze.md)

```bash
$ fossa analyze --snippet-scan
```

### scan binary

#### binary is built in Linux with `ldd` support

```bash
$ cd /path/to/binary
$ fossa analyze --detect-dynamic
```

#### vendored/archived binary

```bash
$ fossa analyze --detect-vendored
```

### report

> [!NOTE|label:references:]
> - [docs/references/subcommands/report.md](https://github.com/fossas/fossa-cli/blob/master/docs/references/subcommands/report.md)

{% hint style='info' %}
> requires a `Full Access` API token
{% endhint %}

```bash
# to generate cyclonedx report
$ fossa report attribution --format cyclonedx-json
```
