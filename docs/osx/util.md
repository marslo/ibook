<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [brew](#brew)
  - [force the link and overwrite everything](#force-the-link-and-overwrite-everything)
  - [rerurn postinstall](#rerurn-postinstall)
  - [check brew configure file](#check-brew-configure-file)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## brew

### force the link and overwrite everything
```bash
$ brew link --overwrite <formula>
```
- example
  ```bash
  $ brew link --overwrite --dry-run python@3.8
  Would remove:
  /usr/local/bin/python3 -> /usr/local/Cellar/python@3.9/3.9.0/bin/python3.9

  If you need to have this software first in your PATH instead consider running:
    echo 'export PATH="/usr/local/opt/python@3.8/bin:$PATH"' >> /Users/marslo/.bash_profile
  ```

### rerurn postinstall
```bash
$ brew postinstall <formula>
```

- i.e.:
  ```bash
  $ sudo chown marslo:admin -R /usr/local/lib/python3.8/site-packages
  $ brew postinstall python@3.8
  ==> Postinstalling python@3.8
  ==> /usr/local/Cellar/python@3.8/3.8.6_1/bin/python3 -s setup.py --no-user-cfg install --force --verbose --install-scripts=/usr/local/Cellar/python@3.8
  ==> /usr/local/Cellar/python@3.8/3.8.6_1/bin/python3 -s setup.py --no-user-cfg install --force --verbose --install-scripts=/usr/local/Cellar/python@3.8
  ==> /usr/local/Cellar/python@3.8/3.8.6_1/bin/python3 -s setup.py --no-user-cfg install --force --verbose --install-scripts=/usr/local/Cellar/python@3.8
  ```

### check brew configure file
```bash
$ brew -v edit <formula>
```

- i.e.: `$ brew -v edit openjdk`
  ![brew -v](../screenshot/osx/brew-v.png)

#### manual install formula
```bash
$ brew -v edit macvim
$ brew -v fetch --deps macvim
$ brew -v install --build-from-source macvim
$ brew pin macvim
```
