

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

  * `re-install`

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
