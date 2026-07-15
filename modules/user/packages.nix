{ config, pkgs, antigravity-nix, ... }:
{
  home.packages = with pkgs; [
    android-studio
    jetbrains.idea
    vscodium
    zed-editor
    rustup
    flutter
    dbeaver-bin
    mysql-workbench
    google-chrome
    chromium
    obs-studio
    gpu-screen-recorder
    obsidian
    openboard
    libreoffice-fresh
    dunst
    nemo
    haruna
    tree
    tree-sitter
    papirus-icon-theme
    adw-gtk3
    # Antigravity IDE (via community Nix flake, auto-updated 3x/week)
    antigravity-nix.packages.${pkgs.stdenv.system}.google-antigravity-ide
    bibata-cursors
    nwg-look
    tumbler
    ffmpegthumbnailer
    webp-pixbuf-loader
    poppler_gi
    qt6.qtsvg
    qt6.qtwayland
    awww
    imagemagick
    
    # Engineering / Development Tools
    gcc           # Includes g++
    gnumake
    cmake
    ninja
    pkg-config
    jdk           # Java Development Kit
    python3       # Python
    nodejs_22     # Node.js
    go            # Go compiler
    fzf           # Command-line fuzzy finder
    firebase-tools # Firebase CLI
  ];
}
