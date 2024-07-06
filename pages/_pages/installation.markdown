---
layout: single
title: Installation
permalink: /installation/
---
## Installation prerequisites

- [Docker](https://docs.docker.com/engine/installation/)
- to run `docker` commands without needing `sudo` please refer to the [linux postinstall documentation](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)
- as we are using `docker compose` commands the compose plugin must be installed. If missing you find [here](https://docs.docker.com/compose/install/linux/) instructions how to install it. If you don't want to use compose, see [this section in the FAQ](/magicmirror/faq/#how-to-start-magicmirror-without-using-docker-composeyml-files)

## Additional prerequisites for running on a raspberry pi with Scenario **electron** ✌️ or **client** 👌

- disable the screensaver (depends on the underlying os), otherwise MagicMirror will disappear after a while.
- enable "Wait for Network at Boot" (with `sudo raspi-config`, navigate to "3 boot options" and choose "B2 Wait for Network at Boot"). If not set, some modules will remaining in "loading..." state because MagicMirror starts to early.
- when using wlan you should disable "power_save" (depends on the underlying os, e.g. `sudo iw wlan0 set power_save off`), otherwise MagicMirror can not update the displayed data without working internet connection.

## Installation of this Repository

Open a shell in your home directory and run
```bash
git clone https://gitlab.com/khassel/magicmirror.git
```

Now cd into the new directory `magicmirror/run` and copy the yml-file depending on the scenario.

For scenario **server** ☝️:
```bash
cd ./magicmirror/run
cp serveronly.yml docker-compose.yml
```

For scenario **electron** ✌️:
```bash
cd ./magicmirror/run
cp rpi.yml docker-compose.yml
```

For scenario **client** 👌:
```bash
cd ./magicmirror/run
cp clientonly.yml docker-compose.yml
```

> ⚠️ You have to edit the `docker-compose.yml` if you are running scenario **server** and want to use another port.

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

This project ist updated weekly because the image contains debian as operating system. To get (security) updates in time the image build is executed every sunday.

To get the newest image you have to update this locally. Navigate to `~/magicmirror/run` and execute

```bash
docker compose pull
```

After the new image is pulled you have to restart the container with

```bash
docker compose up -d
```

> With every new image the old image remains on your hard disc and occupies disk space. To get rid of all old images you can execute `docker image prune -f`.
