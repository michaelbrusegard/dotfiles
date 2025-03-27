{ pkgs, system, username, hostName, secrets, catppuccin, nur, ... }:
{
  imports = [
    catppuccin.nixosModules.catppuccin
  ];
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      extra-experimental-features = [ "flakes" "nix-command" ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
  nixpkgs = {
    hostPlatform = system;
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
    overlays = [ nur.overlays.default ];
  };
  networking.hostName = hostName;
  time.timeZone = "Europe/Oslo";
  users.users.${username} = {
    name = username;
    shell = pkgs.zsh;
    hashedPassword = secrets.users.${username}.hashedPassword;
  };
  users.users.test = {
    isNormalUser = true;
    home = "/home/test";
    initialPassword = "test123";
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;  # Using bash instead of zsh for testing
  };
  programs.zsh.enable = true;
}
