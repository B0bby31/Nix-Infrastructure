{ self, inputs, ... }: {

  flake.modules.nixos.niri = { pkgs, lib, ... }: {

    nixpkgs.overlays = [ inputs.niri.overlays.niri ];

    imports = [
      inputs.niri.nixosModules.niri
    ];

    niri-flake.cache.enable = false;

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;

    };
    systemd.user.services.niri-flake-polkit.enable = false;

  };

  # Home manager config for different users/systems
  flake.modules.homeManager.niriMacbook = { pkgs, lib, ... }: (import ./homeMacbook.nix { inherit inputs pkgs lib; });


}
