{ self, inputs, ... }: {
  flake.nixosModules.userCollin = { lib, config, pkgs, ... }:
{
  users.users.collin = {
    isNormalUser = true;
    initialPassword = "12345";
    description = "Collin Harcarik";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable sudo privileges
  };
};

}
