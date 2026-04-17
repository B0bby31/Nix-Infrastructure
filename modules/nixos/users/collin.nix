{ self, inputs, ... }: {
  flake.modules.nixos.userCollin = { lib, config, pkgs, ... }:
{
  users.users.collin = {
    isNormalUser = true;
    initialPassword = "12345";
    description = "Collin Harcarik";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "render" "pipewire" "audio" ]; # Enable sudo privileges
  };
};

}
