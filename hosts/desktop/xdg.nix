{ pkgs, ... }: {
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
      config = {
        common = {
          default = ["hyprland" "gtk"];
        };
      };
      xdgOpenUsePortal = true;
    };
  };
}
