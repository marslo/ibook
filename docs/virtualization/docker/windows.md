<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [docker](#docker)
  - [docker-ee](#docker-ee)
  - [exec commands](#exec-commands)
  - [tricky](#tricky)
- [Hyper-V](#hyper-v)
  - [installation](#installation)
  - [Windows Docker Container Hyper-V Isolation](#windows-docker-container-hyper-v-isolation)
- [Q&A](#qa)
  - [could not read CA certificate](#could-not-read-ca-certificate)
- [references](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## docker
### docker-ee

#### installation
> references:
> - [Docker-EE installtion in windows server](https://computingforgeeks.com/how-to-run-docker-containers-on-windows-server-2019/)
> - [Get started: Prep Windows for containers](https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/set-up-environment?tabs=Windows-Server)
> - [Install Docker Enterprise Edition for Windows Server](https://docker-docs.netlify.app/install/windows/docker-ee/)
> - [basic settings: Docker Linux Container running on Windows Server 2019](https://mountainss.wordpress.com/2020/03/31/docker-linux-container-running-on-windows-server-2019-winserv-docker-containers/)
> - [Use a script to install docker-ee](https://docs.docker.com.zh.xy2401.com/v17.12/install/windows/docker-ee/#optional-make-sure-you-have-all-required-updates)
> - [Remote Management of a Windows Docker Host](https://docs.microsoft.com/en-us/virtualization/windowscontainers/management/manage_remotehost)

```powershell
> Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
> Install-Package -Name docker -ProviderName DockerMsftProvider
> Restart-Computer -Force

# or
> Install-Module DockerMsftProvider -Force
> Install-Package Docker -ProviderName DockerMsftProvider -Force
> Restart-Computer
```

![install-docker-ee-in-windows-server](../../screenshot/docker/docker-ee-windows-server.png)

- install specific docker version
  ```powershell
  > Install-Package -Name docker -ProviderName DockerMsftProvider -Force -RequiredVersion 17.06.2-ee-5
  ```

- check
  ```powershell
  > Get-Package -Name Docker -ProviderName DockerMsftProvider
  Name                           Version          Source                           ProviderName
  ----                           -------          ------                           ------------
  docker                         19.03.5          DockerDefault                    DockerMsftProvider

  > Find-Package -Name Docker -ProviderName DockerMsftProvider
  Name                           Version          Source           Summary
  ----                           -------          ------           -------
  Docker                         20.10.9          DockerDefault    Contains docker-ee for use with Windows Server.
  ```

- upgrade
  ```powershell
  > Install-Package -Name Docker -ProviderName DockerMsftProvider -Update -Force
  > Start-Service Docker
  ```

- [uninstall](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon)
  ```powershell
  > Uninstall-Package -Name docker -ProviderName DockerMsftProvider
  > Uninstall-Module -Name DockerMsftProvider

  # get package via
  > Get-PackageProvider -Name *Docker*
  ```

- [Clean up Docker data and system components](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon#clean-up-docker-data-and-system-components)
  ```powrshell
  > Get-HNSNetwork | Remove-HNSNetwork
  > Get-ContainerNetwork | Remove-ContainerNetwork
  > Remove-Item "C:\ProgramData\Docker" -Recurse

  # close Hyper-V
  > Remove-WindowsFeature Containers
  > Remove-WindowsFeature Hyper-V

  # reboot
  > Restart-Computer -Force
  ```

- pull and run windows image
  ```powershell
  > docker pull mcr.microsoft.com/dotnet/samples:dotnetapp-nanoserver-2009
  > docker run mcr.microsoft.com/dotnet/samples:dotnetapp-nanoserver-2009
  ```

#### [Use a script to install docker-ee](http://man.hubwiz.com/docset/Docker.docset/Contents/Resources/Documents/docs.docker.com/install/windows/docker-ee.html)
```powershell
# On an online machine, download the zip file.
Invoke-WebRequest -UseBasicParsing -OutFile docker-18.09.5.zip https://download.docker.com/components/engine/windows-server/18.09/docker-18.09.5.zip
# Stop Docker service
Stop-Service docker

# Extract the archive.
Expand-Archive docker-18.09.5.zip -DestinationPath $Env:ProgramFiles -Force

# Clean up the zip file.
Remove-Item -Force docker-18.09.5.zip

# Install Docker. This requires rebooting.
$null = Install-WindowsFeature containers

# Add Docker to the path for the current session.
$env:path += ";$env:ProgramFiles\docker"

# Optionally, modify PATH to persist across sessions.
$newPath = "$env:ProgramFiles\docker;" +
[Environment]::GetEnvironmentVariable("PATH",
[EnvironmentVariableTarget]::Machine)

[Environment]::SetEnvironmentVariable("PATH", $newPath,
[EnvironmentVariableTarget]::Machine)

# Register the Docker daemon as a service.
dockerd --register-service

# Start the Docker service.
Start-Service docker
```

- check

  > - [imarslo : stop service & process via powershell](../../cheatsheet/windows/windows.html#stop-service--process-via-powershell)
  > - [powershell : Get-Service](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-service?view=powershell-7.2)

  ```powershell
  > Get-Process dockerd
  Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
  -------  ------    -----      -----     ------     --  -- -----------
      449      28   138348      45356       4.31  16192   0 dockerd

  > Get-NetTCPConnection -LocalPort 2376
  LocalAddress                        LocalPort RemoteAddress                       RemotePort State       AppliedSetting
  ------------                        --------- -------------                       ---------- -----       --------------
  ::                                  2376      ::                                  0          Listen
  # or
  > Get-NetTCPConnection -LocalPort 2376 -State Listen -ErrorVariable $err -ErrorAction SilentlyContinue

  > Get-Service Docker
  Status   Name               DisplayName
  ------   ----               -----------
  Running  Docker             Docker Engine
  ```

#### install a specific version
```powershell
> Install-Package -Name docker -ProviderName DockerMsftProvider -Force -RequiredVersion 18.09
...
Name                      Version               Source           Summary
----                      -------               ------           -------
Docker                    18.09                 Docker           Contains Docker Engine - Enterprise for use with Windows Server...

# update module
> Update-Module DockerMsftProvider
```

#### upgrade docker-ee
```powershell
> Install-Package -Name docker -ProviderName DockerMsftProvider -RequiredVersion 18.09 -Update -Force
```

#### uninstall docker-ee
```powershell
# Leave any active Docker Swarm
> docker swarm leave --force

# Remove all running and stopped containers
> docker rm -f $(docker ps --all --quiet)

# Prune container data
> docker system prune --all --volumes

# Uninstall Docker PowerShell Package and Module
> Uninstall-Package -Name docker -ProviderName DockerMsftProvider
> Uninstall-Module -Name DockerMsftProvider

# Clean up Windows Networking and file system
> Get-HNSNetwork | Remove-HNSNetwork
> Remove-Item -Path "C:\ProgramData\Docker" -Recurse -Force
```

### exec commands
```powershell
> docker exec a8 powershell -c "Get-CimInstance Win32_Process | Select-Object ProcessId, CommandLine"
```

### tricky
- [run linux container in windows server 2019](https://computingforgeeks.com/how-to-run-docker-containers-on-windows-server-2019/)
  - uninstall current docker-ee
    ```powershell
    > Uninstall-Package -Name docker -ProviderName DockerMSFTProvider
    ```

  - enable Nested Virtualization by using Linux Virtual Machine running on Hyper-V.
    ```powershell
    > Get-VM WinContainerHost | Set-VMProcessor -ExposeVirtualizationExtensions $true
    ```

  - install pre build docker-ee
    ```powershell
    > Install-Module DockerProvider
    > Install-Package Docker -ProviderName DockerProvider -RequiredVersion preview
    ```

  - Enable LinuxKit system for running Linux containers
    ```powershell
    [Environment]::SetEnvironmentVariable("LCOW_SUPPORTED", "1", "Machine")
    ```
    - to Switch back to running Windows containers
      ```powershell
      [Environment]::SetEnvironmentVariable("LCOW_SUPPORTED", "$null", "Machine")
      ```

  - restart docker service
    ```powershell```
    > Restart-Service docker
    ```

  - check
    ```powershell
    > docker run -it --rm ubuntu /bin/bash
    ```

- [FIPS 140-2 cryptographic module support](http://man.hubwiz.com/docset/Docker.docset/Contents/Resources/Documents/docs.docker.com/install/windows/docker-ee.html)
  ```batch
  > [System.Environment]::SetEnvironmentVariable("DOCKER_FIPS", "1", "Machine")

  # regedit
  Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy\" -Name "Enabled" -Value "1"

  > net stop docker
  > net start docker

  # check
  > docker info
  ...
  Labels:
    com.docker.security.fips=enabled
  ...
  ```

## Hyper-V
### installation

- via commands
  ```powershell
  > Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
  ```
- manually

### [Windows Docker Container Hyper-V Isolation](https://www.virtualizationhowto.com/2020/12/install-docker-in-windows-server-2019/)
```powershell
> docker run -it --isolation=hyperv mcr.microsoft.com/windows/servercore:ltsc2019

# check
> get-process -Name vmwp
```

## Q&A
### [could not read CA certificate](https://github.com/docker/for-win/issues/1746)
- solution
  ```powershell
  [Environment]::SetEnvironmentVariable("DOCKER_CERT_PATH", $null, "User")
  [Environment]::SetEnvironmentVariable("DOCKER_HOST", $null, "User")
  [Environment]::SetEnvironmentVariable("DOCKER_MACHINE_NAME", $null, "User")
  [Environment]::SetEnvironmentVariable("DOCKER_TLS_VERIFY", $null, "User")
  [Environment]::SetEnvironmentVariable("DOCKER_TOOLBOX_INSTALL_PATH", $null, "User")
  ```

- or
  ```batch
  SET DOCKER_CERT_PATH= $null, "User"
  SET DOCKER_HOST= $null, "User"
  SET DOCKER_MACHINE_NAME= $null, "User"
  SET DOCKER_TLS_VERIFY= $null, "User"
  SET DOCKER_TOOLBOX_INSTALL_PATH= $null, "User"
  ```

## references
> - [Support policy for Windows Server containers in on-premises scenarios](https://docs.microsoft.com/en-us/troubleshoot/windows-server/containers/support-for-windows-containers-docker-on-premises-scenarios)
> - [Windows container requirements](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/system-requirements)
> - [System requirements for Hyper-V on Windows Server](https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/system-requirements-for-hyper-v-on-windows#general-requirements)
> - [Install Docker in Windows Server 2019](https://www.virtualizationhowto.com/2020/12/install-docker-in-windows-server-2019/)
> - [Docker PowerShell Scripts for Local Development](https://geoffhudik.com/tech/2019/05/27/docker-powershell-scripts-for-local-development/)
>   - [* docker-restart-attempt.ps1](https://gist.github.com/thnk2wn/32ce1ad47882bd5b1c43e19cbf8f37f4)
>   - [docker-cloud-config-start.ps1](https://gist.github.com/thnk2wn/3222627b1cb3796c70277e7edda4a036)
>   - [run-prep.ps1](https://gist.github.com/thnk2wn/32e8bb9c68857a4b05183a33f43e2846)
>   - [docker-mysql-start.ps1](https://gist.github.com/thnk2wn/85a599be930c7bca54fb3463f158a3a8)
>   - [docker-rabbitmq-start.ps1](https://gist.github.com/thnk2wn/4bdc9e7d42df50197b53485d880f2a83)
>   - [docker-redis-start.ps1](https://gist.github.com/thnk2wn/32ce1ad47882bd5b1c43e19cbf8f37f4)
>   - [eureka-start.ps1](https://gist.github.com/thnk2wn/ad1e1dbfa5c4c96d6ca59a72a00e45c9)
>   - [eureka-wait.ps1](https://gist.github.com/thnk2wn/5366a34a71c8fcfd5e3d14722dc02975)
