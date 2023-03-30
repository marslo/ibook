<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [install](#install)
- [start up WSL](#start-up-wsl)
  - [initialization](#initialization)
- [check](#check)
- [others](#others)
- [Q&A](#qa)
  - [`Error: 0x80040326`](#error-0x80040326)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
>
> wsl:
> - [Windows10/11 三步安装wsl2 Ubuntu20.04（任意盘）](https://zhuanlan.zhihu.com/p/466001838)
> - [WSL Linux 子系统，真香！完整实操](https://zhuanlan.zhihu.com/p/146545159)
> - [Install Hyper-V on Windows 10](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)
> - [在 Windows 10 上安装 Hyper-V](https://learn.microsoft.com/zh-cn/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)
> - [Set up a WSL development environment](https://learn.microsoft.com/en-us/windows/wsl/setup/environment?source=recommendations)
> - [Install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
> - [WSL Error code: Wsl/Service/0x80040326](https://www.techtutsonline.com/how-to-fix-wsl-error-code-0x80040326/#:~:text=Error%20code%3A%20Wsl%2FService%2F0x80040326%20How%20to%20fix%20this%20error,in%20the%20same%20order%3A%20wsl%20--update%20wsl%20--shutdown)
>
> windows terminal:
> - [Windows Terminal 下载，美化，完整配置](https://zhuanlan.zhihu.com/p/439437013)
> - [Startup settings in Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/startup)
> - [Window Terminal 安装以及使用(2021最新)](https://zhuanlan.zhihu.com/p/351281543)
> - [How to Change Default Terminal Application in Windows 10](https://www.tenforums.com/tutorials/180053-how-change-default-terminal-application-windows-10-a.html)
{% endhint %}

## install

- hyper-v
  ```powershell
  > Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
  ```

- wsl
  ```powershell
  > wsl --install
  Installing: Virtual Machine Platform
  Virtual Machine Platform has been installed.
  Installing: Windows Subsystem for Linux
  Windows Subsystem for Linux has been installed.
  Installing: Windows Subsystem for Linux
  Windows Subsystem for Linux has been installed.
  Installing: Ubuntu
  Ubuntu has been installed.
  The requested operation is successful. Changes will not be effective until the system is rebooted.
  ```

  ![wsl install](../../screenshot/win/wsl/wsl-2.png)

  - more
    ```powershell
    > wsl --list --online

    # or
    > wsl --install -d <DistroName>
    ```

- Microsoft-Windows-Subsystem-Linux
  ```powershell
  > dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

  Deployment Image Servicing and Management tool
  Version: 10.0.19041.844

  Image Version: 10.0.19044.2604

  Enabling feature(s)
  [==========================100.0%==========================]
  The operation completed successfully.
  ```

  - or
    ```powershell
    > Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
    ```

- VirtualMachinePlatform
  ```powershell
  > dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

  Deployment Image Servicing and Management tool
  Version: 10.0.19041.844

  Image Version: 10.0.19044.2604

  Enabling feature(s)
  [==========================100.0%==========================]
  The operation completed successfully.
  ```

- set version to 2
  ```powershell
  > wsl --set-default-version 2
  This application requires the Windows Subsystem for Linux Optional Component.
  The system may need to be restarted so the changes can take effect.
  ```

## start up WSL
- download
  ```powershell
  > cd d:\Linux
  > Invoke-WebRequest -Uri https://wsldownload.azureedge.net/Ubuntu_2004.2020.424.0_x64.appx -OutFile Ubuntu20.04.appx -UseBasicParsing
  ```

- rename
  ```powershell
  > Rename-Item .\Ubuntu20.04.appx Ubuntu.zip
  > Expand-Archive .\Ubuntu.zip -Verbose
  > cd .\Ubuntu\
  > .\ubuntu2004.exe
  ```

### initialization

```powershell
> Restart-Computer
```

![wsl init](../../screenshot/win/wsl/wsl-account-setup-3.png)

## check
- windows feature
  - appwiz.cpl

    ![appwiz.cpl](../../screenshot/win/wsl/wsl-check-appwiz.cpl.png)

  - windows features
    ```powershell
    > Get-WindowsOptionalFeature -Online | Where-Object {$_.State -eq "Enabled"} | format-table

    FeatureName                                   State
    -----------                                   -----
    WCF-Services45                              Enabled
    WCF-TCP-PortSharing45                       Enabled
    MediaPlayback                               Enabled
    SmbDirect                                   Enabled
    MSRDC-Infrastructure                        Enabled
    MicrosoftWindowsPowerShellV2Root            Enabled
    MicrosoftWindowsPowerShellV2                Enabled
    NetFx4-AdvSrvs                              Enabled
    Printing-PrintToPDFServices-Features        Enabled
    Printing-XPSServices-Features               Enabled
    SearchEngine-Client-Package                 Enabled
    WorkFolders-Client                          Enabled
    Internet-Explorer-Optional-amd64            Enabled
    Windows-Defender-Default-Definitions        Enabled
    Printing-Foundation-Features                Enabled
    Printing-Foundation-InternetPrinting-Client Enabled
    Microsoft-Windows-Subsystem-Linux           Enabled
    VirtualMachinePlatform                      Enabled
    Microsoft-Hyper-V-All                       Enabled
    Microsoft-Hyper-V                           Enabled
    Microsoft-Hyper-V-Tools-All                 Enabled
    Microsoft-Hyper-V-Management-PowerShell     Enabled
    Microsoft-Hyper-V-Hypervisor                Enabled
    Microsoft-Hyper-V-Services                  Enabled
    Microsoft-Hyper-V-Management-Clients        Enabled
    ```

    ![windows feature check](../../screenshot/win/wsl/wsl-check-windowsfeature.png)

## others
- enable or disable Hyper-V
  ```powershell
  > DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
  ```

- [setup powershell startup](https://zhuanlan.zhihu.com/p/439437013)
  ```powershell
  # 引入 posh-git
  Import-Module posh-git

  # 引入 oh-my-posh
  Import-Module oh-my-posh

  # 引入 ps-read-line
  Import-Module PSReadLine

  # 设置 PowerShell 主题
  Set-PoshPrompt -Theme gmay
  #------------------------------- Import Modules END   -------------------------------

  #-------------------------------  Set Hot-keys BEGIN  -------------------------------
  # 设置预测文本来源为历史记录
  Set-PSReadLineOption -PredictionSource History

  # 每次回溯输入历史，光标定位于输入内容末尾
  Set-PSReadLineOption -HistorySearchCursorMovesToEnd

  # 设置 Tab 为菜单补全和 Intellisense
  Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

  # 设置 Ctrl+d 为退出 PowerShell
  Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit

  # 设置 Ctrl+z 为撤销
  Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo

  # 设置向上键为后向搜索历史记录
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

  # 设置向下键为前向搜索历史纪录
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
  #-------------------------------  Set Hot-keys END    -------------------------------

  #-------------------------------    Functions BEGIN   -------------------------------
  # Python 直接执行
  $env:PATHEXT += ";.py"

  # 更新系统组件
  function Update-Packages {
    # update pip
    Write-Host "Step 1: 更新 pip" -ForegroundColor Magenta -BackgroundColor Cyan
    $a = pip list --outdated
    $num_package = $a.Length - 2
    for ($i = 0; $i -lt $num_package; $i++) {
      $tmp = ($a[2 + $i].Split(" "))[0]
      pip install -U $tmp
    }

    # update TeX Live
    $CurrentYear = Get-Date -Format yyyy
    Write-Host "Step 2: 更新 TeX Live" $CurrentYear -ForegroundColor Magenta -BackgroundColor Cyan
    tlmgr update --self
    tlmgr update --all

    # update Chocolotey
    Write-Host "Step 3: 更新 Chocolatey" -ForegroundColor Magenta -BackgroundColor Cyan
    choco outdated
  }
  #-------------------------------    Functions END     -------------------------------

  #-------------------------------   Set Alias BEGIN    -------------------------------
  # 1. 编译函数 make
  function MakeThings {
    nmake.exe $args -nologo
  }
  Set-Alias -Name make -Value MakeThings

  # 2. 更新系统 os-update
  Set-Alias -Name os-update -Value Update-Packages

  # 3. 查看目录 ls & ll
  function ListDirectory {
    (Get-ChildItem).Name
    Write-Host("")
  }
  Set-Alias -Name ls -Value ListDirectory
  Set-Alias -Name ll -Value Get-ChildItem

  # 4. 打开当前工作目录
  function OpenCurrentFolder {
    param
    (
      # 输入要打开的路径
      # 用法示例：open C:\
      # 默认路径：当前工作文件夹
      $Path = '.'
    )
    Invoke-Item $Path
  }
  Set-Alias -Name open -Value OpenCurrentFolder
  #-------------------------------    Set Alias END     -------------------------------

  #-------------------------------   Set Network BEGIN    -------------------------------
  # 1. 获取所有 Network Interface
  function Get-AllNic {
    Get-NetAdapter | Sort-Object -Property MacAddress
  }
  Set-Alias -Name getnic -Value Get-AllNic

  # 2. 获取 IPv4 关键路由
  function Get-IPv4Routes {
    Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript {$_.NextHop -ne '0.0.0.0'}
  }
  Set-Alias -Name getip -Value Get-IPv4Routes

  # 3. 获取 IPv6 关键路由
  function Get-IPv6Routes {
    Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript {$_.NextHop -ne '::'}
  }
  Set-Alias -Name getip6 -Value Get-IPv6Routes
  ```

## Q&A
### `Error: 0x80040326`
- issue
  ```bash
  Error: 0x80040326
  Error code: Wsl/Service/CreateInstance/0x80040326
  ```

  ![0x80040326](../../screenshot/win/wsl/wsl-0x80040326.png)

- solution
  ```powershell
  # start powershell with administrator

  > wsl --update
  Checking for updates.
  Updating Windows Subsystem for Linux...
  > wsl --shutdown
  > wsl -d ubuntu
  To run a command as administrator (user "root"), use "sudo <command>".
  See "man sudo_root" for details.
  ```

  ![0x80040326](../../screenshot/win/wsl/wsl-0x80040326-update-shutdown.png)
