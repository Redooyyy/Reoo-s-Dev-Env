import sys, urllib.request, json, urllib.parse, re, os, difflib

artist_str = sys.argv[1]
title_str = sys.argv[2]
safe_filename = sys.argv[3]
try:
    actual_duration = float(sys.argv[4])
except:
    actual_duration = None

lyrics_dir = os.path.expanduser("~/Music/lyrics")

NOISE_KEYWORDS = r'(?i)\b(lofi|lo-fi|remix|official|video|audio|lyrics|mv|slowed|reverb|nightcore|cover|full|hd|hq|4k|bangla|bengali|song|গান|নাটক|natok|feat|ft|music|band|version|unplugged|acoustic|live)\b'
NOISE_SONG_ONLY = r'(?i)\b(lofi|lo-fi|remix|official|video|audio|lyrics|mv|slowed|reverb|nightcore|cover|full|hd|hq|4k)\b'

def is_noise_segment(text):
    cleaned = re.sub(NOISE_KEYWORDS, '', text)
    cleaned = re.sub(r'[^a-zA-Z\u0980-\u09FF]', '', cleaned)
    return len(cleaned) < 3

def parse_yt_title(title_str, artist_str):
    parts = [p.strip() for p in title_str.split('|')]

    if len(parts) >= 2:
        # clean song title
        song = re.sub(NOISE_SONG_ONLY, '', parts[0])
        song = re.sub(r'\s*[-–]\s*\S.*$', '', song)
        song = song.strip(' -()')

        # find artist
        artist = artist_str
        for p in reversed(parts[1:]):
            clean = re.sub(r'\s*\(.*?\)', '', p).strip()
            clean = re.sub(r'\s*[-–]\s*\S.*$', '', clean).strip()
            if is_noise_segment(clean):
                continue
            if not re.search(r'[a-zA-Z]', clean):
                continue
            artist = clean
            break

    elif ' - ' in title_str:
        dash_parts = [p.strip() for p in title_str.split(' - ', 1)]
        prefix = dash_parts[0]
        rest   = dash_parts[1] if len(dash_parts) > 1 else ''

        rest_clean = re.sub(r'\s*\(.*?\)', '', rest).strip()
        rest_clean = re.sub(NOISE_SONG_ONLY, '', rest_clean).strip()

        if is_noise_segment(prefix):
            song   = rest_clean
            artist = artist_str
        else:
            song   = rest_clean
            artist = prefix.strip()

    else:
        song = re.sub(r'(?i)(\[.*?\]|\(.*?\)|lofi|remix|official|video|audio|mv|cover)', ' ', title_str)
        song = re.sub(r'\s*[-–]\s*\S.*$', '', song).strip()
        artist = artist_str

    return song.strip(), artist.strip()

def clean_ascii(text):
    text = re.sub(r'[^a-zA-Z0-9 ]', ' ', text)
    return ' '.join(text.split())

def scale_timestamp(match, ratio):
    minutes = int(match.group(1))
    seconds = float(match.group(2))
    total_seconds = minutes * 60 + seconds
    scaled = total_seconds * ratio
    new_minutes = int(scaled // 60)
    new_seconds = scaled % 60
    return f"[{new_minutes:02d}:{new_seconds:05.2f}]"

def search_lrclib(query):
    if not query: return None
    url = f"https://lrclib.net/api/search?q={urllib.parse.quote(query)}"
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    try:
        with urllib.request.urlopen(req, timeout=30) as response:
            return json.loads(response.read().decode())
    except:
        return None

def verify_match(item, song, artist):
    track = item.get('trackName', '').lower()
    s_clean = clean_ascii(song).lower().strip()
    if not track or not s_clean:
        return False
    if track in s_clean or s_clean in track:
        return True
    if difflib.SequenceMatcher(None, track, s_clean).ratio() > 0.6:
        return True
    return False

parsed_song, parsed_artist = parse_yt_title(title_str, artist_str)

queries = [
    f"{parsed_song} {parsed_artist}",
    parsed_song,
    f"{clean_ascii(parsed_song)} {clean_ascii(parsed_artist)}",
    clean_ascii(parsed_song),
    clean_ascii(artist_str),
]

for q in queries:
    q = q.strip()
    if not q:
        continue
    data = search_lrclib(q)
    if not data:
        continue

    try:
        for item in data:
            if item.get('syncedLyrics') and verify_match(item, parsed_song, parsed_artist):
                lyrics = item['syncedLyrics']
                original_duration = item.get('duration')

                # auto-sync slowed tracks
                if actual_duration and original_duration:
                    ratio = actual_duration / float(original_duration)
                    if abs(1.0 - ratio) > 0.03:
                        lyrics = re.sub(
                            r'\[(\d{2}):(\d{2}\.\d{2,3})\]',
                            lambda m: scale_timestamp(m, ratio),
                            lyrics
                        )

                os.makedirs(lyrics_dir, exist_ok=True)
                lrc_path = os.path.join(lyrics_dir, f"{safe_filename}.lrc")
                with open(lrc_path, "w") as f:
                    f.write(lyrics)
                print(f"Saved lyrics to {lrc_path}")
                sys.exit(0)
    except Exception as e:
        import traceback
        with open('/tmp/yt-lyrics-error.log', 'w') as f:
            traceback.print_exc(file=f)
        sys.exit(1)

sys.exit(1)
