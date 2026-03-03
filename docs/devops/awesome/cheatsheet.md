<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [tldr](#tldr)
  - [install](#install)
  - [config](#config)
- [cht.sh](#chtsh)
  - [with fzf](#with-fzf)
  - [links](#links)
  - [.cht.sh.conf](#chtshconf)
    - [CHTSH environment](#chtsh-environment)
    - [theme](#theme)
    - [mode](#mode)
  - [`--shell`](#--shell)
- [cheat](#cheat)
  - [configure](#configure)
    - [theme](#theme-1)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# tldr

> [!NOTE|label:references:]
> - [tldr.sh](https://tldr.sh/) | [tlrc](https://tldr.sh/tlrc) | [python version](https://pypi.org/project/tldr/)
> - [client](https://github.com/tldr-pages/tldr/wiki/Clients)

## install
```bash
# node version
$ npm install -g tldr
# -- usage --
$ $(npm config get prefix)/bin/tldr --theme ocean <cmd>

# rust version
$ brew install --HEAD tlrc

# c version
$ brew install --HEAD tldr

# python version
$ python3 -m pip install tldr
```

## config
- rust version

  > [!TIP|label:references:]
  > - config file :
  >   - linux and bsd: `$XDG_CONFIG_HOME/tlrc/config.toml` or `~/.config/tlrc/config.toml` if `$XDG_CONFIG_HOME` is unset
  >   - macos: `~/Library/Application Support/tlrc/config.toml`
  >   - windows: `%ROAMINGAPPDATA%\tlrc\config.toml`
  > - [iMarslo: .tlrc.toml](https://github.com/marslo/dotfiles/blob/main/.marslo/.tlrc.toml)
  >   `export TLRC_CONFIG="$HOME/.marslo/.tlrc.toml"`

  ```bash
  # rust version
  # -- default configure --
  $ tldr --gen-config > $(tldr --config-path)

  # -- user defined configure --
  $ export TLRC_CONFIG="$HOME/.marslo/.tlrc.toml"
  # or
  $ tldr --config "$HOME/.marslo/.tlrc.toml" <cmd>
  ```

- python version
  ```bash
  # tldr-pypi : https://pypi.org/project/tldr/
  export TLDR_COLOR_NAME='cyan'
  export TLDR_COLOR_DESCRIPTION='white'
  export TLDR_COLOR_EXAMPLE='green'
  export TLDR_COLOR_COMMAND='red'
  export TLDR_COLOR_PARAMETER='white'
  export TLDR_LANGUAGE='en'
  export TLDR_CACHE_ENABLED=1
  export TLDR_CACHE_MAX_AGE=720
  export TLDR_PAGES_SOURCE_LOCATION='https://raw.githubusercontent.com/tldr-pages/tldr/main/pages'
  export TLDR_DOWNLOAD_CACHE_LOCATION='https://tldr-pages.github.io/assets/tldr.zip'
  ```

# cht.sh

> [!NOTE|label:references:]
> - [chubin/cheat.sh](https://github.com/chubin/cheat.sh) | [cheat.sh](https://cheat.sh/) | - [cheat.sh/fzf](https://cheat.sh/fzf)
> - [gotbletu/fzf-cheat.sh](https://gist.github.com/gotbletu/538ffd9565bc38b5426dd9071ff1eecd)
> - [youtube: I made the greatest tool ever! | tmux & cht.sh & fzf](https://www.youtube.com/watch?v=hJzqEAf2U4I)
>   - [ThePrimeagen/.dotfiles/tmux-cht.sh](https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-cht.sh)
> - [kenos1/tmux-cht-sh/bin/tmux-cht-sh.sh](https://github.com/kenos1/tmux-cht-sh/blob/main/bin/tmux-cht-sh.sh)
> - [gohoyer/Alfred-Cheat.sh](https://github.com/gohoyer/Alfred-Cheat.sh)
> - [From FZF file preview to a browser for cht.sh to discovering the ideal solution](https://dev.to/melopilosyan/from-fzf-file-preview-to-a-browser-for-chtsh-to-discovering-the-ideal-solution-3ann)
> - [melopilosyan/confNest - cs](https://github.com/melopilosyan/confNest/blob/main/bin/cs)

```bash
# install
$ curl -fsSL https://cht.sh/:cht.sh --create-dirs -o ~/.local/bin/cht.sh
$ chmod +x ~/.local/bin/cht.sh

# completion
$ curl -fsSL https://cheat.sh/:bash_completion --create-dirs -o ~/.marslo/.completion/cht.sh
$ source ~/.marslo/.completion/cht.sh

# added in .bashrc
$ [[ -f "${iRCHOME}"/.completion/cht.sh ]] && source "${iRCHOME}"/.completion/cht.sh
```

## with fzf

- [cs](https://github.com/marslo/dotfiles/blob/main/.marslo/bin/cs)

## links

- [:intro](https://cht.sh/:intro)
- [~snapshot](https://cht.sh/~snapshot)
- [:vim](https://cht.sh/:vim)
- [:styles](https://cht.sh/:styles)
- [:styles-demo](https://cht.sh/:styles-demo)
- :list
  - i.e.: [python/:list](https://cht.sh/python/:list)
- :learn
  - i.e.: [python/:learn](https://cht.sh/python/:learn)

## .cht.sh.conf

> [!NOTE|label:references:]
> - path: `~/.cht.sh/`
> - file : `~/.cht.sh/cht.sh.conf`
> - [cht.sh](https://cht.sh/:cht.sh)
>   configuration is stored in `~/.cht.sh/` (can be overridden with `CHTSH` env var.)

### CHTSH environment

| ENVIRONMENT VARIABLE        | VALUE                                         |
|-----------------------------|-----------------------------------------------|
| `CHTSH_HOME`                | `~/.cht.sh/`                                  |
| `CHTSH_CONF`                | `$CHTSH_HOME/cht.sh.conf`                     |
| `CHTSH_URL`                 | `https://cht.sh`                              |
| `CHTSH_MODE`                | `$(cat "$CHTSH_HOME/mode 2>/dev/null")`       |
| `CHTSH_CURL_OPTIONS`        | -                                             |
| `CHEATSH_INSTALLATION`      | `$(cat "$CHTSH_HOME/standalone" 2>/dev/null)` |
| `CHEATSH_TEST_STANDALONE`   | `YES/NO`                                      |
| `CHEATSH_TEST_SKIP_ONLINE`  | `YES/NO`                                      |
| `CHEATSH_TEST_SHOW_DETAILS` | `YES/NO`                                      |

### theme
- list themes
  ```bash
  $ cht.sh :styles

  # or
  $ curl cht.sh/:styles
  ```

- show themes
  ```bash
  $ cht.sh :styles-demo

  # or
  $ cht.sh :styles |
    while read -r _s; do
      echo -e "\n---";
      echo -e "${_s}";
      echo -e "---";
      curl "cheat.sh/bash/advanced?style=${_s}";
    done
  ```

- configure theme
  ```bash
  $ cat ~/.cht.sh/cht.sh.conf
  CHTSH_QUERY_OPTIONS="style=arduino"
  ```

- themes
  - algol_nu
  - arduino
  - native
  - solarized-dark
  - stata-dark

### mode

> [!NOTE|label:references:]
> - path : `~/.cht.sh/mode`

```bash
$ cht.sh --mode lite      # use https://cheat.sh/ only
$ cht.sh --mode auto      # use local installation
```

## `--shell`

> [!NOTE|label:references:]

```bash
$ brew install --HEAD rlwrap
$ cht.sh --shell python
```

# cheat

> [!NOTE|label:references:]
> - [cheat/chet](https://github.com/cheat/cheat) | [cheat/cheatsheets](https://github.com/cheat/cheatsheets)
> - [Related Projects](https://github.com/cheat/cheat/wiki/Related-Projects)
> - [docopt](http://docopt.org/)

```bash
$ brew install cheat
```

## configure
```bash
$ mkdir -p ~/.config/cheat && cheat --init > ~/.config/cheat/conf.yml

# -- config path --
$ cheat --conf
```

- reset cheatsheets repo
  ```bash
  $ cd ~/.config/cheat/cheatsheets
  $ rm -rf community
  $ git clone https://github.com/cheat/cheatsheets.git community
  ```

### theme

- arduino
- github-dark
- gruvbox
- native
- onedark

- optional
  - doom-one
  - evergarden
  - lovelace
  - nord
  - solarized-dark256
  - vulcan
