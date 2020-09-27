#!/bin/bash
# shellcheck disable=SC2039,SC1078,SC1079,SC2015
# =============================================================================
#   FileName : deploy.sh
#     Author : marslo.jiao@gmail.com
#    Created : 2020-09-27 22:03:34
# LastChange : 2020-09-27 22:03:34
# =============================================================================

target='.target_book'
book='_book'
branch='gh-pages'
remotes=$(git remote -v | sed -n -re 's:^origin\W*(\S+)\W*\(push\)$:\1:gp')
msg=$(git show HEAD --no-patch --format="%s")

# References:
#  - [WAOW! Complete explanations](https://stackoverflow.com/a/28938235/101831)
#  - [coloring functions](https://gist.github.com/inexorabletash/9122583)
# credit belongs to https://raw.githubusercontent.com/ppo/bash-colors/master/bash-colors.sh
c() {
  [ $# -eq 0 ] && echo "\033[0m" || echo "$1" | sed -E "s/(.)/‹\1›/g;s/([KRGYBMCW])/3\1/g;s/([krgybmcw])/4\1/g;s/S/22/;y/sufnKRGYBMCWkrgybmcw›/14570123456701234567m/;s/‹/\\\033[/g";
}


usage="""$(c B)deploy.sh - to quickly deploy _book/* into gh-pages branch $(c)
\nUSAGE:
\t$(c sG)$ $0 [help] [function name]$(c)
\nNOTICE:
\tAdd command $(c Y)'built'$(c) in ./package.json as below:
\t\t$(c u){$(c)
\t\t$(c u)  \"scripts\": {$(c)
\t\t$(c u)    \"built\": \"gitbook install && gitbook build\",$(c)
\t\t$(c u)  }$(c)
\t\t$(c u)}$(c)
\n\tMore details can be found by $(c Y)$ $0 info$(c)
\nEXAMPLE:
\n\tDeploy _book into remote repository gh-pages branch:
\t\t$(c Y)$ $0 doDeploy$(c)
\n\tShow current information:
\t\t$(c Y)$ $0 info$(c)
\nINDEPENDENT FUNCTION NAME:
"""

info="""
  $(c M)BASIC :$(c)
           $(c Y)temp dir$(c) : ${target}
  $(c Y)remote repository$(c) : ${remotes}
   $(c Y)branch to deploy$(c) : ${branch}
     $(c Y)commit message$(c) : ${msg}

  $(c M)NPM COMMANDS :$(c)
      $(c Y)npm run clean$(c) : $(grep \"clean\" package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')
      $(c Y)npm run built$(c) : $(grep \"built\" package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')
"""

function help()
{
  echo -e "${usage}"
  # ${GREP} '^function' $0 | sed -re "s:^function([^(.]*).*$:\t\1:g"
  declare -F -p | sed -re "s:^.*-f(.*)$:\t\1:g"
}

function info() {
  echo -e "${info}"
}

function build() {
  [ -d ./node_modules ] && rm -rf ./node_modules
  [ -d ./_book ] && rm -rf ./_book
  npm run built
}

function updateRepo() {
  if [ "$(git rev-parse remotes/origin/${branch})" != "$(git -C ${target} rev-parse HEAD)" ]; then
    git -C "${target}" fetch origin --force "${branch}"
    git -C "${target}" rebase -v refs/remotes/origin/${branch}
  fi
}

function cloneRepo() {
  git clone --single-branch --branch "${branch}" https://github.com/marslo/ibook.git "${target}"
}

function updateBook() {
  npm run built
  yes | cp -rf ${book}/* ${target}/

  pushd .
  cd "${target}" || exit

  git add --all .
  git commit -am "${msg}"
  git push origin gh-pages --force

  popd || return
}

function doDeploy() {
  if [ -d "${target}" ]; then
    updateRepo
  else
    mkdir -p "${target}" && cd "${target}" || exit
    cloneRepo
  fi
  updateBook
}

if [ "$1" = "help" ]; then
  help
else
  # if no parameters, then run all of default installation and configuration
  if [ $# -eq 0 ]; then
    info
    echo '-----------------------'
    help
  # execute specified the functions
  else
    for func do
      [ "$(type -t -- "$func")" = function ] && "$func"
    done
  fi
fi
