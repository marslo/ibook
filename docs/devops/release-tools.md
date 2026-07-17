<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [semantic-release](#semantic-release)
  - [install](#install)
  - [conventional commits](#conventional-commits)
  - [plugins](#plugins)
    - [check and upgrade](#check-and-upgrade)
  - [configurations](#configurations)
    - [.releaserc.json](#releasercjson)
    - [.releaserc.js](#releasercjs)
    - [with conventionalcommits](#with-conventionalcommits)
  - [execution](#execution)
    - [github workflow](#github-workflow)
- [conventional-changelog](#conventional-changelog)
  - [install](#install-1)
  - [usage](#usage)
    - [check preset loader](#check-preset-loader)
- [poetry](#poetry)
  - [install and upgrade](#install-and-upgrade)
    - [environment](#environment)
    - [cleanup](#cleanup)
  - [new project and init](#new-project-and-init)
    - [new pyproject.toml](#new-pyprojecttoml)
    - [init](#init)
  - [requests management](#requests-management)
    - [load requests](#load-requests)
    - [remove requests](#remove-requests)
    - [update requests](#update-requests)
  - [use poetry](#use-poetry)
    - [activate env](#activate-env)
- [publish to PyPI](#publish-to-pypi)
  - [setup token](#setup-token)
  - [build and publish](#build-and-publish)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# semantic-release

> [!NOTE|label:reference:]
> - [semantic-release](https://semantic-release.gitbook.io/semantic-release)

## install
```bash
$ npm install -g semantic-release @semantic-release/changelog @semantic-release/git @semantic-release/github

# or full install
$ npm install -g semantic-release @semantic-release/commit-analyzer @semantic-release/release-notes-generator @semantic-release/changelog @semantic-release/exec @semantic-release/git @semantic-release/github
```

## conventional commits

> [!TIP|label:references:]
> - [* iMarslo: commit message](./git/tricky.html#commit-message)
> - [commitlint](https://commitlint.js.org/)
> - [commitlint configuration](https://commitlint.js.org/reference/configuration.html)

```bash
$ npm i -g @commitlint/config-conventional

# or
$ npm install -g @commitlint/cli @commitlint/config-conventional
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

### check and upgrade
```bash
$ npm outdated -g
Package                                     Current   Wanted   Latest  Location                                                 Depended by
@commitlint/cli                              21.0.1   21.2.0   21.2.0  node_modules/@commitlint/cli                             global
@commitlint/config-conventional              21.0.1   21.2.0   21.2.0  node_modules/@commitlint/config-conventional             global
@pnp/cli-microsoft365                        11.7.1   11.8.0   11.8.0  node_modules/@pnp/cli-microsoft365                       global
conventional-changelog-conventionalcommits    9.3.1   10.2.0   10.2.0  node_modules/conventional-changelog-conventionalcommits  global
npm                                         11.17.0  11.18.0  11.18.0  node_modules/npm                                         global
npm-groovy-lint                              17.0.5   18.0.0   18.0.0  node_modules/npm-groovy-lint                             global
semantic-release                             25.0.3   25.0.5   25.0.5  node_modules/semantic-release                            global

# check version list
$ npm view conventional-changelog-conventionalcommits versions --json | tail
  "8.0.0",
  "9.0.0",
  "9.1.0",
  "9.2.0",
  "9.3.0",
  "9.3.1",
  "10.0.0",
  "10.1.0",
  "10.2.0"
]

# upgrade all
$ npm update -g

added 293 packages, removed 1068 packages, and changed 1081 packages in 55s
# upgrade specific package
$ npm install -g conventional-changelog-conventionalcommits@latest
```

## configurations

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

<!--sec data-title="create or update CHANGELOG.md and commit as new revision" data-id="section1" data-show=true data-collapse=true ces-->
```json
// create or update CHANGELOG.md and commit as new revision
{
  "branches": [
    { "name": "main" },
    { "name": "next", "channel": "beta", "prerelease": true }
  ],
  "tagFormat": "v${version}",
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    ["@semantic-release/changelog", { "changelogFile": "CHANGELOG.md" }],
    ["@semantic-release/git", { "assets": ["CHANGELOG.md"], "message": "chore(release): v${nextRelease.version}" }],
    "@semantic-release/github"
  ]
}
```
<!--endsec-->

<!--sec data-title="update version in pyproject.toml and poetry.lock via poetry" data-id="section2" data-show=true data-collapse=true ces-->
```json
// update version in pyproject.toml and poetry.lock via poetry
{
  "branches": [
    { "name": "main" },
    { "name": "next", "channel": "beta", "prerelease": true }
  ],
  "tagFormat": "v${version}",
  "plugins": [
    ["@semantic-release/commit-analyzer", {
      "preset": "angular",
      "releaseRules": [
        { "type": "docs", "release": "patch" },
        { "type": "ci",   "release": "patch" }
      ]
    }],
    "@semantic-release/release-notes-generator",
    ["@semantic-release/changelog", { "changelogFile": "CHANGELOG.md" }],
    ["@semantic-release/exec", { "prepareCmd": "poetry version ${nextRelease.version} && poetry lock" }],
    ["@semantic-release/git", { "assets": ["CHANGELOG.md", "pyproject.toml", "poetry.lock"], "message": "chore(release): v${nextRelease.version}" }],
    "@semantic-release/github"
  ]
}
```
<!--endsec-->

<!--sec data-title="format the release notes with conventional-changelog-conventionalcommits" data-id="section3" data-show=true data-collapse=true ces-->
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
    ["@semantic-release/changelog", { "changelogFile": "CHANGELOG.md" }],
    ["@semantic-release/git", { "assets": ["CHANGELOG.md"], "message": "chore(release): v${nextRelease.version}" }],
    "@semantic-release/github"
  ]
}
```
<!--endsec-->

### .releaserc.js


> [!NOTE|label:references:]
> - [conventional-changelog-conventionalcommits - v10.0.0 BREAKING CHANGES](https://github.com/conventional-changelog/conventional-changelog/blob/master/packages/conventional-changelog-conventionalcommits/CHANGELOG.md#1000-2026-06-26)
> - [conventional-changelog-writer](https://github.com/conventional-changelog/conventional-changelog/blob/master/packages/conventional-changelog-writer/README.md)

```javascript
// minimal .releaserc.js for conventional-changelog-conventionalcommits v10+
module.exports = {
  branches: ["main"],
  plugins: [
    ["@semantic-release/commit-analyzer",         { preset: "conventionalcommits" }],
    ["@semantic-release/release-notes-generator", { preset: "conventionalcommits" }],
    "@semantic-release/changelog",   // writes/updates CHANGELOG.md
    "@semantic-release/git"          // commits the updated CHANGELOG.md
  ]
};
```

<!--sec data-title="customized changelog format for conventional-changelog-conventionalcommits v10+" data-id="section4" data-show=true data-collapse=true ces-->
```javascript
// with customized changelog format for conventional-changelog-conventionalcommits v10+
const SECTIONS = [
  { type: 'feat',     section: 'Features' },
  { type: 'fix',      section: 'Bug Fixes' },
  { type: 'refactor', section: 'Code Refactoring' },
  { type: 'chore',    section: 'Others' },
  { type: 'docs',     section: 'Documentation' },
  { type: 'perf',     section: 'Performance' },
  { type: 'ci',       section: 'CI/CD' }
];
const TYPE_TO_SECTION = Object.fromEntries(SECTIONS.map(s => [s.type, s.section]));
const SECTION_ORDER   = SECTIONS.map(s => s.section);
const isSignoff       = (line) => /^\s*Signed-off-by:/i.test(line);
const stripSignoff    = (text) => (text || '').split('\n').filter(l => !isSignoff(l)).join('\n').trim();

// ── Handlebars templates (writer-8 compatible; vendored from the conventional - commits preset so they work regardless of the installed preset major) ──
const mainTemplate = `{{> header}}
{{#if noteGroups}}
{{#each noteGroups}}

### ⚠ {{title}}

{{#each notes}}
* {{#if commit.scope}}**{{commit.scope}}:** {{/if}}{{text}}
{{/each}}
{{/each}}
{{/if}}
{{#each commitGroups}}

{{#if title}}
### {{title}}

{{/if}}
{{#each commits}}
{{> commit root=@root}}
{{/each}}
{{/each}}
`;

const headerPartial = `## {{#if @root.linkCompare~}}
  [{{version}}]({{~@root.host}}/{{#if this.owner}}{{~this.owner}}{{else}}{{~@root.owner}}{{/if}}/{{#if this.repository}}{{~this.repository}}{{else}}{{~@root.repository}}{{/if}}/compare/{{previousTag}}...{{currentTag}})
{{~else}}
  {{~version}}
{{~/if}}
{{~#if date}} ({{date}})
{{/if}}
`;

// {{header}} keeps the original "feat: ..." prefix; body/footer follow (signoff stripped in transform)
const commitPartial = "* {{header}}\n{{#if body}}\n{{body}}\n{{/if}}\n{{#if footer}}\n\n{{footer}}\n{{/if}}\n";

module.exports = {
  "branches": ["main"],
  "tagFormat": "v${version}",
  "plugins": [
    ["@semantic-release/commit-analyzer", {
      "preset": "angular",
      "releaseRules": [
        // { "type": "feat",     "release": "patch" },
        // { "breaking": true,   "release": "minor" },
        { "type": "chore",    "release": "patch" },
        { "type": "refactor", "release": "patch" },
        { "type": "docs",     "release": "patch" },
        { "type": "ci",       "release": "patch" }
      ]
    }],
    ["@semantic-release/release-notes-generator", {
      "preset": "conventionalcommits",
      "presetConfig": { "types": SECTIONS },
      "writerOpts": {
        "groupBy": "type",
        // order sections as listed in SECTIONS (not alphabetically)
        "commitGroupsSort": (a, b) => SECTION_ORDER.indexOf(a.title) - SECTION_ORDER.indexOf(b.title),
        "commitsSort": ["header", "subject"],
        "noteGroupsSort": "title",
        "mainTemplate": mainTemplate,
        "headerPartial": headerPartial,
        "commitPartial": commitPartial,
        "footerPartial": "",
        "transform": (commit) => {
          const c = { ...commit };

          // type -> section label (drives the "### <section>" grouping)
          if (TYPE_TO_SECTION[c.type]) {
            c.type = TYPE_TO_SECTION[c.type];
          }

          // drop Signed-off-by trailers from body / footer / notes
          if (c.body) {
            const lines = c.body.split('\n').filter(l => !isSignoff(l));
            c.body = lines.length > 0 ? lines.map(l => '  ' + l).join('\n') : null;
          }
          if (c.footer) {
            c.footer = stripSignoff(c.footer) || null;
          }
          if (Array.isArray(c.notes)) {
            c.notes = c.notes
              .map(n => ({ ...n, text: stripSignoff(n.text) }))
              .filter(n => n.text);
          }

          return c;
        }
      }
    }],
    ["@semantic-release/changelog", { "changelogFile": "CHANGELOG.md" }],
    ["@semantic-release/exec", {
      "prepareCmd": "pre-commit run --files CHANGELOG.md || true"
    }],
    ["@semantic-release/git", {
      "assets": ["CHANGELOG.md"],
      "message": "chore(release): v${nextRelease.version}"
    }],
    "@semantic-release/github"
  ]
};
```
<!--endsec-->

<!--sec data-title="with conventional-changelog-conventionalcommits <= v9.x" data-id="section5" data-show=true data-collapse=true ces-->
```javascript
module.exports = {
  "branches": ["main"],
  "tagFormat": "v${version}",
  "plugins": [
    ["@semantic-release/commit-analyzer", {
      "preset": "angular",
      "releaseRules": [
        // { "breaking": true,   "release": "minor" },
        { "type": "chore",    "release": "patch" },
        { "type": "refactor", "release": "patch" },
        { "type": "docs",     "release": "patch" },
        { "type": "ci",       "release": "patch" }
      ]
    }],
    ["@semantic-release/release-notes-generator", {
      "preset": "conventionalcommits",
      "presetConfig": {
        "types": [
          { "type": "Features",  "section": "Features" },
          { "type": "Bug Fixes", "section": "Bug Fixes" }
        ]
      },
      "writerOpts": {
        "commitsSort": ["header", "subject"],
        "transform": (commit) => {
          // clone object to avoid immutable error
          const clonedCommit = { ...commit };

          // mapping from original commit type to section title in CHANGELOG
          const sectionMap = {
            'feat': 'Features',
            'fix': 'Bug Fixes',
            'refactor': 'Code Refactoring',
            'chore': 'Others',
            'docs': 'Documentation',
            'perf': 'Performance',
            'ci': 'CI/CD'
          };

          const isSignoff = (line) => /^\s*Signed-off-by:/i.test(line);

          // commit body
          if (clonedCommit.body) {
            const cleanedBodyLines = clonedCommit.body.split('\n').filter(line => !isSignoff(line));
            clonedCommit.body = cleanedBodyLines.length > 0
              ? cleanedBodyLines.map(line => '  ' + line).join('\n')
              : null;
          }

          // footer
          if (clonedCommit.footer) {
            clonedCommit.footer = clonedCommit.footer
              .split('\n')
              .filter(line => !isSignoff(line))
              .join('\n').trim() || null;
          }

          // notes
          if (Array.isArray(clonedCommit.notes)) {
            clonedCommit.notes = clonedCommit.notes.filter(n => !isSignoff(n.text || n.title || ''));
          }

          // return the modified commit object, note: we did not change the subject,
          return clonedCommit;
        },
        // using {{header}} to ensure the original "feat: ..." is fully preserved
        "commitPartial": "* {{header}}\n{{#if body}}\n{{body}}\n{{/if}}\n{{#if footer}}\n\n{{footer}}\n{{/if}}\n"
      }
    }],
    ["@semantic-release/changelog", { "changelogFile": "CHANGELOG.md" }],
    ["@semantic-release/exec", {
      "prepareCmd": "pre-commit run --files CHANGELOG.md || true"
    }],
    ["@semantic-release/git", {
      "assets": ["CHANGELOG.md"],
      "message": "chore(release): v${nextRelease.version}"
    }],
    "@semantic-release/github"
  ]
};
```
<!--endsec-->

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

<!--sec data-title="sample debug log" data-id="section6" data-show=true data-collapse=true ces-->
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
  semantic-release:git committed files: [ 'CHANGELOG.md' ] +0ms
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


### github workflow

<!--sec data-title="github workflow with summary status" data-id="section7" data-show=true data-collapse=true ces-->

```javascript
// .releaserc.js
...
module.exports = {
    ...
    ["@semantic-release/exec", {
      "prepareCmd": "pre-commit run --files CHANGELOG.md || true",
      "successCmd": "echo \"RELEASED_VERSION=${nextRelease.version}\" >> \"$GITHUB_ENV\""       // export to env for later steps
    }],
};
```


```yaml
# .github/workflows/semantic-release.yml
---
name: Release
run-name: Release · ${{ github.ref_name }} · @${{ github.actor }}

...

permissions:
  contents: write    # allow to create tag / push commit
  pull-requests: write
  issues: write

jobs:
  release:
    runs-on: ubuntu-latest

    steps:
      # ...
      - name: Run semantic-release
        id: release
        env:
          GH_TOKEN: ${{ secrets.SEMANTIC_RELEASE_TOKEN }}
          CI: "true"
          DRY_RUN: ${{ github.event.inputs.dry_run }}
        run: |
          if [ "$DRY_RUN" = "true" ]; then
            semantic-release --dry-run
          else
            semantic-release --verbose
          fi

      - name: Release summary
        if: always()
        run: |
          if [ -n "${RELEASED_VERSION:-}" ]; then
            echo "::notice title=Release::Released v${RELEASED_VERSION} on ${GITHUB_REF_NAME} by @${GITHUB_ACTOR}"
            {
              echo "## Release v${RELEASED_VERSION}"
              echo ""
              echo "| | |"
              echo "|---|---|"
              echo "| Version      | \`v${RELEASED_VERSION}\` |"
              echo "| Branch       | \`${GITHUB_REF_NAME}\` |"
              echo "| Triggered by | @${GITHUB_ACTOR} |"
              echo "| Release      | ${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/releases/tag/v${RELEASED_VERSION} |"
            } >> "$GITHUB_STEP_SUMMARY"
          else
            echo "::notice title=Release::No new release (no version bump, or dry-run)"
            {
              echo "## No new release"
              echo ""
              echo "_No commits triggered a version bump (or this was a dry-run)._"
            } >> "$GITHUB_STEP_SUMMARY"
          fi
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

| COMMAND                                | DESCRIPTION                                                                                                                       |
|----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| `$ poetry run python -m cli.crm <cmd>` | requires `$ poetry install`                                                                                                       |
| `$ python -m cli.crm <cmd>`            | requires `$ poetry install && source "$(poetry env info --path)/bin/activate"`                                                    |
| `$ cr-manager <cmd>`                   | requires `$ poetry install && source "$(poetry env info --path)/bin/activate"`, or `pip install --user -e .`, or `pipx install .` |

## install and upgrade
```bash
# pipx
$ pipx install poetry

# pip
$ python3 -m pip install --user poetry

# curl
$ curl -sSL https://install.python-poetry.org | python3 -
# -- windows --
> (Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | py -

# upgrade
$ poetry self update

# uninstall
$ poetry self uninstall
```

### environment
```bash
# check env
$ poetry env info
$ poetry env info --path

# list envs
$ poetry env list
```

### cleanup
```bash
# remove unused envs
$ poetry env remove <PYTHON_VERSION>
# or
$ poetry env remove --all

# cache
$ poetry cache clear --all pypi
```

## new project and init

### new pyproject.toml
```bash
$ poetry new <NEW_PROJECT>

# or with src
$ poetry new --src <NEW_PROJECT>
```

### init
```bash
$ cd /path/to/project
$ poetry init

# or interactive mode
$ poetry init --name "<NEW_PROJECT>" --dependency requests^2.32 --dev-dependency pytest^8.3 -n
```

## requests management
### load requests
```bash
$ poetry add $(cat requirements.txt)

# or
$ poetry add requests

# or manually added
$ poetry add "requests^2.32"
$ poetry add "Django>=5.0,<5.2"

# -- add tool.poetry.group.dev.dependencies --
$ poetry add --group dev pytest
# or
$ poetry add --dev pytest
```

### remove requests
```bash
$ poetry remove requests
# or
$ poetry remove pytest --group dev
```

### update requests
```bash
poetry update

# single package
poetry update requests pytest

# upgrade group
poetry update --only dev
```

## use poetry
```bash
$ cd /path/to/project

$ poetry install
# or
$ poetry install --without dev
# or
$ poetry install --no-root
```

### activate env
```bash
$ poetry env use python
$ poetry env use /usr/local/bin/python3.12

# with pyenv
$ pyenv local <VERSION>
$ poetry env use $(pyenv which python)

# actrive venv
$ source "$(poetry env info --path)/bin/activate"
```

# publish to PyPI

## setup token
```bash
$ poetry config pypi-token.pypi pypi-xxxxxxxxxx

# optional
$ poetry check
```

## build and publish
```bash
$ poetry install
$ poetry build
$ poetry publish --build
# or
$ poetry publish --build --no-interaction --verbose
```

```bash
$ poetry install
Installing dependencies from lock file

Package operations: 8 installs, 0 updates, 0 removals

  - Installing asteroid (4.0.2)
  - Installing dill (0.4.0)
  - Installing isort (7.0.0)
  - Installing mccabe (0.7.0)
  - Installing platformdirs (4.5.0)
  - Installing tomlkit (0.13.3)
  - Installing pylint (4.0.2)
  - Installing wcwidth (0.2.14)

Installing the current project: cr-manager (3.0.3)

$ poetry build
Building cr-manager (3.0.3)
Building sdist
  - Building sdist
  - Built cr_manager-3.0.3.tar.gz
Building wheel
  - Building wheel
  - Built cr_manager-3.0.3-py3-none-any.whl

$ poetry publish --build
There are 2 files ready for publishing. Build anyway? (yes/no) [no] y
Building cr-manager (3.0.3)
Building sdist
  - Building sdist
  - Built cr_manager-3.0.3.tar.gz
Building wheel
  - Building wheel
  - Built cr_manager-3.0.3-py3-none-any.whl

Publishing cr-manager (3.0.3) to PyPI
 - Uploading cr_manager-3.0.3-py3-none-any.whl 100%
 - Uploading cr_manager-3.0.3.tar.gz 100%
```
