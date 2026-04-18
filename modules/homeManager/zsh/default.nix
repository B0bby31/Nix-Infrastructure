{
  flake.modules.homeManager.zsh = { lib, ... }: {

    # We also enable starship, cause what is the point of zsh without it
    programs.starship = {
      enable = true;
      enableZshIntegration = true;     
    };

    programs.fastfetch = {
      enable = true;
    };

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
    
      initContent = let
        zshConfigEarlyInit = lib.mkOrder 500 ''
          fastfetch
        '';
      in
      lib.mkMerge [ zshConfigEarlyInit ];

      shellAliases = { # TODO: add more things
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
      };
      history.size = 10000;
    };
    
  };
}
