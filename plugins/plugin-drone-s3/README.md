# Woodpecker CI - Drone S3 plugin

> **Warning**
> use only for **`LOCAL BACKEND`**; for docker backend use official plugin: <https://woodpecker-ci.org/plugins/S3%20Plugin>

- Documentation: <https://plugins.drone.io/plugins/s3>

## Installation

- Get drone-s3.exe from docker image (or download it from <https://github.com/drone-plugins/drone-s3/releases>)

```bash
C:\> cd C:\ProgramData\woodpecker-local\backend-local\bin

C:\> docker create --name plugin plugins/s3

C:\> docker cp plugin:C:\\drone-s3.exe drone-s3.exe

C:\> docker rm plugin
```

## Pipeline Usage

```yaml
---
labels:
  platform: windows/amd64
  backend: local

steps:
  # https://plugins.drone.io/plugins/s3
  s3-upload-plugin:
    image: drone-s3.exe # must be in your host windows path
    settings:
      path_style: true  # minio
      bucket: woodpecker
      endpoint:  # API port of minio (9000)
        from_secret: woodpecker_minio_endpoint
      access_key:
        from_secret: woodpecker_minio_access_key
      secret_key:
        from_secret: woodpecker_minio_secret_key
      source: test.py
      target: ${CI_REPO_OWNER^^}/${CI_REPO_NAME}
    when:
      event: [push, tag]
```
