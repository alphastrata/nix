#!/bin/bash

# Get the JSON from the get_tailnet.sh script
json_output=$(./get_tailnet.sh)

# Parse the JSON to get the IP of the clicked device
# This is just a pseudocode representation; you'll need to replace it with actual JSON parsing logic.
device_ip=$(echo "$json_output" | jq -r '.[device].ip')

# Copy the IP to the clipboard using wl-copy
echo "$device_ip" | wl-copy
