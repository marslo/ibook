<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [installation](#installation)
  - [cache dir and clean caches](#cache-dir-and-clean-caches)
  - [for global user (or non user)](#for-global-user-or-non-user)
  - [re-install package in `site.USER_BASE`](#re-install-package-in-siteuser_base)
  - [setup default python version](#setup-default-python-version)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## installation

### [cache dir and clean caches](https://stackoverflow.com/a/61762308/2940319)
- clean cache (`[pip cache](https://pip.pypa.io/en/stable/reference/pip_cache/)`)
  ```bash
  $ pip cache purge
  $ pip cache remove matplotlib
  ```
- set no cache (`[pip config](https://pip.pypa.io/en/stable/reference/pip_config/)`)
  ```bash
  $ pip install --no-cache-dir <pkg-name>

  # or
  $ pip config set global.cache-dir false
  ```


### for global user [(or non user)](https://docs.python.org/3/using/cmdline.html#envvar-PYTHONNOUSERSITE)
> ```bash
> export PYTHONPATH="/usr/local/lib/python3.8/site-packages:$PYTHONPATH"
> ```

```bash
# load the user's $HOME/.pip/pip.conf
$ sudo python -m pip install <package-name>
```
or

```bash
# CANNOT load the user's $HOME/.pip/pip.conf
$ sudo -H pip install <pacakge-name>
```

### [re-install package in `site.USER_BASE`](https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUSERBASE)
> ```bash
> $ python -c 'import site; print(site.USER_BASE)'
> /Users/marslo/Library/Python/3.8
> ```

```bash
$ export PYTHONUSERBASE="$(python -c 'import site; print(site.USER_BASE)')"
$ pip install --upgrade --force-reinstall --user <package-name>
```
- reference:
  - [Can I force pip to reinstall the current version?](https://stackoverflow.com/a/19549035/2940319)

### [setup default python version](https://stackoverflow.com/a/7000324/2940319)
``` bash
# temporary
$ export VERSIONER_PYTHON_VERSION=3.8

$ defaults write com.apple.versioner.python Version 3.8
```
