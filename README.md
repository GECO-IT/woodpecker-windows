# Woodpecker-windows [![status-badge](https://ci.cereg.com/api/badges/62/status.svg)](https://ci.cereg.com/repos/62)

All stuff for use [Woodpecker CI](https://woodpecker-ci.org) on Windows

- [Woodpecker-windows ](#woodpecker-windows-)
  - [Install Woodpecker Agent](#install-woodpecker-agent)
    - [Docker Backend](#docker-backend)
    - [Local Backend](#local-backend)
  - [Pipeline Usage](#pipeline-usage)
    - [Backend Docker](#backend-docker)
    - [Backend Local](#backend-local)
  - [Plugins Usage](#plugins-usage)

## Install Woodpecker Agent

### Docker Backend

Follow [documentation](./agent/backend-docker/README.md)

### Local Backend

Follow [documentation](./agent/backend-local/README.md)

## Pipeline Usage

### Backend Docker

```yaml
---
labels:
  platform: windows/amd64
  backend: docker

workspace:
  base: C:\tmp

clone:
  git:
    image: <REPO_URL>/woodpecker-git-plugin

steps:
...
```

### Backend Local

```yaml
---
labels:
  platform: windows/amd64
  backend: local

steps:
...
```

## Plugins Usage

- [git](./plugins/plugin-git/README.md)
- [git-basic-changelog](./plugins/plugin-git-basic-changelog/README.md)
- [gitea-package](./plugins/plugin-gitea-package/README.md)
- [teams-notify](./plugins/plugin-teams-notify/README.md)
- [drone-docker](./plugins/plugin-drone-docker/README.md)
- [drone-s3](./plugins/plugin-drone-s3/README.md)
