---
layout: single
title: Docker Setup
permalink: /
toc: false
---

# MagicMirror²

is an open source modular smart mirror platform. For more info visit the [project website](https://github.com/MagicMirrorOrg/MagicMirror). This project packs MagicMirror into a docker image.

# Why Docker?

Using docker simplifies the setup by using the docker image instead of setting up the host with installing all the node.js stuff etc.
Getting/Updating the image is done with one command.

We have three usecases:
- Scenario **server** ☝️: Running the application in server only mode.

  This will start the server, after which you can open the application in your browser of choice.
  This is e.g useful for testing or running the application somewhere online, so you can access it with a browser from everywhere.

- Scenario **electron** ✌️: Using docker on the raspberry pi and starting the MagicMirror on the screen of the pi using electron.

- Scenario **client** 👌: Using docker on the raspberry pi and starting the MagicMirror on the screen of the pi using another running MagicMirror instance.
