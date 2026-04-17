{ self, inputs, ... }: {
  flake.modules.nixos.nautilus = { pkgs, ... }: {
    environment.systemPackages = [ 
      pkgs.nautilus
      pkgs.libheif 
      pkgs.libheif.out 
    ];

    # Additional service to make nautilus work nicely (see https://wiki.nixos.org/wiki/Nautilus)
    services.gvfs.enable = true;

    # This works in conjunction with a home manager module see wiki
    services.udisks2.enable = true;
    

    nixpkgs.overlays = [
  (final: prev: {
    nautilus = prev.nautilus.overrideAttrs (nprev: {
      buildInputs =
        nprev.buildInputs
        ++ (with pkgs.gst_all_1; [
          gst-plugins-good
          gst-plugins-bad
        ]);
    });
  })
];

    environment.pathsToLink = [ "share/thumbnailers" ];
  };
}
