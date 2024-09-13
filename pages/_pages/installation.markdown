---
layout: single
title: Installation
permalink: /installation/
---
## Installation prerequisites

- [Docker](https://docs.docker.com/engine/installation/)
- to run `docker` commands without needing `sudo` please refer to the [linux postinstall documentation](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)
- as we are using `docker compose` commands the compose plugin must be installed. If missing you find [here](https://docs.docker.com/compose/install/linux/) instructions how to install it. ⚠️ This setup needs `docker compose` version `2.20.3` or above, you can check the version with `docker compose version`. If you don't want to use compose, see [this section in the FAQ](/magicmirror/faq/#how-to-start-magicmirror-without-using-composeyaml-files)

## Additional prerequisites for running on a raspberry pi with Scenario **electron** ✌️ or **client** 👌

- disable the screensaver (depends on the underlying os), otherwise MagicMirror will disappear after a while.
- enable "Wait for Network at Boot" (with `sudo raspi-config`, navigate to "3 boot options" and choose "B2 Wait for Network at Boot"). If not set, some modules will remaining in "loading..." state because MagicMirror starts to early.
- when using wlan you should disable "power_save" (depends on the underlying os, e.g. `sudo iw wlan0 set power_save off`), otherwise MagicMirror can not update the displayed data without working internet connection.

## Installation of this Repository

Open a shell in your home directory and run
```bash
git clone https://gitlab.com/khassel/magicmirror.git
```

### Use install script

`cd` into the new directory `magicmirror/install` and  execute `bash install.sh <scenario>` where you have to replace `<scenario>` with `electron` or `server` or `client`.

### Manual Install

`cd` into the new directory `magicmirror/run` and copy 2 files:

```bash
cd ./magicmirror/run
cp original.env .env
cp original.compose.yaml compose.yaml
```

Depending on the scenario you have to edit the `.env` file:

For scenario **server** ☝️:
```bash
MM_SCENARIO="server"
```

This is already the default.

For scenario **electron** ✌️:
```bash
MM_SCENARIO="electron"
```

For scenario **client** 👌:
```bash
MM_SCENARIO="client"
MM_INIT="no_init"
```

> ⚠️ You have to edit the value `MM_SERVER_PORTS` in the `.env` file if you are running scenario **server** and want to use another port.

> ⚠️ You have to edit the values `MM_CLIENT_PORT` and `MM_CLIENT_ADDRESS` in the `.env` file if you are running scenario **client**.

### Using own compose file

If you have an own compose file where you want to add this setup you can use the install script or manual install and then run `docker compose config` in the `magicmirror/run` folder. You can copy/paste the output in your existing compose file. There are more informations in the [FAQ](/magicmirror/faq/#how-to-start-magicmirror-without-using-composeyaml-files).

A minimal compose file for scenario **server** ☝️ is:

```yaml
services:
  magicmirror:
    container_name: mm
    image: karsten13/magicmirror:latest
    restart: unless-stopped
    volumes:
      - ../mounts/config:/opt/magic_mirror/config
      - ../mounts/modules:/opt/magic_mirror/modules
      - ../mounts/css:/opt/magic_mirror/css
    ports:
      - 8080:8080
```

## Start MagicMirror²

Navigate to `~/magicmirror/run` and execute

```bash
docker compose up -d
```

The container will start and with scenario **electron** ✌️ or **client** 👌 the MagicMirror should appear on the screen of your pi. In server only mode opening a browser at `http://localhost:8080` should show the MagicMirror (scenario **server** ☝️).

> The container is configured to restart automatically so after executing `docker compose up -d` it will also restart after a reboot of your pi.


You can see the logs with

```bash
docker logs mm
```

Executing
```bash
docker ps -a
```
will show all containers and 

```bash
docker compose down
```

will stop and remove the MagicMirror container.

You can restart the container with one command `docker compose up -d --force-recreate`. This is e.g. necessary if you change the configuration.

## Updating the image

The MagicMirror²-Project has quarterly releases so every 1st of Jan/Apr/Jul/Oct a new version is released.

This project ist updated weekly every sunday to get (security) updates of the operating system.

To get the newest image you have to update this locally. Navigate to `~/magicmirror/run` and execute

```bash
docker compose pull
```

After the new image is pulled you have to restart the container with

```bash
docker compose up -d
```

> With every new image the old image remains on your hard disc and occupies disk space. To get rid of all old images you can execute `docker image prune -f`.

## Init container and running as root

The container runs with userid=1000, this is normally the userid of the pi user.

The volumes on the host (~/magicmirror/mounts/*) are created at first start from the docker daemon with userid=0 (root), so we have to correct the permissions, otherwise the container cannot access the volumes. This is done by a init container which is started before the mm container.

If you don't want or need this behavior you can remove the init container by setting `MM_INIT="no_init"` in the `.env` file.

The container has no root permissions and no `sudo` installed, so if you need such permissions you have to add `user: root` to the `compose.yaml` file.

## Running on Raspberry Pi OS Lite (or on another operating system without desktop)

You can use Raspberry Pi OS Lite as operating system which has no graphical desktop. You have to setup Raspberry Pi OS Lite yourself and login (directly or per ssh).

You need to install `git` with

```bash
sudo apt-get update
sudo apt-get install -y git
```

and then clone this repository.

For installing you can use the install script as described above.