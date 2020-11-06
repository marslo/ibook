<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [brew](#brew)
  - [force the link and overwrite everything](#force-the-link-and-overwrite-everything)
  - [rerurn postinstall](#rerurn-postinstall)
  - [check brew configure file](#check-brew-configure-file)
  - [whatprovide alternatives](#whatprovide-alternatives)
  - [tricky](#tricky)

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

### whatprovide alternatives
```bash
$ pkgutil --file-info /usr/bin/qlmanage
volume: /
path: /usr/bin/qlmanage

pkgid: com.apple.pkg.Core
pkg-version: 10.15.0.1.1.1569789135
install-time: 1570542610
uid: 0
gid: 0
mode: 755
```
- for brew formula
  ```bash
  $ while read formula; do brew list --formula "${formula}" | grep -w magick; done < <(brew list --formula)
  ```

### tricky
> reference:
> - [Tips and Tricks](https://docs.brew.sh/Tips-N'-Tricks)

- interactive homebrew shell
  ```bash
  $ brew irb
  ==> Interactive Homebrew Shell
  Example commands available with: brew irb --examples

  WARNING: This version of ruby is included in macOS for compatibility with legacy software. 
  In future versions of macOS the ruby runtime will not be available by 
  default, and may require you to install an additional package.

  irb(main):001:0>
  ```
