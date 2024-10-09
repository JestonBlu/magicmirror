#!/bin/bash

(
  if [[ "$XRANDR_PARAMS" != "" ]]; then
    sleep $XRANDR_DELAY
    xrandr $XRANDR_PARAMS
  fi
) &

/usr/bin/X :0 -nolisten tcp -s 0 -dpms vt1
