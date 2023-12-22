#!/bin/bash

set -e

# Create temorary file
tempFile=$(mktemp)

# Run cleanup on exit
function cleanup {
  rm -f "$tempFile"
}
trap cleanup EXIT

# Copy zigbee2mqtt config file from kubernetes
kubectl cp -n zigbee2mqtt \
  zigbee2mqtt-0:/app/data/configuration.yaml \
  "${tempFile}"

# Fetch secrets
export MQTT_USERNAME=$(gcloud secrets versions access --secret=mosquittoUsername latest)
export MQTT_PASSWORD=$(gcloud secrets versions access --secret=mosquittoPassword latest)

# Update config file with secrets
yq -i '.mqtt.user = strenv(MQTT_USERNAME)' "${tempFile}"
yq -i '.mqtt.password = strenv(MQTT_PASSWORD)' "${tempFile}"

# Copy config file to zigbee2mqtt running in kubernetes
kubectl cp -n zigbee2mqtt \
  "${tempFile}" \
  zigbee2mqtt-0:/app/data/configuration.yaml
