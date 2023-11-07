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
  - [create a virtual machine with powershell by Hyper-V](#create-a-virtual-machine-with-powershell-by-hyper-v)
- [Q&A](#qa)
  - [could not read CA certificate](#could-not-read-ca-certificate)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [Support policy for Windows Server containers in on-premises scenarios](https://docs.microsoft.com/en-us/troubleshoot/windows-server/containers/support-for-windows-containers-docker-on-premises-scenarios)
> - [Windows container requirements](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/system-requirements)
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
> - [Docker Engine on Windows](https://learn.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon)
{% endhint %}

## docker
### docker-ee

#### installation

> [!NOTE]
> references:
> - [* Install Docker Engine - Enterprise on Windows Servers](http://man.hubwiz.com/docset/Docker.docset/Contents/Resources/Documents/docs.docker.com/install/windows/docker-ee.html)
> - [Docker-EE installtion in windows server](https://computingforgeeks.com/how-to-run-docker-containers-on-windows-server-2019/)
> - [Get started: Prep Windows for containers](https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/set-up-environment?tabs=Windows-Server)
> - [Install Docker Enterprise Edition for Windows Server](https://docker-docs.netlify.app/install/windows/docker-ee/)
> - [basic settings: Docker Linux Container running on Windows Server 2019](https://mountainss.wordpress.com/2020/03/31/docker-linux-container-running-on-windows-server-2019-winserv-docker-containers/)
> - [Use a script to install docker-ee](https://docs.docker.com.zh.xy2401.com/v17.12/install/windows/docker-ee/#optional-make-sure-you-have-all-required-updates)
> - [Remote Management of a Windows Docker Host](https://docs.microsoft.com/en-us/virtualization/windowscontainers/management/manage_remotehost)
> - [Windows Server 2019 - Docker Daemon](https://mpolinowski.github.io/docs/DevOps/Windows/2019-06-13--windows-server-2019-docker-daemon/2019-06-13/)
>   - [Downloading Docker Manually](https://mpolinowski.github.io/docs/DevOps/Windows/2019-06-13--windows-server-2019-docker-daemon/2019-06-13/#downloading-docker-manually)

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

- update DockerMsftProvider
  ```powershell
  > Update-Module DockerMsftProvider
  ```

- upgrade to latest version
  ```powershell
  > Install-Package -Name Docker -ProviderName DockerMsftProvider -Update -Force
    Name                           Version          Source           Summary
    ----                           -------          ------           -------
    Docker                         20.10.9          DockerDefault    Contains Docker EE for use with Windows Server.
  > Get-Package -Name Docker -ProviderName DockerMsftProvider
    Name                           Version          Source                           ProviderName
    ----                           -------          ------                           ------------
    docker                         20.10.9          DockerDefault                    DockerMsftProvider
  > docker --version
    Docker version 20.10.9, build 591094d

  > Start-Service Docker
  ```

- or to particular version
  ```powershell
  > Install-Package -Name docker -ProviderName DockerMsftProvider -RequiredVersion 18.09 -Update -Force
  ```

- [uninstall](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon)
  ```powershell
  # clean docker images and processes
  > docker swarm leave --force
  > docker rm -f $(docker ps --all --quiet)
  > docker system prune --all --volumes

  # uninstall
  > Uninstall-Package -Name docker -ProviderName DockerMsftProvider
  > Uninstall-Module -Name DockerMsftProvider

  # clean up the network and filesystem
  > Get-HNSNetwork | Remove-HNSNetwork
  > Remove-Item -Path "C:\ProgramData\Docker" -Recurse -Force

  # get package via
  > Get-PackageProvider -Name *Docker*
  ```

- [Clean up Docker data and system components](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon#clean-up-docker-data-and-system-components)
  ```powershell
  > Get-HNSNetwork | Remove-HNSNetwork
  > Get-ContainerNetwork | Remove-ContainerNetwork
  > Remove-Item "C:\ProgramData\Docker" -Recurse

  # close Hyper-V
  > Remove-WindowsFeature Containers
  > Remove-WindowsFeature Hyper-V

  # reboot
  > Restart-Computer -Force
  ```


- [download docker manually](https://mpolinowski.github.io/docs/DevOps/Windows/2019-06-13--windows-server-2019-docker-daemon/2019-06-13/#downloading-docker-manually)

  > [!NOTE]
  > - [OneGet/MicrosoftDockerProvider](https://github.com/OneGet/MicrosoftDockerProvider)
  > - [Install Package Docker - Windows Server 2022 error](https://learn.microsoft.com/en-us/answers/questions/1324697/install-package-docker-windows-server-2022-error)

  ```powershell
  # On an online machine, download the zip file.
  > Invoke-WebRequest -UseBasicParsing -OutFile docker-19.03.3.zip https://download.docker.com/components/engine/windows-server/19.03/docker-19.03.3.zip

  # Stop Docker service if eralier version of Docker is already installed
  Stop-Service docker

  # Extract the archive.
  Expand-Archive docker-19.03.3.zip -DestinationPath $Env:ProgramFiles -Force

  # Clean up the zip file.
  Remove-Item -Force docker-19.03.3.zip

  # Install Docker. This requires rebooting.
  $null = Install-WindowsFeature containers

  Restart-Computer -Force

  # Add Docker to the path for the current session.
  $env:path += ';$env:ProgramFiles\docker'

  # Optionally, modify PATH to persist across sessions.
  $newPath = '$env:ProgramFiles\docker;' +
  [Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine)
  [Environment]::SetEnvironmentVariable('PATH', $newPath, [EnvironmentVariableTarget]::Machine)

  # Register the Docker daemon as a service.
  dockerd --register-service

  # Start the Docker service.
  Start-Service docker

  # verify
  docker pull hello-world:nanoserver
  docker images
  docker container run hello-world:nanoserver
  ```

- pull and run windows image
  ```powershell
  > docker pull mcr.microsoft.com/dotnet/samples:dotnetapp-nanoserver-2009
  > docker run mcr.microsoft.com/dotnet/samples:dotnetapp-nanoserver-2009
  ```

<!--sec data-title="Use a script to install docker-ee" data-id="section0" data-show=true data-collapse=true ces-->
```powershell
# inspired from http://man.hubwiz.com/docset/Docker.docset/Contents/Resources/Documents/docs.docker.com/install/windows/docker-ee.html

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
<!--endsec-->

- check

  > [!NOTE]
  > - [imarslo: stop service & process via powershell](../../cheatsheet/windows/windows.html#stop-service--process-via-powershell)
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

#### update `daemon.json` for docker-ee
```powershell
> $configfile = @"
{
  "tls": false,
  "hosts": ["tcp://0.0.0.0:2376", "npipe://"],
  "debug": true,
  "data-root": "E:\\docker_home",
  "storage-opts": []
}
"@

> $configfile | Out-File -FilePath C:\ProgramData\docker\config\daemon.json -Encoding ascii -Force
> Start-Service Docker

# or
> Restart-Service Docker
```
- verify
  ```powershell
  > docker info
  ...
  Docker Root Dir: E:\docker_home
  ...
  WARNING: API is accessible on http://0.0.0.0:2376 without encryption.
           Access to the remote API is equivalent to root access on the host. Refer
           to the 'Docker daemon attack surface' section in the documentation for
           more information: https://docs.docker.com/go/attack-surface/

  > docker -H tcp://localhost:2376 images
  REPOSITORY          TAG                    IMAGE ID       CREATED         SIZE
  hello-world         nanoserver             e33d37034c87   33 hours ago    258MB
  ```

#### running linux container in windows server

- [by enable experimental features in docker daemon.conf](https://mountainss.wordpress.com/2020/03/31/docker-linux-container-running-on-windows-server-2019-winserv-docker-containers/)
  - Set LCOW_SUPPORTED Variable to 1 for enabled
    ```powershell
    > [Environment]::SetEnvironmentVariable(“LCOW_SUPPORTED”, “1”, “Machine”)
    ```

  - enable experimental features in docker `daemon.conf`
    ```powershell
    > $configfile = @"
    {
        "experimental": true
    }
    "@

    > $configfile | Out-File -FilePath C:\ProgramData\docker\config\daemon.json -Encoding ascii -Force
    ```

  - deploy LCOW for it to run
    ```powershell
    > Invoke-WebRequest -Uri “https://github.com/linuxkit/lcow/releases/download/v4.14.35-v0.3.9/release.zip&#8221; -UseBasicParsing -OutFile release.zip
    > Expand-Archive release.zip -DestinationPath “$Env:ProgramFiles\Linux Containers\.”
    ```

  - make Linux containers the Default
    ```powershell
    > [Environment]::SetEnvironmentVariable(“LCOW_API_PLATFORM_IF_OMITTED”, “linux”, “Machine”)
    ```

- [by pre build docker-ee](https://computingforgeeks.com/how-to-run-docker-containers-on-windows-server-2019/)
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
    > [Environment]::SetEnvironmentVariable("LCOW_SUPPORTED", "1", "Machine")
    ```

    - to Switch back to running Windows containers
      ```powershell
      > [Environment]::SetEnvironmentVariable("LCOW_SUPPORTED", "$null", "Machine")
      ```

- restart docker service
  ```powershell
  > Restart-Service docker
  ```

- check
  ```powershell
  > docker run -it --rm ubuntu /bin/bash
  ```

#### [FIPS 140-2 cryptographic module support](http://man.hubwiz.com/docset/Docker.docset/Contents/Resources/Documents/docs.docker.com/install/windows/docker-ee.html)
```powershell
> [System.Environment]::SetEnvironmentVariable("DOCKER_FIPS", "1", "Machine")

# regedit
> Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy\" -Name "Enabled" -Value "1"

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

> [!TIP]
> - [* Hyper-V Technology Overview](https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/hyper-v-technology-overview)
> - [* Install the Hyper-V role on Windows Server](https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/get-started/install-the-hyper-v-role-on-windows-server)
> - [* Docker Linux Container running on Windows Server 2019](https://mountainss.wordpress.com/2020/03/31/docker-linux-container-running-on-windows-server-2019-winserv-docker-containers/)
> - [System requirements for Hyper-V on Windows Server](https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/system-requirements-for-hyper-v-on-windows#general-requirements)
> - [* Create Virtual Machine with Hyper-V on Windows 10](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/create-virtual-machine)

### installation
#### in windows servers

> [!TIP]
> If you're connected locally to the server, run the command without `-ComputerName <computer_name>`.

- via commands
  ```powershell
  > Install-WindowsFeature -Name Hyper-V [-ComputerName <computer_name>] -IncludeManagementTools -Restart
  ```
  - check
    ```powershell
    > Get-WindowsFeature -ComputerName <computer_name>
    ```
- manually
  1. In **Server Manager**, on the **Manage menu**, click `Add Roles and Features`.
  1. On the Before you begin page, verify that your destination server and network environment are prepared for the role and feature you want to install. Click `Next`.
  1. On the Select installation type page, select `Role-based` or `feature-based` installation and then click `Next`.
  1. On the Select destination server page, select a server from the server pool and then click Next.
  1. On the Select server roles page, select `Hyper-V`.
  1. To add the tools that you use to create and manage virtual machines, click `Add Features`. On the Features page, click `Next`.
  1. On the Create Virtual Switches page, Virtual Machine Migration page, and Default Stores page, select the appropriate options.
  1. On the Confirm installation selections page, select `Restart the destination server automatically if required`, and then click `Install`.
  1. When installation is finished, verify that Hyper-V installed correctly. Open the All Servers page in Server Manager and select a server on which you installed Hyper-V. Check the Roles and Features tile on the page for the selected server.

#### in windows 10

> [!NOTE]
> references:
> - [Enable-WindowsOptionalFeature](https://learn.microsoft.com/en-us/powershell/module/dism/enable-windowsoptionalfeature?view=windowsserver2022-ps)
> - [Hyper-V on Windows 10](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/)
>   - [Install Hyper-V on Windows 10](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)
>   - [Create Virtual Machine with Hyper-V on Windows 10](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/create-virtual-machine?source=recommendations)
>   - [Create a Virtual Machine with Hyper-V on Windows 10 Creators Update](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/quick-create-virtual-machine)
> - [Remotely manage Hyper-V](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/dn632582(v=ws.11))
> - [DISM Technical Reference](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)

- via powershell
  ```powershell
  > Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
  ```

  - check
    ```powershell
    > Get-WindowsOptionalFeature -Online [| Where-Object {$_.State -eq "Enabled"}] [| format-table]
    ```
    ![windows optional feature](../../screenshot/docker/hyper-v-win10-ps-table.png)

- via cmd and dism
  ```batch
  > DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
  ```

- via manually

  1. <kbd>win</kbd> -> **Apps and Features**
  1. select **Programs and Features**
  1. select **Turn Windows Features on or off**
  1. Select **Hyper-V** and click **OK**

  ![enable hyper-v in settings](../../screenshot/docker/hyper-v-win10-via-settings.png)

- others
  - shortcut located in : `shell:Common Administrative Tools` ( `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools` )
  - Hyper-V Quick Create : `%ProgramFiles%\Hyper-V\VMCreate.exe`
  - Hyper-V Manager : `%windir%\System32\mmc.exe "%windir%\System32\virtmgmt.msc"`

### [Windows Docker Container Hyper-V Isolation](https://www.virtualizationhowto.com/2020/12/install-docker-in-windows-server-2019/)
```powershell
> docker run -it --isolation=hyperv mcr.microsoft.com/windows/servercore:ltsc2019

# check
> get-process -Name vmwp
```

### [create a virtual machine with powershell by Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/create-virtual-machine#create-a-virtual-machine-with-powershell)
```powershell
# Set VM Name, Switch Name, and Installation Media Path.
$VMName = 'TESTVM'
$Switch = 'External VM Switch'
$InstallMedia = 'C:\Users\Administrator\Desktop\en_windows_10_enterprise_x64_dvd_6851151.iso'

# Create New Virtual Machine
New-VM -Name $VMName -MemoryStartupBytes 2147483648 -Generation 2 -NewVHDPath "D:\Virtual Machines\$VMName\$VMName.vhdx" -NewVHDSizeBytes 53687091200 -Path "D:\Virtual Machines\$VMName" -SwitchName $Switch

# Add DVD Drive to Virtual Machine
Add-VMScsiController -VMName $VMName
Add-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path $InstallMedia

# Mount Installation Media
$DVDDrive = Get-VMDvdDrive -VMName $VMName

# Configure Virtual Machine to Boot from DVD
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVDDrive
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
