<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [theme](#theme)
  - [`jekyll`](#jekyll)
- [`gh-pages`](#gh-pages)
- [Please use a personal access token instead](#please-use-a-personal-access-token-instead)
  - [token generation](#token-generation)
  - [clean previous git credential](#clean-previous-git-credential)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## theme
> reference:
> - [github.com » github.page](https://docs.github.com/en/github/working-with-github-pages)
> - theme
>   [jekyll-themes.com](https://jekyll-themes.com/)
>   [jekyllthemes.io](https://jekyllthemes.io/)
>   [jekyllthemes.org](http://jekyllthemes.org/)
>   [jamstackthemes.dev](https://jamstackthemes.dev/ssg/jekyll/)
>   [Solar](https://jekyll-themes.com/solar/)
>   [DevJoural](https://hemang.dev/DevJournal/)

### `jekyll`
> - [jellky usage](https://kbroman.org/simple_site/pages/local_test.html)

- install
  ```bash
  $ gem install github-pages
  Fetching em-websocket-0.5.1.gem
  Fetching colorator-1.1.0.gem
  Fetching eventmachine-1.2.7.gem
  ...
  ```

- start local service
  ```bash
  $ jekyll serve
  Configuration file: /Users/marslo/mywork/tools/git/marslo/marslo.github.io/_config.yml
              Source: /Users/marslo/mywork/tools/git/marslo/marslo.github.io
         Destination: /Users/marslo/mywork/tools/git/marslo/marslo.github.io/_site
   Incremental build: disabled. Enable with --incremental
        Generating...
                      done in 0.593 seconds.
   Auto-regeneration: enabled for '/Users/marslo/mywork/tools/git/marslo/marslo.github.io'
      Server address: http://127.0.0.1:4000/
    Server running... press ctrl-c to stop.
  ```

## `gh-pages`
> reference [How to build and deploy a React app to Github pages in less than 5 minutes](https://medium.com/mobile-web-dev/how-to-build-and-deploy-a-react-app-to-github-pages-in-less-than-5-minutes-d6c4ffd30f14)

## [Please use a personal access token instead](https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/)
> references:
> - [Authentication token format updates are generally available](https://github.blog/changelog/2021-03-31-authentication-token-format-updates-are-generally-available/)
> - [Creating a personal access token](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token)
> - [Other authentication methods](https://docs.github.com/en/rest/overview/other-authentication-methods#basic-authentication)
> - [jonjack/add-update-github-access-token-on-mac.md](https://gist.github.com/jonjack/bf295d4170edeb00e96fb158f9b1ba3c)
> - [Updating credentials from the macOS Keychain](https://docs.github.com/en/get-started/getting-started-with-git/updating-credentials-from-the-macos-keychain)
> - [Caching your GitHub credentials in Git](https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git)
> - [Using the OS X Keychain to store and retrieve passwords](https://www.netmeister.org/blog/keychain-passwords.html)
> - [Get Password from Keychain in Shell Scripts](https://scriptingosx.com/2021/04/get-password-from-keychain-in-shell-scripts/)

### token generation
- login -> account -> `settings` -> `Developer settings` -> `Personal access tokens`

### clean previous git credential
```bash
$ git credential-osxkeychain erase ⏎
host=github.com ⏎
protocol=https ⏎
⏎

# and clean the previous git credential in keychain Access.app
$ security delete-internet-password -l github.com
```

- check git credential helper
  ```bash
  $ git config --get credential.helper
  osxkeychain
  ```

- find item in keychain
  ```bash
  $ security find-internet-password -l github.com
  ```

- read password
  > [imarslo : read password in osx](../../osx/util.html#get-wifi-password)

  ```bash
   $ sudo security find-internet-password -ws github.com [-a <account@mail.com>]
  ```

  or read all information
  ```bash
  $ sudo security find-internet-password -gs github.com
  ```
![read password from keychain via `/usr/bin/security`](../../screenshot/git/git-keychain-token.png)

