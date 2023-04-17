<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [location](#location)
  - [get locations](#get-locations)
- [list](#list)
- [default configuration](#default-configuration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [8.1 Customizing Git - Git Configuration](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)
{% endhint %}

## location

> [!NOTE|label:locations]
> - [Where system, global and local Git config files on Windows and Ubuntu Linux are](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/Where-system-global-and-local-Windows-Git-config-files-are-saved)
> - [git on Windows - location of configuration files](https://www.onwebsecurity.com/configuration/git-on-windows-location-of-global-configuration-file.html)
> 0


|      SCOPE     | WINDOWS                                     | UNIX-LIKE                      |
|:--------------:|---------------------------------------------|--------------------------------|
|     system     | `<install-path>\etc\gitconfig`              | `<install-path>/etc/gitconfig` |
| system example | `%LOCALAPPDATA%\Programs\Git\etc\gitconfig` | `/usr/local/etc/gitconfig`     |
|     global     | `%USERPROFILE%\.gitconfig`                  | `$HOME/.gitconfig`             |
|      local     | `<git-repo>\.git\config`                    | `<git-repo>/.git/config`       |
|    portable    | `%PROGRAMDATA%\Git\config`                  | -                              |

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

## list

- list all with scope
  ```bash
  $ git config --list --show-scope
  ```

- list origin
  ```bash
  $ git config --list --show-origin --show-scope
  ```

- list single scope only
  - list local only
    ```bash
    $ git config --list --local
    ```

  - list global
    ```bash
    $ git config --list --global
    ```

  - list system
    ```bash
    $ git config --list --system
    ```


## default configuration
- `core.editor`

  ![core.editor](../../screenshot/git/git-for-windows-2.png)

  - use vim ( the ubiqutos text editor ) as Git's default editor
    ```bash
    $ git config --get core.editor
    vim
    ```

- `init.defaultBranch`

  ![core.editor](../../screenshot/git/git-for-windows-3.png)


  - override the default branch name for new repositories
    ```bash
    $ git config --get init.defaultBranch
    development
    ```

- `core.autocrlf`

  ![core.editor](../../screenshot/git/git-for-windows-6.png)

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


- `pull.rebase`

  ![core.editor](../../screenshot/git/git-for-windows-8.png)

  ```bash
  $ git config --get pull.rebase
  true
  ```

- `core.fscache` & `core.symlinks`

  ![core.editor](../../screenshot/git/git-for-windows-10.png)

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

- `core.fsmonitor`

  ![core.editor](../../screenshot/git/git-for-windows-11.png)

  - enable experimental built-in file system monitor
    ```bash
    $ git config --get core.fsmonitor
    true
    ```
