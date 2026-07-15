{ config, pkgs, lib, inputs, antigravity-nix, ... }:

let
  patchPapirus = pkgs.stdenv.mkDerivation {
    name = "${pkgs.papirus-icon-theme.name}-patch";
    src = pkgs.papirus-icon-theme;
    installPhase = ''
      mkdir -p $out/share/icons
      ln -s $src/share/icons/Papirus $out/share/icons/hicolor
    '';
  };
in
{
  home.stateVersion = "25.11";

  imports = [
    inputs.caelestia-shell.homeManagerModules.default
    inputs.zen-browser.homeModules.twilight
    ./packages.nix
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  programs.caelestia = {
    enable = true;
    cli.enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  services.mpdris2 = {
    enable = true;
    mpd.musicDirectory = "/home/reo/Music";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
    };
  };
  
  systemd.user.services.caelestia = {
    Service = {
      ExecStart = lib.mkForce "${pkgs.writeShellScript "caelestia-wrapper" ''
        export XDG_DATA_DIRS=$XDG_DATA_DIRS:${patchPapirus}/share:/run/current-system/sw/share
        export QT_PLUGIN_PATH=$QT_PLUGIN_PATH:${pkgs.qt6.qtsvg}/lib/qt-6/plugins:${pkgs.qt6.qtwayland}/lib/qt-6/plugins
        export QT_QPA_PLATFORMTHEME=gtk3
        
        ${config.programs.caelestia.package}/bin/caelestia-shell
      ''}";
    };
  };

  # Dynamically link the config at runtime to avoid hjem activation conflicts while remaining fully writable!
  systemd.user.services.caelestia-config-link = {
    Unit = {
      Description = "Link Caelestia Config to NixOS Repo";
      Before = [ "caelestia.service" ];
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/ln -sfn /home/reo/nixos-config/caelestia-config /home/reo/.config/caelestia";
    };
  };

}
