{ self, inputs, ... }: {
  flake.nixosConfigurations.macbook = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.modules.nixos.macbookConfiguration
    ];
  };
}
