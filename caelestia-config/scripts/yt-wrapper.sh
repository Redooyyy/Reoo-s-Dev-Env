#!/usr/bin/env bash
echo "Triggered yt-wrapper at $(date)" >> /tmp/yt-wrapper.log

ACTIVE_TITLE=$(hyprctl activewindow -j | jq -r '.title')
echo "Active title: $ACTIVE_TITLE" >> /tmp/yt-wrapper.log

if [[ "$ACTIVE_TITLE" == *"rmpc"* ]]; then
    echo "Match found, launching foot" >> /tmp/yt-wrapper.log
    foot --app-id yt-floating ~/.config/caelestia/scripts/yt-search.sh &
else
    echo "No match, simulating key" >> /tmp/yt-wrapper.log
    hyprctl keyword unbind "CTRL, Y"
    wtype -M ctrl -k y -m ctrl
    sleep 0.1
    hyprctl keyword bind "CTRL, Y, exec, /home/reo/.config/caelestia/scripts/yt-wrapper.sh"
fi
