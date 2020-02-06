#!/bin/sh

rm -rf /opt/magic_mirror/modules/default

mkdir -p /opt/magic_mirror/modules/default
mkdir -p /opt/magic_mirror/config

cp -r /opt/magic_mirror/mount_ori/modules/default/. /opt/magic_mirror/modules/default/

if [ ! -f /opt/magic_mirror/config/config.js ]; then
  cp /opt/magic_mirror/mount_ori/config/config.js.sample /opt/magic_mirror/config/config.js
fi

sudo chown -R node:node /opt/magic_mirror/modules
sudo chown -R node:node /opt/magic_mirror/config

if [ "$StartEnv" = "test" ]; then 

  echo "start tests"
  Xvfb :99 -screen 0 1024x768x16 &
  export DISPLAY=:99
  
  # adjust test timeouts
  sed -i "s:test.timeout(10000):test.timeout(30000):g" tests/e2e/global-setup.js
  cat tests/e2e/global-setup.js
  
  grunt
  npm run test:unit
  npm run test:e2e

else

  echo "start magicmirror"

  exec "$@"
fi
