<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [AND OR operator](#and-or-operator)
  - [SC2155](#sc2155)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## AND OR operator
### [SC2155](https://www.shellcheck.net/wiki/SC2235)
- problematic code:
  ```bash
  ([ "$x" ] || [ "$y" ]) && [ "$z" ]
  ```
- correct code:
  ```bash
  { [ "$x" ] || [ "$y" ]; } && [ "$z" ]
  ```
- example
  - [git-retag](https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/git-retag#L33)

