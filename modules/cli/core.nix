{ config, lib, pkgs, ... }:

let
  cfg = config.modules.cli.core;
in {
  options.modules.cli.core.enable = lib.mkEnableOption "Core CLI applications";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      coreutils
      gnused
      gnugrep
      gnumake
      curl
      wget
      file
      rsync
      fontconfig
      yq
      age
      sops
    ];
  };
}
