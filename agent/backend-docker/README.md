# Woodpecker Windows Agent - Backend Docker

- [Woodpecker Windows Agent - Backend Docker](#woodpecker-windows-agent---backend-docker)
  - [Tested environment](#tested-environment)
  - [Install Docker](#install-docker)
    - [Windows Features](#windows-features)
    - [Docker daemon](#docker-daemon)
    - [Install Docker Plugins](#install-docker-plugins)
    - [Pull Windows Base Images](#pull-windows-base-images)
  - [Build your own containers](#build-your-own-containers)
  - [Install Woodpecker Agent](#install-woodpecker-agent)
    - [Configuration](#configuration)
    - [Autostart at bootup](#autostart-at-bootup)
    - [Create Clean Task Schedule](#create-clean-task-schedule)
  - [Pipeline Usage](#pipeline-usage)

## Tested environment

- Windows Server 2019 core installation
- Windows Server 2022 core installation
- Docker >= 20.10
- Woodpecker Agent **v1.05 to v2.6.0** (version >= 2.6.1 **KO**)

## Install Docker

### Windows Features

Enable the Containers feature, and disable Windows Defender to stop it burning CPU cycles...

```powershell
PS C:\> Install-WindowsFeature -Name Containers
PS C:\> Uninstall-WindowsFeature Windows-Defender
PS C:\> Restart-Computer -Force
```

### Docker daemon

- Source: <https://learn.microsoft.com/en-us/virtualization/windowscontainers/quick-start/set-up-environment?tabs=dockerce>

```powershell
PS C:\> Invoke-WebRequest -UseBasicParsing -o install-docker-ce.ps1 `
  "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1"

PS C:\> .\install-docker-ce.ps1 -DockerVersion "20.10.24"
PS C:\> Remove-Item -Path ".\install-docker-ce.ps1" -Forcece.ps1" -Force
```

### Install Docker Plugins

- Docker Commpose

```bash
C:\> mkdir C:\ProgramData\docker\cli-plugins

C:\> curl -fSsLo C:\Windows\System32\docker-compose.exe ^
          https://github.com/docker/compose/releases/download/v2.24.4/docker-compose-windows-x86_64.exe

C:\> mklink C:\ProgramData\docker\cli-plugins\docker-compose.exe C:\Windows\System32\docker-compose.exe
```

- Docker Buildx

```bash
C:\> curl -fSsLo C:\Windows\System32\docker-buildx.exe ^
          https://github.com/docker/buildx/releases/download/v0.17.1/buildx-v0.17.1.windows-amd64.exe

C:\> mklink C:\ProgramData\docker\cli-plugins\docker-buildx.exe C:\Windows\System32\docker-buildx.exe
```

### Pull Windows Base Images

Any Docker containers you run on Windows Server will be based on Windows Server Core or Nano Server.
View <https://mcr.microsoft.com/en-us/product/windows/servercore/about>

- Windows 2019 Based

```bash
C:\> docker image pull mcr.microsoft.com/windows/servercore:ltsc2019
C:\> docker image pull mcr.microsoft.com/windows/nanoserver:ltsc2019
# optionnal: docker pull mcr.microsoft.com/windows/server:ltsc2019
```

- Windows 2022 Based

```bash
C:\> docker image pull mcr.microsoft.com/windows/servercore:ltsc2022
C:\> docker image pull mcr.microsoft.com/windows/nanoserver:ltsc2022
# optionnal: docker pull mcr.microsoft.com/windows/server:ltsc2022
```

## Build your own containers

Follow [documentation](../../build/README.md) or you can
use images at <https://hub.docker.com/search?q=gecoit84>

```command
C:\> docker pull gecoit84/woodpecker-agent:2.6.0
C:\> docker pull gecoit84/woodpecker-windows-base:latest
C:\> docker pull gecoit84/woodpecker-git-plugin:2.6.0

# retag for git trusted plugin
C:\> docker image tag gecoit84/woodpecker-git-plugin:2.6.0 ^
                      woodpeckerci/plugin-git:latest
```

## Install Woodpecker Agent

### Configuration

- Copy directory _**backend-docker**_ to _**C:\ProgramData\woodpecker-docker**_
- Get your SSL public cert file and copy to _**.\volumes\ssl**_ (optionnal)
- Copy and edit _**.env.woodpecker-agent.sample**_ to _**.env.woodpecker-agent**_

```bash
WOODPECKER_SERVER="woodpecker.xxx"
WOODPECKER_GRPC_SECURE="true"
WOODPECKER_GRPC_VERIFY="true"
WOODPECKER_MAX_WORKFLOWS="2"
WOODPECKER_AGENT_SECRET="xxx"
WOODPECKER_HOSTNAME="woodpecker-agent5"
```

- Edit _**docker-compose.yml**_
- Start your Woodpecker agent

```powershell
PS C:\> cd C:\ProgramData\woodpecker-docker
PS C:\ProgramData\woodpecker-docker> docker compose up -d
[+] Running 1/1
 ✔ Container woodpecker-docker-agent-1  Started

PS C:\ProgramData\woodpecker-docker> docker compose logs agent
...
agent-1  |... starting Woodpecker agent with version '2.6.0' and backend
'docker' using platform 'windows/amd64' running up to 2 pipelines in parallel ...
```

### Autostart at bootup

```cmd
C:\> SCHTASKS /CREATE /SC ONSTART /TN "Geco-iT\Docker Woodpecker startup" ^
                  /TR "C:\ProgramData\woodpecker-docker\startup.cmd" /RU system
```

### Create Clean Task Schedule

- <https://woodpecker-ci.org/docs/administration/backends/docker#image-cleanup>

```bash
# Clean @eachday @02:00
C:\> SCHTASKS /CREATE /SC DAILY /TN "Geco-iT\Woodpecker Cleaner" /ST 02:00 /RU system ^
        /TR "C:\ProgramData\woodpecker-docker\geco-docker-woodpecker-prune.crond.cmd"
```

## Pipeline Usage

```yaml
---
labels:
  platform: windows/amd64
  backend: docker

workspace:
  base: C:\tmp

clone:
  git:
    # $ docker image tag \
    #        <REPO_URL>/woodpecker/woodpecker-git-plugin:latest \
    #        woodpeckerci/plugin-git:latest
    image: woodpeckerci/plugin-git
    pull: false

steps:
...
```
