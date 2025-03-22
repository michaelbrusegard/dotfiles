{ pkgs, username, home-manager, ... }:
{
  imports = [
    home-manager.darwinModules.default
  ];
  nix = {
    settings = {
      allowed-users = ["@admin"];
      trusted-users = ["@admin"];
    };
    linux-builder.enable = true;
  };
  networking = {
    computerName = hostname;
    localHostName = hostname;
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };
  users.users.${username} = {
    home = "/Users/${username}";
    extraGroups = [ "admin" ];
  };
  security = {
    pam.enableSudoTouchIdAuth = true;
  };
  power = {
    sleep = {
      allowSleepByPowerButton = false;
      computer = "never";
      hardDisk = "never";
      display = 20;
    };
    restartAfterFreeze = true;
    restartAfterPowerFailure = true;
  };
}
