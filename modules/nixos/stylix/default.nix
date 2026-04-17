{ self, inputs, ... }: {
  flake.modules.nixos.stylix = { lib, pkgs, ... }: {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
    stylix.enable = true;
    stylix.base16Scheme = ./tokyo-night-dark.yaml;
    stylix.image = ./geisha_original.png;
    stylix.polarity = "dark";
    

 
    stylix.fonts = {
      monospace = {
      };
      sansSerif = {
      };
      serif = {
      };
    };

    stylix.opacity = {
      applications = 0.8;
      terminal = 0.8;
      desktop = 0.8;
      popups = 1.0;
    };

  };

  # Home manager config for different users/systems
  flake.modules.homeManager.stylixMacbook = { pkgs, lib, ... }: (import ./homeMacbook.nix { inherit pkgs lib; });
}
