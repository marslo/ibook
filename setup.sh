#!/usr/bin/env bash

set -euo pipefail

declare OLD_PATH="$PATH"

if [[ 'Darwin' = "$(uname)" ]]; then
  export PATH="$HOME/.nvm/versions/node/v12.22.12/bin/:$PATH"
  echo ".. debug info:"
  node --version
  npm --version
  gitbook install --log=debug --debug
  npm install gitbook-plugin-codegroup@^2.3.5
  gitbook install --log=debug --debug
elif [[ -f /etc/os-release ]] && [[ 'ubuntu' = $(awk -F '=' '/^ID=/ { print $2 }' /etc/os-release) ]]; then
  export PATH="/opt/node/node-v12.22.12-linux-x64/bin/:$PATH"
  echo ".. debug info:"
  node --version
  npm --version
  gitbook install
  npm install gitbook-plugin-codegroup@^2.3.5
  gitbook install
fi

export PATH="$OLD_PATH"

# vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh
