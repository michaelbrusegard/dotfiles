{ pkgs, username, home-manager, ... }:
{
  imports = [
    home-manager.nixosModules.default
  ];
  nix.settings = {
    allowed-users = ["@wheel"];
    trusted-users = ["@wheel"];
  };
  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "wheel" ];
  };
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "nb_NO.UTF-8";
      LC_IDENTIFICATION = "nb_NO.UTF-8";
      LC_MEASUREMENT = "nb_NO.UTF-8";
      LC_MONETARY = "nb_NO.UTF-8";
      LC_NAME = "nb_NO.UTF-8";
      LC_NUMERIC = "nb_NO.UTF-8";
      LC_PAPER = "nb_NO.UTF-8";
      LC_TELEPHONE = "nb_NO.UTF-8";
      LC_TIME = "nb_NO.UTF-8";
    };
  };
  networking = {
    enableIPv6 = true;
    firewall.enable = true;
  };
  boot = {
    initrd.systemd.enable = true;
    tmp.cleanOnBoot = true;
  };
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
      execWheelOnly = true;
    };
    protectKernelImage = true;
    rtkit.enable = true;
    pam = {
      loginLimits = [
        { domain = "@wheel"; type = "hard"; item = "nofile"; value = "524288"; }
        { domain = "@wheel"; type = "soft"; item = "nofile"; value = "524288"; }
      ];
      services.login.requireWheel = true;
    };
  };
}
