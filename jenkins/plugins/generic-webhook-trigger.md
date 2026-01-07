<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [job configuration](#job-configuration)
  - [post content parameters](#post-content-parameters)
  - [cause](#cause)
  - [optional filter](#optional-filter)
- [github webhook settings](#github-webhook-settings)
  - [trigger conditions](#trigger-conditions)
- [manual verify](#manual-verify)
  - [check ping status](#check-ping-status)
  - [trigger pipeline](#trigger-pipeline)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## job configuration
### post content parameters

| NAME OR VARIABLE    | EXPRESSION                      | JSONPath |
|---------------------|---------------------------------|:--------:|
| PAYLOAD             | `$`                             |     ✓    |
| PR_API_URL          | `$.issue.pull_request.url`      |     ✓    |
| PR_COMMENT_BODY     | `$.comment.body`                |     ✓    |
| PR_COMMENT_HTML_URL | `$.comment.html_url`            |     ✓    |
| PR_COMMENT_USER     | `$.comment.user.login`          |     ✓    |
| PR_EVENT_ACTION     | `$.action`                      |     ✓    |
| PR_HTML_URL         | `$.issue.pull_request.html_url` |     ✓    |
| PR_NUMBER           | `$.issue.number`                |     ✓    |
| PR_REPOSITORY_NAME  | `$.repository.name`             |     ✓    |

### cause

```bash
[#$PR_NUMBER] triggered via $PR_EVENT_ACTION comments by @$PR_COMMENT_USER - `$PR_COMMENT_BODY`
```

### optional filter

- Expression: `(?i)^sandbox-jenkins-integration\b.*\b(recheck|rerun|retry|retrigger|reverify|verify)\b`
- Text: `$PR_REPOSITORY_NAME $PR_COMMENT_BODY`

## github webhook settings
### trigger conditions

| CONDITION                    | DESCRIPTION                                                                                                                                                                                                                                                                                        |
|------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Commit comments              | commit or diff commented on.                                                                                                                                                                                                                                                                       |
| Discussion comments          | discussion comment created, edited, or deleted.                                                                                                                                                                                                                                                    |
| Issue comments               | issue comment created, edited, or deleted.                                                                                                                                                                                                                                                         |
| Pull request review comments | pull request diff comment created, edited, or deleted.                                                                                                                                                                                                                                             |
| Pull request review threads  | a pull request review thread was resolved or unresolved.                                                                                                                                                                                                                                           |
| Pull request reviews         | pull request review submitted, edited, or dismissed.                                                                                                                                                                                                                                               |
| Pull requests                | pull request assigned, auto merge disabled, auto merge enabled, closed, converted to draft, demilestoned, dequeued, edited, enqueued, labeled, locked, milestoned, opened, ready for review, reopened, review request removed, review requested, synchronized, unassigned, unlabeled, or unlocked. |
| Pushes                       | git push to a repository.                                                                                                                                                                                                                                                                          |

## manual verify
### check ping status

> [!TIP|label:with or without token]
> - with token: `https://jenkins.domain.com/generic-webhook-trigger/invoke?token=ghe-pr-hook`
> - without token: `https://jenkins.domain.com/generic-webhook-trigger/invoke`

```bash
$ curl -i -X POST \
  -H 'Content-Type: application/json' \
  --data '{"ping":"pong"}' \
  'https://jenkins.domain.com/generic-webhook-trigger/invoke?token=ghe-pr-hook'
HTTP/2 200
content-type: application/json;charset=utf-8
date: Tue, 06 Jan 2026 08:39:47 GMT
server: Jetty(12.0.25)
vary: Accept-Encoding
vary: Accept-Encoding
x-content-type-options: nosniff
content-length: 420

{"jobs":{"marslo/ghe/sandbox":{"regexpFilterExpression":"(?i)^sandbox\\b.*\\b(recheck|rerun|retry|retrigger|reverify|verify)\\b","triggered":false,"resolvedVariables":{"COMMENT_BODY":"","EVENT_ACTION":"","PAYLOAD":"{\"ping\":\"pong\"}","PAYLOAD_ping":"pong","PR_API_URL":"","PR_NUMBER":"","REPOSITORY_NAME":""},"regexpFilterText":" ","id":0,"url":""}},"message":"Triggered jobs."}
```

### trigger pipeline

```bash
$ curl -i -X POST \
  -H 'Content-Type: application/json' \
  --data '{
    "action": "created",
    "repository": { "name": "sandbox" },
    "comment": { "body": "retrigger" },
    "issue": {
      "number": 123,
      "pull_request": { "url": "https://api.github.com/repos/x/y/pulls/123" }
    }
  }' \
  'https://jenkins.domain.com/generic-webhook-trigger/invoke'
HTTP/2 200
content-type: application/json;charset=utf-8
date: Tue, 06 Jan 2026 08:42:05 GMT
server: Jetty(12.0.25)
vary: Accept-Encoding
vary: Accept-Encoding
x-content-type-options: nosniff
content-length: 1031

{"jobs":{"marslo/ghe/sandbox":{"regexpFilterExpression":"(?i)^sandbox\\b.*\\b(recheck|rerun|retry|retrigger|reverify|verify)\\b","triggered":true,"resolvedVariables":{"COMMENT_BODY":"retrigger","EVENT_ACTION":"created","PAYLOAD":"{\n    \"action\": \"created\",\n    \"repository\": { \"name\": \"sandbox\" },\n    \"comment\": { \"body\": \"retrigger\" },\n    \"issue\": {\n      \"number\": 123,\n      \"pull_request\": { \"url\": \"https://api.github.com/repos/x/y/pulls/123\" }\n    }\n  }","PAYLOAD_action":"created","PAYLOAD_comment_body":"retrigger","PAYLOAD_issue_number":"123","PAYLOAD_issue_pull_request_url":"https://api.github.com/repos/x/y/pulls/123","PAYLOAD_repository_name":"sandbox","PR_API_URL":"https://api.github.com/repos/x/y/pulls/123","PR_NUMBER":"123","REPOSITORY_NAME":"sandbox"},"regexpFilterText":"sandbox retrigger","id":9049,"url":"queue/item/9049/"}},"message":"Triggered jobs."}
```
