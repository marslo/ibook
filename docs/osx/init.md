<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [packages installation](#packages-installation)
- [tap](#tap)
- [cask](#cask)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## packages installation

```bash
# --- utils ---
$ brew install imagemagick
$ brew install tmux corkscrew telnet figlet toilet
$ brew install stow iproute2mac pandoc ifstat nmap
$ brew install pcre2 gettext libtool              # for build vim from source
$ brew install util-linux
$ brew install gawk gnu-tar grep findutils gnu-which gnu-getopt gnu-sed gnu-tar gnutls coreutils moreutils bash proctools pstree vnstat ncdu ipcalc htop glances ack lsof trash
$ brew install colordiff diffutils wdiff
$ brew install --HEAD diff-so-fancy highlight
$ brew install gzip
$ brew install carlocab/personal/unrar
$ brew install zip unzip                          # Info-ZIP
$ brew install --HEAD rename whois watch wget curl
$ brew install --HEAD hexyl                       # a hex viewer for the terminal
$ brew install create-dmg
$ brew install fontforge
$ sudo gem install iStats -n /usr/local/bin       # requires ruby to be installed

$ brew install --HEAD pass
$ brew install pass-otp
$ brew install --HEAD pinentry-mac                # for alfred workflow

# --- editor ---
## nvim
$ brew install --HEAD utf8proc
$ brew install --HEAD neovim
$ brew install --cask vimr
$ python3 -m pip install jedi
$ python3 -m pip install --upgrade pynvim
$ GEM_HOME="$HOME/.gem" gem install neovim --user-install
## macvim
$ brew install --HEAD macvim                      # using `--HEAD` to prevent 32bit vim + 64bit python
$ sudo cp -r $(brew --prefix macvim)/MacVim.app /Applications
## vscode
$ brew install --cask visual-studio-code
# or link to cmd via
$ sudo ln -sf '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' /usr/local/bin/code

# --- dev tools ---
$ brew install nvm                                # nvm for gitbook install: nvm install 12
$ brew install gradle-completion
$ brew install --HEAD ruby
$ brew install less
$ brew install kubecolor
$ brew install --HEAD kubectl
$ brew install mongosh
$ brew install gnu-indent
$ brew install --HEAD git-flow git-extras
$ brew install dos2unix
$ brew install openldap
$ brew install jq
$ brew install openjdk
$ brew install gradle
$ brew install --HEAD fzf fzy bat ack ag rg
$ brew install mkdocs                             # markdown docs, usage: `mkdocs build -d site -s`
$ curl -o "$HOME/.local/bin/cht.sh" -fsSL 'https://cht.sh/:cht.sh' && chmod +x "$HOME/.local/bin/cht.sh"
$ brew install --HEAD gum
$ brew install hashicorp/tap/vault

# --- npm packages ---
$ npm i -g tldr                                   # or $ brew install tlrc; or $ python3 -m pip install tldr
$ npm i -g gnomon
$ npm i -g tabset
$ npm i -g doctoc
$ npm i -g git-stats
$ npm i -g svgexport
$ npm i -g iterm2-tab-set
$ npm i -g neovim
$ npm i -g npm-completion
# - optional -
$ sudo ln -sf $(npm get prefix)/bin/* /usr/local/bin/

# --- lint ---
$ brew install --HEAD shellcheck
$ npm i -g npm-groovy-lint && sudo ln -sf $(npm get prefix)/bin/npm-groovy-lint /usr/local/bin/npm-groovy-lint
$ npm i -g @commitlint/{cli,config-conventional}  # for commitlint
$ npm i -g css-validator                          # for css validation
$ brew install --HEAD yamllint yamlfmt
$ brew install hadolint                           # for dockerfile
$ brew install stylelint                          # for css
$ brew install jsonlint
$ brew install ansible-lint
$ brew install vint                               # vim script language lint
$ brew install --HEAD eslint
$ brew install --HEAD shfmt                       # autoformat shell script source code
# optional
$ brew install actionlint                         # for github action
$ brew install libxml2                            # for xmllint

# --- cask ---
$ brew install --cask keycastr
$ brew install --cask fliqlo                      # flip clock screensaver

# --- tap ---
$ brew tap hashicorp/tap
$ brew tap homebrew/command-not-found             # brew which-formula && brew which-update
$ brew tap vitorgalvao/tiny-scripts
$ brew tap buo/cask-upgrade                       # brew cu

# check tap info
$ brew tap-info vitorgalvao/tiny-scripts --json | jq -r .[].formula_names

# --- for fun ---
$ brew install pv
$ brew install fortune
```

## tap
```bash
$ brew tap
buo/cask-upgrade
carlocab/personal
hashicorp/tap
homebrew/command-not-found
vitorgalvao/tiny-scripts
```

## cask
```bash
       Cask                  Current       Latest        A/U    Result
 1/21  alfred                5.6           5.6            Y   [   OK   ]
 2/21  baiduinput            6.0.3.66      6.0.3.66           [   OK   ]
 3/21  beyond-compare        5.0.6.30713   5.0.6.30713    Y   [   OK   ]
 4/21  bob                   0.10.3        0.10.3         Y   [   OK   ]
 5/21  chatbox               1.11.8        1.11.8         Y   [   OK   ]
 6/21  cherry-studio         1.1.18        1.1.18         Y   [   OK   ]
 7/21  cleanmymac            5.0.7         5.0.7          Y   [   OK   ]
 8/21  cursor                0.48.7        0.48.7         Y   [   OK   ]
 9/21  dash                  7.3.5         7.3.5          Y   [   OK   ]
10/21  google-chrome@canary  137.0.7111.0  137.0.7111.0   Y   [   OK   ]
11/21  istat-menus           7.10.2        7.10.2         Y   [   OK   ]
12/21  jiggler               1.9           1.9                [   OK   ]
13/21  keycastr              0.10.3        0.10.3         Y   [   OK   ]
14/21  macvim                181           181            Y   [   OK   ]
15/21  moom                  4.1.3         4.1.3          Y   [   OK   ]
16/21  paintbrush            2.6.0         2.6.0              [   OK   ]
17/21  shottr                1.8.1         1.8.1          Y   [   OK   ]
18/21  sip                   3.6.2         3.6.2          Y   [   OK   ]
19/21  snipaste              2.10.6        2.10.6         Y   [   OK   ]
20/21  vimr                  0.52.0        0.52.0         Y   [   OK   ]
21/21  wechat                3.8.10.17     3.8.10.17      Y   [   OK   ]
```
