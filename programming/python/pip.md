<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [issues](#issues)
  - [`pkg_resources.VersionConflict`](#pkg_resourcesversionconflict)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## issues

### `pkg_resources.VersionConflict`

- issue

```bash
$ sudo -H pip install --upgrade pip
...

$ pip --version
Traceback (most recent call last):
  File "/usr/local/lib/python3.7/site-packages/pkg_resources/__init__.py", line 584, in _build_master
    ws.require(__requires__)
  File "/usr/local/lib/python3.7/site-packages/pkg_resources/__init__.py", line 901, in require
    needed = self.resolve(parse_requirements(requirements))
  File "/usr/local/lib/python3.7/site-packages/pkg_resources/__init__.py", line 792, in resolve
    raise VersionConflict(dist, req).with_context(dependent_req)
pkg_resources.VersionConflict: (pip 20.1.1 (/Users/marslo/Library/Python/3.7/lib/python/site-packages), Requirement.parse('pip==20.0.2'))

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/usr/local/opt/python/bin/pip3", line 6, in <module>
    from pkg_resources import load_entry_point
  File "/usr/local/lib/python3.7/site-packages/pkg_resources/__init__.py", line 3254, in <module>
    @_call_aside
  File "/usr/local/lib/python3.7/site-packages/pkg_resources/__init__.py", line 3238, in _call_aside
    f(*args, **kwargs)
  File "/usr/local/lib/python3.7/site-packages/pkg_resources/__init__.py", line 3267, in _initialize_master_working_set
    working_set = WorkingSet._build_master()
  File "/usr/local/lib/python3.7/site-packages/pkg_resources/__init__.py", line 586, in _build_master
    return cls._build_from_requirements(__requires__)
  File "/usr/local/lib/python3.7/site-packages/pkg_resources/__init__.py", line 599, in _build_from_requirements
    dists = ws.resolve(reqs, Environment())
  File "/usr/local/lib/python3.7/site-packages/pkg_resources/__init__.py", line 787, in resolve
    raise DistributionNotFound(req, requirers)
pkg_resources.DistributionNotFound: The 'pip==20.0.2' distribution was not found and is required by the application


$ which -a pip
/usr/local/opt/python/libexec/bin/pip
/usr/local/bin/pip
$ la /usr/local/opt/python/libexec/bin/pip
lrwxr-xr-x 1 marslo staff 14 Jul  6 18:23 /usr/local/opt/python/libexec/bin/pip -> ../../bin/pip3

$ /usr/local/opt/python/bin/pip3 --version
Traceback (most recent call last):
  File "/usr/local/lib/python3.7/site-packages/pkg_resources/__init__.py", line 584, in _build_master
    ws.require(__requires__)
  File "/usr/local/lib/python3.7/site-packages/pkg_resources/__init__.py", line 901, in require
    needed = self.resolve(parse_requirements(requirements))
  File "/usr/local/lib/python3.7/site-packages/pkg_resources/__init__.py", line 792, in resolve
    raise VersionConflict(dist, req).with_context(dependent_req)
pkg_resources.VersionConflict: (pip 20.1.1 (/Users/marslo/Library/Python/3.7/lib/python/site-packages), Requirement.parse('pip==20.0.2'))
....
```

- solution

```bash
$ which -a pip
/usr/local/opt/python/libexec/bin/pip
/usr/local/bin/pip

$ la /usr/local/opt/python/libexec/bin/pip
lrwxr-xr-x 1 marslo staff 14 Jul  6 18:23 /usr/local/opt/python/libexec/bin/pip -> ../../bin/pip3

$ which -a pip3
/usr/local/bin/pip3
/usr/bin/pip3
```

  * `ln -sf`

  ```bash
  $ mv /usr/local/opt/python/bin/pip3{,.bak}
  $ ln -sf /usr/local/bin/pip3 /usr/local/opt/python/bin/pip3
  ```

  * [`re-install`](https://github.com/Homebrew/homebrew-core/issues/43867#issuecomment-529194418)

  ```bash
  $ brew reinstall python
  $ sudo rm -rf /usr/local/lib/python3.7/site-packages/pip/

  $ brew postinstall python
  $ pip --version
  pip 20.0.2 from /usr/local/lib/python3.7/site-packages/pip (python 3.7)

  $ sudo -H python3 -m pip install --force-reinstall pip
  $ pip --version
  pip 20.1.1 from /usr/local/lib/python3.7/site-packages/pip (python 3.7)
  ```


### `ImportError: No module named pkg_resources`

- precondition:
  ```bash
  $ which -a python
  /usr/local/opt/python/libexec/bin/python
  /usr/bin/python

  $ realpath /usr/bin/python
  /System/Library/Frameworks/Python.framework/Versions/2.7/bin/python2.7
  ```

- issue
  ```bash
  $ /usr/bin/xattr
  Traceback (most recent call last):
    File "/usr/bin/xattr", line 8, in <module>
      from pkg_resources import load_entry_point
  ImportError: No module named pkg_resources
  ```

- [solution](https://github.com/Homebrew/homebrew-cask/issues/69660#issuecomment-535778324)
  - restore `~/Library/Python/2.7`
    ```bash
    $ mkdir -p ~/Library/Python/2.7/lib/python
    $ cp -r /usr/local/lib/python2.7/site-packages ~/Library/Python/2.7/lib/python/
    $ sudo chown -R $(whoami):staff ~/Library/Python/2.7

    # or
    $ sudo chown -R $USER:$(id -g) /Users/$USER/Library/Python
    ```
    result:
    ```bash
    $ /usr/bin/python -m pip list
    DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7.
    Package                      Version
    ---------------------------- ---------
    backports.ssl-match-hostname 3.7.0.1
    certifi                      2019.6.16
    chardet                      3.0.4
    Click                        7.0
    click-config-file            0.5.0
    colorama                     0.4.1
    configobj                    5.0.6
    docker                       4.0.2
    idna                         2.8
    ipaddress                    1.0.22
    Markdown                     3.1.1
    mdv                          1.7.4
    pip                          19.1.1
    Pygments                     2.4.2
    requests                     2.22.0
    setuptools                   41.0.1
    six                          1.12.0
    ssdfw-scripts                1.2.2
    tabulate                     0.8.3
    urllib3                      1.25.3
    websocket-client             0.56.0
    wheel                        0.33.4

    $ /usr/bin/xattr
    Traceback (most recent call last):
      File "/usr/bin/xattr", line 8, in <module>
        from pkg_resources import load_entry_point
      File "/Users/marslo/Library/Python/2.7/lib/python/site-packages/pkg_resources/__init__.py", line 3241, in <module>
        @_call_aside
      File "/Users/marslo/Library/Python/2.7/lib/python/site-packages/pkg_resources/__init__.py", line 3225, in _call_aside
        f(*args, **kwargs)
      File "/Users/marslo/Library/Python/2.7/lib/python/site-packages/pkg_resources/__init__.py", line 3254, in _initialize_master_working_set
        working_set = WorkingSet._build_master()
      File "/Users/marslo/Library/Python/2.7/lib/python/site-packages/pkg_resources/__init__.py", line 583, in _build_master
        ws.require(__requires__)
      File "/Users/marslo/Library/Python/2.7/lib/python/site-packages/pkg_resources/__init__.py", line 900, in require
        needed = self.resolve(parse_requirements(requirements))
      File "/Users/marslo/Library/Python/2.7/lib/python/site-packages/pkg_resources/__init__.py", line 786, in resolve
        raise DistributionNotFound(req, requirers)
    pkg_resources.DistributionNotFound: The 'xattr==0.6.4' distribution was not found and is required by the application
    ```

  - install `setuptools==39.1.0`
    ```bash
    [$ sudo -H python -m pip install --upgrade pip setuptools wheel]
    [$ sudo -H /usr/bin/python -m pip uninstall -y setuptools]

    $ /usr/bin/python -m pip install --user setuptools==39.1.0
    DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7.
    Looking in indexes: https://ssdfw-repo-dev.marvell.com/artifactory/api/pypi/tools/simple
    Collecting setuptools==39.1.0
      Using cached https://ssdfw-repo-dev.marvell.com/artifactory/api/pypi/tools/packages/8c/10/79282747f9169f21c053c562a0baa21815a8c7879be97abd930dbcf862e8/setuptools-39.1.0-py2.py3-none-any.whl
    Installing collected packages: setuptools
      Found existing installation: setuptools 41.0.1
        Uninstalling setuptools-41.0.1:
          Successfully uninstalled setuptools-41.0.1
    Successfully installed setuptools-39.1.0
    ```

    result:
      ```bash
      $ /usr/bin/xattr
      Traceback (most recent call last):
        File "/usr/bin/xattr", line 8, in <module>
          from pkg_resources import load_entry_point
        File "/Users/marslo/Library/Python/2.7/lib/python/site-packages/pkg_resources/__init__.py", line 3086, in <module>
          @_call_aside
        File "/Users/marslo/Library/Python/2.7/lib/python/site-packages/pkg_resources/__init__.py", line 3070, in _call_aside
          f(*args, **kwargs)
        File "/Users/marslo/Library/Python/2.7/lib/python/site-packages/pkg_resources/__init__.py", line 3099, in _initialize_master_working_set
          working_set = WorkingSet._build_master()
        File "/Users/marslo/Library/Python/2.7/lib/python/site-packages/pkg_resources/__init__.py", line 574, in _build_master
          ws.require(__requires__)
        File "/Users/marslo/Library/Python/2.7/lib/python/site-packages/pkg_resources/__init__.py", line 892, in require
          needed = self.resolve(parse_requirements(requirements))
        File "/Users/marslo/Library/Python/2.7/lib/python/site-packages/pkg_resources/__init__.py", line 778, in resolve
          raise DistributionNotFound(req, requirers)
      pkg_resources.DistributionNotFound: The 'xattr==0.6.4' distribution was not found and is required by the application
      ```

  - reinstall `xattr==0.6.4`
    ```bash
    
    ```


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
