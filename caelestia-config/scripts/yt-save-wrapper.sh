#!/usr/bin/env bash
ACTIVE_TITLE=$(hyprctl activewindow -j | jq -r '.title')

if [[ "$ACTIVE_TITLE" == *"rmpc"* ]]; then
    foot --app-id yt-floating fish -i -c yt-save &
else
    hyprctl keyword unbind "CTRL, S"
    wtype -M ctrl -k s -m ctrl
    sleep 0.1
    hyprctl keyword bind "CTRL, S, exec, /home/reo/nixos-config/caelestia-config/scripts/yt-save-wrapper.sh"
fi
