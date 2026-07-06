#!/usr/bin/env bash

echo "Starting YouTube Autoplay Daemon..."

while true; do
    # Wait for MPD player state to change
    mpc idle player >/dev/null

    # Check the queue length and current position
    TOTAL_SONGS=$(mpc playlist | wc -l)
    CURRENT_SONG=$(mpc status | grep -o '\[.*\] #[0-9]*/[0-9]*' | grep -o '#[0-9]*/[0-9]*' | head -n1 | cut -d'#' -f2 | cut -d/ -f1)

    # Make sure we're actually playing something
    if [ -z "$CURRENT_SONG" ] || [ -z "$TOTAL_SONGS" ]; then
        continue
    fi

    REMAINING=$((TOTAL_SONGS - CURRENT_SONG))

    # If there is 2 or fewer songs left in the queue after the current one
    if [ "$REMAINING" -le 2 ]; then
        CURRENT_FILE=$(mpc current -f %file%)
        
        # Check if the playing song is a locally cached YouTube stream
        if [[ "$CURRENT_FILE" =~ \.YT-StreamCache/([a-zA-Z0-9_-]{11})/[a-zA-Z0-9_-]{11}\.m4a ]]; then
            YT_ID="${BASH_REMATCH[1]}"
            echo "Queue is running low. Fetching Autoplay mix for $YT_ID..."
            
            # Fetch the next 5 songs from the YouTube Mix
            NEXT_SONGS=$(yt-dlp --flat-playlist --print id "https://www.youtube.com/watch?v=$YT_ID&list=RD$YT_ID" --playlist-items 2-6)
            
            for SONG_ID in $NEXT_SONGS; do
                echo "Appending $SONG_ID to queue..."
                # Fetch and append the song sequentially to avoid YouTube HTTP 429 Bans
                fish -c "source ~/.config/cli-music/music.fish; yt --append $SONG_ID" >/dev/null 2>&1
            done
        fi
    fi
done
