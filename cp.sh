#!/usr/bin/env bash

branch='marslo'

git fetch --all --force
git fetch --force origin "${branch}":remotes/origin/"${branch}"
git fetch --prune --prune-tags --force origin

startMsg=$(git log -1 --pretty=format:'%s')
startRev=$(git log origin/"${branch}" --pretty="%h - %s" | grep "${startMsg}" | awk '{print $1}')
reversions=$(git rev-list origin/"${branch}" "${startRev}"..origin/"${branch}" | tac | xargs)

if [ -z "${reversions}" ]; then
  echo "no commits between master and ${branch} branch. Exit."
else
  git cherry-pick "${reversions}"
  git push -u --force origin master
fi

# vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh
