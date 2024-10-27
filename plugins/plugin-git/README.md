# Woodpecker CI - Git Clone plugin

* Documentation: <https://woodpecker-ci.org/plugins/Git%20Clone>
* Source: <https://github.com/woodpecker-ci/plugin-git>

You must add to our pipeline

```yaml
...
workspace:
  base: C:\tmp

clone:
  git:
    image: <REPO_URL>/woodpecker-git-plugin

steps:
...
```
