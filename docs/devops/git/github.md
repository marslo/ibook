<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [hooks](#hooks)
- [jenkins](#jenkins)
  - [branch](#branch)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




{% hint style='tip' %}
> references:
> - [Testing webhooks](https://docs.github.com/en/webhooks-and-events/webhooks/testing-webhooks)
> - [GitHub Integration: Webhooks](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/github-webhook-configuration)
>   - [GitHub Webhook: Non-Multibranch Jobs](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/github-webhook-non-multibranch-jobs)
>   - [GitHub Webhook: Pipeline Multibranch](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/github-webhook-pipeline-multibranch)
>   - [GitHub: Webhook Troubleshooting](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/troubleshooting-guides/github-webhook-troubleshooting)
>   - [GitHub: How to configure status checks per Pipeline stage for Pull Requests](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/github-customize-status-checks-for-pull-request)
> - [GitHub Permissions and API token Scopes for Jenkins](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/github-user-scopes-and-organization-permissions-overview)
> - [CloudBees Pull Request Builder for GitHub plugin](https://docs.cloudbees.com/docs/cloudbees-ci/latest/maintaining/pull-request-builder-for-github)
> - [GitHub webhooks](https://www.jetbrains.com/help/upsource/github-webhooks.html#set-up-a-webhook-to-update-pull-requests)
> - [Guide for Troubleshooting GitHub Webhooks](https://hookdeck.com/webhooks/platforms/guide-troubleshooting-github-webhooks#webhook-troubleshootingrequirements-checklist)
> - [How to update Jenkins build status in GitHub pull requests [Step-by-Step Tutorial]](https://applitools.com/blog/how-to-update-jenkins-build-status-in-github-pull-requests-step-by-step-tutorial/)
> - [How to set GitHub commit status with Jenkinsfile NOT using a pull request builder](https://stackoverflow.com/questions/43214730/how-to-set-github-commit-status-with-jenkinsfile-not-using-a-pull-request-builde)
> - [GitHub REST API documentation](https://docs.github.com/en/rest?apiVersion=2022-11-28)
> - workflow && checks:
>   - [Commit Message Checker for pull request](https://github.com/marketplace/actions/commit-message-checker-for-pull-request)
>   - [GS Commit Message Checker](https://github.com/marketplace/actions/gs-commit-message-checker)
>   - [Skipping workflow runs](https://docs.github.com/en/actions/managing-workflow-runs/skipping-workflow-runs)
>   - [* api: Commit statuses](https://docs.github.com/en/rest/commits/statuses?apiVersion=2022-11-28)
> - ci/jenkins:
>   - [How to update Jenkins build status in GitHub pull requests [Step-by-Step Tutorial]](https://applitools.com/blog/how-to-update-jenkins-build-status-in-github-pull-requests-step-by-step-tutorial/)
>   - [How to Use Custom GitHub Checks Using Jenkins Pipeline?!](https://mostafawael.medium.com/github-checks-using-jenkins-pipeline-2d8c594dfba9)
>   - [* Custom GitHub Checks With Jenkins Pipeline](https://medium.com/ni-tech-talk/custom-github-checks-with-jenkins-pipeline-ed1d1c94d99f)
>   - [Show current state of Jenkins build on GitHub repo](https://stackoverflow.com/q/14274293/2940319)
>   - [How to Integrate Your GitHub Repository to Your Jenkins Project](https://www.blazemeter.com/blog/how-to-integrate-your-github-repository-to-your-jenkins-project)
>   - [Jenkins GitHub Integration for CI/CD Pipelines example](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/Jenkins-with-GitHub-Integration-Guide)
>   - [Branches and Pull Requests](https://www.jenkins.io/doc/book/pipeline/multibranch/#supporting-pull-requests)
>   - [kad/JENKINS-28447.workaround.groovy](https://gist.github.com/kad/4a5a8f669d4a4090b43be1f1c5461df3)
>   - [Use setGithubPullRequestStatus as a standalone feature #102](https://github.com/KostyaSha/github-integration-plugin/issues/102)
>   - [Replay in pr-builder pipeline doesn't update GitHub PR status OR restarting a pipeline stage will not update pull request status](https://github.com/jenkinsci/ghprb-plugin/issues/756)
> - sample code:
>   - [* Lonor/kubernetes-springboot-demo](https://github.com/Lonor/kubernetes-springboot-demo/blob/master/Jenkinsfile)
> - plugins:
>   - [GitHubCommitStatusSetter](https://stackoverflow.com/a/51003334/2940319)
>   - [githubPRComment](https://github.com/Lonor/kubernetes-springboot-demo/blob/master/Jenkinsfile)
>   - [GitHub Checks](https://plugins.jenkins.io/github-checks/)
{% endhint %}

## hooks
- in github
  - pull request: `<JENKINS_URL>/github-pull-request-hook/`
  - push `<JENKINS_URL>/github-webhook/`

## jenkins
### branch
- `+refs/pull/*:refs/remotes/origin/pr/*`
- `+refs/heads/*:refs/remotes/origin/*`
