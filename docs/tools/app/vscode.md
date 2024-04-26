<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [basic](#basic)
- [config](#config)
  - [font style](#font-style)
- [plugins](#plugins)
  - [settings sync](#settings-sync)
  - [vim](#vim)
- [shortcut](#shortcut)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [How to Set Up Proxy Settings for Advise for Visual Studio Code](https://docs.mend.io/en-US/bundle/wsk/page/how_to_set_up_proxy_settings_for_advise_for_visual_studio_code.html)
> - [Extension Marketplace](https://code.visualstudio.com/docs/editor/extension-marketplace#_disable-an-extension)
{% endhint %}

## basic

> [!TIP|label:`settings.json`]
>
>
> |    OS   | LOCATION                                                    |
> |:-------:|-------------------------------------------------------------|
> | windows | `%APPDATA%\Code\User\settings.json`                         |
> |  linux  | `$HOME/.config/Code/User/settings.json`                     |
> |   osx   | `$HOME/Library/Application Support/Code/User/settings.json` |

## config

> [!NOTE|label:references:]
> - [#194694 - The Ports panel is opening by itself.](https://github.com/microsoft/vscode/issues/194694#issuecomment-1744810198)

- proxy
  ```json
  {
      "http.proxy": "http://user:pass@my.proxy.address:8080",
      "http.proxyStrictSSL": false,
  }
  ```

### font style

> [!NOTE|label:references:]
> - [#42939 editor.tokenColorCustomizations not applying font style](https://github.com/Microsoft/vscode/issues/42939)

- italic

  > [!NOTE|label:references:]
  > - [How do I get Visual Studio Code to display italic fonts in formatted code?](https://stackoverflow.com/a/50714195/2940319)
  > - [kosimst/FiraFlott](https://github.com/kosimst/FiraFlott?tab=readme-ov-file#vscode-specific)
  > - [kosimst/Firicico](https://github.com/kosimst/Firicico?tab=readme-ov-file#what-are-italics)
  > - [#116 - Italics for keywords, etc](https://github.com/wesbos/cobalt2-vscode/issues/116)
  > - [#51 - VSCode 自定义主题样式](https://github.com/vhxubo/blog/issues/51)

  ```json
  "editor.tokenColorCustomizations": {
    "textMateRules": [
      {
        "scope": [
          //following will be in italic (=FlottFlott)
          "comment",
          "entity.name.type.class", //class names
          "keyword", //import, export, return…
          "constant", //String, Number, Boolean…, this, super
          "storage.modifier", //static keyword
          "storage.type.class.js", //class keyword
        ],
        "settings": {
          "fontStyle": "italic"
        }
      },
    ]
  },
  ```


## plugins
### [settings sync](https://code.visualstudio.com/docs/editor/settings-sync)

> [!NOTE]
> - [Code Settings Sync Configurations](https://dev.to/shanalikhan/visual-studio-code-settings-sync-configurations-mn0)

- update github token

  > [!NOTE|label:references:]
  > - [#1313 - Update Expired token](https://github.com/shanalikhan/code-settings-sync/issues/1313#issuecomment-890602304)

  1. generate new token for gist
  1. vscode -> <kbd>⌘</kbd> + <kbd>⇧</kbd> + <kbd>p</kbd> -> `>Sync: Advanced Options`

    ![sync: advanced options](../../screenshot/tools/vscode/sync-1.png)

  1. `>Sync: Open Settings`

    ![sync: advanced options](../../screenshot/tools/vscode/sync-1.png)

  1. paste new token

    ![paste new token](../../screenshot/tools/vscode/sync-3.png)

### [vim](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim)

> [!NOTE|label:references:]
> - [nstalling vim inside visual studio code](https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/installing-vim-in-vscode/)
> - [Shan Khan/Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)

- install
  - mac
    ```bash
    $ defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false              # For VS Code
    $ defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false      # For VS Code Insider
    $ defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false         # For VS Codium
    $ defaults write com.microsoft.VSCodeExploration ApplePressAndHoldEnabled -bool false   # For VS Codium Exploration users
    $ defaults delete -g ApplePressAndHoldEnabled                                           # If necessary, reset global default
    ```

- configure
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

## shortcut

> [!NOTE|label:references:]
> - [mac.pdf](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-macos.pdf)
> - [linux.pdf](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-linux.pdf)
> - [windows.pdf](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf)
> - keys
>   - <kbd>⌃</kbd> : `control`
>   - <kbd>⌘</kbd> : `command`
>   - <kbd>⇧</kbd> : `shift`
>   - <kbd>⌥</kbd> : `option`
>
> - accepted keys:
>
> | PLATFORM | MODIFIERS                          |
> |:--------:|------------------------------------|
> |   macOS  | `Ctrl+`, `Shift+`, `Alt+`, `Cmd+`  |
> |  Windows | `Ctrl+`, `Shift+`, `Alt+`, `Win+`  |
> |   Linux  | `Ctrl+`, `Shift+`, `Alt+`, `Meta+` |


|          SHORTCUT         |          KEY          | DESCRIPTION                   |
|:-------------------------:|:---------------------:|-------------------------------|
|      shift + cmd + p      |       ⇧ + ⌘ + p       | open command palette          |
|          cmd + p          |         ⌘ + p         | go to file                    |
|   shift + ctrl + &#x60;   |     ⇧ + ⌘ + &#x60;    | new terminal                  |
|          ctrl + b         |         ⌃ + b         | toggle sidebar visibility     |
|          ctrl + r         |         ⌃ + r         | open recently                 |
|          cmd + j          |         ⌘ + j         | toggle terminal panel         |
|          cmd + ,          |         ⌘ + ,         | open settings                 |
|      shift + cmd + e      |       ⇧ + ⌘ + e       | open explorer view            |
|      shift + cmd + f      |       ⇧ + ⌘ + f       | open search view              |
|      shift + cmd + v      |       ⇧ + ⌘ + v       | open markdown preview         |
|         cmd + k, v        |        ⌘ + k, v       | open markdown preview to side |
|      shift + cmd + g      |       ⇧ + ⌘ + g       | open source control view      |
|      shift + cmd + x      |       ⇧ + ⌘ + x       | open extensions view          |
|      shift + cmd + o      |       ⇧ + ⌘ + o       | go to symbol                  |
|      shift + cmd + m      |       ⇧ + ⌘ + m       | show problem panel            |
|      shift + cmd + y      |       ⇧ + ⌘ + y       | show debug console panel      |
|      shift + cmd + u      |       ⇧ + ⌘ + u       | show output  panel            |
|          ctrl + ^         |         ⌃ + ^         | show terminal panel           |
| cmd + k + 0 / cmd + k + j | ⌘ + k + 0 / ⌘ + k + j | fold/unfold all methods       |
|       alt + cmd + o       |       ⌥ + ⌘ + o       | connect to ...                |
|       alt + cmd + r       |       ⌥ + ⌘ + r       | reveal in finder              |
|       alt + cmd + c       |       ⌥ + ⌘ + c       | copy path                     |
