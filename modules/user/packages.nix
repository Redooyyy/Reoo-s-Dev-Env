{ config, pkgs, ... }:
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
    # GUI & Theming
    (pkgs.buildFHSEnv {
      name = "antigravity";
      targetPkgs = pkgs: with pkgs; [
        glib nss nspr atk at-spi2-atk cups dbus libdrm gtk3 pango cairo gdk-pixbuf expat mesa alsa-lib systemd
        libX11 libXcomposite libXdamage libXext libXfixes libXrandr libXrender libXtst libXxf86vm libxcb libxshmfence
        libgbm libxkbcommon curl git gnupg libsecret gnome-keyring
      ];
      runScript = pkgs.writeShellScript "antigravity-wrapper" ''
        export GNOME_KEYRING_CONTROL=/run/user/$(id -u)/keyring
        export SSH_AUTH_SOCK=/run/user/$(id -u)/keyring/ssh
        exec /home/reo/.local/share/Antigravity-x64/antigravity --password-store=gnome-libsecret "$@"
      '';
    })
    (pkgs.makeDesktopItem {
      name = "antigravity";
      desktopName = "Antigravity";
      comment = "Google DeepMind Agentic Coding Assistant";
      exec = "antigravity";
      icon = "terminal";
      terminal = false;
      categories = [ "Development" "Utility" ];
      mimeTypes = [ "x-scheme-handler/antigravity" ];
    })
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
