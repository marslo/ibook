#!/usr/bin/env bash
# shellcheck source=/dev/null disable=SC2155
# =============================================================================
#   FileName : deploy.sh
#     Author : marslo
#    Created : 2020-09-27 22:03:34
# LastChange : 2026-08-26 14:20:32
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
declare remotes=$(git remote get-url origin)
declare msg=$(git --no-pager show HEAD --no-patch --format="%s")
usage="NAME
  $(c 0B)deploy.sh - to quickly deploy _book/* into gh-pages branch $(c)

USAGE
  $(c 0Gs)$ $0 [help] [function name]$(c)

NOTICE
  add command $(c Y)'built'$(c) in $(c 0Csi)package.json$(c) as below:
  $(c 0Gi)\`\`\`json
  {
    \"scripts\": {
      \"built\": \"gitbook install && gitbook build\",
    }
  }
  \`\`\`$(c)
  more details can be found by $(c Y)$ $0 info$(c)

EXAMPLE
  $(c 0Wdi)# deploy _book into remote repository gh-pages branch$(c)
  $(c 0Y)$ $0 doDeploy$(c)

  $(c 0Wdi)# show current information$(c)
  $(c 0Y)$ $0 info$(c)

INDEPENDENT FUNCTION NAME
"

info="
  $(c 0M)BASIC INFO :$(c)
               $(c 0Wdi)TEMP DIR$(c) : $(c 0Ci)${target}$(c)
      $(c 0Wdi)REMOTE REPOSITORY$(c) : $(c 0Ci)${remotes}$(c)
       $(c 0Wdi)BRANCH TO DEPLOY$(c) : $(c 0Ci)${branch}$(c)
         $(c 0Wdi)COMMIT MESSAGE$(c) : $(c 0Ci)${msg}$(c)

  $(c 0M)NPM COMMANDS :$(c)
       $(c 0Wdi)$ npm run clean$(c)  : $(c 0Yi)$(grep \"clean\"  "${root}"/package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')$(c)
       $(c 0Wdi)$ npm run built$(c)  : $(c 0Yi)$(grep \"built\"  "${root}"/package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')$(c)
       $(c 0Wdi)$ npm run deploy$(c) : $(c 0Yi)$(grep \"deploy\" "${root}"/package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')$(c)
"

function help() {
  echo -e "${usage}"
  # ${GREP} '^function' $0 | sed -re "s:^function([^(.]*).*$:\t\1:g"
  declare -F -p | sed -re "s:^.*-f(.*)$:\t\1:g"
}

function info() { echo -e "${info}"; }

function build() {
  test -d ./node_modules && rm -rf ./node_modules
  test -d ./_book && rm -rf ./_book
  npm run built
}

function installModules() {
  test -d "${modules}" || gitbook install
}

# to rebuilt for changed file only
function rebuiltToc() {
  # xargs doctoc --github --notitle --update-only --maxlevel 3 >/dev/null \
  #        < <( fd . "$(git rev-parse --show-toplevel)"/docs --type f --extension md --exclude SUMMARY.md --exclude README.md )
  xargs doctoc --github --notitle --update-only --maxlevel 3 >/dev/null < <(git diff --name-only --diff-filter=AMCT 'HEAD..HEAD^')
}

function rePush(){
  git add --all "$(git rev-parse --show-toplevel)"
  git commit --signoff --amend --no-edit --allow-empty
  git push -u --force origin HEAD:"$(git rev-parse --abbrev-ref HEAD)"
}

function updateRepo() {
  if [[ """$(git rev-parse remotes/origin/"${branch}")""" != """$(git -C "${target}" rev-parse HEAD)""" ]]; then
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
    echo -e "$(c 0Rs)ERROR$(c): $(c 0Wi)FAILED on gitbook build. Exiting.$(c)"
    popd || return
    exit 1
  else
    command rm -rf "${target:?}"/*
    command cp -Rf "${book}"/* "${target}"/
    # command cp -f "${root}"/docs/linux/vnc/vnc-runbook.html "${target}"/linux/vnc/vnc-runbook.html

    cd "${target}" || exit

    command -v pre-commit >/dev/null 2>&1 && test -f "$(git rev-parse --show-toplevel)/.pre-commit-config.yaml" && {
      # color.diff=always forces ANSI into pre-commit's piped `git diff`, which activates colormoved+allow-indentation-change and hangs on large diffs:
      # == -c color.diff=auto -c diff.colormoved=no pre-commit run --all-files
      GIT_CONFIG_COUNT=2 \
      GIT_CONFIG_KEY_0=color.diff      GIT_CONFIG_VALUE_0=auto \
      GIT_CONFIG_KEY_1=diff.colormoved GIT_CONFIG_VALUE_1=no \
      pre-commit run --all-files
    }
    git add --all .

    targetMsg=$(git --no-pager show remotes/origin/gh-pages --no-color --no-patch --format="%s")
    local -a cmd=(git commit)
    git log -1 --format='%(trailers:key=Signed-off-by,valueonly,separator=%x2C)' |
        command grep -q "$(git config user.email)" || cmd+=('--signoff')

    if [[ "${targetMsg}" = "${msg}" ]]; then
      echo -e "$(c 0Ci)~~> force push without create new commit:$(c)"
      cmd+=(--amend --no-edit --allow-empty)
    else
      cmd+=(-am "${msg}")
    fi

    "${cmd[@]}"
    git push -u origin HEAD:refs/heads/gh-pages --force

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
      [ "$(type -t -- "${func}")" = function ] && "${func}"
    done
  fi
fi

# vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh
