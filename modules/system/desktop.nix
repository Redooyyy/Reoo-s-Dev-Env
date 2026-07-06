{ config, pkgs, ... }:
{
  services.pipewire.enable = true;
  services.tumbler.enable = true;
  programs.hyprland.enable = true;
  
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    material-symbols
  ];
}
