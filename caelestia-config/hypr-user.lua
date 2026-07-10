-- YouTube Fuzzy Search Floating Terminal
hl.window_rule({ match = { class = "yt-floating" }, float = true, center = true, size = "800 500" })
hl.bind("CTRL + Y", hl.dsp.exec_cmd("/home/reo/.config/caelestia/scripts/yt-wrapper.sh"))

-- YouTube Autoplay Daemon (Now runs via Systemd!)

-- Save currently playing YouTube song to Library (Download)
hl.bind("CTRL + S", hl.dsp.exec_cmd("/home/reo/nixos-config/caelestia-config/scripts/yt-save-wrapper.sh"))
