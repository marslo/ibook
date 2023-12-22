<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [install](#install)
- [start](#start)
- [stop](#stop)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [Handbook](https://minikube.sigs.k8s.io/docs/handbook/)
> - [kubernetes/minikube](https://github.com/kubernetes/minikube)

## install

- osx
  ```bash
  $ curl -sL -O https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
  $ sudo install minikube-darwin-amd64 /usr/local/bin/minikube
  ```

- linux
  ```bash
  $ curl -sL -O https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  $ sudo install minikube-linux-amd64 /usr/local/bin/minikube
  ```

- windows
  ```powershell
  > New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
  > Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing

  > $oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
  if ($oldPath.Split(';') -inotcontains 'C:\minikube'){
    [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath), [EnvironmentVariableTarget]::Machine)
  }
  ```

## start
```bash
$ minikube start
😄  minikube v1.32.0 on Darwin 14.1.1
✨  Automatically selected the docker driver
📌  Using Docker Desktop driver with root privileges
👍  Starting control plane node minikube in cluster minikube
🚜  Pulling base image ...
💾  Downloading Kubernetes v1.28.3 preload ...
    > preloaded-images-k8s-v18-v1...:  403.35 MiB / 403.35 MiB  100.00% 24.17 M
    > gcr.io/k8s-minikube/kicbase...:  453.90 MiB / 453.90 MiB  100.00% 13.76 M
🔥  Creating docker container (CPUs=2, Memory=7906MB) ...
🐳  Preparing Kubernetes v1.28.3 on Docker 24.0.7 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring bridge CNI (Container Networking Interface) ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

## stop
```bash
$ minikube stop
✋  Stopping node "minikube"  ...
🛑  Powering off "minikube" via SSH ...
🛑  1 node stopped.
```
