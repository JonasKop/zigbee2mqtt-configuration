FROM docker.io/koenkk/zigbee2mqtt:1.34.0

RUN addgroup zigbee2mqtt -g 1000 && \
    adduser zigbee2mqtt -u 1000 -G zigbee2mqtt -D -H && \
    chown -R zigbee2mqtt:zigbee2mqtt /app

USER zigbee2mqtt
