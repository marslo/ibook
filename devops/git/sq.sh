#!/bin/bash

C=$1
GIT_EDITOR="sed -i -e '2,$C s/^pick /s /'" git rebase -i HEAD~$C
