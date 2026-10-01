<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [cursor agent](#cursor-agent)
  - [call MCP tool](#call-mcp-tool)
  - [call skills](#call-skills)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## cursor agent

> [!NOTE|label:reference]
> cursor agent CLI can be call as:
> - `agent` or `~/.local/bin/agent`
> - `cursor-agent` or `~/.local/bin/cursor-agent`

```bash
# install cursor agent and login cursor agent
$ curl https://cursor.com/install -fsS | bash
$ agent login

# verify
$ agent -p 'Reply hello'
```

```bash
# create .cursor/mcp.json
# enable and login MCP
$ agent mcp enable Github
$ agent mcp login Github

# verify
$ agent mcp list
Github: ready

# mcp discover
$ agent mcp list-tools Github | head -n1
Tools for Github (41):
```

### call MCP tool

| OUTPUT SOLUTION                                                          | DESCRIPTION                                                                 |
| ------------------------------------------------------------------------ | --------------------------------------------------------------------------- |
| <code>--output json &#124; jq</code>                                     | JSON envelope, where result is an escaped string                            |
| <code>--output-format stream-json &#124; jq </code>                      | JSON envelope, where result is an escaped string, but with streaming output |
| <code>--output-format json &#124; jq -r '.result &#124; fromjson'</code> | Clean inner JSON ✅                                                         |
| `-output-format text`                                                    | LLM raw output (may contain markdown fences and other artifacts)            |

```bash
# call mcp tool
# get json output
$ agent -p 'Call github-get-me and output ONLY the raw JSON result. No prose, no markdown.' --approve-mcps --yolo --output-format json | jq -r '.result | fromjson'

# get raw result
$ agent -p 'Call github-get-me and output the raw result.' --approve-mcps --yolo
```

### call skills

```bash
$ agent -p "/SKILL_NAME help" --force --trust

# with model and stream output
$ agent -p "/SKILL_NAME help" --force --trust --output-format stream-json --stream-partial-output --model claude-opus-4-8-thinking-high
```
