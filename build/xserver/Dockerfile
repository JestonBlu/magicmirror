FROM alpine:latest

COPY entrypoint.sh .
COPY 99-vc4.conf /usr/share/X11/xorg.conf.d/

RUN set -e; \
    chmod +x entrypoint.sh; \
    apk add --no-cache xorg-server xf86-input-evdev xrandr bash;

ENV XRANDR_DELAY=5s

ENTRYPOINT ["/entrypoint.sh"]
