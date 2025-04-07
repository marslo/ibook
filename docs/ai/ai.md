<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [chat tool](#chat-tool)
- [chatgpt](#chatgpt)
  - [model](#model)
  - [using chatgpt to generate git commits](#using-chatgpt-to-generate-git-commits)
  - [using chatgpt to review git diff](#using-chatgpt-to-review-git-diff)
- [RAG](#rag)
- [ChatGPT](#chatgpt)
  - [tips](#tips)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [Introduction to Generative AI](https://blog.bytebytego.com/i/149084835/introduction-to-generative-ai)

## chat tool

> [!NOTE|label:references:]
> - [如何在 Chatbox 中接入 SiliconCloud - 超简单完整教程](https://bennhuang.com/posts/chatbox-siliconcloud-integration-guide/)


## chatgpt

### model

| MODEL NAME        | MAX CONTEXT |
|-------------------|-------------|
| gpt-3.5-turbo-16k | 16,384      |
| gpt-4-32k         | 32,768      |
| gpt-4-turbo       | 128,000     |


### using chatgpt to generate git commits

<!--sec data-title="chatgpt.commit.sh" data-id="section0" data-show=true data-collapse=true ces-->
```bash
#!/usr/bin/env bash

set -euo pipefail

model="${COMMITX_MODEL:-gpt-4-1106-preview}"
temperature="${COMMITX_TEMPERATURE:-0.3}"
OPENAI_API_KEY="${OPENAI_API_KEY:? OPENAI_API_KEY not set}"
diff=$(git --no-pager diff --color=never)
prompt="Generate a Git commit message in the Conventional Commits format, with the following structure:

<type>(<scope1,scope2,...>): short summary

- detail 1
- detail 2
- ...

Use multiple scopes if the diff includes changes in multiple areas.
Use markdown-style bullet points for details.
Do not include explanations or code.
Base it on the following diff:

$diff"

declare payload
payload=$(jq -n \
  --arg model "$model" \
  --arg temp "$temperature" \
  --arg prompt "$prompt" \
  '{
    model: $model,
    temperature: ($temp | tonumber),
    messages: [
      { role: "system", content: "You are an assistant that writes Git commit messages." },
      { role: "user", content: $prompt }
    ]
  }')


curl -s https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$payload" |
jq -r '.choices[0].message.content'

# vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh
```
<!--endsec-->

### using chatgpt to review git diff
<!--sec data-title="chatgpt.review.sh" data-id="section1" data-show=true data-collapse=true ces-->
```bash
#!/usr/bin/env bash

set -euo pipefail

MODEL="${COMMITX_MODEL:-gpt-4-turbo}"
TEMPERATURE="${COMMITX_TEMPERATURE:-0.3}"
OPENAI_API_KEY="${OPENAI_API_KEY:? OPENAI_API_KEY not set}"
diff=$(git --no-pager diff --color=never)
prompt="You are a Principal Software Architect reviewing a Git diff.

You may not have the full code context, but please still provide a professional code review.

Focus on:
- What the changes are doing
- Code quality, style, naming, structure
- Potential bugs or anti-patterns
- Suggestions for improvement

Use markdown. Be helpful, concise, and insightful.

--- START DIFF ---
${diff}
--- END DIFF ---"

curl -s https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
    --arg model "$MODEL" \
    --arg temp "$TEMPERATURE" \
    --arg prompt "$prompt" \
    ' {
      model: $model,
      temperature: ($temp | tonumber),
      messages: [
        { role: "system", content: "You are a senior engineer performing code review." },
        { role: "user", content: $prompt }
      ]
    }')" |
jq -r '.choices[0].message.content'

# vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh
```
<!--endsec-->

## RAG

> [!TIP]
> - [RAG - Retrieval-Augmented Generation](https://aws.amazon.com/what-is/retrieval-augmented-generation/)

## ChatGPT

### tips

<!--sec data-title="create package todownload" data-id="section2" data-show=true data-collapse=true ces-->
[see details](https://chatgpt.com/c/67f07846-04f8-8010-bce9-27150bfb1382)

```bash
import os
from pathlib import Path

# Define script contents
table_script = """#!/usr/bin/env bash

# print_table.sh — CLI 表格打印工具，支持列对齐和彩色输出

_strip_ansi() {
  sed 's/\\x1B\\[[0-9;]*[mK]//g'
}

_str_length() {
  echo -e "$1" | _strip_ansi | awk '{ print length }'
}

repeat_char() {
  printf "%*s" "$2" '' | tr ' ' "$1"
}

print_table() {
  local -n _headers=$1
  local -n _rows=$2
  local -n _aligns=$3

  local cols=${#_headers[@]}
  local -a widths

  # 计算每列最大宽度
  for ((i = 0; i < cols; i++)); do
    widths[i]=$(_str_length "${_headers[i]}")
  done

  for row in "${_rows[@]}"; do
    IFS='|' read -r -a fields <<<"$row"
    for ((i = 0; i < cols; i++)); do
      len=$(_str_length "${fields[i]}")
      ((len > widths[i])) && widths[i]=$len
    done
  done

  # 打印分割线
  _print_line() {
    for ((i = 0; i < cols; i++)); do
      printf "+-%s" "$(repeat_char '-' "${widths[i]}")"
    done
    echo "+"
  }

  # 打印一行
  _print_row() {
    local -a fields=("$@")
    for ((i = 0; i < cols; i++)); do
      local raw="${fields[i]}"
      local clean=$(_str_length "$raw")
      local pad=${widths[i]}
      case "${_aligns[i]}" in
        right)
          printf "| %*s " "$pad" "$raw"
          ;;
        center)
          local left=$(( (pad - clean) / 2 ))
          local right=$(( pad - clean - left ))
          printf "| %*s%s%*s " "$left" "" "$raw" "$right" ""
          ;;
        *)
          printf "| %-*s " "$pad" "$raw"
          ;;
      esac
    done
    echo "|"
  }

  # 打印整张表格
  _print_line
  _print_row "${_headers[@]}"
  _print_line
  for row in "${_rows[@]}"; do
    IFS='|' read -r -a fields <<<"$row"
    _print_row "${fields[@]}"
  done
  _print_line
}
"""

# Define output path
output_path = Path("/mnt/data/cli-ui/print_table.sh")
output_path.parent.mkdir(parents=True, exist_ok=True)

# Save script to file
with open(output_path, "w") as f:
    f.write(table_script)

output_path.name
```
<!--endsec-->
