{ config, pkgs, system, username, hostName, sops-nix, catppuccin, nur, secrets, isDarwin, ... }:
{
  imports = [
    sops-nix.nixosModules.sops
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
    hashedPasswordFile = config.secrets."users/${username}/hashedPassword".path;
  };
  sops = {
    age.keyFile = if isDarwin 
      then "/Users/${username}/.config/sops/age/keys.txt"
      else "/home/${username}/.config/sops/age/keys.txt";
    defaultSopsFile = "${builtins.toString secrets}/secrets.yaml";
    secrets = {
      "users/${username}/hashedPassword" = {
        neededForUsers = true;
      };
    };
  };
  programs.zsh.enable = true;
}
