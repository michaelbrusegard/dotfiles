{ pkgs, lib, lanzaboote, apple-fonts, system, ... }: {
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];
  boot = {
    kernelModules = [
      "kvm-amd"
      "nct6775"
    ];
    kernelParams = [
      "quiet"
      "loglevel=3"
    ];
    consoleLogLevel = 3;
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    plymouth = {
      enable = true;
      logo = pkgs.runCommand "empty.png" {} ''
        ${pkgs.graphicsmagick}/bin/gm convert -size 1x1 xc:transparent $out
      '';
      font = "${apple-fonts.packages.${system}.sf-pro}/share/fonts/truetype/SF-Pro.ttf";
      themePackages = [ pkgs.adi1090x-plymouth-themes ];
      theme = "lone";
    };
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      luks.devices = {
        "luks-c3fbdb7e-8668-43d3-ae74-1c8dd400f0d8".device = "/dev/disk/by-uuid/c3fbdb7e-8668-43d3-ae74-1c8dd400f0d8";
        "luks-3326ca76-4cad-48a9-9c88-6aadd59e63fa".device = "/dev/disk/by-uuid/3326ca76-4cad-48a9-9c88-6aadd59e63fa";
      };
    };
    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
  };
}
