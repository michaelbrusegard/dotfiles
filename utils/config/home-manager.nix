{ pkgs, specialArgs, username, catppuccin, ... }:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      imports = [
        catppuccin.homeManagerModules.catppuccin
        ../../modules
        ../../users/${username}
      ];
    };
    extraSpecialArgs = pkgs.lib.mkForce specialArgs;
  };
}
