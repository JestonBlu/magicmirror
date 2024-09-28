#!/bin/bash

set -e

docker cp mm:/opt/magic_mirror/package.json /mnt/c/data/repo/foreign/MagicMirror/
docker cp mm:/opt/magic_mirror/package-lock.json /mnt/c/data/repo/foreign/MagicMirror/

docker cp mm:/opt/magic_mirror/vendor/package.json /mnt/c/data/repo/foreign/MagicMirror/vendor/
docker cp mm:/opt/magic_mirror/vendor/package-lock.json /mnt/c/data/repo/foreign/MagicMirror/vendor/

docker cp mm:/opt/magic_mirror/fonts/package.json /mnt/c/data/repo/foreign/MagicMirror/fonts/
docker cp mm:/opt/magic_mirror/fonts/package-lock.json /mnt/c/data/repo/foreign/MagicMirror/fonts/
