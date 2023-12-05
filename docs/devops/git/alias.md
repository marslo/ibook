<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [basic](#basic)
- [pretty show](#pretty-show)
- [branch](#branch)
- [commit and push](#commit-and-push)
- [find alias](#find-alias)
- [get Change-Ids](#get-change-ids)
- [revision count](#revision-count)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [Must Have Git Aliases: Advanced Examples](https://www.durdn.com/blog/2012/11/22/must-have-git-aliases-advanced-examples/)
> - [mwhite/git-aliases.md](https://gist.github.com/mwhite/6887990)
> - [How to make bash as default shell in git alias?](https://stackoverflow.com/a/73163369/2940319)

### basic
```
[alias]
  aa          = add --all
  st          = status -sb
  sts         = status
  rb          = rebase
  co          = checkout --force --recurse-submodules
  cb          = rev-parse --abbrev-ref HEAD
  cl          = clean -dffx
  cn          = clone --recurse-submodules --tags
  cp          = cherry-pick
  wc          = whatchanged
  gca         = gc --aggressive
  fa          = fetch --prune --prune-tags --force --all
  ma          = merge --all --progress
  psa         = push origin --all
  pst         = push origin --tags
  root        = rev-parse --show-toplevel
  first       = rev-list --max-parents=0 HEAD
  last        = cat-file commit HEAD
  undo        = reset HEAD~1 --mixed
  ### [c]onflict [f]ile
  cf          = "! bash -c 'grep --color=always -rnw \"^<<<<<<< HEAD$\"'"
  # [c]onflict [f]ile [n]ame
  cfn         = diff --name-only --diff-filter=U --relative

  # statistics
  # get line changer statistic
  impact            = "!git ls-files -z \
                            | xargs -0n1 git blame -w \
                            | perl -n -e '/^.*?\\((.*?)\\s+[\\d]{4}/; print $1,\"\\n\"' \
                            | sort -f \
                            | uniq -c \
                            | sort -nr"
```

### pretty show
```
[alias]
  ### [p]retty [t]ag
  ls          = log --stat --pretty=short --graph
  ### [p]retty [l]og(s)
  pl          = !git --no-pager log --color --graph --pretty=tformat:'%C(red)%h%C(reset) -%C(yellow)%d%C(reset) %s %C(green)(%cr) %C(blue)<%an>%C(reset)' --abbrev-commit --date=relative --max-count=3
  pls         = log --color --graph --pretty=tformat:'%C(red)%h%C(reset) -%C(yellow)%d%C(reset) %s %C(green)(%cr)%C(reset) %C(blue)<%an>%C(reset)' --abbrev-commit --date=relative
  ### [p]revious branch [p]retty [l]og
  ppl         = !git --no-pager log --color --graph --pretty=tformat:'%C(red)%h%C(reset) -%C(yellow)%d%C(reset) %s %C(green)(%cr) %C(blue)<%an>%C(reset)' --abbrev-commit --date=relative --max-count=3 @{-1}
  ### [f]ull [p]retty [l]log
  fpl         = log --color --graph --pretty=tformat:'%C(red)%H%C(reset) -%C(yellow)%d%C(reset) %s %C(green)(%cr)%C(reset) %C(blue)<%an>%C(reset)' --abbrev-commit --date=relative
  ### Showing all branches and their relationshps
  tree        = log --color --graph --pretty=oneline --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --decorate --abbrev-commit --all
  clog        = log --color --graph --all --decorate --simplify-by-decoration --oneline
  ### [p]retty [t]ag(s)
  pt          = "! git for-each-ref --sort=-taggerdate refs/tags --format='%(color:red)%(objectname:short)%(color:reset) - %(align:left,38)%(color:bold yellow)[%(objecttype) : %(refname:short)]%(color:reset)%(end) %(subject) %(color:green)(%(if)%(taggerdate)%(then)%(taggerdate:format:%Y-%m-%d %H:%M:%S)%(else)%(committerdate:format:%Y-%m-%d %H:%M:%S)%(end))%(color:reset) %(color:blue)%(if)%(taggername)%(then)<%(taggername)>%(else)<%(committername)>%(end)%(color:reset)' --color --count=10"
  pts         = "! git for-each-ref --sort=-taggerdate refs/tags --format='%(color:red)%(objectname:short)%(color:reset) - %(color:bold yellow)[%(objecttype) : %(refname:short)]%(color:reset) - %(subject) %(color:green)(%(if)%(taggerdate)%(then)%(taggerdate:format:%Y-%m-%d %H:%M:%S)%(else)%(committerdate:format:%Y-%m-%d %H:%M:%S)%(end))%(color:reset) %(color:blue)%(if)%(taggername)%(then)<%(taggername)>%(else)<%(committername)>%(end)%(color:reset)' --color"
  # https://stackoverflow.com/a/53535353/2940319
  ### [p]retty [b]ranch(s)
  pb          = "! git for-each-ref refs/heads refs/remotes --sort=-committerdate --format='%(color:red)%(objectname:short)%(color:reset) - %(color:bold yellow)%(committerdate:format:%Y-%m-%d %H:%M:%S)%(color:reset) - %(align:left,20)%(color:cyan)<%(authorname)>%(color:reset)%(end) %(color:bold red)%(if)%(HEAD)%(then)* %(else)  %(end)%(color:reset)%(refname:short)' --color --count=10"
  pbs         = "! git for-each-ref refs/heads refs/remotes --sort=-committerdate --format='%(color:red)%(objectname:short)%(color:reset) - %(color:bold yellow)%(committerdate:format:%Y-%m-%d %H:%M:%S)%(color:reset) - %(align:left,20)%(color:cyan)<%(authorname)>%(color:reset)%(end) %(color:bold red)%(if)%(HEAD)%(then)* %(else)  %(end)%(color:reset)%(refname:short)' --color"
  ### sort local/remote branch via committerdate (DESC). usage: $ git recent; $ git recent remotes 10
  recent      = "!f() { \
                        declare help=\"USAGE: git recent [remotes|tags] [count]\"; \
                        declare refs; \
                        declare count; \
                        if [ 2 -lt $# ]; then \
                          echo \"${help}\"; \
                          exit 1; \
                        else \
                          if [ 'remotes' = \"$1\" ]; then \
                            refs='refs/remotes/origin'; \
                          elif [ 'tags' = \"$1\" ]; then \
                            refs='refs/tags'; \
                          elif [ 1 -eq $# ]; then \
                            count=$1; \
                          fi; \
                          if [ 2 -eq $# ]; then \
                            count=$2; \
                          fi; \
                        fi; \
                        git for-each-ref \
                            --sort=-committerdate \
                            ${refs:='refs/heads'} \
                            --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) %(color:green)(%(committerdate:relative))%(color:reset)' \
                            --color=always \
                            --count=${count:=5}; \
                    }; f \
                "
```

### branch
```
[alias]
  ### [s]ort [b]ranch
  sb          = "! git branch --sort=-committerdate --format='%(HEAD) %(color:red)%(objectname:short)%(color:reset) - %(color:yellow)%(refname:short)%(color:reset) - %(subject) %(color:bold green)(%(committerdate:relative))%(color:reset) %(color:blue)<%(authorname)>%(color:reset)' --color=always"
  # [c]urrent [b]ranch
  rbr         = "! f(){ git branch -ra | grep $1; }; f"
```

### commit and push
```
[alias]
  # [c]ommit -[a]m
  ca          = "!f() { \
                        git add --all $(git rev-parse --show-toplevel) ; \
                        git commit -am \"$1\" ; \
                      }; f \
                "
  ### [c]omm[i]t --[a]mend
  cia         = "!f() { \
                        declare authorDate=\"${GIT_AUTHOR_DATE}\"; \
                        declare commiterDate=\"${GIT_COMMITTER_DATE}\"; \
                        OPT='commit --amend --allow-empty'; \
                        if [ 0 -eq $# ]; then \
                          git ${OPT} ; \
                        else \
                          if [ \"o\" == \"$1\" ] || [ \"original\" == \"$1\" ]; then \
                            declare dd=\"$(git log -n 1 --format=%aD)\"; \
                            export GIT_AUTHOR_DATE=\"${dd}\"; \
                            export GIT_COMMITTER_DATE=\"${dd}\"; \
                            git ${OPT} --date=\"${dd}\" -m \"${@:2}\" ; \
                          else \
                            git ${OPT} -m \"$@\" ; \
                          fi; \
                          unset GIT_AUTHOR_DATE; \
                          unset GIT_COMMITTER_DATE; \
                        fi; \
                      }; f \
                "
  ### [m]arslo force [p]ush
  mp          = "! bash -c 'while read branch; do \n\
                              echo -e \"\\033[1;33m~~> ${branch}\\033[0m\" \n\
                              git add --all $(git rev-parse --show-toplevel) \n\
                              git commit --amend --no-edit \n\
                              if [ 'meta/config' == \"${branch}\" ]; then \n\
                                git push -u --force origin HEAD:refs/meta/config \n\
                                git fetch origin --force refs/meta/config:refs/remotes/origin/meta/config ; \n\
                                git reset --hard remotes/origin/${branch} ; \n\
                              else \n\
                                git push -u --force origin ${branch} \n\
                              fi \n\
                            done < <(git rev-parse --abbrev-ref HEAD) \n\
                           ' \n\
                "


```

### find alias
```
[alias]
  # https://stackoverflow.com/q/53841043/2940319
  ### show [g]it alia[s]
  as         = "! bash -c '''grep --no-group-separator -A1 -e \"^\\s*###\" \"$HOME\"/.marslo/.gitalias | \n\
                              awk \"END{if((NR%2))print p}!(NR%2){print\\$0p}{p=\\$0}\" | \n\
                              sed -re \"s/( =)(.*)(###)/*/g\" | \n\
                              sed -re \"s:[][]::g\" | \n\
                              awk -F* \"{printf \\\"\\033[1;33m%-20s\\033[0m » \\033[0;34m%s\\033[0m\\n\\\", \\$1, \\$2}\" | \n\
                              sort \n\
                          ''' \n\
                "
  # https://brettterpstra.com/2014/08/04/shell-tricks-one-git-alias-to-rule-them-all/
  ### [find] [a]lias by keywords
  finda = "!grepalias() { git config --get-regexp alias | \
                          grep -i \"$1\" | \
                          awk -v nr=2 '{ \
                                         sub(/^alias\\./,\"\") }; \
                                         {printf \"\\033[31m%15s :\\033[1;37m\", $1}; \
                                         {sep=FS}; \
                                          { for (x=nr; x<=NF; x++) {printf \"%s%s\", sep, $x; }; print \"\\033[0;39m\" \
                                      }'; \
                        }; grepalias"
```


### get Change-Ids
```
[alias]
  ### [c]hange-[i][d]
  cid             = "!f() { \
                            ref='HEAD'; \
                            if [ 0 -ne $# ]; then ref=\"$@\"; fi; \
                            echo \"\\033[1;33m~~> Commit-Id : Change-Id :\\033[0m\"; \
                            git --no-pager log -1 --no-color ${ref} | \
                                sed -nr 's!^commit\\s*(.+)$!\\1!p; s!^\\s*Change-Id:\\s*(.*$)!\\1!p' | \
                                awk '{ key=$0; getline; print key \" : \" $0; }'; \
                          }; f \
                    "
  ### [c]hange-[i][d][s]
  cids            = "!f() { \
                            OPT='-3'; \
                            if [ 0 -ne $# ]; then OPT=\"$@\"; fi; \
                            echo \"\\033[1;33m~~> Commit-Id : Change-Id :\\033[0m\"; \
                            git --no-pager log --no-color ${OPT} | \
                                sed -nr 's!^commit\\s*(.+)$!\\1!p; s!^\\s*Change-Id:\\s*(.*$)!\\1!p' | \
                                awk '{ key=$0; getline; print key \" : \" $0; }'; \
                          }; f \
                    "
  ### [c]hange-[i][d] to [rev]sion
  cid2rev         = "!f() { \
                            if [ 0 -ne $# ]; then \
                              changeId=\"$@\" ; \
                              for _i in $(git rev-list --do-walk HEAD); do \
                                if git --no-pager show ${_i} --no-patch --format='%B' | grep -F \"Change-Id: ${changeId}\" >/dev/null 2>&1; then \
                                  echo ${_i} ; \
                                  break ; \
                                fi ; \
                              done ; \
                            else \
                              exit 1; \
                            fi; \
                          }; f \
                    "

  ### [c]hange-[id] [rev]ision [count]
  cid-rev-count   = "!f() { \
                            echo \"\\033[1;33m~~> Revision-Count : Commit-Id : Change-Id :\\033[0m\"; \
                            git rev-list --no-color --reverse HEAD | nl | sort -nr | \
                                while read number revision; do \
                                  cid=$(git show -s \"${revision}\" --format='%B' | sed -rn 's/^\\s*Change-Id:\\s*(.+)$/\\1/p') ; \
                                  if [[ \"${cid}\" = \"$1\" ]]; then echo \"${number} : ${revision} : ${cid}\"; break; fi; \
                                done; \
                          }; f"
```

### revision count
```
[alias]
  show-rev        = "!f(){ git rev-list --count $1; }; f"
  rev-number      = "!bash -c 'git rev-list --reverse HEAD | nl | sort -nr | awk \"{ if(\\$1 == "$0") { print \\$2 }}\"'"
  rev-count       = "!f() { \
                            declare hash=$(git rev-parse \"$1\"); \
                            git rev-list --no-color --reverse HEAD | nl | sort -nr | \
                                while read number revision ; do \
                                  if [[ \"${revision}\" = \"${hash}\" ]]; then echo \"${number}\"; break; fi; \
                                done; \
                          }; f"
  ### [c]hange-[id] [rev]ision [count]
  cid-rev-count   = "!f() { \
                            echo \"\\033[1;33m~~> Revision-Count : Commit-Id : Change-Id :\\033[0m\"; \
                            git rev-list --no-color --reverse HEAD | nl | sort -nr | \
                                while read number revision; do \
                                  cid=$(git show -s \"${revision}\" --format='%B' | sed -rn 's/^\\s*Change-Id:\\s*(.+)$/\\1/p') ; \
                                  if [[ \"${cid}\" = \"$1\" ]]; then echo \"${number} : ${revision} : ${cid}\"; break; fi; \
                                done; \
                          }; f"
  show-remote-rev = "!bash -c 'git ls-remote --heads $(git config --get remote.origin.url) | \n\
                               grep \"refs/heads/$0\" | \n\
                               cut -f 1 \n\
                              ' \n\
                    "
  revset          = "!bash -c 'ix=0; for ih in $(git rev-list --reverse HEAD); do \n\
                                 TCMD=\"git notes --ref linrev\"; \n\
                                 TCMD=\"$TCMD add $ih -m \\\"(r\\$((++ix)))\\\"\"; \n\
                                 eval \"$TCMD\"; \n\
                               done; \n\
                               echo \"Linear revision notes are set.\" \n\
                              ' \n\
                    "
  revunset        = "!bash -c 'ix=0; for ih in $(git rev-list --reverse HEAD); do \n\
                                 TCMD=\"git notes --ref linrev\"; \n\
                                 TCMD=\"$TCMD remove $ih\"; \n\
                                 eval \"$TCMD 2>/dev/null\"; \n\
                               done; \n\
                               echo \"Linear revision notes are unset.\" \n\
                              ' \n\
                    "
```
