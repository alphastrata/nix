#!/bin/bash

# Check if Helix is running
if pgrep -x "hx" > /dev/null; then
    # Helix is running, get the last line of the log file
    last_line=$(tail -n 1 ~/.cache/helix/helix.log)
else
    # Helix is not running, set a default message
    last_line="hx not running"
fi

# Extract the text within the square brackets
log_status=$(echo "$last_line" | grep -oP '\[\K[^\]]+')

# Construct the JSON output for Waybar
echo "HX:[$log_status]"
