<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [environment in MacOS](#environment-in-macos)
  - [setup default python](#setup-default-python)
  - [`pip.conf`](#pipconf)
  - [list python path](#list-python-path)
  - [python libs](#python-libs)
  - [multiple versions](#multiple-versions)
- [version change](#version-change)
  - [modules re-installation](#modules-re-installation)
  - [`PYTHONPATH`](#pythonpath)
  - [`/usr/local/opt/python`](#usrlocaloptpython)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> reference:
> - [homebrew and python](https://docs.brew.sh/Homebrew-and-Python)
> - [Installing from local packages](https://pip.pypa.io/en/stable/user_guide/#installing-from-local-packages)
> - [pip list](https://pip.pypa.io/en/stable/reference/pip_list/)

## environment in MacOS
### [setup default python](https://github.com/Homebrew/homebrew-cask/issues/52128#issuecomment-424680522)
```bash
$ defaults write com.apple.versioner.python Version 3.8
```
### `pip.conf`
- user: `~/.pip/pip.conf`
- global: `/Library/Application Support/pip/pip.conf`
- list config:
  ```bash
  $ pip config list
  global.index-url='https://repo.my.com/artifactory/api/pypi/tools/simple'
  ```

- [`PIP_CONF_FILE`](https://pip.pypa.io/en/stable/user_guide/#configuration)
  ```bash
  $ export PIP_CONFIG_FILE=/path/to/pip.conf
  ```
- upgrade all outdated modules
  ```bash
  $ pip install --upgrade --user $(pip list --outdated | sed 1,2d | awk '{print $1}' | xargs)
  ```
  - with exclude
    ```bash
    $ pip3.9 install --upgrade --user $(pip3.9 list --outdated | sed 1,2d | awk '{print $1}' | grep -vw 'docker\|rich')
    ```

### [list python path](https://github.com/Homebrew/legacy-homebrew/issues/31873#issuecomment-53532229)
```bash
$ python -vv -c "import sys; print sys.path"
$ python -vvE -c "import sys; print sys.path"
$ python -vvEsS -c "import sys; print sys.path"
```

### python libs
- global
 ```bash
  $ ls -ld /usr/local/lib/python*/
  drwxr-xr-x 3 marslo admin 96 May 17  2019 /usr/local/lib/python2.7/
  drwxr-xr-x 3 marslo admin 96 May 17  2019 /usr/local/lib/python3.7/
  drwxr-xr-x 3 marslo admin 96 Jan 13  2020 /usr/local/lib/python3.8/
  drwxr-xr-x 3 marslo admin 96 Oct 10 17:06 /usr/local/lib/python3.9/

  $ ls -ld /Library/Python/2.7/site-packages/
  drwxr-xr-x 9 root wheel 288 Aug  6 18:16 /Library/Python/2.7/site-packages/
 ```
 - or
  ```bash
    $ ls $(brew --prefix)/lib/python*
    /usr/local/lib/python2.7:
    site-packages

    /usr/local/lib/python3.7:
    site-packages

    /usr/local/lib/python3.8:
    site-packages

    /usr/local/lib/python3.9:
    site-packages
  ```

- local
  ```bash
  $ ls -ld ~/Library/Python/*/
  drwx------ 4 marslo staff 128 Aug  6 17:23 /Users/marslo/Library/Python/2.7/
  drwx------ 5 marslo staff 160 Oct 12 21:17 /Users/marslo/Library/Python/3.7/
  drwx------ 5 marslo staff 160 Oct 27 19:24 /Users/marslo/Library/Python/3.8/
  drwx------ 5 marslo staff 160 Oct 27 19:24 /Users/marslo/Library/Python/3.9/
  ```
- how to check
  ```bash
  $ /usr/bin/python -c 'import site; print(site.USER_BASE)'
  /Users/marslo/Library/Python/2.7

  $ /usr/local/bin/python3.9 -c 'import site; print(site.USER_BASE)'
  /Users/marslo/Library/Python/3.9
  ```

### multiple versions
#### get current working version
```bash
$ CFLAGS=-I$(brew --prefix)/include LDFLAGS=-L$(brew --prefix)/lib pip --version
pip 20.2.4 from /Users/marslo/Library/Python/3.8/lib/python/site-packages/pip (python 3.8)
```
- or
  ```bash
  $ $(brew --prefix)/opt/python/libexec/bin/python -V
  Python 3.8.6
  ```

#### upgrade particular modules
```bash
$ sudo -H python3.9 -m pip install --upgrade pip
Collecting pip
  Using cached pip-20.2.4-py2.py3-none-any.whl (1.5 MB)
Installing collected packages: pip
  Attempting uninstall: pip
    Found existing installation: pip 20.2.3
    Uninstalling pip-20.2.3:
      Successfully uninstalled pip-20.2.3
Successfully installed pip-20.2.4
```
  - upgrade to previous version
  ```bash
  $ pip install --upgrade --no-cache-dir --pre pip
  ```

#### install all older version modules
```bash
$ /usr/local/bin/python3.8 -m pip freeze > pip3.8-requirements.txt
$ sudo -H /usr/local/bin/python3.9 -m pip install --pre -r pip3.8-requirements.txt
```
- reference:
  ```bash
  $ CFLAGS=-I$(brew --prefix)/include LDFLAGS=-L$(brew --prefix)/lib pip freeze
  beautifulsoup4==4.9.1
  certifi==2020.6.20
  cffi==1.14.1
  chardet==3.0.4
  click==7.1.2
  click-config-file==0.6.0
  colorama==0.4.3
  ...
  ```
  - or
    ```bash
    $ pip list --outdate --format=freeze
    docker==4.2.2
    rich==3.0.5

    $ pip list -o --format columns
    Package Version Latest Type
    ------- ------- ------ -----
    docker  4.2.2   4.3.1  wheel
    rich    3.0.5   9.1.0  whee

    $ pip list --outdate --format=json
    [{"name": "docker", "version": "4.2.2", "latest_version": "4.3.1", "latest_filetype": "wheel"}, {"name": "rich", "version": "3.0.5", "latest_version": "9.1.0", "latest_filetype": "wheel"}]
    ```

## version change
> change default python from `3.8` to `3.9`

### modules re-installation
```bash
$ /usr/local/bin/python3.8 -m pip freeze > pip3.8-requirements.txt
$ sudo -H /usr/local/bin/python3.9 -m pip install --pre -r pip3.8-requirements.txt
```

### `PYTHONPATH`
```bash
$ export PYTHONPATH="/usr/local/lib/python3.8/site-packages:$PYTHONPATH"

    |
    v
$ export PYTHONPATH="/usr/local/lib/python3.9/site-packages:$PYTHONPATH"
```

### `/usr/local/opt/python`
```bash
$ unlink /usr/local/opt/python
$ ln -sf /usr/local/Cellar/python@3.9/3.9.0 /usr/local/opt/python

$ unlink /usr/local/bin/python
$ ln -sf /usr/local/Cellar/python@3.9/3.9.0/bin/python3.9 /usr/local/bin/python3
$ ln -sf /usr/local/Cellar/python@3.9/3.9.0/bin/python3.9 /usr/local/bin/python

$ export PYTHONUSERBASE="$(/usr/local/opt/python/libexec/bin/python -c 'import site; print(site.USER_BASE)')"
$ export PYTHON3='/usr/local/opt/python/libexec/bin'
$ export PATH="$PYTHONUSERBASE/bin:${PYTHON3}:$PATH"
```
