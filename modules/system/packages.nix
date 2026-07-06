{ config, pkgs, ... }:
let
  caelestia-sddm-theme = pkgs.stdenv.mkDerivation {
    name = "sddm-caelestia-theme";
    src = pkgs.fetchFromGitHub {
      owner = "ItsABigIgloo";
      repo = "caelestia-sddm";
      rev = "e7a533b4213425ab61751c62909d4fc69441f243";
      sha256 = "0wqv40ib61nmj3wckmarkqa0fvl4qd7q1fr6p2nivs89b71bnd4g";
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes/caelestia
      cp -aR themes/minimalistV2/* $out/share/sddm/themes/caelestia/
      cp ${./reo.face} $out/share/sddm/themes/caelestia/assets/avatar.face.icon
      # Fix Qt6 compatibility: rename import module
      find $out/share/sddm/themes/caelestia -type f -name "*.qml" \
        -exec sed -i 's|import QtGraphicalEffects 1\.[0-9]*|import Qt5Compat.GraphicalEffects|g' {} +
      # Fix missing [SddmGreeterTheme] section header and set Qt6 greeter
      sed -i '1s/^/[SddmGreeterTheme]\nQtVersion=6\n/' $out/share/sddm/themes/caelestia/metadata.desktop
    '';
  };
in
{


  environment.systemPackages = with pkgs; [
    cava
    ffmpeg
    brave
    git
    kitty
    foot
    neovim
    lm_sensors
    acpi
    upower
    pciutils
    mesa-demos
    intel-gpu-tools
    eza
    zoxide
    direnv
    fastfetch
    btop
    micro
    thunar
    starship
    gnome-keyring
    polkit_gnome
    bluez
    pipewire
    wireplumber
    pavucontrol
    wl-clipboard
    cliphist
    curl
    trash-cli
    jq
    lazygit
    bat
    ripgrep
    ydotool
    hyprpicker
    xdg-user-dirs
    xdg-desktop-portal-gtk
    adw-gtk3
    papirus-icon-theme
    unzip
    zip
    plocate
    sof-firmware
    yazi
    gh
    yt-dlp
    fd
    fzf
    mpd
    rmpc
    mpc
    wtype
    ytfzf
    mpdris2
    caelestia-sddm-theme
  ];


}
