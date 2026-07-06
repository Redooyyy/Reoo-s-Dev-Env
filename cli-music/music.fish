# ==========================================
# CLI Music - Advanced Terminal Music Player
# ==========================================

# yt-dlp aliases
alias ytbest='yt-dlp -f "bestvideo+bestaudio/best" -o "~/Videos/%(title)s.%(ext)s"'
alias yt1080='yt-dlp -f "bestvideo[ext=mp4][height<=1080]+bestaudio[ext=m4a]/mp4" -o "~/Videos/%(title)s.%(ext)s"'
alias ytmp3='yt-dlp -x --audio-format mp3 -o "~/Music/%(title)s.%(ext)s"'
alias ytplaylist='yt-dlp -o "~/Videos/%(playlist_title)s/%(title)s.%(ext)s"'
alias igdl='yt-dlp -o "~/Videos/Instagram/%(title)s.%(ext)s"'

# YouTube to MPD Fuzzy Search & Autoplay logic
function yt -d "Fuzzy search YouTube and play in MPD"
    set append_mode 0
    if test "$argv[1]" = "--append"
        set append_mode 1
        set query $argv[2..-1]
    else
        set query $argv
    end
    
    if test -z "$query"
        read -p 'set_color red; echo -n "YouTube Search> "; set_color normal' query
    end

    if test -z "$query"
        return
    end

    # Check if the query is exactly an 11-character YouTube ID
    if string match -q -r '^[a-zA-Z0-9_-]{11}$' -- "$query"
        set video_id "$query"
        set youtube_url "https://www.youtube.com/watch?v=$video_id"
    else
        echo "🔍 Fast-Searching YouTube for '$query' (fetching 15 results, takes ~5s)..."
        # yt-dlp is vastly more reliable than ytfzf's built-in scrapers
        set search_results (yt-dlp "ytsearch15:$query" --print "%(title)s (%(uploader)s) ｜ %(id)s" 2>/dev/null)
        
        if test -z "$search_results"
            echo "❌ ERROR: No results found from YouTube! (Are you offline?)"
            return
        end
        
        # Pipe perfectly formatted results directly into fzf
        set selected (printf "%s\n" $search_results | fzf --prompt="YouTube Search> " --height=20 --layout=reverse --border --color=pointer:#2CF9ED,prompt:#2CF9ED)
        
        if test -z "$selected"
            echo "❌ Search cancelled."
            return
        end
        
        # Safely extract the 11-character video ID from the end of the selected line
        set video_id (string match -r '.* ｜ ([a-zA-Z0-9_-]{11})$' "$selected" | tail -n 1)
        
        if test -z "$video_id"
            echo "❌ ERROR: Could not extract YouTube ID from selection."
            return
        end
        
        set youtube_url "https://www.youtube.com/watch?v=$video_id"
    end
    
    echo "🎵 Fetching high-quality audio and metadata (takes ~2 seconds)..."
        set song_dir "$HOME/Music/.YT-StreamCache/$video_id"
        mkdir -p "$song_dir"
        
        set file_path "$song_dir/$video_id.m4a"
        yt-dlp -f bestaudio --extract-audio --audio-format m4a --embed-metadata --embed-thumbnail -o "$file_path" "$youtube_url"
        
        if test $status -ne 0
            echo "❌ Download failed!"
            return
        end
        
        # Extract cover art to cover.jpg inside this completely unique folder!
        # Because every song gets its own folder, there are ZERO hardcoding conflicts.
        ffmpeg -v quiet -y -i "$file_path" -an -vcodec mjpeg "$song_dir/cover.jpg" 2>/dev/null
        
        # Tell MPD to scan ONLY our tiny cache folder so it instantly finds the file
        mpc update --wait ".YT-StreamCache"
        
        if test $append_mode -eq 0
            # Clean up old queue and old cache to ensure we start totally fresh!
            mpc stop
            mpc clear
            # Find and delete all OTHER song directories in the cache
            find ~/Music/.YT-StreamCache -mindepth 1 -maxdepth 1 -type d ! -name "$video_id" -exec rm -rf {} + 2>/dev/null
        end
        
        # Add the beautifully tagged file to the queue!
        mpc add ".YT-StreamCache/$video_id/$video_id.m4a"
        
        # Automatically fetch perfectly synced lyrics BEFORE playing!
        set song_artist (ffprobe -v quiet -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$file_path")
        set song_title (ffprobe -v quiet -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$file_path")
        set song_duration (ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file_path")
        
        if test -z "$song_artist"; set song_artist "Unknown"; end
        if test -z "$song_title"; set song_title "Unknown"; end
        
        set safe_filename (string replace -a '/' '_' "$song_artist - $song_title")
        echo "$HOME/Music/lyrics/$safe_filename.lrc" >> ~/.cache/yt_lyrics_cache.txt
        rm -f ~/Music/lyrics/"$safe_filename.lrc" 2>/dev/null
        
        # Run our smart Python auto-fetcher asynchronously in the background!
        python3 ~/.config/cli-music/scripts/yt-lyrics-auto.py "$song_artist" "$song_title" "$safe_filename" "$song_duration" >/dev/null 2>&1 &
        
        if test $append_mode -eq 0
            mpc play
        end
        
end

# Save YouTube Song to Local Library
function yt-save -d "Download the currently playing YouTube song to Library"
    set current_file (mpc current -f %file%)
    set video_id (string match -r '\.YT-StreamCache/([a-zA-Z0-9_-]{11})/[a-zA-Z0-9_-]{11}\.m4a' "$current_file" | tail -n 1)

    if test -z "$video_id"
        echo "❌ The currently playing song is not a cached YouTube stream."
        echo "File: $current_file"
        sleep 3
        return
    end

    # Extract clean title and artist from MPD tags
    set title_str (mpc current -f %title%)
    set artist_str (mpc current -f %artist%)
    
    if test -z "$title_str"
        set title_str "Unknown Title"
    end
    if test -z "$artist_str"
        set artist_str "Unknown Artist"
    end

    set filename "$artist_str - $title_str.m4a"
    # Sanitize filename
    set filename (string replace -a '/' '_' "$filename")
    set dest_path "$HOME/Music/$filename"

    echo "💾 Saving to Library: $filename"
    
    set final_dir "$HOME/Music/$artist_str - $title_str"
    mkdir -p "$final_dir"
    set dest_path "$final_dir/$filename"
    
    # Instantly copy the perfectly tagged file from our cache to its own permanent folder!
    cp "$HOME/Music/.YT-StreamCache/$video_id/$video_id.m4a" "$dest_path"
    
    # Also save its unique cover art so it NEVER loses its banner!
    cp "$HOME/Music/.YT-StreamCache/$video_id/cover.jpg" "$final_dir/cover.jpg" 2>/dev/null
    
    echo "✅ Song perfectly saved to $dest_path!"
    
    # Update MPD so it immediately sees the saved file
    mpc update --wait "$artist_str - $title_str"
    
    sleep 2
end

function rmpc -d "Run rmpc and automatically clean up cache on exit"
    # Clean up ANY leftover cache from previous sessions before starting!
    rm -rf ~/Music/.YT-StreamCache 2>/dev/null; mkdir -p ~/Music/.YT-StreamCache
    mpc update --wait ".YT-StreamCache" 2>/dev/null
    
    if test -f ~/.cache/yt_lyrics_cache.txt
        while read -l lrc_file
            rm -f "$lrc_file" 2>/dev/null
        end < ~/.cache/yt_lyrics_cache.txt
        rm -f ~/.cache/yt_lyrics_cache.txt
    end
    
    # Run the actual rmpc binary
    command rmpc $argv
    
    # Clean up when quitting normally
    echo "🧹 Cleaning up YouTube cache..."
    mpc stop
    mpc clear
    rm -rf ~/Music/.YT-StreamCache 2>/dev/null; mkdir -p ~/Music/.YT-StreamCache
    mpc update --wait ".YT-StreamCache" 2>/dev/null
    
    if test -f ~/.cache/yt_lyrics_cache.txt
        while read -l lrc_file
            rm -f "$lrc_file" 2>/dev/null
        end < ~/.cache/yt_lyrics_cache.txt
        rm -f ~/.cache/yt_lyrics_cache.txt
    end
end
