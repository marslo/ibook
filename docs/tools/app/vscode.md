<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [basic](#basic)
- [config](#config)
- [plugins](#plugins)
  - [Settings Sync](#settings-sync)
  - [vim](#vim)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [How to Set Up Proxy Settings for Advise for Visual Studio Code](https://docs.mend.io/en-US/bundle/wsk/page/how_to_set_up_proxy_settings_for_advise_for_visual_studio_code.html)
> - [Extension Marketplace](https://code.visualstudio.com/docs/editor/extension-marketplace#_disable-an-extension)
{% endhint %}


## basic

- settings.json

  |    OS   | LOCATION                                                    |
  |:-------:|-------------------------------------------------------------|
  | windows | `%APPDATA%\Code\User\settings.json`                         |
  |  linux  | `$HOME/.config/Code/User/settings.json`                     |
  |   osx   | `$HOME/Library/Application Support/Code/User/settings.json` |

- shortcuts
  - [mac.pdf](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-macos.pdf)
  - [linux.pdf](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-linux.pdf)
  - [windows.pdf](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf)

  - accepted keys

    | PLATFORM | MODIFIERS                          |
    |:--------:|------------------------------------|
    |   macOS  | `Ctrl+`, `Shift+`, `Alt+`, `Cmd+`  |
    |  Windows | `Ctrl+`, `Shift+`, `Alt+`, `Win+`  |
    |   Linux  | `Ctrl+`, `Shift+`, `Alt+`, `Meta+` |


## config

- proxy
  ```json
  {
      "http.proxy": "http://user:pass@my.proxy.address:8080",
      "http.proxyStrictSSL": false,
  }
  ```

## plugins
### [Settings Sync](https://code.visualstudio.com/docs/editor/settings-sync)

### [vim](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim)

> [!NOTE|label:references:]
> - [nstalling vim inside visual studio code](https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/installing-vim-in-vscode/)

- install
  - mac
    ```bash
    $ defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false              # For VS Code
    $ defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false      # For VS Code Insider
    $ defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false         # For VS Codium
    $ defaults write com.microsoft.VSCodeExploration ApplePressAndHoldEnabled -bool false   # For VS Codium Exploration users
    $ defaults delete -g ApplePressAndHoldEnabled                                           # If necessary, reset global default
    ```

- confiugre
  ```json
  // vim
  "vim.changeWordIncludesWhitespace": true,
  "vim.cursorStylePerMode.insert": "line",
  "vim.cursorStylePerMode.normal": "underline",
  "vim.cursorStylePerMode.visual": "underline",
  "vim.cursorStylePerMode.visualblock": "line",
  "vim.cursorStylePerMode.visualline": "underline",
  "vim.cursorStylePerMode.replace": "underline",
  "vim.useSystemClipboard": true,
  "vim.sneakUseIgnorecaseAndSmartcase": true,
  "vim.easymotion": true,
  "vim.incsearch": true,
  "vim.hlsearch": true,
  ```
