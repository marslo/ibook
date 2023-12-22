<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Q&A](#qa)
  - [`pkg_resources.VersionConflict`](#pkg_resourcesversionconflict)
  - [`ImportError: No module named pkg_resources`](#importerror-no-module-named-pkg_resources)
  - [`No module named pip`](#no-module-named-pip)
  - [python install with `tcl-tk`](#python-install-with-tcl-tk)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## Q&A
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

  - install `setuptools==39.1.0` and [`xattr==0.6.4`](http://qpypi.qpython.org/repository/121480/xattr-0.6.4.tar.gz#1bef31afb7038800f8d5cfa2f4562b37)
    ```bash
    $ sudo -H python -m pip install --upgrade pip setuptools wheel
    $ sudo -H /usr/bin/python -m pip uninstall -y setuptools

    $ /usr/bin/python -m pip install --user setuptools==39.1.0
    DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7.
    Collecting setuptools==39.1.0
    Installing collected packages: setuptools
      Found existing installation: setuptools 41.0.1
        Uninstalling setuptools-41.0.1:
          Successfully uninstalled setuptools-41.0.1
    Successfully installed setuptools-39.1.0

    $ curl -fsSL https://raw.githubusercontent.com/marslo/ibook/master/programming/python/xattr-0.6.4.tar.gz -o xattr-0.6.4.tar.gz
    $ /usr/bin/python -m pip install --user xattr-0.6.4.tar.gz
    DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7.
    Processing ./xattr-0.6.4.tar.gz
    Building wheels for collected packages: xattr
      Building wheel for xattr (setup.py) ... done
      Stored in directory: /Users/marslo/Library/Caches/pip/wheels/63/db/04/be8c6e423b8158e30b1d63992368c899811286844edf41ce32
    Successfully built xattr
    Installing collected packages: xattr
      WARNING: The script xattr is installed in '/Users/marslo/Library/Python/2.7/bin' which is not on PATH.
      Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
    Successfully installed xattr-0.6.4
    ```

  result:
    ```bash
    $ /usr/bin/xattr -h
    usage: xattr [-lz] file [file ...]
           xattr -p [-lz] attr_name file [file ...]
           xattr -w [-z] attr_name attr_value file [file ...]
           xattr -d attr_name file [file ...]

    The first form lists the names of all xattrs on the given file(s).
    The second form (-p) prints the value of the xattr attr_name.
    The third form (-w) sets the value of the xattr attr_name to attr_value.
    The fourth form (-d) deletes the xattr attr_name.

    options:
      -h: print this help
      -l: print long format (attr_name: attr_value)
      -z: compress or decompress (if compressed) attribute value in zip format

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
    setuptools                   39.1.0
    six                          1.12.0
    tabulate                     0.8.3
    urllib3                      1.25.3
    websocket-client             0.56.0
    wheel                        0.33.4
    xattr                        0.6.4
    ```

  - reinstall `xattr==0.6.4` for global [if necessary]
    ```bash
    $ sudo -H /usr/bin/python -m pip install xattr-0.6.4.tar.gz
    DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7.
    Processing /Users/marslo/Desktop/xattr-0.6.4.tar.gz
    Building wheels for collected packages: xattr
      Building wheel for xattr (setup.py) ... error
      ERROR: Complete output from command /System/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python -u -c 'import setuptools, tokenize;__file__='"'"'/private/tmp/pip-req-build-dVgPOl/setup.py'"'"';f=getattr(tokenize, '"'"'open'"'"', open)(__file__);code=f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' bdist_wheel -d /private/tmp/pip-wheel-ZV80PW --python-tag cp27:
      ERROR: usage: -c [global_opts] cmd1 [cmd1_opts] [cmd2 [cmd2_opts] ...]
         or: -c --help [cmd1 cmd2 ...]
         or: -c --help-commands
         or: -c cmd --help

      error: invalid command 'bdist_wheel'
      ----------------------------------------
      ERROR: Failed building wheel for xattr
      Running setup.py clean for xattr
    Failed to build xattr
    Installing collected packages: xattr
      Found existing installation: xattr 0.6.4
        Uninstalling xattr-0.6.4:
          Successfully uninstalled xattr-0.6.4
      Running setup.py install for xattr ... done
    Successfully installed xattr-0.6.4
    ```

### `No module named pip`
- issue
  ```bash
  $ sudo -H /usr/bin/python -m pip install --upgrade pip setuptools wheel
  /System/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python: No module named pip
  ```

- [solution](https://stackoverflow.com/a/46631019/2940319)
  ```bash
  $ sudo -H /usr/bin/python -m ensurepip --default-pip
  Looking in links: /tmp/tmpkmqQV6
  Requirement already satisfied: setuptools in /Library/Python/2.7/site-packages (39.1.0)
  Collecting pip
  Installing collected packages: pip
  Successfully installed pip-18.1
  ```

- verify
  ```bash
  $ sudo /usr/bin/python -m pip install --upgrade pip setuptools wheel
  DEPRECATION: Python 2.7 reached the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 is no longer maintained. pip 21.0 will drop support for Python 2.7 in January 2021. More details about Python 2 support in pip can be found at https://pip.pypa.io/en/latest/development/release-process/#python-2-support pip 21.0 will remove support for this functionality.
  WARNING: The directory '/Users/marslo/Library/Caches/pip' or its parent directory is not owned or is not writable by the current user. The cache has been disabled. Check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
  Looking in indexes: https://my.artifactory.dev.com/artifactory/api/pypi/tools/simple
  Requirement already up-to-date: pip in /Users/marslo/Library/Python/2.7/lib/python/site-packages (20.2.4)
  Requirement already up-to-date: setuptools in /Users/marslo/Library/Python/2.7/lib/python/site-packages (44.1.1)
  Requirement already up-to-date: wheel in /Users/marslo/Library/Python/2.7/lib/python/site-packages (0.35.1)

  $ ls -Altrh /System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python
  ```

- alternatives
  > [get-pip.py](https://pip.pypa.io/en/stable/installing/)

  ```bash
  $ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  $ /usr/bin/python get-pip.py
  ```


### [python install with `tcl-tk`](https://stackoverflow.com/a/60469243/2940319)
```bash
$ export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
$ export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
$ export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
$ export PKG_CONFIG_PATH="/usr/local/opt/tcl-tk/lib/pkgconfig"
$ brew reinstall python
```
