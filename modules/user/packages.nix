{ config, pkgs, antigravity-nix, claude-code-nix, ... }:
let
  # 9router - CLI proxy router for AI services
  # Install from npm registry since it's not in nixpkgs
  ninerouter = pkgs.stdenv.mkDerivation {
    pname = "9router";
    version = "1.0.0";
    dontUnpack = true;
    nativeBuildInputs = [ pkgs.nodejs_22 ];
    installPhase = ''
      export HOME=$TMPDIR
      ${pkgs.nodejs_22}/bin/npm install -g --prefix $out 9router
    '';
    meta = with pkgs.lib; {
      description = "CLI proxy router for AI services";
      license = licenses.mit;
    };
  };
in
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
    # Claude Code CLI
    claude-code-nix.packages.${pkgs.stdenv.system}.default
    # 9router proxy for AI services
    ninerouter
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
