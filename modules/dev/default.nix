{ config, lib, pkgs, isDarwin, ... }:

let
  cfg = config.modules.dev;
in {
  options.modules.dev.enable = lib.mkEnableOption "Development tools configuration";

  config = lib.mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        enableZshIntegration = true;
        silent = true;
        nix-direnv.enable = true;
      };
      bun = {
        enable = true;
        enableGitIntegration = true;
      };
    };
    home = {
      packages = with pkgs; [
        # Misc
        podman-compose

        # Python
        uv
        python3

        # Go
        go

        # Node
        nodejs
        nodePackages.pnpm

        # Lua
        lua
        luarocks

        # C
        clang
        cmake
        lldb
      ];
      sessionVariables = {
        NODE_COMPILE_CACHE = "$HOME/.cache/nodejs-compile-cache";
      };
      activation = lib.mkIf isDarwin {
        initPodmanMachine = lib.hm.dag.entryAfter ["writeBoundary"] ''
          if ! ${pkgs.podman}/bin/podman machine inspect podman-machine-default >/dev/null 2>&1; then
            echo "Initializing default Podman machine..."
            $DRY_RUN_CMD ${pkgs.podman}/bin/podman machine init
          else
            echo "Default Podman machine already exists."
          fi
        '';
        storePodmanSocket = lib.hm.dag.entryAfter ["writeBoundary"] ''
          SOCKET_PATH=$(${pkgs.podman}/bin/podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')
          if [ -n "$SOCKET_PATH" ]; then
            echo "Storing Podman socket path..."
            $DRY_RUN_CMD mkdir -p $HOME/.config/podman
            echo "$SOCKET_PATH" > $HOME/.config/podman/socket_path
          else
            echo "Error: Could not determine Podman socket path. Is the machine running?"
          fi
        '';
      };
    };
  };
}
