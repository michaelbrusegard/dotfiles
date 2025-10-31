{ config, lib, pkgs-unstable, pkgs, affinity, ... }:

let
  cfg = config.modules.gui;

  breaktimer = pkgs.appimageTools.wrapType2 {
    pname = "breaktimer";
    version = "2.0.1";
     src = pkgs.fetchurl {
       url = "https://github.com/tom-james-watson/breaktimer-app/releases/download/v2.0.1/BreakTimer.AppImage";
       hash = "sha256:1533b2de8073413c8a4ddc62852e546b5541e18971ad0324ea47a7369e214f36";
     };
  };
in {
  options.modules.gui.enable = lib.mkEnableOption "GUI applications";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs-unstable; [
      easyeffects
      breaktimer
      imv
      burpsuite
      element-desktop
      slack
      legcord
      obsidian
      protonmail-desktop
      proton-pass
      libreoffice-fresh
      transmission_4
      inkscape-with-extensions
      gimp3-with-plugins
      scribus
      affinity.packages.x86_64-linux.v3
      blender
      freecad-wayland
      orca-slicer
      pkgs.bambu-studio
      betaflight-configurator
      qgis
      notion
      davinci-resolve
    ];
  };
}
