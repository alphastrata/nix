#!/bin/bash

# Run tailscale status and capture the output
status_output=$(tailscale status)

# Function to extract status, IP, and name
extract_info() {
    local device_name=$1
    local device_info=$(echo "$status_output" | grep "$device_name")

    # Check if the device is online or active
    if echo "$device_info" | grep -q -e "active" -e "online"; then
        # If online, extract and show the IP
        local ip=$(echo "$device_info" | awk '{print $1}')
        echo "$device_name@$ip"
    else
        echo "$device_name@OFFLINE"
    fi
}

# Extract info for each device
framebox_info=$(extract_info "framebox")
smackmacs_mbp_info=$(extract_info "smakmacs-mbp")

# Output the information
echo "$framebox_info || $smackmacs_mbp_info"
