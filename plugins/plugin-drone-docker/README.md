# Woodpecker CI - Drone Docker plugin

Use buildx on windows failed; we must try to setup buildkitd on windows !

View: <https://github.com/moby/buildkit/blob/master/docs/windows.md>

**Current Status**: KO !!!

## Workaround

```yaml
---
labels:
  platform: windows/amd64
  backend: local

steps:
  build:
    image: bash.exe
    environment:
      DOCKER_REGISTRY:
        from_secret: DOCKER_REGISTRY
      DOCKER_REGISTRY_USERNAME:
        from_secret: DOCKER_REGISTRY_USERNAME
      DOCKER_REGISTRY_PASSWORD:
        from_secret: DOCKER_REGISTRY_PASSWORD
    commands:
      # login to registry
      - echo "$${DOCKER_REGISTRY_PASSWORD}" | docker login $${DOCKER_REGISTRY} --username $${DOCKER_REGISTRY_USERNAME} --password-stdin
      # build container
      - docker build --tag sampleapp:v1 .
```

## Not follow this (don't work)

**Warning**: use only for **`LOCAL BACKEND`**; don't run on docker backend: **Docker Windows Buildx is KO!**

- Documentation: <https://plugins.drone.io/plugins/docker>

## Installation

- Get drone-docker.exe from docker image

```bash
C:\> cd C:\woodpecker-windows\agent\backend-local\bin

C:\> docker create --name plugin plugins/docker

C:\> docker cp plugin:C:\\bin\\drone-docker.exe drone-docker.exe

C:\> docker rm plugin
```

- Install buildkitd

Follow: <https://docs.docker.com/build/buildkit/#buildkit-on-windows>

## Pipeline Usage

```yaml
---
labels:
  platform: windows/amd64
  backend: local

steps:
  # https://plugins.drone.io/plugins/docker
  docker-windows-build:
    image: drone-docker.exe # must be in your host windows path
    environment:
      DOCKER_BUILDKIT: 0
      # view windows pipe: [System.IO.Directory]::GetFiles("\\.\pipe\") | sort
      #DOCKER_HOST: npipe://./pipe/docker_engine  # => KO
      #DOCKER_HOST: npipe:////./pipe/docker_engine #  => KO
      #DOCKER_HOST: npipe:\\\\.pipe\\docker_engine  #=> KO
      #DOCKER_HOST: npipe:\\.pipe\docker_engine  #=> KO
    settings:
      dry_run: true
      daemon_off: true
      registry: registry.xxxx.com
      repo: registry.xxxx.com/private/test-windows-to-delete
      username:
        from_secret: DOCKER_REGISTRY_USERNAME
      password:
        from_secret: DOCKER_REGISTRY_PASSWORD
      dockerfile: Dockerfile.Windows
      platforms: windows/amd64
      tags:
        - latest
        - ${CI_COMMIT_TAG}
        - ${CI_COMMIT_SHA:0:10}
    when:
      event: [push, tag]

```
