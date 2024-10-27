# Woodpecker Windows Agent - Backend Local

## Configuration

1. Copy directory _**backend-local**_ to _**C:\ProgramData\woodpecker**_
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

* Run installer

```bash
C:\ProgramData\woodpecker> .\setup.cmd
```

* Add Woodpecker plugins executable to path

```bash
C:\ProgramData\woodpecker> set SETUP_PATH="C:\ProgramData\woodpecker"
C:\ProgramData\woodpecker> setx /M PATH "%SETUP_PATH%\bin;%PATH%"
```

## Pipeline Usage

```yaml
---
labels:
  platform: windows/amd64
  backend: docker

steps:

  # example use minio command: mc.exe to upload file # mc.exe must be in $PATH
  s3-upload-mc:
    image: powershell.exe
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
