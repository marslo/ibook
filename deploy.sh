#!/bin/bash
# shellcheck disable=SC2039
# =============================================================================
#   FileName : deploy.sh
#     Author : marslo.jiao@gmail.com
#    Created : 2020-09-27 22:03:34
# LastChange : 2020-09-27 22:03:34
# =============================================================================

target='./.target_book'
book='./_book'
branch='gh-pages'
remotes=$(git remote -v | sed -n -re 's:^origin\W*(\S+)\W*\(push\)$:\1:gp')
msg=$(git show HEAD --no-patch --format="%s")

usage="""USAGE:
\n\t$0 [help] [function name]
\nNOTICE:
\n\tAdd two commands 'clean' and 'built' in ./package.json.
\n\tDetails can be found by $ $0 info
\nEXAMPLE:
\n\tDeploy _book into remote repository gh-pages branch:
\n\t\t$0 doDeploy
\n\tShow current information:
\n\t\t$0 info

\n\nINDEPENDENT FUNCTION NAME:
"""

function help()
{
  echo -e "${usage}"
  # ${GREP} '^function' $0 | sed -re "s:^function([^(.]*).*$:\t\1:g"
  declare -F -p | sed -re "s:^.*-f(.*)$:\t\1:g"
}

function info() {
  echo -e """
    basic :
             temp dir : ${target}
    remote repository : ${remotes}
     branch to deploy : ${branch}
       commit message : ${msg}

    npm commands :
        npm run clean : $(grep \"clean\" package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')
        npm run built : $(grep \"built\" package.json  | sed -n -re 's/.*:\W*"([^"]+)".*$/\1/p')
  """
}

function build() {
  npm run clean
  gitbook install
  gitbook build
}

function updateRepo() {
  git -C "${target}" fetch origin --force "${branch}"
  git -C "${target}" rebase -v refs/remotes/origin/${branch}
}

function cloneRepo() {
  git clone --single-branch --branch "${branch}" https://github.com/marslo/ibook.git "${target}"
}

function updateBook() {
  npm run built
  cp -rf ${book}/* ${target}/

  push .
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
