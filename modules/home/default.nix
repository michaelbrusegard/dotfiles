{ lib, pkgs, hostName, isDarwin, ... }:
{
  home = {
    stateVersion = "25.05";
    pointerCursor = lib.mkIf (!isDarwin) {
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
    shellAliases = {
      rebuild = if isDarwin then
        "sudo darwin-rebuild switch --flake ~/Developer/dotfiles#${hostName}"
      else
        "sudo nixos-rebuild switch --flake ~/Developer/dotfiles#${hostName}";
      reload = "source ~/.zshrc";
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
