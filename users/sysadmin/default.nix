{ ... }: {
  home.stateVersion = "25.05";
  modules = {
    cli.enable = true;
    git.enable = true;
    neovim.enable = true;
    shell.enable = true;
    wezterm.enable = true;
    yazi.enable = true;
  };
};
