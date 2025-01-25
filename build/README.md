# Build Woodpecker Containers

- [Build Woodpecker Containers](#build-woodpecker-containers)
  - [Configuration](#configuration)
  - [Build](#build)
    - [All](#all)
    - [Mandatory](#mandatory)
    - [Optional](#optional)
  - [Push all images to your registry](#push-all-images-to-your-registry)
  - [Clean](#clean)

## Configuration

Copy and Edit  _**.env.sample**_ to _**.env**_ file

```bash
##
# Default docker registry
##
DOCKER_REGISTRY=registry.xxx/woodpecker

##
# Build Woodpecker Version: https://github.com/woodpecker-ci/woodpecker/tags
##
AGENT_VERSION=v3.0.1

##
# Plugins version
##
PLUGIN_GIT_VERSION=2.6.
```

## Build

```bash
C:\> cd .\build
```

### All

```bash
C:\> docker-compose.exe build
```

### Mandatory

- Woodpecker Windows Agent

```bash
C:\> docker-compose.exe build agent
```

- Woodpecker Windows Git Plugin

```bash
C:\> docker-compose.exe build plugin-git
```

### Optional

- Woodpecker Windows Base images

```bash
C:\> docker-compose.exe build base
C:\> docker-compose.exe build base-chocolatey
C:\> docker-compose.exe build base-chocolatey-msvsbuild # --memory 2GB
```

- Woodpecker Windows Python image

```bash
C:\> docker-compose.exe build python-3.12
C:\> docker-compose.exe build python-3.11
C:\> docker-compose.exe build python-3.10
```

- Woodpecker Windows Gitea/Forgejo Package Plugin

```bash
C:\> docker-compose.exe build plugin-gitea-package
```

- Woodpecker Windows Basic Changelog Plugin

```bash
C:\> docker-compose.exe build plugin-git-basic-changelog
```

- Woodpecker Windows Teams Notify Plugin

```bash
C:\> docker-compose.exe build plugin-teams-notify
```

- Woodpecker Windows Harbor Label Plugin

```bash
C:\> docker-compose.exe build plugin-teams-notify
```

## Push all images to your registry

```bash
C:\> docker-compose.exe push
```

## Clean

```bash
# Remove all stopped containers
C:\> for /f "tokens=*" %%i in ('docker ps --filter "status=exited" -q') do docker rm %%i

# Remove all unused images
C:\> for /f "tokens=*" %%i in ('docker images --filter "dangling=true" -q --no-trunc') do docker image rm %%i

# Remove Woodpecker Volumes
C:\> for /f "tokens=*" %%i in ('docker volume ls --filter "name=^wp_*" --filter "dangling=true" -q') do docker volume rm %%i
```
