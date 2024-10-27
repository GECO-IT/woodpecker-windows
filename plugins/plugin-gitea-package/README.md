# Woodpecker CI - Gitea Package plugin

## Overview

Woodpecker CI plugin to upload any file to the _Gitea Generic Package Registry_.

For details about the features and limits of the _Generic Package Registry_ their [docs](https://docs.gitea.com/usage/packages/generic).

Windows port of <https://gitea.ocram85.com/plugins/gitea-package>

## Settings

| Settings Name     | Default | Description                         |
| ----------------- | ------- | ----------------------------------- |
| `user`            | _none_  | Gitea user for basic auth           |
| `password`        | _none_  | User Password or Token (PAT)        |
| `owner`           | _none_  | Package owner                       |
| `package_name`    | _none_  | The package name                    |
| `package_version` | _none_  | Package version                     |
| `file_source`     | _none_  | File source path for upload.        |
| `file_name`       | _none_  | Package file name                   |
| `update`          | _false_ | Allow update existing package files |

## Pipeline Usage

```yaml
...
steps:
  upload-package:
    image: <REPO_URL>/woodpecker-gitea-package-plugin
    settings:
      user:
        from_secret: gitea_user
      token:
        from_secret: gitea_token
      owner: c.duchenoy
      package_name: ${CI_REPO_NAME,,}
      package_version: "1.0.0"
      file_source: ./build/program.exe
      file_name: test.exe
      update: true
    when:
      event: tag
      branch: ${CI_REPO_DEFAULT_BRANCH}
```
