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
- [remove](#remove)
  - [remove package and dependencies](#remove-package-and-dependencies)
- [download](#download)
- [config](#config)
  - [options](#options)
  - [list all configs](#list-all-configs)
  - [samples](#samples)
  - [Authentication](#authentication)
- [tricky](#tricky)
  - [argcomplete](#argcomplete)
  - [get size of installed pip package](#get-size-of-installed-pip-package)
- [pipx](#pipx)
  - [setup pipx](#setup-pipx)
  - [show info](#show-info)
  - [examles](#examles)
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

  # or - https://github.com/Homebrew/homebrew-core/blob/master/Formula/p/python%403.13.rb#L324
  $ python3 -Im pip install -v --no-index --upgrade --isolated \
    --target=/usr/local/lib/python3.13/site-packages \
    /usr/local/Cellar/python@3.13/3.13.2/Frameworks/Python.framework/Versions/3.13/lib/python3.13/ensurepip/_bundled/pip-25.0-py3-none-any.whl \
    /usr/local/Cellar/python@3.13/3.13.2/libexec/wheel-0.45.1-py3-none-any.whl
  ```
- windows
  ```batch
  > python -m pip install --upgrade pip
  ```

#### from easy_install
```bash
$ cd /path/to/install/home/Scripts
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

> [!NOTE|label:references:]
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

> [!NOTE|label:references:]
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

## remove

### [remove package and dependencies](https://stackoverflow.com/a/27713702/2940319)
```bash
$ pip install pip-autoremove
# or
$ python3 -m pip install pip-autoremove

# remove package and dependencies
$ pip-autoremove <package-name> -y
```

- [another solution](https://stackoverflow.com/a/78038667/2940319)
  ```python
  # pip-uninstall-with-dependencies.py

  #
  # usage: python pip-uninstall-with-dependencies.py pkg1 [pkg2 ...]
  #

  from sys import argv
  from pip._internal.commands.show import search_packages_info
  from pip._internal.cli.main import main
  from typing import List, Dict

  if len(argv) < 2:
      print(f"Usage: {argv[0]} pkg1 [pkg2 ...]")
      exit(1)

  def get_dependency_tree(packages: List[str], candidates: Dict[str, List[str]] = dict()) -> Dict[str, List[str]]:
      for package in packages:
          if not candidates.get(package):
              pkg_info = next(search_packages_info([package]))
              candidates[package] = pkg_info.required_by
              for package in pkg_info.requires:
                  get_dependency_tree([package])

      return candidates

  candidates = get_dependency_tree(argv[1:])

  # eliminate required
  for package in list(candidates):
      diff = set(candidates[package]).difference(list(candidates))
      if diff:
          print(f"Package {package} cannot be removed, it is required by {diff}")
          del candidates[package]

  print("Uninstalling packages and dependencies:", *candidates)
  for package in candidates:
      main(['uninstall', '-y', package])
  ```

## download

> [!NOTE|label:references:]
> - [Is there a way to list pip dependencies/requirements?](https://stackoverflow.com/a/38531949/2940319)
> - [使用pip下载非Python包资源](https://blog.csdn.net/Long_xu/article/details/135117395)
> - [pip下载python依赖包](https://zhuanlan.zhihu.com/p/674000491)

## config

### [options](https://pip.pypa.io/en/latest/cli/pip_install/#options)

| PARAMETER                    | VALUE                         | ENVIRONMENT VARIABLE                                              |
|------------------------------|-------------------------------|-------------------------------------------------------------------|
| `-r`, `--requirement`        | `<file>`                      | `PIP_REQUIREMENT`                                                 |
| `-c`, `--constraint`         | `<file>`                      | `PIP_CONSTRAINT`                                                  |
| `--no-deps`                  | -                             | `PIP_NO_DEPS`, `PIP_NO_DEPENDENCIES`                              |
| `--pre`                      | -                             | `PIP_PRE`                                                         |
| `-e`, `--editable`           | `<path/url>`                  | `PIP_EDITABLE`                                                    |
| `--dry-run`                  | -                             | `PIP_DRY_RUN`                                                     |
| `-t`, `--target`             | `<dir>`                       | `PIP_TARGET`                                                      |
| `--platform`                 | `<platform>`                  | `PIP_PLATFORM`                                                    |
| `--python-version`           | `<version>`                   | `PIP_PYTHON_VERSION`                                              |
| `--implementation`           | `<implementation>`            | `PIP_IMPLEMENTATION`                                              |
| `--abi`                      | `<abi>`                       | `PIP_ABI`                                                         |
| `--user`                     | -                             | `PIP_USER`                                                        |
| `--root`                     | `<dir>`                       | `PIP_ROOT`                                                        |
| `--prefix`                   | `<dir>`                       | `PIP_PREFIX`                                                      |
| `--src`                      | `<dir>`                       | `PIP_SRC`, `PIP_SOURCE`, `PIP_SOURCE_DIR`, `PIP_SOURCE_DIRECTORY` |
| `-U`, `--upgrade`            | -                             | `PIP_UPGRADE`                                                     |
| `--upgrade-strategy`         | **`only-if-needed`**, `eager` | `PIP_UPGRADE_STRATEGY`                                            |
| `--force-reinstall`          | -                             | `PIP_FORCE_REINSTALL`                                             |
| `-I`, `--ignore-installed`   | -                             | `PIP_IGNORE_INSTALLED`                                            |
| `--ignore-requires-python`   | -                             | `PIP_IGNORE_REQUIRES_PYTHON`                                      |
| `--no-build-isolation`       | -                             | `PIP_NO_BUILD_ISOLATION`                                          |
| `--use-pep517`               | -                             | `PIP_USE_PEP517`                                                  |
| `--check-build-dependencies` | -                             | `PIP_CHECK_BUILD_DEPENDENCIES`                                    |
| `--break-system-packages`    | -                             | `PIP_BREAK_SYSTEM_PACKAGES`                                       |
| `-C`, `--config-setting`     | `<settings>`                  | `PIP_CONFIG_SETTING`                                              |
| `--global-option`            | `<options>`                   | `PIP_GLOBAL_OPTION`                                               |
| `--compile`                  | -                             | `PIP_COMPILE`                                                     |
| `--no-compile`               | -                             | `PIP_NO_COMPILE`                                                  |
| `--no-warn-script-location`  | -                             | `PIP_NO_WARN_SCRIPT_LOCATION`                                     |
| `--no-warn-conflicts`        | -                             | `PIP_NO_WARN_CONFLICTS`                                           |
| `--no-binary`                | `:all`, `:none`               | `PIP_NO_BINARY`                                                   |
| `--only-binary`              | `:all`, `:none`               | `PIP_ONLY_BINARY`                                                 |
| `--prefer-binary`            | -                             | `PIP_PREFER_BINARY`                                               |
| `--require-hashes`           | -                             | `PIP_REQUIRE_HASHES`                                              |
| `--progress-bar`             | **`on`**, `off`, `raw`        | `PIP_PROGRESS_BAR`                                                |
| `--root-user-action`         | **`warn`**, `ignore`          | `PIP_ROOT_USER_ACTION`                                            |
| `--report`                   | `<file>`                      | `PIP_REPORT`                                                      |
| `--no-clean`                 | -                             | `PIP_NO_CLEAN`                                                    |
| `-i`, `--index-url`          | `<url>`                       | `PIP_INDEX_URL`                                                   |
| `--extra-index-url`          | `<url>`                       | `PIP_EXTRA_INDEX_URL`                                             |
| `--no-index`                 | -                             | `PIP_NO_INDEX`                                                    |
| `-f`, `--find-links`         | `<url>`                       | `PIP_FIND_LINKS`                                                  |


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
  For variant 'global', will try loading '/opt/homebrew/share/pip:/Library/Application Support/pip/pip.conf'
  For variant 'user', will try loading '/Users/marslo/.pip/pip.conf'
  For variant 'user', will try loading '/Users/marslo/.config/pip/pip.conf'
  For variant 'site', will try loading '/opt/homebrew/opt/python@3.13/Frameworks/Python.framework/Versions/3.13/pip.conf'
  :env:.break-system-packages='true'
  global.break-system-package='true'

  $ echo $PIP_BREAK_SYSTEM_PACKAGES
  true
  ```

### samples

> [!NOTE|label:references:]
> - [Configuration](https://pip.pypa.io/en/stable/topics/configuration/)

- `--ignore-installed`
  ```bash
  [install]
  ignore-installed = true
  ```

- `--no-dependencies`
  ```bash
  [install]
  no-dependencies = yes
  ```

- `--no-compile`
  ```bash
  [install]
  no-compile = yes
  ```

- `--no-warn-script-location`
  ```bash
  [install]
  no-warn-script-location = yes
  ```

- `--no-cache-dir`
  ```bash
  [global]
  no-cache-dir = yes
  ```

- `--verbose` and `--quiet`

  > [!NOTE|label:references:]
  > - `verbose`: `export PIP_VERBOSE=<n>` == `pip install [-v, -vv, -vvv, -vvvv]`
  >   - 0: no output
  >   - 1: print only errors
  >   - 2: print errors and warnings
  >   - 3: print errors, warnings, and info
  >   - 4: print everything

  ```bash
  [global]
  verbose = 2
  quiet = 0
  ```

- `--trusted-host`
  ```bash
  [install]
  trusted-host =
      mirror1.example.com
      mirror2.example.com
  ```

- `--find-links`
  ```bash
  [global]
  find-links =
      http://download.example.com

  [install]
  find-links =
      http://mirror1.example.com
      http://mirror2.example.com
  ```

### [Authentication](https://pip.pypa.io/en/stable/topics/authentication/)

## tricky
### argcomplete
```bash
$ python3 -m pip install -U argcomplete

$ sudo mkdir -p $(brew --prefix)/etc/bash_completion.d
$ activate-global-python-argcomplete --dest=$(brew --prefix)/etc/bash_completion.d

$ grep bash_completion.sh ~/.bash_profile ~/.bashrc
/Users/marslo/.bash_profile:  [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh"      ]] && source "$(brew --prefix)/etc/profile.d/bash_completion.sh"

# enable completion for pipx
echo 'eval "$(register-python-argcomplete pipx)"' >> ~/.bashrc
```

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

## pipx

> [!NOTE|label:references:]
> - [pipx](https://pipx.pypa.io/stable/)

### setup pipx
```bash
$ python3 -m pip install pipx
$ pipx ensurepath
$ pipx install ansible --include-deps

# re-install pipx if system python version changed
$ pipx reinstall-all --python /bin/python3.11
# or
$ pipx reinstall-all --python "$(command -v python3)"

# -- upgrade pipx -- #
$ python3 -m pip install --user --upgrade pipx
```

### show info
```bash
$ pipx environment
```

### [examles](https://pipx.pypa.io/stable/examples/)
- [pipx install](https://pipx.pypa.io/stable/examples/#pipx-install-examples)
  ```bash
  $ pipx install pycowsay
  $ pipx install --python python3.10 pycowsay
  $ pipx install --python 3.12 pycowsay
  $ pipx install --fetch-missing-python --python 3.12 pycowsay
  $ pipx install git+https://github.com/psf/black
  $ pipx install git+https://github.com/psf/black.git@branch-name
  $ pipx install git+https://github.com/psf/black.git@git-hash
  $ pipx install git+ssh://<username>@<private-repo-domain>/<path-to-package.git>
  $ pipx install https://github.com/psf/black/archive/18.9b0.zip
  $ pipx install black[d]
  $ pipx install --preinstall ansible-lint --preinstall mitogen ansible-core
  $ pipx install 'black[d] @ git+https://github.com/psf/black.git@branch-name'
  $ pipx install --suffix @branch-name 'black[d] @ git+https://github.com/psf/black.git@branch-name'
  $ pipx install --include-deps jupyter
  $ pipx install --pip-args='--pre' poetry
  $ pipx install --pip-args='--index-url=<private-repo-host>:<private-repo-port> --trusted-host=<private-repo-host>:<private-repo-port>' private-repo-package
  $ pipx install --index-url https://test.pypi.org/simple/ --pip-args='--extra-index-url https://pypi.org/simple/' some-package
  $ pipx --global install pycowsay
  $ pipx install .
  $ pipx install path/to/some-project
  ```

- [pipx install-all](https://pipx.pypa.io/stable/examples/#pipx-install-all-example)
  ```bash
  $ pipx list --json > pipx.json
  $ pipx instal-all pipx.json
  ```

- [pipx run](https://pipx.pypa.io/stable/examples/#pipx-run-examples)
  ```bash
  $ pipx run BINARY  # latest version of binary is run with python3
  $ pipx run --spec PACKAGE==2.0.0 BINARY  # specific version of package is run
  $ pipx run --python python3.10 BINARY  # Installed and invoked with specific Python version
  $ pipx run --python python3.9 --spec PACKAGE=1.7.3 BINARY
  $ pipx run --spec git+https://url.git BINARY  # latest version on default branch is run
  $ pipx run --spec git+https://url.git@branch BINARY
  $ pipx run --spec git+https://url.git@hash BINARY
  $ pipx run pycowsay moo
  $ pipx --version  # prints pipx version
  $ pipx run pycowsay --version  # prints pycowsay version
  $ pipx run --python pythonX pycowsay
  $ pipx run pycowsay==2.0 --version
  $ pipx run pycowsay[dev] --version
  $ pipx run --spec git+https://github.com/psf/black.git black
  $ pipx run --spec git+https://github.com/psf/black.git@branch-name black
  $ pipx run --spec git+https://github.com/psf/black.git@git-hash black
  $ pipx run --spec https://github.com/psf/black/archive/18.9b0.zip black --help
  $ pipx run https://gist.githubusercontent.com/cs01/fa721a17a326e551ede048c5088f9e0f/raw/6bdfbb6e9c1132b1c38fdd2f195d4a24c540c324/pipx-demo.py
  ```

- [pipx inject](https://pipx.pypa.io/stable/examples/#pipx-inject-example)
  ```bash
  $ pipx install ptpython
  $ pipx inject ptpython requests pendulum
  ```

- [pipx upgrade-shared](https://pipx.pypa.io/stable/examples/#pipx-upgrade-shared-examples)
  ```bash
  $ pipx upgrade-shared
  $ pipx upgrade-shared --pip-args=pip==24.0
  ```

## troubleshooting

- `error: externally-managed-environment`

  > [!NOTE|label:references:]
  > - [Python 3.11, pip and (breaking) system packages](https://veronneau.org/python-311-pip-and-breaking-system-packages.html)
  >   - [pip environment variable](https://pip.pypa.io/en/stable/topics/configuration/#environment-variables)
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
  - solution: [ignore by pip.config](https://stackoverflow.com/a/75722775/2940319)

    > [!TIP|label:rerefences:]
    > - `pip.config`:
    >   - `~/.pip/pip.conf`
    >   - `~/.config/pip/pip.conf`
    > - check pip config:
    >   ```bash
    >   $ python3 -m pip config debug
    >   env_var:
    >   env:
    >   global:
    >     /opt/homebrew/share/pip:/Library/Application Support/pip/pip.conf, exists: False
    >   site:
    >     /opt/homebrew/opt/python@3.13/Frameworks/Python.framework/Versions/3.13/pip.conf, exists: False
    >   user:
    >     /Users/marslo/.pip/pip.conf, exists: True
    >       global.break-system-package: true
    >     /Users/marslo/.config/pip/pip.conf, exists: False
    >   ```

    ```bash
    # setup by command
    $ python3 -m pip config set global.break-system-packages true

    # or added manually
    $ cat ~/.pip/pip.conf
    [global]
    break-system-package = true
    ```

  - solution: via option temporary
    ```bash
    $ python3 -m pip install --upgrade pip --break-system-packages

    # or
    $ python3 -m pip install --upgrade pip --system-site-packages
    ```

  - solution: via environment vaiable
    ```bash
    $ export PIP_BREAK_SYSTEM_PACKAGES=true
    $ python3 -m pip install --upgrade pip

    # or
    $ PIP_BREAK_SYSTEM_PACKAGES=true python3 -m pip install --upgrade pip
    ```

  - solution: remove EXTERNALLY-MANAGED file
    ```bash
    # 3.12
    $ mv $(brew --prefix python@3.12)/Frameworks/Python.framework/Versions/3.12/lib/python3.12/EXTERNALLY-MANAGED{,.bak}
    # 3.13
    $ mv $(brew --prefix python@3.13)/Frameworks/Python.framework/Versions/3.13/lib/python3.13/EXTERNALLY-MANAGED{,.bak}
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
