#!/usr/bin/env bash

startMsg=$(git log -1 --pretty=format:'%s')
startRev=$(git log marslo --pretty="%h - %s" | grep "${startMsg}" | awk '{print $1}')
reversions=$(git rev-list marslo ${startRev}..origin/marslo | tac | xargs)

git cherry-pick $reversions
