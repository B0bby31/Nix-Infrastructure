{ self, inputs, ... }: {
  flake.modules.nixos.dankGreeter = { lib, ... }: {
    imports = [
      inputs.dms.nixosModules.greeter
    ];

    programs.dank-material-shell.greeter = {
      enable = true;
      compositor.name = "niri";
      compositor.customConfig = ''
      hotkey-overlay {
        skip-at-startup
      }
      environment {
        DMS_RUN_GREETER "1"
      }
      debug {
        render-drm-device "/dev/dri/gpuApple1"
      }
      '';
      configHome = "/home/collin"; # Well this is kinda unfortunate
    };
  };
}
