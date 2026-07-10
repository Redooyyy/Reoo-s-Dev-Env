#!/usr/bin/env bash
echo "Triggered yt-save-wrapper at $(date)" >> /tmp/yt-save.log

ACTIVE_TITLE=$(hyprctl activewindow -j | jq -r '.title')
ACTIVE_CLASS=$(hyprctl activewindow -j | jq -r '.class')
echo "Active title: $ACTIVE_TITLE | Class: $ACTIVE_CLASS" >> /tmp/yt-save.log

if [[ "$ACTIVE_TITLE" == *"rmpc"* ]] || [[ "$ACTIVE_CLASS" == *"rmpc"* ]]; then
    echo "Match found, launching yt-save" >> /tmp/yt-save.log
    notify-send "YouTube Save" "Saving current song from rmpc!"
    foot --app-id yt-floating fish -i -c yt-save &
else
    echo "No match, simulating key" >> /tmp/yt-save.log
    notify-send "YouTube Save" "Not in rmpc! Passing CTRL+S to $ACTIVE_CLASS"
    hyprctl keyword unbind "CTRL, S"
    wtype -M ctrl -k s -m ctrl
    sleep 0.1
    hyprctl keyword bind "CTRL, S, exec, /home/reo/nixos-config/caelestia-config/scripts/yt-save-wrapper.sh"
fi

