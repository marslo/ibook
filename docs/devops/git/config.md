<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [installation](#installation)
  - [frmo source](#frmo-source)
- [location](#location)
  - [get locations](#get-locations)
- [list](#list)
  - [get from all configure](#get-from-all-configure)
- [default configuration](#default-configuration)
- [tig](#tig)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [8.1 Customizing Git - Git Configuration](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)
> - [Improving cross-subsystem git workflow: The different git configuration files](https://www.onwebsecurity.com/tag/git.html)
> - [git config](https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-config)
> - [git-config - Get and set repository or global options](https://git-scm.com/docs/git-config)
> - [Git config](https://www.w3docs.com/learn-git/git-config.html)
> - [10.8 Git Internals - Environment Variables](https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables)
{% endhint %}

## installation

> [!NOTE|label:references:]
> - [Download for Linux and Unix](https://git-scm.com/download/linux)
> - [1.5 Getting Started - Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

- ubuntu
  ```bash
  $ sudo add-apt-repository ppa:git-core/ppa
  $ sudo apt update
  $ sudo apt install git
  ```

### frmo source

> [!NOTE|label:references:]
> - [1.5 Getting Started - Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
> - [index : git.git](https://git.kernel.org/pub/scm/git/git.git)
> - [Compile and install Git from source](https://subscription.packtpub.com/book/iot-and-hardware/9781783982929/4/ch04lvl1sec40/compile-and-install-git-from-source)
> - [How do I correctly install the tools in git's contrib directory?](https://stackoverflow.com/a/11613541/2940319)
> - [* CheckInstall](https://help.ubuntu.com/community/CheckInstall)
>   ```bash
>   $ sudo apt-get update && sudo apt-get install checkinstall
>   ```
> - [MHMDhub/Install Git from source](https://gist.github.com/MHMDhub/d2d1a857fc5af5b18d6fff70fb4489b5)
> - [How To Install Git from Source on Ubuntu 20.04 [Quickstart]](https://www.digitalocean.com/community/tutorials/how-to-install-git-from-source-on-ubuntu-20-04-quickstart)

- dependencies

  > [!NOTE|label:references:]
  > - [* iMarslo : linux troubleshooting](../linux/troubleshooting.html)

  - git-core

    ```bash
    # debian
    $ sudo apt-get install dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev

    # centos/rhel
    $ sudo dnf install dh-autoreconf curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel
    ```

  - git-doc
    ```bash
    # debian
    $ sudo apt-get install asciidoc xmlto docbook2x

    # centos/rhel
    $ sudo dnf install asciidoc xmlto docbook2X
    ```

  - git-info
    ```bash
    # debian
    $ sudo apt-get install install-info

    # centos/rhel
    $ sudo dnf install getopt
    # or
    $ sudo ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
    ```

- install

  > [!NOTE|label:release package:]
  > - [git-for-windows](https://github.com/git-for-windows/git/releases)
  > - [git](https://github.com/git/git/tags)
  > - [/pub/software/scm/git/](https://mirrors.edge.kernel.org/pub/software/scm/git/)
  > - [* iMarslo : linux troubleshooting](../linux/troubleshooting.html)
  > - [A1.4 Appendix A: Git in Other Environments - Git in Bash](https://git-scm.com/book/uz/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Bash)
  > - [A1.6 Appendix A: Git in Other Environments - Git in Powershell](https://git-scm.com/book/uz/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Powershell)

  ```bash
  $ curl -fsSL https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.42.0.tar.gz |
         tar -zxf -C ${iRCHOME}/utils/git &&
    cd ${iRCHOME}/utils/git

  $ make configure
  $ ./configure --prefix=/usr/local
  $ make -j all doc info
  $ sudo make install install-doc install-html install-info

  # additional
  $ chmod +x ${iRCHOME}/utils/git/contrib/completion/*
  $ sudo ln -sf ${iRCHOME}/utils/git/contrib/completion/git-prompt.sh       /usr/local/libexec/git-core/git-prompt.sh
  $ sudo ln -sf ${iRCHOME}/utils/git/contrib/completion/git-completion.bash /usr/share/bash-completion/completions/git
  ```

  - result
    ```bash
    # git-for-windows
    $ git --version
    git version 2.42.0.windows.2.5.g49aad3ca52

    # git
    $ git --version
    git version 2.42.0.325.g3a06386e31
    ```

  - pacakges:

    > [!TIP|label:check apt package bin path without install:]
    > ```bash
    > $ sudo apt-file list git
    > ```

    - bins : `/usr/local/bin`
    - git-core : `/usr/local/libexec/git-core` or `$ git --exec-path`
    - diff-highlight : `/usr/share/doc/git/contrib/diff-highlight/diff-highlight`
    - git-prompt.sh : `/usr/local/libexec/git-core/git-prompt.sh`
    - git-completion : `/usr/share/bash-completion/completions/git`
    - git-info : `/usr/local/share/info`

  <!--sec data-title="bins details" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  bindir=$(cd '/usr/local/bin' && pwd) && \
  execdir=$(cd '/usr/local/libexec/git-core' && pwd) && \
  destdir_from_execdir_SQ=$(echo 'libexec/git-core' | sed -e 's|[^/][^/]*|..|g') && \
  { test "$bindir/" = "$execdir/" || \
    for p in git scalar git-shell git-cvsserver; do \
          rm -f "$execdir/$p" && \
          test -n "" && \
          ln -s "$destdir_from_execdir_SQ/bin/$p" "$execdir/$p" || \
          { test -z "" && \
            ln "$bindir/$p" "$execdir/$p" 2>/dev/null || \
            cp "$bindir/$p" "$execdir/$p" || exit; } \
    done; \
  } && \
  for p in git-receive-pack git-upload-archive git-upload-pack; do \
          rm -f "$bindir/$p" && \
          test -n "" && \
          ln -s "git" "$bindir/$p" || \
          { test -z "" && \
            ln "$bindir/git" "$bindir/$p" 2>/dev/null || \
            ln -s "git" "$bindir/$p" 2>/dev/null || \
            cp "$bindir/git" "$bindir/$p" || exit; }; \
  done && \
  for p in git-add git-am git-annotate git-apply git-archive git-bisect git-blame git-branch git-bugreport git-bundle git-cat-file git-check-attr git-check-ignore git-check-mailmap git-check-ref-format git-checkout--worker git-checkout-index git-checkout git-clean git-clone git-column git-commit-graph git-commit-tree git-commit git-config git-count-objects git-credential-cache--daemon git-credential-cache git-credential-store git-credential git-describe git-diagnose git-diff-files git-diff-index git-diff-tree git-diff git-difftool git-fast-export git-fast-import git-fetch-pack git-fetch git-fmt-merge-msg git-for-each-ref git-for-each-repo git-fsck git-fsmonitor--daemon git-gc git-get-tar-commit-id git-grep git-hash-object git-help git-hook git-index-pack git-init-db git-interpret-trailers git-log git-ls-files git-ls-remote git-ls-tree git-mailinfo git-mailsplit git-merge-base git-merge-file git-merge-index git-merge-ours git-merge-recursive git-merge-tree git-merge git-mktag git-mktree git-multi-pack-index git-mv git-name-rev git-notes git-pack-objects git-pack-redundant git-pack-refs git-patch-id git-prune-packed git-prune git-pull git-push git-range-diff git-read-tree git-rebase git-receive-pack git-reflog git-remote-ext git-remote-fd git-remote git-repack git-replace git-rerere git-reset git-rev-list git-rev-parse git-revert git-rm git-send-pack git-shortlog git-show-branch git-show-index git-show-ref git-sparse-checkout git-stash git-stripspace git-submodule--helper git-symbolic-ref git-tag git-unpack-file git-unpack-objects git-update-index git-update-ref git-update-server-info git-upload-archive git-upload-pack git-var git-verify-commit git-verify-pack git-verify-tag git-worktree git-write-tree git-cherry git-cherry-pick git-format-patch git-fsck-objects git-init git-maintenance git-merge-subtree git-restore git-show git-stage git-status git-switch git-version git-whatchanged; do \
          rm -f "$execdir/$p" && \
          if test -z ""; \
          then \
                  test -n "" && \
                  ln -s "$destdir_from_execdir_SQ/bin/git" "$execdir/$p" || \
                  { test -z "" && \
                    ln "$execdir/git" "$execdir/$p" 2>/dev/null || \
                    ln -s "git" "$execdir/$p" 2>/dev/null || \
                    cp "$execdir/git" "$execdir/$p" || exit; }; \
          fi \
  done && \
  remote_curl_aliases="git-remote-https git-remote-ftp git-remote-ftps" && \
  for p in $remote_curl_aliases; do \
          rm -f "$execdir/$p" && \
          test -n "" && \
          ln -s "git-remote-http" "$execdir/$p" || \
          { test -z "" && \
            ln "$execdir/git-remote-http" "$execdir/$p" 2>/dev/null || \
            ln -s "git-remote-http" "$execdir/$p" 2>/dev/null || \
            cp "$execdir/git-remote-http" "$execdir/$p" || exit; } \
  done
  install -d -m 755 '/usr/local/share/man/man3'
  (cd perl/build/man/man3 && tar cf - .) | \
  (cd '/usr/local/share/man/man3' && umask 022 && tar xof -)
  ```
  <!--endsec-->

## location

> [!NOTE|label:locations]
> - [Where system, global and local Git config files on Windows and Ubuntu Linux are](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/Where-system-global-and-local-Windows-Git-config-files-are-saved)
> - [Where do the settings in my Git configuration come from?](https://stackoverflow.com/q/17756753/2940319)
> - [git on Windows - location of configuration files](https://www.onwebsecurity.com/configuration/git-on-windows-location-of-global-configuration-file.html)


|      SCOPE     | WINDOWS                                     | UNIX-LIKE                  |
|:--------------:|---------------------------------------------|----------------------------|
|     system     | `<GIT_DIR>\etc\gitconfig`                   | `<GIT_DIR>/etc/gitconfig`  |
| system example | `%LOCALAPPDATA%\Programs\Git\etc\gitconfig` | `/usr/local/etc/gitconfig` |
|     global     | `%USERPROFILE%\.gitconfig`                  | `$HOME/.gitconfig`         |
|      local     | `<git-repo>\.git\config`                    | `<git-repo>/.git/config`   |
|    portable    | `%PROGRAMDATA%\Git\config`                  | -                          |

### get locations
- windows
  ```batch
    > git config --list --show-origin --name-only | sed -r 's/^file:(.+)\s+.*$/\1/g' | sort.exe /unique
    REM or
    > git config --list --show-origin --name-only | sed -r 's/^file:(.+)\s+.*$/\1/g' | powershell -nop "$input | sort -unique"
    REM or
    > git config --list --show-origin --name-only | sed -r 's/^file:(.+)\s+.*$/\1/g' | powershell -nop "$input | Sort-Object -unique"
    .git/config
    C:/Users/marslo/.gitconfig
    C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  ```
- osx
  ```bash
  $ git config --list --show-origin --name-only | awk -F'[:[:blank:]]' '{print $2}' | sort -u
  .git/config
  /Users/marslo/.gitconfig
  /Users/marslo/.marslo/.gitalias
  /usr/local/etc/gitconfig
  ```

- edit config file
  ```bash
  $ git config --edit --system
  $ git config --edit --global

  # or
  $ sudo git -c core.editor=ls\ -al config --system --edit
  ```

## list

- list all with scope
  ```bash
  $ git config --list --show-scope
  system  credential.helper=osxkeychain
  system  core.ignorecase=false
  system  filter.lfs.clean=git-lfs clean -- %f
  ```

- list origin
  ```bash
  $ git config --list --show-origin --show-scope
  system  file:/usr/local/etc/gitconfig credential.helper=osxkeychain
  system  file:/usr/local/etc/gitconfig core.ignorecase=false
  system  file:/usr/local/etc/gitconfig filter.lfs.clean=git-lfs clean -- %f
  ```

- list single scope only
  - list local only
    ```bash
    $ git config --list --local
    core.repositoryformatversion=0
    core.filemode=true
    core.bare=false
    ```

  - list global
    ```bash
    $ git config --list --global
    user.name=marslo
    user.email=marslo@gmail.com
    push.default=matching
    ```

  - list system
    ```bash
    $ git config --list --system
    credential.helper=osxkeychain
    core.ignorecase=false
    filter.lfs.clean=git-lfs clean -- %f
    filter.lfs.smudge=git-lfs smudge -- %f
    filter.lfs.process=git-lfs filter-process
    filter.lfs.required=true
    ```

### get from all configure
```bash
$ git config --show-origin --show-scope --get-all user.name
global   file:/Users/marslo/.gitconfig   marslo
local    file:.git/config    marslo
```

## default configuration
- `core.editor`

  - use vim ( the ubiqutos text editor ) as Git's default editor
    ```bash
    $ git config --get core.editor
    vim
    ```

  ![core.editor](../../screenshot/git/git-for-windows-2.png)

- `init.defaultBranch`

  - override the default branch name for new repositories
    ```bash
    $ git config --get init.defaultBranch
    development
    ```

  ![core.editor](../../screenshot/git/git-for-windows-3.png)


- `core.autocrlf`

  > [!TIP|label:see also:]
  > - [* iMarslo : core.autocrlf](./eol.html#coreautocrlf)

  - checkout windows-style, commit unix-style line endings
    ```bash
    $ git config --get core.autocrlf
    true
    ```
  - checkout as-is, commit unix-style line endings
    ```bash
    $ git config --get core.autocrlf
    input
    ```
  - checkout as-is, commit as-is
    ```bash
    $ git config --get core.autocrlf
    false
    ```

  ![core.editor](../../screenshot/git/git-for-windows-6.png)

- `pull.rebase`
  ```bash
  $ git config --get pull.rebase
  true
  ```

  ![core.editor](../../screenshot/git/git-for-windows-8.png)

- `core.fscache` & `core.symlinks`

  - enable file system caching
    ```bash
    $ git config --get core.fscache
    true
    ```

  - enable symbolic links
    ```bash
    $ git config --get core.symlinks
    true
    ```

  ![core.editor](../../screenshot/git/git-for-windows-10.png)

- `core.fsmonitor`

  - enable experimental built-in file system monitor
    ```bash
    $ git config --get core.fsmonitor
    true
    ```

  ![core.editor](../../screenshot/git/git-for-windows-11.png)


## tig

> [!NOTE|label:references:]
> - [How to fix "fatal error: ncursesw/ncurses.h: No such file or directory"](https://www.xmodulo.com/fatal-error-ncursesw-ncurses-no-file-directory.html)
> - [tig : Installation instructions](https://jonas.github.io/tig/INSTALL.html)

```bash
# ubuntu
$ sudo apt-get install libncursesw5-dev
# centos/rhel
$ sudo yum install ncurses-devel

$ git clone git@github.com:jonas/tig.git ${iRCHOME}/utils/ && cd !$/tig
$ make -j prefix=/usr/local
$ sudo make install prefix=/usr/local

$ /usr/local/bin/tig --version
tig version 2.5.8-5-g1894954
ncursesw version 6.3.20211021
```
