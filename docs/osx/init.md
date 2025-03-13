<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [packages installation](#packages-installation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## packages installation

```bash
# --- utils ---
$ brew install imagemagick
$ brew install tmux corkscrew telnet figlet toilet
$ brew install stow iproute2mac pandoc ifstat nmap
$ brew install pcre2 gettext libtool           # for build vim from source
$ brew install util-linux
$ brew install gawk gnu-tar grep findutils gnu-which gnu-getopt gnu-sed gnu-tar gnutls coreutils moreutils bash proctools pstree vnstat ncdu ipcalc htop glances ack lsof trash
$ brew install colordiff diffutils wdiff
$ brew install --HEAD diff-so-fancy highlight
$ brew install gzip
$ brew install --cask unrar
$ brew install --HEAD rename whois watch wget
$ brew install create-dmg
$ brew install fontforge
$ sudo gem install iStats -n /usr/local/bin    # requires ruby to be installed

$ brew install --HEAD pass
$ brew install pass-otp
$ brew install --HEAD pinentry-mac             # for alfred workflow

# --- editor ---
## nvim
$ brew install --HEAD utf8proc
$ brew install --HEAD neovim
$ brew install --cask vimr
## macvim
$ brew install --HEAD macvim                   # using `--HEAD` to prevent 32bit vim + 64bit python
$ sudo cp -r $(brew --prefix macvim)/MacVim.app /Applications
## vscode
$ brew install --cask visual-studio-code
# or link to cmd via
$ sudo ln -sf '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' /usr/local/bin/code

# --- dev tools ---
$ brew install nvm                             # nvm for gitbook install: nvm install 12
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

# --- npm packages ---
$ npm i -g tldr                                   # or $ brew install tlrc; or $ python3 -m pip install tldr
$ npm i -g gnomon
$ npm i -g tabset
$ npm i -g doctoc
$ npm i -g git-stats
$ npm i -g svgexport
# - optional -
$ sudo ln -sf $(npm get prefix)/bin/* /usr/local/bin/

# --- lint ---
$ brew install --HEAD shellcheck
$ npm i -g npm-groovy-lint && sudo ln -sf $(npm get prefix)/bin/npm-groovy-lint /usr/local/bin/npm-groovy-lint
$ npm i -g @commitlint/{cli,config-conventional}  # for commitlint
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
$ brew install hashicorp/tap/vault
$ brew tap homebrew/command-not-found             # brew which-formula && brew which-update
$ brew tap vitorgalvao/tiny-scripts
$ brew tap buo/cask-upgrade                       # brew cu

# check tap info
$ brew tap-info vitorgalvao/tiny-scripts --json | jq -r .[].formula_names

# --- for fun ---
$ brew install pv
$ brew install fortune
```

