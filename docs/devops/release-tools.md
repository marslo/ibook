<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [semantic-release](#semantic-release)
  - [install](#install)
  - [plugins](#plugins)
    - [.releaserc.json](#releasercjson)
    - [with conventionalcommits](#with-conventionalcommits)
  - [execution](#execution)
- [conventional-changelog](#conventional-changelog)
  - [install](#install-1)
  - [usage](#usage)
    - [check preset loader](#check-preset-loader)
- [poetry](#poetry)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# semantic-release

> [!NOTE|label:reference:]
> - [semantic-release](https://semantic-release.gitbook.io/semantic-release)

## install
```bash
$ npm install -g semantic-release @semantic-release/changelog @semantic-release/git @semantic-release/github

# optional
$ npm install -g conventional-changelog-cli
$ npm install -g conventional-changelog-angular
```

## plugins

> [!TIP]
> put in the root of repository
> - references:
>> - [plugins](https://semantic-release.gitbook.io/semantic-release/extending/plugins-list)

| PLUGIN                                                                                                                   | USAGE                                                                              |
|--------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------|
| [`@semantic-release/commit-analyzer`](https://github.com/semantic-release/commit-analyzer)                               | to analyze commits with conventional-changelog, i.e.( `feat`, `fix`, `refactor!` ) |
| [`@semantic-release/release-notes-generator`](https://github.com/semantic-release/release-notes-generator)               | to generate changelog content                                                      |
| [`@semantic-release/changelog`](https://github.com/semantic-release/changelog)                                           | to create or update a changelog file                                               |
| [`@semantic-release/git`](https://github.com/semantic-release/git)                                                       | to commit release assets to the project's git repository                           |
| [`@semantic-release/github`](https://github.com/semantic-release/github)                                                 | to publish a GitHub release and comment on released Pull Requests/Issues           |
| [`@semantic-release/exec`](https://github.com/semantic-release/exec)                                                     | to execute custom shell commands                                                   |
| [`conventional-changelog-conventionalcommits`](https://www.npmjs.com/package/conventional-changelog-conventionalcommits) | for automated CHANGELOG generation and version management                          |


### .releaserc.json

```json
{
  "branches": ["main"],
  "repositoryUrl": "git@github.com:username/repo-name.git",
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/github"
  ]
}
```

<!--sec data-title="i.e.:" data-id="section0" data-show=true data-collapse=true ces-->
```json
{
  "branches": ["main"],
  "repositoryUrl": "git@github.com:marslo/pass-fzf.git",
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/github"
  ]
}
```
<!--endsec-->

```json
// will create or update CHANGELOG.md and commit as new revision
{
  "branches": [
    { "name": "main" },
    { "name": "next", "channel": "beta", "prerelease": true }
  ],
  "tagFormat": "v${version}",
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    [
      "@semantic-release/changelog",
      {
        "changelogFile": "CHANGELOG.md"
      }
    ],
    [
      "@semantic-release/git",
      {
        "assets": ["CHANGELOG.md"],
        "message": "chore(release): v${nextRelease.version}"
      }
    ],
    "@semantic-release/github"
  ]
}
```

```json
// to format the release notes with conventional-changelog-conventionalcommits
{
  "branches": [
    { "name": "main" },
    { "name": "next", "channel": "beta", "prerelease": true }
  ],
  "tagFormat": "v${version}",
  "plugins": [
    "@semantic-release/commit-analyzer",
    [
      "@semantic-release/release-notes-generator",
      {
        "preset": "conventionalcommits",
        "presetConfig": {
          "commitDateFormat": "YYYY-MM-DD",
          "types": [
            { "type": "refactor", "section": "Breaking Changes" }
          ]
        },
        "writerOpts": {
          "headerPartial": "{{#if isPatch}}##{{else}}#{{/if}} v{{version}} ({{date}})\n\n"
        }
      }
    ],
    [
      "@semantic-release/changelog",
      {
        "changelogFile": "CHANGELOG.md"
      }
    ],
    [
      "@semantic-release/git",
      {
        "assets": ["CHANGELOG.md"],
        "message": "chore(release): v${nextRelease.version}"
      }
    ],
    "@semantic-release/github"
  ]
}
```

### with conventionalcommits


| FLAG                         | SCOPE                            |
|------------------------------|----------------------------------|
| `writerOpts.headerPartial`   | `CHANGELOG.md` and release notes |
| `presetConfig.headerPartial` | release notes                    |

```bash
$ npm install -g conventional-changelog-conventionalcommits
```

```json
{
  "branches": ["main"],
  "tagFormat": "v${version}",
  "plugins": [
    "@semantic-release/commit-analyzer",
    [
      "@semantic-release/release-notes-generator",
      {
        "preset": "conventionalcommits",
        "presetConfig": {
          "commitUrlFormat": "https://github.com/marslo/pass-fzf/commit/{hash}",
          "compareUrlFormat": "https://github.com/marslo/pass-fzf/compare/v{previousVersion}...v{currentVersion}",
          "issueUrlFormat": "https://github.com/marslo/pass-fzf/issues/{id}",
          "commitDateFormat": "YYYY-MM-DD",
          "types": [
            { "type": "feat", "section": "Features" },
            { "type": "fix", "section": "Bug Fixes" },
            { "type": "refactor", "section": "Breaking Changes" }
          ]
        },
        "writerOpts": {
          "headerPartial": "{{#if isPatch}}##{{else}}#{{/if}} [v{{version}}]({{compareUrl}}) ({{date}})\n\n",
          "transform": {
            "linkReferences": true
          }
        }
      }
    ],
    ["@semantic-release/changelog", { "changelogFile": "CHANGELOG.md" }],
    ["@semantic-release/git", { "assets": ["CHANGELOG.md"] }],
    "@semantic-release/github"
  ]
}
```

## execution

```bash
#           + missing necessary env-ci, and manually setup
# +---------------------+
$ CI=true GIT_BRANCH=main npx semantic-release --branch main --debug [ --dry-run ]
#                                              +-----------+ +-----+
#                                                   |           + debug mode
#                                                   + the branch definitional in .releaserc
```

- sample release : [pass-fzf v2.0.0](https://github.com/marslo/pass-fzf/releases)

<!--sec data-title="sample debug log" data-id="section1" data-show=true data-collapse=true ces-->
```bash
$ CI=true GIT_BRANCH=main npx semantic-release --branch main --debug
[5:28:07 PM] [semantic-release] › ℹ  Running semantic-release version 24.2.3
  semantic-release:config load config from: /Users/marslo/iMarslo/tools/git/marslo/pass-fzf/.releaserc.json +0ms
  semantic-release:config options values: {
  semantic-release:config   branches: [
  semantic-release:config     { name: 'main' },
  semantic-release:config     { name: 'next', channel: 'beta', prerelease: true }
  semantic-release:config   ],
  semantic-release:config   repositoryUrl: 'https://github.com/marslo/pass-fzf.git',
  semantic-release:config   tagFormat: 'v${version}',
  semantic-release:config   plugins: [
  semantic-release:config     '@semantic-release/commit-analyzer',
  semantic-release:config     '@semantic-release/release-notes-generator',
  semantic-release:config     [ '@semantic-release/changelog', [Object] ],
  semantic-release:config     [ '@semantic-release/git', [Object] ],
  semantic-release:config     '@semantic-release/github'
  semantic-release:config   ],
  semantic-release:config   _: [],
  semantic-release:config   branch: 'main',
  semantic-release:config   debug: true,
  semantic-release:config   '$0': '/Users/marslo/.npm/bin/semantic-release'
  semantic-release:config } +13ms
  semantic-release:plugins options for @semantic-release/changelog/verifyConditions: { changelogFile: 'CHANGELOG.md' } +0ms
[5:28:07 PM] [semantic-release] › ✔  Loaded plugin "verifyConditions" from "@semantic-release/changelog"
  semantic-release:plugins options for @semantic-release/git/verifyConditions: {
  semantic-release:plugins   assets: [ 'CHANGELOG.md' ],
  semantic-release:plugins   message: 'chore(release): v${nextRelease.version}'
  semantic-release:plugins } +1ms
[5:28:07 PM] [semantic-release] › ✔  Loaded plugin "verifyConditions" from "@semantic-release/git"
  semantic-release:plugins options for @semantic-release/github/verifyConditions: {} +0ms
[5:28:07 PM] [semantic-release] › ✔  Loaded plugin "verifyConditions" from "@semantic-release/github"
  semantic-release:plugins options for @semantic-release/commit-analyzer/analyzeCommits: {} +0ms
[5:28:07 PM] [semantic-release] › ✔  Loaded plugin "analyzeCommits" from "@semantic-release/commit-analyzer"
  semantic-release:plugins options for @semantic-release/release-notes-generator/generateNotes: {} +0ms
[5:28:07 PM] [semantic-release] › ✔  Loaded plugin "generateNotes" from "@semantic-release/release-notes-generator"
  semantic-release:plugins options for @semantic-release/changelog/prepare: { changelogFile: 'CHANGELOG.md' } +0ms
[5:28:07 PM] [semantic-release] › ✔  Loaded plugin "prepare" from "@semantic-release/changelog"
  semantic-release:plugins options for @semantic-release/git/prepare: {
  semantic-release:plugins   assets: [ 'CHANGELOG.md' ],
  semantic-release:plugins   message: 'chore(release): v${nextRelease.version}'
  semantic-release:plugins } +0ms
[5:28:07 PM] [semantic-release] › ✔  Loaded plugin "prepare" from "@semantic-release/git"
  semantic-release:plugins options for @semantic-release/github/publish: {} +1ms
[5:28:07 PM] [semantic-release] › ✔  Loaded plugin "publish" from "@semantic-release/github"
  semantic-release:plugins options for @semantic-release/github/addChannel: {} +0ms
[5:28:07 PM] [semantic-release] › ✔  Loaded plugin "addChannel" from "@semantic-release/github"
  semantic-release:plugins options for @semantic-release/github/success: {} +0ms
[5:28:07 PM] [semantic-release] › ✔  Loaded plugin "success" from "@semantic-release/github"
  semantic-release:plugins options for @semantic-release/github/fail: {} +0ms
[5:28:07 PM] [semantic-release] › ✔  Loaded plugin "fail" from "@semantic-release/github"
  semantic-release:get-git-auth-url Verifying ssh auth by attempting to push to  https://github.com/marslo/pass-fzf.git +0ms
  semantic-release:get-git-auth-url SSH key auth successful. +645ms
  semantic-release:get-tags found tags for branch main: [ { gitTag: 'v1.0.0', version: '1.0.0', channels: [ null ] } ] +0ms
[5:28:09 PM] [semantic-release] › ✔  Run automated release from branch main on repository https://github.com/marslo/pass-fzf.git
[5:28:10 PM] [semantic-release] › ✔  Allowed to push to the Git repository
[5:28:10 PM] [semantic-release] › ℹ  Start step "verifyConditions" of plugin "@semantic-release/changelog"
[5:28:10 PM] [semantic-release] › ✔  Completed step "verifyConditions" of plugin "@semantic-release/changelog"
[5:28:10 PM] [semantic-release] › ℹ  Start step "verifyConditions" of plugin "@semantic-release/git"
[5:28:10 PM] [semantic-release] › ✔  Completed step "verifyConditions" of plugin "@semantic-release/git"
[5:28:10 PM] [semantic-release] › ℹ  Start step "verifyConditions" of plugin "@semantic-release/github"
[5:28:10 PM] [semantic-release] [@semantic-release/github] › ℹ  Verify GitHub authentication
[5:28:10 PM] [semantic-release] › ✔  Completed step "verifyConditions" of plugin "@semantic-release/github"
[5:28:10 PM] [semantic-release] › ℹ  Found git tag v1.0.0 associated with version 1.0.0 on branch main
  semantic-release:get-commits Use from: 4a703e72c0887f2012de8e791e725181d1ce18d8 +0ms
[5:28:10 PM] [semantic-release] › ℹ  Found 2 commits since last release
  semantic-release:get-commits Parsed commits: [ { commit: { long: '5a49f93752bbee7893454eddec2e258223fa0233', short: '5a49f93' }, tree: { long: '68d93047ca4dc9f6dcc2e175109ec55622e38a3a', short: '68d9304' }, author: { name: 'marslo', email: 'marslo.jiao@gmail.com', date: 2025-05-09T23:28:57.000Z }, committer: { name: 'marslo', email: 'marslo.jiao@gmail.com', date: 2025-05-10T00:25:53.000Z }, subject: 'style(semantic-release): to update the .releaserc to customerize the release notes format', body: 'Signed-off-by: marslo <marslo.jiao@gmail.com>\n', hash: '5a49f93752bbee7893454eddec2e258223fa0233', committerDate: 2025-05-10T00:25:53.000Z, message: 'style(semantic-release): to update the .releaserc to customerize the release notes format\n' + '\n' + 'Signed-off-by: marslo <marslo.jiao@gmail.com>', gitTags: '(HEAD -> main, origin/main, origin/HEAD)' }, { commit: { long: 'e42bb14921eca7f456b88f9a3a082644235eb1b3', short: 'e42bb14' }, tree: { long: 'd3c8f55807732ab0c8e6dacb00447eeee7ae21e1', short: 'd3c8f55' }, author: { name: 'marslo', email: 'marslo.jiao@gmail.com', date: 2025-05-09T01:05:43.000Z }, committer: { name: 'marslo', email: 'marslo.jiao@gmail.com', date: 2025-05-09T22:45:08.000Z }, subject: 'refactor!: enhance the plugin and installation instructions', body: '- refactor fzf.bash to use env bash and support more pass subcommands: ` -c/--clip`,`show`,`edit`,`rm`\n' + '- improve argument parsing and error handling in fzf.bash\n' + '- enable `.releaserc.json` for semantic release\n' + '\n' + 'BREAKING CHANGE:  fzf.bash refactoring\n' + '\n' + 'Signed-off-by: marslo <marslo.jiao@gmail.com>\n', hash: 'e42bb14921eca7f456b88f9a3a082644235eb1b3', committerDate: 2025-05-09T22:45:08.000Z, message: 'refactor!: enhance the plugin and installation instructions\n' + '\n' + '- refactor fzf.bash to use env bash and support more pass subcommands: ` -c/--clip`,`show`,`edit`,`rm`\n' + '- improve argument parsing and error handling in fzf.bash\n' + '- enable `.releaserc.json` for semantic release\n' + '\n' + 'BREAKING CHANGE:  fzf.bash refactoring\n' + '\n' + 'Signed-off-by: marslo <marslo.jiao@gmail.com>', gitTags: '' } ] +21ms
[5:28:10 PM] [semantic-release] › ℹ  Start step "analyzeCommits" of plugin "@semantic-release/commit-analyzer"
[5:28:10 PM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  Analyzing commit: style(semantic-release): to update the .releaserc to customerize the release notes format

Signed-off-by: marslo <marslo.jiao@gmail.com>
  semantic-release:commit-analyzer Analyzing with default rules +0ms
[5:28:10 PM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  The commit should not trigger a release
[5:28:10 PM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  Analyzing commit: refactor!: enhance the plugin and installation instructions

- refactor fzf.bash to use env bash and support more pass subcommands: ` -c/--clip`,`show`,`edit`,`rm`
- improve argument parsing and error handling in fzf.bash
- enable `.releaserc.json` for semantic release

BREAKING CHANGE:  fzf.bash refactoring

Signed-off-by: marslo <marslo.jiao@gmail.com>
  semantic-release:commit-analyzer Analyzing with default rules +1ms
  semantic-release:commit-analyzer The rule { breaking: true, release: 'major' } match commit with release type 'major' +0ms
  semantic-release:commit-analyzer Release type 'major' is the highest possible. Stop analysis. +0ms
[5:28:10 PM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  The release type for the commit is major
[5:28:10 PM] [semantic-release] [@semantic-release/commit-analyzer] › ℹ  Analysis of 2 commits complete: major release
[5:28:10 PM] [semantic-release] › ✔  Completed step "analyzeCommits" of plugin "@semantic-release/commit-analyzer"
[5:28:10 PM] [semantic-release] › ℹ  The next release version is 2.0.0
[5:28:10 PM] [semantic-release] › ℹ  Start step "generateNotes" of plugin "@semantic-release/release-notes-generator"
  semantic-release:release-notes-generator version: '2.0.0' +0ms
  semantic-release:release-notes-generator host: undefined +0ms
  semantic-release:release-notes-generator owner: 'marslo' +0ms
  semantic-release:release-notes-generator repository: 'pass-fzf' +0ms
  semantic-release:release-notes-generator previousTag: 'v1.0.0' +0ms
  semantic-release:release-notes-generator currentTag: 'v2.0.0' +0ms
  semantic-release:release-notes-generator host: 'https://github.com' +0ms
  semantic-release:release-notes-generator linkReferences: undefined +0ms
  semantic-release:release-notes-generator issue: 'issues' +0ms
  semantic-release:release-notes-generator commit: 'commit' +0ms
[5:28:10 PM] [semantic-release] › ✔  Completed step "generateNotes" of plugin "@semantic-release/release-notes-generator"
[5:28:10 PM] [semantic-release] › ℹ  Start step "prepare" of plugin "@semantic-release/changelog"
[5:28:10 PM] [semantic-release] [@semantic-release/changelog] › ℹ  Create /Users/marslo/iMarslo/tools/git/marslo/pass-fzf/CHANGELOG.md
[5:28:10 PM] [semantic-release] › ✔  Completed step "prepare" of plugin "@semantic-release/changelog"
[5:28:10 PM] [semantic-release] › ℹ  Start step "prepare" of plugin "@semantic-release/git"
[5:28:10 PM] [semantic-release] [@semantic-release/git] › ℹ  Found 1 file(s) to commit
  semantic-release:git add file to git index {
  command: 'git add --force --ignore-errors CHANGELOG.md',
  escapedCommand: 'git add --force --ignore-errors CHANGELOG.md',
  exitCode: 0,
  stdout: '',
  stderr: '',
  all: undefined,
  failed: false,
  timedOut: false,
  isCanceled: false,
  killed: false
} +0ms
  semantic-release:git commited files: [ 'CHANGELOG.md' ] +0ms
[5:28:11 PM] [semantic-release] [@semantic-release/git] › ℹ  Prepared Git release: v2.0.0
[5:28:11 PM] [semantic-release] › ✔  Completed step "prepare" of plugin "@semantic-release/git"
[5:28:11 PM] [semantic-release] › ℹ  Start step "generateNotes" of plugin "@semantic-release/release-notes-generator"
  semantic-release:release-notes-generator version: '2.0.0' +1s
  semantic-release:release-notes-generator host: undefined +0ms
  semantic-release:release-notes-generator owner: 'marslo' +0ms
  semantic-release:release-notes-generator repository: 'pass-fzf' +0ms
  semantic-release:release-notes-generator previousTag: 'v1.0.0' +0ms
  semantic-release:release-notes-generator currentTag: 'v2.0.0' +0ms
  semantic-release:release-notes-generator host: 'https://github.com' +0ms
  semantic-release:release-notes-generator linkReferences: undefined +0ms
  semantic-release:release-notes-generator issue: 'issues' +0ms
  semantic-release:release-notes-generator commit: 'commit' +0ms
[5:28:11 PM] [semantic-release] › ✔  Completed step "generateNotes" of plugin "@semantic-release/release-notes-generator"
[5:28:13 PM] [semantic-release] › ✔  Created tag v2.0.0
[5:28:13 PM] [semantic-release] › ℹ  Start step "publish" of plugin "@semantic-release/github"
  semantic-release:github release object: {
  semantic-release:github   owner: 'marslo',
  semantic-release:github   repo: 'pass-fzf',
  semantic-release:github   tag_name: 'v2.0.0',
  semantic-release:github   target_commitish: 'main',
  semantic-release:github   name: 'v2.0.0',
  semantic-release:github   body: '# [2.0.0](https://github.com/marslo/pass-fzf/compare/v1.0.0...v2.0.0) (2025-05-10)\n' +
  semantic-release:github     '\n' +
  semantic-release:github     '\n' +
  semantic-release:github     '* refactor!: enhance the plugin and installation instructions ([e42bb14](https://github.com/marslo/pass-fzf/commit/e42bb14921eca7f456b88f9a3a082644235eb1b3))\n' +
  semantic-release:github     '\n' +
  semantic-release:github     '\n' +
  semantic-release:github     '### BREAKING CHANGES\n' +
  semantic-release:github     '\n' +
  semantic-release:github     '* fzf.bash refactoring\n' +
  semantic-release:github     '\n' +
  semantic-release:github     'Signed-off-by: marslo <marslo.jiao@gmail.com>\n' +
  semantic-release:github     '\n' +
  semantic-release:github     '\n' +
  semantic-release:github     '\n',
  semantic-release:github   prerelease: false
  semantic-release:github } +0ms
[5:28:14 PM] [semantic-release] [@semantic-release/github] › ℹ  Published GitHub release: https://github.com/marslo/pass-fzf/releases/tag/v2.0.0
[5:28:14 PM] [semantic-release] › ✔  Completed step "publish" of plugin "@semantic-release/github"
[5:28:14 PM] [semantic-release] › ℹ  Start step "success" of plugin "@semantic-release/github"
  semantic-release:github found pull requests: [] +0ms
[@octokit/request] "GET https://api.github.com/search/issues?q=in%3Atitle+repo%3Amarslo%2Fpass-fzf+type%3Aissue+state%3Aopen+The%20automated%20release%20is%20failing%20%F0%9F%9A%A8" is deprecated. It is scheduled to be removed on Thu, 04 Sep 2025 00:00:00 GMT. See https://github.blog/changelog/2025-03-06-github-issues-projects-api-support-for-issues-advanced-search-and-more/
  semantic-release:github found semantic-release issues: [] +942ms
[5:28:16 PM] [semantic-release] › ✔  Completed step "success" of plugin "@semantic-release/github"
[5:28:16 PM] [semantic-release] › ✔  Published release 2.0.0 on default channel
```
<!--endsec-->


# conventional-changelog

## install
```bash
$ npm install -g conventional-changelog-cli
$ npm install -g conventional-changelog-angular
```

## usage

| PRESET                |
|-----------------------|
| `angular`             |
| `atom`                |
| `eslint`              |
| `conventionalcommits` |
| `jquery`              |
| `codemirror`          |
| `ember`               |
| `express`             |
| `jshint`              |

```bash
#                   Angular Commit Message Convention
#                            +--------+
$ npx conventional-changelog -p angular --from HEAD^ --to HEAD -r 0 > RELEASE_NOTES.md
```

### check preset loader
```bash
$ npm ls conventional-changelog-preset-loader -g
/Users/marslo/.npm/lib
└─┬ conventional-changelog-cli@5.0.0
  └─┬ conventional-changelog@6.0.0
    └── conventional-changelog-preset-loader@5.0.0
```


# poetry

> [!TIP]
> - for python only
