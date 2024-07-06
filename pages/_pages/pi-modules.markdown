---
layout: single
title: Pi Related Modules
permalink: /pi-modules/
---

Many modules are working out of the box with this docker setup. But if you want to use modules which needs hardware of the raspberry pi the setup can be tricky. This step-by-step example is a showcase how to solve such problems when you want to use a PIR motion sensor.

# MagicMirror with PIR motion sensor

## Install module MMM-Pir-Sensor-Lite

Start the container and login with `docker exec -it mm bash`. Navigate to the `modules` folder and clone [MMM-PIR-Sensor-Lite](https://github.com/grenagit/MMM-PIR-Sensor-Lite.git) with `git clone https://github.com/grenagit/MMM-PIR-Sensor-Lite.git`. Now `cd` into the new folder `MMM-PIR-Sensor-Lite` and run `npm install`.

## Configure MMM-PIR-Sensor-Lite

Every module needs to be configured in the `config.js` file. Here is my config for testing the module:

```javascript
  {
    module: "MMM-PIR-Sensor-Lite",
    position: "top_right",
    config: {
      sensorPin: 23, // GPIO pin
      deactivateDelay: 20000, // 20 sec
      showCountDown: true,
      showDetection: true,
    }
  }
```

The `sensorPin` is the gpio pin where you plugged in the motion sensor.
After updating the `config.js` you have to restart the container.

But the module will not work with the default image `karsten13/magicmirror:latest`, the module will remain in `Loading...` state.

The module needs `python3` to work which is not installed in `karsten13/magicmirror:latest`. We could build a custom image on top and install `python3` but the simpler solution is to use `karsten13/magicmirror:fat` where `python3` is already included.

So update your `docker-compose.yaml` with the new image and restart the container.

But the PIR-Sensor still does'nt work, because the used python script fails with: `RuntimeError: No access to /dev/mem.  Try running as root!`.

To get this working you have to add an additional device into your `docker-compose.yml` in the `devices:` section: ` - /dev/gpiomem`.

Your `docker-compose.yml` file should now look like:

```yaml
services:
  magicmirror:
    container_name: mm
    image: karsten13/magicmirror:fat
    volumes:
      - ../mounts/config:/opt/magic_mirror/config
      - ../mounts/modules:/opt/magic_mirror/modules
      - ../mounts/css:/opt/magic_mirror/css
      - /tmp/.X11-unix:/tmp/.X11-unix
      - /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket
    devices:
      - /dev/vchiq
      - /dev/gpiomem
    environment:
      DISPLAY: unix:0.0
    network_mode: host
    shm_size: "128mb"
    restart: unless-stopped
```

After restarting the container our PIR-Sensor should now work, you should see the countdown in the upper right corner.
You can interrupt the countdown by waking the sensor up. After 20 sec. without motion the screen should go off, you can wake up the screen with the sensor.

One ugly thing is now left because in my setup MagicMirror is not running in fullscreen anymore. This is related to the `xrandr` calls which are activating the monitor. As solution I found only a workaround, put the following `electronOptions` into your `config.js` file

```javascript
let config = {
  electronOptions: {
    width: 1920,
    height: 1080,
    alwaysOnTop: true,
  },
  address: "0.0.0.0",
  ...
```

where the `width` and `height` values should match with your screen resolution. If someone has a better solution for the fullscreen problem please let me know.

## Debugging

Start the container and login with `docker exec -it mm bash`.

Test if you can activate/deactivate the monitor by running:

- deactivate: `xrandr --output HDMI-1 --off`
- activate: `xrandr --output HDMI-1 --rotate normal --auto`

Test if your PIR-Sensor is working by running:

`python3 -u modules/MMM-PIR-Sensor-Lite/pir.py 23` where `23` is the used GPIO pin.

Output should look like

```bash
PIR_START
USER_PRESENCE
USER_PRESENCE
```

where every line `USER_PRESENCE` represents a motion detection.