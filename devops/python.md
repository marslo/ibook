<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [install pip](#install-pip)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### install pip
#### from source code
```bash
$ curl https://bootstrap.pypa.io/get-pip.py | python [--no-setuptools] [--no-wheel]
# or
$ curl https://bootstrap.pypa.io/get-pip.py | python3.2
# or
$ curl https://bootstrap.pypa.io/get-pip.py | python - 'pip==8.0.0'
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
```bat
> python -m pip install --upgrade pip
```

#### from easy_install
```bash
$ cd <PythonInstallHome>\Scripts
$ easy_install pip
```
[or](https://pypi.org/project/ez_setup/#modal-close)
```bash
$ curl -fsSL https://files.pythonhosted.org/packages/ba/2c/743df41bd6b3298706dfe91b0c7ecdc47f2dc1a3104abeb6e9aa4a45fa5d/ez_setup-0.9.tar.gz | tar xzf - -C .
$ python ez_setup-0.9/ez_setup.py pip
```
