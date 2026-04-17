{ inputs, lib, pkgs, ... }: {
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
  ];
  programs.dank-material-shell = {
    enable = true;
    niri = {
      enableSpawn = true;      # Auto-start DMS with niri, if enabled

      includes = {
        filesToInclude = [
          "alttab"                 
          "binds"
          "colors"
          "layout"
          "outputs"
          "wpblur"
          "windowrules"
        ];
      };
    };
    settings = builtins.fromJSON (builtins.readFile ./dank.json);
  };
}
