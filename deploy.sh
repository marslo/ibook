#!/usr/bin/env bash
# shellcheck source=/dev/null disable=SC1078,SC1079,SC2015,SC2216
# =============================================================================
#   FileName : deploy.sh
#     Author : marslo.jiao@gmail.com
#    Created : 2020-09-27 22:03:34
# LastChange : 2026-02-17 17:31:47
# =============================================================================

# @credit: https://github.com/ppo/bash-colors
# @usage:  or copy & paste the `c()` function from:
#          https://github.com/ppo/bash-colors/blob/master/bash-colors.sh#L3
# shellcheck disable=SC2015
test -f "${HOME}/.marslo/bin/bash-colors.sh" && source "${HOME}/.marslo/bin/bash-colors.sh" || { c() { :; }; }

root="$(git rev-parse --show-toplevel)"
target="${root}/.target_book"
modules="${root}/node_modules"
book="${root}/_book"
branch='gh-pages'
# declare remotes=$(git remote -v | sed -n -re 's:^origin\W*(\S+)\W*\(push\)$:\1:gp')
remotes=$(git remote get-url origin)
msg=$(git --no-pager show HEAD --no-patch --format="%s")
usage="""NAME
  $(c B)deploy.sh - to quickly deploy _book/* into gh-pages branch $(c)

USAGE
  $(c sG)$ $0 [help] [function name]$(c)

NOTICE
  add command $(c Y)'built'$(c) in $(c Csi)package.json$(c) as below:
  $(c Gi)\`\`\`json
  {
    \"scripts\": {
      \"built\": \"gitbook install && gitbook build\",
    }
  }
  \`\`\`$(c)
  more details can be found by $(c Y)$ $0 info$(c)

EXAMPLE
  $(c Wdi)# deploy _book into remote repository gh-pages branch$(c)
  $(c Y)$ $0 doDeploy$(c)

  $(c Wdi)# show current information$(c)
  $(c Y)$ $0 info$(c)

INDEPENDENT FUNCTION NAME
"""

info="""
  $(c M)BASIC INFO :$(c)
             $(c Wdi)[TEMP DIR]$(c) : $(c Ci)${target}$(c)
    $(c Wdi)[REMOTE REPOSITORY]$(c) : $(c Ci)${remotes}$(c)
     $(c Wdi)[BRANCH TO DEPLOY]$(c) : $(c Ci)${branch}$(c)
       $(c Wdi)[COMMIT MESSAGE]$(c) : $(c Ci)${msg}$(c)

  $(c M)NPM COMMANDS :$(c)
       $(c Wdi)$ npm run clean$(c)  : $(c Yi)$(grep \"clean\"  "${root}"/package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')$(c)
       $(c Wdi)$ npm run built$(c)  : $(c Yi)$(grep \"built\"  "${root}"/package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')$(c)
       $(c Wdi)$ npm run deploy$(c) : $(c Yi)$(grep \"deploy\" "${root}"/package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')$(c)
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

# to rebuilt for changed file only
function rebuiltToc() {
  # xargs doctoc --github --notitle --update-only --maxlevel 3 >/dev/null \
  #        < <( fd . "$(git rev-parse --show-toplevel)"/docs --type f --extension md --exclude SUMMARY.md --exclude README.md )
  xargs doctoc --github --notitle --update-only --maxlevel 3 >/dev/null \
        < <(git diff --name-only HEAD..HEAD^)
}

function rePush(){
  git add --all "$(git rev-parse --show-toplevel)"
  git commit --signoff --amend --no-edit --allow-empty
  git push -u --force origin "$(git rev-parse --abbrev-ref HEAD)"
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
    yes | cp -Rf "${book}"/* "${target}"/

    cd "${target}" || exit

    command -v pre-commit >/dev/null 2>&1 && test -f "$(git rev-parse --show-toplevel)/.pre-commit-config.yaml" && {
      pre-commit run --all-files
    }
    git add --all .
    targetMsg=$(git show remotes/origin/gh-pages --no-patch --format="%s")
    signed="$(git log -n1 --format='%(trailers:key=Signed-off-by,valueonly,separator=%x2C)' | command grep -q "$(git config user.email)"; echo $?)";
    [ 0 -ne "${signed}" ] && sopt='--signoff' || sopt='';
    if [ "${targetMsg}" = "${msg}" ]; then
      echo '~~> force push without create new commit: '
      eval "git commit ${sopt} --amend --no-edit --allow-empty"
    else
      eval "git commit ${sopt} -am '${msg}'"
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
    echo -e '-----------------------\n'
    help
  # execute specified the functions
  else
    for func do
      [ "$(type -t -- "$func")" = function ] && "$func"
    done
  fi
fi

# vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh
