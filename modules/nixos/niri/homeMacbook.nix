{ inputs, pkgs, lib, ... }: {
  programs.niri = {

      settings = {
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input.keyboard = {
          xkb = {
            layout = "us";
            variant = "mac_intl";
          };
        };
        input.touchpad = {
           natural-scroll = true;
           dwt = true;
        };
        gestures.hot-corners.enable = false;
	


        binds = {
          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action.spawn-sh = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn-sh = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action.spawn-sh = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };
          "XF86AudioMicMute" = {
            allow-when-locked = true;
            action.spawn-sh = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          };

          # Brightness keys
          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action.spawn-sh = "${lib.getExe pkgs.brightnessctl} -d apple-panel-bl set +4%";
          };
          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action.spawn-sh = "${lib.getExe pkgs.brightnessctl} -d apple-panel-bl set 4%-";
          };

          "Mod+T".action.spawn-sh = lib.getExe pkgs.alacritty;
          "Mod+B".action.spawn-sh = lib.getExe inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta;
          "Mod+Q".action.close-window = [ ];
        };
        debug = {
          # This depends on the symlink
          render-drm-device = "/dev/dri/gpuApple1";
        };
      };
  };

}
