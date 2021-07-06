<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [installation](#installation)
  - [cache dir and clean caches](#cache-dir-and-clean-caches)
  - [for global user (or non user)](#for-global-user-or-non-user)
  - [re-install package in `site.USER_BASE`](#re-install-package-in-siteuser_base)
  - [setup default python version](#setup-default-python-version)
  - [`index-url` & `extra-index-url`](#index-url--extra-index-url)
  - [list pip package with url](#list-pip-package-with-url)

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
> export PYTHONPATH="/usr/local/lib/python3.9/site-packages:$PYTHONPATH"
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
> /Users/marslo/Library/Python/3.9
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
$ export VERSIONER_PYTHON_VERSION=3.9

$ defaults write com.apple.versioner.python Version 3.9
```

### `index-url` & `extra-index-url`
> reference:
> - [pip wheel](https://pip.pypa.io/en/stable/reference/pip_wheel/)
> - [pip error looking for private package in pypi](https://stackoverflow.com/a/58199831/2940319)

```bash
$ pip config list
global.extra-index-url='https://private.artifactory.com/artifactory/api/pypi/pypi-dev/simple'
global.index-url='https://private.artifactory.com/artifactory/api/pypi/tools/simple'
```

### [list pip package with url]()
```bash
$ pip list --format=freeze |
      cut -d= -f1 |
      xargs pip show |
      awk '/^Name/{printf $2} /^Home-page/{print ": "$2}'
beautifulsoup4: http://www.crummy.com/software/BeautifulSoup/bs4/
certifi: https://certifiio.readthedocs.io/en/latest/
cffi: http://cffi.readthedocs.org
chardet: https://github.com/chardet/chardet
click: https://palletsprojects.com/p/click/
click-config-file: http://github.com/phha/click_config_file
colorama: https://github.com/tartley/colorama
commonmark: https://github.com/rtfd/commonmark.py
compressed-rtf: https://github.com/delimitry/compressed_rtf
configobj: https://github.com/DiffSK/configobj
docker: https://github.com/docker/docker-py
extract-msg: https://github.com/mattgwwalker/msg-extractor
git-review: http://docs.openstack.org/infra/git-review/
idna: https://github.com/kjd/idna
IMAPClient: https://github.com/mjs/imapclient/
Markdown: https://Python-Markdown.github.io/
mdv: http://github.com/axiros/terminal_markdown_viewer
meson: https://mesonbuild.com
olefile: https://www.decalage.info/python/olefileio
pip: https://pip.pypa.io/
pprintpp: https://github.com/wolever/pprintpp
psutil: https://github.com/giampaolo/psutil
pycparser: https://github.com/eliben/pycparser
Pygments: https://pygments.org/
pytz: http://pythonhosted.org/pytz
PyUserInput: https://github.com/SavinaRoja/PyUserInput
requests: https://requests.readthedocs.io
rich: https://github.com/willmcgugan/rich
setuptools: https://github.com/pypa/setuptools
six: https://github.com/benjaminp/six
soupsieve: https://github.com/facelessuser/soupsieve
ssdfw-scripts: https://vgitcentral.marvell.com/a/storage/ssdfw/devops/scripts/devkit
tabulate: https://github.com/astanin/python-tabulate
typing-extensions: https://github.com/python/typing/blob/master/typing_extensions/README.rst
tzlocal: https://github.com/regebro/tzlocal
urllib3: https://urllib3.readthedocs.io/
websocket-client: https://github.com/websocket-client/websocket-client.git
wheel: https://github.com/pypa/wheel
xattr: http://github.com/xattr/xattr
```
