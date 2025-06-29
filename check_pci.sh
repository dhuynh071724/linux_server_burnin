#!/bin/bash
for dev in /sys/bus/pci/devices/*; do
  name=$(basename "$dev")
  vendor=$(cat "$dev/vendor")
  device=$(cat "$dev/device")
  if [[ -f "$dev/current_link_speed" ]]; then
    speed=$(cat "$dev/current_link_speed")
    width=$(cat "$dev/current_link_width")
    echo "Device: $name ($vendor:$device)"
    echo "  Speed: $speed"
    echo "  Width: $width"
    echo
  fi
done