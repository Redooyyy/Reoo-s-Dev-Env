{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/core.nix
    ../../modules/system/desktop.nix
    ../../modules/system/packages.nix
  ];

  networking.hostName = "dedSec";
}
