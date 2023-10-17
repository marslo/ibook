#!/bin/bash
# shellcheck disable=SC1078,SC1079,SC2015,SC2216
# =============================================================================
#   FileName : deploy.sh
#     Author : marslo.jiao@gmail.com
#    Created : 2020-09-27 22:03:34
# LastChange : 2020-12-25 23:32:24
# =============================================================================

root="$(git rev-parse --show-toplevel)"
target="${root}/.target_book"
modules="${root}/node_modules"
book="${root}/_book"
branch='gh-pages'
# remotes=$(git remote -v | sed -n -re 's:^origin\W*(\S+)\W*\(push\)$:\1:gp')
remotes=$(git remote get-url origin)
msg=$(git --no-pager show HEAD --no-patch --format="%s")

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
\tadd command $(c Y)'built'$(c) in ./package.json as below:
\t\t$(c u){$(c)
\t\t$(c u)  \"scripts\": {$(c)
\t\t$(c u)    \"built\": \"gitbook install && gitbook build\",$(c)
\t\t$(c u)  }$(c)
\t\t$(c u)}$(c)
\n\tmore details can be found by $(c Y)$ $0 info$(c)
\nEXAMPLE:
\n\tdeploy _book into remote repository gh-pages branch:
\t\t$(c Y)$ $0 doDeploy$(c)
\n\tshow current information:
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
      $(c Y)npm run clean$(c)  : $(grep \"clean\"  "${root}"/package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')
      $(c Y)npm run built$(c)  : $(grep \"built\"  "${root}"/package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')
      $(c Y)npm run deploy$(c) : $(grep \"deploy\" "${root}"/package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')
"""

function help() {
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

function installModules() {
  [[ -d "${modules}" ]] || gitbook install
}

function rebuiltToc() {
  find "$(git rev-parse --show-toplevel)"/docs \
       -iname '*.md' \
       -not -path '**/SUMMARY.md' \
       -not -path '**/README.md' \
       -exec doctoc --github --maxlevel 3 {} \;
}

function rePush(){
  git add --all $(git rev-parse --show-toplevel)
  git commit --amend --no-edit
  git push -u --force origin $(git rev-parse --abbrev-ref HEAD)
}

function updateRepo() {
  if [ """$(git rev-parse remotes/origin/"${branch}")""" != """$(git -C "${target}" rev-parse HEAD)""" ]; then
    git -C "${target}" fetch origin --force "${branch}"
    # git -C "${target}" rebase -v refs/remotes/origin/${branch}
    git -C "${target}" reset --hard refs/remotes/origin/${branch}
    git -C "${target}" config user.email 'marslo.jiao@gmail.com'
    git -C "${target}" config user.name  'marslo'
  fi
}

function cloneRepo() {
  git clone --single-branch --branch "${branch}" https://github.com/marslo/ibook.git "${target}"
  git config user.email 'marslo.jiao@gmail.com'
  git config user.name  'marslo'
}

function updateBook() {
  pushd .
  cd "$(git rev-parse --show-toplevel)" || return

  if ! npm run built; then
    echo "ERROR: FAILED on gitbook build. Exiting."
    popd || return
    exit 1
  else
    yes | rm -rf "${target:?}"/*
    yes | cp -rf "${book}"/* "${target}"/

    cd "${target}" || exit

    git add --all .
    targetMsg=$(git show remotes/origin/gh-pages --no-patch --format="%s")
    if [ "${targetMsg}" = "${msg}" ]; then
      echo '~~> force push without create new commit: '
      git commit --amend --no-edit
    else
      git commit -am "${msg}"
    fi
    git push origin gh-pages --force

    popd || return
  fi
}

function doDeploy() {
  installModules
  rebuiltToc
  rePush

  if [ -d "${target}" ]; then
    updateRepo
  else
    mkdir -p "${target}" && cd "${target}" || exit
    cloneRepo
  fi
  updateBook
}

if [ "$1" = "help" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
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
