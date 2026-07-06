{ config, ... }:
{
  hjem.users.reo = {
    directory = "/home/reo";
    files = {
      ".config/hypr/hyprland.lua".source = ../../caelestia/hypr/hyprland.lua;
      ".config/hypr/variables.lua".source = ../../caelestia/hypr/variables.lua;
      ".config/hypr/hyprland/animations.lua".source = ../../caelestia/hypr/hyprland/animations.lua;
      ".config/hypr/hyprland/decoration.lua".source = ../../caelestia/hypr/hyprland/decoration.lua;
      ".config/hypr/hyprland/env.lua".source = ../../caelestia/hypr/hyprland/env.lua;
      ".config/hypr/hyprland/execs.lua".source = ../../caelestia/hypr/hyprland/execs.lua;
      ".config/hypr/hyprland/functions.lua".source = ../../caelestia/hypr/hyprland/functions.lua;
      ".config/hypr/hyprland/general.lua".source = ../../caelestia/hypr/hyprland/general.lua;
      ".config/hypr/hyprland/gestures.lua".source = ../../caelestia/hypr/hyprland/gestures.lua;
      ".config/hypr/hyprland/group.lua".source = ../../caelestia/hypr/hyprland/group.lua;
      ".config/hypr/hyprland/input.lua".source = ../../caelestia/hypr/hyprland/input.lua;
      ".config/hypr/hyprland/keybinds.lua".source = ../../caelestia/hypr/hyprland/keybinds.lua;
      ".config/hypr/hyprland/misc.lua".source = ../../caelestia/hypr/hyprland/misc.lua;
      ".config/hypr/hyprland/rules.lua".source = ../../caelestia/hypr/hyprland/rules.lua;
      
      ".config/cava/config".source = ../../cli-music/cava/config;
      ".config/cli-music/scripts/yt-lyrics-auto.py".source = ../../cli-music/scripts/yt-lyrics-auto.py;
      ".config/cli-music/music.fish".source = ../../cli-music/music.fish;

      ".config/fish".source = ../../caelestia/fish;
      ".config/foot".source = ../../caelestia/foot;
      ".config/fastfetch".source = ../../caelestia/fastfetch;
      ".config/btop".source = ../../caelestia/btop;
      ".config/micro".source = ../../caelestia/micro;
      ".config/Thunar".source = ../../caelestia/thunar;
      ".config/starship.toml".source = ../../caelestia/starship.toml;
      ".config/spicetify".source = ../../caelestia/spicetify;
      ".config/zed".source = ../../caelestia/zed;
      ".config/uwsm".source = ../../caelestia/uwsm;
      ".config/nvim".source = ../../nvim;
      
      # Additional unmanaged configs
      ".config/rmpc".source = ../../cli-music/rmpc;
      ".config/mpd/mpd.conf".source = ../../cli-music/mpd/mpd.conf;

      # VSCodium mappings
      ".config/VSCodium/User/settings.json".source = ../../caelestia/vscode/settings.json;
      ".config/VSCodium/User/keybindings.json".source = ../../caelestia/vscode/keybindings.json;
      ".config/codium-flags.conf".source = ../../caelestia/vscode/flags.conf;

      # Firefox mappings (assuming 'default' profile)
      ".mozilla/firefox/default/chrome/userChrome.css".source = ../../caelestia/firefox/userChrome.css;
      ".mozilla/firefox/default/user.js".source = ../../caelestia/firefox/user.js;
    };
  };
}
