{ ... }: {
  home.stateVersion = "25.05";
  modules = {
    programs = {
      browser.enable = true;
    };
    terminal = {
      git.enable = true;
      neovim.enable = true;
      silicon.enable = true;
      shell.enable = true;
      wezterm.enable = true;
    };
  };
};
