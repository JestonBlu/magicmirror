---
layout: single
title: Docker Images
permalink: /images/
toc: false
---

> ⚠️ Changes in Aug. 2024 (see [installation](/magicmirror/installation/#init-container-and-running-as-root))
> - `sudo` removed (use user `root`)
> - updating volume permissions on startup removed (use init container)

## Images on [Docker Hub](https://hub.docker.com/r/karsten13/magicmirror/):  [![](https://img.shields.io/docker/pulls/karsten13/magicmirror.svg)](https://hub.docker.com/r/karsten13/magicmirror/)

The docker image `karsten13/magicmirror` is available with these tags:

TAG                | OS/ARCH     | ELECTRON | DISTRO | DESCRIPTION
------------------ | ----------- | -------- | -------|------------------------------------------
**latest** (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}) | linux/amd64 | no       | debian {{ site.data.gitlab.variables.DEBIAN_VERSION_MASTER }} slim | only `serveronly`-mode
**latest** (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}) | linux/arm   | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION_MASTER }} slim | for raspberry pi
**latest** (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}) | linux/arm64 | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION_MASTER }} slim | for raspberry pi4 64-Bit-Version
**fat** (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}_fat)| linux/amd64 | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION_MASTER }} | both modes
**fat** (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}_fat)| linux/arm   | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION_MASTER }} | for raspberry pi
**fat** (or {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }}_fat)| linux/arm64 | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION_MASTER }} | for raspberry pi4 64-Bit-Version
**alpine**             | all 3 archs | no       | alpine | only `serveronly`-mode, smaller in size

Version {{ site.data.gitlab.variables.MAGICMIRROR_VERSION }} is the current release of MagicMirror. Older version tags remain on docker hub, the other tags are floating tags and therefore overwritten with every new build. The used Node version is {{ site.data.gitlab.variables.NODE_VERSION_MASTER }}.

> The difference between `latest` and `fat` is image size and installed debian packages. For most use cases the `latest` image is sufficient. Some modules need dependencies which are not includes in `latest`, e.g. `python` or compilers, so in such cases you should use `fat`.

⛔ The following experimental images are not for production use:

TAG                | OS/ARCH     | ELECTRON | DISTRO | DESCRIPTION
------------------ | ----------- | -------- | -------|------------------------------------------
**develop**        | linux/amd64 | no       | debian {{ site.data.gitlab.variables.DEBIAN_VERSION_DEVELOP }} slim | only `serveronly`-mode
**develop**        | linux/arm   | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION_DEVELOP }} slim | for raspberry pi
**develop**        | linux/arm64 | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION_DEVELOP }} slim | for raspberry pi4 64-Bit-Version
**develop_fat**    | linux/amd64 | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION_DEVELOP }} | both modes
**develop_fat**    | linux/arm   | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION_DEVELOP }} | for raspberry pi
**develop_fat**    | linux/arm64 | yes      | debian {{ site.data.gitlab.variables.DEBIAN_VERSION_DEVELOP }} | for raspberry pi4 64-Bit-Version
**develop_alpine** | all 3 archs | no       | alpine | only `serveronly`-mode, smaller in size

These images are using the `develop` branch of the MagicMirror git repository and Node version {{ site.data.gitlab.variables.NODE_VERSION_DEVELOP }}.
