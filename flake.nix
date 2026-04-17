{
  description = "Nixos config flake";

  inputs = {
    # Nixpkgs and home manager
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Apple related
    apple-silicon.url = "github:nix-community/nixos-apple-silicon";
    nixos-asahi-framebuffer-compression.url = "github:oliverbestmann/nixos-asahi-framebuffer-compression";
  
    # Impermanence
    impermanence.url = "github:nix-community/impermanence";
    impermanence.inputs.nixpkgs.follows = "";
    impermanence.inputs.home-manager.follows = "";

    # Niri compositor flake
    niri.url = "github:sodiboo/niri-flake";
    
    # Dendritic pattern
    flake-parts.url = "github:hercules-ci/flake-parts";
 
    # Dank material shell
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };    

    # Zen browser flake that allows declaritive zen config
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs = {
        # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # Add some additional prefs to Zen (may or may not switch to arkenfox)
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };

    # Add stylix
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake
    { inherit inputs; } {
      imports = [
        ./modules/hosts/macbook/default.nix
        ./modules/hosts/default.nix
        ./modules/nixos/default.nix
        ./modules/homeManager/default.nix
        inputs.flake-parts.flakeModules.modules
      ];
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    };
}
