<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [docker completion](#docker-completion)
  - [OSX](#osx)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## docker completion

### OSX
```bash
bashComp="$(brew --prefix)/etc/bash_completion.d"
dApp="/Applications/Docker.app"
dmver='0.16.2'
gitcontent='https://raw.githubusercontent.com'
dm="${gitcontent}/docker/machine/v${dmver}/contrib/completion/bash/docker-machine.bash"
curlOpt='-x 127.0.0.1:1087 -fsSL'

brew install bash-completion

for _i in docker.bash-completion docker-compose.bash-completion; do
  ln -s ${dApp}/Contents/Resources/etc/${_i} ${bashComp}/${_i}
done

sudo curl ${curlOpt} ${dm} --output ${bashComp}/docker-machine.bash

cat > ~/.bash_profile << EOF
if command -v brew > /dev/null && [ -f "${bashComp}" ]; then
  # bash-completion
  export BASH_COMPLETION_COMPAT_DIR="${bashComp}"
  source "${bashComp}"
fi
EOF
```
