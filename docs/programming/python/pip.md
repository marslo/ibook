<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [installation](#installation)
  - [install pip](#install-pip)
  - [cache dir and clean caches](#cache-dir-and-clean-caches)
  - [for global user (or non user)](#for-global-user-or-non-user)
  - [re-install package in `site.USER_BASE`](#re-install-package-in-siteuser_base)
  - [setup default python version](#setup-default-python-version)
  - [`index-url` & `extra-index-url`](#index-url--extra-index-url)
  - [list pip package with url](#list-pip-package-with-url)
  - [installing from local packages](#installing-from-local-packages)
- [config](#config)
  - [list all configs](#list-all-configs)
- [tricky](#tricky)
  - [get size of installed pip package](#get-size-of-installed-pip-package)
- [troubleshooting](#troubleshooting)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## installation

> [!NOTE|label:references:]
> - [Python Management and Project Dependencies](https://www.integralist.co.uk/posts/python-management/)

### install pip
#### from source code
```bash
$ curl https://bootstrap.pypa.io/get-pip.py | python [--no-setuptools] [--no-wheel]
# or
$ curl https://bootstrap.pypa.io/get-pip.py | python3.2
# or
$ curl https://bootstrap.pypa.io/get-pip.py | python - 'pip==8.0.0'
```

- python3.6
  ```bash
  $ python3 < <(curl -s https://bootstrap.pypa.io/pip/3.6/get-pip.py)
  ```

- [example](https://pip.pypa.io/en/stable/installing/#installing-with-get-pip-py)
  ```bash
  $ python get-pip.py --no-index --find-links=/local/copies
  $ python get-pip.py --user
  $ python get-pip.py --proxy="http://[user:passwd@]proxy.server:port"
  $ python get-pip.py pip==9.0.2 wheel==0.30.0 setuptools==28.8.0
  ```

#### upgrade pip
- linux
  ```bash
  $ [sudo [-H]] pip install --upgrade pip
  ```
- windows
  ```batch
  > python -m pip install --upgrade pip
  ```

#### from easy_install
```bash
$ cd <PythonInstallHome>\Scripts
$ easy_install pip
```
- [or](https://pypi.org/project/ez_setup/#modal-close)
  ```bash
  $ curl -fsSL https://files.pythonhosted.org/packages/ba/2c/743df41bd6b3298706dfe91b0c7ecdc47f2dc1a3104abeb6e9aa4a45fa5d/ez_setup-0.9.tar.gz | tar xzf - -C .
  $ python ez_setup-0.9/ez_setup.py pip
  ```

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

> [!NOTE]
> ```bash
> export PYTHONPATH="/usr/local/lib/python3.9/site-packages:$PYTHONPATH"
> ```

```bash
# load the user's $HOME/.pip/pip.conf
$ sudo python -m pip install <package-name>

# or
# CANNOT load the user's $HOME/.pip/pip.conf
$ sudo -H pip install <pacakge-name>
```

### [re-install package in `site.USER_BASE`](https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUSERBASE)

> [!NOTE]
> ```bash
> $ python -c 'import site; print(site.USER_BASE)'
> /Users/marslo/Library/Python/3.9
> ```
> - reference:
>   - [Can I force pip to reinstall the current version?](https://stackoverflow.com/a/19549035/2940319)

```bash
$ export PYTHONUSERBASE="$(python -c 'import site; print(site.USER_BASE)')"
$ pip install --upgrade --force-reinstall --user <package-name>
```

### [setup default python version](https://stackoverflow.com/a/7000324/2940319)
``` bash
# temporary
$ export VERSIONER_PYTHON_VERSION=3.9

$ defaults write com.apple.versioner.python Version 3.9
```

### `index-url` & `extra-index-url`

> [!NOTE]
> reference:
> - [pip wheel](https://pip.pypa.io/en/stable/reference/pip_wheel/)
> - [pip error looking for private package in pypi](https://stackoverflow.com/a/58199831/2940319)

```bash
$ pip config list
global.extra-index-url='https://private.artifactory.com/artifactory/api/pypi/pypi-dev/simple'
global.index-url='https://private.artifactory.com/artifactory/api/pypi/tools/simple'
```

### [list pip package with url](https://stackoverflow.com/a/46838082/2940319)

> [!NOTE]
> ```bash
> $ sudo yum install util-linux -y
> ```

```bash
$ pip list --format=freeze |
      cut -d= -f1 |
      xargs pip show |
      awk '/^Name/{printf $2} /^Home-page/{print ": "$2}' |
      column -t
beautifulsoup4:     http://www.crummy.com/software/BeautifulSoup/bs4/
certifi:            https://certifiio.readthedocs.io/en/latest/
cffi:               http://cffi.readthedocs.org
chardet:            https://github.com/chardet/chardet
click:              https://palletsprojects.com/p/click/
click-config-file:  http://github.com/phha/click_config_file
colorama:           https://github.com/tartley/colorama
commonmark:         https://github.com/rtfd/commonmark.py
compressed-rtf:     https://github.com/delimitry/compressed_rtf
configobj:          https://github.com/DiffSK/configobj
docker:             https://github.com/docker/docker-py
extract-msg:        https://github.com/mattgwwalker/msg-extractor
git-review:         http://docs.openstack.org/infra/git-review/
idna:               https://github.com/kjd/idna
IMAPClient:         https://github.com/mjs/imapclient/
Markdown:           https://Python-Markdown.github.io/
mdv:                http://github.com/axiros/terminal_markdown_viewer
meson:              https://mesonbuild.com
olefile:            https://www.decalage.info/python/olefileio
pip:                https://pip.pypa.io/
pprintpp:           https://github.com/wolever/pprintpp
psutil:             https://github.com/giampaolo/psutil
pycparser:          https://github.com/eliben/pycparser
Pygments:           https://pygments.org/
pytz:               http://pythonhosted.org/pytz
PyUserInput:        https://github.com/SavinaRoja/PyUserInput
requests:           https://requests.readthedocs.io
rich:               https://github.com/willmcgugan/rich
setuptools:         https://github.com/pypa/setuptools
six:                https://github.com/benjaminp/six
soupsieve:          https://github.com/facelessuser/soupsieve
ssdfw-scripts:      https://gerrit.sample.com/a/storage/ssdfw/devops/scripts/devkit
tabulate:           https://github.com/astanin/python-tabulate
typing-extensions:  https://github.com/python/typing/blob/master/typing_extensions/README.rst
tzlocal:            https://github.com/regebro/tzlocal
urllib3:            https://urllib3.readthedocs.io/
websocket-client:   https://github.com/websocket-client/websocket-client.git
wheel:              https://github.com/pypa/wheel
xattr:              http://github.com/xattr/xattr
```

### [installing from local packages](https://pip.pypa.io/en/stable/user_guide/#installing-from-local-packages)
- osx/unix
  ```bash
  $ python -m pip download --destination-directory DIR -r requirements.txt

  # --no-index && --find-links
  $ python -m pip install --no-index --find-links=DIR -r requirements.txt
  ```
- windows
  ```bash
  $ py -m pip download --destination-directory DIR -r requirements.txt

  # --no-index && --find-links
  $ py -m pip install --no-index --find-links=DIR -r requirements.txt
  ```

## config
### list all configs

> [!NOTE]
> - [pip config](https://pip.pypa.io/en/stable/cli/pip_config/)

```bash
# to check where config comes from
$ python -m pip config debug
env_var:
env:
global:
  /etc/xdg/pip/pip.conf, exists: False
  /etc/pip.conf, exists: True
    global.index-url: https://private.artifactory.com/artifactory/api/pypi/tools/simple
site:
  /usr/pip.conf, exists: False
user:
  /home/marslo/.pip/pip.conf, exists: False
  /home/marslo/.config/pip/pip.conf, exists: False
```

- or
  ```bash
  $ pip config -v list
  For variant 'global', will try loading '/Library/Application Support/pip/pip.conf'
  For variant 'user', will try loading '/Users/marslo/.pip/pip.conf'
  For variant 'user', will try loading '/Users/marslo/.config/pip/pip.conf'
  For variant 'site', will try loading '/usr/local/opt/python@3.11/Frameworks/Python.framework/Versions/3.11/pip.conf'
  ```

## tricky
### [get size of installed pip package](https://stackoverflow.com/a/60850841/2940319)
```bash
$ pip list |
      tail -n +3 |
      awk '{print $1}' |
      xargs pip show |
      grep --color=never -E 'Location:|Name:' |
      cut -d ' ' -f 2 |
      paste -d ' ' - - |
      awk '{print $2 "/" tolower($1)}' |
      xargs du -sh 2> /dev/null |
      sort -hr
124M  /Users/marslo/Library/Python/3.12/lib/python/site-packages/cmake
28M   /usr/local/lib/python3.12/site-packages/kubernetes
16M   /usr/local/lib/python3.12/site-packages/pip
13M   /usr/local/lib/python3.12/site-packages/ansible
9.9M  /usr/local/lib/python3.12/site-packages/cryptography
8.8M  /usr/local/lib/python3.12/site-packages/pygments
5.1M  /usr/local/lib/python3.12/site-packages/setuptools
1.5M  /usr/local/lib/python3.12/site-packages/msgpack
1.5M  /usr/local/lib/python3.12/site-packages/greenlet
1.3M  /usr/local/lib/python3.12/site-packages/pycparser
1.3M  /usr/local/lib/python3.12/site-packages/oauthlib
1.2M  /usr/local/lib/python3.12/site-packages/jinja2
948K  /usr/local/lib/python3.12/site-packages/pyasn1
848K  /usr/local/lib/python3.12/site-packages/cffi
824K  /Users/marslo/Library/Python/3.12/lib/python/site-packages/fortls
820K  /usr/local/lib/python3.12/site-packages/click
784K  /usr/local/lib/python3.12/site-packages/urllib3
556K  /usr/local/lib/python3.12/site-packages/wheel
556K  /Users/marslo/Library/Python/3.12/lib/python/site-packages/pynvim
520K  /usr/local/lib/python3.12/site-packages/tqdm
520K  /usr/local/lib/python3.12/site-packages/pipx
520K  /usr/local/lib/python3.12/site-packages/idna
456K  /usr/local/lib/python3.12/site-packages/requests
360K  /usr/local/lib/python3.12/site-packages/packaging
348K  /usr/local/lib/python3.12/site-packages/asciidoc
312K  /usr/local/lib/python3.12/site-packages/certifi
244K  /usr/local/lib/python3.12/site-packages/rsa
204K  /usr/local/lib/python3.12/site-packages/argcomplete
204K  /Users/marslo/Library/Python/3.12/lib/python/site-packages/json5
196K  /usr/local/lib/python3.12/site-packages/tabulate
156K  /usr/local/lib/python3.12/site-packages/distlib
140K  /usr/local/lib/python3.12/site-packages/resolvelib
96K   /usr/local/lib/python3.12/site-packages/argopt
88K   /usr/local/lib/python3.12/site-packages/cachetools
84K   /usr/local/lib/python3.12/site-packages/userpath
44K   /usr/local/lib/python3.12/site-packages/platformdirs
32K   /usr/local/lib/python3.12/site-packages/bashate
28K   /usr/local/lib/python3.12/site-packages/pbr
20K   /usr/local/lib/python3.12/site-packages/markupsafe
0     /usr/local/lib/python3.12/site-packages/virtualenv
0     /usr/local/lib/python3.12/site-packages/tbb
0     /usr/local/lib/python3.12/site-packages/openvino
0     /usr/local/lib/python3.12/site-packages/numpy
0     /usr/local/lib/python3.12/site-packages/filelock
0     /usr/local/lib/python3.12/site-packages/docutils
```

## troubleshooting

- `error: externally-managed-environment`

  > [!NOTE|label:references:]
  > - [pip(3) install，完美解决 externally-managed-environment](https://www.yaolong.net/article/pip-externally-managed-environment/)
  > - [Python教程：解决pip安装包时报错：error: externally-managed-environment This environment is externally managed](https://blog.csdn.net/a772304419/article/details/133469123)
  > - [How do I solve "error: externally-managed-environment" every time I use pip 3?](https://stackoverflow.com/a/76641565/2940319)
  > - [How to Fix the pip "externally-managed-environment" Error on Linux](https://www.makeuseof.com/fix-pip-error-externally-managed-environment-linux/)

  - issue
    ```bash
    $ pip install pipx
    error: externally-managed-environment

    × This environment is externally managed
    ╰─> To install Python packages system-wide, try brew install
        xyz, where xyz is the package you are trying to
        install.

        If you wish to install a non-brew-packaged Python package,
        create a virtual environment using python3 -m venv path/to/venv.
        Then use path/to/venv/bin/python and path/to/venv/bin/pip.

        If you wish to install a non-brew packaged Python application,
        it may be easiest to use pipx install xyz, which will manage a
        virtual environment for you. Make sure you have pipx installed.

    note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
    hint: See PEP 668 for the detailed specification.
    ```
  - solution
    ```bash
    $ mv $(brew --prefix python@3.12)/Frameworks/Python.framework/Versions/3.12/lib/python3.12/EXTERNALLY-MANAGED{,.bak}
    ```

- `Skipping ... due to invalid metadata entry 'name'`

  > [!NOTE|label:info]
  > - [changelog : 23.2 (2023-07-15)](https://pip.pypa.io/en/stable/news/#v23-2)
  >   Deprecate support for eggs for Python 3.11 or later, when the new importlib.metadata backend is used to load distribution metadata. This only affects the egg distribution format (with the .egg extension); distributions using the .egg-info metadata format (but are not actually eggs) are not affected. For more information about eggs, see [relevant section in the setuptools documentation](https://setuptools.pypa.io/en/stable/deprecated/python_eggs.html)

  - solution
    ```bash
    $ pip list
    WARNING: Skipping /usr/local/lib/python3.12/site-packages/six-1.16.0-py3.12.egg-info due to invalid metadata entry 'name'

    $ pip unisntall six
    $ rm -rf /usr/local/lib/python3.12/site-packages/six-1.16.0-py3.12.egg-info
    # if necessary
    $ rm -rf /usr/local/lib/python3.12/site-packages/six-1.16.0-py3.12.dist-info
    $ pip install six
    ```

- `has inconsistent version`

  > [!NOTE|label:references:]
  > - [pip has problems with metadata](https://stackoverflow.com/a/68126941/2940319)

  - solution
    ```bash
    $ python -m pip install --upgrade --no-cache-dir --use-deprecated=legacy-resolver <your_package>
    ```
