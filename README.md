# Woodpecker-windows [![status-badge](https://ci.geco-it.net/api/badges/6/status.svg)](https://ci.geco-it.net/repos/6)

All stuff for use [Woodpecker CI](https://woodpecker-ci.org) on Windows

- [Woodpecker-windows ](#woodpecker-windows-)
  - [Install Woodpecker Agent](#install-woodpecker-agent)
    - [Docker Backend](#docker-backend)
    - [Local Backend](#local-backend)
  - [Pipeline Usage](#pipeline-usage)
    - [Backend Docker](#backend-docker)
    - [Backend Local](#backend-local)
  - [Plugins Usage](#plugins-usage)
  - [License](#license)
  - [Author Information](#author-information)

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
    # $ docker image tag \
    #        <REPO_URL>/woodpecker/woodpecker-git-plugin:latest \
    #        woodpeckerci/plugin-git:latest
    image: woodpeckerci/plugin-git
    pull: false

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
- [drone-docker](./plugins/plugin-drone-docker/README.md)
- [drone-s3](./plugins/plugin-drone-s3/README.md)

## License

GPLv3+

## Author Information

This Windows port was created in 2024 by Cyril DUCHENOY, CEO of [Geco-iT SARL](https://www.geco-it.fr).

> **Note**
> Read-only source code mirror of Geco-iT Open Source projects.
