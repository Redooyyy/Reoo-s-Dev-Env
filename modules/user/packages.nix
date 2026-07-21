{ config, pkgs, antigravity-nix, claude-code-nix, ... }:
let
  # 9router - CLI proxy router for AI services
  # Tarball already bundles app/node_modules — no npm network needed at build time.
  # Hash: sha512 SRI from npm registry integrity field.
  ninerouter-src = pkgs.fetchurl {
    url  = "https://registry.npmjs.org/9router/-/9router-0.5.30.tgz";
    hash = "sha512-1JsqzRuawrS6b4Fqw15/vhIWjH179ehGQXuvQiTnvPksXG8jbtS26lVyBOy6VXkRVZC3WRWpyhDVNQy2DOgYlw==";
  };

  ninerouter = pkgs.buildNpmPackage {
    pname = "9router";
    version = "0.5.30";
    src = ninerouter-src;

npmDepsHash = "sha256-hOE56M+AmjHCbaungOMTnvHghbsdf/QZFLXFU8w7kBM=";
    dontNpmBuild = true;

    postPatch = ''
      cp ${./9router-package-lock.json} package-lock.json
    '';

    postInstall = ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.nodejs_22}/bin/node $out/bin/9router \
        --add-flags "$out/lib/node_modules/9router/cli.js"
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
