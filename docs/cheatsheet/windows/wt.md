<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [install](#install)
  - [via download](#via-download)
  - [windows terminal](#windows-terminal)
- [shortcut key](#shortcut-key)
  - [Open the quake mode window](#open-the-quake-mode-window)
- [my settings](#my-settings)
  - [gruvbox-dark](#gruvbox-dark)
  - [global-wild togged hotkey](#global-wild-togged-hotkey)
  - [quake](#quake)
  - [all](#all)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP|label:references:]
> - [* microsoft/terminal](https://github.com/microsoft/terminal)
> - [Custom actions in Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/actions)
> - [在windows下用下拉式中断yakuake(guake)指南](https://zhuanlan.zhihu.com/p/345480762?utm_id=0)
> - [Settings JSON file](https://learn.microsoft.com/en-us/windows/terminal/install#settings-json-file)
>   - stable : `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
>   - preview : `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json`
>   - unpackaged(scoop, chocolately, ...) : `%LOCALAPPDATA%\Microsoft\Windows Terminal\settings.json`
> - [Using command line arguments for Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/command-line-arguments)

## install
### via download

> [!NOTE|label:references:]
> - [WinGet configuration Preview](https://devblogs.microsoft.com/commandline/winget-configuration-preview/)
> - [winget.run](https://github.com/winget-run)

#### winget

- get details
  ```powershell
  > Get-Command -Module Microsoft.WinGet.Client

  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Function        Add-WinGetSource                                   0.2.1      Microsoft.WinGet.Client
  Function        Disable-WinGetSetting                              0.2.1      Microsoft.WinGet.Client
  Function        Enable-WinGetSetting                               0.2.1      Microsoft.WinGet.Client
  Function        Get-WinGetSettings                                 0.2.1      Microsoft.WinGet.Client
  Function        Remove-WinGetSource                                0.2.1      Microsoft.WinGet.Client
  Function        Reset-WinGetSource                                 0.2.1      Microsoft.WinGet.Client
  Cmdlet          Assert-WinGetPackageManager                        0.2.1      Microsoft.WinGet.Client
  Cmdlet          Find-WinGetPackage                                 0.2.1      Microsoft.WinGet.Client
  Cmdlet          Get-WinGetPackage                                  0.2.1      Microsoft.WinGet.Client
  Cmdlet          Get-WinGetSource                                   0.2.1      Microsoft.WinGet.Client
  Cmdlet          Get-WinGetUserSettings                             0.2.1      Microsoft.WinGet.Client
  Cmdlet          Get-WinGetVersion                                  0.2.1      Microsoft.WinGet.Client
  Cmdlet          Install-WinGetPackage                              0.2.1      Microsoft.WinGet.Client
  Cmdlet          Repair-WinGetPackageManager                        0.2.1      Microsoft.WinGet.Client
  Cmdlet          Set-WinGetUserSettings                             0.2.1      Microsoft.WinGet.Client
  Cmdlet          Test-WinGetUserSettings                            0.2.1      Microsoft.WinGet.Client
  Cmdlet          Uninstall-WinGetPackage                            0.2.1      Microsoft.WinGet.Client
  Cmdlet          Update-WinGetPackage                               0.2.1      Microsoft.WinGet.Client
  ```

- install winget
  ```powershell
  > Install-Module Microsoft.WinGet.Client

  Untrusted repository
  You are installing the modules from an untrusted repository. If you trust this repository, change its InstallationPolicy value by
  running the Set-PSRepository cmdlet. Are you sure you want to install the modules from 'PSGallery'?
  [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): a
  ```

  - [or on Windows Sandbox](https://learn.microsoft.com/en-us/windows/package-manager/winget/#install-winget-on-windows-sandbox)
    ```powershell
    $progressPreference = 'silentlyContinue'
    Write-Information "Downloading WinGet and its dependencies..."
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
    Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx -OutFile Microsoft.UI.Xaml.2.7.x64.appx
    Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage Microsoft.UI.Xaml.2.7.x64.appx
    Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    ```

- list upgarde
  ```powershell
  > winget upgrade
  Name                                                       Id                                Version          Available        Source
  -------------------------------------------------------------------------------------------------------------------------------------
  AutoHotkey                                                 AutoHotkey.AutoHotkey             2.0.0            2.0.4            winget
  Git                                                        Git.Git                           2.40.1           2.41.0.3         winget
  Microsoft 365 Apps for enterprise - en-us                  Microsoft.Office                  16.0.16130.20644 16.0.16529.20164 winget
  搜狗输入法 13.4.0正式版                                    Sogou.SogouInput                  13.4.0.7202      13.7.0.7991      winget
  WinSCP 5.19.6                                              WinSCP.WinSCP                     5.19.6           6.1.1            winget
  Microsoft Visual C++ 2015-2019 Redistributable (x86) - 14… Microsoft.VCRedist.2015+.x86      14.28.29914.0    14.36.32532.0    winget
  7-Zip 21.07 (x64 edition)                                  7zip.7zip                         21.07.00.0       23.01            winget
  VMware Horizon Client                                      VMware.HorizonClient              8.6.0.29364      8.9.0.35399      winget
  Microsoft Visual Studio Code (User)                        Microsoft.VisualStudioCode        1.78.2           1.81.0           winget
  Beyond Compare 4                                           ScooterSoftware.BeyondCompare4    4.1.3.20814      4.4.6.27483      winget
  PuTTY release 0.76                                         PuTTY.PuTTY                       0.76.0.0         0.78.0.0         winget
  Adobe Acrobat Reader DC                                    Adobe.Acrobat.Reader.32-bit       22.001.20117     23.003.20244     winget
  Zoom(64bit)                                                Zoom.Zoom                         < 5.14.0.13888   5.15.5.19404     winget
  Zoom Outlook Plugin                                        Zoom.ZoomOutlookPlugin            5.13.10          5.14.10          winget
  Microsoft Windows Desktop Runtime - 6.0.6 (x64)            Microsoft.DotNet.DesktopRuntime.6 6.0.6            6.0.20           winget
  Microsoft Visual C++ 2015-2022 Redistributable (x64) - 14… Microsoft.VCRedist.2015+.x64      14.34.31938.0    14.36.32532.0    winget
  网易有道翻译                                               Youdao.YoudaoDict                 10.0.3.0         10.0.8.0         winget
  17 upgrades available.
  ```

- upgrade
  ```powershell
  > winget upgrade --all

  # or
  > winget upgrade <WinGet Package>

  # i.e.:
  > winget upgrade Git
  Found Git [Git.Git] Version 2.41.0.3
  This application is licensed to you by its owner.
  Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
  Downloading https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.3/Git-2.41.0.3-64-bit.exe
    ██████████████████████████████  58.3 MB / 58.3 MB
  Successfully verified installer hash
  Starting package install...
  Successfully installed
  ```

### windows terminal


> [!NOTE|label:references:]
> - [Windows Terminalv1.16.10261.0](https://winget.run/pkg/Microsoft/WindowsTerminal)
>   ```bash
>   > winget install -e --id Microsoft.WindowsTerminal
>   ```

- show versions
  ```powershell
  > winget show Microsoft.WindowsTerminal --versions
  Found Windows Terminal [Microsoft.WindowsTerminal]
  Version
  ------------
  1.16.10261.0
  1.16.10231.0
  1.15.3465.0
  1.15.2874.0
  1.15.2524.0
  1.14.2281.0
  1.13.11431.0
  1.12.10983.0
  1.12.10982.0
  1.12.10733.0
  1.12.10732.0
  1.12.10393.0
  1.12.10334.0
  ...
  ```
- show available pacakges
  ```powershell
  > winget search windowsterminal
  Name                     Id                                Version      Source
  -------------------------------------------------------------------------------
  Windows Terminal Preview Microsoft.WindowsTerminal.Preview 1.17.10234.0 winget
  Windows Terminal         Microsoft.WindowsTerminal         1.16.10261.0 winget
  ```


## shortcut key

> [!NOTE|label:references:]
> - [`globalSummon` action](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/actions#global-commands)
> - [#12047: Global keyboard shortcut for launching Terminal](https://github.com/microsoft/terminal/issues/12047)
> - [#2983: Shortcut key to launch Terminal](https://github.com/microsoft/terminal/issues/2983)
>   ```bash
>   @ECHO OFF
>   start /B C:\Users\user\AppData\Local\Microsoft\WindowsApps\wt.exe
>   ```
> - [Bring up the Windows Terminal in a keystroke](https://blog.danskingdom.com/Bring-up-the-Windows-Terminal-in-a-keystroke/)
>   - [ahk](https://blog.danskingdom.com/Bring-up-the-Windows-Terminal-in-a-keystroke/#method-4-switch-to-windows-terminal-via-keyboard-shortcut-and-autohotkey)
> - [#12220: Minimize to tray not working](https://github.com/microsoft/terminal/issues/12220)
>   ```json
>   "minimizeToNotificationArea": true
>   ```

| KEYS                      | CMD/ACTIONS          | TARGET/MODE    |
| ------------------------- | -------------------- | -------------- |
| `ctrl+shift+f`            | `find`               | -              |
| `ctrl+shift+space`        | `openNewTabDropdown` | -              |
| `ctrl+,`                  | `openSettings`       | `settingsUI`   |
| `ctrl+shift+,`            | `openSettings`       | `settingsFile` |
| `ctrl+alt+,`              | `openSettings`       | `defaultsFile` |
| `alt+space`               | `openSystemMenu`     | -              |
| `alt+enter`               | `toggleFullscreen`   | -              |
| `f11`                     | `toggleFullscreen`   | -              |
| `ctrl+shift+d`            | `duplicateTab`       | -              |
| `ctrl+shift+t`            | `newTab`             | -              |
| `ctrl+tab`                | `nextTab`            | -              |
| `ctrl+shift+tab`          | `prevTab`            | -              |
| `ctrl+shift+n`            | `newWindow`          | -              |
| `alt+shift+d`             | `splitPane`          | `duplicate`    |
| `alt+shift+-`             | `splitPane`          | `horizontal`   |
| `alt+shift++`             | `splitPane`          | `vertical`     |
| `ctrl+shift+w`            | `closePane`          | -              |
| `alt+down`                | `moveFocus`          | `down`         |
| `alt+up`                  | `moveFocus`          | `up`           |
| `alt+left`                | `moveFocus`          | `left`         |
| `alt+right`               | `moveFocus`          | `right`        |
| `moveFocus`               | `moveFocus`          | `previous`     |
| `alt+shift+down`          | `resizePane`         | `down`         |
| `alt+shift+up`            | `resizePane`         | `up`           |
| `alt+shift+left`          | `resizePane`         | `left`         |
| `alt+shift+right`         | `resizePane`         | `right`        |
| `ctrl+c`                  | `copy`               | -              |
| `ctrl+shift+c`            | `copy`               | -              |
| `ctrl+insert`             | `copy`               | -              |
| `enter`                   | `copy`               | -              |
| `ctrl+v`                  | `paste`              | -              |
| `ctrl+shift+v`            | `paste`              | -              |
| `shift+insert`            | `paste`              | -              |
| `ctrl+shift+a`            | `selectAll`          | -              |
| `ctrl+shift+m`            | `markMode`           | -              |
| `ctrl+shift+up`           | `scrollUp`           | -              |
| `ctrl+shift+down`         | `scrollDown`         | -              |
| `ctrl+shift+pgup`         | `scrollUpPage`       | -              |
| `ctrl+shift+pgdn`         | `scrollDownPage`     | -              |
| `ctrl+shift+home`         | `scrollToTop`        | -              |
| `ctrl+shift+end`          | `scrollToBottom`     | -              |
| `ctrl+=`                  | `adjustFontSize`     | `1`            |
| `ctrl+-`                  | `adjustFontSize`     | `-1`           |
| `ctrl+numpad_plus`        | `adjustFontSize`     | `1`            |
| `ctrl+numpad_minus`       | `adjustFontSize`     | `-1`           |
| `ctrl+0`, `ctrl+numpad_0` | `resetFontSize`      | -              |

- example
  ```json
  // Summon the most recently used (MRU) window, to the current virtual desktop,
  // to the monitor the mouse cursor is on, without an animation. If the window is
  // already in the foreground, then minimize it.
  { "keys": "ctrl+1", "command": { "action": "globalSummon" } },

  // Summon the MRU window, by going to the virtual desktop the window is
  // currently on. Move the window to the monitor the mouse is on.
  { "keys": "ctrl+2", "command": { "action": "globalSummon", "desktop": "any" } },

  // Summon the MRU window to the current desktop, leaving the position of the window untouched.
  { "keys": "ctrl+3", "command": { "action": "globalSummon", "monitor": "any" } },

  // Summon the MRU window, by going to the virtual desktop the window is
  // currently on, leaving the position of the window untouched.
  { "keys": "ctrl+4", "command": { "action": "globalSummon", "desktop": "any", "monitor": "any" } },

  // Summon the MRU window with a dropdown duration of 200ms.
  { "keys": "ctrl+5", "command": { "action": "globalSummon", "dropdownDuration": 200 } },

  // Summon the MRU window. If the window is already in the foreground, do nothing.
  { "keys": "ctrl+6", "command": { "action": "globalSummon", "toggleVisibility": false } },

  // Summon the window named "_quake". If no window with that name exists, then create a new window.
  { "keys": "ctrl+7", "command": { "action": "globalSummon", "name": "_quake" } }
  ```


### Open the quake mode window
```json
{
"keys": "win+`",
  "command": {
    "action": "globalSummon",
    "name": "_quake",
    "dropdownDuration": 200,
    "toggleVisibility": true,
    "monitor": "toMouse",
    "desktop": "toCurrent"
  }
}
```

## my settings
### gruvbox-dark
```json
"schemes":
[
    {
        "background": "#282828",
        "black": "#282828",
        "blue": "#458588",
        "brightBlack": "#928374",
        "brightBlue": "#83A598",
        "brightCyan": "#8EC07C",
        "brightGreen": "#B8BB26",
        "brightPurple": "#D3869B",
        "brightRed": "#FB4934",
        "brightWhite": "#EBDBB2",
        "brightYellow": "#FABD2F",
        "cursorColor": "#FFFFFF",
        "cyan": "#689D6A",
        "foreground": "#EBDBB2",
        "green": "#98971A",
        "name": "gruvbox-dark",
        "purple": "#B16286",
        "red": "#CC241D",
        "selectionBackground": "#1D2021",
        "white": "#A89984",
        "yellow": "#D79921"
    }
],
```

### global-wild togged hotkey
```json
"actions":
[
  { "keys": "ctrl+alt+o", "command": { "action": "globalSummon" } },

],
"minimizeToNotificationArea": true,
```

### quake
```json
    "actions":
    [
        {
            "command":
            {
                "action": "globalSummon",
                "name": "_quake"
            }
        },
        {
            "command":
            {
                "action": "globalSummon",
                "desktop": "toCurrent",
                "dropdownDuration": 200,
                "monitor": "toMouse",
                "name": "_quake",
                "toggleVisibility": true
            },
            "keys": "shift+space"
        },
    ],
```

### all

<!--sec data-title="LocalState\settings.json" data-id="section0" data-show=true data-collapse=true ces-->
```json
{
    "$help": "https://aka.ms/terminal-documentation",
    "$schema": "https://aka.ms/terminal-profiles-schema-preview",
    "actions":
    [
        {
            "command":
            {
                "action": "globalSummon",
                "name": "_quake"
            }
        },
        {
            "command":
            {
                "action": "globalSummon",
                "desktop": "toCurrent",
                "dropdownDuration": 200,
                "monitor": "toMouse",
                "name": "_quake",
                "toggleVisibility": true
            },
            "keys": "shift+space"
        },
        { "keys": "ctrl+alt+o", "command": { "action": "globalSummon" } },
        {
            "command":
            {
                "action": "moveTab",
                "direction": "backward"
            },
            "keys": "alt+shift+l"
        },
        {
            "command":
            {
                "action": "clearBuffer",
                "clear": "all"
            },
            "keys": "ctrl+l"
        },
        {
            "command":
            {
                "action": "moveFocus",
                "direction": "left"
            }
        },
        {
            "command":
            {
                "action": "nextTab"
            },
            "keys": "ctrl+shift+l"
        },
        {
            "command": "paste"
        },
        {
            "command":
            {
                "action": "copy",
                "singleLine": false
            },
            "keys": "ctrl+c"
        },
        {
            "command":
            {
                "action": "moveTab",
                "direction": "forward"
            },
            "keys": "alt+shift+h"
        },
        {
            "command": "find",
            "keys": "ctrl+shift+f"
        },
        {
            "command":
            {
                "action": "splitPane",
                "split": "auto",
                "splitMode": "duplicate"
            },
            "keys": "alt+shift+d"
        },
        {
            "command": "unbound",
            "keys": "ctrl+v"
        },
        {
            "command":
            {
                "action": "prevTab"
            },
            "keys": "ctrl+shift+h"
        }
    ],
    "alwaysShowNotificationIcon": true,
    "alwaysShowTabs": true,
    "autoHideWindow": false,
    "centerOnLaunch": true,
    "copyFormatting": "none",
    "copyOnSelect": true,
    "defaultProfile": "{51855cb2-8cce-5362-8f54-464b92b32386}",
    "experimental.rendering.forceFullRepaint": true,
    "experimental.rendering.software": true,
    "focusFollowMouse": true,
    "initialCols": 116,
    "initialPosition": ",",
    "initialRows": 28,
    "language": "en-US",
    "launchMode": "default",
    "minimizeToNotificationArea": true,
    "newTabMenu":
    [
        {
            "type": "remainingProfiles"
        }
    ],
    "newTabPosition": "afterCurrentTab",
    "profiles":
    {
        "defaults":
        {
            "bellStyle": "none",
            "closeOnExit": "graceful",
            "colorScheme": "One Half Dark",
            "cursorShape": "bar",
            "experimental.retroTerminalEffect": true,
            "font":
            {
                "cellHeight": "1",
                "face": "Rec Mono Casual",
                "size": 19.0
            },
            "opacity": 98
        },
        "list":
        [
            {
                "colorScheme": "Campbell Powershell",
                "commandline": "%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
                "cursorShape": "underscore",
                "font":
                {
                    "face": "GohuFont uni14 Nerd Font Mono",
                    "size": 20.0
                },
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "hidden": false,
                "name": "Windows PowerShell",
                "opacity": 98
            },
            {
                "colorScheme": "Solarized Dark",
                "commandline": "%SystemRoot%\\System32\\cmd.exe",
                "cursorShape": "underscore",
                "font":
                {
                    "face": "GohuFont uni14 Nerd Font Mono",
                    "size": 20.0
                },
                "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                "hidden": false,
                "name": "Command Prompt",
                "opacity": 86,
                "useAcrylic": true
            },
            {
                "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",
                "hidden": true,
                "name": "Ubuntu",
                "opacity": 98,
                "source": "Windows.Terminal.Wsl"
            },
            {
                "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
                "hidden": true,
                "name": "Azure Cloud Shell",
                "source": "Windows.Terminal.Azure"
            },
            {
                "colorScheme": "gruvbox-dark",
                "cursorShape": "doubleUnderscore",
                "font":
                {
                    "face": "Rec Mono Casual",
                    "size": 20.0,
                    "weight": "semi-light"
                },
                "guid": "{51855cb2-8cce-5362-8f54-464b92b32386}",
                "hidden": false,
                "name": "Ubuntu",
                "opacity": 98,
                "source": "CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc",
                "useAcrylic": false
            },
            {
                "colorScheme": "gruvbox-dark",
                "guid": "{17bf3de4-5353-5709-bcf9-835bd952a95e}",
                "hidden": true,
                "name": "Ubuntu-22.04",
                "opacity": 98,
                "source": "Windows.Terminal.Wsl"
            },
            {
                "colorScheme": "gruvbox-dark",
                "font":
                {
                    "size": 18.0
                },
                "guid": "{d7b20cea-47a9-518c-95a4-c8bd91e2e1c6}",
                "hidden": false,
                "name": "Ubuntu 22.04.2 LTS",
                "opacity": 98,
                "source": "CanonicalGroupLimited.Ubuntu22.04LTS_79rhkp1fndgsc"
            },
            {
                "commandline": "ubuntu.exe",
                "font":
                {
                    "size": 14.0
                },
                "guid": "{12f6614d-02ac-48e7-881a-e9ff89f9170f}",
                "hidden": false,
                "name": "_quake"
            }
        ]
    },
    "schemes":
    [
        {
            "background": "#0C0C0C",
            "black": "#0C0C0C",
            "blue": "#0037DA",
            "brightBlack": "#767676",
            "brightBlue": "#3B78FF",
            "brightCyan": "#61D6D6",
            "brightGreen": "#16C60C",
            "brightPurple": "#B4009E",
            "brightRed": "#E74856",
            "brightWhite": "#F2F2F2",
            "brightYellow": "#F9F1A5",
            "cursorColor": "#FFFFFF",
            "cyan": "#3A96DD",
            "foreground": "#CCCCCC",
            "green": "#13A10E",
            "name": "Campbell",
            "purple": "#881798",
            "red": "#C50F1F",
            "selectionBackground": "#FFFFFF",
            "white": "#CCCCCC",
            "yellow": "#C19C00"
        },
        {
            "background": "#012456",
            "black": "#0C0C0C",
            "blue": "#0037DA",
            "brightBlack": "#767676",
            "brightBlue": "#3B78FF",
            "brightCyan": "#61D6D6",
            "brightGreen": "#16C60C",
            "brightPurple": "#B4009E",
            "brightRed": "#E74856",
            "brightWhite": "#F2F2F2",
            "brightYellow": "#F9F1A5",
            "cursorColor": "#FFFFFF",
            "cyan": "#3A96DD",
            "foreground": "#CCCCCC",
            "green": "#13A10E",
            "name": "Campbell Powershell",
            "purple": "#881798",
            "red": "#C50F1F",
            "selectionBackground": "#FFFFFF",
            "white": "#CCCCCC",
            "yellow": "#C19C00"
        },
        {
            "background": "#282C34",
            "black": "#282C34",
            "blue": "#61AFEF",
            "brightBlack": "#5A6374",
            "brightBlue": "#61AFEF",
            "brightCyan": "#56B6C2",
            "brightGreen": "#98C379",
            "brightPurple": "#C678DD",
            "brightRed": "#E06C75",
            "brightWhite": "#DCDFE4",
            "brightYellow": "#E5C07B",
            "cursorColor": "#FFFFFF",
            "cyan": "#56B6C2",
            "foreground": "#DCDFE4",
            "green": "#98C379",
            "name": "One Half Dark",
            "purple": "#C678DD",
            "red": "#E06C75",
            "selectionBackground": "#FFFFFF",
            "white": "#DCDFE4",
            "yellow": "#E5C07B"
        },
        {
            "background": "#FAFAFA",
            "black": "#383A42",
            "blue": "#0184BC",
            "brightBlack": "#4F525D",
            "brightBlue": "#61AFEF",
            "brightCyan": "#56B5C1",
            "brightGreen": "#98C379",
            "brightPurple": "#C577DD",
            "brightRed": "#DF6C75",
            "brightWhite": "#FFFFFF",
            "brightYellow": "#E4C07A",
            "cursorColor": "#4F525D",
            "cyan": "#0997B3",
            "foreground": "#383A42",
            "green": "#50A14F",
            "name": "One Half Light",
            "purple": "#A626A4",
            "red": "#E45649",
            "selectionBackground": "#FFFFFF",
            "white": "#FAFAFA",
            "yellow": "#C18301"
        },
        {
            "background": "#002B36",
            "black": "#002B36",
            "blue": "#268BD2",
            "brightBlack": "#073642",
            "brightBlue": "#839496",
            "brightCyan": "#93A1A1",
            "brightGreen": "#586E75",
            "brightPurple": "#6C71C4",
            "brightRed": "#CB4B16",
            "brightWhite": "#FDF6E3",
            "brightYellow": "#657B83",
            "cursorColor": "#FFFFFF",
            "cyan": "#2AA198",
            "foreground": "#839496",
            "green": "#859900",
            "name": "Solarized Dark",
            "purple": "#D33682",
            "red": "#DC322F",
            "selectionBackground": "#FFFFFF",
            "white": "#EEE8D5",
            "yellow": "#B58900"
        },
        {
            "background": "#FDF6E3",
            "black": "#002B36",
            "blue": "#268BD2",
            "brightBlack": "#073642",
            "brightBlue": "#839496",
            "brightCyan": "#93A1A1",
            "brightGreen": "#586E75",
            "brightPurple": "#6C71C4",
            "brightRed": "#CB4B16",
            "brightWhite": "#FDF6E3",
            "brightYellow": "#657B83",
            "cursorColor": "#002B36",
            "cyan": "#2AA198",
            "foreground": "#657B83",
            "green": "#859900",
            "name": "Solarized Light",
            "purple": "#D33682",
            "red": "#DC322F",
            "selectionBackground": "#FFFFFF",
            "white": "#EEE8D5",
            "yellow": "#B58900"
        },
        {
            "background": "#000000",
            "black": "#000000",
            "blue": "#3465A4",
            "brightBlack": "#555753",
            "brightBlue": "#729FCF",
            "brightCyan": "#34E2E2",
            "brightGreen": "#8AE234",
            "brightPurple": "#AD7FA8",
            "brightRed": "#EF2929",
            "brightWhite": "#EEEEEC",
            "brightYellow": "#FCE94F",
            "cursorColor": "#FFFFFF",
            "cyan": "#06989A",
            "foreground": "#D3D7CF",
            "green": "#4E9A06",
            "name": "Tango Dark",
            "purple": "#75507B",
            "red": "#CC0000",
            "selectionBackground": "#FFFFFF",
            "white": "#D3D7CF",
            "yellow": "#C4A000"
        },
        {
            "background": "#FFFFFF",
            "black": "#000000",
            "blue": "#3465A4",
            "brightBlack": "#555753",
            "brightBlue": "#729FCF",
            "brightCyan": "#34E2E2",
            "brightGreen": "#8AE234",
            "brightPurple": "#AD7FA8",
            "brightRed": "#EF2929",
            "brightWhite": "#EEEEEC",
            "brightYellow": "#FCE94F",
            "cursorColor": "#000000",
            "cyan": "#06989A",
            "foreground": "#555753",
            "green": "#4E9A06",
            "name": "Tango Light",
            "purple": "#75507B",
            "red": "#CC0000",
            "selectionBackground": "#FFFFFF",
            "white": "#D3D7CF",
            "yellow": "#C4A000"
        },
        {
            "background": "#300A24",
            "black": "#171421",
            "blue": "#0037DA",
            "brightBlack": "#767676",
            "brightBlue": "#08458F",
            "brightCyan": "#2C9FB3",
            "brightGreen": "#26A269",
            "brightPurple": "#A347BA",
            "brightRed": "#C01C28",
            "brightWhite": "#F2F2F2",
            "brightYellow": "#A2734C",
            "cursorColor": "#FFFFFF",
            "cyan": "#3A96DD",
            "foreground": "#FFFFFF",
            "green": "#26A269",
            "name": "Ubuntu-22.04-ColorScheme",
            "purple": "#881798",
            "red": "#C21A23",
            "selectionBackground": "#FFFFFF",
            "white": "#CCCCCC",
            "yellow": "#A2734C"
        },
        {
            "background": "#300A24",
            "black": "#171421",
            "blue": "#0037DA",
            "brightBlack": "#767676",
            "brightBlue": "#08458F",
            "brightCyan": "#2C9FB3",
            "brightGreen": "#26A269",
            "brightPurple": "#A347BA",
            "brightRed": "#C01C28",
            "brightWhite": "#F2F2F2",
            "brightYellow": "#A2734C",
            "cursorColor": "#FFFFFF",
            "cyan": "#3A96DD",
            "foreground": "#FFFFFF",
            "green": "#26A269",
            "name": "Ubuntu-ColorScheme",
            "purple": "#881798",
            "red": "#C21A23",
            "selectionBackground": "#FFFFFF",
            "white": "#CCCCCC",
            "yellow": "#A2734C"
        },
        {
            "background": "#000000",
            "black": "#000000",
            "blue": "#000080",
            "brightBlack": "#808080",
            "brightBlue": "#0000FF",
            "brightCyan": "#00FFFF",
            "brightGreen": "#00FF00",
            "brightPurple": "#FF00FF",
            "brightRed": "#FF0000",
            "brightWhite": "#FFFFFF",
            "brightYellow": "#FFFF00",
            "cursorColor": "#FFFFFF",
            "cyan": "#008080",
            "foreground": "#C0C0C0",
            "green": "#008000",
            "name": "Vintage",
            "purple": "#800080",
            "red": "#800000",
            "selectionBackground": "#FFFFFF",
            "white": "#C0C0C0",
            "yellow": "#808000"
        },
        {
            "background": "#282828",
            "black": "#282828",
            "blue": "#458588",
            "brightBlack": "#928374",
            "brightBlue": "#83A598",
            "brightCyan": "#8EC07C",
            "brightGreen": "#B8BB26",
            "brightPurple": "#D3869B",
            "brightRed": "#FB4934",
            "brightWhite": "#EBDBB2",
            "brightYellow": "#FABD2F",
            "cursorColor": "#FFFFFF",
            "cyan": "#689D6A",
            "foreground": "#EBDBB2",
            "green": "#98971A",
            "name": "gruvbox-dark",
            "purple": "#B16286",
            "red": "#CC241D",
            "selectionBackground": "#1D2021",
            "white": "#A89984",
            "yellow": "#D79921"
        }
    ],
    "showTabsInTitlebar": true,
    "startOnUserLogin": true,
    "tabWidthMode": "equal",
    "themes": [],
    "useAcrylicInTabRow": false,
    "wordDelimiters": " \\()\"',:;<>!#$%^&*|+=[]{}?\u2502"
}
```
<!--endsec-->
