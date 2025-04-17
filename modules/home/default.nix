{ lib, config, pkgs, hostName, isDarwin, ... }:
{
  home = {
    stateVersion = "25.05";
    pointerCursor = lib.mkIf (config.modules.gui.enable && !isDarwin) {
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
    shell.enableZshIntegration = true;
    shellAliases = {
      rebuild = if isDarwin then
        "sudo darwin-rebuild switch --flake ~/Developer/dotfiles#${hostName}"
      else
        "sudo nixos-rebuild switch --flake ~/Developer/dotfiles#${hostName}";
      update = "nix flake update --flake ~/Developer/dotfiles";
      update-secrets = "nix flake update secrets --flake ~/Developer/dotfiles";
      cleanup = "nix-collect-garbage -d && nix store optimise";
      reload = "source ~/.config/zsh/.zshrc";
      c = "clear";
      dl = "cd ~/Downloads";
      dt = "cd ~/Desktop";
      dc = "cd ~/Documents";
      dp = "cd ~/Developer";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      "-" = "cd -";
      f = "fuck";
      ls = "eza";
      cat = "bat";
      lzd = "lazygit";
    };
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/bin"
    ];
  };
}
