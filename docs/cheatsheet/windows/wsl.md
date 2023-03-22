

{% hint style='tip' %}
> references:
> - [Windows10/11 三步安装wsl2 Ubuntu20.04（任意盘）](https://zhuanlan.zhihu.com/p/466001838)
> - [WSL Linux 子系统，真香！完整实操](https://zhuanlan.zhihu.com/p/146545159)
> - [Set up a WSL development environment](https://learn.microsoft.com/en-us/windows/wsl/setup/environment?source=recommendations)
> - [Install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
{% endhint %}

## install
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
