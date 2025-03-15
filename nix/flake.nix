{
  inputs = import ./inputs.nix;

  outputs = { self, nixpkgs, ... }@inputs:
    let
      utils = import ./utils inputs;

      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      nixosConfigurations = {
        desktop = utils.mkSystem {
          system = "x86_64-linux";
          username = "michaelbrusegard";
          hostname = "desktop";
        };

        wsl = utils.mkSystem {
          system = "x86_64-linux";
          username = "michaelbrusegard";
          hostname = "wsl";
        };

        espresso = utils.mkSystem {
          system = "x86_64-linux";
          username = "sysadmin";
          hostname = "espresso";
        };

        leggero = utils.mkSystem {
          system = "aarch64-linux";
          username = "sysadmin";
          hostname = "leggero";
        };
      };

      darwinConfigurations."*" = utils.mkSystem {
        system = builtins.currentSystem or "aarch64-darwin";
        username = "michaelbrusegard";
        hostname = builtins.substring 0 (-1) (builtins.readFile (builtins.toFile "hostname" (
          builtins.unsafeDiscardStringContext (builtins.readFile (builtins.toFile "get-hostname"
            "PATH=/usr/bin:/usr/sbin:$PATH; scutil --get LocalHostName")))));
      };
    };
};
