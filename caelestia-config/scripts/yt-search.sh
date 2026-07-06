#!/usr/bin/env bash

# Ask for query
read -p "YouTube Search> " QUERY
if [ -z "$QUERY" ]; then exit; fi

echo "Searching YouTube for '$QUERY'..."

# Create a FIFO (named pipe) to prevent bash from waiting for yt-dlp
rm -f /tmp/yt-fifo /tmp/yt-selection.txt
mkfifo /tmp/yt-fifo

# Run yt-dlp in the background writing to the FIFO
yt-dlp "ytsearch20:$QUERY" --print "%(title)s | %(uploader)s (%(id)s)" 2>/dev/null > /tmp/yt-fifo &
YTPID=$!

# Run fzf reading from the FIFO
fzf --prompt="YouTube> " --border=rounded --color=bg+:-1,bg:-1,border:#cc3333,prompt:#cc3333,pointer:#cc3333 < /tmp/yt-fifo > /tmp/yt-selection.txt

# Immediately kill yt-dlp so it stops downloading search results!
kill -9 $YTPID 2>/dev/null
rm -f /tmp/yt-fifo

SELECTION=$(cat /tmp/yt-selection.txt 2>/dev/null)

if [ -z "$SELECTION" ]; then exit; fi

# Extract ID using regex
if [[ "$SELECTION" =~ \(([a-zA-Z0-9_-]{11})\)$ ]]; then
    ID="${BASH_REMATCH[1]}"
    echo "Selected ID: $ID"
    # Pass the ID to our fish `yt` command!
    fish -c "source ~/.config/cli-music/music.fish; yt $ID"
fi
