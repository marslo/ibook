<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [chat tool](#chat-tool)
- [chatgpt](#chatgpt)
  - [model](#model)
  - [using chatgpt to generate git commits](#using-chatgpt-to-generate-git-commits)
  - [using chatgpt to review git diff](#using-chatgpt-to-review-git-diff)
- [RAG](#rag)

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
