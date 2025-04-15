{ config, lib, pkgs, ... }:

let
  cfg = config.modules.wayland;
  clipsync = pkgs.writeShellScriptBin "clipsync" {
    text = builtins.readFile ./bin/clipsync.sh;
    runtimeInputs = with pkgs; [
      wl-clipboard
      xclip
      clipnotify
    ];
  };
in {
  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./mako.nix
    ./rofi.nix
    # ./waybar.nix
  ];
  options.modules.wayland.enable = lib.mkEnableOption "Wayland configuration";

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      font.name = "SF Pro";
    };
    qt = {
      enable = true;
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
    services = { 
      cliphist.enable = true;
      playerctld.enable = true;
    };
    systemd.user.services.clipsync = {
      Unit = {
        After = ["graphical-session.target"];
        PartOf = "graphical-session.target";
      };
      Service = {
        ExecStart = "${clipsync}/bin/clipsync watch";
        ExecStop = "${clipsync}/bin/clipsync stop";
        Restart = "always";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
    home.packages = with pkgs; [
      hyprpicker
    ];
  };
}
