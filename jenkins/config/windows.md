<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [windows agent](#windows-agent)
  - [windows agent configuration](#windows-agent-configuration)
  - [start service](#start-service)
  - [remove service](#remove-service)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## windows agent

### windows agent configuration
- jenkins node

![config](../../screenshot/jenkins/config/win-1.png)

### start service

#### open the node connection page -> `Launch` -> `File` -> `Install as a server`

![start server manually](../../screenshot/jenkins/config/win-3.png)

#### setup `jenkins-slave.exe`

![run as administrator](../../screenshot/jenkins/config/win-6.png)

#### install and start service by `cmd` -> `sc.exe`

![sc](../../screenshot/jenkins/config/win-7.png)

```bat
C:\WINDOWS\system32>sc.exe create "jenkins" start= auto binPath= "E:\devops\jenkins-slave.exe" DisplayName= "jenkins"
[SC] CreateService SUCCESS

C:\WINDOWS\system32>sc description jenkins "the windows agent for jenkins <https://<JENKINS_URL>>"
[SC] ChangeServiceConfig2 SUCCESS

C:\WINDOWS\system32>sc start jenkins

SERVICE_NAME: jenkins
        TYPE               : 10  WIN32_OWN_PROCESS
        STATE              : 2  START_PENDING
                                (STOPPABLE, NOT_PAUSABLE, ACCEPTS_SHUTDOWN)
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x0
        PID                : 27784
        FLAGS              :
```

> reference: [sc.exe query](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/sc-query)

- service configuration
  ```bat
  C:\WINDOWS\system32>sc config jenkins start= disabled
  [SC] ChangeServiceConfig SUCCESS

  C:\WINDOWS\system32>sc query jenkins

  SERVICE_NAME: jenkins
          TYPE               : 10  WIN32_OWN_PROCESS
          STATE              : 4  RUNNING
                                  (STOPPABLE, NOT_PAUSABLE, ACCEPTS_SHUTDOWN)
          WIN32_EXIT_CODE    : 0  (0x0)
          SERVICE_EXIT_CODE  : 0  (0x0)
          CHECKPOINT         : 0x0
          WAIT_HINT          : 0x0
  ```

- list all services
  ```bat
  C:\WINDOWS\system32>sc queryex type=service state=all | find /i "SERVICE_NAME:"
  SERVICE_NAME: AJRouter
  SERVICE_NAME: ALG
  SERVICE_NAME: AppIDSvc
  SERVICE_NAME: Appinfo
  SERVICE_NAME: AppMgmt
  SERVICE_NAME: AppReadiness
  SERVICE_NAME: AppVClient
  SERVICE_NAME: AppXSvc
  SERVICE_NAME: AudioEndpointBuilder
  SERVICE_NAME: Audiosrv
  SERVICE_NAME: AxInstSV
  ...
  ```

- setup service

![restart when anything abnormal](../../screenshot/jenkins/config/win-8.png)

### remove service

![remove service](../../screenshot/jenkins/config/win-9.png)

```bat
C:\WINDOWS\system32>sc stop jenkins

SERVICE_NAME: jenkins
        TYPE               : 10  WIN32_OWN_PROCESS
        STATE              : 3  STOP_PENDING
                                (STOPPABLE, NOT_PAUSABLE, ACCEPTS_SHUTDOWN)
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x0

C:\WINDOWS\system32>sc delete jenkins
[SC] DeleteService SUCCESS

C:\WINDOWS\system32>taskkill /F /IM mmc.exe
SUCCESS: The process "mmc.exe" with PID 19572 has been terminated.
```

or remove `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\jenkins`
