<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [hooks](#hooks)
- [jenkins](#jenkins)
  - [branch](#branch)
- [actions](#actions)
- [apps](#apps)

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

## actions

> [!NOTE|label:references]
> - [marketplace](https://github.com/marketplace)
> - [First interaction](https://github.com/marketplace/actions/first-interaction)
> - [github-action-auto-format](https://github.com/marketplace/actions/github-action-auto-format)
>   - [cloudposse/github-action-auto-release](https://github.com/cloudposse/github-action-auto-release)
> - [jenkins](https://github.com/marketplace?page=2&q=jenkins&query=jenkins+&type=actions)
>   - [Setup Jenkins](https://github.com/marketplace/actions/setup-jenkins)
>     - [test.yml](https://github.com/snow-actions/setup-jenkins/blob/main/.github/workflows/test.yml)
>     - [jenkins.yaml](https://github.com/snow-actions/setup-jenkins/blob/main/test-resources/jenkins.yaml)
>   - [Jenkins-Action](https://github.com/marketplace/actions/jenkins-action)
>   - [Build Jenkins jobs](https://github.com/marketplace/actions/build-jenkins-jobs)
>   - [Trigger a Jenkins Job](https://github.com/marketplace/actions/trigger-a-jenkins-job)
>   - [TriggerJenkinsBuild](https://github.com/marketplace/actions/triggerjenkinsbuild)
>   - [Run jenkins jobs](https://github.com/marketplace/actions/run-jenkins-jobs)
>   - [GitHub Actions Linting](https://github.com/marketplace/actions/github-actions-linting)
>   - [jenkins-action-parametrized](https://github.com/marketplace/actions/jenkins-action-parametrized)
>   - [Jenkins Job Builder](https://github.com/marketplace/actions/jenkins-job-builder)
>   - [jenkins-job-action](https://github.com/marketplace/actions/jenkins-job-action)
>   - [Trigger Jenkins Job and Return Result](https://github.com/marketplace/actions/trigger-jenkins-job-and-return-result)
>   - [Run Jenkins Job with Build Result](https://github.com/marketplace/actions/run-jenkins-job-with-build-result)
>   - [Run Jenkins Job and get build result](https://github.com/marketplace/actions/run-jenkins-job-and-get-build-result)
>     - [halilsafakkilic/jenkins-action](https://github.com/halilsafakkilic/jenkins-action)
> - git
>   - [Commit Message Checker for pull request](https://github.com/marketplace/actions/commit-message-checker-for-pull-request)
>   - [Check Commit Message](https://github.com/marketplace/actions/check-commit-message)
>   - [Git matching commits](https://github.com/marketplace/actions/git-matching-commits)
>   - [Git matching commits](https://github.com/marketplace/actions/git-matching-commits)
>   - [Commit Message Checker for pull request](https://github.com/marketplace/actions/commit-message-checker-for-pull-request)
>   - [GS Commit Message Checker](https://github.com/marketplace/actions/gs-commit-message-checker)
>   - [Git Commit Data](https://github.com/marketplace/actions/git-commit-data)
>   - [Generate semver](https://github.com/marketplace/actions/generate-semver)
> - [pre-commit](https://github.com/marketplace/actions/pre-commit)
>   - [pre-commit ci](https://pre-commit.ci/)
> - utillity
>   - [Upload a Build Artifact](https://github.com/marketplace/actions/upload-a-build-artifact)
>   - [Download a Build Artifact](https://github.com/marketplace/actions/download-a-build-artifact)
>   - [GitHub API Request](https://github.com/marketplace/actions/github-api-request)
>   - [Checkout](https://github.com/marketplace/actions/checkout)
>   - [Configure GitHub Pages](https://github.com/marketplace/actions/configure-github-pages)
>   - [GitHub API Request](https://github.com/marketplace/actions/github-api-request)
>   - [GitHub Script](https://github.com/marketplace/actions/github-script)
>   - [Git Version](https://github.com/marketplace/actions/git-version)
>   - [Load available actions](https://github.com/marketplace/actions/load-available-actions)
>   - [Secret output](https://github.com/marketplace/actions/secret-output)
>   - [Ansible Publish](https://github.com/marketplace/actions/ansible-publish)
>   - [Jira Add Comment](https://github.com/marketplace/actions/jira-add-comment)
>   - [Setup Jira](https://github.com/marketplace/actions/setup-jira)
>   - [Release-Notes-Preview](https://github.com/marketplace/actions/release-notes-preview)
>   - [Trigger CircleCI Pipeline](https://github.com/marketplace/actions/trigger-circleci-pipeline)
>   - [Deploy Helm to EKS](https://github.com/marketplace/actions/deploy-helm-to-eks)
>   - [Docker Build Tag Publish](https://github.com/marketplace/actions/docker-build-tag-publish)
>   - [Deploy Helm to EKS](https://github.com/marketplace/actions/deploy-helm-to-eks)
>   - [Kubectl tool installer](https://github.com/marketplace/actions/kubectl-tool-installer)
>   - [Kubernetes Set Context](https://github.com/marketplace/actions/kubernetes-set-context)
>   - [Helm tool installer](https://github.com/marketplace/actions/helm-tool-installer)

## apps

> [!NOTE|label:references:]
> - [Slack + GitHub](https://github.com/marketplace/slack-github)
> - [CommitCheck](https://github.com/marketplace/commitcheck)
