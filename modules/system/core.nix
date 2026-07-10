{ config, pkgs, ... }:
{
  services.upower.enable = true;
  documentation.man.enable = false;
  nixpkgs.config.allowUnfree = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  boot.loader = {
    grub = {
      device = "nodev";
      enable = true;
      efiSupport = true;
    };
    efi.canTouchEfiVariables = true;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.xserver.xkb.layout = "us";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";
  
  # Enable SDDM Display Manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "caelestia";
    extraPackages = with pkgs; [
      kdePackages.qt5compat
      kdePackages.qtdeclarative
      kdePackages.qtsvg
    ];
  };

  # Unlock gnome-keyring on login so apps like Antigravity can save passwords
  security.pam.services.sddm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  
  services.displayManager.sessionPackages = [
    (pkgs.stdenv.mkDerivation {
      name = "caelestia-session";
      passthru.providedSessions = [ "caelestia" ];
      buildCommand = ''
        mkdir -p $out/share/wayland-sessions
        cat <<EOF > $out/share/wayland-sessions/caelestia.desktop
[Desktop Entry]
Name=Caelestia Hyprland
Comment=Caelestia Hyprland Session
Exec=start-hyprland
Type=Application
EOF
      '';
    })
  ];
  
  networking.networkmanager.enable = true;
  users.users.root.hashedPassword = "$6$rounds=4096$YwcWRjbQ1gnZcur1$PSpuyb0uyNg/fEBsZTIAxswpmKY0726ZGYCf/WKDaYYIl/AjMpHQ63F9mWPPWBq5QN1J9YRV58iL136HLHnl20";
  programs.fish.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libx11
      libxxf86vm
      libxext
      libxtst
      libxi
      libxrender
      libxcursor
      libxdamage
      libxcomposite
      libxrandr
      libxfixes
      glib
      gtk3
      cairo
      pango
      alsa-lib
      libGL
      freetype
      fontconfig
      dbus
    ];
  };
  time.timeZone = "Asia/Dhaka";
  swapDevices = [ { device = "/swapfile"; size = 4096; } ];
  users.users."reo" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    hashedPassword = "$6$rounds=4096$YBOcHNFXByTJ33Eo$YxomznGBdcXQqB1E6d4sTB6Ncy3kGxzaquPWYuougHiwz.5nYlG/VcuTlLh6kLKCyrogA2sFtZbtn.JX0kl27.";
    shell = pkgs.fish;
  };
  
  security.wrappers.intel_gpu_top = {
    owner = "root";
    group = "root";
    source = "${pkgs.intel-gpu-tools}/bin/intel_gpu_top";
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    initialScript = pkgs.writeText "mariadb-init.sql" ''
      CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY '20052005';
      ALTER USER 'root'@'localhost' IDENTIFIED BY '20052005';
      GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
      FLUSH PRIVILEGES;
    '';
  };

  system.stateVersion = "25.11";
}
