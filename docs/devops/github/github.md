<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [workflow && checkers](#workflow--checkers)
- [hooks](#hooks)
- [jenkins](#jenkins)
  - [branch](#branch)
- [actions](#actions)
- [apps](#apps)
- [gpg commit signature](#gpg-commit-signature)
  - [generate gpg key pair](#generate-gpg-key-pair)
  - [get gpg public key](#get-gpg-public-key)
  - [local git config](#local-git-config)
  - [verify](#verify)
  - [tips](#tips)

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
> - [* Building Git Pull Requests with Jenkins](https://www.djaodjin.com/blog/jenkins-build-pull-requests.blog.html)
> - sample code:
>   - [* Lonor/kubernetes-springboot-demo](https://github.com/Lonor/kubernetes-springboot-demo/blob/master/Jenkinsfile)
{% endhint %}

## workflow && checkers

> [!NOTE|label:workflow && checkers]
> - [Automating Docker Workflows with GitHub Actions: A 60% Boost in Deployment Speed!](https://vaibhav342.hashnode.dev/automating-docker-workflows-with-github-actions-a-60-boost-in-deployment-speed)
> - [Commit Message Checker for pull request](https://github.com/marketplace/actions/commit-message-checker-for-pull-request)
> - [GS Commit Message Checker](https://github.com/marketplace/actions/gs-commit-message-checker)
> - [Skipping workflow runs](https://docs.github.com/en/actions/managing-workflow-runs/skipping-workflow-runs)
> - [* api: Commit statuses](https://docs.github.com/en/rest/commits/statuses?apiVersion=2022-11-28)
> - [Awesome GitHub Action Workflows](https://dev.to/tungbq/awesome-github-action-workflows-2fi0)
> - [* Use cases and examples](https://docs.github.com/en/actions/use-cases-and-examples)
> - [* Writing workflows](https://docs.github.com/en/actions/writing-workflows)
> - [* sdras/awesome-actions](https://github.com/sdras/awesome-actions)

- ci/jenkins:

  > [!NOTE|label:ci/jenkins:]
  > - [How to update Jenkins build status in GitHub pull requests [Step-by-Step Tutorial]](https://applitools.com/blog/how-to-update-jenkins-build-status-in-github-pull-requests-step-by-step-tutorial/)
  > - [How to Use Custom GitHub Checks Using Jenkins Pipeline?!](https://mostafawael.medium.com/github-checks-using-jenkins-pipeline-2d8c594dfba9)
  > - [* Custom GitHub Checks With Jenkins Pipeline](https://medium.com/ni-tech-talk/custom-github-checks-with-jenkins-pipeline-ed1d1c94d99f)
  > - [Show current state of Jenkins build on GitHub repo](https://stackoverflow.com/q/14274293/2940319)
  > - [How to Integrate Your GitHub Repository to Your Jenkins Project](https://www.blazemeter.com/blog/how-to-integrate-your-github-repository-to-your-jenkins-project)
  > - [Jenkins GitHub Integration for CI/CD Pipelines example](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/Jenkins-with-GitHub-Integration-Guide)
  > - [Branches and Pull Requests](https://www.jenkins.io/doc/book/pipeline/multibranch/#supporting-pull-requests)
  > - [kad/JENKINS-28447.workaround.groovy](https://gist.github.com/kad/4a5a8f669d4a4090b43be1f1c5461df3)
  > - [Use setGithubPullRequestStatus as a standalone feature #102](https://github.com/KostyaSha/github-integration-plugin/issues/102)
  > - [Replay in pr-builder pipeline doesn't update GitHub PR status OR restarting a pipeline stage will not update pull request status](https://github.com/jenkinsci/ghprb-plugin/issues/756)

- plugins:

  > [!NOTE|label:plugins:]
  > - [GitHubCommitStatusSetter](https://stackoverflow.com/a/51003334/2940319)
  > - [githubPRComment](https://github.com/Lonor/kubernetes-springboot-demo/blob/master/Jenkinsfile)
  > - [GitHub Checks](https://plugins.jenkins.io/github-checks/)

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
> -references:
>   - [Advanced CI/CD Pipeline Optimization Techniques Using GitHub Actions](https://dzone.com/articles/advanced-cicd-pipeline-optimization-techniques)
>   - [GitHub Actions vs. Jenkins](https://dev.to/spacelift/github-actions-vs-jenkins-41i4)
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
> - utility
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


## gpg commit signature

> [!NOTE|label:references:]
> - [Managing commit signature verification](https://docs.github.com/en/authentication/managing-commit-signature-verification)

### generate gpg key pair

> [!NOTE|label:references:]
> `(9) ECC (sign and encrypt)` + `(1) Curve 25519` means:
>  - `ed25519` for signing
>  - `cv25519` for encryption

```bash
$ gpg --full-generate-key
gpg (GnuPG) 2.4.9; Copyright (C) 2025 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (sign only)
  (14) Existing key from card
Your selection? 9
Please select which elliptic curve you want:
   (1) Curve 25519 *default*
   (4) NIST P-384
   (6) Brainpool P-256
Your selection? 1
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 0
Key does not expire at all
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.

Real name: marslo
Email address: marslo@domain.com
Comment:
You selected this USER-ID:
    "marslo <marslo@domain.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: directory '/Users/marslo/.gnupg/openpgp-revocs.d' created
gpg: revocation certificate stored as '/Users/marslo/.gnupg/openpgp-revocs.d/5**************************************3.rev'
public and secret key created and signed.

pub   ed25519 2026-02-11 [SC]
      5**************************************3
uid                      marslo <marslo@domain.com>
sub   cv25519 2026-02-11 [E]
```

### get gpg public key

```bash
# export
$ gpg --armor --export marslo@domain.com

# or via keyid
$ KEY_ID="$(gpg --list-secret-keys --with-colons marslo@domain.com | awk -F: '/^sec/ {print $5}')"
$ KEY_ID="$(gpg --list-secret-keys --keyid-format LONG marslo@domain.com | sed -rn 's|^sec[^/]+ed25519/([^ ]+) .+]$|\1|p')"
$ gpg --armor --export ${KEY_ID}
-----BEGIN PGP PUBLIC KEY BLOCK-----

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxx
-----END PGP PUBLIC KEY BLOCK-----
```

And copy the output into Github:
1. Go to `Settings` -> `SSH and GPG keys` -> `New GPG key`
2. Paste the public key into the `Key` field and click `Add GPG key`

### local git config

> [!TIP|label:references:]
> - this configuration is sign with gpg key what particular repos with particular account automatically
> - this mostly used when you have multiple accounts and want to sign commit with different gpg key for different account

```git
# ~/.gitconfig
[include]
  path              = ~/.marslo/gitconfig.d/account
```

```git
# ~/.marslo/gitconfig.d/account
[includeIf "hasconfig:remote.*.url:*com?marslo_ghe/**"]
  path              = ~/.marslo/gitconfig.d/accounts/marslo_ghe
[includeIf "gitdir/i:~/code/github/**"]
  path              = ~/.marslo/gitconfig.d/accounts/marslo_ghe
```

> [!NOTE|label:references:]
> ```bash
> $ git help config
>   gpg.format
>       Specifies which key format to use when signing with --gpg-sign. Default is "openpgp". Other possible
>       values are "x509", "ssh".
> ```
> - [Telling Git about your GPG key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-gpg-key)
> - [Telling Git about your SSH key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-ssh-key)
> - [Telling Git about your X.509 key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-x509-key-1)

```git
# ~/.marslo/gitconfig.d/accounts/marslo_ghe
[user]
  name       = marslo
  email      = marslo@domain.com
  # signingkey => "${KEY_ID}"
  signingkey = 7**************3

[commit]
    gpgsign  = true

[tag]
    gpgsign  = true
```

### verify
```bash
$ git me
marslo <marslo@domain.com>     # accounts/marslo_ghe [G]

$ git config user.signingkey
7**************3

$ git config commit.gpgsign
true

# create code change and commit
$ git show --show-signature -s
commit 09daeb35ddb7a78f395c0e2a323b300d7c565fce (origin/devel, origin/HEAD)
gpg: Signature made Tue Feb 10 16:19:41 2026 PST
gpg:                using EDDSA key 5**************************************3
gpg: Good signature from "marslo <marslo@domain.com>" [ultimate]
Author: marslo <marslo@domain.com>
Date:   2026-02-10 16:19:41 -0800 Tuesday

    test: verify gpg sign key

    Signed-off-by: marslo <marslo@domain.com>
```

### tips

- show signature in git log
  ```bash
  $ git config --global log.showSignature true
  ```

- list GPG public key via API/CLI via Github
  ```bash
  # API
  $ curl -sL -u marslo_ghe:$GITHUB_API_TOKEN https://api.github.com/users/marslo_ghe/gpg_keys |
    jq -r '.[] | .key_id + "\n" + .raw_key'
  # -- or authentication with gh CLI --
  $ curl -H "Authorization: Bearer $(gh auth token)" \
         -sL https://api.github.com/users/marslo_ghe/gpg_keys |
    jq -r '.[] | .key_id + "\n" + .raw_key'

  # CLI
  $ gh api users/marslo_ghe/gpg_keys --jq '.[] | .key_id + "\n" + .raw_key'
  ```
