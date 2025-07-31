

## apt install

> [!TIP]
> - [nvim-releases](https://github.com/neovim/neovim-releases/releases)

```bash
$ sudo apt-get update
$ sudo apt-get install -y ca-certificates curl gnupg bash-completion jq python3 python3-pip xclip xsel tree dstat shellcheck tig
$ sudo apt-get install -y cifs-utils nfs-common

# vim 9.x
$ sudo add-apt-repository ppa:jonathonf/vim
$ sudo apt-get update && sudo apt-get install vim

# nvim
$ curl -fsSL -O https://github.com/neovim/neovim-releases/releases/download/v0.11.2/nvim-linux-x86_64.deb
$ sudo apt install ./nvim-linux-x86_64.deb
# -- nvim - tiktoken_core.so --
$ sudo apt install lua5.1
$ NAME="tiktoken_core-linux-$(uname -m)-$(lua -v 2>&1 | sed -n 's/Lua \([0-9]\)\.\([0-9]\).*/lua\1\2/p').so"
$ VERSION=$(curl --silent 'https://api.github.com/repos/gptlang/lua-tiktoken/releases/latest' | jq -r .tag_name)
$ curl -fsSL --create-dirs -o ~/.config/nvim/lua/tiktoken_core.so https://github.com/gptlang/lua-tiktoken/releases/download/${VERSION}/${NAME}
# -- pynvim --
$ pip3 install --user pynvim
# -- tree-sitter --
$ sudo npm install -g tree-sitter-cli

# 20.x nodejs
$ curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
$ NODE_MAJOR=20
$ echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
$ sudo apt-get update && sudo apt-get install nodejs -y

# go
$ sudo apt install golang-go

# fzf
$ VERSION=$(curl --silent 'https://api.github.com/repos/junegunn/fzf/releases/latest' | jq -r .tag_name)
$ curl -fsSL -O https://github.com/junegunn/fzf/releases/download/${VERSION}/fzf-${VERSION//v}-linux_$(dpkg --print-architecture).tar.gz
$ sudo tar -xzf fzf-${VERSION//v}-linux_$(dkpg --print-architecture).tar.gz -C /usr/local/bin
$ fzf --bash | sudo tee /usr/share/bash-completion/completions/fzf

# rg
$ VERSION=$(curl --silent 'https://api.github.com/repos/BurntSushi/ripgrep/releases/latest' | jq -r .tag_name)
$ curl -fsSL -O https://github.com/BurntSushi/ripgrep/releases/download/${VERSION}/ripgrep_${VERSION}-1_$(dpkg --print-architecture).deb
$ sudo dpkg -i ripgrep_${VERSION}-1_$(dpkg --print-architecture).deb
$ rg --generate complete-bash | sudo tee /usr/share/bash-completion/completions/rg

# bat
$ VERSION=$(curl --silent 'https://api.github.com/repos/sharkdp/bat/releases/latest' | jq -r .tag_name)
$ curl -fsSL -O https://github.com/sharkdp/bat/releases/download/${VERSION}/bat_${VERSION//v}_$(dpkg --print-architecture).deb
$ sudo dpkg -i bat_${VERSION//v}_$(dpkg --print-architecture).deb
$ bat --completion bash | sudo tee /usr/share/bash-completion/completions/bat

# fd
$ VERSION=$(curl --silent 'https://api.github.com/repos/sharkdp/fd/releases/latest' | jq -r .tag_name)
$ curl -fsSL -O https://github.com/sharkdp/fd/releases/download/${VERSION}/fd_${VERSION//v}_$(dpkg --print-architecture).deb
$ sudo dpkg -i fd_${VERSION//v}_$(dpkg --print-architecture).deb
$ fd --gen-completions bash | sudo tee /usr/share/bash-completion/completions/fd

# ncdu
$ curl -fsSL -O https://dev.yorhel.nl/download/ncdu-2.8.1-linux-x86_64.tar.gz
$ sudo tar -xzf ncdu-2.8.1-linux-x86_64.tar.gz -C /usr/local/bin

# difft
$ VERSION=$(curl --silent 'https://api.github.com/repos/Wilfred/difftastic/releases/latest' | jq -r .tag_name)
$ curl -fsSL -O https://github.com/Wilfred/difftastic/releases/download/${VERSION}/difft-x86_64-unknown-linux-musl.tar.gz
$ sudo tar -xzf difft-x86_64-unknown-linux-musl.tar.gz -C /usr/local/bin
```

### docker
```bash
$ sudo apt-get update
$ sudo apt-get install ca-certificates curl
$ sudo install -m 0755 -d /etc/apt/keyrings
$ sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
$ sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
$ echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$ sudo apt-get update

# install
$ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
$ sudo usermod -aG docker "$(whoami)"
# re-login to apply group changes
```
