{ self, inputs, ... }: {
  flake.modules.nixos.dankShell = { lib, ... }: {
    imports = [
      inputs.dms.nixosModules.dank-material-shell
    ];
    programs.dank-material-shell = {
      enable = true;
      enableSystemMonitoring = true;
      enableVPN = true;                  # VPN management widget
      enableDynamicTheming = false;       # Wallpaper-based theming (matugen)
      enableAudioWavelength = true;      # Audio visualizer (cava)
      enableCalendarEvents = true;       # Calendar integration (khal)
      enableClipboardPaste = true;       # Pasting items from the clipboard (wtype)
    };
  };
  flake.modules.homeManager.dankShellMacbook = { pkgs, lib, ... }: (import ./homeMacbook.nix { inherit inputs pkgs lib; });
} 
