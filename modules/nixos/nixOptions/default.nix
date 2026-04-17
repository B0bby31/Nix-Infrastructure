{ self, inputs, ... }: {
  flake.modules.nixos.nixOptions = { lib, ... }: {
    # collect garbage automatically, every week
    nix.gc.automatic = true;
    nix.gc.dates = "weekly";

    # deduplicate store files
    nix.settings.auto-optimise-store = true;

    # keep store blobs for old generations up to 30 days
    nix.gc.options = "--delete-older-than 30d";
  };
}
