inputs@{ nixpkgs, catppuccin, darwin, home-manager, ... }:
{ system, username, hostname }:
let
  pkgs = nixpkgs.legacyPackages.${system};

  utils = import ../utils inputs;

  commonModules = [
    catppuccin.nixosModules.catppuccin
    ./config/common.nix
    ../hosts/${hostname}
    ./config/home-manager.nix
  ];

  commonArgs = {
    inherit system;
    specialArgs = {
      inherit pkgs system username hostname utils;
      inherit (inputs) nixpkgs nur darwin home-manager nixos-hardware apple-fonts catppuccin zen-browser;
    };
  };

  isDarwin = builtins.match ".*-darwin" system != null;

in
if isDarwin then
  darwin.lib.darwinSystem (commonArgs // {
    modules = [
      home-manager.darwinModules.default
      ./config/darwin.nix
    ] ++ commonModules;
  })
else
  nixpkgs.lib.nixosSystem (commonArgs // {
    modules = [
      home-manager.nixosModules.default
      ./config/nixos.nix
    ] ++ commonModules;
  });
