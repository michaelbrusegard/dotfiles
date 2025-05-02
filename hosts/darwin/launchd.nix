{ pkgs, userName, ... }: {
  launchd = {
    daemons = {
      kanata = {
        command = "${pkgs.kanata}/bin/kanata";
        serviceConfig = {
          ProgramArguments = [
            "${pkgs.kanata}/bin/kanata"
            "-c"
            "${./kanata.kbd}"
            "--port"
            "10000"
            "--debug"
          ];
          RunAtLoad = true;
          KeepAlive = true;
          StandardErrorPath = "/Library/Logs/Kanata/kanata.err.log";
          StandardOutPath = "/Library/Logs/Kanata/kanata.out.log";
        };
      };
      karabiner-vhiddaemon = {
        command = "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
        serviceConfig = {
          ProgramArguments = [
            "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"
          ];
          RunAtLoad = true;
          KeepAlive = true;
        };
      };
      karabiner-vhidmanager = {
        command = "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate";
        serviceConfig = {
          ProgramArguments = [
            "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"
            "activate"
          ];
          RunAtLoad = true;
        };
      };
    };
    user.agents = {
      raycast = {
        command = "open -a Raycast";
        serviceConfig = {
          UserName = userName;
          RunAtLoad = true;
          KeepAlive = false;
          ProcessType = "Interactive";
        };
      };
      ice = {
        command = "open -a Ice";
        serviceConfig = {
          UserName = userName;
          RunAtLoad = true;
          KeepAlive = false;
          ProcessType = "Interactive";
        };
      };
      podman = {
        command = "${pkgs.podman}/bin/podman machine start";
        serviceConfig = {
          UserName = userName;
          RunAtLoad = true;
          KeepAlive = true;
          ProcessType = "Background";
        };
      };
    };
  };
}
