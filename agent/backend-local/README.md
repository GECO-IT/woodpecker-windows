# Woodpecker Windows Agent - Backend Local

## Configuration

1. Copy directory _**backend-local**_ to _**C:\ProgramData\woodpecker-local**_
2. Edit global vars _**setup.cmd**_

```bash
WOODPECKER_AGENT_VERSION="v2.6.0"
WOODPECKER_SERVER="woodpecker.lan.xxxxx:39443"
WOODPECKER_HOSTNAME="woodpecker-agentxxx"
WOODPECKER_AGENT_SECRET="xxxxx"
WOODPECKER_MAX_WORKFLOWS="2"
WOODPECKER_FILTER_LABELS=""

PLUGIN_GIT_VERSION="2.6.0"
```

## Setup

- Run installer

```bash
C:\ProgramData\woodpecker-local> .\setup.cmd
```

- Add Woodpecker plugins executable to path

```bash
C:\ProgramData\woodpecker-local> set SETUP_PATH="C:\ProgramData\woodpecker-local"
C:\ProgramData\woodpecker-local> setx /M PATH "%SETUP_PATH%\bin;%PATH%"
```

## Install & Configure git

- Install Software Manager - Chocolatey

```powershell
# install
PS C:\> Set-ExecutionPolicy Bypass -Scope Process -Force;
PS C:\> [System.Net.PS ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
PS C:\> iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# remember parameters on upgrade
choco feature enable -n=useRememberedArgumentsForUpgrades
```

- Install GIT

```bash
C:\> choco install git -y --params "'/Symlinks /NoShellIntegration /NoGuiHereIntegration /NoShellHereIntegration'"
C:\> choco install poshgit
```

- GIT Authentification

```bash
C:\> mkdir c:\tmp
C:\> cd C:\tmp
C:\tmp> curl -fSSL -o pstools.zip https://download.sysinternals.com/files/PSTools.zip
C:\tmp> unzip pstools.zip -d pstools
C:\tmp> rm -f pstools.zip
C:\tmp> .\pstools\psexec -i -s cmd.exe

# open new cmd.exe in system user
C:\Windows\system32> whoami
nt authority\system
C:\Windows\system32> git clone <REPO_TEST_URL>
```

## Pipeline Usage

```yaml
---
labels:
  platform: windows/amd64
  backend: local

steps:

  # example use minio command: mc.exe to upload file # mc.exe must be in $PATH
  s3-upload-mc:
    image: bash.exe
    secrets: [ bucket_name, access_key, secret_key ]
    environment:
      - S3_ENDPOINT=http://xxxx:9000
    commands:
      # connect alias
      - mc.exe alias set myminio $$env:S3_ENDPOINT $$env:ACCESS_KEY $$env:SECRET_KEY
      # status
      - mc.exe admin info myminio
      # upload file
      - mc.exe cp README.md myminio/$$env:BUCKET_NAME/$$env:CI_REPO/mc/README
...
```
