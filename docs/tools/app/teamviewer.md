<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [teamviewer installation. Inspired from Official Help](#teamviewer-installation-inspired-from-official-help)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### teamviewer installation. Inspired from [Official Help](http://www.teamviewer.com/en/help/363-How-do-I-install-TeamViewer-on-my-Linux-distribution.aspx#other)

- Add i386 architecture
  ```bash
  $ sudo dpkg --add-architecture i386
  $ sudo apt-get update
  ```
- download teamview deb
  ```bash
    $ wget http://downloadeu2.teamviewer.com/download/teamviewer_linux.deb
  ```
- install the dependency by `apt-get`
  ```bash
    $ sudo apt-get install -f
  ```

- install teamviewer by `dpkg`
  ```bash
  $ sudo dpkg -i teamviewer_linux.deb
  ```
